import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/userDetailScreenController.dart';
import '../models/UserDataDetail.dart';
import '../models/userDataList.dart';
import 'edit_user_screen.dart';

class UserDetailsScreen extends ConsumerWidget {
  final UserDataList userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider(userId.id));

    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: userData.when(
        data: (user) => UserDetailsCard(user: user, ref: ref, userId: userId,),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

// Extracted UI for better readability
class UserDetailsCard extends StatelessWidget {
  final UserDataList userId;
  final User user;
  final WidgetRef ref;
  const UserDetailsCard({super.key, required this.user, required this.ref, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText("Name", user.name),
                  _buildText("Email", user.email),
                  _buildText("Phone", user.phone),
                  _buildText("Address", user.address),
                  if (user.company != null) _buildText("Company", user.company!),
                  if (user.website != null) _buildText("Website", user.website!),
                  if (user.latitude != null && user.longitude != null)
                    _buildText("Location", "${user.latitude}, ${user.longitude}"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(user: user),
                  ),
                );
                if (updatedUser != null) {
                  ref.invalidate(userProvider(userId.id)); // Refresh only this user
                }
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
