import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TvaController extends GetxController {
  var switchTVA = false.obs;

  // Keys for SharedPreferences
  final String _tvaKey = 'switchTVA';

  @override
  void onInit() {
    super.onInit();
    loadSwitchState(); // Load the initial value from SharedPreferences
  }

  // Function to load the saved switch state from SharedPreferences
  Future<void> loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switchTVA.value = prefs.getBool(_tvaKey) ?? false; // Default to false if no value is found
  }

  // Save switch state to SharedPreferences
  Future<void> saveSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tvaKey, switchTVA.value);
  }
}
