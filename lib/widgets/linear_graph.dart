import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LinearGraph extends StatelessWidget {
  final List<double> dataPoints;
  final double maxY;
  const LinearGraph({super.key, required this.dataPoints, required this.maxY});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                dataPoints.length,
                (i) => FlSpot(i.toDouble(), dataPoints[i]),
              ),
              isCurved: true,
              color: Theme.of(context).colorScheme.secondary,
              barWidth: 4,
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
