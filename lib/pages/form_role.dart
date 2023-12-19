import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormRolePage extends StatefulWidget {
  final String accessToken;

  FormRolePage({
    required this.accessToken,
  });

  @override
  _FormRolePageState createState() => _FormRolePageState();
}

class _FormRolePageState extends State<FormRolePage> {
  TextEditingController roleController = TextEditingController();

  Future<void> addRole() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/addRole');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'role': roleController.text}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']); // Tampilkan pesan dari backend
        Navigator.pop(context);
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
        title: Text('Tambah Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addRole(); // Panggil fungsi addRole saat tombol ditekan
              },
              child: Text('Tambah Role'),
            ),
          ],
        ),
      ),
    );
  }
}
