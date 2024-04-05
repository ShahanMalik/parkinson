import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkinson/core/utils/utils.dart';
import 'package:parkinson/main_Activity.dart';
import 'package:parkinson/presentation/login_screen/login_screen.dart';
import 'package:parkinson/presentation/signup_screen/signup_screen.dart';
import 'package:parkinson/theme/custom_button_style.dart';
import 'package:parkinson/theme/custom_text_style.dart';
import 'package:parkinson/theme/theme_helper.dart';
import 'package:parkinson/widgets/custom_elevated_button.dart';

class AddUserDetailScreen extends StatefulWidget {
  @override
  _AddUserDetailScreenState createState() => _AddUserDetailScreenState();
}

class _AddUserDetailScreenState extends State<AddUserDetailScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _specialityController = TextEditingController();

  XFile? _image;

  Future<void> _openImagePicker(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      _image = pickedImage;
    });
  }

  bool isload = false;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _specialityFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _phoneFocusNode.dispose();
    _specialityFocusNode.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _specialityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(signupPageRadioValue);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.cyan300,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 26),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: new Wrap(
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(Icons.photo_library),
                                    title: new Text('Photo Library'),
                                    onTap: () {
                                      _openImagePicker(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new ListTile(
                                    leading: new Icon(Icons.photo_camera),
                                    title: new Text('Camera'),
                                    onTap: () {
                                      _openImagePicker(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: _image != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(_image!.path)),
                        )
                      : CircleAvatar(
                          radius: 60,
                          child: Icon(Icons.add_a_photo, size: 30),
                          backgroundColor: Colors.grey[200],
                        ),
                ),
                SizedBox(height: 50),
                _buildTextField(_nameController, 'Name', _nameFocusNode),
                SizedBox(height: 16),
                (signupPageRadioValue == "doctors")
                    ? _buildTextField(_specialityController, 'Speciality',
                        _specialityFocusNode)
                    : Container(),
                (signupPageRadioValue == "doctors")
                    ? SizedBox(height: 16)
                    : SizedBox(height: 2),
                _buildTextField(_phoneController, 'Phone', _phoneFocusNode),
                SizedBox(height: 16),
                _buildTextField(
                    _addressController, 'Address', _addressFocusNode),
                SizedBox(height: 16),
                CustomElevatedButton(
                  isloading: isload,
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  buttonTextStyle: CustomTextStyles.titleSmallTeal300,
                  text: "Add",
                  onPressed: () async {
                    setState(() {
                      isload = true;
                    });
                    if (_nameController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _addressController.text.isEmpty ||
                        _image == null) {
                      setState(() {
                        isload = false;
                      });
                      Utils()
                          .showMessage(context, "Please fill all the fields");
                      return;
                    } else {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('user_image')
                          .child(
                              signupScreenuserCredential!.user!.uid + '.jpg');
                      await ref.putFile(File(_image!.path));
                      final url = await ref.getDownloadURL();
                      if (signupPageRadioValue == 'doctors') {
                        await FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(signupScreenuserCredential!.user!.uid)
                            .update({
                          'name': _nameController.text,
                          'speciality': _specialityController.text,
                          'phone': _phoneController.text,
                          'address': _addressController.text,
                          'profilePic': url,
                          'date': DateTime.now(),
                          'online': 'offline',
                        });
                        setState(() {
                          isload = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                        Utils().showMessage(
                            context, 'Doctor detail added successfully!');
                      } else {
                        await FirebaseFirestore.instance
                            .collection("patients")
                            .doc(signupScreenuserCredential!.user!.uid)
                            .update({
                          'name': _nameController.text,
                          'phone': _phoneController.text,
                          'address': _addressController.text,
                          'profilePic': url,
                          'date': DateTime.now(),
                          'online': 'offline',
                        });
                        setState(() {
                          isload = false;
                        });
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                        Utils().showMessage(
                            context, 'Patient detail added successfully!');
                      }
                    }
                  },
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: RichText(
                //     text: TextSpan(children: [
                //       TextSpan(
                //           text: "Have an account",
                //           style: CustomTextStyles.bodySmallPrimary_1),
                //       TextSpan(text: " "),
                //       TextSpan(
                //           text: "Sign In",
                //           style: CustomTextStyles.labelLargePrimaryBold)
                //     ]),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String label, FocusNode focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (value) {
        if (focusNode == _nameFocusNode) {
          FocusScope.of(context).requestFocus(_specialityFocusNode);
        } else if (focusNode == _specialityFocusNode) {
          FocusScope.of(context).requestFocus(_phoneFocusNode);
        } else if (focusNode == _phoneFocusNode) {
          FocusScope.of(context).requestFocus(_addressFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
        // labelText: label,
        hintText: label,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w300,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: appTheme.blue50,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
