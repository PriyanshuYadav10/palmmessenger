import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../config/theme/app_themes.dart';
import '../data/model/contacts_user_model.dart';
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
  ContactsUserModel? mainContacts;
  bool _isLoadingContacts = false;

  List<Contact>? get contacts => _contacts;
  ContactsUserModel? get contact => mainContacts;
  bool get isLoadingContacts => _isLoadingContacts;

  // Page Index Update
  void updateIndex(int pageIndex) {
    _selectedPageIndex = pageIndex;
    notifyListeners();
  }
  List<String> getCommaSeparatedContactNumbers() {
    if (_contacts == null) return [];

    final numbers = <String>{}; // use a set to avoid duplicates

    for (final contact in _contacts!) {
      for (final phone in contact.phones) {
        final number = phone.number.replaceAll(RegExp(r'\D'), ''); // remove non-digits
        if (number.length >= 10) {
          final cleaned = number.substring(number.length - 10); // get last 10 digits
          numbers.add("+91$cleaned"); // add +91 prefix
        }
      }
    }

    return numbers.toList();
  }
  Future<void> fetchContactsAndSend() async {
    await loadContacts();

    final contactNumbers = getCommaSeparatedContactNumbers();
    List<String> phoneList = [];
    if (_contacts != null) {
      for (final contact in _contacts!) {
        for (final phone in contact.phones) {
          final cleanNumber = phone.number
              .replaceAll(RegExp(r'\s|-'), '')
              .replaceAll('+91', '')
              .trim();

          if (cleanNumber.length >= 10) {
            phoneList.add(cleanNumber);
          }
        }
      }
    }
    Map<String, dynamic> param = {
      "phoneNumbers": phoneList
    };
    print('param --> $param');
    await contactListUser(param);
  }
  bool _isLoading = false;
  String _message = '';
  Future<void> contactListUser(Map<String, dynamic> param) async {
    _isLoading = true;
    print('_isLoading   $_isLoading');
    _message = '';
    notifyListeners();
    try {
      final model = await homeRepo.contactListRepo(param);

      _isLoading = false;
      if (model != null) {
        mainContacts = model;
      } else {
        _message = "Failed to generate public key.";
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
    }

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
