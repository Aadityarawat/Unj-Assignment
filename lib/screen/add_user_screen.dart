import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unj_digital_assignment/models/userDataList.dart';
import 'home_screen.dart';

class AddUserScreen extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  AddUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newUser = UserDataList(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                );

                ref.read(userListProvider.notifier).addUser(newUser);

                Navigator.pop(context);
              },
              child: Text("Save User"),
            ),
          ],
        ),
      ),
    );
  }
}
