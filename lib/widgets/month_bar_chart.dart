import 'package:facturation_intuitive/controller/monthley_summray_controller.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthBarChart extends StatelessWidget {
  final MonthlySummaryController monthlySummaryController = Get.find<MonthlySummaryController>();

  MonthBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Calculate maximum Y value dynamically based on the totals
      double maxY = (monthlySummaryController.monthlyTotals.values.isEmpty)
          ? 10
          : (monthlySummaryController.monthlyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2);

      final ThemeController themeController = Get.find<ThemeController>();
      final isLightTheme = themeController.themeMode.value == ThemeMode.light;

      List<BarChartGroupData> barGroups = _generateBarGroups((isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor));

      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomTitles,
                reservedSize: 42,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
        ),
      );
    });
  }

  // Generate bar groups based on the selected date range
  List<BarChartGroupData> _generateBarGroups(Color color) {
    List<BarChartGroupData> barGroups = [];

    if (monthlySummaryController.selectedStartDate.value != null &&
        monthlySummaryController.selectedEndDate.value != null) {
      DateTime start = monthlySummaryController.selectedStartDate.value!;
      DateTime end = monthlySummaryController.selectedEndDate.value!;

      for (DateTime date = start; date.isBefore(end.add(const Duration(days: 1))); date = DateTime(date.year, date.month + 1, 1)) {
        String monthKey = '${date.year}-${date.month}';
        double monthTotal = monthlySummaryController.monthlyTotals[monthKey] ?? 0.0;
        barGroups.add(_buildBarChartGroup(date.month - 1, monthTotal, color)); // month - 1 for zero-based index
      }
    }

    return barGroups;
  }

  BarChartGroupData _buildBarChartGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        ),
      ],
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        months[value.toInt()],
        style: TextStyle(
          color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
