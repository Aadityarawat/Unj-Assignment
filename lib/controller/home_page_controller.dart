import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:unj_digital_assignment/models/home_page_data.dart';
import 'package:unj_digital_assignment/service/database_service.dart';
import 'package:unj_digital_assignment/service/http_service.dart';

import '../models/userDataList.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpService _httpService;
  late DatabaseService _databaseService;

  HomePageController(super.state) {
    _httpService = _getIt.get<HttpService>();
    _databaseService = _getIt.get<DatabaseService>();
    _setup();
  }

  Future<void> _setup() async {
    loadUsersFromLocal();
    load();
  }

  int _page = 1;
  int _totalPages = 1;
  int _totalUsers = 1;
  bool _hasMore = true;

  Future<void> load() async {
    if (!_hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {

      final res = await _httpService.get(
        "https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io/users?page=$_page",
      );

      if (res?.statusCode == 200) {
        final Map<String, dynamic>? responseData = res?.data;

        if (responseData == null || responseData['users'] == null) {
          _hasMore = false;
          return;
        }

        final List<dynamic>? data = responseData['users'];
        _totalPages = responseData['total_pages'] ?? 1;
        _totalUsers = responseData['total_users'] ?? 1;

        if (data == null || data.isEmpty) {
          _hasMore = false;

        } else {
          if (_totalUsers > state.users.length) {
            final newUsers = data.map((json) => UserDataList.fromJson(json)).toList();

            state = state.copyWith(users: [...state.users, ...newUsers]);
            _databaseService.saveUsersToLocal(state.users);

            if (_page < _totalPages) {
              _page++;
            } else {
              _hasMore = false;
            }
          }
        }
      } else {
        print(" API Error: ${res?.statusCode}");
      }
    } catch (e) {
      print(" Exception during fetch: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadUsersFromLocal() async {
    state = await _databaseService.loadUsersFromLocal();
  }

  void addUser(UserDataList user) {
    state = state.copyWith(users: [user, ...state.users]);
    _databaseService.saveUsersToLocal(state.users);
  }
}