import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:warmindo_app/upload.dart';

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
  String? imgUrl;
  String? previousRoleValue;

  List<Map<String, dynamic>> roles = []; // List untuk menyimpan daftar peran

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _getRoles();
    fetchUserDetails();
  }

  Future<void> _getRoles() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/viewRole');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      });

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          roles = responseData.cast<Map<String, dynamic>>();
        });
        print(responseData.toString());
      } else {
        print('Failed to fetch roles');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchUserDetails() async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/api/pemilik/userDetails/${widget.userId}');

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

  Future<void> editUser() async {
    final url =
        Uri.parse('http://10.0.2.2:3000/api/pemilik/editUser/${widget.userId}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idpengguna': widget.userId,
          'username': usernameController.text,
          'password': passwordController.text,
          'namapengguna': namaController.text,
          'idrole': idroleController.text,
          'status': status,
          'foto': imgUrl,
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
            FormBuilderDropdown(
              key: Key('RoleDropdown'),
              name: 'idrole',
              decoration: InputDecoration(label: Text("Role Pengguna")),
              items: roles
                  .map((e) => DropdownMenuItem(
                      value: e['idrole'], child: Text(e['role'])))
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  idroleController.text = value.toString();
                  previousRoleValue =
                      value; // Set nilai sebelumnya saat dropdown diubah
                });
              },
              // Set nilai awal dropdown ke nilai sebelumnya jika sudah ada
              initialValue: previousRoleValue ?? idrole,
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
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? imagePicked = await picker.pickImage(
                  source: ImageSource.gallery,
                  // imageQuality: 50,
                );
                File imageFile = File(imagePicked!.path);
                try {
                  final res = await uploadFile(
                      file: imageFile,
                      filename: imageFile.path.split('/').last);
                  setState(() {
                    imgUrl = res['body']['url'];
                  });
                } catch (error) {
                  print('Error: $error');
                }
                // Panggil fungsi tambahPengguna saat tombol ditekan
              },
              child: Text('Tambah Foto'),
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
