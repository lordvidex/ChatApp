import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final ValueKey key;
  final String userImage;
  MessageBubble(
      {this.userImage, this.key, this.message, this.username, this.isMe});
  @override
  Widget build(BuildContext context) {
    void _openLargeImage() {
      //add method for viewing image
    }
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          GestureDetector(
            onTap: _openLargeImage,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(userImage),
            ),
          ),
        messageBox(context),
      ],
    );
  }

  ConstrainedBox messageBox(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 120,
        minHeight: 40,
        maxWidth: 200,
      ),
      child: Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Text(username,
                    //textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).primaryColor,
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
    );
  }
}
