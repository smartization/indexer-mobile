import 'package:flutter/material.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/place/place_service.dart';

import '../../api/api_spec.swagger.dart';

class ItemPlaceInput extends StatefulWidget {
  final PlaceDTO? value;
  final Function(PlaceDTO?) onChanged;

  const ItemPlaceInput({Key? key, required this.onChanged, this.value})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ItemPlaceInputState(onChanged: onChanged, value: value);
}

class _ItemPlaceInputState extends State<ItemPlaceInput> {
  PlaceDTO? value;
  Function(PlaceDTO?) onChanged;
  late Future<List<PlaceDTO>> _places;
  late PlaceService _placeService;

  _ItemPlaceInputState({required this.onChanged, this.value});

  @override
  void initState() {
    super.initState();
    _placeService = PlaceService(context: context);
    _places = _placeService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _places, builder: builder);
  }

  Widget builder(BuildContext context, AsyncSnapshot<List<PlaceDTO>> snapshot) {
    if (snapshot.hasData) {
      List<DropdownMenuItem<PlaceDTO>> dropdownItems = snapshot.data!
          .map((e) => DropdownMenuItem<PlaceDTO>(value: e, child: Text(e.name)))
          .toList();
      return DropdownButtonFormField<PlaceDTO?>(
        value: value,
        items: dropdownItems,
        onChanged: onChanged,
      );
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    } else {
      return const LoadingIndicator(title: "Downloading places");
    }
  }
}
