import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/views/products_view.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/views/settings_view.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/views/users_view.dart';
import '../../features/auth/presentation/args/login_args.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/orders/presentation/views/orders_view.dart';
import '../../features/products/presentation/managers/products_cubit/products_cubit.dart';
import '../../features/products/presentation/views/product_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';

class AppRouter {
  RouteSettings? _currentSettings;

  Route? generateRoute(RouteSettings settings) {
    _currentSettings = settings;

    switch (settings.name) {
      case Routes.splashView:
        return _route(const AnimatedSplashView());
      case Routes.loginView:
        final args = _currentSettings!.arguments as LoginArgs?;
        return _route(LoginView(loginArgs: args));
      case Routes.registerView:
        return _route(const RegisterView());
      case Routes.forgetPasswordView:
        return _route(const ForgetPasswordView());
      case Routes.dashboardView:
        return _route(const DashboardView());
      case Routes.productsView:
        return _route(const ProductsView());
      case Routes.productView:
        final args = _currentSettings!.arguments as List;
        return _route(
          BlocProvider<ProductsCubit>.value(
            value: args[0] as ProductsCubit,
            child: ProductView(
              fruitEntity: args.length > 1 ? args[1] as FruitEntity? : null,
            ),
          ),
        );
      case Routes.usersView:
        return CupertinoPageRoute(builder: (_) => const UsersView());
      case Routes.settingsView:
        return CupertinoPageRoute(builder: (_) => const SettingsView());
      case Routes.ordersView:
        return CupertinoPageRoute(builder: (_) => const OrdersView());
      // case Routes.analyticsView:
      //   return CupertinoPageRoute(builder: (_) => const OrdersView());
      default:
        return null;
    }
  }

  PageRouteBuilder<dynamic> _route(Widget view) => PageRouteBuilder(
    settings: _currentSettings,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) => view,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0.08, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}
