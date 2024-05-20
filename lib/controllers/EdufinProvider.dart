// lib/providers/edufin_provider.dart
import 'package:contact_art/controllers/EdufinController.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/models/Edu.dart';

class EdufinProvider with ChangeNotifier {
  EdufinController _controller = EdufinController();
  List<Edu> _questions = [];
  int _selectedIndex = -1;

  EdufinProvider() {
    _questions = _controller.getEduItems();
  }

  List<Edu> get questions => _questions;
  int get selectedIndex => _selectedIndex;

  void togglePanel(int index) {
    if (_selectedIndex == index) {
      _selectedIndex = -1;
    } else {
      _selectedIndex = index;
    }
    notifyListeners();
  }
}
