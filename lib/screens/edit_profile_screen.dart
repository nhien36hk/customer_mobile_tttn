import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/user_model.dart';
import 'package:gotta_go/provider/app_infor.dart';
import 'package:gotta_go/widgets/label_text_widget.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? userInfor;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfor = Provider.of<AppInfor>(context, listen: false).userInfor;

    if (userInfor != null) {
      nameController.text = userInfor!.name;
      emailController.text = userInfor!.email;
      phoneController.text = userInfor!.phone;
    }
  }

  void updateUser() {
    try {
      showDialog(
        context: context,
        builder: (context) => LoadingWidget(),
      );
      Map<String, dynamic> userMap = {
        "name": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
      };
      firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update(userMap)
          .then((user) {
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        Fluttertoast.showToast(msg: "Cập nhật thông tin thành công");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Cập nhật bị lỗi $e");
    }
  }

  Future<void> updateAvatar(ImageSource source) async {
    try {
      XFile? imagePicker = await ImagePicker().pickImage(source: source);
      if (imagePicker != null) {
        File imageFile = File(imagePicker!.path);
        final ref = await FirebaseStorage.instance
            .ref()
            .child("avatars/${firebaseAuth.currentUser!.uid}")
            .putFile(imageFile);
      }
    } catch (e) {
      print("Lỗi chọn ảnh $e");
      Fluttertoast.showToast(msg: "Lỗi cập nhật ảnh đại diện $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Thông tin tài khoản",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateUser();
                },
                child: Text(
                  "Cập nhật",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Chọn ảnh từ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(Icons.camera_alt),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Máy ảnh'),
                                        ],
                                      ),
                                      onTap: () {
                                        updateAvatar(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(Icons.camera),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Thư viện'),
                                        ],
                                      ),
                                      onTap: () {
                                        updateAvatar(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userInfor?.name ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(userInfor?.phone ?? ""),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      LabelTextWidget(
                        hintText: "Nhập số điện thoại",
                        iconLabel: Icon(Icons.phone),
                        labelText: "Số điện thoại",
                        textController: phoneController,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LabelTextWidget(
                        hintText: "Nhập họ tên",
                        iconLabel: Icon(Icons.person),
                        labelText: "Họ tên",
                        textController: nameController,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LabelTextWidget(
                        hintText: "Nhập email",
                        iconLabel: Icon(Icons.email),
                        labelText: "Email",
                        textController: emailController,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
