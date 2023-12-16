import 'package:flutter/material.dart';
import 'package:warmindo_app/pengguna.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController penggunaController = TextEditingController();
  List<Pengguna> pengguna = List.empty(growable: true);

  int selectedIndex = -1;
  List<String> roles = ['Admin', 'User', 'Guest'];
  String selectedRole = ''; // Menyimpan nilai peran yang dipilih
  List<String> statuses = ['Aktif', 'Tidak Aktif'];
  String selectedStatus = 'Aktif'; // Menyimpan nilai status yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manajemen Akun Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: penggunaController,
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: penggunaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: penggunaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Nama Pengguna',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildGreyText("Role"),
            _buildDropdown(roles, selectedRole),
            const SizedBox(height: 10),
            _buildGreyText("Status"),
            _buildDropdown(statuses, selectedStatus),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String username = penggunaController.text.trim();
                    String password = penggunaController.text.trim();
                    String namapengguna = penggunaController.text.trim();
                    int? idrole = roles.indexOf(selectedRole);
                    String status = selectedStatus;
                    String foto = penggunaController.text.trim();
                    if (username.isNotEmpty &&
                        password.isNotEmpty &&
                        namapengguna.isNotEmpty &&
                        idrole != null &&
                        status.isNotEmpty &&
                        foto.isNotEmpty) {
                      setState(() {
                        penggunaController.text = '';
                        pengguna.add(Pengguna(
                          username: username,
                          password: password,
                          namapengguna: namapengguna,
                          idrole: idrole,
                          status: status,
                          foto: foto,
                        ));
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String username = penggunaController.text.trim();
                    String password = penggunaController.text.trim();
                    String namapengguna = penggunaController.text.trim();
                    int? idrole = roles.indexOf(selectedRole);
                    String status = selectedStatus;
                    String foto = penggunaController.text.trim();
                    if (username.isNotEmpty &&
                        password.isNotEmpty &&
                        namapengguna.isNotEmpty &&
                        idrole != null &&
                        status.isNotEmpty &&
                        foto.isNotEmpty) {
                      setState(() {
                        penggunaController.text = '';
                        pengguna[selectedIndex].username = username;
                        pengguna[selectedIndex].password = password;
                        pengguna[selectedIndex].namapengguna = namapengguna;
                        pengguna[selectedIndex].idrole = idrole;
                        pengguna[selectedIndex].status = status;
                        pengguna[selectedIndex].foto = foto;
                        selectedIndex = -1;
                      });
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            pengguna.isEmpty
                ? const Text(
                    'Tidak ada data pengguna',
                    style: TextStyle(fontSize: 22),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: pengguna.length,
                      itemBuilder: (context, index) => getRow(index),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: const Text('Select'),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            pengguna[index].username[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengguna[index].username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(pengguna[index].password),
            Text(pengguna[index].namapengguna),
            Text(roles[pengguna[index].idrole!]), // Tampilkan peran
            Text(pengguna[index].status),
            Text(pengguna[index].foto),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  penggunaController.text = pengguna[index].username;
                  penggunaController.text = pengguna[index].password;
                  penggunaController.text = pengguna[index].namapengguna;
                  setState(() {
                    selectedRole = roles[pengguna[index].idrole!];
                  });
                  setState(() {
                    selectedStatus = pengguna[index].status;
                  });
                  penggunaController.text = pengguna[index].foto;
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: const Icon(Icons.edit),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    pengguna.removeAt(index);
                  });
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
