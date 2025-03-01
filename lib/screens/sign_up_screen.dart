import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/screens/login_screen.dart';
import 'package:gotta_go/screens/main_screen.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:gotta_go/widgets/password_input_widget.dart';
import 'package:gotta_go/widgets/text_input_widget.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(context: context, builder: (context) => LoadingWidget());
      try {
        UserCredential userAuth =  await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        // Kiểm tra email đã tồn tại
        final result = await firebaseFirestore
            .collection("users")
            .where("email", isEqualTo: emailController.text)
            .get();

        if (result.docs.isNotEmpty) {
          Navigator.pop(context); // Đóng loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email đã được sử dụng')),
          );
          return;
        }

        // Tạo tài khoản
        Map<String, dynamic> userData = {
          "email": emailController.text,
          "name": nameController.text,
          "phone": phoneController.text,
          "status": "active",
          "role": "user",
          "createdAt": DateTime.now().toString(),
        };

        await firebaseFirestore.collection("users").doc(userAuth.user!.uid).set(userData);
        await firebaseAuth.currentUser!.sendEmailVerification();
        Navigator.pop(context); // Đóng loading
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Đăng ký thành công, vui lòng xác nhận email để đăng nhập!')),
        );
      } catch (e) {
        Navigator.pop(context); // Đóng loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã có lỗi xảy ra: ${e.toString()}')),
        );
      }
    }
  }

  void signUpWithGoogle() async {
    try {
      showDialog(context: context, builder: (context) => LoadingWidget());
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot documentSnapshot =
              await firebaseFirestore.collection('users').doc(user.uid).get();
          if (documentSnapshot.exists) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else {
            Map<String, dynamic> userData = {
              'uid': user.uid,
              'email': user.email,
              'phone': user.phoneNumber,
              'name': user.displayName,
              'photoUrl': user.photoURL,
              'role': 'user',
              'status': 'active',
              'createdAt': DateTime.now().toString(),
            };
            await firebaseFirestore
                .collection('users')
                .doc(user.uid)
                .set(userData);
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          }
        }
      } else {
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã có lỗi xảy ra: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(220),
                      bottomRight: Radius.circular(220),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontSize: 64,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'images/person.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextInputWidget(
                        iconName: Icons.person,
                        hintText: "Nhập tên người dùng",
                        labelText: "Tên người dùng",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tên không thể trống";
                          }
                          if (value.length < 2) {
                            return 'Tên phải có ít nhất 2 ký tự';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextInputWidget(
                        iconName: Icons.email,
                        hintText: "Nhập địa chỉ email",
                        labelText: "Email",
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email không thể trống";
                          }
                          final emailRegExp =
                              RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                          if (!emailRegExp.hasMatch(value)) {
                            return "Email không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextInputWidget(
                        iconName: Icons.phone,
                        hintText: "Nhập số điện thoại",
                        labelText: "Số điện thoại",
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Số điện thoại không thể trống";
                          }
                          final phoneRegExp =
                              RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');
                          if (!phoneRegExp.hasMatch(value)) {
                            return "Số điện thoại không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      PasswordInputWidget(
                        iconName: Icons.lock,
                        hintText: "Nhập mật khẩu",
                        labelText: "Mật khẩu",
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mật khẩu không thể trống";
                          }
                          if (value.length < 6) {
                            return "Mật khẩu phải có ít nhất 6 ký tự";
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return "Mật khẩu phải chứa ít nhất 1 chữ hoa";
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Mật khẩu phải chứa ít nhất 1 số";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      PasswordInputWidget(
                        iconName: Icons.lock,
                        hintText: "Vui lòng nhập lại mật khẩu",
                        labelText: "Xác nhận mật khẩu",
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng xác nhận mật khẩu";
                          }
                          if (value != passwordController.text) {
                            return "Mật khẩu không khớp";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 47),
                      GestureDetector(
                        onTap: signUp,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Constants.buttonColor,
                          ),
                          child: Center(
                            child: Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Constants.textButtonCOlor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn đã có tài khoản?",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => LoadingWidget());
                              await Future.delayed(Duration(milliseconds: 250));
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.textButtonCOlor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Đăng ký với",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: signUpWithGoogle,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(30)),
                                height: 50,
                                child: Image.asset('images/super_g.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
