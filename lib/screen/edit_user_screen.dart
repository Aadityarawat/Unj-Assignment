import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unj_digital_assignment/models/UserDataDetail.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final User user;
  const EditUserScreen({super.key, required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        User(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          address: widget.user.address,
          company: widget.user.company,
          website: widget.user.website,
          latitude: widget.user.latitude,
          longitude: widget.user.longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(nameController, "Name", "Please enter a valid name"),
                      _buildTextField(emailController, "Email", "Enter a valid email", isEmail: true),
                      _buildTextField(phoneController, "Phone", "Enter a valid phone number (10 digits)", isNumber: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
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
