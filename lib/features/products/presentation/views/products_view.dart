import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/header_action_button.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../../domain/entities/fruit_entity.dart';
import '../managers/products_cubit/products_cubit.dart';
import '../widgets/products_empty_state.dart';
import '../widgets/products_grid_view.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<FruitEntity> _fruits = [];

  @override
  Widget build(BuildContext context) => BlocProvider<ProductsCubit>(
    create: (context) => getIt<ProductsCubit>()..getProducts(),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.products,
          showArrowBack: true,
          onTap: () => context.pop(),
          actions: [
            HeaderActionButton(
              label: AppStrings.add,
              icon: Icons.add_rounded,
              onTap: () => context.pushNamed(
                Routes.productView,
                arguments: [context.read<ProductsCubit>()],
              ),
            ),
            Gap(16.w),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: BlocConsumer<ProductsCubit, ProductsState>(
            listener: (context, state) {
              if (state is ProductsSuccess) {
                if (state.newItemAdded || state.itemUpdated) {
                  context.pop();
                  AppToast.show(
                    context: context,
                    title: state.newItemAdded
                        ? AppStrings.productAdded
                        : AppStrings.productUpdated,
                    type: ToastificationType.success,
                  );
                } else if (state.itemRemoved) {
                  AppToast.show(
                    context: context,
                    title: AppStrings.productRemoved,
                    type: ToastificationType.success,
                  );
                }
                _fruits = state.products;
              }
              if (state is ProductsFailure) {
                AppToast.show(
                  context: context,
                  title: state.errorMessage,
                  type: ToastificationType.error,
                );
              }
            },
            builder: (context, state) {
              if (state is ProductsSuccess) {
                if (state.products.isEmpty) {
                  return const ProductsEmptyState();
                }
                return ProductsGridView(fruits: state.products);
              } else if (state is ProductsLoading &&
                  !state.newItemAdded &&
                  !state.itemUpdated &&
                  !state.itemRemoved) {
                return const Skeletonizer(
                  enabled: true,
                  child: ProductsGridView(itemCount: 4),
                );
              } else if (_fruits.isNotEmpty) {
                return ProductsGridView(fruits: _fruits);
              } else {
                return Center(
                  child: Text(
                    AppStrings.somethingWentWrong,
                    style: AppTextStyles.font14Regular.copyWith(
                      color: context.colors.subText,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    ),
  );
}
