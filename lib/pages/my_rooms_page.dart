import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_list_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class MyRoomsPage extends StatefulWidget {
  final UserModel? user;

  const MyRoomsPage({Key? key, this.user}) : super(key: key);

  @override
  State<MyRoomsPage> createState() => _MyRoomsPageState();
}

class _MyRoomsPageState extends State<MyRoomsPage> {
  late ViewModel viewModel;
  var activeRoomsFuture;
  var passiveRoomsFuture;

  @override
  void initState() {
    viewModel = Provider.of<ViewModel>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var TempActiveRooms = await getRooms("active");
      var TempPassiveRooms = await getRooms("passive");
      setState(() {
        activeRoomsFuture = TempActiveRooms;
        passiveRoomsFuture = TempPassiveRooms;
      });
    });

    super.initState();
  }

  FutureBuilder roomList(String value) {
    return FutureBuilder(
      future: getRooms(value),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return RoomListPage(myRooms: snapshot.data, user: widget.user);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text('No data available');
          }
        }
      },
    );
  }

  Future getRooms(String value) async {
    var rooms = await viewModel.listRoomsByUserID(widget.user!.userID);
    return rooms[value];
  }

  Future<void> _refreshRooms() async {
    var TempActiveRooms = await getRooms("active");
    var TempPassiveRooms = await getRooms("passive");
    setState(() {
      activeRoomsFuture = TempActiveRooms;
      passiveRoomsFuture = TempPassiveRooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Odalarım"),
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Aktif Odalarım")),
              Tab(child: Text("Pasif Odalarım")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _refreshRooms,
              child: roomList("active"),
            ),
            RefreshIndicator(
              onRefresh: _refreshRooms,
              child: roomList("passive"),
            ),
          ],
        ),
      ),
    );
  }
}
