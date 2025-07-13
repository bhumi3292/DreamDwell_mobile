import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:dream_dwell/features/auth/presentation/view/login.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';

// Generate mocks
@GenerateMocks([UserLoginUsecase])
import 'login_widget_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login Widget Tests', () {
    late MockUserLoginUsecase mockLoginUsecase;
    late LoginViewModel loginViewModel;

    setUp(() {
      mockLoginUsecase = MockUserLoginUsecase();
      loginViewModel = LoginViewModel(loginUserUseCase: mockLoginUsecase);
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<LoginViewModel>.value(
          value: loginViewModel,
          child: const Login(),
        ),
      );
    }

    testWidgets('Login screen displays all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // There are 3 images: logo, fb, google
      expect(find.byType(Image), findsNWidgets(3));

      expect(find.text('DreamDwell'), findsOneWidget);
      expect(find.text('Welcome back!'), findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(2));
      // Use a widget predicate to find the dropdown by label
      final dropdownFinder = find.byWidgetPredicate((widget) {
        return widget is DropdownButtonFormField<String> &&
            widget.decoration.labelText == 'Stake Holder';
      });
      if (dropdownFinder.evaluate().isEmpty) {
        debugPrint('DropdownButtonFormField not found! Widget tree:');
        debugDumpApp();
      }
      expect(dropdownFinder, findsOneWidget);

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Signup'), findsOneWidget);
    });

    testWidgets('Login form validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Select a role'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('Stakeholder dropdown shows correct options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final dropdownFinder = find.byWidgetPredicate((widget) {
        return widget is DropdownButtonFormField<String> &&
            widget.decoration.labelText == 'Stake Holder';
      });
      if (dropdownFinder.evaluate().isEmpty) {
        debugPrint('DropdownButtonFormField not found! Widget tree:');
        debugDumpApp();
      }
      expect(dropdownFinder, findsOneWidget);

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      expect(find.text('Landlord'), findsOneWidget);
      expect(find.text('Tenant'), findsOneWidget);
    });

    testWidgets('Form can be filled and submitted', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      final dropdownFinder = find.byWidgetPredicate((widget) {
        return widget is DropdownButtonFormField<String> &&
            widget.decoration.labelText == 'Stake Holder';
      });
      if (dropdownFinder.evaluate().isEmpty) {
        debugPrint('DropdownButtonFormField not found! Widget tree:');
        debugDumpApp();
      }
      expect(dropdownFinder, findsOneWidget);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Landlord').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter your email'), findsNothing);
      expect(find.text('Enter your password'), findsNothing);
      expect(find.text('Select a role'), findsNothing);
    });
  });
} 