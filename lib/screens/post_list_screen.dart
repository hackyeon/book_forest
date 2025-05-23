import 'package:book_forest/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'post_create_screen.dart';
import 'post_detail_screen.dart';
import 'package:book_forest/api/api.dart' as api;
import 'package:book_forest/api/url.dart' as url;

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<dynamic> posts = []; // 게시글 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    fetchPosts(); // 화면 로드 시 게시글을 불러옴
  }

  Future<void> fetchPosts() async {
    var json = {};
    var response = await api.request(url.POST_LIST, json);

    if (response['result'] != 0) {
      setState(() {
        isLoading = false; // 로딩 완료
      });
      return;
    }
    setState(() {
      posts = response['json']['data'];
      posts.sort((a, b) {
        if(a['idx'] < b['idx']) {
          return 1;
        } else {
          return -1;
        }
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/bookswage_logo.png',
            width: 100,
            height: 38,
          ),
        ),
        // 오른쪽에 버튼 추가
        actions: [
          IconButton(
            icon: Icon(Icons.settings), // 설정 아이콘
            onPressed: () {
              // SettingScreen으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              ).then((_) {
                fetchPosts();
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시할 위젯
          : ListView.builder(
              itemCount: posts.length, // API에서 받은 게시글 개수
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Text(posts[index]['idx'].toString()), // 왼쪽에 idx 표시
                      trailing: Text(posts[index]['date']), // 오른쪽에 date 표시
                      title: Text(
                        posts[index]['title'],
                        maxLines: 1, // 타이틀을 한 줄로 제한
                        overflow: TextOverflow.ellipsis, // 내용이 길면 ...으로 표시
                      ),
                      subtitle: Text(
                        posts[index]['content'],
                        maxLines: 1, // 내용을 한 줄로 제한
                        overflow: TextOverflow.ellipsis, // 내용이 길면 ...으로 표시
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              postIdx: posts[index]['idx'],
                            ),
                          ),
                        ).then((_) {
                          fetchPosts();
                        });
                      },
                    ),
                    Divider(), // 각 ListTile 아래에 밑줄 추가
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreateScreen()),
          ).then((_) {
            fetchPosts();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
