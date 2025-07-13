import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dream_dwell/view/explore.dart';

void main() {
  group('ExplorePage', () {
    testWidgets('should display search bar and filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplorePage(),
        ),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Should show search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search properties...'), findsOneWidget);

      // Should show filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Apartment'), findsOneWidget);
      expect(find.text('House'), findsOneWidget);
      expect(find.text('Villa'), findsOneWidget);
    });

    testWidgets('should show filter button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplorePage(),
        ),
      );

      // Should show filter button
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ExplorePage(),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
} 