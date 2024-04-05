import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:parkinson/services/chat_servvices/screen/home_screen.dart';
import 'package:parkinson/theme/theme_helper.dart';

class SeeAllDoctorScreen extends StatefulWidget {
  @override
  _SeeAllDoctorScreenState createState() => _SeeAllDoctorScreenState();
}

class _SeeAllDoctorScreenState extends State<SeeAllDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[200]!,
              Colors.blue[100]!,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 17),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        // gradient: LinearGradient(
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        //   colors: [Colors.blue[500]!, Colors.blue[600]!],
                        // ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Doctor Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Data is available
                      final doctors = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];

                          return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  // color: appTheme.teal50,
                                  border: Border.all(
                                      color: appTheme.teal300, width: 0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 74, 161, 219),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: doctor['profilePic'],
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 80,
                                              width: 80,
                                              child: LinearProgressIndicator(
                                                color: Colors.grey.shade200,
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.baseline,
                                              // textBaseline:
                                              //     TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  doctor['name'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                // message_lottie.json

                                                // InkWell(
                                                //   onTap: () {
                                                //     Navigator.push(
                                                //         context,
                                                //         MaterialPageRoute(
                                                //             builder: (context) =>
                                                //                 HomeScreenChat()));
                                                //   },
                                                //   child: Lottie.asset(
                                                //       'assets/images/message_lottie.json',
                                                //       // reverse: true,
                                                //       // animate: true,
                                                //       height: 27,
                                                //       width: 27,
                                                //       fit: BoxFit.cover),
                                                // ),
                                              ],
                                            ),
                                            Text(
                                              doctor['speciality'].length > 13
                                                  ? '${doctor['speciality'].substring(0, 13)}...'
                                                  : doctor['speciality'],
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 161, 158, 158),
                                                fontWeight: FontWeight.w200,
                                                fontSize: 13,
                                              ),
                                            ),
                                            // SizedBox(height: 5),
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       child: RatingBar.builder(
                                            //         ignoreGestures: true,
                                            //         allowHalfRating: true,
                                            //         itemSize: 14,
                                            //         initialRating:
                                            //             doctor['rating'] ?? 0.0,
                                            //         minRating: 1,
                                            //         direction: Axis.horizontal,
                                            //         itemCount: 5,
                                            //         itemBuilder: (context, _) =>
                                            //             Icon(
                                            //           Icons.star,
                                            //           color: Colors.amber,
                                            //         ),
                                            //         onRatingUpdate: (rating) {
                                            //         },
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       doctor['rating'].toString(),
                                            //       style: TextStyle(
                                            //         fontSize: 13,
                                            //         color: Color.fromARGB(
                                            //             255, 69, 67, 67),
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       '(${doctor['noOfRating']} users)',
                                            //       style: TextStyle(
                                            //         fontSize: 12,
                                            //         color: Color.fromARGB(
                                            //             255, 69, 67, 67),
                                            //       ),
                                            //     ),
                                            //     SizedBox(width: 5),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    } else if (snapshot.hasError) {
                      // Error occurred while fetching data
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      // Data is still loading
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
