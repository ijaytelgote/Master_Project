import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scatter Plot Example'),
        ),
        body: FutureBuilder(
          future: fetchScatterData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<FlSpot> spots = List.from(snapshot.data ?? []);
              return ScatterChart(
                ScatterChartData(
                  scatterSpots: spots.map((spot) => ScatterSpot(spot.x, spot.y)).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<FlSpot>> fetchScatterData(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/scatter_data'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<FlSpot> spots = data.map((entry) => FlSpot(entry['X'].toDouble(), entry['Y'].toDouble())).toList();
        return spots;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
