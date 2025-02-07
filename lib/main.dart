import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:unj_digital_assignment/screen/home_screen.dart';
import 'package:unj_digital_assignment/service/database_service.dart';
import 'package:unj_digital_assignment/service/http_service.dart';

void main() async{
  await _setupService();
  runApp(const MyApp());
}

Future<void> _setupService() async{
  GetIt.instance.registerSingleton(HttpService());
  GetIt.instance.registerSingleton(DatabaseService());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Unj Digital',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

