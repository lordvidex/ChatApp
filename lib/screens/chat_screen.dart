import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(
          padding: EdgeInsets.all(8),
          child: Text('Some Text'),
        ),
        itemCount: 10,
      ),
    ));
  }
}
