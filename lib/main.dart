import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_practical/weather/Bloc/weather_bloc.dart';
import 'package:weather_app_practical/weather/Screens/weather_search.dart';

GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackBarKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      /// Creating a WeatherBloc instance.
      home: BlocProvider(
        create: (context) => WeatherBloc(),
        child: WeatherPage(),
      ),
    );
  }
}
