import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app_practical/API/api_manager.dart';
import 'package:weather_app_practical/weather/Bloc/weather_event.dart';
import 'package:weather_app_practical/weather/Bloc/weather_state.dart';

import 'package:weather_app_practical/weather/Model/weather_model.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final APIManager apiManager = APIManager();

  /// Constructor initializing the initial state to WeatherInitial
  WeatherBloc() : super(WeatherInitial()) {
    /// Event listeners and handling for different weather-related events.

    /// Observing network connectivity changes.
    on<NetworkObserve>(_observe);

    /// Notifying network status changes.
    on<NetworkNotify>(_notifyStatus);
    on<FetchWeatherEvent>((event, emit) async {
      /// Emitting initial state while fetching weather data.
      emit(WeatherInitial());
      try {
        var weatherResponse = await _fetchWeatherData(event.cityName);

        /// Emitting success state with weather data.
        emit(WeatherSuccessState(weather: weatherResponse));
      } catch (e) {
        log("failuer ------------- $e");
      }
    });
  }

  /// Method to observe network connectivity changes.
  void _observe(event, emit) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        /// Notifying when there's no network connectivity.
        WeatherBloc().add(NetworkNotify());
      } else {
        /// Notifying when network is available.
        WeatherBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }

  /// Method to handle notification of network status changes.
  void _notifyStatus(NetworkNotify event, emit) {
    /// Emitting success/failure based on network status
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }

  /// Fetches weather data for a given city using an API call.
  Future<WeatherModel> _fetchWeatherData(String cityName) async {
    const apiKey = '4fef2d6ffa64dd8f3a98f5bc3aa4778a';
    final apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await apiManager.getAPICall(apiUrl);

    return WeatherModel.fromJson(response);
  }

  /// Checks connectivity and logs the type of network connected (mobile or wifi).
  connectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    }
  }
}
