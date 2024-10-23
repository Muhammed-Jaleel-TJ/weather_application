import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather.dart';
import 'package:weather_application/consts.dart';
import 'package:weather_application/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService(API_KEY);

  final WeatherFactory _wf = WeatherFactory(API_KEY);

  Weather? _weather;

  String? name;

  Future<void> getCurrentWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _wf.currentWeatherByCityName(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(context) {
    if (_weather == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(204, 226, 139, 8),
              Color.fromARGB(225, 8, 79, 138),
              Colors.black
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //present day
                    _presentDay(),
                    Column(
                      children: [
                        //current time
                        _time(),
                        //current Date
                        _date(),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(Icons.location_on,
                                  color: Colors.deepPurple, size: 30),
                            ),
                          ),
                          TextSpan(
                            text: _weather?.areaName ?? "",
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 350,
                      width: 350,
                      child: _weather != null
                          ? Lottie.asset(_getWeatherAnimation(
                              _weather?.weatherDescription))
                          : const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 10),
                    Text(_weather?.weatherDescription ?? "Fetching weather...",
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    const SizedBox(height: 50),
                    Text(
                      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.sizeOf(context).height * 0.15,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(183, 208, 130, 12),
                        Color.fromARGB(225, 8, 79, 138),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Max : ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Text(
                            "Min : ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Wind : ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Text(
                            "Humidity : ${_weather?.humidity?.toStringAsFixed(0)}%",
                            style: GoogleFonts.orbitron(
                              textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getWeatherAnimation(String? condition) {
    if (condition == null) {
      return 'assets/images/sunny_weather.json';
    }
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'broken clouds':
        return 'assets/images/cloudy_weather.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'light rain':
        return 'assets/images/rainy_weather.json';
      case 'thunderstorm':
        return 'assets/images/thunder_weather.json';
      case 'clear':
        return 'assets/images/sunny_weather.json';
      default:
        return 'assets/images/sunny_weather.json';
    }
  }

  Widget _time() {
    DateTime now = _weather!.date!;
    return Text(
      DateFormat("hh:mm a").format(now),
      style: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
      ),
    );
  }

  Widget _date() {
    DateTime now = _weather!.date!;
    return Text(
      DateFormat("d.M.yyyy").format(now),
      style: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
      ),
    );
  }

  Widget _presentDay() {
    DateTime now = _weather!.date!;
    return Text(
      DateFormat("EEEE").format(now),
      style: GoogleFonts.orbitron(
        textStyle: const TextStyle(
          fontSize: 25,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
