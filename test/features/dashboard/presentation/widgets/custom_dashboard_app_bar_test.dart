import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_confirmation_dialog.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/custom_dashboard_app_bar.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSignOutCubit extends MockCubit<SignOutState>
    implements SignOutCubit {}

void main() {
  late MockSignOutCubit mockSignOutCubit;
  late StreamController<SignOutState> stateController;

  setUp(() {
    AppToast.isEnabled = false;
    stateController = StreamController<SignOutState>.broadcast();
    mockSignOutCubit = MockSignOutCubit();

    when(() => mockSignOutCubit.state).thenReturn(SignOutInitial());
    when(() => mockSignOutCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockSignOutCubit.signOut()).thenAnswer((_) async {});

    if (getIt.isRegistered<SignOutCubit>()) {
      getIt.unregister<SignOutCubit>();
    }
    getIt.registerFactory<SignOutCubit>(() => mockSignOutCubit);
  });

  tearDown(() {
    AppToast.isEnabled = true;
    stateController.close();
    if (getIt.isRegistered<SignOutCubit>()) {
      getIt.unregister<SignOutCubit>();
    }
  });

  Widget buildWidget({Map<String, WidgetBuilder>? routes}) =>
      createWidgetForTesting(
        withToastification: true,
        routes: routes,
        child: const Scaffold(
          appBar: CustomDashboardAppBar(),
          body: SizedBox(),
        ),
      );

  group('CustomDashboardAppBar Widget Tests', () {
    testWidgets(
      'should render dashboard icon, title, subtitle, and logout button',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.dashboard_rounded), findsOneWidget);
        expect(find.text(AppStrings.dashboard), findsOneWidget);
        expect(find.text(AppStrings.admin), findsOneWidget);
        expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should show logout confirmation dialog when logout button is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byIcon(Icons.logout_rounded));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CustomConfirmationDialog), findsOneWidget);
        expect(find.text(AppStrings.logOutConfirmation), findsOneWidget);
        expect(find.text(AppStrings.yes), findsOneWidget);
        expect(find.text(AppStrings.no), findsOneWidget);
      },
    );

    testWidgets(
      'should call signOut on cubit when confirm button in dialog is pressed',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act - Tap logout icon
        await tester.tap(find.byIcon(Icons.logout_rounded));
        await tester.pumpAndSettle();

        // Tap confirm (Yes) button
        final yesButton = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.yes,
        );
        await tester.tap(yesButton);
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockSignOutCubit.signOut()).called(1);
      },
    );

    testWidgets(
      'should dismiss dialog without calling signOut when cancel button is pressed',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act - Tap logout icon
        await tester.tap(find.byIcon(Icons.logout_rounded));
        await tester.pumpAndSettle();

        // Tap cancel (No) button
        final noButton = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.no,
        );
        await tester.tap(noButton);
        await tester.pumpAndSettle();

        // Assert
        verifyNever(() => mockSignOutCubit.signOut());
        expect(find.byType(CustomConfirmationDialog), findsNothing);
      },
    );

    testWidgets(
      'should show toast and navigate to loginView when SignOutSuccess state is emitted',
      (WidgetTester tester) async {
        // Arrange
        var navigatedToLogin = false;
        await tester.pumpWidget(
          buildWidget(
            routes: {
              Routes.loginView: (_) {
                navigatedToLogin = true;
                return const Scaffold(body: Text('Login Screen'));
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act
        stateController.add(SignOutSuccess());
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToLogin, isTrue);
      },
    );
  });
}
