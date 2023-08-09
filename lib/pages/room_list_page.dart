import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_detail_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RoomListPage extends StatefulWidget {
  final UserModel? user;
  final String? category;
  final List<dynamic>? myRooms;

  const RoomListPage({Key? key, this.category, this.user, this.myRooms}) : super(key: key);

  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  Future<List<dynamic>>? _roomsFuture;

  @override
  void initState() {
    super.initState();
    _refreshRooms();
  }

  Future<void> _refreshRooms() async {
    setState(() {
      _roomsFuture = _getRooms();
    });
  }

  Future<List<dynamic>> _getRooms() async {
    if (widget.myRooms != null) {
      return widget.myRooms!;
    } else {
      final viewModel = Provider.of<ViewModel>(context, listen: false);
      var rooms = await viewModel.listRoomsByCategory(widget.category);
      rooms.removeWhere((element) => element.city != widget.user!.city);
      return rooms;
    }
  }

  Widget _buildCard(BuildContext context, RoomModel room) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Expanded(
              child: _buildLabelAndText('Oda Numarası', room.roomNumber!),
            ),
            Expanded(
              child: _buildLabelAndText('Oda Sahibi', room.ownerName!),
            ),
            Expanded(
              child: _buildLabelAndText('Yer', room.location!),
            ),
          ],
        ),
        children: <Widget>[
          _buildDetailsRow(context, room),
        ],
      ),
    );
  }

  Widget _buildLabelAndText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(BuildContext context, RoomModel room) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _buildLabelAndText('Açıklama', room.desc!),
          ),
          Expanded(
            child: _buildLabelAndText('kapasite', "${room.members!.length}/${room.capacity}"),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.myRooms == null) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => navigateFuturebuilder(context, room)),
                      (route) => route.isFirst,
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => navigateFuturebuilder(context, room)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              textStyle: TextStyle(fontSize: 16),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.myRooms != null ? Text("Odaya Git") : Text("Katıl"),
          ),
        ],
      ),
    );
  }

  FutureBuilder navigateFuturebuilder(BuildContext context, RoomModel? room) {
    return FutureBuilder(
      future: joinRoom(context, room),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return RoomDetailPage(user: widget.user, room: snapshot.data);
        } else {
          return Scaffold(
            body: Center(child: Text('Odaya Ulaşmakta bir Sorun Yaşandı.')),
          );
        }
      },
    );
  }

  Future joinRoom(BuildContext context, RoomModel? room) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    RoomModel? newRoom = await viewModel.getRoom(room!.roomID);
    if (newRoom!.members!.length < int.parse(newRoom.capacity!)) {
      if (newRoom.members!.contains(widget.user!.userID)) {
        return newRoom;
      } else {
        newRoom.members!.add(widget.user!.userID);
        return await viewModel.updateRoom(newRoom.roomID, newRoom);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.category != null ? AppBar(title: Text(widget.category!)) : null,
      body: RefreshIndicator(
        onRefresh: _refreshRooms,
        child: FutureBuilder<List<dynamic>>(
          future: _roomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final rooms = snapshot.data!;

              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return _buildCard(context, rooms[index]);
                },
              );
            } else {
              return Center(child: Text('Oda Bulunamadı'));
            }
          },
        ),
      ),
    );
  }
}
