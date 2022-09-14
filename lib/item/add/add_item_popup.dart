import 'package:flutter/material.dart';
import 'package:indexer_client/item/add/barcode_input.dart';
import 'package:indexer_client/item/add/category_input.dart';
import 'package:indexer_client/item/add/description_input.dart';
import 'package:indexer_client/item/add/duedate_input.dart';
import 'package:indexer_client/item/add/name_input.dart';
import 'package:indexer_client/item/add/place_input.dart';
import 'package:indexer_client/item/add/quantity_input.dart';

import '../../api/api_spec.enums.swagger.dart';
import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/ApiException.dart';
import '../../common/exceptions/exception_resolver.dart';
import '../barcode_service.dart';
import '../item_service.dart';

class ModifyItemPopup extends StatefulWidget {
  final bool addNew;
  final ItemService itemService;
  final BarcodeService barcodeService;
  final ItemDTO? item;
  final ExceptionResolver exceptionResolver;

  const ModifyItemPopup({
    Key? key,
    required this.itemService,
    required this.barcodeService,
    required this.addNew,
    required this.exceptionResolver,
    this.item,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyItemPopupState(
      itemService: itemService,
      barcodeService: barcodeService,
      addNew: addNew,
      exceptionResolver: exceptionResolver,
      item: item);
}

class _ModifyItemPopupState extends State<ModifyItemPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: "item");
  final ItemService itemService;
  final BarcodeService barcodeService;
  final ExceptionResolver exceptionResolver;
  final bool addNew;
  bool suggestionButtonEnabled = false;
  PlaceDTO? _selectedPlace;
  CategoryDTO? _selectedCategory;
  ItemDTO? item;

  _ModifyItemPopupState(
      {required this.itemService,
      required this.barcodeService,
      required this.addNew,
      required this.exceptionResolver,
      this.item});

  @override
  void initState() {
    super.initState();
    if (item != null) {
      setState(() {
        nameController.text = item!.name;
        barcodeController.text = item!.barcode ?? "";
        dueDateController.text =
            item!.dueDate == null ? "" : item!.dueDate!.toIso8601String();
        descriptionController.text = item!.description ?? "";
        _selectedPlace = item!.storagePlace;
        _selectedCategory = item!.category;
        quantityController.text =
            item!.quantity == null ? "" : item!.quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Item"),
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ItemNameTextInput(controller: nameController),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child:
                        ItemDescriptionInput(controller: descriptionController),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemPlaceInput(
                      value: _selectedPlace,
                      onChanged: onPlaceChanged,
                      exceptionResolver: exceptionResolver,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemBarcodeInput(
                      controller: barcodeController,
                      onChecksumValidChange: onChecksumValidChange,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemDueDateInput(
                        controller: dueDateController, addNew: addNew),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemCategoryInput(
                      onChanged: onItemCategoryChanged,
                      exceptionResolver: exceptionResolver,
                      value: _selectedCategory,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemQuantityInput(controller: quantityController),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                              onPressed: () {
                                onSubmit(context);
                              },
                              child: const Text("Submit")),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                              onPressed: suggestionButtonEnabled
                                  ? getSuggestion
                                  : null,
                              child: const Text("Suggest inputs")),
                        )
                      ],
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
  

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      int id = -1;
      if (this.item != null) {
        id = this.item!.id!.toInt();
      }
      final ItemDTO item = ItemDTO(
          id: id,
          name: nameController.text,
          barcode: barcodeController.text,
          dueDate: dueDateController.text.isEmpty
              ? null
              : DateTime.parse(dueDateController.text),
          description: descriptionController.text,
          barcodeType: ItemDTOBarcodeType.ean,
          storagePlace: _selectedPlace,
          category: _selectedCategory,
          quantity: quantityController.text == ""
              ? null
              : int.parse(quantityController.text));
      if (addNew) {
        itemService
            .saveItem(item)
            .then((value) => Navigator.pop(context, value))
            .catchError((error, stackTrace) {
          exceptionResolver.resolveAndShow(error);
        }, test: (o) => o is ApiException);
      } else {
        itemService
            .updateItem(item)
            .then((value) => Navigator.pop(context, value))
            .catchError((error, stackTrace) {
          exceptionResolver.resolveAndShow(error);
        }, test: (o) => o is ApiException);
      }
    }
  }

  onPlaceChanged(PlaceDTO? place) {
    if (place != null) {
      setState(() {
        _selectedPlace = place;
      });
    }
  }

  void getSuggestion() async {
    String barcode = barcodeController.text;
    if (barcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot suggest, barcode is empty")));
    } else {
      try {
        BarcodeDTO barcodeDTO = await barcodeService.getSuggestion(barcode);
        if (barcodeDTO.title != null) {
          nameController.text = barcodeDTO.title!;
        }
        if (barcodeDTO.link != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Data obtained from: ${barcodeDTO.link}")));
        }
      } on Exception catch (e) {
        exceptionResolver.resolveAndShow(e);
      }
    }
  }

  onItemCategoryChanged(CategoryDTO? category) {
    if (category != null) {
      setState(() => _selectedCategory = category);
    }
  }

  onChecksumValidChange(bool isValid) {
    setState(() => suggestionButtonEnabled = isValid);
  }
}