class ChatModel {
  String? chatID;
  String? roomID;
  List<dynamic>? members;
  List<dynamic>? messages;
  String? chatName;
  bool? active;


ChatModel({this.chatID, this.roomID, this.members, this.messages, this.chatName,this.active});

  Map<String, dynamic> toMap() {
    return {
      'chatID': chatID,
      'roomID': roomID,
      'members': members ?? [],
      'messages': messages ?? [],
      'chatName': chatName ?? '',
      'active': active,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic>? map) {
    return ChatModel(
      chatID: map?['chatID'] as String?,
      roomID: map?['roomID'] as String?,
      members: map?['members'] as List<dynamic>?,
      messages: map?['messages'] as List<dynamic>?,
      chatName: map?['chatName'] as String?,
      active: map?['active'] as bool?,
    );
  }

  @override
  String toString() {
    return 'ChatModel{chatID: $chatID, roomID: $roomID, members: $members, messages: $messages, chatName: $chatName, active: $active}';
  }
}
