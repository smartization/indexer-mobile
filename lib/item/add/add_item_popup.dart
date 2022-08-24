import 'package:flutter/material.dart';
import 'package:indexer_client/item/add/barcode_input.dart';
import 'package:indexer_client/item/add/description_input.dart';
import 'package:indexer_client/item/add/duedate_input.dart';
import 'package:indexer_client/item/add/name_input.dart';

import '../../api/api_spec.swagger.dart';
import '../item_service.dart';

class AddItemPopup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final ItemService itemService;
  
  AddItemPopup({Key? key, required this.itemService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Item"),
      children: [
        Form(
          key: formKey,
            child: Column(
              children: [
                ItemNameTextInput(
                    controller: nameController
                ),
                ItemDescriptionInput(
                    controller: descriptionController
                ),
                ItemBarcodeInput(
                    controller: barcodeController
                ),
                ItemDueDateInput(
                    controller: dueDateController
                ),
                ElevatedButton(
                    onPressed: () { onSubmit(context); },
                    child: const Text("Submit")
                )
              ],
            )
        )
      ],
    );
  }
  

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final PlaceDTO place = PlaceDTO(
        id: 1,
        name: ""
      );
      final ItemDTO item = ItemDTO(
        id: -1,
        name: nameController.text,
        barcode: barcodeController.text,
        dueDate: DateTime.parse(dueDateController.text),
        description: descriptionController.text,
        barcodeType: ItemDTOBarcodeType.ean,
        storagePlace: place
      );
      try {
        itemService
            .saveItem(item)
            .then((value) => Navigator.pop(context, value));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      }

    }

  }
}