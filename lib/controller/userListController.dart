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
  int _page = 2;
  bool _hasMore = true;
  bool _isLoading = false;

  Future<void> fetchUsers() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    try {
      final response = await _dio.get(
        'https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io/users',
        queryParameters: {'page': _page},
      );

      if (response.statusCode == 200) {
        final data = response.data['users'] as List?;
        if (data == null) {
          print("Error: API response does not contain 'users' key.");
          return;
        }

        final users = data.map((json) => UserDataList.fromJson(json)).toList();

        if (users.isEmpty) {
          _hasMore = false;
        } else {
          _page++;
          state = [...state, ...users];
          _saveUsersToLocal();
        }
      } else {
        print("Error: Received status code ${response.statusCode}");
      }
    } on DioException catch (dioError) {
      print("DioError: ${dioError.message}");
      if (dioError.response != null) {
        print("Response data: ${dioError.response?.data}");
      }
    } catch (e) {
      print("Unexpected error: $e");
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadUsersFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUsers = prefs.getString('users');

      if (storedUsers != null) {
        final List<dynamic> userList = json.decode(storedUsers);
        state = userList.map((json) => UserDataList.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error loading users from local storage: $e");
    }
  }

  void addUser(UserDataList user) {
    state = [user, ...state];
    _saveUsersToLocal();
  }

  Future<void> _saveUsersToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userListJson = state.map((user) => user.toJson()).toList();
      await prefs.setString('users', jsonEncode(userListJson));
    } catch (e) {
      print("Error saving users to local storage: $e");
    }
  }
}
