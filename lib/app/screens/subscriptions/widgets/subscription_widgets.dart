import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class SubscriptionTopTabBar extends StatelessWidget {
  final List<String> tabs;

  const SubscriptionTopTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.maybeOf(context);

    if (controller == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SizedBox(
          height: 46.h,
          child: TabBar(
            isScrollable: false,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            splashBorderRadius: BorderRadius.circular(Dimensions.space50.r),
            tabs: List.generate(
              tabs.length,
              (index) => Padding(
                padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : Dimensions.space8.w),
                child: _TabChip(title: tabs[index], isSelected: controller.index == index),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _TabChip({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? MyColor.getPrimaryColor() : MyColor.searchItemBgColor,
        borderRadius: BorderRadius.circular(Dimensions.space50.r),
        border: Border.all(color: isSelected ? Colors.transparent : MyColor.dashboardCardBorder),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space8.w),
        child: Text(
          title.tr,
          textAlign: TextAlign.center,
          style: MyTextStyle.heading12W600().copyWith(
            color: isSelected ? MyColor.white : MyColor.fieldTitleTextColor,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}

class SubscriptionHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SubscriptionHeaderButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColor.searchItemBgColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 40.w,
          width: 40.w,
          child: Icon(icon, size: 18.sp, color: MyColor.regularHederColor),
        ),
      ),
    );
  }
}

class SubscriptionSectionEyebrow extends StatelessWidget {
  final String text;

  const SubscriptionSectionEyebrow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr.toUpperCase(),
      style: MyTextStyle.heading12W600().copyWith(color: MyColor.customerText, letterSpacing: 1),
    );
  }
}

class SubscriptionInlineSwitch extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final int? accentIndex;
  final ValueChanged<int>? onChanged;

  const SubscriptionInlineSwitch({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.accentIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.space4.r),
      decoration: BoxDecoration(
        color: MyColor.searchItemBgColor,
        borderRadius: BorderRadius.circular(Dimensions.space50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
          (index) => GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(index),
            child: Container(
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : Dimensions.space4.w),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space14.w, vertical: Dimensions.space8.h),
              decoration: BoxDecoration(
                color: selectedIndex == index ? MyColor.white : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.space50.r),
              ),
              child: Text(
                items[index].tr,
                style: MyTextStyle.heading12W600().copyWith(
                  color: accentIndex == index ? MyColor.getPrimaryColor() : MyColor.regularHederColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final double radius;

  const SubscriptionSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor = MyColor.white,
    this.radius = Dimensions.space18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(Dimensions.space16.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius.r),
        border: Border.all(color: MyColor.dashboardCardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .03), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }
}

class SubscriptionIconTile extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  SubscriptionIconTile({super.key, required this.icon, this.size = 38, Color? backgroundColor, Color? iconColor})
    : backgroundColor = backgroundColor ?? MyColor.helpCenterItemBgColor,
      iconColor = iconColor ?? MyColor.customerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.w,
      width: size.w,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular((size / 3).r)),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: (size / 2).sp),
    );
  }
}

class SubscriptionPillText extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const SubscriptionPillText({super.key, required this.text, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w, vertical: Dimensions.space6.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(Dimensions.space50.r)),
      child: Text(text.tr, style: MyTextStyle.heading12W600().copyWith(color: textColor)),
    );
  }
}

class SubscriptionFeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isEnabled;

  const SubscriptionFeatureRow({super.key, required this.icon, required this.text, this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isEnabled ? MyColor.customerText : MyColor.updatedTextColor;
    final Color textColor = isEnabled ? MyColor.regularHederColor : MyColor.updatedTextColor;

    return Row(
      children: [
        Icon(icon, size: 17.sp, color: iconColor),
        SizedBox(width: Dimensions.space10.w),
        Expanded(
          child: Text(text.tr, style: MyTextStyle.subHeading14W500().copyWith(color: textColor)),
        ),
      ],
    );
  }
}

class SubscriptionPrimaryButton extends StatelessWidget {
  final String text;
  final bool isMuted;
  final VoidCallback? onTap;

  const SubscriptionPrimaryButton({super.key, required this.text, this.isMuted = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = MyColor.getPrimaryColor();
    final Color foregroundColor = MyColor.white;

    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shadowColor: backgroundColor.withValues(alpha: .2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.space14.r)),
        ),
        child: Text(text.tr, style: MyTextStyle.heading14W600().copyWith(color: foregroundColor)),
      ),
    );
  }
}

class SubscriptionPromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData actionIcon;

  const SubscriptionPromoBanner({super.key, required this.title, required this.subtitle, required this.actionIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w, vertical: Dimensions.space16.h),
      decoration: BoxDecoration(
        color: MyColor.getPrimaryColor(),
        borderRadius: BorderRadius.circular(Dimensions.space18.r),
        boxShadow: [
          BoxShadow(
            color: MyColor.getPrimaryColor().withValues(alpha: .24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.tr, style: MyTextStyle.heading16W600().copyWith(color: MyColor.white)),
                SizedBox(height: Dimensions.space4.h),
                Text(
                  subtitle.tr,
                  style: MyTextStyle.subHeading12W400().copyWith(color: MyColor.white.withValues(alpha: .8)),
                ),
              ],
            ),
          ),
          Container(
            height: 34.w,
            width: 34.w,
            decoration: const BoxDecoration(color: MyColor.white, shape: BoxShape.circle),
            child: Icon(actionIcon, size: 18.sp, color: MyColor.getPrimaryColor()),
          ),
        ],
      ),
    );
  }
}

class SubscriptionDarkPromoCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;
  final String ctaText;

  const SubscriptionDarkPromoCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.ctaText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.space18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF043722),
        borderRadius: BorderRadius.circular(Dimensions.space20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.tr,
            style: MyTextStyle.heading12W600().copyWith(color: const Color(0xFF7AE3B1), letterSpacing: 1.2),
          ),
          SizedBox(height: Dimensions.space10.h),
          Text(
            title.tr,
            style: MyTextStyle.heading20W700().copyWith(color: MyColor.white, fontSize: 28.sp),
          ),
          SizedBox(height: Dimensions.space10.h),
          Text(
            description.tr,
            style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.white.withValues(alpha: .74), height: 1.45),
          ),
          SizedBox(height: Dimensions.space18.h),
          Row(
            children: [
              Text(ctaText.tr, style: MyTextStyle.heading14W600().copyWith(color: MyColor.white)),
              SizedBox(width: Dimensions.space6.w),
              Icon(Icons.arrow_forward_rounded, color: MyColor.white, size: 18.sp),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscriptionMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String trailing;
  final bool isHighlighted;

  const SubscriptionMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.trailing,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = isHighlighted ? MyColor.getPrimaryColor() : MyColor.white;
    final Color titleColor = isHighlighted ? MyColor.white.withValues(alpha: .84) : MyColor.fieldTitleTextColor;
    final Color valueColor = isHighlighted ? MyColor.white : MyColor.regularHederColor;

    return SubscriptionSurfaceCard(
      backgroundColor: background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.tr, style: MyTextStyle.heading12W600().copyWith(color: titleColor)),
          SizedBox(height: Dimensions.space8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: MyTextStyle.heading20W700().copyWith(fontSize: 30.sp, color: valueColor),
                ),
                if (trailing.isNotEmpty)
                  TextSpan(
                    text: trailing,
                    style: MyTextStyle.heading14W600().copyWith(color: valueColor),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
