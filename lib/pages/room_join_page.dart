
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Katıl'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '6 Basamaklı Oda Numarasını Giriniz',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            TextFormField(
              controller: _roomNumberController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                labelText: 'Oda Numarası',
                labelStyle: TextStyle(color: Colors.indigo),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                roomNumber = _roomNumberController!.text;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => navigateFuturebuilder()),
                );
              },
              child: Text(
                'Katıl',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bir hata Oluştu. Tekrar deneyin'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          });
          return RoomJoinPage(user: widget.user);
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
