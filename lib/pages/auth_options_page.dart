
// giriş yap seçenek butonları olacak
// email butonu
  // email butonuna tıklandığında login_page gidecek
// google butonu tıklandığında
  // google ile oturum açacak başarılı ise profile page gidecek değilse hata verecek

import 'package:flutter/material.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/pages/login_page.dart';
import 'package:sign_button/sign_button.dart';

class AuthOptionsPage extends StatelessWidget {
  const AuthOptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButton(
            buttonType: ButtonType.mail,
            btnText: "Mail ile oturum aç",
            buttonSize: ButtonSize.large,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          Divider(),
          SignInButton(
            buttonType: ButtonType.google,
            btnText: "Google ile oturum aç",
            buttonSize: ButtonSize.large,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
    );
  }
}

