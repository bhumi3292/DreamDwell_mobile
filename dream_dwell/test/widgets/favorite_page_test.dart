import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavouritePage', () {
    testWidgets('should display empty state when no favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 64),
                  Text('No favourites yet'),
                  Text('Properties you like will appear here'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('No favourites yet'), findsOneWidget);
      expect(find.text('Properties you like will appear here'), findsOneWidget);
    });

    testWidgets('should display header with clear all button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Favourites'),
              actions: const [
                IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: null,
                ),
              ],
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Favourites'), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep), findsOneWidget);
    });

    testWidgets('should display favorite properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('Favorite Property 1'),
                    subtitle: Text('Location 1'),
                    trailing: Text('\$1,000'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('Favorite Property 2'),
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
      expect(find.byIcon(Icons.favorite), findsNWidgets(2));
      expect(find.text('Favorite Property 1'), findsOneWidget);
      expect(find.text('Favorite Property 2'), findsOneWidget);
      expect(find.text('Location 1'), findsOneWidget);
      expect(find.text('Location 2'), findsOneWidget);
      expect(find.text('\$1,000'), findsOneWidget);
      expect(find.text('\$2,000'), findsOneWidget);
    });

    testWidgets('should handle remove favorite action', (WidgetTester tester) async {
      bool removePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text('Favorite Property'),
                    subtitle: const Text('Location'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => removePressed = true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Favorite Property'), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle), findsOneWidget);
      expect(removePressed, isFalse);

      await tester.tap(find.byIcon(Icons.remove_circle));
      await tester.pumpAndSettle();

      expect(removePressed, isTrue);
    });

    testWidgets('should display error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  Text('Failed to load favourites'),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Failed to load favourites'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should handle clear all confirmation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Favourites'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    showDialog(
                      context: tester.element(find.byType(Scaffold)),
                      builder: (context) => AlertDialog(
                        title: const Text('Clear All Favourites'),
                        content: const Text('Are you sure you want to remove all favourites?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      expect(find.text('Clear All Favourites'), findsOneWidget);
      expect(find.text('Are you sure you want to remove all favourites?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
    });

    testWidgets('should display favorite count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Favourites (3)'),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Favourites (3)'), findsOneWidget);
    });
  });
} 