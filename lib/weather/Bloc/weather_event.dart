import 'package:flutter/material.dart';

/// Abstract class defining the base for different weather-related events.
@immutable
abstract class WeatherEvent {}

/// Event class for fetching weather data for a specific city.
class FetchWeatherEvent extends WeatherEvent {
  final String cityName;
  FetchWeatherEvent({required this.cityName});
}

/// Event class for observing network connectivity changes.
class NetworkObserve extends WeatherEvent {}

class NetworkNotify extends WeatherEvent {
  final bool isConnected;

  NetworkNotify({this.isConnected = false});
}
