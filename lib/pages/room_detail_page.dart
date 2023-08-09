import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_chat_page.dart';
import 'package:friend_circle/pages/room_create_page.dart';
import 'package:friend_circle/pages/room_information_page.dart';
import 'package:friend_circle/pages/room_list_page.dart';
import 'package:friend_circle/pages/room_members_page.dart';
import 'package:friend_circle/pages/room_update_page.dart';

class RoomDetailPage extends StatefulWidget {
  final RoomModel? room;
  final UserModel? user;
  //final bool? active;

  const RoomDetailPage({Key? key, this.room, this.user}) : super(key: key);

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room!.roomName!),
        titleSpacing: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text("Oda Bilgisi")),
            Tab(child: Text("Katılımcılar")),
            Tab(child: Text("Sohbet")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RoomInformationPage(room: widget.room!, user: widget.user!),
          RoomMembersPage(room: widget.room!, user: widget.user!),
          RoomChatPage(room: widget.room!, user: widget.user!),
        ],
      ),
    );
  }
}
