import 'package:flutter/material.dart';
import 'package:indexer_client/common/firebase.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/item_main.dart';
import 'package:indexer_client/item/item_service.dart';
import 'package:indexer_client/settings/settings_main.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseIntegration.init();
  runApp(ChangeNotifierProvider(
    create: (ctx) => AppState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ItemService itemService;
  late Future<SharedPreferences> _preferences;

  MyAppState() {
    _preferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Indexer',
        theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 238, 154, 2),
              secondary: const Color.fromARGB(255, 119, 84, 71),
              tertiary: const Color.fromARGB(255, 182, 108, 0),
              background: Colors.grey.shade50,
            ),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.grey.shade800)),
        home: _DataLoader(
          preferencesFuture: _preferences,
        ));
  }
}

class _DataLoader extends StatefulWidget {
  final Future<SharedPreferences> preferencesFuture;

  const _DataLoader({super.key, required this.preferencesFuture});

  @override
  State<StatefulWidget> createState() => _DataLoaderState(preferencesFuture);
}

class _DataLoaderState extends State<_DataLoader> {
  final Future<SharedPreferences> preferencesFuture;

  bool _isLoadingPreferences;
  bool _isLoadingItems;

  _DataLoaderState(this.preferencesFuture)
      : _isLoadingItems = true,
        _isLoadingPreferences = true;

  @override
  void initState() {
    super.initState();
    preferencesFuture.then((value) {
      _setPreferences(value);
      _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences) {
      return const LoadingIndicator(title: "Loading settings");
    } else if (_isLoadingItems) {
      return const LoadingIndicator(title: "Loading items");
    } else {
      return const ItemMain();
    }
  }

  void _loadItems() {
    if (Provider.of<AppState>(context, listen: false).serverAddress == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => SettingsMain()));
      ScaffoldMessenger.of(context)
          .showSnackBar(createSnackbar("No server address provided"));
    } else {
      ItemService.getInstance(context)
          .loadAllItemsToState()
          .then((value) => setState(() {
                _isLoadingItems = false;
              }))
          .onError((error, stackTrace) {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => SettingsMain()));
        ScaffoldMessenger.of(context)
            .showSnackBar(createSnackbar(error.toString()));
      });
    }
  }

  void _setPreferences(SharedPreferences value) {
    Provider.of<AppState>(context, listen: false)
        .updateServerAddress(value.getString(SettingsKeys.serverAddress.name));
    setState(() => _isLoadingPreferences = false);
  }

  SnackBar createSnackbar(String reason) {
    return SnackBar(content: Text(reason));
  }
}
