import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:dream_dwell/features/explore/presentation/widgets/explore_property_card.dart';
import 'package:dream_dwell/features/explore/presentation/widgets/explore_search_bar.dart';
import 'package:dream_dwell/features/explore/presentation/widgets/explore_filter_dialog.dart';
import 'package:dream_dwell/features/favourite/presentation/bloc/cart_bloc.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late CartBloc _cartBloc;
  String _searchText = '';
  String? _selectedCategory;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _cartBloc = serviceLocator<CartBloc>();
    _cartBloc.add(GetCartEvent());
    context.read<ExploreBloc>().add(GetPropertiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header with Search Bar
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
                  ExploreSearchBar(
                    onSearchChanged: (value) {
                      _searchText = value;
                      _filterProperties();
                    },
                    onFilterPressed: () async {
                      await _showFilterDialog();
                    },
                  ),
                ],
              ),
            ),
            
            // Properties List
            Expanded(
              child: BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state is ExploreLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ExploreError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ExploreBloc>().add(GetPropertiesEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ExploreLoaded) {
                    if (state.filteredProperties.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No properties found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredProperties.length,
                      itemBuilder: (context, index) {
                        final property = state.filteredProperties[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BlocProvider.value(
                            value: _cartBloc,
                            child: ExplorePropertyCard(
                              property: property,
                              onTap: () {
                                // Navigate to property detail page
                                // You can implement this navigation here
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                  
                  return const Center(
                    child: Text('No data available'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterProperties() {
    context.read<ExploreBloc>().add(
      FilterPropertiesEvent(
        searchText: _searchText,
        categoryId: _selectedCategory,
        maxPrice: _maxPrice,
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExploreFilterDialog(
        initialMaxPrice: _maxPrice,
        initialCategory: _selectedCategory,
      ),
    );

    if (result != null) {
      setState(() {
        _maxPrice = result['maxPrice'];
        _selectedCategory = result['category'];
      });
      _filterProperties();
    }
  }
} 