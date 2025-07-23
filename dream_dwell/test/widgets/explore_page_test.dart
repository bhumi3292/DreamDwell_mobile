// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dream_dwell/features/explore/presentation/view/explore_page.dart';
// import 'package:dream_dwell/features/explore/presentation/bloc/explore_bloc.dart';
//
// void main() {
//   group('ExplorePage', () {
//     testWidgets('should display search bar and filter chips', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider(
//             create: (context) => ExploreBloc(
//               getAllPropertiesUsecase: null, // Mock this in a real test
//             ),
//             child: const ExplorePage(),
//           ),
//         ),
//       );
//
//       // Wait for the widget to load
//       await tester.pumpAndSettle();
//
//       // Should show search bar
//       expect(find.byType(TextField), findsOneWidget);
//       expect(find.text('Search properties...'), findsOneWidget);
//
//       // Should show filter chips
//       expect(find.text('All'), findsOneWidget);
//       expect(find.text('Apartment'), findsOneWidget);
//       expect(find.text('House'), findsOneWidget);
//       expect(find.text('Villa'), findsOneWidget);
//     });
//
//     testWidgets('should show filter button', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider(
//             create: (context) => ExploreBloc(
//               getAllPropertiesUsecase: null, // Mock this in a real test
//             ),
//             child: const ExplorePage(),
//           ),
//         ),
//       );
//
//       // Should show filter button
//       expect(find.byIcon(Icons.tune), findsOneWidget);
//     });
//
//     testWidgets('should show loading indicator initially', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider(
//             create: (context) => ExploreBloc(
//               getAllPropertiesUsecase: null, // Mock this in a real test
//             ),
//             child: const ExplorePage(),
//           ),
//         ),
//       );
//
//       // Should show loading indicator
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });
//   });
// }