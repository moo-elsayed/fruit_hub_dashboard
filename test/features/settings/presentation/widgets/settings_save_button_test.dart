import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_save_button.dart';
import 'package:mocktail/mocktail.dart';

import 'package:toastification/toastification.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingsCubit mockSettingsCubit;
  late StreamController<SettingsState> stateController;

  setUp(() {
    mockSettingsCubit = MockSettingsCubit();
    stateController = StreamController<SettingsState>.broadcast();

    when(() => mockSettingsCubit.state).thenReturn(SettingsInitial());
    when(() => mockSettingsCubit.stream)
        .thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    toastification.dismissAll();
    stateController.close();
  });

  Widget buildWidget({
    required VoidCallback onSave,
    required VoidCallback onSuccess,
    bool withToastification = false,
  }) => createWidgetForTesting(
    withToastification: withToastification,
    child: BlocProvider<SettingsCubit>.value(
      value: mockSettingsCubit,
      child: SettingsSaveButton(onSave: onSave, onSuccess: onSuccess),
    ),
  );

  group('SettingsSaveButton Widget Tests', () {
    testWidgets(
      'should render saveChanges text and invoke onSave when tapped',
      (WidgetTester tester) async {
        // Arrange
        var saved = false;
        var succeeded = false;
        await tester.pumpWidget(
          buildWidget(
            onSave: () => saved = true,
            onSuccess: () => succeeded = true,
          ),
        );

        // Assert
        expect(find.byType(CustomMaterialButton), findsOneWidget);
        expect(find.text(AppStrings.saveChanges), findsOneWidget);

        // Act
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert
        expect(saved, isTrue);
        expect(succeeded, isFalse);
      },
    );

    testWidgets(
      'should display loading indicator when state is UpdatingShippingConfigLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockSettingsCubit.state)
            .thenReturn(UpdatingShippingConfigLoading());

        // Act
        await tester.pumpWidget(buildWidget(onSave: () {}, onSuccess: () {}));

        // Assert
        final button = tester.widget<CustomMaterialButton>(
          find.byType(CustomMaterialButton),
        );
        expect(button.isLoading, isTrue);
      },
    );

    testWidgets(
      'should trigger onSuccess and show success toast when state is UpdatingShippingConfigSuccess',
      (WidgetTester tester) async {
        // Arrange
        var succeeded = false;
        await tester.pumpWidget(
          buildWidget(
            onSave: () {},
            onSuccess: () => succeeded = true,
            withToastification: true,
          ),
        );

        // Act: emit UpdatingShippingConfigSuccess
        stateController.add(UpdatingShippingConfigSuccess());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(succeeded, isTrue);
        expect(
          find.text(AppStrings.success, skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.text(
            AppStrings.settingsUpdatedSuccessfully,
            skipOffstage: false,
          ),
          findsOneWidget,
        );

        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 3));
      },
    );
  });
}
