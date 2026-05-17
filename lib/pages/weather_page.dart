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

  String errorMessage = '';
  //fetch weather
  Future<Weather> fetchWeather() async {
    //get current city
    String cityName = await weatherService.getCurrentCity();
    return await weatherService.getWeather(cityName);
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
      body: FutureBuilder(
        future: fetchWeather(),

        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //if has error
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          //if data loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          //if data null
          if (!snapshot.hasData) {
            return Center(
              child: const Text('An error occured, please try again'),
            );
          }

          final weatherData = snapshot.data!;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weatherData.cityName ?? 'null'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'DMSerifText', fontSize: 24),
                    ),
                    Lottie.asset(
                      height: 200,
                      getWeatherLottie(
                        '${weatherData.weatherCondition ?? 'null'}',
                      ),
                    ),
                    Text(
                      '${weatherData.temperature.round()}°C',
                      style: TextStyle(fontFamily: 'DMSerifText', fontSize: 22),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${weatherData.weatherCondition ?? 'null'}',
                      style: TextStyle(fontFamily: 'DMSerifText', fontSize: 15),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
