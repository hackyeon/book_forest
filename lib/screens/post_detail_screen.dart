import 'package:flutter/material.dart';
import 'package:book_forest/api/api.dart' as api;
import 'package:book_forest/api/url.dart' as url;
import 'package:book_forest/utils/toast_util.dart';
import 'package:book_forest/utils/preference_util.dart' as pref;

class PostDetailScreen extends StatefulWidget {
  final int postIdx;

  PostDetailScreen({required this.postIdx});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Map<String, dynamic> post;  // 게시글 데이터를 저장할 변수
  bool isLoading = true;       // 로딩 상태 관리
  bool isOwner = false;            // 사용자가 게시글 작성자인지 확인

  @override
  void initState() {
    super.initState();
    fetchPostDetail();  // 화면 로드 시 게시글 상세 정보를 불러옴
  }

  Future<void> fetchPostDetail() async {
    var json = {'postIdx': widget.postIdx};
    var response = await api.request(url.POST_GET, json);

    if (response['result'] == 0) {
      var _post = response['json']['post'];
      if(_post == null) {
        toast("게시글을 찾을 수 없습니다.");
        Navigator.pop(context);
      } else {
        var localEmail = await pref.getString(pref.KEY_LOGIN_EMAIL);
        var postEmail = _post['email'];
        setState(() {
          post = _post; // API 응답 데이터 저장
          isOwner = localEmail == postEmail;
          isLoading = false;  // 로딩 완료
        });
      }
    } else {
      // 오류 처리 (필요에 따라 에러 메시지 표시 가능)
      toast("게시글을 찾을 수 없습니다.");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세'),
        actions: isOwner
            ? [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 게시글 수정 로직 추가
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // 게시글 삭제 로직 추가
            },
          ),
        ]: null,  // 작성자가 아니면 actions를 숨김
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // 로딩 중일 때 표시할 위젯
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              post['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(post['content']),
          ],
        ),
      )
    );
  }
}
