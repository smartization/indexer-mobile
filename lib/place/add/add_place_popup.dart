import 'package:flutter/material.dart';
import 'package:indexer_client/place/place_service.dart';

import '../../api/api_spec.swagger.dart';
import '../../common/exceptions/exception_resolver.dart';
import 'name_input.dart';

class AddPlacePopup extends StatefulWidget {
  final PlaceService placeService;
  final bool addNew;
  final ExceptionResolver exceptionResolver;
  final PlaceDTO? place;

  const AddPlacePopup(
      {Key? key,
      required this.placeService,
      required this.exceptionResolver,
      required this.addNew,
      this.place})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPlacePopupState(
      placeService: placeService,
      exceptionResolver: exceptionResolver,
      addNew: addNew,
      place: place);
}

class _AddPlacePopupState extends State<AddPlacePopup> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: "place");
  final PlaceService placeService;
  final ExceptionResolver exceptionResolver;
  final bool addNew;
  final PlaceDTO? place;

  _AddPlacePopupState(
      {Key? key,
      required this.placeService,
      required this.exceptionResolver,
      required this.addNew,
      this.place});

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
                children: [
                  PlaceNameTextInput(controller: nameController),
                  ElevatedButton(
                      onPressed: () {
                        onSubmit(context);
                      },
                      child: const Text("Submit"))
                ],
              )),
        )
      ],
    );
  }

  void onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      num id = -1;
      if (this.place != null) {
        id = this.place!.id!;
      }
      final PlaceDTO place = PlaceDTO(id: id, name: nameController.text);
      try {
        if (addNew) {
          placeService
              .save(place)
              .then((value) => Navigator.pop(context, value));
        } else {
          placeService
              .update(place)
              .then((value) => Navigator.pop(context, value));
        }
      } on Exception catch (e) {
        exceptionResolver.resolveAndShow(e);
        Navigator.pop(context);
      }
    }
  }
}
