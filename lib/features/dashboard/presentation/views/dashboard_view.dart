import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/dependency_injection.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';
import 'package:fruit_hub_dashboard/features/dashboard/domain/entities/entities/dashboard_item_entity.dart';
import '../widgets/custom_dashboard_app_bar.dart';
import '../widgets/dashboard_item.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardItems = getDashboardItems(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocProvider(
          create: (context) => SignOutCubit(getIt.get<SignOutUseCase>()),
          child: const CustomDashboardAppBar(),
        ),
      ),
      body: GridView.builder(
        itemCount: dashboardItems.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          var item = dashboardItems[index];
          return DashboardItem(entity: item);
        },
      ),
    );
  }
}
