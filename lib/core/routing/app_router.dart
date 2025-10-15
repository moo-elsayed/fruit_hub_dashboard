import 'package:flutter/cupertino.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import '../../animated_splash_view.dart';
import '../../features/auth/presentation/args/login_args.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/product/presentation/views/add_product_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.dashboardView:
        return CupertinoPageRoute(builder: (_) => const DashboardView());
      case Routes.addProductView:
        return CupertinoPageRoute(builder: (_) => const AddProductView());
      case Routes.splashView:
        return CupertinoPageRoute(
          builder: (context) => const AnimatedSplashView(),
        );
      case Routes.loginView:
        final args = arguments as LoginArgs?;
        return CupertinoPageRoute(
          builder: (context) => LoginView(loginArgs: args),
        );
      case Routes.registerView:
        return CupertinoPageRoute(builder: (context) => const RegisterView());
      case Routes.forgetPasswordView:
        return CupertinoPageRoute(
          builder: (context) => const ForgetPasswordView(),
        );
      default:
        return null;
    }
  }
}
