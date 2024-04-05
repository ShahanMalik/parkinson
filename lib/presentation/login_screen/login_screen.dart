// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/core/utils/utils.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:parkinson/presentation/add_user_detail_screen/add_user_detail_screen.dart';
import 'package:parkinson/presentation/onboarding/tabs/pageview_screen.dart';
import 'package:parkinson/services/chat_servvices/screen/home_screen.dart';
import 'package:parkinson/services/notification_services/home_screen.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:parkinson/widgets/custom_text_form_field.dart';
import 'package:parkinson/widgets/image_compressor_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List<String> user = ["patient", "doctor"];

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String loginPageRadioValue = "doctors";
  bool isload = false;
  SharedPreferences? prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setsharedPres();
  }

  void setsharedPres() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    print(loginPageRadioValue);
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: appTheme.cyan300,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.v),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                SizedBox(height: 8.v),
                CustomTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    prefix: Container(
                        margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
                        child: CustomImageView(
                            imagePath: ImageConstant.imgLock,
                            height: 24.adaptSize,
                            width: 24.adaptSize)),
                    prefixConstraints: BoxConstraints(maxHeight: 48.v),
                    obscureText: true),
                SizedBox(height: 20.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTapTxtForgotPassword(context);
                      },
                      child: Text(
                        "Forgot Password",
                        style: CustomTextStyles.labelLargePrimaryBold,
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 20.v),
                Row(
                  children: [
                    Radio(
                      value: 'doctors',
                      groupValue: loginPageRadioValue,
                      onChanged: (value) {
                        setState(() {
                          loginPageRadioValue = "doctors";
                        });
                      },
                    ),
                    Text("Doctor"),
                    Radio(
                      value: 'patients',
                      groupValue: loginPageRadioValue,
                      onChanged: (value) {
                        setState(() {
                          loginPageRadioValue = "patients";
                        });
                      },
                    ),
                    Text("Patient"),
                  ],
                ),
                SizedBox(height: 20.v),
                CustomElevatedButton(
                  text: "Sign In",
                  isloading: isload,
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  buttonTextStyle: CustomTextStyles.titleSmallTeal300,
                  onPressed: () async {
                    setState(() {
                      isload = true;
                    });
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        )
                            .then((value) async {
                          final personQuery = await FirebaseFirestore.instance
                              .collection(loginPageRadioValue)
                              .where('email',
                                  isEqualTo: emailController.text.trim())
                              .get();

                          if (personQuery.docs.isNotEmpty) {
                            final person = personQuery.docs.first;
                            setState(() {
                              isload = false;
                            });
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            await prefs!.setString(
                                'loginPageRadioValue', loginPageRadioValue);

                            onTapSignIn(context);
                          } else {
                            setState(() {
                              isload = false;
                            });
                            Utils().showMessage(context,
                                "Invalid Email or Password or ${loginPageRadioValue} not found!");
                            await FirebaseAuth.instance.signOut();
                          }
                        });
                      } on FirebaseAuthException catch (exception) {
                        setState(() {
                          isload = false;
                        });
                        Utils()
                            .showMessage(context, exception.message.toString());
                      }
                    } else {
                      setState(() {
                        isload = false;
                      });
                      Utils()
                          .showMessage(context, "Please fill all the fields!");
                    }
                  },
                ),

                SizedBox(height: 24.v),
                // Spacer(),
                GestureDetector(
                  onTap: () {
                    onTapTxtDonthaveanaccount(context);
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Don't have an account,",
                          style: CustomTextStyles.bodySmallPrimary_1),
                      TextSpan(text: " "),
                      TextSpan(
                          text: "Register",
                          style: CustomTextStyles.labelLargePrimaryBold)
                    ]),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPageTitle(BuildContext context) {
    return Column(children: [
      CustomImageView(
          imagePath: ImageConstant.imgHiDocLogo42x115,
          height: 65.v,
          width: 115.h),
      SizedBox(height: 26.v),
      Text("Parkinson Therapy",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
      SizedBox(height: 12.v),
      Text("Sign In To Continue",
          style: CustomTextStyles.labelLargePoppinsPrimaryBold)
    ]);
  }

  /// Navigates to the signupScreen when the action is triggered.
  onTapSignIn(
    BuildContext context,
  ) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MainActivity();
    }));

    // Navigator.popUntil(context, (route) => route.isFirst);
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => MainActivity(),
    //     ));
  }

  /// Navigates to the signupScreen when the action is triggered.
  onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageViewScreen()));
  }

  /// Navigates to the forgetPasswordScreen when the action is triggered.
  onTapTxtForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.forgetPasswordScreen);
  }
}
