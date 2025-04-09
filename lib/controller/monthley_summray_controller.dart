import 'dart:convert';
import 'package:get/get.dart';
import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthlySummaryController extends GetxController {
  final FactureController factureController = Get.find<FactureController>();
  final RxMap<String, double> monthlyTotals = <String, double>{}.obs;
  final Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMonthlyTotals(); // Load saved totals when the controller initializes
    calculateMonthlyTotals(); // Calculate totals based on current facture history
  }

  // Calculate total montant for each month and save it
// Update calculateMonthlyTotals to ensure it processes the full range
  Future<void> calculateMonthlyTotals() async {
    Map<String, double> monthlySums = {};

    for (var facture in factureController.factureHistory) {
      if (facture.montantTotal > 0) {
        DateTime emissionDate = facture.dateEmission;

        if (selectedStartDate.value != null && selectedEndDate.value != null) {
          // Check if the emission date is within the selected date range
          if (emissionDate.isAfter(selectedStartDate.value!.subtract(const Duration(days: 1))) &&
              emissionDate.isBefore(selectedEndDate.value!.add(const Duration(days: 1)))) {
            final monthYearKey = '${emissionDate.year}-${emissionDate.month}';
            monthlySums.update(monthYearKey, (value) => value + facture.montantTotal,
                ifAbsent: () => facture.montantTotal);
          }
        }
      }
    }

    monthlyTotals.assignAll(monthlySums);
    await saveMonthlyTotals(monthlySums);
  }

  // Save monthly totals to SharedPreferences
  Future<void> saveMonthlyTotals(Map<String, double> totals) async {
    final prefs = await SharedPreferences.getInstance();
    final totalsJson = json.encode(totals); // Encode to JSON
    prefs.setString('monthlyTotals', totalsJson);
  }

  // Retrieve saved monthly totals
  Future<void> loadMonthlyTotals() async {
    final prefs = await SharedPreferences.getInstance();
    final totalsString = prefs.getString('monthlyTotals');
    if (totalsString != null) {
      final loadedTotals = Map<String, double>.from(json.decode(totalsString));
      monthlyTotals.assignAll(loadedTotals);
    }
  }

  double getMonthlyTotalForDate(DateTime selectedDate) {
    String monthYearKey = '${selectedDate.year}-${selectedDate.month}';
    return monthlyTotals[monthYearKey] ?? 0.0;
  }
}
