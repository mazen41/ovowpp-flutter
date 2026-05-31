import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class ContactPickerBottomSheet extends StatefulWidget {
  final Function(Contact) onContactSelected;

  const ContactPickerBottomSheet({super.key, required this.onContactSelected});

  @override
  State<ContactPickerBottomSheet> createState() => _ContactPickerBottomSheetState();
}

class _ContactPickerBottomSheetState extends State<ContactPickerBottomSheet> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndLoadContacts() async {
    final permission = await Permission.contacts.request();

    if (permission.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      await _loadContacts();
    } else {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await FastContacts.getAllContacts();

      final contactsWithPhones = contacts.where((contact) => contact.phones.isNotEmpty).toList();

      contactsWithPhones.sort((a, b) => (a.displayName).toLowerCase().compareTo((b.displayName).toLowerCase()));

      setState(() {
        _contacts = contactsWithPhones;
        _filteredContacts = contactsWithPhones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredContacts = _contacts;
      });
      return;
    }

    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = (contact.displayName).toLowerCase();
        final phones = contact.phones.map((phone) => phone.number.replaceAll(RegExp(r'[^\d+]'), '')).toList();

        if (name.contains(query)) {
          return true;
        }

        for (final phone in phones) {
          if (phone.contains(query.replaceAll(RegExp(r'[^\d+]'), ''))) {
            return true;
          }
        }

        return false;
      }).toList();
    });
  }

  String _formatPhoneNumber(String phoneNumber) {
    try {
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      final parsed = PhoneNumber.parse(cleanNumber);
      return parsed.international;
    } catch (e) {
      return phoneNumber;
    }
  }

  void _onContactTap(Contact contact) {
    if (contact.phones.isNotEmpty) {
      // final phoneNumber = contact.phones.first.number;
      //  final contactName = contact.displayName ;
      widget.onContactSelected(contact);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(MyStrings.selectContact.tr, style: theme.textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                _filterContacts();
              },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or number...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Contacts Permission Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant contacts permission to view your contacts',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _requestPermissionAndLoadContacts, child: const Text('Grant Permission')),
          ],
        ),
      );
    }

    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty ? 'No contacts found' : 'No contacts available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        ThemeData theme = Theme.of(context);
        final contact = _filteredContacts[index];
        final phoneNumber = contact.phones.first.number;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: MyColor.lightInformation.withValues(alpha: .4),
              child: Text(
                (contact.displayName.isNotEmpty == true) ? contact.displayName.substring(0, 1).toUpperCase() : '?',
                style: theme.textTheme.headlineMedium?.copyWith(color: MyColor.lightInformation),
              ),
            ),
            title: Text(
              contact.displayName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: MyColor.getBodyTextColor(),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatPhoneNumber(phoneNumber),
                  style: theme.textTheme.bodyMedium?.copyWith(color: MyColor.getInformationColor()),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: MyColor.lightBodyText),
            onTap: () => _onContactTap(contact),
          ),
        );
      },
    );
  }
}

// Usage example:
class ContactPickerExample extends StatelessWidget {
  const ContactPickerExample({super.key});

  void _showContactPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactPickerBottomSheet(
        onContactSelected: (contact) {
          // Handle selected contact
          final phoneNumber = contact.phones.first.number;
          final name = contact.displayName;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: $name - $phoneNumber')));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Picker Demo')),
      body: Center(
        child: ElevatedButton(onPressed: () => _showContactPicker(context), child: const Text('Select Contact')),
      ),
    );
  }
}
