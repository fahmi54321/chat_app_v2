import 'package:chat_app/services/media_services.dart';
import 'package:chat_app/widgets/custom_input_fields.dart';
import 'package:chat_app/widgets/rounded_button.dart';
import 'package:chat_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


//todo 1 (finish)

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  PlatformFile? profileImage;
  final _registerFormKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceWidth * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(height: _deviceHeight * 0.05),
            _registerForm(),
            SizedBox(height: _deviceHeight * 0.05),
            _registerButton(),
            SizedBox(height: _deviceHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((value) {
          setState(() {
            profileImage = value;
          });
        });
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
            image: profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            imagePath: 'https://i.pravatar.cc/1000?img=65',
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
              regEx: 'r.{8,}',
              hintText: 'Name',
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
              hintText: 'Email',
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              regEx: 'r.{8,}',
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: 'Register',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {},
    );
  }
}
