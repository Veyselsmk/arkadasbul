
import 'package:friend_circle/locator.dart';

import 'package:friend_circle/pages/landing_page.dart';

import 'package:friend_circle/view_model/view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<void> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // Handle error
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => ViewModel(),
            child: MaterialApp(
              title: 'APP',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              home: LandingPage(), //MyRoomPage(userID: 'UNkvMd4OWHY5FTfmq0ikbxvPrZt1'),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());

      },
    );
  }
}

