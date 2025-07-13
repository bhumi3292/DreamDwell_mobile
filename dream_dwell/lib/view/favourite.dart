import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/remove_from_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/clear_cart_usecase.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Future<CartEntity?> _cartFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cartFuture = _fetchCart();
  }

  Future<CartEntity?> _fetchCart() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final usecase = GetIt.instance<GetCartUsecase>();
      final result = await usecase();
      return result.fold((failure) {
        print('Error fetching cart: ${failure.message}');
        return null;
      }, (cart) {
        print('Successfully fetched cart with ${cart.items?.length ?? 0} items');
        return cart;
      });
    } catch (e) {
      print('Exception fetching cart: $e');
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favourites'),
          content: const Text('Are you sure you want to remove all properties from your favourites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearAllFavourites();
              },
              child: const Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllFavourites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usecase = GetIt.instance<ClearCartUsecase>();
      final result = await usecase();
      
      result.fold((failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear favourites: ${failure.message}')),
        );
      }, (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All favourites cleared')),
        );
        // Refresh the cart data
        setState(() {
          _cartFuture = _fetchCart();
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing favourites: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  PropertyApiModel _convertPropertyEntityToPropertyApiModel(PropertyEntity propertyEntity) {
    return PropertyApiModel(
      id: propertyEntity.id,
      images: propertyEntity.images ?? [],
      videos: propertyEntity.videos ?? [],
      title: propertyEntity.title ?? 'Unknown Property',
      location: propertyEntity.location ?? 'Unknown Location',
      bedrooms: propertyEntity.bedrooms,
      bathrooms: propertyEntity.bathrooms,
      categoryId: propertyEntity.categoryId ?? '',
      price: propertyEntity.price ?? 0.0,
      description: propertyEntity.description,
      landlordId: propertyEntity.landlordId ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Favourites",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () => _showClearAllDialog(),
                    icon: const Icon(Icons.clear_all, color: Color(0xFF003366)),
                  ),
                ],
              ),
            ),
            
            // Properties List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<CartEntity?>(
                      future: _cartFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading favourites',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _cartFuture = _fetchCart();
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data?.items == null || snapshot.data!.items!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'No favourites yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start adding properties to your favourites',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to explore page
                                    Navigator.pushNamed(context, '/explore');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF003366),
                                  ),
                                  child: const Text(
                                    'Explore Properties',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: snapshot.data!.items!.length,
                          itemBuilder: (context, index) {
                            final cartItem = snapshot.data!.items![index];
                            
                            // Check if the cart item has a valid property
                            if (cartItem.property == null) {
                              return const SizedBox.shrink(); // Skip items without properties
                            }
                            
                            final property = _convertPropertyEntityToPropertyApiModel(cartItem.property!);
                            
                            return PropertyCardWidget(
                              property: property,
                              onTap: () {
                                // Navigate to property details
                                // Navigator.pushNamed(context, '/property-details', arguments: property);
                              },
                              showFavoriteButton: true,
                              isFavorite: true, // Show as favorite since it's in favorites page
                              baseUrl: 'http://10.0.2.2:3001/',
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}