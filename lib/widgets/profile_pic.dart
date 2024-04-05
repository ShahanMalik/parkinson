import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  //////////////////////////////////////////
  ///
  ///
  File? newImage;

  XFile? image;

  var url = '';

  final picker = ImagePicker();

  // method to pick single image while replacing the photo
  Future imagePickerFromGallery(ImageSource source) async {
    image = (await picker.pickImage(source: source))!;

    final bytes = await image!.readAsBytes();
    final kb = bytes.length / 1024;
    final mb = kb / 1024;

    if (kDebugMode) {
      print('original image size:' + mb.toString());
    }

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Unique file name

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
      minHeight: 600, //you can play with this to reduce siz
      minWidth: 600,
      quality: 85, // keep this high to get the original quality of image
    );

    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;

    if (kDebugMode) {
      print('compress image size:' + newMb.toString());
    }

    newImage = File(result.path);

    setState(() {});

    if (newImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');
      await ref.putFile(File(newImage!.path));
      url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection(radioValue.toString())
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profilePic': url});
    }
    setState(() {});
  }

  ///
  ///
  //////////////////////////////////////////
  String profileImage = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  void loadImage() async {
    await FirebaseFirestore.instance
        .collection(radioValue.toString())
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        profileImage = value.data()!['profilePic'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: CachedNetworkImage(
              imageUrl: profileImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 30,
                width: 30,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Choose an option'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Camera'),
                              onTap: () {
                                imagePickerFromGallery(ImageSource.camera);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Gallery'),
                              onTap: () {
                                imagePickerFromGallery(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: SvgPicture.asset("assets/images/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
