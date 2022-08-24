import 'package:flutter/material.dart';
import 'package:indexer_client/place/place_service.dart';

import '../../api/api_spec.swagger.dart';
import 'name_input.dart';

class AddPlacePopup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final PlaceService placeService;

  AddPlacePopup({Key? key, required this.placeService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Add Item"),
      children: [
        Form(
            key: formKey,
            child: Column(
              children: [
                PlaceNameTextInput(controller: nameController),
                ElevatedButton(
                    onPressed: () {
                      onSubmit(context);
                    },
                    child: const Text("Submit"))
              ],
            ))
      ],
    );
  }

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final PlaceDTO place = PlaceDTO(name: nameController.text);
      try {
        placeService.save(place).then((value) => Navigator.pop(context, value));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      }
    }
  }
}
