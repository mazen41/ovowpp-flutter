import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:ovowpp/data/controller/my_account/my_account_controller.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';

import '../../core/utils/text_style.dart';
import '../../core/utils/util_exporter.dart';

class TagSelector extends StatefulWidget {
  final List<AllContacts> tags;
  final bool isContact;
  const TagSelector({super.key, required this.tags, this.isContact = false});

  @override
  TagSelectorState createState() => TagSelectorState();
}

class TagSelectorState extends State<TagSelector> {
  final MultiSelectController<AllContacts> _controller = MultiSelectController<AllContacts>();
  final controller = Get.put(MyAccountController(myAccountRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    final dropdownItems = widget.tags
        .map((tag) => DropdownItem<AllContacts>(value: tag, label: tag.name ?? ""))
        .toList();

    _controller.setItems(dropdownItems);
    final preselectedItems = <DropdownItem<AllContacts>>[];

    for (String selectedTagId in widget.isContact ? controller.selectedContactList : controller.selectedTags) {
      AllContacts? matchingTag;
      try {
        matchingTag = widget.tags.firstWhere((tag) => tag.id.toString() == selectedTagId);
      } catch (e) {
        continue;
      }

      DropdownItem<AllContacts>? matchingItem;
      try {
        matchingItem = dropdownItems.firstWhere((item) => item.value.id == matchingTag!.id);
      } catch (e) {
        continue;
      }

      preselectedItems.add(matchingItem);
    }

    // Set preselected items using selectWhere method
    if (preselectedItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.selectWhere((item) {
          return preselectedItems.any((preselected) => preselected.value.id == item.value.id);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<AllContacts>(
      items: widget.tags.map((tag) => DropdownItem<AllContacts>(value: tag, label: tag.name ?? "")).toList(),
      controller: _controller,
      enabled: true,
      searchEnabled: true,
      searchDecoration: SearchFieldDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyColor.black)),
        border: OutlineInputBorder(borderSide: BorderSide(color: MyColor.black)),
      ),
      chipDecoration: ChipDecoration(
        backgroundColor: MyColor.lightPrimary.withValues(alpha: .2),
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: widget.isContact ? MyStrings.selectContact.tr : MyStrings.selectTags.tr,
        hintStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          borderSide: BorderSide(color: MyColor.socialContainerBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          borderSide: BorderSide(color: MyColor.socialContainerBorder),
        ),
      ),
      dropdownDecoration: DropdownDecoration(
        marginTop: 5,
        maxHeight: 800,
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            widget.isContact ? MyStrings.selectContactFromTheList.tr : MyStrings.selectTagsFromTheList.tr,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedIcon: Icon(Icons.check_box, color: MyColor.getPrimaryColor()),
        disabledIcon: Icon(Icons.lock, color: MyColor.getHeadingTextColor()),
      ),
      onSelectionChange: (selectedItems) {
        widget.isContact ? controller.selectedContactList : controller.selectedTags
          ..clear()
          ..addAll(selectedItems.map((e) => e.id.toString()));
      },
    );
  }
}
