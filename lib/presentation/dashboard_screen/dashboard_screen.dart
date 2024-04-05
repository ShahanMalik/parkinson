import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkinson/data/new_info/new_info.dart';
import 'package:parkinson/presentation/doctors/see_all_doctor/see_all_doctor_screen.dart';
import 'package:parkinson/services/notification_services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard_screen/widgets/doctor_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';
import 'package:parkinson/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Parkinson Therapy"),
          elevation: 0,
          leading: Icon(Icons.emergency_rounded),
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 18.v),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.h, bottom: 5.v),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //     padding: EdgeInsets.only(right: 20.h),
                        //     child: CustomSearchView(
                        //         controller: searchController,
                        //         hintText: "search")),
                        SizedBox(height: 5.v),
                        _buildOfferBanner(context),
                        SizedBox(height: 42.v),
                        _buildTopDoctorSeeAll(context),
                        SizedBox(height: 10.v),
                        _buildDoctor(context),
                        SizedBox(height: 31.v),
                        _buildHealtArticleSee(context),
                        SizedBox(height: 12.v),
                        _buildTwentyFour(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOfferBanner(BuildContext context) {
    return Container(
        width: 335.h,
        height: 150,
        margin: EdgeInsets.only(right: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 12.v),
        decoration: AppDecoration.fillTeal
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 4.v),
              SizedBox(
                  width: 168.h,
                  child: Text("Early \nProtection",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleMedium18
                          .copyWith(height: 1.50))),
              SizedBox(height: 9.v),
              CustomElevatedButton(
                  height: 26.v,
                  width: 106.h,
                  text: "learn more",
                  buttonStyle: CustomButtonStyles.fillCyan,
                  buttonTextStyle: CustomTextStyles.labelLargePrimarySemiBold)
            ]));
  }

  /// Section Widget
  Widget _buildTopDoctorSeeAll(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Top Doctor", style: theme.textTheme.titleMedium),
          InkWell(
            onTap: () {
              onTapTxtSeeAll(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 7.v),
              // color: Colors.amber,
              child: Text("see all", style: CustomTextStyles.labelLargeCyan300),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDoctor(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 175.v,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("doctors")
              // .where("username", isEqualTo: "shahan")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 14.h);
                  },
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doctorsList = snapshot.data!.docs[index];
                    return DoctorItemWidget(
                        onTapDoctor: () {
                          onTapDoctor(context);
                        },
                        singleDoctor: doctorsList);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHealtArticleSee(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 23.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Health Article", style: theme.textTheme.titleMedium),
          InkWell(
            onTap: () {
              onTapTxtSeeAll1(context);
            },
            child: Container(
              // color: Colors.amber,
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.v),
              child: Text("see all", style: CustomTextStyles.labelLargeCyan300),
            ),
          )
        ]));
  }

  /// Section Widget
  Widget _buildTwentyFour(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapTxtSeeAll1(context);
      },
      child: Container(
          margin: EdgeInsets.only(right: 20.h),
          padding: EdgeInsets.all(5.h),
          decoration: AppDecoration.outlineGray
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgDrugImage,
                  height: 55.adaptSize,
                  width: 55.adaptSize,
                  radius: BorderRadius.circular(6.h),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 12.h, top: 16.v),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 179.h,
                            child: Text(
                              newsList[0].title ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.labelMediumOnPrimary
                                  .copyWith(
                                height: 1.50,
                              ),
                            ),
                          ),
                        ]))
              ])),
    );
  }

  /// Navigates to the drDetailsScreen when the action is triggered.
  onTapDoctor(BuildContext context) {
    print("heloottttttttttttttttt");
  }

  /// Navigates to the pharmacyScreen when the action is triggered.
  onTapBtnUser(BuildContext context) {}

  /// Navigates to the drListScreen when the action is triggered.
  onTapTxtSeeAll(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SeeAllDoctorScreen();
    }));
  }

  /// Navigates to the articleScreen when the action is triggered.
  onTapTxtSeeAll1(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.articleScreen);
  }
}
