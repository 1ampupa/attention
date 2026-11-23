import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReactionTimeChart extends StatelessWidget {
  final List<int> reactionTimes;

  const ReactionTimeChart({super.key, required this.reactionTimes});

  @override
  Widget build(BuildContext context) {
    if (reactionTimes.isEmpty) {
      return const Center(child: Text("No reaction time data."));
    }

    final spots = reactionTimes
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key + 1, entry.value.toDouble()))
        .toList();

    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 2.0,
                  color: Theme.of(context).colorScheme.primary,
                  dotData: const FlDotData(show: true),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toInt()} ms',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: const FlGridData(
                show: true,
                horizontalInterval: 500,
                verticalInterval: 5,
              ),
              borderData: FlBorderData(show: true),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
