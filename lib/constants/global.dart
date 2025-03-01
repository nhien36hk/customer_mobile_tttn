import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotta_go/models/user_model.dart';
import 'package:gotta_go/screens/home_screen.dart';
import 'package:gotta_go/screens/notification_screen.dart';
import 'package:gotta_go/screens/ticket_screen.dart';
import 'package:gotta_go/screens/profile_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

final pages = [
  const HomeScreen(),
  const TicketScreen(),
  const NotificationScreen(),
  const ProfileScreen(),
];
