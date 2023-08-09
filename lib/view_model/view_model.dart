import 'dart:io';

import 'package:friend_circle/locator.dart';
import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/repository/user_repository.dart';
import 'package:friend_circle/services/auth_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_circle/services/storage_base.dart';

class ViewModel with ChangeNotifier implements AuthBase, StorageBase {
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _user;
  RoomModel? _room;
  ChatModel? _chat;

  ChatModel? get chat => _chat;

  RoomModel? get room => _room;
  UserModel? get user => _user;

  ViewModel() {
    getCurrentUser();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    _user = await _userRepository.getCurrentUser();

    return _user;
  }

  @override
  Future<UserModel?> login(String? email, String? password) async {
    _user = await _userRepository.login(email, password);
    return _user;
  }

  @override
  Future<UserModel?> loginWithGoogle() async {
    _user = await _userRepository.loginWithGoogle();
    return _user;
  }

  @override
  Future<bool> logOut() async {
    bool result = await _userRepository.logOut();
    _user = null;
    return result;
  }

  @override
  Future<UserModel?> register(String? email, String? password) async {
    _user = await _userRepository.register(email, password);
    return _user;
  }

  Future<UserModel?> getUser(String? userID) async {
    _user = await _userRepository.getUser(userID);
    return _user;
  }

  Future<UserModel?> updateUser(String? userID, UserModel? newUser) async {
    _user = await _userRepository.updateUser(userID, newUser);
    return _user;
  }

  @override
  Future<String?> uploadFile(String? userID, String? fileType, File file) async {
    return await _userRepository.uploadFile(userID, fileType, file);
  }

//////////////////////////////////////////////////////////////////////////

  Future<RoomModel?> createRoom(String? ownerID, RoomModel? room) async {
    _room = await _userRepository.saveRoom(_user?.userID, room);
    return _room;
  }

  Future<RoomModel?> getRoom(String? roomID) async {
    _room = await _userRepository.getRoom(roomID);
    return _room;
  }

  Future<RoomModel?> updateRoom(String? roomID, RoomModel? newRoom) async {
    _room = await _userRepository.updateRoom(roomID, newRoom);
    return _room;
  }

  Future<Map<dynamic, dynamic>> listRoomsByUserID(String? userID) async {
    return await _userRepository.listRoomsByUserID(userID);
  }

  Future<List<dynamic>> listRoomsByCategory(String? category) async {
    return await _userRepository.listRoomsByCategory(category);
  }

  Future<RoomModel?> getRoomByRoomNumber(String? roomNumber) async {
    return await _userRepository.getRoomByRoomNumber(roomNumber);
  }

  /////////////////////////////////////////////////////////////////////

  Future<ChatModel?> getChat(String? chatID) async {
    _chat = await _userRepository.getChat(chatID);
    return _chat;
  }

  Future<ChatModel?> getChatByRoomID(String? roomID) async {
    return await _userRepository.getChatByRoomID(roomID);
  }

  Future<List<dynamic>?> sendMessage(String? chatID, UserModel? user, String? message) async {
    return await _userRepository.addMessage(chatID, user, message);
  }

  Stream<List<dynamic>> getMessages(String? chatID) {
    return _userRepository.getMessages(chatID);
  }
}
