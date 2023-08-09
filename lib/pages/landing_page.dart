import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/pages/login_page.dart';
import 'package:friend_circle/pages/profile_update_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasData) {
              if(snapshot.data!.username !=null || snapshot.data!.city!=null) {
                return HomePage(user: snapshot.data!);
              } else {
                return ProfileUpdatePage(user: snapshot.data!);
              }
            } else {
              return LoginPage();
            }
          }
        });
  }

  Future<UserModel?> getUser(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    UserModel? currentUser = await viewModel.getCurrentUser();
    UserModel? user = await viewModel.getUser(currentUser!.userID);
    return user;

  }
}
