import 'package:book_forest/screens/post_list_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCodeSent = false;

  _sendVerificationCode() {
    // 여기에 인증 코드 발송 API를 추가하세요.
    setState(() {
      _isCodeSent = true;
    });
  }

  _verifyCode() {
    // 여기에 인증 코드 확인 API를 추가하세요.
    if (_codeController.text.isNotEmpty) {
      // 인증이 성공하면 다음 화면으로 이동.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일 입력',
              ),
            ),
            SizedBox(height: 20),
            if (_isCodeSent)
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: '인증번호 입력',
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCodeSent ? _verifyCode : _sendVerificationCode,
              child: Text(_isCodeSent ? '인증번호 확인' : '인증번호 발송'),
            ),
          ],
        ),
      ),
    );
  }
}
