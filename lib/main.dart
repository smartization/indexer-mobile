import 'package:flutter/material.dart';
import 'package:indexer_client/common/firebase.dart';
import 'package:indexer_client/common/loading_indicator.dart';
import 'package:indexer_client/item/item_main.dart';
import 'package:indexer_client/settings/settings_main.dart';
import 'package:indexer_client/state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseIntegration.init();
  runApp(ChangeNotifierProvider(
    create: (ctx) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  late Future<SharedPreferences> _preferences;
  
  MyApp({Key? key}) : super(key: key) {
    _preferences = SharedPreferences.getInstance();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indexer',
        theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromARGB(255, 238, 154, 2),
              secondary: Color.fromARGB(255, 119, 84, 71),
              tertiary: Color.fromARGB(255, 182, 108, 0),
              background: Colors.grey.shade50,
            ),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.grey.shade800)),
        home: FutureBuilder(
          builder: builder,
          future: _preferences,
        ));
  }

  Widget builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return _loadPreferencesAndShow(snapshot.data, context);
    } else if (snapshot.hasError) {
      return _showError(snapshot.error);
    } else {
      return _showLoader();
    }
  }

  Widget _loadPreferencesAndShow(SharedPreferences data, BuildContext context) {
    Provider.of<AppState>(context).serverAddress = data.getString(SettingsKeys.serverAddress.name);
    return const ItemMain();
  }

  Widget _showError(Object? error) {
    return Text("Cannot load settings $error");
  }

  Widget _showLoader() {
    return const LoadingIndicator(title: "Loading settings");
  }
}
