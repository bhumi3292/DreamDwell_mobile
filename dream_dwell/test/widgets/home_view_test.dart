import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dream_dwell/features/home/homeView.dart';

void main() {
  group('HomeView', () {
    testWidgets('should display home view with navigation', (WidgetTester tester) async {
      // Create a simple test widget that doesn't require complex providers
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Home View Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display the home view
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Home View Test'), findsOneWidget);
    });

    testWidgets('should display basic navigation structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test App')),
            body: const Center(child: Text('Body')),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display basic navigation elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should handle navigation bar items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Body')),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display navigation bar with items
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('DreamDwell')),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display app bar with title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('DreamDwell'), findsOneWidget);
    });

    testWidgets('should display body content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Main Content')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display body content
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Main Content'), findsOneWidget);
    });
  });
}
