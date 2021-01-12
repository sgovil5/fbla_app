import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
    this.message,
    this.isMe,
  );

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          // A chat bubble is a row with color and spacing based on which user sent the message.
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: !isMe
                    ? Colors.grey[300]
                    : Theme.of(context)
                        .accentColor, // Blue if sent by user, grey if sent by receiving user.
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe
                      ? Radius.circular(0)
                      : Radius.circular(
                          12), // Shape of bubble determined by which side it's on, which depends on who sent the message.
                ),
              ),
              width: 200,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment
                        .start, // Received messages are on the left, sent messages are on the right.
                children: [
                  Text(
                    message, // Shows text of the actual message.
                    style: TextStyle(
                      color: !isMe
                          ? Colors.black
                          : Theme.of(context)
                              .accentTextTheme
                              .headline1
                              .color, // Text color to contrast with the bubble color.
                    ),
                    textAlign: isMe
                        ? TextAlign.end
                        : TextAlign
                            .start, // Text align, left and right justification.
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
