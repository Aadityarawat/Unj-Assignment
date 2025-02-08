import 'package:unj_digital_assignment/models/userDataList.dart';

class HomePageData {
  final List<UserDataList> users;
  final bool isLoading;

  HomePageData({required this.users, required this.isLoading});

  HomePageData.initial() : users = [], isLoading = false;

  HomePageData copyWith({List<UserDataList>? users, bool? isLoading}) {
    return HomePageData(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
