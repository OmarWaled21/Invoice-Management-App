import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FactureModelController extends GetxController {
  // The default selected model is FactureModel1
  RxInt selectedModel = 1.obs; // This is the current selection
  int _tempModel = 1; // Temporary variable to hold the model selection

  @override
  void onInit() {
    super.onInit();
    // Load the saved model when the controller is initialized
    _loadSelectedModel();
  }

  // Method to set the selected model temporarily (without saving)
  void setSelectedModel(int model) {
    _tempModel = model; // Update the temporary variable
    selectedModel.value = model; // Update the displayed value
  }

  // Method to save the selected model to SharedPreferences
  Future<void> saveSelectedModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedModel', _tempModel); // Save the temporary model
  }

  // Method to reset the temporary model to the saved model
  Future<void> resetToSavedModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tempModel = prefs.getInt('selectedModel') ?? 1; // Load saved model
    selectedModel.value = _tempModel; // Set observable value to the loaded value
  }

  // Load the selected model from SharedPreferences
  void _loadSelectedModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tempModel = prefs.getInt('selectedModel') ?? 1; // Default to 1 if no saved model
    selectedModel.value = _tempModel; // Set the observable value to the loaded value
  }
}
