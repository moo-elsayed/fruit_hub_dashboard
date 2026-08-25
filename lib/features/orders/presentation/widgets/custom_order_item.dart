import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/entities/bottom_sheet_selection_item_entity.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:gap/gap.dart';
import '../../../../core/enums/order_status.dart';
import '../../domain/entities/order_entity.dart';

class CustomOrderItem extends StatelessWidget {
  const CustomOrderItem({super.key, required this.orderEntity});

  final OrderEntity orderEntity;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    color: context.colors.surface,
    child: ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      visualDensity: VisualDensity.compact,
      shape: const Border(),
      leading: _buildLeadingIcon(context),
      title: _buildHeader(context),
      subtitle: _buildSubtitle(context),
      trailing: _buildPriceBadge(context),
      children: [
        const Divider(height: 1, thickness: 0.5),
        _buildCustomerDetails(context),
        const Divider(height: 1, thickness: 0.5),
        _buildProductsList(context),
        _buildFooterActions(context),
      ],
    ),
  );

  Widget _buildLeadingIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (orderEntity.paymentOption.type) {
      case .paypal:
        icon = Icons.paypal;
        color = AppPalette.info;
      case .card:
        icon = Icons.credit_card;
        color = AppPalette.secondaryOrange;
      case .cash:
        icon = Icons.attach_money;
        color = AppPalette.accentGreen;
    }

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildHeader(BuildContext context) => Row(
    children: [
      Text(
        'Order #${orderEntity.orderId}',
        style: AppTextStyles.font16Bold.copyWith(
          color: context.colors.mainText,
        ),
      ),
      Gap(10.w),
      _buildStatusBadge(),
    ],
  );

  Widget _buildStatusBadge() {
    final status = orderEntity.status;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: status.containerColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: status.color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.name,
        style: AppTextStyles.font10Bold.copyWith(color: status.color),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 6.h),
    child: Wrap(
      spacing: 12.w,
      runSpacing: 4.h,
      children: [
        _buildSubtitleItem(
          context: context,
          icon: Icons.calendar_today_outlined,
          title: _formatDate(orderEntity.date),
        ),
        _buildSubtitleItem(
          context: context,
          icon: Icons.person_outline,
          title: orderEntity.address.name.isNotEmpty
              ? orderEntity.address.name
              : 'Unknown User',
        ),
        _buildSubtitleItem(
          context: context,
          icon: Icons.shopping_bag_outlined,
          title: '${orderEntity.products.length} Items',
        ),
      ],
    ),
  );

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    return date.length > 10 ? date.substring(0, 10) : date;
  }

  Row _buildSubtitleItem({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 2.w,
    children: [
      Icon(icon, size: 14.sp, color: context.colors.subText),
      Text(
        title,
        style: AppTextStyles.font12Regular.copyWith(
          color: context.colors.subText,
        ),
      ),
    ],
  );

  Widget _buildPriceBadge(BuildContext context) {
    final total = orderEntity.totalPrice;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 2.h,
      children: [
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: AppTextStyles.font13Bold.copyWith(
            color: context.colors.primary,
          ),
        ),
        Text(
          orderEntity.paymentOption.type.name.toUpperCase(),
          style: AppTextStyles.font11SemiBold.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDetails(BuildContext context) {
    final address = orderEntity.address;
    return Container(
      padding: EdgeInsets.all(16.r),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: AppTextStyles.font13Bold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          Gap(5.h),
          Text(
            '${address.streetName}, ${address.buildingNumber}, ${address.city}',
            style: AppTextStyles.font13SemiBold.copyWith(
              color: context.colors.subText,
            ),
          ),
          Text(
            'Phone: ${address.phone}',
            style: AppTextStyles.font13SemiBold.copyWith(
              color: context.colors.subText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: orderEntity.products.length,
    separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
    itemBuilder: (context, index) {
      final product = orderEntity.products[index];
      return ListTile(
        dense: true,
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
          child: CustomNetworkImage(image: product.imagePath),
        ),
        title: Text(
          product.name,
          style: AppTextStyles.font13Bold.copyWith(
            color: context.colors.mainText,
          ),
        ),
        subtitle: Text(
          'Code: ${product.code}',
          style: AppTextStyles.font13SemiBold.copyWith(
            color: context.colors.subText,
          ),
        ),
        trailing: Text(
          '${product.quantity} x \$${product.price}',
          style: AppTextStyles.font13Bold.copyWith(
            color: context.colors.primary,
          ),
        ),
      );
    },
  );

  Widget _buildFooterActions(BuildContext context) => Padding(
    padding: EdgeInsets.all(12.r),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _showUpdateStatusSheet(context),
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 16.sp,
                color: context.colors.info,
              ),
              Gap(4.w),
              Text(
                'Update Status',
                style: AppTextStyles.font13SemiBold.copyWith(
                  color: context.colors.info,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: Text(
            'Print Invoice',
            style: AppTextStyles.font13SemiBold.copyWith(
              color: context.colors.subText,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );

  void _showUpdateStatusSheet(BuildContext context) {
    final List<BottomSheetSelectionItemEntity> items = OrderStatus.values
        .map(
          (status) => BottomSheetSelectionItemEntity(
            title: status.getName,
            color: status.color,
            isSelected: orderEntity.status == status,
            onTap: () {
              context.pop();
              context.read<OrdersCubit>().updateOrderStatus(
                orderEntity.docId,
                status,
              );
            },
          ),
        )
        .toList();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) =>
          CustomBottomSheet(title: 'Update Order Status', items: items),
    );
  }
}
