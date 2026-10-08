import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/custom_dashboard_app_bar.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_banner_card.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_grid_view.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_item_widget.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_quick_actions_header.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_view_body.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSignOutCubit extends MockCubit<SignOutState>
    implements SignOutCubit {}

void main() {
  late MockSignOutCubit mockSignOutCubit;
  late StreamController<SignOutState> stateController;

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  setUp(() {
    AppToast.isEnabled = false;
    stateController = StreamController<SignOutState>.broadcast();
    mockSignOutCubit = MockSignOutCubit();

    when(() => mockSignOutCubit.state).thenReturn(SignOutInitial());
    when(() => mockSignOutCubit.stream)
        .thenAnswer((_) => stateController.stream);

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
        child: const DashboardView(),
      );

  group('DashboardView Widget Tests', () {
    testWidgets(
      'should render app bar, banner card, quick actions header, and all 5 dashboard items',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);

        // Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CustomDashboardAppBar), findsOneWidget);
        expect(find.byType(DashboardViewBody), findsOneWidget);
        expect(find.byType(DashboardBannerCard), findsOneWidget);
        expect(find.byType(DashboardQuickActionsHeader), findsOneWidget);
        expect(find.byType(DashboardGridView), findsOneWidget);
        expect(find.byType(DashboardItemWidget), findsNWidgets(5));

        expect(find.text(AppStrings.users), findsOneWidget);
        expect(find.text(AppStrings.products), findsOneWidget);
        expect(find.text(AppStrings.orders), findsOneWidget);
        expect(find.text(AppStrings.analytics), findsOneWidget);
        expect(find.text(AppStrings.settings), findsOneWidget);
      },
    );

    testWidgets('should navigate to usersView when Users item is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      setPhoneViewport(tester);
      var navigatedToUsers = false;
      await tester.pumpWidget(
        buildWidget(
          routes: {
            Routes.usersView: (_) {
              navigatedToUsers = true;
              return const Scaffold(body: Text('Users Screen'));
            },
          },
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(AppStrings.users));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatedToUsers, isTrue);
    });

    testWidgets(
      'should navigate to productsView when Products item is tapped',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        var navigatedToProducts = false;
        await tester.pumpWidget(
          buildWidget(
            routes: {
              Routes.productsView: (_) {
                navigatedToProducts = true;
                return const Scaffold(body: Text('Products Screen'));
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text(AppStrings.products));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToProducts, isTrue);
      },
    );

    testWidgets('should navigate to ordersView when Orders item is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      setPhoneViewport(tester);
      var navigatedToOrders = false;
      await tester.pumpWidget(
        buildWidget(
          routes: {
            Routes.ordersView: (_) {
              navigatedToOrders = true;
              return const Scaffold(body: Text('Orders Screen'));
            },
          },
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(AppStrings.orders));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatedToOrders, isTrue);
    });

    testWidgets(
      'should navigate to analyticsView when Analytics item is tapped',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        var navigatedToAnalytics = false;
        await tester.pumpWidget(
          buildWidget(
            routes: {
              Routes.analyticsView: (_) {
                navigatedToAnalytics = true;
                return const Scaffold(body: Text('Analytics Screen'));
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text(AppStrings.analytics));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToAnalytics, isTrue);
      },
    );

    testWidgets(
      'should navigate to settingsView when Settings item is tapped',
      (WidgetTester tester) async {
        // Arrange
        setPhoneViewport(tester);
        var navigatedToSettings = false;
        await tester.pumpWidget(
          buildWidget(
            routes: {
              Routes.settingsView: (_) {
                navigatedToSettings = true;
                return const Scaffold(body: Text('Settings Screen'));
              },
            },
          ),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text(AppStrings.settings));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToSettings, isTrue);
      },
    );
  });
}
