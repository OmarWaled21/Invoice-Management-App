import 'dart:convert';
import 'dart:developer';
import 'package:facturation_intuitive/controller/choose_model_controller.dart';
import 'package:facturation_intuitive/models/contacts_model.dart';
import 'package:facturation_intuitive/models/facture_model.dart';
import 'package:facturation_intuitive/controller/profile_controller.dart';
import 'package:facturation_intuitive/controller/clients_controller.dart';
import 'package:facturation_intuitive/models/items_model.dart';
import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/controller/item_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FactureController extends GetxController {
  var selectedClientId = 0.obs;
  RxList<ItemsModel> items = <ItemsModel>[].obs; // Assuming items should be of type ItemsModel
  RxList<FactureModel> factureHistory = <FactureModel>[].obs;
  FactureModelController factureModelController = Get.find<FactureModelController>();

  // Reactive totals
  RxDouble sousTotal = 0.0.obs;
  RxDouble montantTotal = 0.0.obs;
  RxDouble tvaAverage = 0.0.obs;

  // Reactive selection variables
  RxBool isPrixHTSelected = true.obs; // Initially set to Prix HT as selected
  RxBool isPrixTTCSelected = false.obs;

  RxString invoiceNumber = '${DateTime.now().year} - 1'.obs; // Initialize with current year and first invoice number

  var facture = FactureModel(
    invoiceNumber: '',
    businessDetails: ProfileModel(
      name: '',
      address: '',
      address2: '',
      city: '',
      postalCode: '',
      country: '',
      tvaNumber: '',
      email: '',
      phone: '',
      image: '',
      siret: '',
    ),
    clientDetails: ContactsModel(
      id: 0,
      name: '',
      address: '',
      email: '',
      phone: 0,
      clientType: '',
      country: '',
      tvaNumber: '',
    ),
    dateEmission: DateTime.now(),
    dateEchance: DateTime.now(),
    montantTotal: 0.0,
    sousTotal: 0.0,
    tvaAverage: 0.0,
    items: [],
    selectedModel: 1
  ).obs;

  ItemController itemController = Get.put(ItemController());

  @override
  void onInit() {
    super.onInit();
    loadSelectedPriceFormat(); // Load the saved price format on initialization
    loadSavedFactureDetails();
    loadFactureDetails();
    ever(selectedClientId, (_) => updateClientFromId());
    loadSelectedClientId(); // Load selected client ID from SharedPreferences
    loadFactureHistory();

    // Calculate totals whenever the items list changes
    ever(items, (_) => calculateTotals());
  }

  @override
  void onClose() {
    // Clear items and reset selected client when controller is removed (e.g., hot restart)
    clearItems(); // Call this method to clear items
    resetSelectedClient(); // Add this method to reset the selected client
  }


  void calculateTotals() {
    sousTotal.value = items.fold(0.0, (sum, item) => sum + item.price!.toDouble());
    montantTotal.value = items.fold(0.0, (sum, item) => sum + item.totalPrice!.toDouble());

    // Calculate total TVA
    tvaAverage.value = items.isNotEmpty
        ? items.map((item) => item.tva ?? 0).reduce((a, b) => a + b) /
        items.length
        : 0.0;
  }

  Future<void> loadFactureDetails() async {
    ProfileController profileController = Get.find<ProfileController>();
    ClientsController clientsController = Get.find<ClientsController>();

    await profileController.loadProfileDetails();
    await clientsController.loadClients();

    final prefs = await SharedPreferences.getInstance();

    // Load saved values from SharedPreferences
    String savedInvoiceNumber = prefs.getString('invoiceNumber') ?? '${DateTime.now().year} - 1';
    DateTime savedDateEmission = DateTime.parse(prefs.getString('dateEmission') ?? DateTime.now().toIso8601String());
    DateTime savedDateEchance = DateTime.parse(prefs.getString('dateEchance') ?? DateTime.now().add(const Duration(days: 14)).toIso8601String()); // Default to 30 days later


    facture.value = FactureModel(
      invoiceNumber: savedInvoiceNumber,
      businessDetails: profileController.profileDetails.value,
      clientDetails: _getSelectedClient(),
      dateEmission: savedDateEmission,
      dateEchance: savedDateEchance,
      items: items,
      montantTotal: montantTotal.value,
      sousTotal: sousTotal.value,
      tvaAverage: tvaAverage.value,
      selectedModel: factureModelController.selectedModel.value,
    );
  }

  Future<void> loadSavedFactureDetails() async {
    final prefs = await SharedPreferences.getInstance();

    // Load and update the stored document number, emission date, and due date
    facture.update((facture) {
      facture?.invoiceNumber = prefs.getString('invoiceNumber') ?? '${DateTime.now().year} - 1';
      facture?.dateEmission = DateTime.parse(prefs.getString('dateEmission') ?? DateTime.now().toIso8601String());
      facture?.dateEchance = DateTime.parse(prefs.getString('dateEchance') ?? DateTime.now().add(const Duration(days: 14)).toIso8601String()); // Default to 30 days later
    });

    log("Loaded saved facture details: ${facture.value}");
  }

  ContactsModel _getSelectedClient() {
    ClientsController clientsController = Get.find<ClientsController>();
    return clientsController.clients.firstWhere(
          (client) => client.id == selectedClientId.value,
      orElse: () => ContactsModel(
        id: 0,
        name: '',
        address: '',
        email: '',
        phone: 0,
        clientType: '',
        country: '',
      ),
    );
  }

  void updateClient(ContactsModel client) {
    facture.update((f) {
      f?.clientDetails = client;
    });
    saveSelectedClientId(client.id); // Save selected client ID
    log("Updated selected client: ${client.id} ${client.name}");
  }

  void setSelectedClientId(int clientId) {
    selectedClientId.value = clientId;
  }

  void updateClientFromId() {
    updateClient(_getSelectedClient());
  }

  void updateInvoiceNumber(String invoiceNumber) {
    facture.update((facture) {
      facture?.invoiceNumber = invoiceNumber;
    });
    log("Updated invoice number: $invoiceNumber");
  }

  void updateDateEmission(DateTime newDate) {
    facture.update((facture) {
      facture?.dateEmission = newDate;
    });
  }

  void updateDateEchance(DateTime newDate) {
    facture.update((facture) {
      facture?.dateEchance = newDate;
    });
  }

  void addItem(ItemsModel item) {
    items.add(item);
    calculateTotals();
    updateFactureTotals();
    log("Added item: ${item.name}");
  }

  void updateItem(int id, ItemsModel updatedItem) {
    // Find the index of the item with the given ID
    int index = items.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Update the item in both facture.items and items
      items[index] = updatedItem; // Update the local items list

      // Update the facture's items list if it exists
      facture.update((facture) {
        // Check if the facture has an item at the same index
        if (facture!.items.length > index) {
          facture.items[index] = updatedItem; // Update the facture item
        }
      });

      // Explicit refresh after updating to ensure UI reflects changes
      items.refresh(); // Ensure your list updates in the UI
      calculateTotals(); // Recalculate totals if necessary
      log("Updated item with ID $id: ${updatedItem.name}");
    } else {
      // Handle the case where the item with the specified ID is not found
      log("Error: Item with ID $id does not exist.");
    }
  }

  // Method to remove an item
  void removeItem(int index) {
    items.removeAt(index);
    calculateTotals();
    updateFactureTotals();
  }

  // Save items and totals to facture
  void updateFactureTotals() {
    facture.update((f) {
      f?.items = items.toList();
      f?.montantTotal = montantTotal.value;
      f?.sousTotal = sousTotal.value;
      f?.tvaAverage = tvaAverage.value;
    });
  }

  // Clear all items from the facture
  void clearItems() {
    montantTotal.value = 0.0;
    sousTotal.value = 0.0;
    tvaAverage.value = 0.0;
    facture.update((facture) {
      facture?.items.clear();
    });
    items.clear();
    items.refresh(); // Explicit refresh for UI observers
    calculateTotals();
    log("Cleared all items from the facture and UI.");
  }

  // Reset the selected client ID and details
  void resetSelectedClient() {
    selectedClientId.value = 0; // Reset selected client ID
    updateClient(ContactsModel(
      id: 0,
      name: '',
      address: '',
      email: '',
      phone: 0,
      clientType: '',
      country: '',
    )); // Reset client details
    clearSelectedClientId(); // Clear selected client ID from SharedPreferences
  }

// Save `montantTotal` independently
  Future<void> saveMontantTotal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('montantTotal', montantTotal.value.toStringAsFixed(2));
    await prefs.setString('sousTotal', sousTotal.value.toStringAsFixed(2));
    await prefs.setString('tvaAverage', tvaAverage.value.toStringAsFixed(2));
    log("Montant Total saved: ${montantTotal.value}");
    log("Sous Total saved: ${sousTotal.value}");
    log("Tva Average saved: ${tvaAverage.value}");
  }

  // Save facture details along with adding it to history
  Future<void> saveFactureDetails() async {
    log("Saving facture details: ${facture.value}");

    // Calculate the latest totals based on items
    calculateTotals();

    // Get the selected model from FactureModelController
    int currentSelectedModel = factureModelController.selectedModel.value;

    // Update the current facture's montantTotal before saving
    facture.update((f) {
      f?.montantTotal = montantTotal.value;
      f?.sousTotal = sousTotal.value;
      f?.tvaAverage = tvaAverage.value;
      f?.selectedModel = currentSelectedModel;
    });

    final prefs = await SharedPreferences.getInstance();

    // Save document number, emission date, and due date
    await prefs.setString('invoiceNumber', facture.value.invoiceNumber);
    await prefs.setString('dateEmission', facture.value.dateEmission.toIso8601String());
    await prefs.setString('dateEchance', facture.value.dateEchance.toIso8601String());
    await prefs.setString('factureData', facture.value.toJson().toString());

    // Load current facture history
    List<String>? factureHistoryList = prefs.getStringList('factureHistory') ?? [];

    // Convert facture to JSON, including montantTotal and other totals
    var factureData = facture.value.toJson();
    factureHistoryList.add(json.encode(factureData));

    // Save updated history
    await prefs.setStringList('factureHistory', factureHistoryList);

    // Refresh the factureHistory list to update in UI
    factureHistory.add(facture.value); // Update with latest facture model
    factureHistory.refresh();

    log("Facture History:");
    for (var i = 0; i < factureHistory.length; i++) {
      var facture = factureHistory[i];
      log("Facture ${i + 1}: ${facture.toJson()}");
    }

    log("Facture saved to history with montantTotal: ${facture.value.montantTotal}");
  }

  Future<void> loadFactureHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFactureHistory = prefs.getStringList('factureHistory') ?? [];

    // Load and filter the saved factures
    factureHistory.value = savedFactureHistory.map((factureJson) {
      var data = json.decode(factureJson);
      var factureModel = FactureModel.fromJson(data);

      // Optionally populate reactive totals with saved values if needed
      sousTotal.value += data['sousTotal'] ?? 0.0;
      tvaAverage.value += data['tvaAverage'] ?? 0.0;
      montantTotal.value += data['montantTotal'] ?? 0.0;

      return factureModel;
    }).where((facture) {
      // Filter out invalid factures
      return facture.clientDetails?.name != '';
    }).toList();
  }

  Future<void> clearFactureDetails() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear the facture history
    await prefs.remove('factureHistory');
    await prefs.remove('invoiceNumber');

    log("Facture history cleared.");
  }


  Future<void> loadSelectedClientId() async {
    final prefs = await SharedPreferences.getInstance();
    selectedClientId.value = prefs.getInt('selectedClientId') ?? 0;
    updateClientFromId(); // Update client details based on loaded ID
  }

  Future<void> saveSelectedClientId(int clientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedClientId', clientId);
  }

  Future<void> clearSelectedClientId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedClientId'); // Clear selected client ID
  }

  void selectPrixHT() {
    isPrixHTSelected.value = true;
    isPrixTTCSelected.value = false;
  }

  void selectPrixTTC() {
    isPrixTTCSelected.value = true;
    isPrixHTSelected.value = false;
  }

  // Save selected price format to SharedPreferences
  Future<void> saveSelectedPriceFormat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPrixHTSelected', isPrixHTSelected.value);
  }

  // Load selected price format from SharedPreferences
  Future<void> loadSelectedPriceFormat() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isHTSelected = prefs.getBool('isPrixHTSelected');

    if (isHTSelected != null) {
      isPrixHTSelected.value = isHTSelected;
      isPrixTTCSelected.value = !isHTSelected;
    }
  }

  void resetDocumentDate() async {
    DateTime now = DateTime.now(); // Get the current date and time
    facture.update((facture) {
      facture?.dateEmission = DateTime(now.year, now.month, now.day); // Reset dateEmission to today
      facture?.dateEchance = now.add(const Duration(days: 14)); // Set dateEchance to 14 days from today
    });

    // Save the updated dates to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dateEmission', facture.value.dateEmission.toIso8601String());
    await prefs.setString('dateEchance', facture.value.dateEchance.toIso8601String());

    log("Reset dateEmission to: ${facture.value.dateEmission}");
    log("Set dateEchance to: ${facture.value.dateEchance}");
  }

  void incrementInvoiceNumber() async {
    // Check if a client is selected (client name is not empty)
    if (facture.value.clientDetails?.name.isNotEmpty ?? false) {
      final prefs = await SharedPreferences.getInstance();
      int currentYear = DateTime.now().year;

      // Retrieve the saved invoice number and year from SharedPreferences
      String? savedInvoice = prefs.getString('invoiceNumber');
      int? savedYear = prefs.getInt('currentYear');

      // Parse the saved invoice number or set to 1 if it is null or the year has changed
      int currentNumber;
      if (savedYear == null || savedYear != currentYear || savedInvoice == null) {
        currentNumber = 1;
        await prefs.setInt('currentYear', currentYear); // Update stored year
      } else {
        currentNumber = int.parse(savedInvoice.split(' - ')[1]) + 1;
      }

      // Update the invoice number reactive variable with the new or incremented number
      invoiceNumber.value = '$currentYear - $currentNumber';

      // Update the facture object
      facture.update((f) {
        f?.invoiceNumber = invoiceNumber.value;
      });

      // Save the updated invoice number to SharedPreferences
      await prefs.setString('invoiceNumber', invoiceNumber.value);

      // Log the updated invoice number
      log("Updated invoice number: ${invoiceNumber.value}");
    } else {
      // Log that the invoice number won't be incremented if no client is selected
      log("Cannot increment invoice number: no client selected.");
    }
  }
}
