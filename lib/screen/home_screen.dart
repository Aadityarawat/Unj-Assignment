import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unj_digital_assignment/controller/userListController.dart';
import 'package:unj_digital_assignment/models/userDataList.dart';
import 'package:unj_digital_assignment/screen/add_user_screen.dart';
import 'package:unj_digital_assignment/screen/user_detail_screen.dart';

final userListProvider = StateNotifierProvider<UserListController, List<UserDataList>>((ref) {
  return UserListController();
});


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {

  final TextEditingController searchController = TextEditingController();
  List<UserDataList> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userListProvider.notifier).fetchUsers());
    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    final allUsers = ref.read(userListProvider);
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredUsers = allUsers
          .where((user) =>
      user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Users",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchController.text.isEmpty ? users.length : filteredUsers.length,
              itemBuilder: (context, index) {
                final user = searchController.text.isEmpty ? users[index] : filteredUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailsScreen()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
