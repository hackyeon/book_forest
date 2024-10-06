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
  late Map<String, dynamic> post; // 게시글 데이터를 저장할 변수
  List<dynamic> comments = [];
  bool isLoading = true; // 로딩 상태 관리
  bool isOwner = false; // 사용자가 게시글 작성자인지 확인
  final TextEditingController _commentController =
      TextEditingController(); // 댓글 입력 컨트롤러

  @override
  void initState() {
    super.initState();
    fetchPostDetail(); // 화면 로드 시 게시글 상세 정보를 불러옴
  }

  Future<void> fetchPostDetail() async {
    var json = {'postIdx': widget.postIdx};
    var response = await api.request(url.POST_GET, json);

    if (response['result'] == 0) {
      var _post = response['json']['post'];
      if (_post == null) {
        toast("게시글을 찾을 수 없습니다.");
        Navigator.pop(context);
      } else {
        var localEmail = await pref.getString(pref.KEY_LOGIN_EMAIL);
        var postEmail = _post['email'];
        setState(() {
          post = _post; // API 응답 데이터 저장
          comments = response['json']['comments']; // 댓글 리스트 불러오기
          isOwner = localEmail == postEmail;
          isLoading = false; // 로딩 완료
        });
      }
    } else {
      // 오류 처리 (필요에 따라 에러 메시지 표시 가능)
      toast("게시글을 찾을 수 없습니다.");
      Navigator.pop(context);
    }
  }

  Future<void> submitComment() async {
    String commentText = _commentController.text;
    if (commentText.isEmpty) {
      toast("댓글을 입력하세요.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    var email = await pref.getString(pref.KEY_LOGIN_EMAIL);
    var json = {'comment':commentText, 'contentIdx': post['idx'], 'email': email};
    var response = await api.request(url.COMMENT_SET, json);

    if(response['result'] == 0) {
      toast("댓글 등록 성공");
    } else {
      toast("댓글 등록 실패");
    }

    fetchPostDetail();
    setState(() {
      _commentController.clear(); // 댓글 입력 필드 비우기
    });
  }

  Future<void> deletePost() async {
    var json = {'idx': widget.postIdx};
    var response = await api.request(url.POST_DELETE, json);

    if(response['result'] == 0) {
      toast(response['json']['message']);
      Navigator.pop(context);
    } else {
      toast(response['message']);
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
              deletePost();
            },
          ),
        ]
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(  // 스크롤뷰로 전체 감싸기
        child: Padding(
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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: '댓글을 입력하세요',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: submitComment,
                    child: Text('등록'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,  // ListView가 스크롤뷰 내에서 올바르게 작동하도록
                physics: NeverScrollableScrollPhysics(),  // ListView의 스크롤을 비활성화
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),  // 댓글 간 간격 추가
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // comment와 date를 양 끝에 배치
                      children: [
                        Expanded(
                          child: Text(
                            comments[index]['comment'],  // 댓글 내용 표시
                          ),
                        ),
                        SizedBox(width: 16),  // 간격 추가
                        Text(
                          comments[index]['date'] ?? '',  // 댓글 작성 날짜 표시
                          style: TextStyle(fontSize: 12, color: Colors.grey),  // 작은 폰트로 날짜 표시
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
