import 'package:flutter/material.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_all_properties_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<PropertyEntity>> _propertiesFuture;
  List<PropertyEntity> _allProperties = [];
  List<PropertyEntity> _filteredProperties = [];
  String _searchText = '';
  String? _selectedCategory;
  double? _maxPrice;
  bool _isLoading = false;
  Set<String> _cartPropertyIds = {}; // Track which properties are in cart

  @override
  void initState() {
    super.initState();
    _propertiesFuture = _fetchProperties();
    _fetchCart(); // Fetch cart to know which properties are already added
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh cart when page becomes active (e.g., when returning from other pages)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCart();
    });
  }

  Future<List<PropertyEntity>> _fetchProperties() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final usecase = GetIt.instance<GetAllPropertiesUsecase>();
      final result = await usecase();
      return result.fold((failure) {
        print('Error fetching properties: ${failure.message}');
        return [];
      }, (properties) {
        print('Successfully fetched ${properties.length} properties');
        for (var property in properties) {
          print('Property: ${property.title} - ${property.location} - Rs ${property.price}');
        }
        _allProperties = properties;
        _filteredProperties = properties;
        return properties;
      });
    } catch (e) {
      print('Exception fetching properties: $e');
      return [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCart() async {
    try {
      final usecase = GetIt.instance<GetCartUsecase>();
      final result = await usecase();
      result.fold((failure) {
        print('Error fetching cart: ${failure.message}');
      }, (cart) {
        setState(() {
          _cartPropertyIds = Set<String>.from(
            cart.items?.map((item) => item.property?.id ?? '').where((id) => id.isNotEmpty) ?? []
          );
        });
      });
    } catch (e) {
      print('Exception fetching cart: $e');
    }
  }

  void _filterProperties() {
    setState(() {
      _filteredProperties = _allProperties.where((property) {
        final matchesSearch = _searchText.isEmpty ||
            (property.title?.toLowerCase().contains(_searchText.toLowerCase()) ?? false) ||
            (property.location?.toLowerCase().contains(_searchText.toLowerCase()) ?? false);
        final matchesCategory = _selectedCategory == null || property.categoryId == _selectedCategory;
        final matchesPrice = _maxPrice == null || (property.price ?? 0) <= _maxPrice!;
        return matchesSearch && matchesCategory && matchesPrice;
      }).toList();
    });
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
    final propertyApiModel = _convertPropertyEntityToPropertyApiModel(property);
    
    return PropertyCardWidget(
      property: propertyApiModel,
      onTap: () {
        // Navigate to property details
        // Navigator.pushNamed(context, '/property-details', arguments: property);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('View property details')),
        );
      },
      showFavoriteButton: true,
      isFavorite: _cartPropertyIds.contains(property.id),
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
                              _searchText = value;
                              _filterProperties();
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
                        _buildFilterChip('All', _selectedCategory == null, () {
                          setState(() {
                            _selectedCategory = null;
                            _filterProperties();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('Apartment', _selectedCategory == 'apartment', () {
                          setState(() {
                            _selectedCategory = 'apartment';
                            _filterProperties();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('House', _selectedCategory == 'house', () {
                          setState(() {
                            _selectedCategory = 'house';
                            _filterProperties();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildFilterChip('Villa', _selectedCategory == 'villa', () {
                          setState(() {
                            _selectedCategory = 'villa';
                            _filterProperties();
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
                  : FutureBuilder<List<PropertyEntity>>(
                      future: _propertiesFuture,
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
                                  'Error loading properties',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _propertiesFuture = _fetchProperties();
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
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
                          );
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredProperties.length,
                          itemBuilder: (context, index) {
                            final property = _filteredProperties[index];
                            return _buildPropertyCard(property);
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

  Future<void> _showFilterDialog() async {
    double? maxPrice = _maxPrice;
    String? selectedCategory = _selectedCategory;

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
                  _maxPrice = maxPrice;
                  _selectedCategory = selectedCategory;
                  _filterProperties();
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
