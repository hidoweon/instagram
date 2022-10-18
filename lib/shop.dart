import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: "dory@test.com", password: "12345");
      print(result.user);
    } catch (e) {
      print(e);
    }

    if(auth.currentUser?.uid == null){
      print("you haven't logged in!");
    } else {
      print("you have logged in!");
    }




  }


@override
void initState() {
  super.initState();
  getData();
}

@override
Widget build(BuildContext context) {
  return Container(
    child: Text("shop page"),
  );
}}
