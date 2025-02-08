import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unj_digital_assignment/controller/home_page_controller.dart';
import 'package:unj_digital_assignment/models/home_page_data.dart';
import 'package:unj_digital_assignment/models/userDataList.dart';
import 'package:unj_digital_assignment/screen/add_user_screen.dart';
import 'package:unj_digital_assignment/screen/user_detail_screen.dart';

final homePageControllerProvider =
StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _allUserListScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  List<UserDataList> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _allUserListScrollController.addListener(_scrollListener);
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _allUserListScrollController.removeListener(_scrollListener);
    _allUserListScrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allUserListScrollController.offset >=
        _allUserListScrollController.position.maxScrollExtent * 1 &&
        !_allUserListScrollController.position.outOfRange) {
      ref.read(homePageControllerProvider.notifier).load();
    }
  }

  void _filterUsers() {
    final homePageData = ref.read(homePageControllerProvider);
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredUsers = homePageData.users
          .where((user) =>
      user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homePageData = ref.watch(homePageControllerProvider);
    final homePageController = ref.read(homePageControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            // Search Bar with elevation and padding
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search Users",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Skeletonizer(
                enabled: homePageData.isLoading,
                child: ListView.builder(
                  controller: _allUserListScrollController,
                  itemCount: searchController.text.isEmpty
                      ? homePageData.users.length
                      : filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = searchController.text.isEmpty
                        ? homePageData.users[index]
                        : filteredUsers[index];

                    return Card(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsScreen(userId: user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            if (homePageData.isLoading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          ).then((newUser) {
            if (newUser != null && newUser is UserDataList) {
              homePageController.addUser(newUser);
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text("Add User"),
      ),
    );
  }
}
