import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/remove_from_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';

class PropertyCardWidget extends StatefulWidget {
  final PropertyApiModel property;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool showRemoveButton;
  final bool isFavorite;
  final String? baseUrl;

  const PropertyCardWidget({
    super.key,
    required this.property,
    this.onTap,
    this.showFavoriteButton = true,
    this.showRemoveButton = false,
    this.isFavorite = false,
    this.baseUrl,
  });

  @override
  State<PropertyCardWidget> createState() => _PropertyCardWidgetState();
}

class _PropertyCardWidgetState extends State<PropertyCardWidget> {
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(Icons.error),
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.home, size: 40, color: Colors.grey),
                      ),
              ),
              
              const SizedBox(width: 12),
              
              // Property Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.property.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.property.location,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${widget.property.price.toStringAsFixed(0)} /m',
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.bed, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.property.bedrooms ?? 0}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.bathtub_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.property.bathrooms ?? 0}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showFavoriteButton)
                    IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                            )
                          : Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                      onPressed: _isLoading ? null : _toggleFavorite,
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "4.6",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 