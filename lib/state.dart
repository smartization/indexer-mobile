import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String? serverAddress;
  
  void updateServerAddress(String serverAddress) {
    this.serverAddress = serverAddress;
    notifyListeners();
  }
}