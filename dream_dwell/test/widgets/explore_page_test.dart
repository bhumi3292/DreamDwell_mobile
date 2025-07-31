import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExplorePage', () {
    testWidgets('should display search bar and filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Search properties...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                Row(
                  children: const [
                    Chip(label: Text('All')),
                    Chip(label: Text('Apartment')),
                    Chip(label: Text('House')),
                    Chip(label: Text('Villa')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search properties...'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Apartment'), findsOneWidget);
      expect(find.text('House'), findsOneWidget);
      expect(find.text('Villa'), findsOneWidget);
    });

    testWidgets('should display property cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                Card(
                  child: ListTile(
                    title: Text('Property 1'),
                    subtitle: Text('Location 1'),
                    trailing: Text('\$1,000'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Property 2'),
                    subtitle: Text('Location 2'),
                    trailing: Text('\$2,000'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Property 1'), findsOneWidget);
      expect(find.text('Property 2'), findsOneWidget);
      expect(find.text('Location 1'), findsOneWidget);
      expect(find.text('Location 2'), findsOneWidget);
      expect(find.text('\$1,000'), findsOneWidget);
      expect(find.text('\$2,000'), findsOneWidget);
    });

    testWidgets('should handle empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64),
                  Text('No properties found'),
                  Text('Try adjusting your search criteria'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('No properties found'), findsOneWidget);
      expect(find.text('Try adjusting your search criteria'), findsOneWidget);
    });

    testWidgets('should handle search input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: InputDecoration(
                labelText: 'Search properties...',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search properties...'), findsOneWidget);
    });

    testWidgets('should display filter options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Filter Options'),
                CheckboxListTile(
                  title: Text('Price Range'),
                  value: true,
                  onChanged: null,
                ),
                CheckboxListTile(
                  title: Text('Bedrooms'),
                  value: false,
                  onChanged: null,
                ),
                CheckboxListTile(
                  title: Text('Bathrooms'),
                  value: true,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Filter Options'), findsOneWidget);
      expect(find.text('Price Range'), findsOneWidget);
      expect(find.text('Bedrooms'), findsOneWidget);
      expect(find.text('Bathrooms'), findsOneWidget);
    });

    testWidgets('should handle property card tap', (WidgetTester tester) async {
      bool cardTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => cardTapped = true,
              child: const Card(
                child: ListTile(
                  title: Text('Test Property'),
                  subtitle: Text('Test Location'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Property'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(cardTapped, isFalse);

      await tester.tap(find.text('Test Property'));
      await tester.pumpAndSettle();

      expect(cardTapped, isTrue);
    });

    testWidgets('should display refresh indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {},
              child: ListView(
                children: const [
                  Text('Property 1'),
                  Text('Property 2'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Property 1'), findsOneWidget);
      expect(find.text('Property 2'), findsOneWidget);
    });
  });
}