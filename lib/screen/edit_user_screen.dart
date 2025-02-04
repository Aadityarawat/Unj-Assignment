import 'package:flutter/material.dart';
import 'package:unj_digital_assignment/models/UserDataDetail.dart';

class EditUserScreen extends StatelessWidget {
  final User user;
  EditUserScreen({super.key, required this.user});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;

    return Scaffold(
      appBar: AppBar(title: Text("Edit User")),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  User(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    address: user.address,
                    company: user.company,
                    website: user.website,
                    latitude: user.latitude,
                    longitude: user.longitude,
                  ),
                );
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
