import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateUserPage extends StatefulWidget {
  final String accessToken;
  final String userId;

  UpdateUserPage({required this.accessToken, required this.userId});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  String username = '';
  String password = '';
  String namapengguna = '';
  String idrole = '';
  String status = 'Aktif';
  String foto = '';

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController idroleController = TextEditingController();
  TextEditingController fotoController = TextEditingController();

  Future<void> fetchUserDetails() async {
    final url = Uri.parse(
        'http://localhost:3000/api/pemilik/userDetails/${widget.userId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          username = responseData['username'].toString();
          password = responseData['password'].toString();
          namapengguna = responseData['namapengguna'].toString();
          idrole = responseData['idrole'].toString();
          status = responseData['status'].toString();
          foto = responseData['foto'].toString();
          usernameController.text = username;
          passwordController.text = password;
          namaController.text = namapengguna;
          idroleController.text = idrole;
          fotoController.text = foto;
        });
      } else {
        print('Gagal Mendapatkan detail user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> editUser() async {
    final url = Uri.parse(
        'http://localhost:3000/api/pemilik/editUser/${widget.userId}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
          'namapengguna': namaController.text,
          'idrole': idroleController.text,
          'status': status,
          'foto': fotoController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']); // Show backend response message
        Navigator.pop(context); // Kembali ke halaman sebelumnya
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
        title: Text('Update Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: idroleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: status,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  status =
                      newValue!; // Ubah nilai status langsung saat dropdown diubah
                });
              },
              items: <String>['Aktif', 'Tidak Aktif']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: fotoController,
              decoration: InputDecoration(labelText: 'Foto'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                editUser(); // Panggil fungsi editRole saat tombol ditekan
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
