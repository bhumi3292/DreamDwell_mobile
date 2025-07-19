import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_state.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String? _error;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserInfo();
    });
  }

  Future<void> _loadUserInfo() async {
    final profileState = context.read<ProfileViewModel>().state;
    
    debugPrint('BookingPage - Profile state loading: ${profileState.isLoading}');
    debugPrint('BookingPage - Profile state user: ${profileState.user?.email}');
    debugPrint('BookingPage - Profile state user role: ${profileState.user?.stakeholder}');
    
    // Wait for profile to be loaded
    if (profileState.isLoading) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      return;
    }
    
    final user = profileState.user;
    
    if (user != null) {
      debugPrint('BookingPage - Setting user role: ${user.stakeholder}');
              setState(() {
          _userRole = user.stakeholder;
        });
      await _fetchBookings();
    } else {
      debugPrint('BookingPage - No user found, showing login error');
      setState(() {
        _error = 'Please log in to view your bookings.';
        _isLoading = false;
      });
    }
  }

  Future<String?> _getToken() async {
    final hive = HiveService();
    return await hive.getToken();
  }

  Future<void> _fetchBookings() async {
    if (_userRole == null) {
      debugPrint('BookingPage - User role is null, cannot fetch bookings');
      return;
    }

    debugPrint('BookingPage - Fetching bookings for role: $_userRole');
    setState(() { _isLoading = true; _error = null; });

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        debugPrint('BookingPage - No token found');
        setState(() { 
          _error = 'Please log in to view your bookings.'; 
          _isLoading = false; 
        });
        return;
      }

      String endpoint;
      if (_userRole == 'Tenant') {
        endpoint = 'http://10.0.2.2:3001/api/calendar/tenant/bookings';
      } else if (_userRole == 'Landlord') {
        endpoint = 'http://10.0.2.2:3001/api/calendar/landlord/bookings';
      } else {
        debugPrint('BookingPage - Invalid user role: $_userRole');
        setState(() { 
          _error = 'Invalid user role.'; 
          _isLoading = false; 
        });
        return;
      }

      debugPrint('BookingPage - Making API call to: $endpoint');
      final response = await Dio().get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('BookingPage - API response status: ${response.statusCode}');
      debugPrint('BookingPage - API response data: ${response.data}');

      if (response.data['success']) {
        final bookings = List<Map<String, dynamic>>.from(response.data['bookings'] ?? []);
        debugPrint('BookingPage - Found ${bookings.length} bookings');
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      } else {
        debugPrint('BookingPage - API returned success: false');
        setState(() {
          _error = response.data['message'] ?? 'Failed to fetch bookings.';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('BookingPage - Error fetching bookings: $e');
      setState(() {
        _error = 'Failed to load bookings. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final token = await _getToken();
      if (token == null) return;

      await Dio().delete(
        'http://10.0.2.2:3001/api/calendar/bookings/$bookingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking cancelled successfully!'), backgroundColor: Colors.green),
        );
      }

      await _fetchBookings(); // Refresh the list
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel booking.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    final statusText = status == 'Confirmed' ? 'confirm' : status == 'Rejected' ? 'reject' : 'cancel';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$statusText Booking'),
        content: Text('Are you sure you want to $statusText this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes, $statusText'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final token = await _getToken();
      if (token == null) return;

      await Dio().put(
        'http://10.0.2.2:3001/api/calendar/bookings/$bookingId/status',
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking status updated to ${status.toLowerCase()}!'), backgroundColor: Colors.green),
        );
      }

      await _fetchBookings(); // Refresh the list
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update booking status.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'rejected':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade50;
      case 'confirmed':
        return Colors.green.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      case 'rejected':
        return Colors.grey.shade50;
      default:
        return Colors.blue.shade50;
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final property = booking['property'] ?? {};
    final tenant = booking['tenant'];
    final landlord = booking['landlord'];
    final status = booking['status'] ?? 'pending';
    final date = booking['date'] ?? '';
    final timeSlot = booking['timeSlot'] ?? '';
    final bookingId = booking['_id'] ?? '';

    // Get property image
    String? imageUrl;
    if (property['images'] != null && (property['images'] as List).isNotEmpty) {
      final imagePath = property['images'][0];
      imageUrl = ImageUrlHelper.constructImageUrl(imagePath);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property header with image
            Row(
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.home, color: Colors.grey, size: 24),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.home, color: Colors.grey, size: 24),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['title'] ?? 'Unknown Property',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003366),
                        ),
                      ),
                      if (property['location'] != null)
                        Text(
                          property['location'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Booking details
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.blue.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Date: ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(DateTime.parse(date)),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.blue.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      timeSlot,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                // Show tenant info for landlords
                if (_userRole == 'Landlord' && tenant != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.purple.shade500),
                      const SizedBox(width: 8),
                      Text(
                        'Booked by: ',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Expanded(
                        child: Text(
                          '${tenant['fullName'] ?? 'N/A'} (${tenant['email'] ?? 'N/A'})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],

                // Show landlord info for tenants
                if (_userRole == 'Tenant' && landlord != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.purple.shade500),
                      const SizedBox(width: 8),
                      Text(
                        'Property Owner: ',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Expanded(
                        child: Text(
                          '${landlord['fullName'] ?? 'N/A'} (${landlord['email'] ?? 'N/A'})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.info, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            if (_userRole == 'Tenant' && status.toLowerCase() == 'pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _cancelBooking(bookingId),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),

            // Landlord actions
            if (_userRole == 'Landlord' && status.toLowerCase() != 'cancelled' && status.toLowerCase() != 'rejected')
              Row(
                children: [
                  if (status.toLowerCase() != 'confirmed')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateBookingStatus(bookingId, 'Confirmed'),
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Confirm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  if (status.toLowerCase() != 'confirmed' && status.toLowerCase() != 'rejected') const SizedBox(width: 8),
                  if (status.toLowerCase() != 'rejected' && status.toLowerCase() != 'confirmed')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateBookingStatus(bookingId, 'Rejected'),
                        icon: const Icon(Icons.cancel, size: 16),
                        label: const Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  if ((status.toLowerCase() != 'rejected' && status.toLowerCase() != 'confirmed') || status.toLowerCase() == 'confirmed') const SizedBox(width: 8),
                  if (status.toLowerCase() != 'cancelled')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateBookingStatus(bookingId, 'Cancelled'),
                        icon: const Icon(Icons.block, size: 16),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to login success events
        BlocListener<LoginViewModel, LoginState>(
          listener: (context, loginState) {
            debugPrint('BookingPage - Login state: ${loginState.isSuccess}, shouldNavigate: ${loginState.shouldNavigateToHome}');
            
            // Only reload when login is successful and navigation is triggered
            if (loginState.isSuccess && loginState.shouldNavigateToHome && _userRole == null) {
              debugPrint('BookingPage - Login successful, reloading user info');
              _loadUserInfo();
            }
          },
        ),
        // Listen to profile state changes for logout
        BlocListener<ProfileViewModel, ProfileState>(
          listener: (context, profileState) {
            debugPrint('BookingPage - Profile state loading: ${profileState.isLoading}');
            debugPrint('BookingPage - Profile state user: ${profileState.user?.email}');
            debugPrint('BookingPage - Current user role: $_userRole');
            
            // Only handle logout events (user changes from not null to null)
            if (!profileState.isLoading && profileState.user == null && _userRole != null) {
              debugPrint('BookingPage - User logged out, clearing data');
              setState(() {
                _userRole = null;
                _bookings = [];
                _error = 'Please log in to view your bookings.';
                _isLoading = false;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            _userRole == 'Landlord' ? 'Your Property Bookings' : 'Your Scheduled Visits',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchBookings,
              tooltip: 'Refresh bookings',
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF003366)),
                      SizedBox(height: 16),
                      Text('Loading bookings...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchBookings,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _bookings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                _userRole == 'Landlord' 
                                    ? 'No bookings have been made for your properties yet.'
                                    : 'You have no scheduled visits.',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                              if (_userRole == 'Tenant') ...[
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF90CAF9)),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Ready to schedule a visit?',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003366),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Browse properties in the Explore section and book a visit to see them in person!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Navigate to explore page
                                          Navigator.pushNamed(context, '/home');
                                        },
                                        icon: const Icon(Icons.explore),
                                        label: const Text('Explore Properties'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF003366),
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchBookings,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _bookings.length,
                            itemBuilder: (context, index) => _buildBookingCard(_bookings[_bookings.length - 1 - index]),
                          ),
                        ),
        ),
        floatingActionButton: _userRole == 'Tenant' && _bookings.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  // Navigate to explore page
                  Navigator.pushNamed(context, '/home');
                },
                icon: const Icon(Icons.add),
                label: const Text('Book More'),
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
              )
            : null,
      ),
    );
  }
}