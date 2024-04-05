import 'package:parkinson/data/new_info/new_info.dart';
import 'package:parkinson/presentation/news_screen/news_screen.dart';

import '../article_screen/widgets/trendings_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/core/app_export.dart';
import 'package:parkinson/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class ArticleScreen extends StatelessWidget {
  ArticleScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkinson Therapy"),
        elevation: 0,
        leading: Icon(Icons.emergency_rounded),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 19.v),
        child: Column(
          children: [
            // CustomSearchView(
            //     controller: searchController, hintText: "search article"),
            // SizedBox(height: 23.v),
            // Padding(
            //   padding: EdgeInsets.only(right: 2.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Trending Articles",
            //           style: CustomTextStyles.titleMediumOnPrimaryContainer_1),
            //       Padding(
            //           padding: EdgeInsets.only(bottom: 5.v),
            //           child: Text("see all",
            //               style: CustomTextStyles.labelLargeCyan300)),
            //     ],
            //   ),
            // ),
            SizedBox(height: 16.v),
            SizedBox(height: 11.v),
            Flexible(
              child: GridView.builder(
                itemCount: newsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 1.5,
                  crossAxisSpacing: 13.h,
                  mainAxisSpacing: 10.v,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewsScreen(newsList: newsList[index])));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.h,
                        vertical: 7.v,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 33, 190, 167),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 153.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: 87.v,
                            // width: 138.h,
                            // margin: EdgeInsets.only(left: 1.h),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/news_image_2.jpg'),
                                  fit: BoxFit.cover,
                                  height: 86.v,
                                  width: 144.h,
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgBookmark,
                                  height: 15.adaptSize,
                                  width: 15.adaptSize,
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(
                                    top: 5.v,
                                    right: 1.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 1.v),
                          Container(
                            // width: 106.h,
                            margin: EdgeInsets.only(left: 1.h),
                            child: Text(
                              textAlign: TextAlign.center,
                              newsList[index].title,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles
                                  .labelLargeOnPrimarySemiBold
                                  .copyWith(
                                height: 1.50,
                              ),
                            ),
                          ),
                          // SizedBox(height: 6.v),
                        ],
                      ),
                    ),
                  );
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
