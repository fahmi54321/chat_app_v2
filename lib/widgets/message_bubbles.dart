// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:chat_app/models/chat_messages.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double width;
  final double height;
  const TextMessageBubble({
    Key? key,
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage
        ? [
            const Color.fromRGBO(0, 136, 249, 1.0),
            const Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
          ),
          Text(
            timeago.format(message.sentTime),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double width;
  final double height;
  const ImageMessageBubble({
    Key? key,
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage
        ? [
            const Color.fromRGBO(0, 136, 249, 1.0),
            const Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];

    DecorationImage image = DecorationImage(
      image: NetworkImage(message.content),
      fit: BoxFit.cover,
    );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: image,
            ),
          ),
          const SizedBox(height: 0.02),
          Text(
            timeago.format(message.sentTime),
          ),
        ],
      ),
    );
  }
}
