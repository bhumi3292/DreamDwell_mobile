import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PropertyCardWidget', () {
    testWidgets('should display property information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.home),
                ),
                title: Text('Test Property'),
                subtitle: Text('Test Location'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\$1,000', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('2 bed, 1 bath'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Property'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('\$1,000'), findsOneWidget);
      expect(find.text('2 bed, 1 bath'), findsOneWidget);
    });

    testWidgets('should handle onTap functionality', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => tapped = true,
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
      expect(tapped, isFalse);

      await tester.tap(find.text('Test Property'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('should display favorite button', (WidgetTester tester) async {
      bool favoriteToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: const Text('Test Property'),
                subtitle: const Text('Test Location'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => favoriteToggled = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Property'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(favoriteToggled, isFalse);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      expect(favoriteToggled, isTrue);
    });

    testWidgets('should display property image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.image, size: 48),
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text('Test Property'),
                    subtitle: Text('Test Location'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.text('Test Property'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('should display property details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text('Test Property'),
                subtitle: Text('Test Location'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\$1,000', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bed, size: 16),
                        Text('2'),
                        SizedBox(width: 8),
                        Icon(Icons.bathroom, size: 16),
                        Text('1'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Property'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('\$1,000'), findsOneWidget);
      expect(find.byIcon(Icons.bed), findsOneWidget);
      expect(find.byIcon(Icons.bathroom), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should handle long property names', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text('Very Long Property Name That Might Overflow'),
                subtitle: Text('Test Location'),
                trailing: Text('\$1,000'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Very Long Property Name That Might Overflow'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('\$1,000'), findsOneWidget);
    });
  });
}

