import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  final String time;
  final num? windSpeed;
  final num? humidity;
  final num? temperature;
  final String location;

  Weather({
    required this.time,
    required this.windSpeed,
    required this.humidity,
    required this.temperature,
    required this.location,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      time: json['time'],
      windSpeed: json['values']['windSpeed'],
      humidity: json['values']['humidity'],
      temperature: json['values']['temperature'],
      location: json['location'],
    );
  }
}

class WeatherList extends StatefulWidget {
  const WeatherList({super.key});

  @override
  _WeatherListState createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> {
  List<Weather> _weathers = [];
  String _city = "India/Kolkata";
  final String _apiKey = "A5saI8Gz2Fw49VvBKfEPRLKy8ZBQQNFb";
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityController.text = "India/Kolkata";
    _fetchWeatherData();
  }

  _fetchWeatherData() async {
    final response = await http.get(
      Uri.parse(
        "https://api.tomorrow.io/v4/weather/forecast?location=$_city&apikey=$_apiKey",
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      List weatherData = responseJson['timelines']['hourly'];
      setState(() {
        _weathers =
            weatherData.map((weather) => Weather.fromJson(weather)).toList();
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: _weathers.length,
            itemBuilder: (context, index) {
              final weather = _weathers[index];
              return ListTile(
                title: Text(_city),
                subtitle: Text(weather.time.toString()),
                trailing: Text('Temp : ${weather.temperature} °C'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherDetailsPage(
                        weather: weather,
                        location: _city,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              child: InkWell(
                onTap: () {
                  changeCity();
                },
                child: const Text("Change Location"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> changeCity() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter City'),
          content: TextField(
            controller: cityController,
            decoration: const InputDecoration(hintText: 'e.g. London, UK'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _city = cityController.text;
                });
                Navigator.of(context).pop();
                _fetchWeatherData();
              },
            ),
          ],
        );
      },
    );
  }
}

class WeatherDetailsPage extends StatelessWidget {
  final String location;
  final Weather weather;

  const WeatherDetailsPage({
    super.key,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location: $location',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Temperature: ${weather.temperature}°C',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Wind Speed: ${weather.windSpeed} m/s',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Humidity: ${weather.humidity}%',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
