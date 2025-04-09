import 'dart:developer';
import 'package:facturation_intuitive/models/items_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ItemController extends GetxController {
  var name = ''.obs;
  var description = ''.obs;
  var quantity = 1.obs;
  var unite = ''.obs;
  var price = 0.0.obs;
  var tva = 0.obs;
  var totalPrice = 0.0.obs;
  var items = <ItemsModel>[].obs; // List to hold all items
  var nextId = 0.obs; // Next ID for new items
  var discount = 0.0.obs; // Single discount variable

  @override
  void onInit() {
    super.onInit();
    resetItems();
    loadItems(); // Load items when the controller is initialized
  }

  @override
  void onClose() {
    resetValues(); // Clear items and reset values on close
  }

  void updateName(String value) {
    name.value = value;
  }

  void updateDescription(String value) {
    description.value = value;
  }

  void updateQuantity(int value) {
    quantity.value = value;
  }

  void updateUnite(String value) {
    unite.value = value;
  }

  void updatePrice(double value) {
    price.value = value;
  }

  void updateTva(int value) {
    tva.value = value;
  }

  void updateTotalPrice(double value) {
    totalPrice.value = value;
  }

  // Create an ItemsModel object
  ItemsModel createItem() {
    final item = ItemsModel(
      id: nextId.value,
      name: name.value,
      description: description.value,
      quantity: quantity.value,
      unite: unite.value,
      price: price.value,
      tva: tva.value,
      totalPrice: totalPrice.value,
      discount: discount.value, // Use the single discount variable
    );
    items.add(item); // Add the new item to the list
    nextId.value++; // Increment the ID for the next item
    saveItems(); // Save items to persistent storage
    return item;
  }

  // Method to update an existing item
  void updateItem(ItemsModel updatedItem) {
    // Find the index of the item to update
    int index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      // Update the existing item
      items[index] = updatedItem;
      saveItems(); // Save the updated items to persistent storage
      log('Item updated: ${updatedItem.toJson()}'); // Log the updated item
    } else {
      log('Item with ID ${updatedItem.id} not found for update.');
    }
  }

  // Update loadItems to retrieve nextId from SharedPreferences
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonItems = prefs.getStringList('items');

    if (jsonItems != null) {
      items.value = jsonItems.map((jsonItem) => ItemsModel.fromJson(json.decode(jsonItem))).toList();
    }
    nextId.value = prefs.getInt('nextId') ?? 0; // Retrieve nextId or initialize to 0
  }

  // Update saveItems to save nextId in SharedPreferences
  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonItems = items.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('items', jsonItems);
    await prefs.setInt('nextId', nextId.value); // Save nextId to persistent storage
  }

  // Update resetValues to reset nextId in SharedPreferences
  void resetValues() {
    name.value = '';
    description.value = '';
    quantity.value = 1;
    unite.value = '';
    price.value = 0.0;
    tva.value = 0;
    totalPrice.value = 0.0;
    items.clear();
    nextId.value = 0;
    discount.value = 0.0; // Reset the discount variable

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('items');
      prefs.remove('nextId'); // Clear nextId as well
    });
  }

  // Method to clear items from SharedPreferences
  Future<void> resetItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('items'); // Clear saved items
    await prefs.remove('nextId'); // Clear nextId as well
    items.clear(); // Clear the items list in memory
    nextId.value = 0; // Reset nextId in memory
    discount.value = 0.0; // Clear the discount variable
    log("Items and discount reset on hot restart.");
  }

  // Add this method to set a discount for an item
  void setDiscount(double value) {
    discount.value = value; // Set the discount
  }

  // Method to calculate the average discount (now simply returns the discount)
  double get averageDiscount {
    return discount.value; // Return the current discount
  }
}
