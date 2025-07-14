import 'package:flutter/material.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_all_properties_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/explore/data/explore_property_view_model.dart';
import 'package:dream_dwell/features/explore/data/explore_property_repository.dart';
import 'package:dream_dwell/features/explore/data/explore_property_controller.dart';
import 'package:dream_dwell/features/explore/data/explore_property_state.dart';
import '../../../add_property/presentation/view/property_detail_page.dart';
import 'package:get/get.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ExplorePropertyController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = ExplorePropertyController(ExplorePropertyViewModel(ExplorePropertyRepository()));
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh cart when page becomes active (e.g., when returning from other pages)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchCart();
    });
  }

  Future<void> _initData() async {
    setState(() { _isLoading = true; });
    await _controller.fetchProperties();
    await _controller.fetchCart();
    setState(() { _isLoading = false; });
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

  Widget _buildPropertyCard(PropertyEntity property) {
    final propertyApiModel = _controller.state.convertPropertyEntityToPropertyApiModel(property);
    final isInCart = _controller.isInCart(property.id ?? '');
    return PropertyCardWidget(
      property: propertyApiModel,
      onTap: () {
        Get.to(() => PropertyDetailPage(propertyId: property.id!, baseUrl: 'http://10.0.2.2:3001/'));
      },
      showFavoriteButton: true,
      isFavorite: isInCart,
      baseUrl: 'http://10.0.2.2:3001/',
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = _controller.state;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search properties...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _controller.updateSearchText(value);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.tune, color: theme.primaryColor),
                          onPressed: () async {
                            await _showFilterDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', state.selectedCategory == null, () {
                          setState(() {
                            _controller.updateCategory(null);
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('Apartment', state.selectedCategory == 'apartment', () {
                          setState(() {
                            _controller.updateCategory('apartment');
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('House', state.selectedCategory == 'house', () {
                          setState(() {
                            _controller.updateCategory('house');
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('Villa', state.selectedCategory == 'villa', () {
                          setState(() {
                            _controller.updateCategory('villa');
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Properties List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredProperties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No properties found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search criteria',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.filteredProperties.length,
                          itemBuilder: (context, index) {
                            final property = state.filteredProperties[index];
                            return _buildPropertyCard(property);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    double? maxPrice = _controller.state.maxPrice;
    String? selectedCategory = _controller.state.selectedCategory;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Properties'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Max Price',
                  hintText: 'Enter maximum price',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  maxPrice = double.tryParse(value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Property Type',
                ),
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Types')),
                  DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                  DropdownMenuItem(value: 'house', child: Text('House')),
                  DropdownMenuItem(value: 'villa', child: Text('Villa')),
                ],
                onChanged: (value) {
                  selectedCategory = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.updateMaxPrice(maxPrice);
                  _controller.updateCategory(selectedCategory);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
