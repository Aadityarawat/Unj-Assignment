import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../models/UserDataDetail.dart';
import '../service/http_service.dart';

class UserDetailScreenController {
  late HttpService _httpService;
  final GetIt _getIt = GetIt.instance;

  UserDetailScreenController(){
    _httpService = _getIt.get<HttpService>();
  }

  Future<User> fetchUserDetails(int id) async {
    final response = await _httpService.get(
      'https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io/users/$id',
    );
    return User.fromJson(response?.data);
  }
}

final userProvider = FutureProvider.family.autoDispose<User, int>((ref, id) {
  final controller = UserDetailScreenController();
  return controller.fetchUserDetails(id);
});
