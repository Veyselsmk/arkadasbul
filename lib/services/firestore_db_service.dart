import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> saveUser(UserModel? user) async {
    await firebaseFirestore.collection("users").doc(user?.userID).set(user!.toMap());
    return user;
  }

  @override
  Future<UserModel?> getUser(String? userID) async {
    final docRef = await firebaseFirestore.collection("users").doc(userID).get();
    if (docRef.data() == null) {
      return null;
    }
    final data = await docRef.data()!;
    UserModel? readUser = UserModel.fromMap(data);
    return readUser;
  }

  @override
  Future<UserModel?> updateUser(String? userID, UserModel? newUser) async {
    await firebaseFirestore.collection("users").doc(userID).update(newUser!.toMap());
    return newUser;
  }

  //////////////////////////////////////////////////////////////////////////////////////

  @override
  Future<int> getCollectionLenght(String? collectionName) async {
    var docs = firebaseFirestore.collection(collectionName!);
    AggregateQuerySnapshot lenght = await docs.count().get();
    return lenght.count;
  }

  ////////////////////////////////////////////////////////////////////////////////////////

  @override
  Future<RoomModel?> saveRoom(String? ownerID, RoomModel? room) async {
    CollectionReference ref = await firebaseFirestore.collection("rooms");
    String id = ref.doc().id;
    room?.roomID = id;
    await firebaseFirestore.collection("rooms").doc(room?.roomID).set(room!.toMap());
    ChatModel? chat = ChatModel(roomID: id, members: room.members, chatName: room.roomName, active: true);
    await saveChat(chat);
    return room;
  }

  @override
  Future<RoomModel?> getRoom(String? roomID) async {
    final docRef = await firebaseFirestore.collection("rooms").doc(roomID).get();
    final data = await docRef.data();
    RoomModel? readRoom = await RoomModel.fromMap(data);
    return readRoom;
  }

  @override
  Future<RoomModel?> updateRoom(String? roomID, RoomModel? newRoom) async {
    await firebaseFirestore.collection("rooms").doc(roomID).update(newRoom!.toMap());
    var chat = await getChatByRoomID(roomID);
    chat?.active = newRoom.active;
    chat?.chatName = newRoom.roomName;
    chat?.members = newRoom.members;
    await updateChat(chat?.chatID, chat);
    return newRoom;
  }

  @override
  Future<Map<dynamic,dynamic>> listRoomsByUserID(String? userID) async {
    final docRef = await firebaseFirestore.collection("rooms").where("members", arrayContains: userID).get();
    final querySnapshot = await docRef.docs;
    List rooms = [];
    for (var doc in querySnapshot) {
      var data = await doc.data()!;
      RoomModel? room = RoomModel.fromMap(data);
      rooms.add(room);
    }
    Map map = {"active":[],"passive":[]};
    for(var room in rooms) {
      if(room.active == true) {
        map['active'].add(room);
      }
      if(room.active == false) {
        map['passive'].add(room);
      }
    }
    return map;
  }

  @override
  Future<List<dynamic>> listRoomsByCategory(String? category) async {
    final docRef =
        await firebaseFirestore.collection("rooms").where("category", isEqualTo: category).get();
    final querySnapshot = await docRef.docs;
    List rooms = [];
    for (var doc in querySnapshot) {
      var data = await doc.data()!;
      if(data['active'] == true && int.parse(data['capacity']) > data['members'].length) {
        RoomModel? room = RoomModel.fromMap(data);
        rooms.add(room);
      }
    }
    return rooms;
  }

  @override
  Future<RoomModel?> getRoomByRoomNumber(String? roomNumber) async {
    final docRef = await firebaseFirestore.collection("rooms").where("roomNumber", isEqualTo: roomNumber).get();
    var data = await docRef.docs.firstOrNull?.data();
    if (data == null) {
      return null;
    }
    RoomModel? room = RoomModel.fromMap(data);
    return room;
  }

  //////////////////////////////////////////////////////////////////////////

  @override
  Future<ChatModel?> saveChat(ChatModel? chat) async {
    CollectionReference ref = await firebaseFirestore.collection("chats");
    String id = ref.doc().id;
    chat?.chatID = id;
    await ref.doc(id).set(chat!.toMap());
    return chat;
  }

  @override
  Future<ChatModel?> getChat(String? chatID) async {
    final docRef = await firebaseFirestore.collection("chats").doc(chatID).get();
    final data = await docRef.data();
    ChatModel? chat = ChatModel.fromMap(data);
    return chat;
  }

  @override
  Future<ChatModel?> getChatByRoomID(String? roomID) async {
    //debugPrint("roomID: $roomID");
    final docRef = await firebaseFirestore.collection("chats").where("roomID", isEqualTo: roomID).get();
    var data = docRef.docs.firstOrNull?.data();
    ChatModel? chat = ChatModel.fromMap(data);
    return chat;
    /*final queryDocumentSnapshot = await docRef.docs;
    ChatModel? chat;
    for (var doc in queryDocumentSnapshot) {
      var data = await doc.data();
       chat = ChatModel.fromMap(data);
    }
    return chat;*/
  }

  @override
  Future<ChatModel?> updateChat(String? chatID, ChatModel? chat) async {
    await firebaseFirestore.collection("chats").doc(chatID).update(chat!.toMap());
    return chat;
  }

  @override
  Future<List<dynamic>?> addMessage(String? chatID, UserModel? user, String? message) async {
    var userID = user?.userID;
    var username = user?.username;
    var userImage = user?.imgURL;
    //ListQueue queue = ListQueue();
    ChatModel? chat = await getChat(chatID);
    //debugPrint(chat?.messages.toString());
    var messageField = {"fromUser": userID, "username": username, "userImage": userImage, "message": message};
    //chat!.messages = queue.addLast(messageField);
    chat!.messages?.add(messageField);
    await firebaseFirestore.collection("chats").doc(chatID).update({"messages": chat!.messages!});
    return chat!.messages;
  }

  @override
  Stream<List<dynamic>> getMessages(String? chatID) {

    Stream snapshot = firebaseFirestore.collection("chats").doc(chatID).snapshots();
    //var messages = snapshot.map((event) => event['messages']);
    //return snapshot.map((event) => event.data()!['messages']);
    return snapshot.map((event) => event.data()!['messages']);
  }
}
