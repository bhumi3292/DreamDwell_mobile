import 'package:flutter/material.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/booking/presentation/widgets/booking_modal.dart';
import 'package:dream_dwell/features/booking/presentation/widgets/landlord_manage_availability.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
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
        title: Text('Property Details'),
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
            shadowColor: Colors.blueGrey.withOpacity(0.2),
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
                      Icon(Icons.king_bed, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Bedrooms: ${widget.property.bedrooms ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 18),
                      Icon(Icons.bathtub, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Bathrooms: ${widget.property.bathrooms ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.category, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text('Category: ${widget.property.categoryName ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  const SizedBox(height: 10),
                  Text('Description', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF003366))),
                  const SizedBox(height: 6),
                  Text(widget.property.description ?? 'No description provided.', style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 18),
                  Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  const SizedBox(height: 10),
                  Text('Landlord', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF003366))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text(widget.property.landlordName ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text(widget.property.landlordPhone ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Text(widget.property.landlordEmail ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text('Book a Visit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF003366),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            final profileState = context.read<ProfileViewModel>().state;
                            final currentUser = profileState.user;
                            debugPrint('Current userId:  [33m${currentUser?.userId} [0m, Property landlordId:  [33m${widget.property.landlordId} [0m');
                            final isLandlord = currentUser != null &&
                              (widget.property.landlordId == currentUser.userId);
                            showDialog(
                              context: context,
                              builder: (context) => isLandlord
                                ? LandlordManageAvailability(propertyId: widget.property.id ?? '')
                                : BookingModal(propertyId: widget.property.id ?? ''),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text('Chat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // TODO: Open chat with landlord
                          },
                        ),
                      ),
                    ],
                  ),
                  // Show Update and Delete buttons for landlord only
                  Builder(
                    builder: (context) {
                      final profileState = context.read<ProfileViewModel>().state;
                      final currentUser = profileState.user;
                      final isLandlord = currentUser != null &&
                        (widget.property.landlordId == currentUser.userId);
                      if (!isLandlord) return SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  // Navigate to UpdatePropertyPage with pre-filled details
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
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.delete),
                                label: Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  // TODO: Implement delete property action
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text('Make Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // TODO: Show payment modal
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