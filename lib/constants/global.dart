import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/models/user_model.dart';
import 'package:gotta_go/screens/page_screens/home/home_screen.dart';
import 'package:gotta_go/screens/page_screens/notification/notification_screen.dart';
import 'package:gotta_go/screens/page_screens/ticket/ticket_list_screen.dart';
import 'package:gotta_go/screens/page_screens/profile/profile_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

final pages = [
  const HomeScreen(),
  const TicketListScreen(),
  const NotificationScreen(),
  const ProfileScreen(),
];
