import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dog_gallery/manager/user_manager.dart';
import 'package:flutter_dog_gallery/theme/theme.dart';

import '../widget/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Login",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              _buildTextField(
                  icon: Icons.email,
                  placeholder: "email",
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  }),
              const SizedBox(height: 20),
              _buildTextField(
                  icon: Icons.lock,
                  placeholder: "password",
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  }),
              const SizedBox(height: 20),
              _buildLoginButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required IconData icon,
      required String placeholder,
      required Function(String) onChanged}) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: placeholder,
              filled: true,
              fillColor: loginInputFilledColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
          onChanged: onChanged,
        ));
  }

  Widget _buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: loginButtonBgColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: _email != null && _password != null
                ? () {
                    _login();
                  }
                : null,
            child: const Text("Login")),
      ),
    );
  }

  void _login() async {
    _showLoading();
    await Future.delayed(const Duration(seconds: 3));
    await UserManager().setUserId("taylor");
    //相当于android中的onActivityResult的回调
    if(mounted){  //先要判断当前页面还在挂载状态，否则会出问题
      Navigator.pop(context);
      Navigator.pop(context, true);
    }
  }

  void _showLoading() {
    showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog();
        });
  }
}
