import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/delivery_fees_container.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_currency_field.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_save_button.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/shipping_notification_toggle_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const ShippingConfigEntity());
  });

  late MockSettingsCubit mockSettingsCubit;

  const tConfig = ShippingConfigEntity(
    shippingCost: 50.0,
    freeShippingThreshold: 350.0,
  );

  setUp(() {
    mockSettingsCubit = MockSettingsCubit();

    when(() => mockSettingsCubit.state).thenReturn(SettingsInitial());
    when(() => mockSettingsCubit.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockSettingsCubit.updateShippingConfig(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    toastification.dismissAll();
  });

  Widget buildWidget({
    ShippingConfigEntity config = tConfig,
    bool withToastification = false,
  }) => createWidgetForTesting(
    withToastification: withToastification,
    child: SingleChildScrollView(
      child: BlocProvider<SettingsCubit>.value(
        value: mockSettingsCubit,
        child: DeliveryFeesContainer(config: config),
      ),
    ),
  );

  group('DeliveryFeesContainer Widget Tests', () {
    testWidgets(
      'should render deliveryFees, freeShippingThreshold fields, toggle tile, and save button with initial values',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        expect(find.byType(SettingsCurrencyField), findsNWidgets(2));
        expect(find.byType(ShippingNotificationToggleTile), findsOneWidget);
        expect(find.byType(SettingsSaveButton), findsOneWidget);
        expect(find.text(AppStrings.deliveryFees), findsOneWidget);
        expect(find.text(AppStrings.freeShippingThreshold), findsOneWidget);
        expect(find.text('50'), findsWidgets);
        expect(find.text('350'), findsWidgets);
      },
    );

    testWidgets(
      'should display validation error when shipping cost is cleared and save button is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act: clear the first text field (shipping cost)
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, '');
        await tester.ensureVisible(find.byType(CustomMaterialButton));
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert
        expect(find.text(AppStrings.requiredField), findsOneWidget);
        verifyNever(() => mockSettingsCubit.updateShippingConfig(any()));
      },
    );

    testWidgets(
      'should show toast with noChangesToSave when save is tapped without modifying values and notify is false',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(withToastification: true));

        // Act: tap save button with initial unchanged values
        await tester.ensureVisible(find.byType(CustomMaterialButton));
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(
          find.text(AppStrings.noChangesToSave, skipOffstage: false),
          findsOneWidget,
        );
        verifyNever(() => mockSettingsCubit.updateShippingConfig(any()));

        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 3));
      },
    );

    testWidgets(
      'should call updateShippingConfig when delivery fee is modified and saved',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act: change shipping cost to 75
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, '75');
        await tester.ensureVisible(find.byType(CustomMaterialButton));
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert
        verify(
          () => mockSettingsCubit.updateShippingConfig(
            any(
              that: predicate<ShippingConfigEntity>(
                (entity) =>
                    entity.shippingCost == 75.0 &&
                    entity.freeShippingThreshold == 350.0 &&
                    entity.broadcastNotification == null,
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should call updateShippingConfig with broadcastNotification when notify switch is toggled and saved',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act: toggle notify switch on and save
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byType(CustomMaterialButton));
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert
        verify(
          () => mockSettingsCubit.updateShippingConfig(
            any(
              that: predicate<ShippingConfigEntity>(
                (entity) =>
                    entity.shippingCost == 50.0 &&
                    entity.freeShippingThreshold == 350.0 &&
                    entity.broadcastNotification != null &&
                    entity.broadcastNotification!.notify == true,
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should update text controllers when widget config property updates',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(config: tConfig));
        expect(find.text('50'), findsWidgets);

        // Act: update widget with new config
        const updatedConfig = ShippingConfigEntity(
          shippingCost: 80.0,
          freeShippingThreshold: 500.0,
        );
        await tester.pumpWidget(buildWidget(config: updatedConfig));
        await tester.pump();

        // Assert
        expect(find.text('80'), findsWidgets);
        expect(find.text('500'), findsWidgets);
      },
    );
  });
}
