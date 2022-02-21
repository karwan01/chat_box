import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      debugPrint('>>>>>>>>>>>>>>${e.toString()}');
    });
  }

  Future searchByName(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get()
        .catchError((e) => {debugPrint(">>>>>>>>>>>>${e.toString()}")});
  }

  Future getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) => {debugPrint(">>>>>>>>>>>>${e.toString()}")});
  }

  Future addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) => {debugPrint(">>>>>>>>>>>>${e.toString()}")});
  }

  Future addChatMessage(String roomId, mapMessage) async {
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .collection('chats')
        .add(mapMessage)
        .catchError((e) {
      debugPrint(">>>>>>>>>>>>>>>>>${e.toString()}");
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserMessages(
      String roomId) async {
    //we used snapshot() instead get() because we want to return a stream not future
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }
}
