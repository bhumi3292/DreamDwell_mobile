import 'package:flutter/material.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';

class PropertyDetailPage extends StatelessWidget {
  final String propertyId;
  const PropertyDetailPage({Key? key, required this.propertyId}) : super(key: key);

  Future<PropertyApiModel> fetchProperty(String id) async {
    try {
      final apiService = GetIt.instance<ApiService>();
      final response = await apiService.dio.get('${ApiEndpoints.getPropertyById}$id');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return PropertyApiModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch property: ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Failed to fetch property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PropertyApiModel>(
        future: fetchProperty(propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', 
                       style: const TextStyle(fontSize: 16),
                       textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Refresh the page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailPage(propertyId: propertyId),
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No property found.'));
          }
          
          final property = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                if (property.images.isNotEmpty)
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: property.images.length,
                        itemBuilder: (context, index) {
                          final imageUrl = '${ApiEndpoints.imageUrl}${property.images[index]}';
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 350,
                              height: 250,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 350,
                                height: 250,
                                color: Colors.grey[300],
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 350,
                                height: 250,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.red, size: 50),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Property Title
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        property.location,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${property.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Property Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Property Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Bedrooms and Bathrooms
                        Row(
                          children: [
                            if (property.bedrooms != null) ...[
                              _buildDetailItem(Icons.bed, '${property.bedrooms} Bedrooms'),
                              const SizedBox(width: 24),
                            ],
                            if (property.bathrooms != null)
                              _buildDetailItem(Icons.bathroom, '${property.bathrooms} Bathrooms'),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Category
                        if (property.categoryId.isNotEmpty)
                          _buildDetailItem(Icons.category, 'Category: ${property.categoryId}'),
                        
                        const SizedBox(height: 16),
                        
                        // Description
                        if (property.description != null && property.description!.isNotEmpty) ...[
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            property.description!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Landlord Information Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Landlord Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Note: The backend populates landlord info, but our PropertyApiModel 
                        // doesn't have these fields yet. For now, we'll show the landlord ID
                        _buildDetailItem(Icons.person, 'Landlord ID: ${property.landlordId}'),
                        
                        const SizedBox(height: 8),
                        const Text(
                          'Contact information will be available once landlord details are populated.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Contact Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement contact functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact functionality coming soon!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Contact Landlord',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
} 