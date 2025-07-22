import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
=======
import 'package:dream_dwell/features/favourite/domain/entity/cart/cart_item_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/explore/presentation/view/property_detail_page.dart';
import 'package:dream_dwell/features/explore/presentation/utils/property_converter.dart';
>>>>>>> sprint5

class CartItemWidget extends StatelessWidget {
  final CartItemEntity cartItem;
  final VoidCallback onRemove;
<<<<<<< HEAD
  final String? baseUrl;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    this.baseUrl,
  });
=======

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onRemove,
  }) : super(key: key);
>>>>>>> sprint5

  @override
  Widget build(BuildContext context) {
    final property = cartItem.property;
<<<<<<< HEAD
    final isMinimal = property == null || (property.title == null || property.title!.isEmpty);
    if (isMinimal) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
=======
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final exploreProperty = PropertyConverter.fromPropertyEntity(property);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyDetailPage(property: exploreProperty),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
>>>>>>> sprint5
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
<<<<<<< HEAD
              const Icon(Icons.home, size: 50, color: Colors.grey),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Property details unavailable',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Remove from cart',
=======
              // Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: property.images?.isNotEmpty == true
                      ? Image.network(
                          ImageUrlHelper.constructImageUrl(property.images!.first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.home,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.home,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Property Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002B5B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location ?? 'No Location',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (property.bedrooms != null) ...[
                          const Icon(
                            Icons.bed,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property.bedrooms}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (property.bathrooms != null) ...[
                          const Icon(
                            Icons.bathroom,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property.bathrooms}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${property.price?.toStringAsFixed(0) ?? '0'} / month',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002B5B),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Remove Button
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 24,
                ),
                tooltip: 'Remove from favourites',
>>>>>>> sprint5
              ),
            ],
          ),
        ),
<<<<<<< HEAD
      );
    }
    final propertyApiModel = PropertyApiModel(
      id: property.id,
      images: property.images ?? [],
      title: property.title ?? '',
      location: property.location ?? '',
      price: property.price ?? 0.0,
      description: property.description ?? '',
      categoryId: property.categoryId ?? '',
      landlordId: property.landlordId ?? '',
      createdAt: property.createdAt,
      updatedAt: property.updatedAt,
      videos: property.videos ?? [],
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
    );
    return PropertyCardWidget(
      property: propertyApiModel,
      onTap: null,
      showFavoriteButton: false,
      showRemoveButton: true,
      isFavorite: false,
      baseUrl: baseUrl,
      onRemove: onRemove,
=======
      ),
>>>>>>> sprint5
    );
  }
} 