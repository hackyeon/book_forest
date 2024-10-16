import 'package:book_forest/other/Config.dart';
import 'package:flutter/foundation.dart';  // kIsWeb 사용을 위해 import
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:book_forest/utils/preference_util.dart' as pref;

import 'login_screen.dart';  // 앱 버전 정보를 가져오기 위한 패키지

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String appVersion = '';  // 앱 버전 정보를 저장할 변수

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // 웹 환경일 경우 버전 수동 설정
      setState(() {
        appVersion = WEB_VERSION;  // 웹 환경에서 수동으로 버전 설정
      });
    } else {
      _getAppVersion();  // 모바일 또는 데스크탑에서 앱 버전 가져오기
    }
  }

  // 모바일 및 데스크탑에서 앱 버전 가져오기
  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;  // 앱 버전 정보 설정
      });
    } catch (e) {
      setState(() {
        appVersion = '앱 버전 정보를 가져올 수 없습니다.';
      });
    }
  }

  // 로그아웃 버튼 클릭 시 처리
  void _logout() {
    // 로그아웃 처리 로직
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                // 로그아웃 처리 로직을 여기에 추가
                Navigator.of(context).pop();  // 다이얼로그 닫기
                _navigateToLoginScreen();
              },
            ),
          ],
        );
      },
    );
  }

  // 로그인 화면으로 이동 (모든 화면 스택 제거)
  void _navigateToLoginScreen() async {
    await pref.removeString(pref.KEY_LOGIN_EMAIL);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),  // 로그인 화면으로 이동
          (Route<dynamic> route) => false,  // 모든 이전 화면 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // 뒤로 가기
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 앱 버전 정보 표시
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),  // 위, 아래 패딩 추가
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 좌우 끝에 배치
                children: [
                  Text(
                    '버전',  // 왼쪽에 '버전' 텍스트
                    style: TextStyle(fontSize: 16),  // 폰트 크기 설정
                  ),
                  Text(
                    appVersion.isEmpty ? '불러오는 중...' : appVersion,  // 오른쪽에 앱 버전
                    style: TextStyle(fontSize: 16),  // 폰트 크기 설정
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 로그아웃 버튼
            ElevatedButton(
              onPressed: _logout,
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
