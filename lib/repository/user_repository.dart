import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:friend_circle/locator.dart';
import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/services/auth_base.dart';
import 'package:friend_circle/services/db_base.dart';
import 'package:friend_circle/services/firebase_auth_service.dart';
import 'package:friend_circle/services/firebase_storage_service.dart';
import 'package:friend_circle/services/firestore_db_service.dart';
import 'package:friend_circle/services/storage_base.dart';

class UserRepository implements AuthBase, DBBase, StorageBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService firebaseStorageService = locator<FirebaseStorageService>();

  @override
  Future<UserModel?> getCurrentUser() async {
    UserModel? user = await firebaseAuthService.getCurrentUser();
    user = await getUser(user?.userID);
    return user;
  }

  @override
  Future<UserModel?> login(String? email, String? password) async {
    UserModel? user = await firebaseAuthService.login(email, password);
    return user;
  }

  @override
  Future<UserModel?> loginWithGoogle() async {
    UserModel? user = await firebaseAuthService.loginWithGoogle();
    user = await saveUser(user);
    return user;
  }

  @override
  Future<bool> logOut() async {
    return await firebaseAuthService.logOut();
  }

  @override
  Future<UserModel?> register(String? email, String? password) async {
    try {
      UserModel? user = await firebaseAuthService.register(email, password);
      if ( user == null) {
        return null;
      } else {
        user = await saveUser(user);
        return user;
      }
    } catch (e) {
      return null;
    }


  }

  @override
  Future<UserModel?> getUser(String? userID) async {
    UserModel? user = await firestoreDBService.getUser(userID);
    return user;
  }

  @override
  Future<UserModel?> saveUser(UserModel? user) async {
    return await firestoreDBService.saveUser(user);
  }

  @override
  Future<UserModel?> updateUser(String? userID, UserModel? newUser) async {
    UserModel? user = await firestoreDBService.updateUser(userID, newUser);
    return user;
  }

  @override
  Future<String?> uploadFile(String? userID, String? fileType, File file) async {
    return await firebaseStorageService.uploadFile(userID, fileType, file);
  }

  //////////////////////////////////////////////////////////////////////////////////
  @override
  Future<RoomModel?> saveRoom(String? ownerID, RoomModel? room) async {
    room?.roomNumber = Random().nextInt(999999).toString().padLeft(6, '0');
    room?.active = true;
    UserModel? owner = await getUser(ownerID);
    room?.ownerID = owner?.userID;
    room?.ownerName = owner?.username;
    room?.city = owner?.city;
    room?.members = [ownerID];
    return await firestoreDBService.saveRoom(ownerID, room);
  }

  @override
  Future<int> getCollectionLenght(String? collectionName) async {
    return await firestoreDBService.getCollectionLenght(collectionName);
  }

  @override
  Future<RoomModel?> getRoom(String? roomID) async {
    RoomModel? room = await firestoreDBService.getRoom(roomID);
    return room;
  }

  @override
  Future<RoomModel?> updateRoom(String? roomID, RoomModel? newRoom) async {
    RoomModel? room = await firestoreDBService.updateRoom(roomID, newRoom);
    return room;
  }

  @override
  Future<Map<dynamic, dynamic>> listRoomsByUserID(String? userID) async {
    return await firestoreDBService.listRoomsByUserID(userID);
  }

  @override
  Future<List<dynamic>> listRoomsByCategory(String? category) async {
    return await firestoreDBService.listRoomsByCategory(category);
  }

  @override
  Future<RoomModel?> getRoomByRoomNumber(String? roomNumber) async {
    RoomModel? room = await firestoreDBService.getRoomByRoomNumber(roomNumber);
    return room;
  }

  ////////////////////////////////////////////////////////////////////////////////

  @override
  Future<ChatModel?> getChat(String? chatID) async {
    ChatModel? chat = await firestoreDBService.getChat(chatID);
    return chat;
  }

  @override
  Future<ChatModel?> getChatByRoomID(String? roomID) async {
    return await firestoreDBService.getChatByRoomID(roomID);
  }

  @override
  Future<List<dynamic>?> addMessage(String? chatID, UserModel? user, String? message) async {
    return await firestoreDBService.addMessage(chatID, user, message);
  }

  @override
  Stream<List<dynamic>> getMessages(String? chatID) {
    return firestoreDBService.getMessages(chatID);
  }
}
