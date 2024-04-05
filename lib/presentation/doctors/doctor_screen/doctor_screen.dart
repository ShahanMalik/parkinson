// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/services/chat_servvices/screen/home_screen.dart';
import 'package:parkinson/widgets/custom_image_view.dart';

import 'package:parkinson/widgets/doctor_info.dart';
import 'package:parkinson/widgets/profile_menu.dart';

// ignore: must_be_immutable
class DoctorScreen extends StatelessWidget {
  // final String doctorName;
  // final String doctorCategory;
  // final Float doctorRating;
  // final int doctorLocation;

  var singleDoctor;
  DoctorScreen({
    Key? key,
    required this.singleDoctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkinson Therapy"),
        elevation: 0,
        leading: Icon(Icons.emergency_rounded),
      ),
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => HomeScreenChat()));
          //       },
          //       child: Container(
          //         height: 45,
          //         width: 45,
          //         margin: EdgeInsets.only(right: 10),
          //         decoration: BoxDecoration(
          //           color: appTheme.teal50,
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //         child: Center(
          //           child: Lottie.asset(
          //             'assets/images/message_lottie.json',
          //             fit: BoxFit.scaleDown,
          //             height: 26,
          //             width: 26,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 27),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // color: const Color.fromARGB(255, 155, 86, 86),
                child: CustomImageView(
                  fit: BoxFit.cover,
                  imagePath: singleDoctor['profilePic'],
                  height: 168.adaptSize,
                  width: 168.adaptSize,
                  radius: BorderRadius.circular(
                    100,
                  ),
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 20),
              DoctorInfo(
                text: singleDoctor['name'],
                icon: "assets/images/User Icon.svg",
              ),
              DoctorInfo(
                text: singleDoctor['speciality'],
                icon: "assets/images/stethoscope.svg",
              ),
              DoctorInfo(
                text: singleDoctor['rating'].toString(),
                icon: "assets/images/rating.svg",
              ),
              DoctorInfo(
                text: singleDoctor['role'],
                icon: "assets/images/Location point.svg",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
