import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:facturation_intuitive/models/contacts_model.dart';
import 'package:facturation_intuitive/models/items_model.dart';

class FactureModel {
  String invoiceNumber;
  final ProfileModel businessDetails; // From ProfileController
  ContactsModel? clientDetails; // From ClientsController
  DateTime dateEmission;
  DateTime dateEchance;
  List<ItemsModel> items; // List to hold items
  double montantTotal;
  double sousTotal;
  double tvaAverage;
  int selectedModel;

  FactureModel({
    required this.invoiceNumber,
    required this.businessDetails,
    this.clientDetails,
    required this.dateEmission,
    required this.dateEchance,
    required this.items, // Initialize with an empty list
    required this.montantTotal,
    required this.sousTotal,
    required this.tvaAverage,
    required this.selectedModel,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'invoiceNumber': invoiceNumber,
      'businessDetails': businessDetails.toJson(),
      'clientDetails': clientDetails?.toJson() ?? '',
      'dateEmission': dateEmission.toIso8601String(),
      'dateEchance': dateEchance.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'montantTotal': montantTotal, // Save montantTotal to JSON
      'sousTotal': sousTotal, // Save montantTotal to JSON
      'tvaAverage': tvaAverage, // Save montantTotal to JSON
      'selectedModel': selectedModel,
    };
  }

  // Create from JSON
  factory FactureModel.fromJson(Map<String, dynamic> json) {
    return FactureModel(
      invoiceNumber: json['invoiceNumber'],
      businessDetails: ProfileModel.fromJson(json['businessDetails']),
      clientDetails: json['clientDetails'] != null
          ? ContactsModel.fromJson(json['clientDetails'])
          : null,
      dateEmission: DateTime.parse(json['dateEmission']),
      dateEchance: DateTime.parse(json['dateEchance']),
      items: (json['items'] as List)
          .map((itemJson) => ItemsModel.fromJson(itemJson))
          .toList(),
      montantTotal: json['montantTotal'] ?? 0.0,
      sousTotal: json['sousTotal'] ?? 0.0,
      tvaAverage: json['tvaAverage'] ?? 0.0,
      selectedModel: json['selectedModel'],
    );
  }
}
