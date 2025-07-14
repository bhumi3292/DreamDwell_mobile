# Cart/Favourite Feature

This module implements the cart functionality for the DreamDwell mobile app, allowing users to add properties to their cart (favourites) and manage them.

## Architecture

The feature follows Clean Architecture principles with the following layers:

### Domain Layer
- **Entities**: `CartEntity`, `CartItemEntity`, `PropertyEntity`
- **Repository Interface**: `CartRepository`
- **Use Cases**: 
  - `GetCartUseCase`
  - `AddToCartUseCase`
  - `RemoveFromCartUseCase`
  - `ClearCartUseCase`

### Data Layer
- **Models**: `CartModel`, `CartItemModel`, `PropertyModel`
- **Data Sources**: `CartRemoteDataSource`
- **Repository Implementation**: `CartRepositoryImpl`

### Presentation Layer
- **View Model**: `CartViewModel`
- **Views**: `CartView`
- **Widgets**: 
  - `CartItemWidget`
  - `EmptyCartWidget`
  - `CartButtonWidget`

## Features

### 1. View Cart
- Display all items in the user's cart
- Show property details (title, location, price, image)
- Calculate total price
- Handle empty cart state

### 2. Add to Cart
- Add properties to cart from any property listing
- Prevent duplicate items
- Show success/error feedback

### 3. Remove from Cart
- Remove individual items from cart
- Show confirmation dialog for bulk removal
- Update cart state immediately

### 4. Clear Cart
- Remove all items from cart at once
- Show confirmation dialog
- Handle empty state

### 5. Cart Button Widget
- Reusable widget for property cards
- Shows add/remove state
- Integrates with cart view model

## API Endpoints

The feature uses the following backend endpoints:

- `GET /api/cart` - Get user's cart
- `POST /api/cart/add` - Add property to cart
- `DELETE /api/cart/remove/:propertyId` - Remove property from cart
- `DELETE /api/cart/clear` - Clear entire cart

## Usage

### Basic Cart View
```dart
// Navigate to cart view
Navigator.push(context, MaterialPageRoute(
  builder: (context) => const CartView(),
));
```

### Add Cart Button to Property Card
```dart
CartButtonWidget(
  propertyId: property.id,
  size: 24,
)
```

### Check if Property is in Cart
```dart
final cartViewModel = Get.find<CartViewModel>();
bool isInCart = cartViewModel.isInCart(propertyId);
```

## State Management

The cart uses GetX for state management with the `CartViewModel`:

- **Reactive State**: Cart items, loading state, error messages
- **Methods**: Add, remove, clear, load cart
- **Observable Properties**: Cart data, item count, loading status

## Error Handling

- Network errors are handled gracefully
- User-friendly error messages
- Retry functionality for failed operations
- Loading states for better UX

## Testing

Unit tests are available for:
- Cart view model functionality
- Use case implementations
- Repository operations

Run tests with:
```bash
flutter test test/cart/
```

## Dependencies

- `get` - State management
- `dartz` - Functional programming utilities
- `dio` - HTTP client
- `flutter` - UI framework

## Integration

The cart feature is integrated into the main app through:
1. Service locator dependency injection
2. GetX controller registration in `HomeView`
3. Navigation integration in bottom navigation
4. Property card integration for add/remove functionality 