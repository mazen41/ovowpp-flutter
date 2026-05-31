import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class LanguageShimmer extends StatefulWidget {
  const LanguageShimmer({super.key});

  @override
  State<LanguageShimmer> createState() => _LanguageShimmerState();
}

class _LanguageShimmerState extends State<LanguageShimmer> {
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      showAppBar: false,
      padding: EdgeInsets.all(0),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return MyShimmerWidget(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
