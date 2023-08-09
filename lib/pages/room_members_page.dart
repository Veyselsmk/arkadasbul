import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/pages/profile_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RoomMembersPage extends StatefulWidget {
  final RoomModel? room;
  final UserModel? user;

  const RoomMembersPage({Key? key, this.room, this.user}) : super(key: key);

  @override
  State<RoomMembersPage> createState() => _RoomMembersPageState();
}

class _RoomMembersPageState extends State<RoomMembersPage> {
  late StreamController<List<UserModel?>> _membersStreamController;
  late Stream<List<UserModel?>> _membersStream;
  List<UserModel?> _currentMembers = [];

  @override
  void initState() {
    super.initState();
    _membersStreamController = StreamController<List<UserModel?>>();
    _membersStream = _membersStreamController.stream;
    _getMembersAndUpdateStream();
  }

  @override
  void dispose() {
    _membersStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserModel?>>(
        stream: _membersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _refreshMembers,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildMemberCard(context, snapshot.data![index]);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _getMembersAndUpdateStream() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    RoomModel? room = await viewModel.getRoom(widget.room!.roomID);
    List<UserModel?> users = [];
    for (String? member in room!.members!) {
      UserModel? user = await viewModel.getUser(member);
      users.add(user);
    }

    if (_currentMembers.length != users.length) {
      _currentMembers = users;
      _membersStreamController.add(users);
    }
  }

  Future<void> _refreshMembers() async {
    await _getMembersAndUpdateStream();
  }

  Card _buildMemberCard(BuildContext context, UserModel? user) {
    final bool isRoomOwner = user?.userID == widget.room?.ownerID;
    final bool isCurrentUser = user?.userID == widget.user?.userID;
    final bool isAdmin = widget.room?.ownerID == widget.user?.userID;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.imgURL!),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isRoomOwner ? 'Yönetici' : 'Üye',
                          style: TextStyle(color: Colors.blue.shade800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isCurrentUser)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user)));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade500,
                      onPrimary: Colors.white,
                    ),
                    child: const Text(
                      'Profile Git',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(width: 8),
                if (widget.room?.active == true)
                  if (isAdmin && !isCurrentUser)
                    ElevatedButton(
                      onPressed: () {
                        kickUserFromRoom(user);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                      child: const Text(
                        'Odadan At',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void kickUserFromRoom(UserModel? user) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    RoomModel? room = await viewModel.getRoom(widget.room!.roomID);
    room!.members!.remove(user!.userID);
    await viewModel.updateRoom(room.roomID, room);
    _getMembersAndUpdateStream();
  }
}
