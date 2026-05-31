import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:ovowpp/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/data/controller/controller/country_countrolelr.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';

import '../../../../core/utils/util_exporter.dart';

class CountryBottomSheet {
  static void countryBottomSheet(BuildContext context, {required void Function(Countries data) onSelectedData}) {
    CountryController countryController = CountryController();
    countryController.initialize(); // Load country data
    ThemeData theme = Theme.of(context);
    CustomBottomSheetPlus(
      bgColor: theme.cardColor,
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const BottomSheetBar(),
                const SizedBox(height: 15),
                TextField(
                  controller: countryController.searchController,
                  onChanged: (query) {
                    setState(() {
                      countryController.filterCountries(query);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: MyStrings.searchCountry.tr,
                    prefixIcon: Icon(Icons.search, color: MyColor.getBodyTextColor()),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColor.getPrimaryColor())),
                  ),
                  cursorColor: MyColor.getBodyTextColor(),
                ),
                spaceDown(Dimensions.space24),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: countryController.filteredCountries.length,
                    itemBuilder: (context, index) {
                      var countryItem = countryController.filteredCountries[index];

                      return GestureDetector(
                        onTap: () {
                          countryController.updateMobileCode(countryItem.dialCode!);
                          countryController.selectCountryData(countryItem);

                          onSelectedData(countryItem);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          // margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.transparent,
                            border: Border(bottom: BorderSide(color: MyColor.getBorderColor(), width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                                child: MyNetworkImageWidget(
                                  imageUrl: UrlContainer.countryFlagImageLink.replaceAll(
                                    "{countryCode}",
                                    countryItem.countryCode!.toLowerCase(),
                                  ),
                                  height: Dimensions.space25,
                                  width: Dimensions.space40 + 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                                child: Text('+${countryItem.dialCode}', style: theme.textTheme.bodyLarge?.copyWith()),
                              ),
                              Expanded(
                                child: Text('${countryItem.country}', style: theme.textTheme.bodyMedium?.copyWith()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).show(context);
  }
}
