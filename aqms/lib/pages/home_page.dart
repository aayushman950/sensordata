import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:aqms/widgets/both_pm_tile.dart';
import 'package:aqms/services/fetch_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>> fetchLatestData() async {
    return await FetchLatestData.getLatestData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.place),
              SizedBox(width: 5),
              Text(
                "Sensor 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchLatestData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                final double aqi = data['AQI'] ?? 0.0;
                final double pm10 = data['PM10'] ?? 0.0;
                final double pmTwoPointFive = data['PM2.5'] ?? 0.0;
                final String rawTime = data['time'] ?? "";

                // Parse the custom date format
                final DateFormat inputFormat =
                    DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
                final DateTime parsedTime = inputFormat.parse(rawTime);
                final String formattedTime =
                    DateFormat('yyyy-MM-dd hh:mm a').format(parsedTime);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AQIGaugeAndStatus(aqiRating: aqi.toInt()),
                    BothPMTile(
                      pmTwoPointFiveValue: pmTwoPointFive.toInt(),
                      pmTenValue: pm10.toInt(),
                    ),
                    Text(
                      "Last Updated: $formattedTime",
                      style: const TextStyle(
                          fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
