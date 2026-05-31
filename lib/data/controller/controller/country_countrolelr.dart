import 'package:flutter/material.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class CountryController {
  // Country list and filtered list
  List<Countries> countryList = [];
  List<Countries> filteredCountries = [];

  // Text controller for search
  TextEditingController searchController = TextEditingController();

  // Initialize with an empty country list or populate it here.
  void initialize() {
    CountryModel countryModel = SharedPreferenceService.getCountryJsonDataData();
    countryList = countryModel.data?.countries ?? [];
    filteredCountries = List.from(countryList);
  }

  // Filter countries based on search query
  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries = List.from(countryList);
    } else {
      filteredCountries = countryList
          .where((country) => country.country!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Update the dial code or selected country if needed
  void updateMobileCode(String dialCode) {
    // Implement your logic for updating mobile code
  }

  void selectCountryData(Countries selectedCountry) {
    // Implement your logic for selecting country data
  }
}
