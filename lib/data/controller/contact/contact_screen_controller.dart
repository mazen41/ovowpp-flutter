import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContactScreenController extends GetxController {
  int selectedSearchItemIndex = 1;
  void changeSearchItem(int index) {
    selectedSearchItemIndex = index;
    update();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  List<Map<String, dynamic>> get contactSearchItemList => [
    {
      'title': 'All',
      'onTap': () => changeSearchItem(0),
      'isSelected': selectedSearchItemIndex == 0, // সহজ করুন
    },
    {'title': 'Customers', 'onTap': () => changeSearchItem(1), 'isSelected': selectedSearchItemIndex == 1},
    {'title': 'Lead', 'onTap': () => changeSearchItem(2), 'isSelected': selectedSearchItemIndex == 2},
    {
      'title': 'Agents',
      'onTap': () => changeSearchItem(3),
      'isSelected': selectedSearchItemIndex == 3, // ✅ Fix: 0 থেকে 2 করুন
    },
  ];

  List<Map<String, dynamic>> contactList = [
    {'name': 'Sarah Johnson', 'category': 'Customer', 'number': '+1 (555) 1234-4567', 'active': '2h ago'},
    {'name': 'Sarah Johnson', 'category': 'Lead', 'number': '+1 (555) 1234-4567', 'active': '2h ago'},
    {'name': 'Sarah Johnson', 'category': 'Agent', 'number': '+1 (555) 1234-4567', 'active': '2h ago'},
  ];
}
