import 'package:book_forest/api/url.dart' as Url;
import 'package:book_forest/screens/post_list_screen.dart';
import 'package:book_forest/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:book_forest/api/api.dart' as api;
import '../utils/preference_util.dart' as pref;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCodeSent = false;
  bool _isEmailEditable = true;

  _sendVerificationCode() async {
    // 여기에 인증 코드 발송 API를 추가하세요.
    var json = {'email': _emailController.text};
    var response = await api.request(Url.LOGIN_MAIL, json);

    if(response['result'] != 0) {
      toast(response['message']);
      return;
    }

    setState(() {
      _isCodeSent = true;
      _isEmailEditable = false;
    });
  }

  _verifyCode() async {
    // 여기에 인증 코드 확인 API를 추가하세요.
    if (_codeController.text.isNotEmpty) {
      // 인증이 성공하면 다음 화면으로 이동.
      var email = _emailController.text;
      var json = {'email': email, 'code': _codeController.text};
      var response = await api.request(Url.LOGIN, json);

      if(response['result'] != 0) {
        toast(response['message']);
        return;
      }

      await pref.setString(pref.KEY_LOGIN_EMAIL, email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostListScreen()),
      );
    }
  }

  // 메일 다시 적기 기능
  _resetEmailInput() {
    setState(() {
      _isCodeSent = false;  // 인증 코드 입력 필드 숨김
      _isEmailEditable = true;  // 이메일 다시 수정 가능하게 변경
      _emailController.clear();  // 이메일 입력 필드 초기화
      _codeController.clear();   // 인증 코드 필드 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/bookswage_logo.png',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이메일 입력 또는 텍스트로 변환된 이메일 표시
            _isEmailEditable
                ? TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일 입력',
              ),
            )
                : Text(
              _emailController.text,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // 인증 코드 입력 필드 (메일이 발송된 후에만 보임)
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
            if (_isCodeSent)
              TextButton(
                onPressed: _resetEmailInput,
                child: Text('메일 다시 적기'),
              ),
          ],
        ),
      ),
    );
  }
}
