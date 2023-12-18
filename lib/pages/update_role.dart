import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateRolePage extends StatefulWidget {
  final String accessToken;
  final String roleId;

  UpdateRolePage({required this.accessToken, required this.roleId});

  @override
  _UpdateRolePageState createState() => _UpdateRolePageState();
}

class _UpdateRolePageState extends State<UpdateRolePage> {
  String role = '';
  String status = 'Aktif'; // Default status "Aktif"
  TextEditingController roleController = TextEditingController();

  Future<void> editRole() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pemilik/editRole');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idrole': widget.roleId,
          'role': roleController.text,
          'status': status,
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
  void initState() {
    super.initState();
    fetchRoleDetails(); // Panggil fungsi untuk mendapatkan detail role saat inisialisasi halaman
  }

  Future<void> fetchRoleDetails() async {
    final url = Uri.parse(
        'http://localhost:3000/api/pemilik/roleDetails/${widget.roleId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          role = responseData['role'];
          status = responseData['status'];
          roleController.text = role;
        });
      } else {
        // Tangani jika gagal mendapatkan detail role
        print('Gagal mendapatkan detail role');
      }
    } catch (error) {
      // Tangani error dari HTTP request
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: roleController,
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
                  status = newValue!;
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
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                editRole(); // Panggil fungsi editRole saat tombol ditekan
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
