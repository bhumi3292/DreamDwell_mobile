import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/explore/data/explore_property_state.dart';
import 'package:dream_dwell/features/explore/data/explore_property_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/cart/get_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/presentation/view_model/cart_view_model.dart';

class ExplorePropertyController {
  final ExplorePropertyViewModel viewModel;
  final ExplorePropertyState state = ExplorePropertyState();
  final CartViewModel cartViewModel = GetIt.instance<CartViewModel>();

  ExplorePropertyController(this.viewModel);

  Future<void> fetchProperties() async {
    final properties = await viewModel.fetchProperties();
    state.allProperties = properties;
    state.filteredProperties = properties;
  }

  Future<void> fetchCart() async {
    await cartViewModel.loadCart();
    state.cartPropertyIds = {
      ...?cartViewModel.cart?.items?.map((item) => item.property?.id ?? '').where((id) => id != null && id.isNotEmpty)
    };
  }

  void updateSearchText(String value) {
    state.searchText = value;
    state.filterProperties();
  }

  void updateCategory(String? category) {
    state.selectedCategory = category;
    state.filterProperties();
  }

  void updateMaxPrice(double? price) {
    state.maxPrice = price;
    state.filterProperties();
  }

  // Cart actions
  Future<void> addToCart(String propertyId) async {
    await cartViewModel.addToCart(propertyId);
    await fetchCart();
  }

  Future<void> removeFromCart(String propertyId) async {
    await cartViewModel.removeFromCart(propertyId);
    await fetchCart();
  }

  bool isInCart(String propertyId) {
    return cartViewModel.isInCart(propertyId);
  }
} 