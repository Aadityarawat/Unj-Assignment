import 'package:unj_digital_assignment/models/userDataList.dart';

class HomePageData{
  UserDataList? data;

  HomePageData({
    required this.data,
  });

  HomePageData.initial() : data = null;

  HomePageData copyWith({UserDataList? data}){
    return HomePageData(
        data: data ?? this.data,
    );
  }
}