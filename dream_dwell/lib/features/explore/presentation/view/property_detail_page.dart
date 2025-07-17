import 'package:flutter/material.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';

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
      backgroundColor: Color(0xFFE6F0FF),
      appBar: AppBar(
        title: Text('Property Details'),
        backgroundColor: Color(0xFF003366),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image gallery
                  if (allMedia.isNotEmpty)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            ImageUrlHelper.constructImageUrl(allMedia[_currentImage]),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (allMedia.length > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                allMedia.length,
                                (index) => GestureDetector(
                                  onTap: () => setState(() => _currentImage = index),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImage == index
                                          ? Color(0xFF003366)
                                          : Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 20),
                  // Title and price
                  Text(
                    widget.property.title ?? '',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.property.location ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rs. ${widget.property.price?.toStringAsFixed(0) ?? '-'}',
                    style: TextStyle(fontSize: 22, color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Features row
                  Row(
                    children: [
                      Icon(Icons.king_bed, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text('Bedrooms: ${widget.property.bedrooms ?? '-'}'),
                      SizedBox(width: 16),
                      Icon(Icons.bathtub, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text('Bathrooms: ${widget.property.bathrooms ?? '-'}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.category, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text('Category: ${widget.property.categoryName ?? '-'}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Description
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003366))),
                  SizedBox(height: 4),
                  Text(widget.property.description ?? 'No description provided.'),
                  SizedBox(height: 20),
                  // Landlord info
                  Text('Landlord', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003366))),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text(widget.property.landlordName ?? '-'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text(widget.property.landlordPhone ?? '-'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, color: Color(0xFF003366)),
                      SizedBox(width: 4),
                      Text(widget.property.landlordEmail ?? '-'),
                    ],
                  ),
                  SizedBox(height: 24),
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
                            // TODO: Show booking modal
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