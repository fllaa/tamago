import 'package:flutter/foundation.dart';

/// A singleton notifier that tracks whether the home tab is currently visible
/// This is used to pause/resume auto-scroll functionality in the hero banner
class TabVisibilityNotifier extends ChangeNotifier {
  static final TabVisibilityNotifier _instance = TabVisibilityNotifier._internal();
  
  factory TabVisibilityNotifier() {
    return _instance;
  }
  
  TabVisibilityNotifier._internal();
  
  bool _isHomeTabVisible = true;
  
  bool get isHomeTabVisible => _isHomeTabVisible;
  
  void setHomeTabVisibility(bool isVisible) {
    if (_isHomeTabVisible != isVisible) {
      _isHomeTabVisible = isVisible;
      notifyListeners();
    }
  }
}