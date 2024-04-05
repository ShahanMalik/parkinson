import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/core/utils/utils.dart';
import 'package:parkinson/presentation/login_screen/login_screen.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:parkinson/widgets/custom_text_form_field.dart';

String signupPageRadioValue = "doctors";
UserCredential? signupScreenuserCredential;

class SignupScreen extends StatefulWidget {
  SignupScreen({
    Key? key,
    this.onpress,
  }) : super(key: key);
  final Function? onpress;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: appTheme.cyan300,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.v),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 70.v),
                          _buildPageTitle(context),
                          // SizedBox(height: 29.v),
                          // _buildFullName(context),
                          SizedBox(height: 32.v),
                          _buildEmail(context),
                          SizedBox(height: 8.v),
                          _buildPassword(context),
                          SizedBox(height: 8.v),
                          _buildPassword1(context),
                          SizedBox(height: 12.v),
                          Row(
                            children: [
                              Radio(
                                  value: 'doctors',
                                  groupValue: signupPageRadioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      signupPageRadioValue = 'doctors';
                                    });
                                  }),
                              Text(
                                "Doctor",
                              ),
                              Radio(
                                  value: 'patients',
                                  groupValue: signupPageRadioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      signupPageRadioValue = 'patients';
                                    });
                                  }),
                              Text(
                                "Patient",
                              ),
                            ],
                          ),
                          SizedBox(height: 12.v),
                          _buildSignUp(context),
                          SizedBox(height: 14.v),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Have an account",
                                    style: CustomTextStyles.bodySmallPrimary_1),
                                TextSpan(text: " "),
                                TextSpan(
                                    text: "Login",
                                    style:
                                        CustomTextStyles.labelLargePrimaryBold)
                              ]),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  /// Section Widget
  Widget _buildPageTitle(BuildContext context) {
    return Column(children: [
      CustomImageView(
          imagePath: ImageConstant.imgHiDocLogo42x115,
          height: 42.v,
          width: 115.h),
      SizedBox(height: 27.v),
      Text("Let's Get Started",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
      SizedBox(height: 10.v),
      Text("Create a New Account",
          style: CustomTextStyles.labelLargePoppinsPrimaryBold)
    ]);
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
        controller: emailController,
        hintText: "Email",
        textInputType: TextInputType.emailAddress,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgMail,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v));
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController,
        hintText: "Password",
        textInputType: TextInputType.visiblePassword,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgLock,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        obscureText: true);
  }

  /// Section Widget
  Widget _buildPassword1(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController1,
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
        obscureText: true);
  }

  bool isload = false;

  /// Section Widget
  Widget _buildSignUp(BuildContext context) {
    return CustomElevatedButton(
      text: "Sign Up",
      isloading: isload,
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: CustomTextStyles.titleSmallTeal300,
      onPressed: () async {
        setState(() {
          isload = true;
        });
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            passwordController1.text.isNotEmpty) {
          try {
            if (passwordController.text == passwordController1.text) {
              signupScreenuserCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              if (signupPageRadioValue == 'doctors') {
                await FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(signupScreenuserCredential!.user!.uid)
                    .set({
                  'uid': signupScreenuserCredential!.user!.uid,
                  'name': '',
                  'email': emailController.text.trim(),
                  'profilePic': '',
                  'phone': '',
                  'role': signupPageRadioValue,
                  'speciality': '',
                  'address': '',
                  'rating': 0.0,
                  'noOfRating': 0,
                  'deviceToken': '',
                });
              } else {
                await FirebaseFirestore.instance
                    .collection('patients')
                    .doc(signupScreenuserCredential!.user!.uid)
                    .set({
                  'uid': signupScreenuserCredential!.user!.uid,
                  'name': '',
                  'email': emailController.text.trim(),
                  'profilePic': '',
                  'phone': '',
                  'role': signupPageRadioValue,
                  'address': '',
                  'disease': [],
                  'deviceToken': '',
                });
              }
              setState(() {
                isload = false;
              });
              widget.onpress!();
              // Timer.periodic(Duration(seconds: 1), (timer) {
              //   Utils().showMessage(context, "User Created Successfully!");
              // });
            } else {
              setState(() {
                isload = false;
              });
              Utils().showMessage(context, "Password don't match!");
            }
          } on FirebaseAuthException catch (exception) {
            if (context.mounted) {
              setState(() {
                isload = false;
              });
              Utils().showMessage(context, exception.message.toString());
            }
          }
        } else {
          setState(() {
            isload = false;
          });
          Utils().showMessage(context, 'Please fill all the the fields');
        }
      },
    );
  }

  /// Navigates to the loginScreen when the action is triggered.
  onTapTxtHaveanaccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }
}
