import 'package:flutter/material.dart';
import 'package:indexer_client/item/add/barcode_input.dart';
import 'package:indexer_client/item/add/description_input.dart';
import 'package:indexer_client/item/add/duedate_input.dart';
import 'package:indexer_client/item/add/name_input.dart';
import 'package:indexer_client/item/add/place_input.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/ApiException.dart';
import '../barcode_service.dart';
import '../item_service.dart';

class ModifyItemPopup extends StatefulWidget {
  final bool addNew;
  final ItemService itemService;
  final BarcodeService barcodeService;
  final ItemDTO? item;

  const ModifyItemPopup(
      {Key? key,
      required this.itemService,
      required this.barcodeService,
      required this.addNew,
      this.item})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyItemPopupState(
      itemService: itemService,
      barcodeService: barcodeService,
      addNew: addNew,
      item: item);
}

class _ModifyItemPopupState extends State<ModifyItemPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final ItemService itemService;
  final BarcodeService barcodeService;
  final bool addNew;
  PlaceDTO? _selectedPlace;
  ItemDTO? item;

  _ModifyItemPopupState(
      {required this.itemService,
      required this.barcodeService,
      required this.addNew,
      this.item});

  @override
  void initState() {
    super.initState();
    if (item != null) {
      setState(() {
        nameController.text = item!.name;
        barcodeController.text = item!.barcode ?? "";
        dueDateController.text = item!.dueDate!.toIso8601String();
        descriptionController.text = item!.description ?? "";
        _selectedPlace = item!.storagePlace;
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemBarcodeInput(controller: barcodeController),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemDueDateInput(controller: dueDateController),
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
                              onPressed: getSuggestion,
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
          dueDate: DateTime.parse(dueDateController.text),
          description: descriptionController.text,
          barcodeType: ItemDTOBarcodeType.ean,
          storagePlace: _selectedPlace);
      if (addNew) {
        itemService
            .saveItem(item)
            .then((value) => Navigator.pop(context, value))
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((error as ApiException).reason)));
        }, test: (o) => o is ApiException);
      } else {
        itemService
            .updateItem(item)
            .then((value) => Navigator.pop(context, value))
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((error as ApiException).reason)));
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
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Exception ${e.toString()}")));
      }
    }
  }
}