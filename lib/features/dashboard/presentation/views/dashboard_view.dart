import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';

import '../widgets/custom_dashboard_app_bar.dart';
import '../widgets/dashboard_view_body.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocProvider(
        create: (context) => SignOutCubit(getIt.get<SignOutUseCase>()),
        child: const CustomDashboardAppBar(),
      ),
    ),
    body: const DashboardViewBody(),
  );
}
