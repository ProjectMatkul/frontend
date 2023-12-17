import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateRolePage extends StatefulWidget {
  final String accessToken;
  final String roleId;

  UpdateRolePage({required this.accessToken, required this.roleId});

  @override
  _UpdateRolePageState createState() => _UpdateRolePageState();
}

class _UpdateRolePageState extends State<UpdateRolePage> {
  TextEditingController roleController = TextEditingController();

  Future<void> updateRole() async {
    final url = Uri.parse('http://localhost:3000/api/pemilik/editRole');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idrole': widget.roleId,
          'role': roleController.text,
          'status': 'Aktif', // Sesuaikan dengan kebutuhan Anda
        }),
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
        title: Text('Update Role'),
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
                updateRole(); // Panggil fungsi updateRole saat tombol ditekan
              },
              child: Text('Update Role'),
            ),
          ],
        ),
      ),
    );
  }
}
