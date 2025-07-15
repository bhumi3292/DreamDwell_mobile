import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';
import 'package:dream_dwell/features/favourite/presentation/bloc/cart_bloc.dart';

class ExplorePropertyCard extends StatelessWidget {
  final ExplorePropertyEntity property;
  final VoidCallback onTap;

  const ExplorePropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: property.images != null && property.images!.isNotEmpty
                    ? Image.network(
                        ImageUrlHelper.constructImageUrl(property.images!.first),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.home,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.home,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            
            // Property Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title ?? 'Unknown Property',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location ?? 'Unknown Location',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Property Features
                  Row(
                    children: [
                      _buildFeatureChip(
                        icon: Icons.bed,
                        label: '${property.bedrooms ?? 0} Beds',
                      ),
                      const SizedBox(width: 8),
                      _buildFeatureChip(
                        icon: Icons.bathtub_outlined,
                        label: '${property.bathrooms ?? 0} Baths',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs ${property.price?.toStringAsFixed(0) ?? '0'}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, cartState) {
                          bool isFavorite = false;
                          if (cartState is CartLoaded && property.id != null) {
                            isFavorite = cartState.cart.items?.any((item) => item.property.id == property.id) ?? false;
                          }
                          return BlocListener<CartBloc, CartState>(
                            listener: (context, state) {
                              if (state is CartLoaded) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added to favourites!')),
                                );
                              } else if (state is CartError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            child: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey[600],
                              ),
                              onPressed: () {
                                if (property.id != null && !isFavorite) {
                                  context.read<CartBloc>().add(AddToCartEvent(property.id!));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 