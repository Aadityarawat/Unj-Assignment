import 'package:unj_digital_assignment/models/userDataList.dart';

class HomePageData {
  final List<UserDataList> users;
  final bool isLoading; // ✅ Added loading state

  HomePageData({required this.users, required this.isLoading});

  // ✅ Initial state: Empty users list and loading set to false
  HomePageData.initial() : users = [], isLoading = false;

  // ✅ Update method to handle loading state
  HomePageData copyWith({List<UserDataList>? users, bool? isLoading}) {
    return HomePageData(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
