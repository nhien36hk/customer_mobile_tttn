import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/user_model.dart';
import 'package:gotta_go/provider/app_infor.dart';
import 'package:gotta_go/screens/home_screen.dart';
import 'package:gotta_go/screens/main_screen.dart';
import 'package:gotta_go/screens/sign_up_screen.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:gotta_go/widgets/password_input_widget.dart';
import 'package:gotta_go/widgets/text_input_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        return;
      }

      showDialog(context: context, builder: (context) => LoadingWidget());

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential authCredential = await GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      User user = userCredential.user!;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
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

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $e')));
    }
  }

  void singIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(context: context, builder: (context) => LoadingWidget());
        await firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((auth) async {
          if (auth.user!.emailVerified) {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Vui lòng xác thực email")));
            Navigator.pop(context);
          }
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Lỗi $e")));
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                          'Đăng nhập',
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
                      SizedBox(
                        height: 20,
                      ),
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
                      SizedBox(
                        height: 20,
                      ),
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
                            return "Ít nhất 1 chữ hoa";
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Ít nhất 1 số";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 47,
                      ),
                      GestureDetector(
                        onTap: singIn,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Constants.buttonColor,
                          ),
                          child: Center(
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(
                                  color: Constants.textButtonCOlor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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
                            "Bạn chưa có tài khoản?",
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
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              "Đăng ký ngay",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constants.textButtonCOlor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Đăng nhập bằng",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: signInWithGoogle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.asset('images/super_g.png'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // ... phần còn lại của form Đăng nhập
              ],
            ),
          ),
        ),
      ),
    );
  }
}
