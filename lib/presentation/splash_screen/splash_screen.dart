import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/presentation/onboarding/tabs/pageview_screen.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:parkinson/widgets/custom_outlined_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: appTheme.cyan300,
        body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 46.v),
            child: Column(children: [
              Spacer(),
              CustomImageView(
                  imagePath: ImageConstant.imgHiDocLogo,
                  height: 368.v,
                  width: 338.h),
              SizedBox(height: 87.v),
              CustomOutlinedButton(
                  text: "Login",
                  margin: EdgeInsets.only(right: 6.h),
                  onPressed: () {
                    onTapLogin(context);
                  }),
              SizedBox(height: 15.v),
              CustomElevatedButton(
                  text: "Sign up",
                  margin: EdgeInsets.only(right: 6.h),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  buttonTextStyle: CustomTextStyles.titleSmallTeal300,
                  onPressed: () {
                    onTapSignUp(context);
                  })
            ])));
  }

  /// Navigates to the loginScreen when the action is triggered.
  onTapLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  /// Navigates to the signupScreen when the action is triggered.
  onTapSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageViewScreen()));
  }
}
