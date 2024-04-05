// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/core/utils/utils.dart';

import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:parkinson/widgets/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  // TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: appTheme.cyan300,
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.v),
                child: Column(children: [
                  SizedBox(height: 70.v),
                  _buildPageTitle(context),
                  SizedBox(height: 32.v),
                  CustomTextFormField(
                      controller: emailController,
                      hintText: "Email",
                      textInputType: TextInputType.emailAddress,
                      prefix: Container(
                          margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
                          child: CustomImageView(
                              imagePath: ImageConstant.imgMail,
                              height: 24.adaptSize,
                              width: 24.adaptSize)),
                      prefixConstraints: BoxConstraints(maxHeight: 48.v)),
                  // SizedBox(height: 8.v),
                  // CustomTextFormField(
                  //     controller: passwordController,
                  //     hintText: "password",
                  //     textInputAction: TextInputAction.done,
                  //     textInputType: TextInputType.visiblePassword,
                  //     prefix: Container(
                  //         margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
                  //         child: CustomImageView(
                  //             imagePath: ImageConstant.imgLock,
                  //             height: 24.adaptSize,
                  //             width: 24.adaptSize)),
                  //     prefixConstraints: BoxConstraints(maxHeight: 48.v),
                  //     obscureText: true),
                  SizedBox(height: 27.v),
                  CustomElevatedButton(
                    text: "Reset Password",
                    buttonStyle: CustomButtonStyles.fillPrimary,
                    buttonTextStyle: CustomTextStyles.titleSmallTeal300,
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text.trim());
                          if (context.mounted) {
                            Utils().showMessage(context,
                                'Password reset link sent to ${emailController.text.trim()}');
                          }
                        } on FirebaseAuthException catch (exception) {
                          if (context.mounted) {
                            Utils().showMessage(
                                context, exception.message.toString());
                          }
                        }
                      }
                    },
                  ),
                  // SizedBox(height: 24.v),
                  // Spacer(),
                  // GestureDetector(
                  //     onTap: () {
                  //       onTapTxtDonthaveanaccount(context);
                  //     },
                  //     child: RichText(
                  //         text: TextSpan(children: [
                  //           TextSpan(
                  //               text: "don't have an account",
                  //               style: CustomTextStyles.bodySmallPrimary_1),
                  //           TextSpan(text: " "),
                  //           TextSpan(
                  //               text: "register",
                  //               style: CustomTextStyles.labelLargePrimaryBold)
                  //         ]),
                  //         textAlign: TextAlign.left))
                ]))));
  }

  /// Section Widget
  Widget _buildPageTitle(BuildContext context) {
    return Column(children: [
      CustomImageView(
          imagePath: ImageConstant.imgHiDocLogo42x115,
          height: 65.v,
          width: 115.h),
      SizedBox(height: 26.v),
      Text("Forgotten Password",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
      SizedBox(height: 12.v),
      Text("Enter your email and we send you a password reset link.",
          style: CustomTextStyles.labelLargePoppinsPrimaryBold)
    ]);
  }

  /// Navigates to the signupScreen when the action is triggered.
  // onTapResetPassword(BuildContext context) {
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MainActivity(),
  //     ));
  // }

  // /// Navigates to the signupScreen when the action is triggered.
  // onTapTxtDonthaveanaccount(BuildContext context) {
  //   Navigator.pushNamed(context, AppRoutes.signupScreen);
  // }
}
