import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_property_by_id_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import '../../../booking/presentation/view/booking_page.dart';
import '../../../contact_landlord/presentation/view/contact_landlord_page.dart';
import '../../../edit_property/presentation/view/edit_property_page.dart';
import '../../../share_property/presentation/view/share_property_widget.dart';
import 'package:get/get.dart';

class PropertyDetailPage extends StatefulWidget {
  final String propertyId;
  final String? baseUrl;

  const PropertyDetailPage({
    Key? key,
    required this.propertyId,
    this.baseUrl,
  }) : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Future<PropertyEntity> _futureProperty;

  @override
  void initState() {
    super.initState();
    _futureProperty = _fetchProperty();
  }

  Future<PropertyEntity> _fetchProperty() async {
    final usecase = GetIt.instance<GetPropertyByIdUsecase>();
    final result = await usecase(widget.propertyId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (property) => property,
    );
  }

  bool isVideo(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.webm') ||
        url.toLowerCase().endsWith('.ogg') ||
        url.toLowerCase().endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF003366)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF003366),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 0,
      ),
      body: FutureBuilder<PropertyEntity>(
        future: _futureProperty,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Property not found.'));
          }
          final property = snapshot.data!;
          final List<String> images = property.images ?? [];
          final List<String> videos = property.videos ?? [];
          final List<String> allMedia = [...images, ...videos];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media viewer
                  if (allMedia.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        itemCount: allMedia.length,
                        itemBuilder: (context, index) {
                          final mediaUrl = widget.baseUrl != null ? widget.baseUrl! + allMedia[index] : allMedia[index];
                          if (isVideo(mediaUrl)) {
                            return Center(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoWidget(url: mediaUrl),
                              ),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                mediaUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  else
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Text('No media available', style: TextStyle(color: Colors.grey))),
                    ),
                  const SizedBox(height: 16),
                  // Title and price
                  Text(
                    property.title ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs. ${property.price?.toString() ?? 'N/A'}',
                    style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF003366)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location ?? 'N/A',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Category, Bedrooms, Bathrooms
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('Category: ${property.category?['category_name'] ?? property.categoryId ?? 'N/A'}')),
                      Chip(label: Text('Bedrooms: ${property.bedrooms?.toString() ?? 'N/A'}')),
                      Chip(label: Text('Bathrooms: ${property.bathrooms?.toString() ?? 'N/A'}')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Description',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.description ?? 'No description provided.',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  // Landlord info (show full info if present)
                  if (property.landlord != null)
                    Card(
                      color: const Color(0xFFe6f0ff),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Landlord Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                            const SizedBox(height: 8),
                            Text('Name: ${property.landlord?['fullName'] ?? 'N/A'}'),
                            Text('Email: ${property.landlord?['email'] ?? 'N/A'}'),
                            Text('Phone: ${property.landlord?['phoneNumber'] ?? 'N/A'}'),
                            if (property.landlord?['profilePicture'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  widget.baseUrl != null ? widget.baseUrl! + property.landlord!['profilePicture'] : property.landlord!['profilePicture'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_circle, size: 80, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Action buttons (modular navigation)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add to Favourites logic (existing or to be implemented)
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Add to Favourites'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => BookingPage(propertyId: property.id!));
                        },
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text('Book Now'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: property.landlord != null
                            ? () {
                                Get.to(() => ContactLandlordPage(
                                      landlordEmail: property.landlord!["email"] ?? '',
                                      landlordPhone: property.landlord!["phoneNumber"] ?? '',
                                    ));
                              }
                            : null,
                        icon: const Icon(Icons.contact_mail),
                        label: const Text('Contact Landlord'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => EditPropertyPage(propertyId: property.id!));
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Property'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SharePropertyWidget(propertyId: property.id!),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Placeholder for video widget (implement with a video player package if needed)
class VideoWidget extends StatelessWidget {
  final String url;
  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.videocam, size: 80, color: Colors.grey),
    );
  }
} 