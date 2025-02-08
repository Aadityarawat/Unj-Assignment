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
      appBar: AppBar(
        title: const Text("User Details"),
        centerTitle: true,
      ),
      body: userData.when(
        data: (user) => UserDetailsCard(user: user, ref: ref, userId: userId),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  final UserDataList userId;
  final User user;
  final WidgetRef ref;
  const UserDetailsCard({super.key, required this.user, required this.ref, required this.userId});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.perm_identity_rounded, "Name", user.name),
                    _buildInfoRow(Icons.mail, "Email", user.email),
                    _buildInfoRow(Icons.phone, "Phone", user.phone),
                    _buildInfoRow(Icons.add_chart_outlined, "Address", user.address),
                    if (user.company != null) _buildInfoRow(Icons.factory, "Company", user.company!),
                    if (user.website != null) _buildInfoRow(Icons.wallet_giftcard, "Website", user.website!),
                    if (user.latitude != null && user.longitude != null)
                      _buildInfoRow(Icons.location_pin, "Location", "${user.latitude}, ${user.longitude}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(user: user),
                    ),
                  );
                  if (updatedUser != null) {
                    ref.invalidate(userProvider(userId.id));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Edit User", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
