import 'dart:async';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseServices _db;
  List<Chat> chats = [];
  late StreamSubscription _chatsStream;

  ChatPageProvider({required this.auth}) {
    _db = GetIt.instance.get<DatabaseServices>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream = _db.getChatsForUser(auth.chatUser?.uid ?? '').listen(
        (snapshot) async {
          chats = await Future.wait(
            snapshot.docs.map(
              (dataSnapshot) async {
                Map<String, dynamic> chatData =
                    dataSnapshot.data() as Map<String, dynamic>;

                // get users in chat
                List<ChatUser> members = [];

                for (var uid in chatData['members']) {
                  DocumentSnapshot userSnapshot = await _db.getUser(uid);

                  Map<String, dynamic> userData =
                      userSnapshot.data() as Map<String, dynamic>;

                  userData['uid'] = userSnapshot.id;

                  members.add(ChatUser.fromJSON(userData));
                }

                // get last messages for chat
                List<ChatMessage> messages = [];
                QuerySnapshot chatMessages = await _db.getLastMessageForChat(
                  dataSnapshot.id,
                );

                if(chatMessages.docs.isNotEmpty){
                  Map<String,dynamic> messageData = chatMessages.docs.first.data() as Map<String,dynamic>;

                  ChatMessage msg = ChatMessage.fromJSON(messageData);
                  messages.add(msg);

                }

                return Chat(
                  uid: dataSnapshot.id,
                  currentUserUid: auth.chatUser?.uid ?? '',
                  messages: messages,
                  members: members,
                  group: chatData['is_group'],
                  activity: chatData['is_activity'],
                );
              },
            ).toList(),
          );

          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
