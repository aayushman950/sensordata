import 'package:flutter/material.dart';

class AQIStatus extends StatelessWidget {
  const AQIStatus({super.key, required this.aqiRating});

  final int aqiRating;

  String aqiStatusCalculator(int aqiRating) {
    if (aqiRating >= 0 && aqiRating <= 50) {
      return 'GOOD';
    } else if (aqiRating >= 51 && aqiRating <= 100) {
      return "MODERATE";
    } else if (aqiRating >= 101 && aqiRating <= 150) {
      return "UNHEALTHY FOR SENSITIVE GROUPS";
    } else if (aqiRating >= 151 && aqiRating <= 200) {
      return "UNHEALTHY";
    } else if (aqiRating >= 201 && aqiRating <= 300) {
      return "VERY UNHEALTHY";
    } else if (aqiRating >= 301) {
      return "HAZARDOUS";
    } else {
      return "Unknown";
    }
  }

  Color aqiStatusColorCalculator(int aqiRating) {
    if (aqiRating >= 0 && aqiRating <= 50) {
      return Colors.green;
    } else if (aqiRating >= 51 && aqiRating <= 100) {
      return Colors.yellow;
    } else if (aqiRating >= 101 && aqiRating <= 150) {
      return Colors.orange;
    } else if (aqiRating >= 151 && aqiRating <= 200) {
      return Colors.red;
    } else if (aqiRating >= 201 && aqiRating <= 300) {
      return Colors.purple;
    } else if (aqiRating >= 301) {
      return Colors.red.shade900;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Air Quality is",
          style: TextStyle(fontSize: 25),
        ),
        Text(
          aqiStatusCalculator(aqiRating),
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: aqiStatusColorCalculator(aqiRating)
          ),
        ),
      ],
    );
  }
}
