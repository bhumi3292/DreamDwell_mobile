import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/remove_from_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';
import 'package:dream_dwell/cores/utils/image_url_helper.dart';

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
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _pageController = PageController();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

    print('DEBUG: Heart icon tapped for property: ${widget.property.id} - ${widget.property.title}');
    print('DEBUG: Current favorite state: $_isFavorite');

    // Proceed with cart operation without authentication check
    print('DEBUG: Proceeding with cart operation (no login required)');

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        // Remove from favorites
        print('DEBUG: Attempting to remove from favorites');
        final removeUsecase = GetIt.instance<RemoveFromCartUsecase>();
        final result = await removeUsecase(RemoveFromCartParams(propertyId: widget.property.id ?? ''));
        
        result.fold(
          (failure) {
            print('DEBUG: Remove from favorites failed: ${failure.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to remove from favorites: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          (_) {
            print('DEBUG: Successfully removed from favorites');
            setState(() {
              _isFavorite = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      } else {
        // Add to favorites
        print('DEBUG: Attempting to add to favorites');
        final addUsecase = GetIt.instance<AddToCartUsecase>();
        final result = await addUsecase(AddToCartParams(propertyId: widget.property.id ?? ''));
        
        result.fold(
          (failure) {
            print('DEBUG: Add to favorites failed: ${failure.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add to favorites: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          (_) {
            print('DEBUG: Successfully added to favorites');
            setState(() {
              _isFavorite = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      }
    } catch (e) {
      print('DEBUG: Exception in _toggleFavorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  String _getImageUrl(String imagePath) {
    print('DEBUG: Processing image path: $imagePath');
    final fullUrl = ImageUrlHelper.constructImageUrl(imagePath, baseUrl: widget.baseUrl);
    print('DEBUG: Constructed full URL: $fullUrl');
    return fullUrl;
  }

  Widget _buildImageCarousel() {
    print('DEBUG: Building image carousel for property: ${widget.property.title}');
    print('DEBUG: Number of images: ${widget.property.images.length}');
    print('DEBUG: Images: ${widget.property.images}');
    
    if (widget.property.images.isEmpty) {
      print('DEBUG: No images available, showing placeholder');
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.home, size: 40, color: Colors.grey),
      );
    }

    // For debugging: Show all images in a grid to verify they load
    if (widget.property.images.length > 1) {
      print('DEBUG: Multiple images detected, showing carousel');
    }

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.property.images.length,
            onPageChanged: (index) {
              print('DEBUG: Page changed to index: $index');
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = _getImageUrl(widget.property.images[index]);
              print('DEBUG: Loading image $index: $imageUrl');
              
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  memCacheWidth: 200, // Optimize memory usage
                  memCacheHeight: 200,
                  placeholder: (context, url) {
                    print('DEBUG: Loading placeholder for: $url');
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    print('DEBUG: Error loading image: $url, Error: $error');
                    
                    // Try alternative URL formats if the first one fails
                    final originalPath = widget.property.images[index];
                    final alternativeUrls = [
                      'http://10.0.2.2:3001/uploads/$originalPath',
                      'http://10.0.2.2:3001/images/$originalPath',
                      'http://10.0.2.2:3001/static/$originalPath',
                    ];
                    
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            'Failed',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'URL: ${originalPath.length > 10 ? '${originalPath.substring(0, 10)}...' : originalPath}',
                            style: const TextStyle(fontSize: 6),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Status: 404',
                            style: const TextStyle(fontSize: 6, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Image indicators (only show if there are multiple images)
          if (widget.property.images.length > 1)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.property.images.length,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Stack(
          children: [
            Row(
              children: [
                _buildImageCarousel(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.property.location,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: ${widget.property.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (widget.property.bedrooms != null)
                              Row(
                                children: [
                                  const Icon(Icons.bed, size: 16, color: Colors.grey),
                                  const SizedBox(width: 2),
                                  Text('${widget.property.bedrooms}', style: const TextStyle(fontSize: 13)),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            if (widget.property.bathrooms != null)
                              Row(
                                children: [
                                  const Icon(Icons.bathtub, size: 16, color: Colors.grey),
                                  const SizedBox(width: 2),
                                  Text('${widget.property.bathrooms}', style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Update and Delete buttons removed - no login required for cart functionality
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Vertical Heart Icon positioned on the right
            if (widget.showFavoriteButton)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                          )
                        : Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                            size: 24,
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 