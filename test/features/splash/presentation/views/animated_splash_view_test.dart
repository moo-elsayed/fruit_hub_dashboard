import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/managers/splash_cubit/splash_cubit.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/views/animated_splash_view.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/widgets/animated_splash_view_body.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSplashCubit mockSplashCubit;
  late StreamController<SplashState> stateController;

  setUp(() {
    mockSplashCubit = MockSplashCubit();
    stateController = StreamController<SplashState>.broadcast();

    when(() => mockSplashCubit.state).thenReturn(SplashInitial());
    when(() => mockSplashCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockSplashCubit.checkAppStatus()).thenAnswer((_) async {});

    if (getIt.isRegistered<SplashCubit>()) {
      getIt.unregister<SplashCubit>();
    }
    getIt.registerFactory<SplashCubit>(() => mockSplashCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<SplashCubit>()) {
      getIt.unregister<SplashCubit>();
    }
  });

  group('AnimatedSplashView Widget Tests', () {
    testWidgets(
      'should render AnimatedSplashViewBody and trigger checkAppStatus on initState',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const AnimatedSplashView()),
        );
        await tester.pump(const Duration(milliseconds: 1500));

        // Assert
        expect(find.byType(AnimatedSplashViewBody), findsOneWidget);
        verify(() => mockSplashCubit.checkAppStatus()).called(1);
      },
    );

    testWidgets(
      'should render plant svg, light splash image, and bottom svg in light mode',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const AnimatedSplashView()),
        );
        await tester.pump(const Duration(milliseconds: 1500));

        // Assert
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SvgPicture &&
                widget.bytesLoader.toString().contains(AppAssets.svgsPlant),
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                (widget.image as AssetImage).assetName ==
                    AppAssets.imagesSplashAndroid12,
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SvgPicture &&
                widget.bytesLoader.toString().contains(
                  AppAssets.svgsSplashBottom,
                ),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render dark splash image in dark mode',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            themeMode: ThemeMode.dark,
            child: const AnimatedSplashView(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 1500));

        // Assert
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                (widget.image as AssetImage).assetName ==
                    AppAssets.imagesSplashAndroid12Dark,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should navigate to loginView when state is SplashNavigation.login',
      (WidgetTester tester) async {
        // Arrange
        String? currentRoute;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const AnimatedSplashView(),
            routes: {
              Routes.loginView: (_) {
                currentRoute = Routes.loginView;
                return const Scaffold(body: Text('Login'));
              },
            },
          ),
        );
        await tester.pump();

        // Act
        stateController.add(
          SplashNavigationState(SplashNavigation.login),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(currentRoute, equals(Routes.loginView));
        expect(find.text('Login'), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to dashboardView when state is SplashNavigation.home',
      (WidgetTester tester) async {
        // Arrange
        String? currentRoute;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const AnimatedSplashView(),
            routes: {
              Routes.dashboardView: (_) {
                currentRoute = Routes.dashboardView;
                return const Scaffold(body: Text('Dashboard'));
              },
            },
          ),
        );
        await tester.pump();

        // Act
        stateController.add(
          SplashNavigationState(SplashNavigation.home),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(currentRoute, equals(Routes.dashboardView));
        expect(find.text('Dashboard'), findsOneWidget);
      },
    );
  });
}
