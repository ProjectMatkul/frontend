import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'pengguna_page.dart';
import 'role_page.dart';

class ManajemenPage extends StatelessWidget {
  final String accessToken; // Akses token disimpan di sini

  ManajemenPage(
      {required this.accessToken}); // Konstruktor untuk menginisialisasi akses token

  Future<void> logoutUser(BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/api/auth/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Jika berhasil logout, navigasi kembali ke halaman login
        Navigator.pop(context); // Kembali ke halaman sebelumnya (Login)
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
      appBar: AppBar(
        title: Text('Manajemen Data'),
        actions: [
          IconButton(
            onPressed: () {
              logoutUser(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat Datang di Dashboard!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ketika tombol ditekan, navigasi ke halaman FormPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(
                      accessToken: accessToken,
                    ), // Ganti dengan halaman FormPage yang ada
                  ),
                );
              },
              child: Text('Buka FormPage'), // Text pada tombol
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Ketika tombol ditekan, navigasi ke halaman FormPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleListPage(
                      accessToken: accessToken,
                    ), // Ganti dengan halaman FormPage yang ada
                  ),
                );
              },
              child: Text('Lihat Role'), // Text pada tombol
            ),
          ],
        ),
      ),
    );
  }
}
