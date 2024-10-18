import 'package:rekam_medis_pasien/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineReportChart extends StatelessWidget {
  final List<FlSpot> dataPoints; // Accept data points as a parameter

  LineReportChart({required this.dataPoints}); // Constructor with required parameter

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true), // Set to true for better visuals
          borderData: FlBorderData(show: true), // Show borders
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: dataPoints,
              isCurved: true,
              dotData: FlDotData(show: true), // Show dots on points
              belowBarData: BarAreaData(show: false),
              color: kPrimaryColor, // Change from colors to color
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}

// Example of how to call this widget
// In your screen widget where you want to use the chart, pass the data:
// LineReportChart(dataPoints: getSports());
