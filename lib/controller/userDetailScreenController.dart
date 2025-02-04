import 'package:dio/dio.dart';

import '../models/UserDataDetail.dart';

class UserDetailScreenController {
  final Dio _dio = Dio();

  Future<User> fetchUserDetails() async {
    final response = await _dio.get('https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io/users/2');
    return User.fromJson(response.data);
  }
}
