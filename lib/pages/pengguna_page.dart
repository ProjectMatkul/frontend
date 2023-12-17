import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dashboard_page.dart';
import 'form_page.dart';

class UserListPage extends StatefulWidget {
  final String accessToken;

  UserListPage({required this.accessToken});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<dynamic> users = []; // Simpan data pengguna di sini

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://localhost:3000/api/pemilik/viewUser');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        // Tangani jika gagal mendapatkan data pengguna
        print('Gagal mendapatkan data pengguna');
      }
    } catch (error) {
      // Tangani error dari HTTP request
      print('Error: $error');
    }
  }

  Future<void> deleteUser(String userId) async {
    final url = Uri.parse('http://localhost:3000/api/pemilik/deleteUser');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'idpengguna': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        // Refresh halaman atau ambil data ulang setelah penghapusan pengguna jika diperlukan
        fetchUsers();
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Panggil fungsi untuk mendapatkan data pengguna saat inisialisasi halaman
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardPage(
                  accessToken: widget.accessToken,
                ),
              ),
            );
          },
        ),
      ),
      body: users.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['username']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Panggil fungsi deleteUser saat tombol delete ditekan dengan ID pengguna tertentu
                      deleteUser(users[index]['idpengguna']);
                    },
                  ),
                  // Tambahkan informasi pengguna lainnya sesuai kebutuhan
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPage(
                accessToken: widget.accessToken,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
