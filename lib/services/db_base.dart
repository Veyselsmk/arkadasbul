import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';

abstract class DBBase {
  Future<UserModel?> saveUser(UserModel? user);
  Future<UserModel?> getUser(String? userID);
  Future<UserModel?> updateUser(String? userID, UserModel? newUser);
  ////
  Future<int> getCollectionLenght(String? collectionName);
  ////
  Future<RoomModel?> saveRoom(String? ownerId, RoomModel? room);
  Future<RoomModel?> getRoom(String? roomID);
  Future<RoomModel?> getRoomByRoomNumber(String? roomNumber);
  Future<RoomModel?> updateRoom(String? roomID, RoomModel? newRoom);
  Future<Map<dynamic,dynamic>> listRoomsByUserID(String? userID);
  Future<List<dynamic>> listRoomsByCategory(String? category);
  ////
  //Future<ChatModel?> saveChat(ChatModel? chat,RoomModel? room); //her oda kurulduğunda oda ismi ile chat oluşturur
  Future<ChatModel?> getChat(String? chatID); // chat listeler
  Future<ChatModel?> getChatByRoomID(String? roomID);
  //Future<ChatModel> updateChat(String? chatID,ChatModel? chat); // oda kapandığında chat pasifleştirir veya member azaltır
  Future<List<dynamic>?> addMessage(String? chatID,UserModel? user,String? message); // doc da message alanını update eder
  Stream<List<dynamic>> getMessages(String? chatID);




}
