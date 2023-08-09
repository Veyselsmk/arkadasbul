import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/category_page.dart';
import 'package:friend_circle/pages/my_rooms_page.dart';
import 'package:friend_circle/pages/profile_page.dart';
import 'package:friend_circle/pages/room_create_page.dart';
import 'package:friend_circle/pages/room_join_page.dart';

class HomePage extends StatelessWidget {
  final UserModel? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arkadaş Bul'),
      ),
      //backgroundColor: Colors.grey[200], // Set the background color here
      body: Column(
        children: [
          buildUserSection(context),
          buildButtonsSection(context),
        ],
      ),
    );
  }

  Widget buildUserSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: user!),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                user?.city ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Flexible(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(user!.imgURL!),
                backgroundColor: Colors.transparent,
              ),
            ),
            Flexible(
              child: Text(
                user?.username ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonsSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            buildElevatedButton(
              'Oda Kur',
              Icons.add,
              Colors.orange,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoomCreatePage(user: user!),
                  ),
                );
              },
            ),
            buildElevatedButton(
              'Oda Seç',
              Icons.search,
              Colors.blue,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(user: user!),
                  ),
                );
              },
            ),
            buildElevatedButton(
              'Odalarım',
              Icons.home,
              Colors.green,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyRoomsPage(user: user!),
                  ),
                );
              },
            ),
            buildElevatedButton(
              'Katıl',
              Icons.person_add,
              Colors.purple,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoomJoinPage(user: user!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildElevatedButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        primary: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
