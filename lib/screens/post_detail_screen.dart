import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final dynamic post;
  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 게시글 수정 로직
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // 게시글 삭제 로직
            },
          ),
        ],
      ),
      body: Padding(
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
      ),
    );
  }
}
