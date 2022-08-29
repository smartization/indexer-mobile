import 'dart:async';

import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/place/add/add_place_popup.dart';
import 'package:indexer_client/place/place_expansion_list.dart';
import 'package:indexer_client/place/place_service.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';

import '../api/api_spec.swagger.dart';
import '../common/exceptions/ApiException.dart';
import '../drawer/drawer.dart';

class PlaceMain extends StatefulWidget {
  const PlaceMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaceMainState();
}

class _PlaceMainState extends State<PlaceMain> {
  late Future<List<PlaceDTO>> _placesFuture;
  late PlaceService _placeService;
  late ExceptionResolver _exceptionResolver;
  List<bool>? _expanded;
  List<PlaceDTO>? _places;

  @override
  void initState() {
    super.initState();
    _exceptionResolver = ExceptionResolver(context: context);
    _placeService = PlaceService(context: context);
    _placesFuture = _placeService.getAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppState>(context).addListener(() {
      setState(() {
        _placesFuture = _placeService.getAll();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Places"),
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: futureBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddButtonPressed,
        tooltip: 'Add Place',
        child: const Icon(Icons.add),
      ),
      drawer: const CommonDrawer(),
    );
  }

  Widget futureBuilder(
      BuildContext context, AsyncSnapshot<List<PlaceDTO>> snapshot) {
    if (snapshot.hasData) {
      _places = snapshot.data!;
      _expanded ??= List.filled(_places!.length, false, growable: true);
      return PlaceExpansionList(
        places: _places,
        onPlaceDelete: onPlaceDelete,
        onExpanded: onExpanded,
        expandedList: _expanded,
      );
    } else if (snapshot.hasError) {
      return Text("Error: ${snapshot.error.toString()}");
    } else {
      return const LoadingIndicator(title: "Loading places");
    }
  }

  void onExpanded(int panelIndex, bool isExpanded) {
    setState(() => {_expanded![panelIndex] = !isExpanded});
  }

  void onAddButtonPressed() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saving")));
    Future<PlaceDTO?> createdPlace = showDialog<PlaceDTO>(
      context: context,
      builder: (context) {
        return AddPlacePopup(
          placeService: _placeService,
          exceptionResolver: _exceptionResolver,
        );
      },
    );
    createdPlace.then((value) {
      setState(() {
        if (value != null) _places!.add(value);
        // this will be processed by FutureBuilder so UI can be drawn
        _placesFuture = Future.value(_places);
        // if some new item was added then it is as last item on list
        // add it to _expanded register
        if (_expanded!.length != _places!.length) {
          _expanded!.addAll(
              List.filled((_places!.length - _expanded!.length).abs(), false));
        }
      });
    });
  }

  onPlaceDelete(PlaceDTO place) {
    _placeService.delete(place).then((value) {
      int idx = _places!.indexOf(place);
      if (idx >= 0) {
        setState(() {
          _places!.remove(place);
          _expanded!.removeAt(idx);
        });
      }
    }).catchError((error, stackTrace) {
      _exceptionResolver.resolveAndShow(error);
    }, test: (o) => o is ApiException);
  }
}
