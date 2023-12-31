import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_practical/weather/Model/weather_model.dart';

/// Abstract class defining different states for weather-related conditions.
@immutable
abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object> get props => [];
}

/// Initial state when no weather data is yet fetched.
class WeatherInitial extends WeatherState {}

/// State indicating that weather data is currently being loaded.
class WeatherLoadingState extends WeatherState {}

/// State indicating successful network connection.
class NetworkSuccess extends WeatherState {}

/// State indicating a network failure.
class NetworkFailure extends WeatherState {}

/// State indicating failure to fetch weather data with an error message.
class WeatherFailureState extends WeatherState {
  final String errorMessage;
  const WeatherFailureState(this.errorMessage);
}

/// State indicating successful retrieval of weather data.
class WeatherSuccessState extends WeatherState {
  final WeatherModel weather;
  const WeatherSuccessState({required this.weather});
}
