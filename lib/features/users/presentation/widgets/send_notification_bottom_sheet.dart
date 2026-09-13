import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/helpers/validator.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet_handle.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:toastification/toastification.dart';

import '../../domain/entities/send_notification_input_entity.dart';
import '../managers/user_notifications_cubit/user_notifications_cubit.dart';

class SendNotificationBottomSheet extends StatefulWidget {
  const SendNotificationBottomSheet({
    super.key,
    required this.userId,
    required this.userName,
  });

  final String userId;
  final String userName;

  static void show(
    BuildContext context, {
    required String userId,
    required String userName,
    required UserNotificationsCubit cubit,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SendNotificationBottomSheet(userId: userId, userName: userName),
      ),
    );
  }

  @override
  State<SendNotificationBottomSheet> createState() =>
      _SendNotificationBottomSheetState();
}

class _SendNotificationBottomSheetState
    extends State<SendNotificationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleArController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _bodyArController;
  late final TextEditingController _bodyEnController;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController();
    _titleEnController = TextEditingController();
    _bodyArController = TextEditingController();
    _bodyEnController = TextEditingController();
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _bodyArController.dispose();
    _bodyEnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomKeyboardUnfocus(
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: context.colors.border),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.h,
              children: [
                const CustomBottomSheetHandle(),
                Text(
                  AppStrings.sendNotification,
                  style: AppTextStyles.font16Bold.copyWith(
                    color: context.colors.mainText,
                  ),
                ),
                TextFormFieldHelper(
                  controller: _titleArController,
                  hint: AppStrings.notificationTitleAr,
                  action: TextInputAction.next,
                  onValidate: Validator.validateRequiredField,
                ),
                TextFormFieldHelper(
                  controller: _titleEnController,
                  hint: AppStrings.notificationTitleEn,
                  action: TextInputAction.next,
                  onValidate: Validator.validateRequiredField,
                ),
                TextFormFieldHelper(
                  controller: _bodyArController,
                  hint: AppStrings.notificationBodyAr,
                  maxLines: 2,
                  action: TextInputAction.next,
                  onValidate: Validator.validateRequiredField,
                ),
                TextFormFieldHelper(
                  controller: _bodyEnController,
                  hint: AppStrings.notificationBodyEn,
                  maxLines: 2,
                  action: TextInputAction.done,
                  onValidate: Validator.validateRequiredField,
                ),
                BlocConsumer<UserNotificationsCubit, UserNotificationsState>(
                  listenWhen: (previous, current) =>
                      current is SendNotificationSuccess ||
                      current is SendNotificationFailure,
                  buildWhen: (previous, current) =>
                      current is SendNotificationLoading ||
                      current is SendNotificationSuccess ||
                      current is SendNotificationFailure,
                  listener: (context, state) {
                    if (state is SendNotificationSuccess) {
                      AppToast.show(
                        context: context,
                        title: AppStrings.notificationSentSuccessfully,
                        type: ToastificationType.success,
                      );
                      context.pop();
                    }
                    if (state is SendNotificationFailure) {
                      AppToast.show(
                        context: context,
                        title: state.message,
                        type: ToastificationType.error,
                      );
                    }
                  },
                  builder: (context, state) => CustomMaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final input = SendNotificationInputEntity(
                          userId: widget.userId,
                          titleAr: _titleArController.text.trim(),
                          titleEn: _titleEnController.text.trim(),
                          bodyAr: _bodyArController.text.trim(),
                          bodyEn: _bodyEnController.text.trim(),
                        );
                        context.read<UserNotificationsCubit>().sendNotification(
                          input,
                        );
                      }
                    },
                    maxWidth: true,
                    isLoading: state is SendNotificationLoading,
                    text: AppStrings.send,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
