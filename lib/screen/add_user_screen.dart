import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unj_digital_assignment/models/userDataList.dart';
import 'home_screen.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final newUser = UserDataList(
        id: DateTime.now().millisecondsSinceEpoch,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );

      ref.read(homePageControllerProvider.notifier).addUser(newUser);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New User")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(nameController, "Name", "Please enter a valid name"),
                    _buildTextField(emailController, "Email", "Enter a valid email", isEmail: true),
                    _buildTextField(phoneController, "Phone", "Enter a valid phone number (10 digits)", isNumber: true),
                    _buildTextField(addressController, "Address", "Address cannot be empty"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Save User", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String validationMessage, {
        bool isNumber = false,
        bool isEmail = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validationMessage;
          }
          if (isEmail && !_isValidEmail(value)) {
            return "Enter a valid email";
          }
          if (isNumber && !_isValidPhone(value)) {
            return "Phone must be 10 digits";
          }
          return null;
        },
      ),
    );
  }

  bool _isValidEmail(String email) {
    return email.contains("@gmail.com");
  }

  bool _isValidPhone(String phone) {
    return phone.length == 10 && int.tryParse(phone) != null;
  }
}
