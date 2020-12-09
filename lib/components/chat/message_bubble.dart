import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  MessageBubble(this.message, this.username, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 120,
            maxWidth: 200,
          ),
          child: Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(!isMe)
                  Text(username,
                      //textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold)),
                  Text(message),
                ],
              ),
              decoration: BoxDecoration(
                  color: isMe
                      ? Colors.green[200]
                      : Theme.of(context).accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: !isMe ? Radius.zero : Radius.circular(12),
                      bottomRight: isMe ? Radius.zero : Radius.circular(12)))),
        ),
      ],
    );
  }
}
