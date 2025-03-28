import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/provider/app_infor.dart';
import 'package:gotta_go/screens/login_screen.dart';
import 'package:gotta_go/screens/splash_screen.dart';
import 'package:gotta_go/theme/them_data.dart';   
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Khai báo navigatorKey toàn cục để truy cập từ các dịch vụ
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Thêm global key cho LayoutScreen
final GlobalKey<State<LayoutScreen>> layoutScreenKey = GlobalKey<State<LayoutScreen>>();

// Initialize Firebase only if it hasn't been initialized yet
Future<void> initializeFirebase() async {
  // Check if Firebase is already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "nhom18-tttn",
      options: FirebaseOptions(
        apiKey: "AIzaSyDhRB8dNRqAA8eXUrlkT_07uN8yrSPTiRU",
        appId: "1:323149713826:android:17a7588f9122688827a2fb",
        messagingSenderId: "323149713826",
        projectId: "nhom18-tttn",
        storageBucket: "hom18-tttn.firebasestorage.app",
      ),
    );
  }
}

// Call initializeFirebase() in your main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await initializeDateFormatting('vi_VN', null);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppInfor(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Đặt navigatorKey cho MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeProvider.themeData,
      home: SplashScreen(),
    );
  }
}
