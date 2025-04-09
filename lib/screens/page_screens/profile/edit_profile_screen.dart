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
  String? avatarUrl;
  bool isLoadingAvatar = false;

  @override
  void initState() {
    super.initState();
    userInfor = Provider.of<AppInfor>(context, listen: false).userInfor;
    _loadUserAvatar();

    if (userInfor != null) {
      nameController.text = userInfor!.name;
      emailController.text = userInfor!.email;
      phoneController.text = userInfor!.phone;
    }
  }

  // Tải ảnh đại diện người dùng
  Future<void> _loadUserAvatar() async {
    if (firebaseAuth.currentUser != null) {
      try {
        setState(() {
          isLoadingAvatar = true;
        });
        
        // Kiểm tra xem ảnh đã tồn tại chưa
        final ref = FirebaseStorage.instance
            .ref()
            .child("avatars/${firebaseAuth.currentUser!.uid}");
            
        try {
          // Lấy URL của ảnh
          String downloadURL = await ref.getDownloadURL();
          setState(() {
            avatarUrl = downloadURL;
            isLoadingAvatar = false;
          });
        } catch (e) {
          // Nếu không có ảnh
          setState(() {
            avatarUrl = null;
            isLoadingAvatar = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoadingAvatar = false;
        });
        print("Lỗi khi tải ảnh đại diện: $e");
      }
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
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoadingWidget(),
      );
      
      // Chọn ảnh từ nguồn được chỉ định (camera hoặc thư viện)
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Giới hạn kích thước để tối ưu
        maxHeight: 800,
        imageQuality: 85, // Nén ảnh để tiết kiệm dung lượng
      );
      
      // Nếu có ảnh được chọn
      if (image != null) {
        // Tạo tham chiếu đến vị trí lưu trữ trong Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("avatars/${firebaseAuth.currentUser!.uid}");
            
        // Tải tệp lên Firebase Storage
        File imageFile = File(image.path);
        final uploadTask = await storageRef.putFile(
          imageFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        
        // Lấy URL tải xuống
        final downloadUrl = await storageRef.getDownloadURL();
        
        // Lưu URL vào Firestore trong hồ sơ người dùng
        await firebaseFirestore
            .collection("users")
            .doc(firebaseAuth.currentUser!.uid)
            .update({"avatarUrl": downloadUrl});
            
        // Cập nhật trạng thái
        setState(() {
          avatarUrl = downloadUrl;
        });
        
        // Đóng dialog loading
        Navigator.pop(context);
        
        // Hiển thị thông báo
        Fluttertoast.showToast(
          msg: "Cập nhật ảnh đại diện thành công",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        // Đóng dialog loading nếu không có ảnh được chọn
        Navigator.pop(context);
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.pop(context);
      print("Lỗi cập nhật ảnh đại diện: $e");
      Fluttertoast.showToast(
        msg: "Lỗi cập nhật ảnh đại diện: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF2FD),
        appBar: AppBar(
          backgroundColor: Constants.backgroundColor,
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: updateUser,
            child: Text(
              "Cập nhật",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Constants.backgroundColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.backgroundColor,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera_alt, color: Constants.backgroundColor),
                                    title: Text('Máy ảnh'),
                                    onTap: () {
                                      updateAvatar(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library, color: Constants.backgroundColor),
                                    title: Text('Thư viện'),
                                    onTap: () {
                                      updateAvatar(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Constants.backgroundColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: isLoadingAvatar
                              ? const CircularProgressIndicator()
                              : avatarUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        avatarUrl!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            color: Constants.backgroundColor,
                                            size: 50,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      color: Constants.backgroundColor,
                                      size: 50,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userInfor?.name ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Constants.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userInfor?.phone ?? "",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        LabelTextWidget(
                          hintText: "Nhập số điện thoại",
                          iconLabel: Icon(Icons.phone, color: Constants.backgroundColor),
                          labelText: "Số điện thoại",
                          textController: phoneController,
                        ),
                        const SizedBox(height: 15),
                        LabelTextWidget(
                          hintText: "Nhập họ tên",
                          iconLabel: Icon(Icons.person, color: Constants.backgroundColor),
                          labelText: "Họ tên",
                          textController: nameController,
                        ),
                        const SizedBox(height: 15),
                        LabelTextWidget(
                          hintText: "Nhập email",
                          iconLabel: Icon(Icons.email, color: Constants.backgroundColor),
                          labelText: "Email",
                          textController: emailController,
                        ),
                      ],
                    ),
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

