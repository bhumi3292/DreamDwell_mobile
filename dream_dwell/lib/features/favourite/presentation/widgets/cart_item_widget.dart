import 'package:flutter/material.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity cartItem;
  final VoidCallback onRemove;
  final String? baseUrl;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final property = cartItem.property;
    final isMinimal = property == null || (property.title == null || property.title!.isEmpty);
    if (isMinimal) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
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
              ),
            ],
          ),
        ),
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
    );
  }
} 