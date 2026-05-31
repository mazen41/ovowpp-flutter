import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class UserDataSection extends StatelessWidget {
  final String image;
  final String name;
  final String imagePath;
  const UserDataSection({super.key, required this.image, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return image != ""
        ? CircleAvatar(maxRadius: 21, backgroundImage: NetworkImage("${UrlContainer.domainUrl}/$imagePath/$image"))
        : AlphabetAvatar(firstname: name.toString());
  }
}
