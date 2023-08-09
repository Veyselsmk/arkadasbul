import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/pages/login_page.dart';
import 'package:friend_circle/pages/profile_update_page.dart';
import 'package:friend_circle/pages/register_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _containerWidthAnimation;
  late Animation<double> _containerHeightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _containerWidthAnimation = Tween<double>(begin: 200, end: 300).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.ease),
      ),
    );

    _containerHeightAnimation = Tween<double>(begin: 50, end: 60).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.ease),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTitle(),
                  SizedBox(height: 40),
                  AnimatedContainer(
                    width: _containerWidthAnimation.value,
                    height: _containerHeightAnimation.value,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: _buildEmailTextField(),
                  ),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    width: _containerWidthAnimation.value,
                    height: _containerHeightAnimation.value,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: _buildPasswordTextField(),
                  ),
                  SizedBox(height: 30),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: _buildLoginButton(),
                  ),
                  SizedBox(height: 30),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Kayıt Ol',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40.0,
        color: Colors.blue[900],
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Email Adres',
        labelStyle: TextStyle(color: Colors.blue[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
      ),
      style: TextStyle(color: Colors.blue[900]),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Şifre',
        labelStyle: TextStyle(color: Colors.blue[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
        suffixIcon: Icon(Icons.remove_red_eye, color: Colors.blue[900]),
      ),
      style: TextStyle(color: Colors.blue[900]),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => navigateFutureBuilder()),
              (route) => route.isCurrent,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        'Kayıt Ol',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hesabınız Var Mı? ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage())),
          child: Text(
            'Giriş Yapın',
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }


  FutureBuilder navigateFutureBuilder() {
    return FutureBuilder(
      future: register(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return ProfileUpdatePage(user: snapshot.data);
        } else if (snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bir hata oluştu. Tekrar deneyin'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          });
          // Refresh the page if login fails
          return RegisterPage();
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }


  Future register() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    await viewModel.register(email, password);
    UserModel? currentUser = await viewModel.getCurrentUser();
    UserModel? user = await viewModel.getUser(currentUser!.userID);
    return user;




  }


}
