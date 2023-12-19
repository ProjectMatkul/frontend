import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warmindo_app/pages/update_pengguna.dart';

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
  String username = '';
  String password = '';
  String namapengguna = '';
  String idrole = '';
  String status = '';
  String foto = '';

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController idroleController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/viewUser');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        // Tangani jika gagal mendapatkan data role
        print('Gagal mendapatkan data pengguna');
      }
    } catch (error) {
      // Tangani error dari HTTP request
      print('Error: $error');
    }
  }

  Future<void> deleteUser(String userId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/deleteUser');

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

  Future<void> fetchUserDetails(String userId) async {
    final url =
        Uri.parse('http://localhost:3000/api/pemilik/userDetails/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          username = responseData['username'];
          password = responseData['password'];
          namapengguna = responseData['namapengguna'];
          idrole = responseData['idrole'];
          status = responseData['status'];
          foto = responseData['foto'];
          usernameController.text = username;
          passwordController.text = password;
          namaController.text = namapengguna;
          idroleController.text = idrole;
          fotoController.text = foto;
        });
      } else {
        // Tangani jika gagal mendapatkan detail role
        print('Gagal mendapatkan detail pengguna');
      }
    } catch (error) {
      // Tangani error dari HTTP request
      print('Error: $error');
    }
  }

  void navigateToUpdateUserPage(String userId) async {
    await fetchUserDetails(userId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateUserPage(
          accessToken: widget.accessToken,
          userId: userId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Panggil fungsi untuk mendapatkan data pengguna saat inisialisasi halaman
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = widget.accessToken;

// Menggunakan nilai dari accessToken sebagai indeks (misalnya, dengan mengonversi ke int)
    int index = int.tryParse(accessToken) ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
        centerTitle: true,
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
