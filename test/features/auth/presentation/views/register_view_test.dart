import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_success_dialog.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/sign_up_input_entity.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/args/login_args.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signup_cubit/sign_up_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/views/register_view.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSignupCubit extends MockCubit<SignupState> implements SignupCubit {}

class FakeSignUpInputEntity extends Fake implements SignUpInputEntity {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockSignupCubit mockSignupCubit;
  late StreamController<SignupState> signupStateController;

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  setUpAll(() {
    registerFallbackValue(FakeSignUpInputEntity());
  });

  setUp(() {
    AppToast.isEnabled = false;
    signupStateController = StreamController<SignupState>.broadcast();
    mockSignupCubit = MockSignupCubit();

    when(() => mockSignupCubit.state).thenReturn(SignUpInitial());
    when(() => mockSignupCubit.stream)
        .thenAnswer((_) => signupStateController.stream);
    when(() => mockSignupCubit.createUserWithEmailAndPassword(any()))
        .thenAnswer((_) async {});

    if (getIt.isRegistered<SignupCubit>()) {
      getIt.unregister<SignupCubit>();
    }
    getIt.registerFactory<SignupCubit>(() => mockSignupCubit);
  });

  tearDown(() {
    AppToast.isEnabled = true;
    signupStateController.close();
    if (getIt.isRegistered<SignupCubit>()) {
      getIt.unregister<SignupCubit>();
    }
  });

  Widget buildTestWidget({NavigatorObserver? observer}) =>
      createWidgetForTesting(
        withToastification: true,
        navigatorObserver: observer,
        child: const RegisterView(),
      );

  group('RegisterView Widget Tests', () {
    testWidgets(
      'should render all initial registration UI components correctly',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);

        // Act
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.newAccount), findsWidgets);
        expect(find.byType(AuthHeaderSection), findsOneWidget);
        expect(find.text(AppStrings.appTagline), findsOneWidget);
        expect(find.byType(TextFormFieldHelper), findsNWidgets(4));
        expect(
          find.widgetWithText(CustomMaterialButton, AppStrings.register),
          findsOneWidget,
        );
        expect(find.byType(AuthRedirectText), findsOneWidget);
      },
    );

    testWidgets(
      'should not call createUserWithEmailAndPassword when form validation fails',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act
        final registerButton = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.register,
        );
        await tester.ensureVisible(registerButton);
        await tester.tap(registerButton);
        await tester.pumpAndSettle();

        // Assert
        verifyNever(
          () => mockSignupCubit.createUserWithEmailAndPassword(any()),
        );
      },
    );

    testWidgets(
      'should call createUserWithEmailAndPassword on cubit when form is valid',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act
        final textFields = find.byType(TextFormFieldHelper);
        await tester.enterText(textFields.at(0), 'محمد أحمد');
        await tester.enterText(textFields.at(1), 'user@example.com');
        await tester.enterText(textFields.at(2), '01012345678');
        await tester.enterText(textFields.at(3), 'Password123!');
        await tester.pumpAndSettle();

        final registerButton = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.register,
        );
        await tester.ensureVisible(registerButton);
        await tester.tap(registerButton);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSignupCubit.createUserWithEmailAndPassword(
            any(
              that: isA<SignUpInputEntity>()
                  .having((e) => e.username, 'username', 'محمد أحمد')
                  .having((e) => e.email, 'email', 'user@example.com')
                  .having((e) => e.phone, 'phone', '01012345678')
                  .having((e) => e.password, 'password', 'Password123!'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should show CustomSuccessDialog when SignUpSuccess state is emitted',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act
        signupStateController.add(SignUpSuccess());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CustomSuccessDialog), findsOneWidget);
        expect(find.text(AppStrings.emailSentToVerify), findsOneWidget);
      },
    );

    testWidgets(
      'should pop dialog and view with LoginArgs when success dialog button is pressed',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        LoginArgs? poppedArgs;
        await tester.pumpWidget(
          createWidgetForTesting(
            withToastification: true,
            child: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  key: const ValueKey('open_register'),
                  onPressed: () async {
                    final res = await Navigator.of(context).push<LoginArgs>(
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                    poppedArgs = res;
                  },
                  child: const Text('Open Register'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open Register
        await tester.tap(find.byKey(const ValueKey('open_register')));
        await tester.pumpAndSettle();

        // Fill form so controllers have data
        final textFields = find.byType(TextFormFieldHelper);
        await tester.enterText(textFields.at(1), 'user@example.com');
        await tester.enterText(textFields.at(3), 'Password123!');
        await tester.pumpAndSettle();

        // Act - emit SignUpSuccess
        signupStateController.add(SignUpSuccess());
        await tester.pumpAndSettle();

        // Press confirm on dialog
        final dialogButton = find.descendant(
          of: find.byType(CustomSuccessDialog),
          matching: find.byType(CustomMaterialButton),
        );
        await tester.tap(dialogButton);
        await tester.pumpAndSettle();

        // Assert
        expect(poppedArgs, isNotNull);
        expect(poppedArgs!.email, equals('user@example.com'));
        expect(poppedArgs!.password, equals('Password123!'));
        expect(find.byType(RegisterView), findsNothing);
      },
    );

    testWidgets(
      'should show error toast with message when SignUpFailure state is emitted',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        AppToast.isEnabled = true;
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act
        const errorMessage = 'فشل إنشاء الحساب';
        signupStateController.add(SignUpFailure(errorMessage));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));

        // Assert
        expect(find.text(errorMessage, skipOffstage: false), findsOneWidget);

        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      'should trigger pop when AuthRedirectText login action is tapped',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Act
        final authRedirect = find.byType(AuthRedirectText);
        final textWidget = tester.widget<Text>(
          find.descendant(of: authRedirect, matching: find.byType(Text)),
        );
        final rootSpan = textWidget.textSpan as TextSpan;
        final actionSpan = rootSpan.children![2] as TextSpan;
        final recognizer = actionSpan.recognizer as TapGestureRecognizer?;
        recognizer?.onTap?.call();
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RegisterView), findsNothing);
      },
    );

    testWidgets('should trigger pop when CustomAppBar arrow back is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      setPhoneViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RegisterView), findsNothing);
    });
  });
}
