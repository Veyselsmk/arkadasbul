
// bu sayfa 6 haneli bir oda numarası isteyen alan olacak
// bu alan girildiğinde ilgili oda ya kullanıcı katılım yapacak ve room_detail_page e yönlendirilecek
// eğer oda bulunamassa hata verecek

import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_detail_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RoomJoinPage extends StatefulWidget {
  final UserModel? user;
  const RoomJoinPage({Key? key,this.user}) : super(key: key);

  @override
  State<RoomJoinPage> createState() => _RoomJoinPageState();
}

class _RoomJoinPageState extends State<RoomJoinPage> {
  String? roomNumber;

  TextEditingController? _roomNumberController;


  @override
  void initState() {
    _roomNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _roomNumberController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _roomNumberController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter 6-digit code',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    roomNumber = _roomNumberController!.text;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => navigateFuturebuilder()),
                    );
                  },
                  child: Text('katıl')
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder navigateFuturebuilder() {
    return FutureBuilder(
      future: joinRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return RoomDetailPage(user: widget.user, room: snapshot.data);
        } else {
          return Scaffold(
            body: Center(child: Text('bir hata oluştu')),
          );
        }
      },
    );
  }



  Future joinRoom() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    RoomModel? room = await viewModel.getRoomByRoomNumber(roomNumber);
    if (room!.members!.length < int.parse(room.capacity!)) {
      if (room.members!.contains(widget.user!.userID)) {
        return room;
      } else {
        if(room.active == true){
          room.members?.add(widget.user?.userID);
          return await viewModel.updateRoom(room.roomID,room);
        }
        return null;
      }
    }
  }

}
