import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:warmindo_app/upload.dart';

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
  String? imgUrl;

  List<Map<String, dynamic>> roles = []; // List untuk menyimpan daftar peran

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _getRoles();
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
          'foto': imgUrl,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        Navigator.pop(context,
            true); // Kembali ke halaman sebelumnya setelah berhasil menambahkan pengguna
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
        centerTitle: true,
        title: Text('Tambah Pengguna'),
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
              controller: namapenggunaController,
              decoration: InputDecoration(labelText: 'Nama Pengguna'),
            ),
            SizedBox(height: 16.0),
            FormBuilderDropdown(
              key: Key('RoleDropdown'), // Tambahkan key di sini
              name: 'idrole',
              decoration: InputDecoration(label: Text("Role Pengguna")),
              items: roles
                  .map((e) => DropdownMenuItem(
                      value: e['idrole'], child: Text(e['role'])))
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  roleController.text = value.toString();
                });
              },
            ),
            SizedBox(height: 24.0),
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
