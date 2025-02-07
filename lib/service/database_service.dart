import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unj_digital_assignment/models/userDataList.dart';

import '../models/home_page_data.dart';

class DatabaseService{
  DatabaseService();

  Future<void> saveUsersToLocal(List<UserDataList> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userListJson = users.map((user) => user.toJson()).toList();
      await prefs.setString('users', jsonEncode(userListJson));
    } catch (e) {
      print("Error saving users to local storage: $e");
    }
  }

  Future<HomePageData> loadUsersFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUsers = prefs.getString('users');

      if (storedUsers != null) {
        final List<dynamic> userList = json.decode(storedUsers);
        final users = userList.map((json) => UserDataList.fromJson(json)).toList();
        return HomePageData(users: users, isLoading: false);
      }
    } catch (e) {
      print("Error loading users from local storage: $e");
    }

    // Return an empty HomePageData if loading fails
    return HomePageData(users: [], isLoading: false);
  }

}
