import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/features/favourite/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileViewModel>.value(
          value: BlocProvider.of<ProfileViewModel>(context),
        ),
        BlocProvider<DashboardViewModel>(
          create: (context) => serviceLocator<DashboardViewModel>()..loadProperties(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => serviceLocator<CartBloc>(),
        ),
      ],
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
        backgroundColor: const Color(0xFFF6F8FA),
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
    final user = context.select<ProfileViewModel, UserEntity?>((vm) => vm.state.user);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- User Profile Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: user?.profilePicture != null && user!.profilePicture!.isNotEmpty
                      ? CachedNetworkImageProvider("http://10.0.2.2:3001${user.profilePicture}")
                      : const AssetImage('assets/images/fb.png') as ImageProvider,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      user?.fullName ?? 'Guest',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- Horizontal Scroll: Featured/Recommended Properties ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recommended",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement see all
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
          if (properties.isNotEmpty)
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: HorizontalPropertyCard(
                      property: property,
                      onTap: () {
                        // TODO: Navigate to property details
                      },
                      baseUrl: 'http://10.0.2.2:3001/',
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),

          // --- Promotional Banner ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://thumbs.dreamstime.com/z/commercial-real-estate-banner-blue-colors-hands-smartphone-buildings-skyscrapers-cityscape-property-searching-app-concept-186877789.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Vertical List: All Properties ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              "All Properties",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Replaced ListView.builder with Column to avoid sliver/nested scroll issues
          Column(
            children: properties.map((property) => 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: PropertyCardWidget(
                  property: property,
                  onTap: () {
                    // TODO: Navigate to property details
                  },
                  showFavoriteButton: true,
                  baseUrl: 'http://10.0.2.2:3001/',
                ),
              )
            ).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
