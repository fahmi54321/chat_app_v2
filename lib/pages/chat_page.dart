import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/providers/chat_page_provider.dart';
import 'package:chat_app/widgets/custom_input_fields.dart';
import 'package:chat_app/widgets/custom_list_view_tiles.dart';
import 'package:chat_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late ChatPageProvider pageProvider;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    // todo 11
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            auth: _auth,
            messageListViewController: _messageListViewController,
            chatId: widget.chat.uid,
          ),
        ),
      ],
      child: Builder(
        builder: (ctx) {
          pageProvider = ctx.watch<ChatPageProvider>();
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
                      primaryAction: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          pageProvider.deleteChat(); //todo 12
                        },
                      ),
                      secondaryAction: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          pageProvider.goBack();
                        },
                      ),
                    ),
                    messagesListView(), // todo 13
                    sendMessageForm(), // todo 14 (finish)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget messagesListView() {
    if (pageProvider.messages.isNotEmpty) {
      return SizedBox(
        height: _deviceHeight * 0.74,
        child: ListView.builder(
          controller: _messageListViewController,
          itemCount: pageProvider.messages.length,
          itemBuilder: (context, index) {
            ChatMessage message = pageProvider.messages[index];
            bool isOwnMessage = message.senderID == _auth.chatUser?.uid;
            return CustomChatListViewTile(
              width: _deviceWidth * 0.80,
              deviceHeight: _deviceHeight,
              isOwnMessage: isOwnMessage,
              message: message,
              sender: widget.chat.members
                  .where((member) => member.uid == message.senderID)
                  .first,
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          30,
          29,
          37,
          1.0,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            messageTextField(),
            sendMessageButton(),
            imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (value) {
          pageProvider.message = value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: 'Type a message',
        obscureText: false,
      ),
    );
  }

  Widget sendMessageButton() {
    double size = _deviceHeight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState?.validate() ?? false) {
            _messageFormState.currentState?.save();
            pageProvider.sendTextMessage();
            _messageFormState.currentState?.reset();
          }
        },
        icon: const Icon(
          Icons.send,
        ),
      ),
    );
  }

  Widget imageMessageButton() {
    double size = _deviceHeight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        onPressed: () {
          pageProvider.sendImageMessage();
        },
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        child: const Icon(
          Icons.camera_enhance_sharp,
        ),
      ),
    );
  }
}
