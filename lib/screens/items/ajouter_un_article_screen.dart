import 'dart:developer';

import 'package:facturation_intuitive/controller/facture_controller.dart';
import 'package:facturation_intuitive/controller/item_controller.dart';
import 'package:facturation_intuitive/main.dart';
import 'package:facturation_intuitive/models/items_model.dart';
import 'package:facturation_intuitive/utils/themes/colors.dart';
import 'package:facturation_intuitive/utils/themes/theme_controller.dart';
import 'package:facturation_intuitive/widgets/bottom_button_in_screen.dart';
import 'package:facturation_intuitive/widgets/client/custom_text_field.dart';
import 'package:facturation_intuitive/widgets/custom_drop_down.dart';
import 'package:facturation_intuitive/widgets/default_appbar.dart';
import 'package:facturation_intuitive/widgets/text_widgets/bold_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AjouterUnArticleScreen extends StatefulWidget {
  final ItemsModel? item;
  final int? index; // Add index for existing item
  const AjouterUnArticleScreen({super.key, this.item, this.index});

  @override
  State<AjouterUnArticleScreen> createState() =>
      _AjouterUnArticleScreenScreenState();
}

final TextEditingController nomController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController quantiteController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController tvaController = TextEditingController();

class _AjouterUnArticleScreenScreenState extends State<AjouterUnArticleScreen> {
  final FocusNode _quantiteFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  double? discountPercentage;

  // List of available units
  final List<String> _units = [
    'hour', 'day', 'month', 'each', 'carton', 'kg', 'km', 'liter', 'meter', 'm²',
    'm³', 'night', 'package', 'ton', 'year', 'minute', 'lm', 'word', 'week',  'N/A'
  ];

  // Initially selected unit
  String _selectedUnit = 'Each';

  // List of available units
  final List<double> _tva = [0, 5, 8.5, 10, 13, 20];

  // Initially selected unit
  double _selectedTva = 0;

  double _totalPrice = 0.00;

  // Initialize the controller
  final ItemController itemController = Get.put(ItemController());

  final FactureController factureController = Get.find<FactureController>();

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      // If editing, populate the fields
      nomController.text = widget.item!.name!;
      descriptionController.text = widget.item!.description ?? '';
      quantiteController.text = widget.item!.quantity.toString();
      priceController.text = widget.item!.price!.toString();
      _selectedTva = widget.item!.tva!.toDouble();
      _calculateTotal(); // Calculate total based on the existing item values
    }else{
      // If editing, populate the fields
      nomController.text = '';
      descriptionController.text = '';
      quantiteController.text = '1,00';
      priceController.text = '';
      _selectedTva = 0;
    }

    // Add listeners to detect when focus is lost
    _quantiteFocusNode.addListener(() {
      if (!_quantiteFocusNode.hasFocus) {
        _formatQuantite();
        _calculateTotal();
        _scrollToField();
      }
    });

    _priceFocusNode.addListener(() {
      if (!_priceFocusNode.hasFocus) {
        _formatPrice();
        _calculateTotal();
        _scrollToField();
      }
    });

    // Listen for focus changes to scroll into view
    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _scrollToField();
      }
    });
    // Listen for focus changes to scroll into view
    _descFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _scrollToField();
      }
    });
  }

  // Scroll the text field into view
  void _scrollToField() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function to format the quantite field
  void _formatQuantite() {
    if (quantiteController.text.isNotEmpty) {
      final double? value = double.tryParse(quantiteController.text);
      if (value != null) {
        quantiteController.text =
            NumberFormat("#,##0.00", "fr_FR").format(value);
      }
    }
  }

  // Function to format the price field
  void _formatPrice() {
    if (priceController.text.isNotEmpty) {
      final double? value = double.tryParse(priceController.text);
      if (value != null) {
        priceController.text = NumberFormat("#,##0.00", "fr_FR").format(value);
      }
    }
  }

  // Function to calculate total
  void _calculateTotal() {
    double? quantite = double.tryParse(quantiteController.text.replaceAll(',', '.'));
    double? prix = double.tryParse(priceController.text.replaceAll(',', '.'));

    if (quantite != null && prix != null) {
      setState(() {
        // Calculate base total price based on selection
        if (factureController.isPrixHTSelected.value) {
          // Calculate total price including VAT
          _totalPrice = (quantite * prix) + (_selectedTva / 100 * quantite * prix);
        } else if (factureController.isPrixTTCSelected.value) {
          // Calculate total price excluding VAT
          _totalPrice = (quantite * prix);
        }
      });

      itemController.updateTotalPrice(_totalPrice);
    }
  }

  @override
  void dispose() {
    _quantiteFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isLightTheme = themeController.themeMode.value == ThemeMode.light;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Ajouter un article',
        hasLeading: true,
        textLeading: 'Annuler',
        onPressedLeading: () => Get.back(),
      ),
      body: Container(
        width: mq.width,
        height: mq.height,
        color: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05, vertical: mq.height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextField(
                  onChanged: (val) => itemController.updateName(val),
                  title: 'Nom',
                  focusNode: _nameFocusNode,
                  controller: nomController,
                  hint: 'Nom de votre produit ou service',
                ),
                customTextField(
                  onChanged: (val) => itemController.updateDescription(val),
                  title: 'Description (facultatif)',
                  focusNode: _descFocusNode,
                  controller: descriptionController,
                  hint: 'p. ex. origin, composition, dimensiom',
                ),
                // CupertinoPicker for unit selection
                Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.02),
                  child: CustomDropDown(
                    title: 'Unité',
                    selectedValue: _selectedUnit,
                    options: _units,
                    onSelected: (value) {
                      setState(() {
                        _selectedUnit = value;
                      });
                      itemController.updateUnite(_selectedUnit);
                    },
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                    bgColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
                    txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  ),
                ),
                // Price and quantity fields
                Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: customTextField(
                          title: 'Quantité',
                          controller: quantiteController,
                          focusNode: _quantiteFocusNode,
                          hint: '0,00',
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            // Parse the string to double and then to int
                            double? quantityValue = double.tryParse(val.replaceAll(',', '.'));
                            if (quantityValue != null) {
                              itemController.updateQuantity(
                                  quantityValue.toInt()); // Update as int
                              _calculateTotal();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
                        child: boldText(text: 'x', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
                      ),
                      Expanded(
                        flex: 2,
                        child: customTextField(
                          onChanged: (val) {
                            // Parse the string to double
                            double? priceValue =
                                double.tryParse(val.replaceAll(',', '.'));
                            if (priceValue != null) {
                              itemController.updatePrice(priceValue); // Update as double
                              _calculateTotal();
                            }
                          },
                          title: 'Prix (dont taxes)',
                          controller: priceController,
                          hint: '0,00',
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                        ),
                      ),
                    ],
                  ),
                ),
                // CupertinoPicker for tva selection
                Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.02, bottom: mq.height * 0.05),
                  child: CustomDropDown(
                    title: 'TVA',
                    selectedValue: '$_selectedTva %',
                    options: _tva.map((t) => '$t %').toList(),
                    onSelected: (value) {
                      setState(() {
                        _selectedTva = double.parse(value.replaceAll('%', '').trim());
                      });
                      itemController.updateTva(_selectedTva.toInt());
                      _calculateTotal();
                    },
                    color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor,
                    bgColor: isLightTheme ? ColorsTheme.whiteColor : ColorsTheme.blackColor,
                    txtColor: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.whiteColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      boldText(text: 'Montant total', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor),
                      boldText(text: '${_totalPrice.toStringAsFixed(2)} €', color: isLightTheme ? ColorsTheme.blackColor : ColorsTheme.orangeColor)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: isLightTheme? ColorsTheme.whiteColor : ColorsTheme.blackColor,
        child: bottomButtonInScreen(
          text: 'Terminé',
          horizontal: mq.width * 0.05,
          top: mq.height * 0.01,
          bottom: mq.height * 0.05,
          bgColor: isLightTheme ? ColorsTheme.blueColor : ColorsTheme.orangeColor,
          onPressed: () {
            log("${widget.index}");
            // Ensure all necessary fields are filled
            if (nomController.text.isEmpty || quantiteController.text.isEmpty || priceController.text.isEmpty) {
              Get.snackbar("Erreur", "Veuillez remplir tous les champs obligatoires.");
              return;
            }

            // Check if we are editing an existing item or creating a new one
            if (widget.item != null && widget.index!= null) {
              // Update the existing item
              final updatedItem = ItemsModel(
                id: widget.item!.id, // Use the existing item's ID
                name: nomController.text,
                description: descriptionController.text,
                quantity: int.tryParse(quantiteController.text.replaceAll(',', '.')) ?? 0,
                unite: _selectedUnit,
                price: double.tryParse(priceController.text.replaceAll(',', '.')) ?? 0.0,
                tva: _selectedTva.toInt(),
                totalPrice: _totalPrice,
              );

              factureController.updateItem(widget.item!.id, updatedItem);

              itemController.updateItem(updatedItem); // Call updateItem in the controller

              // Print the new item details for debugging
              log('Updated Item Details:');
              log('ID: ${updatedItem.id}');
              log('Name: ${updatedItem.name}');
              log('Description: ${updatedItem.description}');
              log('Quantity: ${updatedItem.quantity}');
              log('Unit: ${updatedItem.unite}');
              log('Price: ${updatedItem.price}');
              log('TVA: ${updatedItem.tva}');
              log('Total Price: ${updatedItem.totalPrice}');
            } else {
              // Creating a new item
              ItemsModel item = itemController.createItem();

              // Add the item to the facture
              FactureController factureController = Get.find<FactureController>();
              factureController.addItem(item);
              itemController.updateItem(item);

              // Print the new item details for debugging
              log('New Item Details:');
              log('ID: ${item.id}');
              log('Name: ${item.name}');
              log('Description: ${item.description}');
              log('Quantity: ${item.quantity}');
              log('Unit: ${item.unite}');
              log('Price: ${item.price}');
              log('TVA: ${item.tva}');
              log('Total Price: ${item.totalPrice}');
            }

            log(itemController.name.value);
            // Close the screen and show a success message
            Get.back(); // Closes the screen
            Get.snackbar("Succès", widget.item != null ? "Article mis à jour avec succès !" : "Article ajouté avec succès !");
          },
        ),
      ),
    );
  }
}
