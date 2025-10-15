import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/helpers/dependency_injection.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../args/login_args.dart';
import '../managers/forget_password_cubit/forget_password_cubit.dart';
import '../widgets/custom_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Password Reset",
        showArrowBack: true,
        onTap: () => context.pop(),
      ),
      body: BlocProvider(
        create: (context) =>
            ForgetPasswordCubit(getIt.get<ForgetPasswordUseCase>()),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(24.h),
                  Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: AppTextStyles.font16color616A6BSemiBold,
                  ),
                  Gap(30.h),
                  TextFormFieldHelper(
                    controller: _emailController,
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    onValidate: Validator.validateEmail,
                    action: TextInputAction.done,
                  ),
                  Gap(16.h),
                  BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                    listener: (context, state) {
                      if (state is ForgetPasswordSuccess) {
                        AppToast.showToast(
                          context: context,
                          title: "Email Sent Successfully",
                          type: ToastificationType.success,
                        );
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            text:
                                "An email has been sent to your address with instructions to reset your password.",
                            onPressed: () {
                              context.pop();
                              var loginArgs = LoginArgs(
                                email: _emailController.text.trim(),
                                password: "",
                              );
                              context.pop(loginArgs);
                            },
                          ),
                        );
                      }
                      if (state is ForgetPasswordFailure) {
                        AppToast.showToast(
                          context: context,
                          title: state.errorMessage,
                          type: ToastificationType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ForgetPasswordCubit>().forgetPassword(
                              _emailController.text,
                            );
                          }
                        },
                        maxWidth: true,
                        text: "Reset Password",
                        textStyle: AppTextStyles.font16WhiteBold,
                        isLoading: state is ForgetPasswordLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
