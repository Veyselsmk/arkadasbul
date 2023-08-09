import 'package:friend_circle/Widgets/sign_button.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';

import 'package:friend_circle/view_model/view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {

  /////user TEST DATA

  var userEmail = "kkkkkaaaa@jjkasd.com";
  var userPassword ="asasdasdasd";
  var abilities= "asdasdasd";
  var username = "asdasda";
  var bio = "asdasda";
  var city = "asdasdsd";
  var imgURL= "asdasdad";
  var phoneNo= "asdasdasd";
  ////Room Test DATA

  var category = "asdasd";
  var location = "asdasd";
  var capacity = "6";
  var date = "asdasdas";
  var desc = "asdasda";
  var roomname = "asdasd";

  /////Chat TEST DATA
  var message = "asdasda";


  TestPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Test Page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SignButton(
                onPressed: () => userRegister(context),
                buttonColor: Colors.lightBlue,
                buttonText: "User Register",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => userLogin(context),
                buttonColor: Colors.lightBlue,
                buttonText: "User Login",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => userProfileUpdate(context),
                buttonColor: Colors.lightBlue,
                buttonText: "User Update Profile",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => getUser(context),
                buttonColor: Colors.lightBlue,
                buttonText: "Get User By ID",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () =>createRoom(context),
                buttonColor: Colors.lightBlue,
                buttonText: "Create Room",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () =>getRoom(context),
                buttonColor: Colors.lightBlue,
                buttonText: "Get Room By RoomID",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => updateRoom(context),
                buttonColor: Colors.lightBlue,
                buttonText: "Update Room",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => listRoomsByUserID(context),
                buttonColor: Colors.lightBlue,
                buttonText: "list Rooms by UserID",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => listRoomsByCategory(context),
                buttonColor: Colors.lightBlue,
                buttonText: "list Room By Category",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => listRoomsByCategory(context),
                buttonColor: Colors.lightBlue,
                buttonText: "list Rooms By Category",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => getRoomByRoomNumber(context),
                buttonColor: Colors.lightBlue,
                buttonText: "get Room By RoomNumber",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => getChat(context),
                buttonColor: Colors.lightBlue,
                buttonText: "get Chat",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => getChatByRoomID(context),
                buttonColor: Colors.lightBlue,
                buttonText: "get Chat BY Room ID",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => chatSendMessage(context),
                buttonColor: Colors.lightBlue,
                buttonText: "send Messages",
                textColor: Colors.amberAccent,
              ),
              SignButton(
                onPressed: () => chatGetMessage(context),
                buttonColor: Colors.lightBlue,
                buttonText: "get Messages",
                textColor: Colors.amberAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
  //debugPrint("!!!!!!: ${}");
  void userRegister(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var user =await userViewModel.register(userEmail, userPassword);
    debugPrint("!!!!!! USER REGISTGER: ${user.toString()}");
  }

  void userLogin(BuildContext context) async{
  final userViewModel = Provider.of<ViewModel>(context, listen: false);
  var user =await userViewModel.login(userEmail, userPassword);
  debugPrint("!!!!!! USER LOGIN: ${user.toString()}");
  }

  void userProfileUpdate(BuildContext context) async{
  final userViewModel = Provider.of<ViewModel>(context, listen: false);
  UserModel? newUser = UserModel(
  userID: userViewModel.user?.userID,
  email: userEmail,
  city: city,
  imgURL: imgURL,
  //abilities: abilities,
  username: username,
  //phoneNo: phoneNo,
  bio: bio
  );
  var user = await userViewModel.updateUser(userViewModel.user?.userID, newUser);
  debugPrint("!!!!!! USER UPDATE: ${user.toString()}");
  }

  void getUser(BuildContext context) async{
  final userViewModel = Provider.of<ViewModel>(context, listen: false);
  var userID= "1DiPU9zzTDQI85GBigkwq3HcVPh1";
  var user = await userViewModel.getUser(userID);
  debugPrint("!!!!!! USER GET: ${user.toString()}");
  }

  void createRoom(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    RoomModel? draft = RoomModel(
      category: category,
      location: location,
      capacity: capacity,
      date: date,
      desc: desc,
      roomName: roomname
    );
    var room = await userViewModel.createRoom(userViewModel.user?.userID, draft);
    debugPrint("!!!!!! ROOM CREATE: ${room.toString()}");
  }

  void getRoom(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var roomID= "wMZVJPkHEcCkr6qSB7F8";
    var room = await userViewModel.getRoom(roomID);
    debugPrint("!!!!!! ROOM GET BY ROOM ID: ${room.toString()}");
  }

  void updateRoom(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var roomID = "wMZVJPkHEcCkr6qSB7F8";
    RoomModel? draft = RoomModel(
        category: category,
        location: location,
        capacity: capacity,
        date: date,
        desc: desc,
        roomName: roomname,
        active: false
    );
    var room = await userViewModel.updateRoom(roomID, draft);
    debugPrint("!!!!!! ROOM UPDATE: ${room.toString()}");
  }

  void listRoomsByUserID(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var userID = userViewModel.user?.userID;
    var rooms = await userViewModel.listRoomsByUserID(userID);
    debugPrint("!!!!!! ROOM LIST BY ROOM ID: ${rooms.toString()}");
  }

  void listRoomsByCategory(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var category = "ent";
    //var subCategory = "sss";
    var rooms = await userViewModel.listRoomsByCategory(category);
    debugPrint("!!!!!! ROOM LIST BY ROOM ID: ${rooms.toString()}");
  }

  void getRoomByRoomNumber(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var roomNumber = "183433";
    var room = await userViewModel.getRoomByRoomNumber(roomNumber);
    debugPrint("!!!!!! ROOM LIST BY ROOM NUMBER: ${room.toString()}");
  }

  void getChat(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var chatID="dj9QBweeSPTDRvO8oxqm";
    var chat = await userViewModel.getChat(chatID);
    debugPrint("!!!!!! CHAT GET BY CHAT ID: ${chat.toString()}");
  }

  void getChatByRoomID(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var roomID="wMZVJPkHEcCkr6qSB7F8";
    var chat = await userViewModel.getChatByRoomID(roomID);
    debugPrint("!!!!!! CHAT GET BY ROOM ID: ${chat.toString()}");
  }

  void chatSendMessage(BuildContext context) async{
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var chatID = "rOut3j7FCXKE1SkQ7eJK";
    var msg = "asdasd";
    var message = await userViewModel.sendMessage(chatID, userViewModel.user, msg);
    debugPrint("!!!!!! CHAT GET BY CHAT ID: ${message.toString()}");
  }

  void chatGetMessage(BuildContext context)  {
    final userViewModel = Provider.of<ViewModel>(context, listen: false);
    var chatID = "rOut3j7FCXKE1SkQ7eJK";
    var message = userViewModel.getMessages(chatID);
    message.forEach((element) {
      debugPrint("/n");
      print("/n asdasd::${element[1].toString()}");
      debugPrint("/n");
    });
  }



}
