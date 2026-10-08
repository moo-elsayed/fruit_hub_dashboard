import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/widgets/or_divider.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/widgets/social_auth_section.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSocialSignInCubit extends MockCubit<SocialSignInState>
    implements SocialSignInCubit {}

void main() {
  late MockSocialSignInCubit mockSocialSignInCubit;
  late StreamController<SocialSignInState> stateController;

  setUp(() {
    AppToast.isEnabled = false;
    stateController = StreamController<SocialSignInState>.broadcast();
    mockSocialSignInCubit = MockSocialSignInCubit();

    when(() => mockSocialSignInCubit.state).thenReturn(SocialSignInInitial());
    when(() => mockSocialSignInCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockSocialSignInCubit.googleSignIn()).thenAnswer((_) async {});
  });

  tearDown(() {
    AppToast.isEnabled = true;
    stateController.close();
  });

  Widget buildWidget({Map<String, WidgetBuilder>? routes}) =>
      createWidgetForTesting(
        withToastification: true,
        routes: routes,
        child: BlocProvider<SocialSignInCubit>.value(
          value: mockSocialSignInCubit,
          child: const SocialAuthSection(),
        ),
      );

  group('SocialAuthSection Widget Tests', () {
    testWidgets('should render OrDivider and Google button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OrDivider), findsOneWidget);
      expect(find.text(AppStrings.signInWithGoogle), findsOneWidget);
      expect(find.byType(CustomMaterialButton), findsOneWidget);
    });

    testWidgets(
      'should trigger googleSignIn on cubit when Google button is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text(AppStrings.signInWithGoogle));
        await tester.pump();

        // Assert
        verify(() => mockSocialSignInCubit.googleSignIn()).called(1);
      },
    );

    testWidgets(
      'should show loading indicator on Google button when GoogleLoading is emitted',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockSocialSignInCubit.state).thenReturn(GoogleLoading());
        await tester.pumpWidget(buildWidget());
        await tester.pump();

        // Assert
        final googleButton = tester.widget<CustomMaterialButton>(
          find.byWidgetPredicate(
            (w) =>
                w is CustomMaterialButton &&
                w.text == AppStrings.signInWithGoogle,
          ),
        );
        expect(googleButton.isLoading, isTrue);
      },
    );

    testWidgets(
      'should navigate to dashboardView when GoogleSuccess state is emitted',
      (WidgetTester tester) async {
        // Arrange
        var navigatedToDashboard = false;
        await tester.pumpWidget(
          buildWidget(
            routes: {
              Routes.dashboardView: (_) {
                navigatedToDashboard = true;
                return const Scaffold(body: Text('Dashboard Screen'));
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act
        stateController.add(GoogleSuccess());
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToDashboard, isTrue);
      },
    );

    testWidgets(
      'should show error toast with message when GoogleFailure state is emitted',
      (WidgetTester tester) async {
        // Arrange
        AppToast.isEnabled = true;
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act
        const errorMessage = 'حدث خطأ أثناء تسجيل الدخول بجوجل';
        stateController.add(GoogleFailure(errorMessage));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));

        // Assert
        expect(find.text(errorMessage, skipOffstage: false), findsOneWidget);

        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 4));
      },
    );
  });
}
