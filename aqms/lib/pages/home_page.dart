import 'package:aqms/services/fetch_cloud_final.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:aqms/widgets/both_pm_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> latestData;

  @override
  void initState() {
    super.initState();
    latestData = fetchData();
  }

  Future<void> _refreshData() async {
    // Re-fetch the data and update the state
    setState(() {
      latestData = fetchData();
    });
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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: latestData,
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
                  // Log fetched data
                  print('Fetched Data: ${snapshot.data}');

                  var pm10 = snapshot.data?['pm10'];
                  var pm25 = snapshot.data?['pm25'];
                  var aqi = snapshot.data?['pm25_aqi'];

                  if (pm10 != null) pm10 = double.parse(pm10);
                  if (pm25 != null) pm25 = double.parse(pm25);

                  final formattedTime =
                      ""; // Replace with formatted timestamp if available.

                  return ListView(
                    children: [
                      AQIGaugeAndStatus(aqiRating: aqi ?? 0),
                      BothPMTile(
                        pmTwoPointFiveValue: pm25 ?? 0,
                        pmTenValue: pm10 ?? 0,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Last Updated: $formattedTime",
                          style: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
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
      ),
    );
  }
}
