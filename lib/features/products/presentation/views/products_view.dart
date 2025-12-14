import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/helpers/di.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../domain/entities/fruit_entity.dart';
import '../../domain/use_cases/add_product_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../domain/use_cases/update_product_use_case.dart';
import '../managers/products_cubit/products_cubit.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<FruitEntity> _fruits = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(
        getIt.get<AddProductUseCase>(),
        getIt.get<GetProductsUseCase>(),
        getIt.get<DeleteProductUseCase>(),
        getIt.get<UpdateProductUseCase>(),
      )..getProducts(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: "Products",
              showArrowBack: true,
              onTap: () => context.pop(),
            ),
            body: Padding(
              padding: .only(top: 10.h),
              child: BlocConsumer<ProductsCubit, ProductsState>(
                listener: (context, state) {
                  if (state is ProductsSuccess) {
                    if ((state.itemRemoved ||
                        state.newItemAdded ||
                        state.itemUpdated)) {
                      context.pop();
                      AppToast.showToast(
                        context: context,
                        title: state.newItemAdded
                            ? "product added"
                            : state.itemUpdated
                            ? "product updated"
                            : "product removed",
                        type: .success,
                      );
                    }
                    _fruits = state.products;
                  }
                  if (state is ProductsLoading && state.itemRemoved) {
                    AppDialogs.showLoadingDialog(context);
                  }
                  if (state is ProductsFailure) {
                    AppToast.showToast(
                      context: context,
                      title: state.errorMessage,
                      type: .error,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProductsSuccess ||
                      (state is ProductsLoading && state.itemRemoved)) {
                    return ProductsGridView(fruits: _fruits);
                  } else if (state is ProductsLoading && !state.itemRemoved) {
                    return const Skeletonizer(
                      enabled: true,
                      child: ProductsGridView(itemCount: 6),
                    );
                  } else {
                    return const Center(child: Text("error"));
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.pushNamed(
                Routes.productView,
                arguments: [context.read<ProductsCubit>()],
              ),
              backgroundColor: AppColors.color1B5E37,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
