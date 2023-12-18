import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  final String accessToken;

  FormPage({required this.accessToken});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namapenggunaController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  Future<void> tambahPengguna() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/addPengguna');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
          'namapengguna': namapenggunaController.text,
          'status': statusController.text,
          'idrole': int.parse(roleController.text),
          'foto': fotoController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        Navigator.pop(
            context); // Kembali ke halaman sebelumnya setelah berhasil menambahkan pengguna
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
        title: Text('Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: namapenggunaController,
              decoration: InputDecoration(labelText: 'Nama Pengguna'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Role Pengguna'),
              keyboardType: TextInputType.number, // Hanya menerima input angka
            ),
            TextField(
              controller: fotoController,
              decoration: InputDecoration(labelText: 'Foto Pengguna'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                tambahPengguna(); // Panggil fungsi tambahPengguna saat tombol ditekan
              },
              child: Text('Tambah Pengguna'),
            ),
          ],
        ),
      ),
    );
  }
}
