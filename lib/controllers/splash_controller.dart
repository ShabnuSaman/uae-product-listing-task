import 'package:flutter/foundation.dart';

class SplashController extends ChangeNotifier {
  bool _ready = false;
  bool get ready => _ready;

  SplashController() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      _ready = true;
      notifyListeners();
    });
  }
}
