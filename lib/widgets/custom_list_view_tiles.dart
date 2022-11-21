// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/widgets/message_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/rounded_image.dart';

class CustomListViewTiles extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function()? onTap;

  CustomListViewTiles({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
        size: height / 2,
        imagePath: imagePath,
        isActive: isActive,
      ),
      subtitle: isActivity == true
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpinKitThreeBounce(
                  color: Colors.black54,
                  size: height * 0.10,
                )
              ],
            )
          : Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;
  const CustomChatListViewTile({
    Key? key,
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  imagePath: sender.imageURL,
                  size: width * 0.04,
                )
              : Container(),
          SizedBox(width: width * 0.05),
          message.type == MessageType.TEXT
              ? TextMessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  width: width,
                  height: deviceHeight * 0.06,
                )
              : ImageMessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  width: width * 0.55,
                  height: deviceHeight * 0.30,
                ),
        ],
      ),
    );
  }
}
