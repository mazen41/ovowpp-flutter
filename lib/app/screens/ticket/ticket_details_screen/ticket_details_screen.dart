import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/support/ticket_details_controller.dart';
import 'package:ovowpp/data/repo/support/support_repo.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/screens/ticket/ticket_details_screen/sections/message_list_section.dart';
import 'package:ovowpp/app/screens/ticket/ticket_details_screen/sections/reply_section.dart';
import 'package:ovowpp/app/screens/ticket/ticket_details_screen/widget/ticket_status_widget.dart';
import 'package:get/get.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  String title = "";
  @override
  void initState() {
    String ticketId = Get.arguments[0];
    title = Get.arguments[1];

    Get.put(SupportRepo());
    var controller = Get.put(TicketDetailsController(repo: Get.find(), ticketId: ticketId));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => AnnotatedRegionWidget(
        top: true,
        child: MyCustomScaffold(
          pageTitle: MyStrings.replyTicket,
          actionButton: [
            if (controller.model.data?.myTickets?.status != '3')
              Padding(
                padding: const EdgeInsets.only(right: Dimensions.space20),
                child: TextButton(
                  onPressed: () {
                    controller.closeTicket(controller.model.data?.myTickets?.id.toString() ?? '-1');
                  },
                  child: Text(
                    MyStrings.close,
                    style: theme.textTheme.bodyLarge?.copyWith(color: MyColor.getErrorColor()),
                  ),
                ),
              ),
          ],
          body: controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        TicketStatusWidget(controller: controller),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.cardColor),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ReplySection(), MessageListSection()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
