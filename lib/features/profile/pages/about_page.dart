import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('吃啥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('版本 1.0.0'),
            SizedBox(height: 24),
            Text('一个用于决定吃什么的小工具。'),
            SizedBox(height: 8),
            Text('数据全部保存在本地，不上传。'),
          ],
        ),
      ),
    );
  }
}
