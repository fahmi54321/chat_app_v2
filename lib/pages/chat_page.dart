import 'package:chat_app/models/chat.dart';
import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//todo 1 (finish)

class Chatpage extends StatefulWidget {
  Chat chat;

  Chatpage({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  @override
  Widget build(BuildContext context) {

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                widget.chat.title(),
                fontSize: 10,
                primaryAction: IconButton(icon: Icon(Icons.delete),onPressed: (){},),
                secondaryAction: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){},),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
