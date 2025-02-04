import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unj_digital_assignment/screen/edit_user_screen.dart';
import '../controller/userDetailScreenController.dart';
import '../models/UserDataDetail.dart';

final userProvider = FutureProvider<User>((ref) async {
  final controller = UserDetailScreenController();
  return controller.fetchUserDetails();
});

// View
class UserDetailsScreen extends ConsumerWidget {
  const UserDetailsScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: userData.when(
        data: (user) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${user.name}", style: TextStyle(fontSize: 18)),
                        Text("Email: ${user.email}", style: TextStyle(fontSize: 18)),
                        Text("Phone: ${user.phone}", style: TextStyle(fontSize: 18)),
                        Text("Address: ${user.address}", style: TextStyle(fontSize: 18)),
                        if (user.company != null)
                          Text("Company: ${user.company}", style: TextStyle(fontSize: 18)),
                        if (user.website != null)
                          Text("Website: ${user.website}", style: TextStyle(fontSize: 18)),
                        if (user.latitude != null && user.longitude != null)
                          Text("Location: ${user.latitude}, ${user.longitude}",
                              style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final updatedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(user: user),
                      ),
                    );
                    if (updatedUser != null) {
                      ref.invalidate(userProvider);
                    }
                  },
                  child: Text("Edit"),
                ),
              ],
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
