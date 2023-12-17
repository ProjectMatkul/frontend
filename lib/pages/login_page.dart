import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<void> loginUser(
    String email, String password, BuildContext context) async {
  final url = Uri.parse('http://localhost:3000/api/auth/login');

  try {
    final response = await http.post(
      url,
      body: json.encode({'username': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];
      // Lakukan sesuatu dengan token, seperti menyimpannya ke SharedPreferences
      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(
            builder: (context) => DashboardPage(
                  accessToken: accessToken,
                )),
      );
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
    }
  } catch (error) {
    print('Error: $error');
  }
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/warmindo.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/lg.png",
            width: 350,
            height: 250,
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Expanded(
      child: SizedBox(
        width: mediaSize.width,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Container _buildSectionWithMargin(Widget child, double marginTop) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: child,
    );
  }

  Container _buildSectionWithMarginBottom(Widget child, double marginTop) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: child,
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat Datang Di Aplikasi Warmindo",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildSectionWithMargin(_buildGreyText("Silahkan Login"), 0),
        const SizedBox(height: 30),
        _buildGreyText("Username"),
        _buildInputField(usernameController),
        const SizedBox(height: 30),
        _buildGreyText("Password"),
        _buildSectionWithMarginBottom(
            _buildInputField(passwordController, isPassword: true), 0),
        const SizedBox(height: 20),
        _buildLoginButton(context),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        loginUser(usernameController.text, passwordController.text, context);
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOGIN"),
    );
  }
}
