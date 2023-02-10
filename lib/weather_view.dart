import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Entities
class WeatherData {
  final String time;
  final num windSpeed;
  final num humidity;
  final num temperature;
  final String location;

  WeatherData({
    required this.time,
    required this.windSpeed,
    required this.humidity,
    required this.temperature,
    required this.location,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      time: json['time'],
      windSpeed: json['values']['windSpeed'],
      humidity: json['values']['humidity'],
      temperature: json['values']['temperature'],
      location: "",
    );
  }
}

// Use Cases
class GetWeatherData {
  final String apiKey;

  GetWeatherData({
    required this.apiKey,
  });

  Future<List<WeatherData>> execute(String city) async {
    final response = await http.get(
      Uri.parse(
        "https://api.tomorrow.io/v4/weather/forecast?location=$city&apikey=$apiKey",
      ),
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      List weatherData = responseJson['timelines']['hourly'];
      return weatherData
          .map((weather) => WeatherData.fromJson(weather))
          .toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

// UI
class WeatherList extends StatefulWidget {
  final GetWeatherData useCase;

  const WeatherList({
    super.key,
    required this.useCase,
  });

  @override
  _WeatherListState createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> {
  List<WeatherData> _weathers = [];
  String _city = "India/Kolkata";
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityController.text = "India/Kolkata";
    _fetchWeatherData();
  }

  _fetchWeatherData() async {
    _weathers = await widget.useCase.execute(_city);
    setState(() {});
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
                  title: Text(_city),
                  subtitle: Text(weather.time.toString()),
                  trailing: Text('Temp:${weather.temperature}°C'),
                );
              }),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              child: InkWell(
                onTap: () {
                  changeCity();
                },
                child: const Text("ChangeLocation"),
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
          title: const Text('EnterCity'),
          content: TextField(
            controller: cityController,
            decoration: const InputDecoration(hintText: 'e.g.London,UK'),
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
  final WeatherData weather;

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
              'Location:$location',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Temperature:${weather.temperature}°C',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'WindSpeed:${weather.windSpeed}m/s',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Humidity:${weather.humidity}%',
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
