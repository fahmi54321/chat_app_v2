import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/widgets/custom_list_view_tiles.dart';
import 'package:chat_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//todo 1 (next chat_messages)

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceWidth * 0.02,
      ),
      height: _deviceHeight * 0.98,
      width: _deviceWidth * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            'Chats',
            primaryAction: IconButton(
              onPressed: () {
                _auth.logout();
              },
              icon: const Icon(Icons.logout),
              color: const Color.fromRGBO(
                0,
                82,
                218,
                1.0,
              ),
            ),
          ),
          _chatList(),
        ],
      ),
    );
  }

  Widget _chatList() {
    return Expanded(
      child: _chatTiles(),
    );
  }

  Widget _chatTiles() {
    return CustomListViewTiles(
      height: _deviceHeight * 0.10,
      title: 'Text',
      subtitle: '',
      imagePath: '',
      isActive: false,
      isActivity: false,
      onTap: () {},
    );
  }
}
