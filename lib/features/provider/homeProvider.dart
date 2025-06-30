import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../config/theme/app_themes.dart';
import '../data/repository/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepo homeRepo;

  HomeProvider({required this.homeRepo});

  // Theme & Page Index Handling
  Color appBarColor = ColorResources.appColor;
  int _selectedPageIndex = 0;
  int _afterLoginPageIndex = 0;
  int _selectedMobilePageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;
  int get afterLoginPageIndex => _afterLoginPageIndex;
  int get selectedMobilePageIndex => _selectedMobilePageIndex;

  // Contact Handling
  List<Contact>? _contacts;
  bool _isLoadingContacts = false;

  List<Contact>? get contacts => _contacts;
  bool get isLoadingContacts => _isLoadingContacts;

  // Page Index Update
  void updateIndex(int pageIndex) {
    _selectedPageIndex = pageIndex;
    notifyListeners();
  }


  // Fetch Contacts with Permission Handling
  Future<void> loadContacts() async {
    _isLoadingContacts = true;
    notifyListeners();

    try {
      if (await FlutterContacts.requestPermission()) {
        _contacts = await FlutterContacts.getContacts(withProperties: true);
      } else {
        _contacts = [];
      }
    } catch (e) {
      print("Failed to load contacts: $e");
      _contacts = [];
    }

    _isLoadingContacts = false;
    notifyListeners();
  }
}
