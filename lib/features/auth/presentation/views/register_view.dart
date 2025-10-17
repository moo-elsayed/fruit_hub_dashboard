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
import '../../domain/use_cases/create_user_with_email_and_password_use_case.dart';
import '../args/login_args.dart';
import '../managers/signup_cubit/sign_up_cubit.dart';
import '../widgets/auth_redirect_text.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/terms_and_conditions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignupCubit(getIt.get<CreateUserWithEmailAndPasswordUseCase>()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "New Account",
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(24.h),
                  TextFormFieldHelper(
                    controller: _nameController,
                    hint: "Full Name",
                    keyboardType: TextInputType.name,
                    onValidate: (value) => Validator.validateName(type: "Name",val: value),
                    action: TextInputAction.next,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _emailController,
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    onValidate: Validator.validateEmail,
                    action: TextInputAction.next,
                  ),
                  Gap(16.h),
                  TextFormFieldHelper(
                    controller: _passwordController,
                    hint: "Password",
                    isPassword: true,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.visiblePassword,
                    onValidate: Validator.validatePassword,
                    action: TextInputAction.done,
                  ),
                  Gap(16.h),
                  TermsAndConditions(
                    onChanged: (value) => _agreeToTerms = value,
                  ),
                  Gap(30.h),
                  BlocConsumer<SignupCubit, SignupState>(
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        AppToast.showToast(
                          context: context,
                          title: "Account created successfully",
                          type: ToastificationType.success,
                        );
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            text:
                                "A verification email has been sent to your inbox. Please check your email and verify your account to continue",
                            onPressed: () {
                              context.pop();
                              var loginArgs = LoginArgs(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                              context.pop(loginArgs);
                            },
                          ),
                        );
                      }
                      if (state is SignUpFailure) {
                        AppToast.showToast(
                          context: context,
                          title: state.message,
                          type: ToastificationType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!_agreeToTerms) {
                              AppToast.showToast(
                                context: context,
                                title: "You should accept terms and conditions",
                                type: ToastificationType.error,
                              );
                            } else {
                              context
                                  .read<SignupCubit>()
                                  .createUserWithEmailAndPassword(
                                    username: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                            }
                          }
                        },
                        maxWidth: true,
                        isLoading: state is SignUpLoading,
                        text: "Login",
                        textStyle: AppTextStyles.font16WhiteBold,
                      );
                    },
                  ),
                  Gap(33.h),
                  AuthRedirectText(
                    question: "Already have an account?",
                    action: "Login",
                    onTap: () => context.pop(),
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
