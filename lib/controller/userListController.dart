import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:unj_digital_assignment/models/userDataList.dart';

class UserListController extends StateNotifier<List<UserDataList>> {
  UserListController() : super([]) {
    loadUsersFromLocal();
  }

  final Dio _dio = Dio();
  int _page = 1;
  bool _hasMore = true;

  Future<void> fetchUsers() async {
    if (!_hasMore) return;

    try {
      final response = await _dio.get(
        'https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io/users?page=$_page',
      );

      final data = response.data['users'] as List;
      final users = data.map((json) => UserDataList.fromJson(json)).toList();

      if (users.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        state = [...users, ...state];
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> loadUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsers = prefs.getString('users');

    if (storedUsers != null) {
      final List<dynamic> userList = json.decode(storedUsers);
      state = userList.map((json) => UserDataList.fromJson(json)).toList();
    }
  }

  void addUser(UserDataList user) {
    state = [user, ...state];
    _saveUsersToLocal();
  }

  Future<void> _saveUsersToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userListJson = state.map((user) => user.toJson()).toList();
    await prefs.setString('users', jsonEncode(userListJson));
  }
}
