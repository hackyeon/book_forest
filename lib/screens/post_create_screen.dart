import 'package:book_forest/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:book_forest/utils/preference_util.dart' as pref;
import 'package:book_forest/api/api.dart' as api;
import 'package:book_forest/api/url.dart' as url;

class PostCreateScreen extends StatefulWidget {
  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      toast("좀 뭐라도 써라 ㅡㅡ");
    } else {
      // 게시글 전송 로직
      var email = await pref.getString(pref.KEY_LOGIN_EMAIL);
      var json = {'email': email, 'title': _titleController.text, 'content': _contentController.text};
      var response = await api.request(url.POST_CREATE, json);
      if(response['result'] == 0) {
        toast('게시글 작성 성공');
      } else {
        toast('게시글 작성 실패');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용을 입력하세요',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
