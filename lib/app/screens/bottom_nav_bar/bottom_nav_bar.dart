import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';
import 'package:ovowpp/app/screens/bottom_nav_bar/widget/bottom_nav_item.dart';
import 'package:ovowpp/app/screens/contact/contact_screen.dart';
import 'package:ovowpp/app/screens/dashboard/dashboard_screen.dart';
import 'package:ovowpp/app/screens/menu/menu_screen.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import '../../../core/utils/my_images.dart';
import '../campaigns/campaigns_screen.dart';
import '../chat_home/chat_home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> screens = [];

  int currentIndex = 0;

  void changeScreen(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    screens = [
      DashboardScreen(
        onMenuTap: (navIndex) {
          changeScreen(navIndex);
        },
      ),
      ChatHomeScreen(),
      CampaignsScreen(),
      ContactScreen(),
      MenuScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: WillPopWidget(
        child: Scaffold(
          backgroundColor: MyColor.lightBackground,
          key: _scaffoldKey,
          extendBody: false,
          body: screens[currentIndex],
          bottomNavigationBar: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: MyColor.white,
                  //  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: MyColor.dashboardCardBorder, // shadow color
                      offset: Offset(0, -1), // x=0, y=-4 (top shadow)
                      // blurRadius: 2,
                      // spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomNavItem(
                      onTap: () {
                        changeScreen(0);
                      },
                      iconSize: 20,
                      isSelected: currentIndex == 0,
                      selectedIcon: MyImages.selectedDashboard,
                      unSelectedIcon: MyImages.unSelectedDashboard,
                      title: MyStrings.dashboard,
                    ),
                    BottomNavItem(
                      onTap: () {
                        changeScreen(1);
                      },
                      isSelected: currentIndex == 1,
                      selectedIcon: MyImages.selectedChat,
                      unSelectedIcon: MyImages.unSelectedChat,
                      title: MyStrings.chats,
                    ),
                    BottomNavItem(
                      onTap: () {
                        // if (MyUtils.checkPermission(AppPermission.viewCampaign)) {
                        changeScreen(2);
                        //  } else {
                        //  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                        //  }
                      },
                      isSelected: currentIndex == 2,
                      selectedIcon: MyImages.selectedCampaigns,
                      unSelectedIcon: MyImages.unSelectedCampaigns,
                      title: MyStrings.campaign,
                    ),
                    BottomNavItem(
                      onTap: () {
                        //   if (MyUtils.checkPermission(AppPermission.viewContact)) {
                        changeScreen(3);
                        //   } else {
                        //  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                        //  }
                      },
                      isSelected: currentIndex == 3,
                      selectedIcon: MyImages.selectedContact,
                      unSelectedIcon: MyImages.unSelectedContact,
                      title: MyStrings.contacts,
                    ),
                    BottomNavItem(
                      onTap: () {
                        changeScreen(4);
                      },
                      isSelected: currentIndex == 4,
                      selectedIcon: MyImages.selectedAccount,
                      unSelectedIcon: MyImages.unSelectedAccount,
                      title: MyStrings.account,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
