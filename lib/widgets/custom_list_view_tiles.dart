import 'package:chat_app/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListViewTiles extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => onTap,
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
        size: height / 2,
        imagePath: imagePath,
        isActive: isActive,
      ),
      subtitle: isActivity == true ? Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpinKitThreeBounce(
            color: Colors.black54,
            size: height * 0.10,
          )
        ],
      ) : Text(
        subtitle,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

}
