import 'package:unj_digital_assignment/models/userDataList.dart';


class HomePageData {
  final List<UserDataList> users;

  HomePageData({required this.users});

  HomePageData.initial() : users = [];

  HomePageData copyWith({List<UserDataList>? users}) {
    return HomePageData(
      users: users ?? this.users,
    );
  }
}
