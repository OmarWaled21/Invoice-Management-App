import 'dart:convert';
import 'package:facturation_intuitive/models/contacts_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientsController extends GetxController {
  var clients = <ContactsModel>[].obs;
  int nextId = 1; // Track the next available ID

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  void addClient(ContactsModel client) {
    clients.add(client);
    saveClients(); // Call to save clients after adding a new one
  }

  // Function to remove a client
  void removeClient(ContactsModel client) {
    clients.remove(client);
    saveClients(); // Save the updated list after removal
  }

  // Save clients to Shared Preferences
  Future<void> saveClients() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> clientJsonList =
    clients.map((client) => json.encode(client.toJson())).toList();
    await prefs.setStringList('clients', clientJsonList);
  }

  // Load clients from Shared Preferences
  Future<void> loadClients() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? clientJsonList = prefs.getStringList('clients');
    if (clientJsonList != null) {
      clients.value = clientJsonList
          .map((clientJson) => ContactsModel.fromJson(json.decode(clientJson)))
          .toList();
    }
  }

  // This can be called when creating a new contact to get the next ID
  int getNextClientId() {
    if (clients.isEmpty) {
      return 1; // Start IDs from 1 if no clients exist
    }
    // Find the maximum ID in the existing clients
    return clients.map((client) => client.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
