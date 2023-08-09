
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';


class RoomChatPage extends StatefulWidget {
  final String? roomID;

  const RoomChatPage({Key? key, this.roomID}) : super(key: key);

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  var viewModel;
  UserModel? currentUser;
  ChatModel? chat;
  RoomModel? room;
  TextEditingController? messageController;
  ScrollController _scrollController = ScrollController();
  String? newMessage;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ViewModel>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getRoom();
    });
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<List<dynamic>>(
        stream: getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return chatBubble(snapshot.data![index]);
                  },
                ),
              ),
              addMessage(),
            ],
          );
        },
      ),
    );
  }

  Stream<List<dynamic>> getMessages() {
    return viewModel.getMessages(chat?.chatID);
  }

  void getRoom() async {
    var roomTemp = await viewModel.getChat(widget.roomID);
    var chatTemp = await viewModel.getChatByRoomID(widget.roomID);
    setState(() {
      room = roomTemp;
      chat = chatTemp;
      currentUser = viewModel.user;
    });
  }

  Widget chatBubble(Map message) {
    final isCurrentUser = currentUser?.userID == message['fromUser'];
    final borderRadius = BorderRadius.circular(16);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    CircleAvatar(
                      backgroundImage: NetworkImage(message['userImage']),
                    ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: isCurrentUser ? Colors.lightBlue : Colors.grey.shade300,
                      ),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(4),
                      child: Text(
                        message['message'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isCurrentUser ? Colors.white : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  if (isCurrentUser)
                    CircleAvatar(
                      backgroundImage: NetworkImage(message['userImage']),
                    ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      message['username'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addMessage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                controller: messageController,
                cursorColor: Colors.blueGrey,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  hintText: "Write your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.send,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  newMessage = messageController!.text;
                  sendMessage();
                  messageController?.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    await viewModel.sendMessage(chat?.chatID, currentUser, newMessage);
  }
}



















/*
class RoomChatPage extends StatefulWidget {
  final String? roomID;
  const RoomChatPage({Key? key, this.roomID}) : super(key: key);

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  var viewModel;
  UserModel? currentUser;
  ChatModel? chat;
  RoomModel? room;
  TextEditingController? messageController;
  ScrollController _scrollController = new ScrollController();
  String? newMessage;
  @override
  void initState() {
    viewModel = Provider.of<ViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRoom();
    });
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
          stream: getMessages(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CircularProgressIndicator();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      controller: _scrollController,
                      //reverse: true,

                      itemBuilder: (context, index) {
                        //return Text(snapshot.data![index].toString());
                        return chatBuble(snapshot.data![index]);
                      }),
                ),
                addMessage()
              ],
            );
          }),
    );
  }

  Stream<List<dynamic>> getMessages() {
    return viewModel.getMessages(chat?.chatID);
  }

  void getRoom() async {
    var roomTemp = await viewModel.getRoom(widget.roomID);
    var chatTemp = await viewModel.getChatByRoomID(widget.roomID);
    setState(() {
      room = roomTemp;
      chat = chatTemp;
      currentUser = viewModel.user;
    });
  }

  Padding chatBuble(Map message) {
    if (currentUser?.userID == message['fromUser']) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: Colors.lightBlue),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(4),
                        child: Text(message['message'],
                            style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(message['userImage']),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text(message['username'],
                          style: TextStyle(fontSize: 12, color: Colors.green, decoration: TextDecoration.none)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(message['userImage']),
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: Colors.lightBlue),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(4),
                        child: Text(message['message'],
                            style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text(message['username'],
                          style: TextStyle(fontSize: 12, color: Colors.green, decoration: TextDecoration.none)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Padding addMessage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Container(
        //height: 2,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                controller: messageController,
                cursorColor: Colors.blueGrey,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Mesajınızı Yazın",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                //focusElevation: 80,
                elevation: 0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.navigation,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  newMessage = messageController!.text;
                  sendMessage();
                  messageController?.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    await viewModel.sendMessage(chat?.chatID, currentUser, newMessage);
  }
}

 */
