import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/dashbaord/presentation/view_model/dashboard_view_model.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/property_card_widget.dart';
import 'package:dream_dwell/features/dashbaord/presentation/widgets/horizontal_property_card.dart';
import 'dart:async';

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

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentBigImageIndex = 0;
  Timer? _bigImageTimer;
  late PageController _bigImagePageController;

  @override
  void initState() {
    super.initState();
    _bigImagePageController = PageController();
    _startBigImageTimer();
  }

  void _startBigImageTimer() {
    _bigImageTimer?.cancel();
    _bigImageTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (!mounted) return;
      setState(() {
        _currentBigImageIndex = (_currentBigImageIndex + 1) % (_bigImageCount ?? 1);
        _bigImagePageController.animateToPage(
          _currentBigImageIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  int? _bigImageCount;

  @override
  void dispose() {
    _bigImageTimer?.cancel();
    _bigImagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<DashboardViewModel, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error:  {state.message}'),
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
              final landlordAvatars = state.landlordAvatars;
              final bigImageUrls = state.bigImageUrls;
              final topProperties = state.topProperties;
              _bigImageCount = bigImageUrls.length;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Avatars
                    if (landlordAvatars.isNotEmpty)
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: landlordAvatars.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final landlord = landlordAvatars[index];
                            final avatarUrl = landlord['profilePicture'] != null && landlord['profilePicture'].toString().isNotEmpty
                                ? 'http://10.0.2.2:3001${landlord['profilePicture']}'
                                : null;
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                                  backgroundColor: Colors.grey[300],
                                  child: avatarUrl == null ? const Icon(Icons.person, size: 28, color: Colors.white) : null,
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    landlord['fullName'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    // Big Animated House Image
                    if (bigImageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 220,
                          child: PageView.builder(
                            controller: _bigImagePageController,
                            itemCount: bigImageUrls.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentBigImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final imageUrl = bigImageUrls[index];
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 800),
                                child: imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          imageUrl,
                                          key: ValueKey(imageUrl),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 220,
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        height: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Center(child: Text('No image', style: TextStyle(color: Colors.grey))),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // 5 Property Cards (vertical)
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topProperties.length,
                      itemBuilder: (context, index) {
                        final property = topProperties[index];
                        return PropertyCardWidget(
                          property: property,
                          onTap: () {
                            // Navigate to property details
                            // You can use Get.to or Navigator here
                          },
                          showFavoriteButton: true,
                          baseUrl: 'http://10.0.2.2:3001/',
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
