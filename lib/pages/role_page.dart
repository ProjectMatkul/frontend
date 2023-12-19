import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warmindo_app/pages/dashboard_page.dart';

import 'form_role.dart';
import 'update_role.dart';

class RoleListPage extends StatefulWidget {
  final String accessToken;

  RoleListPage({required this.accessToken});

  @override
  State<RoleListPage> createState() => _RoleListPageState();
}

class _RoleListPageState extends State<RoleListPage> {
  List<dynamic> roles = []; // Simpan data role di sini
  String role = ''; // Deklarasikan variabel role
  String status = ''; // Deklarasikan variabel status
  TextEditingController roleController =
      TextEditingController(); // Deklarasikan roleController

  Future<void> fetchRoles() async {
    final url = Uri.parse('http://localhost:3000/api/pemilik/viewRole');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          roles = json.decode(response.body);
        });
      } else {
        // Tangani jika gagal mendapatkan data role
        print('Gagal mendapatkan data role');
      }
    } catch (error) {
      // Tangani error dari HTTP request
      print('Error: $error');
    }
  }

  Future<void> deleteRole(int roleId) async {
    final url = Uri.parse('http://localhost:3000/api/pemilik/deleteRole');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'idrole': roleId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']); // Show backend response message
        // Update the UI after deleting the role if needed
        fetchRoles(); // Refresh roles after deletion
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchRoleDetails(int roleId) async {
    final url =
        Uri.parse('http://localhost:3000/api/pemilik/roleDetails/$roleId');

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

  void navigateToUpdateRolePage(int roleId) async {
    // Panggil fetchRoleDetails sebelum navigasi ke halaman UpdateRolePage
    await fetchRoleDetails(roleId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateRolePage(
          accessToken: widget.accessToken,
          roleId: roleId.toString(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchRoles(); // Panggil fungsi untuk mendapatkan data role saat inisialisasi halaman
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Role'),
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
      body: roles.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(roles[index]['role']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call deleteRole function when delete button is pressed
                          deleteRole(roles[index]['idrole']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Call navigateToUpdateRolePage function when edit button is pressed
                          navigateToUpdateRolePage(roles[index]['idrole']);
                        },
                      ),
                    ],
                  ),
                  // Tambahkan informasi role lainnya sesuai kebutuhan
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormRolePage(
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
