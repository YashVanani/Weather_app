import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_practical/main.dart';
import 'package:weather_app_practical/utils/app_color.dart';
import 'package:weather_app_practical/utils/app_imges.dart';
import 'package:weather_app_practical/utils/common_string.dart';
import '../Bloc/weather_bloc.dart';
import '../Bloc/weather_event.dart';
import '../Bloc/weather_state.dart';

/// Represents the WeatherPage, displaying weather-related information and functionality.
class WeatherPage extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();
  final WeatherBloc weatherBloc = WeatherBloc();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImage.mainBoxImage), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  CommonString.weather,
                  style: TextStyle(fontSize: 30, color: AppColors.whiteColor),
                ),
              ),
              const SizedBox(height: 30),

              /// UI elements like search input
              Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: cityController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search_sharp, color: AppColors.secondaryColor),
                    hintText: CommonString.enterCityName,
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      weatherBloc.connectivity();
                      weatherBloc.add(
                        FetchWeatherEvent(cityName: cityController.text),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Text(
                        CommonString.getWeather,
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// BlocListener and BlocBuilder managing state changes and UI updates based on WeatherBloc state.
              BlocListener<WeatherBloc, WeatherState>(
                bloc: weatherBloc,

                /// Listens to state changes in the WeatherBloc and triggers corresponding UI updates.
                listener: (BuildContext context, state) {
                  /// Displays a SnackBar for network failure.
                  if (state is NetworkFailure) {
                    SnackBar snackBar = snackBarStyle(CommonString.noInternetConnection, AppColors.secondaryColor);
                    snackBarKey.currentState?.showSnackBar(snackBar);
                  }

                  /// Displays a SnackBar for weather-related failure with error message.
                  if (state is WeatherFailureState) {
                    SnackBar snackBar = snackBarStyle(state.errorMessage.toString(), AppColors.redColor);
                    snackBarKey.currentState?.showSnackBar(snackBar);
                  }
                },

                /// Builds the UI based on the WeatherBloc state using BlocBuilder.
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  bloc: weatherBloc,
                  builder: (context, state) {
                    /// Displays a loading indicator while weather data is being fetched.
                    if (state is WeatherLoadingState) {
                      return const CircularProgressIndicator();
                    }
                    /// Displays weather information upon successful data retrieval.
                    else if (state is WeatherSuccessState) {
                      final weather = state.weather;
                      final temp = weather.main!.temp;
                      final description = weather.weather![0].main;
                      final cityName = weather.name;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .4,
                          decoration: BoxDecoration(
                            image: const DecorationImage(image: AssetImage(AppImage.bgImage), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              Text(
                                '$cityName',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                              ),
                              Text(
                                '$temp${CommonString.celsius}',
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                              ),
                              const Text(
                                CommonString.des,
                              ),
                              Text(
                                '$description',
                                style: const TextStyle(fontSize: 18, color: AppColors.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to create a styled SnackBar.
  snackBarStyle(String text, Color color) {
    return SnackBar(content: Text(text), backgroundColor: color, duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating);
  }
}
