import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart<T> extends StatelessWidget {
  const CustomLineChart({
    required this.dataList,
    required this.flSpots,
    super.key,
  });

  final List<T> dataList;
  final List<FlSpot> flSpots;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final TextStyle style = TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 8
                    );
                    Widget text;
                    switch (value.toInt()) {
                      case 1:
                        text = Text("JAN", style: style);
                        break;
                      case 2:
                        text = Text("FEB", style: style);
                        break;
                      case 3:
                        text = Text("MAR", style: style);
                        break;
                      case 4:
                        text = Text("APR", style: style);
                        break;
                      case 5:
                        text = Text("MAY", style: style);
                        break;
                      case 6:
                        text = Text("JUN", style: style);
                        break;
                      case 7:
                        text = Text("JUL", style: style);
                        break;
                      case 8:
                        text = Text("AUG", style: style);
                        break;
                      case 9:
                        text = Text("SEPT", style: style);
                        break;
                      case 10:
                        text = Text("OCT", style: style);
                        break;
                      case 11:
                        text = Text("NOV", style: style);
                        break;
                      case 12:
                        text = Text("DEC", style: style);
                        break;
                      default:
                        text = Text("", style: style);
                        break;
                    }
                    return SideTitleWidget(
                      child: text,
                      axisSide: meta.axisSide,
                    );
                  },
                  interval: 1,
                )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final TextStyle style = TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 8
                  );
                  return Text("${value}",
                    style: style,
                  );
                },
                reservedSize: 20,
                interval: 2,
              ),
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
            ),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
            ),
          ),
          minY: 0,
          minX: 0,
          maxY: dataList.length.toDouble() + 3,
          maxX: 12,
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.orange,
              width: 1,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: flSpots,
              isCurved: false,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.white.withOpacity(0.3),
              ),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
