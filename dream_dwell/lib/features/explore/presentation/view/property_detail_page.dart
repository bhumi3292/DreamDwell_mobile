import 'package:flutter/material.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/booking/presentation/widgets/booking_modal.dart';
import 'package:dream_dwell/features/booking/presentation/widgets/landlord_manage_availability.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:dream_dwell/features/add_property/presentation/view/update_property_page.dart';

class PropertyDetailPage extends StatefulWidget {
  final ExplorePropertyEntity property;
  const PropertyDetailPage({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  int _currentImage = 0;



  @override
  Widget build(BuildContext context) {
    final images = widget.property.images ?? [];
    final allMedia = images; // Add videos if you want

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        title: const Text('Property Details'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 10,
            shadowColor: Colors.blueGrey.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image gallery
                  if (allMedia.isNotEmpty)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            ImageUrlHelper.constructImageUrl(allMedia[_currentImage]),
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (allMedia.length > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                allMedia.length,
                                (index) => GestureDetector(
                                  onTap: () => setState(() => _currentImage = index),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImage == index
                                          ? const Color(0xFF003366)
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  Text(
                    widget.property.title ?? '',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.property.location ?? '',
                    style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Rs. ${widget.property.price?.toStringAsFixed(0) ?? '-'}',
                      style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.king_bed, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Bedrooms: ${widget.property.bedrooms ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 18),
                      const Icon(Icons.bathtub, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Bathrooms: ${widget.property.bathrooms ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Category: ${widget.property.categoryName ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  const SizedBox(height: 10),
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF003366))),
                  const SizedBox(height: 6),
                  Text(widget.property.description ?? 'No description provided.', style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 18),
                  Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  const SizedBox(height: 10),
                  const Text('Landlord', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF003366))),
                  const SizedBox(height: 6),
                  // Check if landlord details are available
                  if (widget.property.landlordName != null || widget.property.landlordPhone != null || widget.property.landlordEmail != null) ...[
                    if (widget.property.landlordName != null)
                      Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF003366)),
                          const SizedBox(width: 4),
                          Text(
                            widget.property.landlordName!.startsWith('Landlord ID:') 
                              ? 'Landlord Reference' 
                              : widget.property.landlordName!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    if (widget.property.landlordName != null) const SizedBox(height: 4),
                    if (widget.property.landlordPhone != null)
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Color(0xFF003366)),
                          const SizedBox(width: 4),
                          Text(widget.property.landlordPhone!, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    if (widget.property.landlordPhone != null) const SizedBox(height: 4),
                    if (widget.property.landlordEmail != null)
                      Row(
                        children: [
                          const Icon(Icons.email, color: Color(0xFF003366)),
                          const SizedBox(width: 4),
                          Text(widget.property.landlordEmail!, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                  ] else ...[
                                         // Show message when landlord details are not available
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(8),
                         border: Border.all(color: Colors.grey[300]!),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                               const SizedBox(width: 8),
                               Expanded(
                                 child: Text(
                                   'Landlord contact information is not available for this property.',
                                   style: TextStyle(
                                     color: Colors.grey[600],
                                     fontSize: 14,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           const SizedBox(height: 8),
                           Text(
                             'You can use the "Book a Visit" button above to schedule a viewing, or contact the landlord through the booking system.',
                             style: TextStyle(
                               color: Colors.grey[500],
                               fontSize: 12,
                             ),
                           ),
                         ],
                       ),
                     ),
                  ],
                  const SizedBox(height: 24),
                  // Action buttons - Primary actions
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Column(
                      children: [
                        // Primary action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.calendar_today, size: 20),
                                label: const Text(
                                  'Book a Visit',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003366),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                ),
                                                                  onPressed: () {
                                    final profileState = context.read<ProfileViewModel>().state;
                                    final currentUser = profileState.user;
                                    debugPrint('Current userId: ${currentUser?.userId}, Property landlordId: ${widget.property.landlordId}');
                                    final isLandlord = currentUser != null &&
                                      (widget.property.landlordId == currentUser.userId);
                                    showDialog(
                                      context: context,
                                      builder: (context) => isLandlord
                                        ? LandlordManageAvailability(propertyId: widget.property.id ?? '')
                                        : BookingModal(
                                            propertyId: widget.property.id ?? '',
                                            propertyTitle: widget.property.title ?? '',
                                          ),
                                    );
                                  },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.phone, size: 20),
                                label: const Text(
                                  'Contact',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  // Add contact functionality here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Contact functionality coming soon!'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Show Update and Delete buttons for landlord only
                  Builder(
                    builder: (context) {
                      final profileState = context.read<ProfileViewModel>().state;
                      final currentUser = profileState.user;
                      final isLandlord = currentUser != null &&
                        (widget.property.landlordId == currentUser.userId);
                      if (!isLandlord) return const SizedBox.shrink();
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Property Management',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text(
                                        'Update Property',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[600],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdatePropertyPage(
                                              propertyId: widget.property.id ?? '',
                                              initialTitle: widget.property.title ?? '',
                                              initialLocation: widget.property.location ?? '',
                                              initialPrice: widget.property.price ?? 0.0,
                                              initialDescription: widget.property.description ?? '',
                                              initialBedrooms: widget.property.bedrooms ?? 0,
                                              initialBathrooms: widget.property.bathrooms ?? 0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text(
                                        'Delete Property',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[600],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: () {
                                        // TODO: Implement delete property action
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Delete feature coming soon!')),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 