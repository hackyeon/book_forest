import 'package:book_forest/screens/post_create_screen.dart';
import 'package:flutter/material.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 리스트'),
      ),
      body: ListView.builder(
        itemCount: 10, // 게시글 개수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('게시글 제목 $index'),
            subtitle: Text('게시글 내용 $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailScreen(postId: index)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 게시글 작성 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreateScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
