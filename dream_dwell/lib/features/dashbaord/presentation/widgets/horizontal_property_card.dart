import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/remove_from_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';

class HorizontalPropertyCard extends StatefulWidget {
  final PropertyApiModel property;
  final VoidCallback? onTap;
  final String? baseUrl;

  const HorizontalPropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.baseUrl,
  });

  @override
  State<HorizontalPropertyCard> createState() => _HorizontalPropertyCardState();
}

class _HorizontalPropertyCardState extends State<HorizontalPropertyCard> {
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      // Check if the property is in the cart (favorites)
      final getCartUsecase = GetIt.instance<GetCartUsecase>();
      final result = await getCartUsecase();
      
      result.fold(
        (failure) {
          // If we can't check, assume not favorite
          setState(() {
            _isFavorite = false;
          });
        },
        (cart) {
          final isInCart = cart.items?.any((item) => item.property?.id == widget.property.id) ?? false;
          setState(() {
            _isFavorite = isInCart;
          });
        },
      );
    } catch (e) {
      // If there's an error, assume not favorite
      setState(() {
        _isFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        // Remove from favorites
        final removeUsecase = GetIt.instance<RemoveFromCartUsecase>();
        final result = await removeUsecase(RemoveFromCartParams(propertyId: widget.property.id ?? ''));
        
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to remove from favorites: ${failure.message}')),
            );
          },
          (_) {
            setState(() {
              _isFavorite = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from favorites')),
            );
          },
        );
      } else {
        // Add to favorites
        final addUsecase = GetIt.instance<AddToCartUsecase>();
        final result = await addUsecase(AddToCartParams(propertyId: widget.property.id ?? ''));
        
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add to favorites: ${failure.message}')),
            );
          },
          (_) {
            setState(() {
              _isFavorite = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to favorites')),
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getImageUrl() {
    if (widget.property.images.isEmpty) return '';
    
    final imagePath = widget.property.images.first;
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    // Use the baseUrl if provided, otherwise construct from the image path
    final baseUrl = widget.baseUrl ?? 'http://10.0.2.2:3001/';
    return '$baseUrl$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();

    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Stack(
              children: [
                imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 200,
                          height: 120,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 200,
                          height: 120,
                          child: Icon(Icons.error),
                        ),
                      )
                    : Container(
                        width: 200,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.home, size: 40, color: Colors.grey),
                      ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                            )
                          : Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Property Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.property.location,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹ ${widget.property.price.toStringAsFixed(0)} /m',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.bed, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.property.bedrooms ?? 0}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.bathtub_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.property.bathrooms ?? 0}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "4.6",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 