// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:parkinson/services/chat_servvices/screen/chat_screen.dart';
import 'package:parkinson/services/notification_services/notification_services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {Key? key})
      : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();

  var deviceToken = '';

  var url = '';
  FocusNode focusNode = FocusNode();

  File? newImage;

  XFile? image;

  final picker = ImagePicker();

  bool isload = false;
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
      handleShowDialog();
    }
  }

  Future<dynamic> handleShowDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Add this
          builder: (context, setState) {
            // Add this
            return Dismissible(
              direction: DismissDirection.vertical,
              key: Key(newImage!.path),
              onDismissed: (direction) {
                Navigator.of(context).pop();
                setState(() {
                  image = null;
                  _controller.clear();
                  newImage = null;
                  isload = false;
                });
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: Dialog(
                      backgroundColor: Colors.black,
                      child: PhotoView(
                        enablePanAlways: true,
                        customSize: Size(MediaQuery.of(context).size.width * 1,
                            MediaQuery.of(context).size.height * 0.8),
                        enableRotation: true,
                        imageProvider: FileImage(File(newImage!.path)),
                        backgroundDecoration:
                            BoxDecoration(color: Colors.black),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                        heroAttributes:
                            PhotoViewHeroAttributes(tag: newImage!.path),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: isload
                            ? EdgeInsets.symmetric(horizontal: 5, vertical: 20)
                            : EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                        backgroundColor: Color.fromARGB(255, 8, 131, 116),
                      ),
                      label: isload
                          ? SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.black,
                              ),
                            )
                          : Container(), // Display an empty container when isload is false
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        setState(() {
                          isload = true;
                        });
                        send();
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          isload = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }, // Add this
        ); // Add this
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: CupertinoTextField(
            cursorColor: Colors.black,
            controller: _controller,
            focusNode: FocusNode(),
            placeholder: "Type your Message",
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25)),
            suffix: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _controller.clear();
              },
              child: InkWell(
                onTap: () {
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
                                focusNode.unfocus();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Gallery'),
                              onTap: () {
                                imagePickerFromGallery(ImageSource.gallery);
                                Navigator.pop(context);
                                focusNode.unfocus();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  // CupertinoIcons.photo_camera,
                  // Icons.photo_camera_outlined,
                  CupertinoIcons.camera_on_rectangle_fill,

                  color: Color.fromARGB(255, 134, 129, 129),
                ),
              ),
            ),
          )),
          const SizedBox(
            width: 17,
          ),
          GestureDetector(
            onTap: () async {
              send();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                CupertinoIcons.paperplane_fill,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void send() async {
    print('sendsendsendsendsend');
    if (newImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');
      await ref.putFile(File(newImage!.path));
      url = await ref.getDownloadURL();
      // message = "";
      // setState(() {});
      // _image = null;
    }
    if (_controller.text.isEmpty && newImage == null) {
      return;
    }
    String message = _controller.text;
    _controller.clear();
    await FirebaseFirestore.instance
        .collection(radioValue.toString())
        .doc(widget.currentId)
        .collection('messages')
        .doc(widget.friendId)
        .collection('chats')
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": message ?? "",
      'sendPic': url,
      "type": newImage != null ? "image" : "text",
      "date": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection(radioValue.toString())
          .doc(widget.currentId)
          .collection('messages')
          .doc(widget.friendId)
          .set({'last_msg': message, "date": DateTime.now()});
    });

    await FirebaseFirestore.instance
        .collection(
            radioValue.toString() == 'patients' ? 'doctors' : 'patients')
        .doc(widget.friendId)
        .collection('messages')
        .doc(widget.currentId)
        .collection("chats")
        .add({
      "senderId": widget.currentId,
      "receiverId": widget.friendId,
      "message": message,
      "type": newImage != null ? "image" : "text",
      'sendPic': url,
      "date": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection(
              radioValue.toString() == 'patients' ? 'doctors' : 'patients')
          .doc(widget.friendId)
          .collection('messages')
          .doc(widget.currentId)
          .set({"last_msg": message, "date": DateTime.now()});
    });
    setState(() {
      image = null;
      _controller.clear();
      newImage = null;
      isload = false;
    });

    //...............................................
    //...............................................
    //...............................................
    //...............................................
    //...............................................
    print("Button pressed");
    var collection = FirebaseFirestore.instance.collection(
        radioValue.toString() == 'doctors' ? 'patients' : 'doctors');
    var snapshot = await collection.get();
    // print("Got snapshot with ${snapshot.docs.length} docs");
    snapshot.docs
        .where((element) => element['uid'] == widget.friendId)
        .forEach((element) {
      deviceToken = element['deviceToken'];
      print("Device Token: $deviceToken");
    });
  }
}
