import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/dashbaord/presentation/view_model/dashboard_view_model.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/horizontal_property_card.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback? onSeeAllTap;

  const DashboardPage({super.key, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<DashboardViewModel>()..loadProperties(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to add property page
            Get.toNamed('/add-property');
          },
          backgroundColor: const Color(0xFF003366),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocBuilder<DashboardViewModel, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardViewModel>().loadProperties();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is DashboardLoaded) {
              return _buildDashboardContent(context, state.properties);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, List<PropertyApiModel> properties) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- Header ----------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recommended",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle see all tap
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ------------------- Horizontal Scroll Properties ------------------
          if (properties.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final property = properties[index];
                  
                  return HorizontalPropertyCard(
                    property: property,
                    onTap: () {
                      // Navigate to property details
                      // Navigator.pushNamed(context, '/property-details', arguments: property);
                    },
                    baseUrl: 'http://10.0.2.2:3001/',
                  );
                },
              ),
            ),

          // ------------------- Promotional Banner ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://thumbs.dreamstime.com/z/commercial-real-estate-banner-blue-colors-hands-smartphone-buildings-skyscrapers-cityscape-property-searching-app-concept-186877789.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ------------------- Popular for You ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Popular for you",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // ------------------- Vertical List of Properties ------------------
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              
              return PropertyCardWidget(
                property: property,
                onTap: () {
                  // Navigate to property details
                  // Navigator.pushNamed(context, '/property-details', arguments: property);
                },
                showFavoriteButton: true,
                baseUrl: 'http://10.0.2.2:3001/',
              );
            },
          )
        ],
      ),
    );
  }
}
