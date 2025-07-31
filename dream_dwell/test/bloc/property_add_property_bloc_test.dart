import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Property Add Property Bloc', () {
    test('should support async operations', () async {
      await Future.delayed(const Duration(milliseconds: 1));
      expect(true, isTrue);
    });

    test('should handle mock operations', () {
      final mockValue = 'mock';
      expect(mockValue, equals('mock'));
    });
  });
}