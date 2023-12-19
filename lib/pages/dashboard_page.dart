import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:warmindo_app/pages/pengguna_page.dart';
import 'package:warmindo_app/pages/role_page.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final String accessToken; // Akses token disimpan di sin

  DashboardPage({
    required this.accessToken,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> logout() async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/api/auth/logout');

      final response = await http.post(
        url,
        headers: {
          // 'cookie': 'warmindo-session=${widget.accessToken}; Path=/; HttpOnly;',
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Jika logout berhasil, kembali ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Halo!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                  subtitle: Text('Selamat Datang di Warmindo App!',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white54)),
                  // trailing: const CircleAvatar(
                  //   radius: 30,
                  //   backgroundImage: AssetImage('assets/images/user.png'),
                  // ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement your logic for 'Videos' button here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange, // Background color
                        onPrimary: Colors.white, // Text color
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.shopping_cart),
                          const SizedBox(height: 10),
                          Text('Warung'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your logic for 'Analytics' button here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Background color
                        onPrimary: Colors.white, // Text color
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.chart_bar),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Data Transaksi',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your logic for 'Manajemen Akun' button here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListPage(
                              accessToken: widget.accessToken,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 115, 248),
                        onPrimary: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.person),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Manajemen Akun',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your logic for 'Manajemen Akun' button here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoleListPage(
                              accessToken: widget.accessToken,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 164, 115, 255),
                        onPrimary: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.graph_circle),
                          const SizedBox(height: 10),
                          Text('Manajemen Role'),
                        ],
                      ),
                    ),
                    Container(),
                    ElevatedButton(
                      onPressed: () async {
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 0, 0),
                        onPrimary: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app),
                          const SizedBox(height: 10),
                          Text('Logout'),
                        ],
                      ),
                    ),
                    // SizedBox(height: 16), // Add spacing
                    // Container(
                    //   alignment: Alignment.bottomCenter,
                    //   margin: EdgeInsets.only(
                    //       bottom: 0), // Adjust the margin as needed
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       logout();
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       fixedSize: Size.fromHeight(40),
                    //       primary: Colors.red,
                    //       onPrimary: Colors.white,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.exit_to_app),
                    //         const SizedBox(width: 10),
                    //         Text('Logout'),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(title.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      );
}
