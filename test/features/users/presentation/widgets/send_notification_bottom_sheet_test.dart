import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/send_notification_input_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/send_notification_bottom_sheet.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockUserNotificationsCubit extends MockCubit<UserNotificationsState>
    implements UserNotificationsCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const SendNotificationInputEntity(
        userId: '1',
        titleAr: 'عربي',
        titleEn: 'English',
        bodyAr: 'محتوى عربي',
        bodyEn: 'English body',
      ),
    );
  });

  late MockUserNotificationsCubit mockCubit;
  late StreamController<UserNotificationsState> stateController;

  setUp(() {
    mockCubit = MockUserNotificationsCubit();
    stateController = StreamController<UserNotificationsState>.broadcast();

    when(() => mockCubit.state).thenReturn(UserNotificationsInitial());
    when(() => mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockCubit.sendNotification(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    stateController.close();
  });

  group('SendNotificationBottomSheet Widget Tests', () {
    testWidgets('should render all fields and send button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: BlocProvider<UserNotificationsCubit>.value(
            value: mockCubit,
            child: const Scaffold(
              body: SendNotificationBottomSheet(
                userId: 'user_1',
                userName: 'Ahmed',
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(AppStrings.sendNotification), findsOneWidget);
      expect(find.text(AppStrings.notificationTitleAr), findsOneWidget);
      expect(find.text(AppStrings.notificationTitleEn), findsOneWidget);
      expect(find.text(AppStrings.notificationBodyAr), findsOneWidget);
      expect(find.text(AppStrings.notificationBodyEn), findsOneWidget);
      expect(find.text(AppStrings.send), findsOneWidget);
    });

    testWidgets(
      'should trigger validation errors when sending with empty fields',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockCubit,
              child: const Scaffold(
                body: SendNotificationBottomSheet(
                  userId: 'user_1',
                  userName: 'Ahmed',
                ),
              ),
            ),
          ),
        );

        // Act: Tap send button without typing
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pumpAndSettle();

        // Assert: sendNotification should never be called
        verifyNever(() => mockCubit.sendNotification(any()));
      },
    );

    testWidgets(
      'should call cubit.sendNotification when form is filled and submitted',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockCubit,
              child: const Scaffold(
                body: SendNotificationBottomSheet(
                  userId: 'user_1',
                  userName: 'Ahmed',
                ),
              ),
            ),
          ),
        );

        // Act: Enter valid input into all 4 text fields
        final textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(4));

        await tester.enterText(textFields.at(0), 'عنوان عربي');
        await tester.enterText(textFields.at(1), 'English Title');
        await tester.enterText(textFields.at(2), 'نص الرسالة بالعربي');
        await tester.enterText(textFields.at(3), 'English message body');
        await tester.pump();

        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockCubit.sendNotification(
            any(
              that: isA<SendNotificationInputEntity>()
                  .having((e) => e.userId, 'userId', 'user_1')
                  .having((e) => e.titleAr, 'titleAr', 'عنوان عربي')
                  .having((e) => e.titleEn, 'titleEn', 'English Title')
                  .having((e) => e.bodyAr, 'bodyAr', 'نص الرسالة بالعربي')
                  .having((e) => e.bodyEn, 'bodyEn', 'English message body'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('should open bottom sheet via static show method', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => SendNotificationBottomSheet.show(
                  context,
                  userId: 'user_1',
                  userName: 'Ahmed',
                  cubit: mockCubit,
                ),
                child: const Text('Open BottomSheet'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Open BottomSheet'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SendNotificationBottomSheet), findsOneWidget);
    });
  });
}
