import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dream_dwell/features/add_property/presentation/view/add_property_presentation.dart';

void main() {
  group('AddPropertyPresentation Category Tests', () {
    testWidgets('should display category dropdown with add button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddPropertyPresentation(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Category'), findsOneWidget);
      
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      
      // Should show select category dropdown
      expect(find.text('Select Category'), findsOneWidget);
    });

    testWidgets('should show add category dialog when add button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddPropertyPresentation(),
        ),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Tap the add category button
      await tester.tap(find.byIcon(Icons.add_circle));
      await tester.pumpAndSettle();

      // Should show add category dialog
      expect(find.text('Add New Category'), findsOneWidget);
      expect(find.text('Category Name'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('should show form fields for property details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddPropertyPresentation(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Bedrooms'), findsOneWidget);
      expect(find.text('Bathrooms'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Add Property'), findsOneWidget);
    });
  });
} 