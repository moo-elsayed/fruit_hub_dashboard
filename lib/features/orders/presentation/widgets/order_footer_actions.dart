import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';

class OrderFooterActions extends StatelessWidget {
  const OrderFooterActions({super.key, required this.orderEntity});

  final OrderEntity orderEntity;

  void _showUpdateStatusSheet(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    final items = OrderStatus.values
        .map(
          (status) => CustomBottomSheetSelectionItem(
            title: status.getName,
            value: status,
            isSelected: orderEntity.status == status,
            onTap: () => cubit.updateOrderStatus(orderEntity.docId, status),
          ),
        )
        .toList();

    CustomBottomSheet.show(
      context: context,
      title: AppStrings.updateOrderStatus,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) => CustomMaterialButton(
    onPressed: () => _showUpdateStatusSheet(context),
    text: AppStrings.updateStatus,
    textStyle: AppTextStyles.font13SemiBold.copyWith(
      color: orderEntity.status.color,
    ),
    textColor: orderEntity.status.color,
    icon: Icon(
      Icons.sync_alt_rounded,
      size: 16.sp,
      color: orderEntity.status.color,
    ),
    isTrailingIcon: false,
    backgroundColor: orderEntity.status.containerColor,
    side: BorderSide(color: orderEntity.status.color.withValues(alpha: 0.5)),
    borderRadius: BorderRadius.circular(10.r),
    padding: EdgeInsets.symmetric(vertical: 11.h),
    maxWidth: true,
  );
}
