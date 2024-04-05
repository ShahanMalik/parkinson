// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/presentation/doctors/doctor_screen/doctor_screen.dart';

// ignore: must_be_immutable
class DoctorItemWidget extends StatelessWidget {
  var singleDoctor;

  DoctorItemWidget({
    Key? key,
    required this.singleDoctor,
    required Null Function() onTapDoctor,
  }) : super(
          key: key,
        );

  VoidCallback? onTapDoctor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DoctorScreen(
                singleDoctor: singleDoctor,
              ),
              transitionDuration: Duration(
                  seconds: 1), // Adjust transition duration as per your need
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     transitionDuration: Duration(seconds: 2),
            //     pageBuilder: (_, __, ___) => DoctorScreen(
            //       singleDoctor: singleDoctor,
            //     ),
            //   ),
            // );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.h,
              vertical: 10.v,
            ),
            decoration: AppDecoration.outlineTeal.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              //  title: Text(doctorsList['name']),
              children: [
                SizedBox(height: 11.v),
                CustomImageView(
                  fit: BoxFit.cover,
                  imagePath: singleDoctor['profilePic'],
                  height: 68.adaptSize,
                  width: 68.adaptSize,
                  radius: BorderRadius.circular(
                    34.h,
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(height: 18.v),
                Padding(
                  padding: EdgeInsets.only(left: 1.h),
                  child: Text(
                    singleDoctor['name'],
                    style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                  ),
                ),
                SizedBox(height: 3.v),
                Padding(
                  padding: EdgeInsets.only(left: 1.h),
                  child: Text(
                    singleDoctor['speciality'].length > 13
                        ? '${singleDoctor['speciality'].substring(0, 13)}...'
                        : singleDoctor['speciality'],
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                SizedBox(height: 6.v),
                Padding(
                  padding: EdgeInsets.only(left: 1.h),
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgStar,
                        height: 10.adaptSize,
                        width: 10.adaptSize,
                        margin: EdgeInsets.only(bottom: 3.v),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.h,
                          top: 2.v,
                          bottom: 1.v,
                        ),
                        child: Text(
                          singleDoctor['rating'].toString(),
                          style: CustomTextStyles.labelSmallCyan300,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 23.h,
                          top: 3.v,
                        ),
                        child: Text(
                          singleDoctor['address'],
                          style: CustomTextStyles.labelSmallBluegray200,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
