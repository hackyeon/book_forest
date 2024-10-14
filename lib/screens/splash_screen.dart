import 'package:book_forest/screens/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:book_forest/utils/preference_util.dart' as pref;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    var email = await pref.getString(pref.KEY_LOGIN_EMAIL);
    if(email.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/bookswage_logo.png',
          width: 100,
          height: 38,
        ),
      ),
    );
  }
}
