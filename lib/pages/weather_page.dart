import 'package:apiweather/models/weather_model.dart';
import 'package:apiweather/services/weather_service.dart';
import 'package:flutter/material.dart';

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

  //weather animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('City: ${_weather?.cityName ?? 'Loading City'}'),
                  Text(
                    'Temperature: ${_weather?.temperature ?? 'Loading temperature'}',
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
