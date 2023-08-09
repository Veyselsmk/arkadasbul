import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_circle/models/chat_model.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RoomChatPage extends StatefulWidget {
  final RoomModel? room;
  final UserModel? user;

  const RoomChatPage({Key? key, this.room, this.user}) : super(key: key);

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  ChatModel? chat;
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? newMessage;
  bool isKeyboardVisible = false;
  bool isScrollAtBottom = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getChat();
    });
    SystemChannels.textInput.invokeMethod('TextInput.show').whenComplete(() {
      setState(() {
        isKeyboardVisible = true;
      });
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (isScrollAtBottom) {
          scrollToBottom();
        }
      });
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide').whenComplete(() {
      setState(() {
        isKeyboardVisible = false;
      });
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (!isScrollAtBottom && !isKeyboardVisible) {
          scrollToBottom();
        }
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFECE5DD),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    if (isScrollAtBottom && !isKeyboardVisible) {
                      scrollToBottom();
                    }
                  });
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return chatBubble(snapshot.data![index]);
                    },
                  );
                },
              ),
            ),
            if(widget.room?.active==true)
            if (!isKeyboardVisible)
              buildMessageInput(),
            if (isKeyboardVisible)
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Stream<List<dynamic>> getMessages() {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    return viewModel.getMessages(chat?.chatID);
  }

  Future<void> getChat() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    final chatTemp = await viewModel.getChatByRoomID(widget.room!.roomID);
    setState(() {
      chat = chatTemp;
    });
  }

  Widget chatBubble(Map message) {
    final isCurrentUser = widget.user?.userID == message['fromUser'];
    final BorderRadius borderRadius = BorderRadius.circular(8);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                CircleAvatar(
                  backgroundImage: NetworkImage(message['userImage']),
                  radius: 16,
                  backgroundColor: Colors.transparent,
                ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: isCurrentUser ? Colors.lightGreenAccent[100] : Colors.white,
                  ),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['message'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['username'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isCurrentUser)
                CircleAvatar(
                  backgroundImage: NetworkImage(message['userImage']),
                  radius: 16,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: messageController,
              cursorColor: Colors.blueGrey,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                hintText: 'Bir Mesaj Yazın',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.send, // Set the text input action
              onEditingComplete: () {
                if (messageController.text.trim().isNotEmpty) {
                  sendMessage();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                sendMessage();
              }
            },
          ),
        ],
      ),
    );
  }


  void sendMessage() {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    newMessage = messageController.text.trim();
    if (newMessage!.isNotEmpty) {
      viewModel.sendMessage(chat?.chatID, widget.user, newMessage);
      messageController.clear();
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      isScrollAtBottom = true;
    }
  }
}
