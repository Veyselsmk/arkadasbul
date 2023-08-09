import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/pages/room_update_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RoomInformationPage extends StatefulWidget {
  final RoomModel? room;
  final UserModel? user;

  const RoomInformationPage({Key? key, this.room, this.user}) : super(key: key);

  @override
  _RoomInformationPageState createState() => _RoomInformationPageState();
}

class _RoomInformationPageState extends State<RoomInformationPage> {
  RoomModel? room;
  bool isLoading = false;

  @override
  void initState() {
    room = widget.room;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshRoom,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Oda Bilgileri',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                roomField(
                  label: 'Oda İsmi',
                  value: room?.roomName,
                  icon: Icons.home,
                ),
                roomField(
                  label: 'Açıklama',
                  value: room?.desc,
                  icon: Icons.description_outlined,
                ),
                roomField(
                  label: 'Oda Numarası',
                  value: room?.roomNumber,
                  icon: Icons.format_list_numbered,
                ),
                roomField(
                  label: 'Oda Sahibi',
                  value: room?.ownerName,
                  icon: Icons.person,
                ),
                roomField(
                  label: 'Kategori',
                  value: room?.category,
                  icon: Icons.category,
                ),
                roomField(
                  label: 'Tarih',
                  value: room?.date,
                  icon: Icons.calendar_today,
                ),
                roomField(
                  label: 'Kapasite',
                  value: '${room?.members?.length ?? 0}/${room?.capacity ?? 0}',
                  icon: Icons.people,
                ),
                roomField(
                  label: 'Yer',
                  value: room?.location,
                  icon: Icons.location_on,
                ),
                SizedBox(height: 20),
                if (room?.active == true)
                  if (widget.user?.userID == room?.ownerID)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomUpdatePage(user: widget.user!, room: room!)));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text(
                        "Odayı Güncelle",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        leaveRoom(context);
                        Navigator.of(context).pop(MaterialPageRoute(builder: (context) => HomePage(user: widget.user!)));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                      child: Text(
                        "Odadan Ayrıl",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget roomField({required String label, String? value, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value ?? 'N/A',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _refreshRoom() async {
    setState(() {
      isLoading = true;
    });


    final viewModel = Provider.of<ViewModel>(context, listen: false);
    final updatedRoom = await viewModel.getRoom(room!.roomID);
    setState(() {
      room = updatedRoom;
      isLoading = false;
    });
  }

  void leaveRoom(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    room!.members!.remove(widget.user!.userID);
    await viewModel.updateRoom(room!.roomID, room);
  }
}
