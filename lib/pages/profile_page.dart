import 'package:flutter/material.dart';
import 'package:friend_circle/main.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/landing_page.dart';
import 'package:friend_circle/pages/login_page.dart';
import 'package:friend_circle/pages/profile_update_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;

  const ProfilePage({Key? key, this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool? isCurrent;

  @override
  void initState() {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.user != null && viewModel.user != null) {
        if (widget.user!.userID == viewModel.user!.userID) {
          setState(() {
            isCurrent = true;
          });
        } else {
          setState(() {
            isCurrent = false;
          });
        }
      } else {
        setState(() {
          isCurrent = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green, // Set the background color here
      appBar: checkUser(context),
      body: Stack(
        children: [
          Container(
            color: Colors.blue[100],
          ),
          profile(widget.user),
        ],
      ),
    );
  }

  AppBar checkUser(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context, listen: false);

    if (isCurrent == true) {
      return AppBar(
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings_outlined),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileUpdatePage(user: widget.user),
                ));
              }
              if (value == 'logout') {
                logout(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Profili Güncelle'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Çıkış Yap'),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return AppBar(
        title: Text(viewModel.user!.username!),
      );
    }
  }

  Widget profile(UserModel? user) {
    debugPrint(user.toString());
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(user!.imgURL!),
              backgroundColor: Colors.transparent,
            ),

            SizedBox(height: 16),
            Text(
              user!.username!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user!.city!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  profileField(
                    Icons.email_outlined,
                    "Email",
                    user!.email!,
                    Colors.blue[900]!,
                  ),
                  SizedBox(height: 12),
                  profileField(
                    Icons.info_outlined,
                    "Bio",
                    user!.bio!,
                    Colors.green[900]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileField(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    //debugPrint(viewModel.user.toString());
    viewModel.logOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => route.isCurrent);
  }
}
