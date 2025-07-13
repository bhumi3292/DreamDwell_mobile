import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dream_dwell/view/favourite.dart';
import 'package:dream_dwell/features/add_property/domain/entity/cart/cart_entity.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

void main() {
  group('FavouritePage', () {
    testWidgets('should display empty state when no favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FavouritePage(),
        ),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Should show empty state
      expect(find.text('No favourites yet'), findsOneWidget);
      expect(find.text('Start adding properties to your favourites'), findsOneWidget);
      expect(find.text('Explore Properties'), findsOneWidget);
    });

    testWidgets('should display header correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FavouritePage(),
        ),
      );

      // Should show header
      expect(find.text('My Favourites'), findsOneWidget);
      expect(find.byIcon(Icons.clear_all), findsOneWidget);
    });

    testWidgets('should show clear all dialog when clear button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FavouritePage(),
        ),
      );

      // Tap the clear all button
      await tester.tap(find.byIcon(Icons.clear_all));
      await tester.pumpAndSettle();

      // Should show dialog
      expect(find.text('Clear All Favourites'), findsOneWidget);
      expect(find.text('Are you sure you want to remove all properties from your favourites?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
    });
  });
} 