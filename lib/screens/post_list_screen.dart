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
  List<dynamic> posts = [];  // 게시글 데이터를 저장할 리스트
  bool isLoading = true;     // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    fetchPosts();  // 화면 로드 시 게시글을 불러옴
  }

  Future<void> fetchPosts() async {
    var json = {};
    var response = await api.request(url.POST_LIST, json);

    if(response['result'] != 0) {
      setState(() {
        isLoading = false;  // 로딩 완료
      });
      return;
    }
    setState(() {
      posts = response['json']['data'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 리스트'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // 로딩 중일 때 표시할 위젯
          : ListView.builder(
        itemCount: posts.length,  // API에서 받은 게시글 개수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]['title']),  // 게시글 제목 표시
            subtitle: Text(posts[index]['content']),  // 게시글 내용 표시
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(
                    post: posts[index],
                  ),
                ),
              );
            },
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
