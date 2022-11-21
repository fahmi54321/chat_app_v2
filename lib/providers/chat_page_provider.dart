// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/services/cloud_storage_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/services/media_services.dart';
import 'package:chat_app/services/navigation_services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  //todo 5
  late DatabaseServices _db;
  late CloudStorageServices _storage;
  late MediaService _media;
  late NavigatorServices _navigation;

  AuthenticationProvider auth;
  ScrollController messageListViewController;

  String chatId;
  List<ChatMessage> messages = [];
  String _message = '';
  String get message => _message;
  set message(String value) => _message = value;
  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  ChatPageProvider({
    required this.auth,
    required this.messageListViewController,
    required this.chatId,
  }) {
    //todo 6
    _db = GetIt.instance.get<DatabaseServices>();
    _storage = GetIt.instance.get<CloudStorageServices>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigatorServices>();
    _keyboardVisibilityController = KeyboardVisibilityController();

    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void goBack() {
    _navigation.goBack();
  }

  //todo 7
  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessageForChat(chatId).listen(
        (snapshot) {
          List<ChatMessage> msgs = snapshot.docs.map(
            (msg) {
              Map<String, dynamic> messageData =
                  msg.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(messageData);
            },
          ).toList();

          messages = msgs;
          notifyListeners();

          // auto scroll to last message
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (messageListViewController.hasClients) {
              messageListViewController.jumpTo(
                messageListViewController.position.maxScrollExtent,
              );
            }
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((event) {
      _db.updateChatData(
        chatId,
        {
          'is_activity': event,
        },
      );
    });
  }

  //todo 8
  void deleteChat() {
    goBack();
    _db.deleteChat(chatId);
  }

  //todo 9
  void sendTextMessage() {
    if (message.isNotEmpty) {
      ChatMessage messageToSend = ChatMessage(
        senderID: auth.chatUser?.uid ?? '',
        type: MessageType.TEXT,
        content: message,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(chatId, messageToSend);
    }
  }

  //todo 10 (next chat_page.dart)
  void sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? downloadUrl = await _storage.saveChatImageToStorage(
          chatId,
          auth.chatUser?.uid ?? '',
          file,
        );
        ChatMessage messageToSend = ChatMessage(
          senderID: auth.chatUser?.uid ?? '',
          type: MessageType.IMAGE,
          content: downloadUrl ?? '',
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(chatId, messageToSend);
      }
    } catch (e) {
      print(e);
    }
  }
}
