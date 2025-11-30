import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theming/app_colors.dart';
import '../../domain/entities/fruit_entity.dart';
import '../managers/products_cubit/products_cubit.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<FruitEntity> fruits = [];

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsetsGeometry.only(top: 10.h),
                child: CustomAppBar(
                  title: "Products",
                  showArrowBack: true,
                  onTap: () => context.pop(),
                ),
              ),
            ),
          ),
          // SliverAppBar(
          //   pinned: true,
          //   floating: false,
          //   snap: false,
          //   automaticallyImplyLeading: false,
          //   backgroundColor: AppColors.white,
          //   surfaceTintColor: AppColors.white,
          //   toolbarHeight: 0,
          //   bottom: PreferredSize(
          //     preferredSize: Size.fromHeight(52.h),
          //     child: Padding(
          //       padding: EdgeInsetsGeometry.symmetric(
          //         horizontal: 16.w,
          //         vertical: 8.h,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "products",
          //             style: AppTextStyles.font16color0C0D0DBold,
          //           ),
          //           BlocBuilder<ProductsCubit, ProductsState>(
          //             builder: (context, state) {
          //               var cubit = context.read<ProductsCubit>();
          //               bool isFilterActive = cubit.selectedSortOption != -1;
          //               return AnimatedContainer(
          //                 duration: const Duration(milliseconds: 200),
          //                 padding: EdgeInsets.symmetric(
          //                   horizontal: 12.w,
          //                   vertical: 6.h,
          //                 ),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(4.r),
          //                   ),
          //                   color: isFilterActive
          //                       ? AppColors.color1B5E37.withValues(alpha: 0.1)
          //                       : Colors.transparent,
          //                   border: Border.all(
          //                     color: isFilterActive
          //                         ? AppColors.color1B5E37
          //                         : AppColors.colorEAEBEB,
          //                   ),
          //                 ),
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     showModalBottomSheet(
          //                       context: context,
          //                       builder: (_) => BlocProvider.value(
          //                         value: context.read<ProductsCubit>(),
          //                         child: const SortProductsBottomSheet(),
          //                       ),
          //                     );
          //                   },
          //                   child: SvgPicture.asset(Assets.iconsFilter),
          //                 ),
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
        body: Padding(
          padding: EdgeInsetsGeometry.only(top: 10.h),
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is GetProductsSuccess) {
                fruits = state.products;
                return ProductsGridView(fruits: fruits);
              } else if (state is GetProductsLoading) {
                return const Skeletonizer(
                  enabled: true,
                  child: ProductsGridView(itemCount: 6),
                );
              } else {
                return const Text("error");
              }
            },
          ),
        ),
      ),
    );
  }
}
