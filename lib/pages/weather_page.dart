import 'package:apiweather/models/weather_model.dart';
import 'package:apiweather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key:
  final weatherService = WeatherService("2e5484ab45791c3473ed55b6a398ff58");
  Weather? _weather;
  String errorMessage = '';
  //fetch weather
  Future<void> fetchWeather() async {
    //get current city
    String cityName = await weatherService.getCurrentCity();

    //get weather for city
    try {
      final Weather weather = await weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    fetchWeather();
    super.initState();
  }

  String getWeatherLottie(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/lotties/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/lotties/raining.json';
      case 'clear':
        return 'assets/lotties/sunny';
      default:
        return 'assets/lotties/sunny.json';
    }
  }

  //weather animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather', style: TextStyle(fontFamily: 'DMSerifText')),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //get city
                  Text(
                    'City: ${_weather?.cityName ?? 'Loading City'}',
                    softWrap: true,
                    style: TextStyle(fontFamily: 'DMSerifText', fontSize: 20),
                  ),
                  //lottie according to weather condition
                  Lottie.asset(
                    getWeatherLottie(
                      _weather?.weatherCondition ?? 'assets/lotties/sunny.json',
                    ),
                  ),
                  //get temperature
                  Text(
                    'Temperature: ${_weather?.temperature.round()}°C',
                    style: TextStyle(fontFamily: 'DMSerifText', fontSize: 18),
                  ),
                  //get weatherCondition
                  Text(
                    _weather?.weatherCondition ?? '',
                    style: TextStyle(fontFamily: 'DMSerifText'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
