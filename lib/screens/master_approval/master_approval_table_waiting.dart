import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/part_number.dart';
import 'package:scc_web/shared_widgets/paging_display.dart';
import 'package:scc_web/shared_widgets/table_content.dart';
import 'package:scc_web/shared_widgets/vcc_paging_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class MasterApprovalTableWaiting extends StatefulWidget {
  final Function(PartNumberListData) onApprove, onReject, onView;
  final bool canView, canReject, canApprove;
  const MasterApprovalTableWaiting(
      {super.key,
      required this.onApprove,
      required this.onReject,
      required this.onView,
      required this.canView,
      required this.canReject,
      required this.canApprove});

  @override
  State<MasterApprovalTableWaiting> createState() =>
      _MasterApprovalTableWaitingState();
}

class _MasterApprovalTableWaitingState
    extends State<MasterApprovalTableWaiting> {
  Paging paging = Paging(pageNo: 1, pageSize: 5);
  @override
  Widget build(BuildContext context) {
    Widget rowButton() {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.canApprove,
            child: Expanded(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(95, 40),
                  backgroundColor: sccDeliveredText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Approve",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(visible: widget.canApprove, child: const SizedBox(width: 12)),
          Visibility(
            visible: widget.canReject,
            child: Expanded(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(95, 40),
                  backgroundColor: sccButtonCancel,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Reject",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(visible: widget.canReject, child: const SizedBox(width: 12)),
          Expanded(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                minimumSize: const Size(95, 40),
                backgroundColor: sccNavText2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Detail",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMobile ? Colors.transparent : sccWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: isMobile
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(
                  vertical: 16,
                  // horizontal: 24,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Waiting for Approval',
                      style: TextStyle(
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2B2B2B),
                      ),
                    ),
                    PagingDropdown(
                      selected: (paging.pageSize ?? 0).toString(),
                      onSelect: (val) {
                        if (paging.pageSize != val) {
                          setState(() {
                            paging.pageSize = val;
                          });
                          paging.pageNo = paging.pageNo! - 1;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: sccWhite,
                  border: Border(
                    top: BorderSide(color: sccLightGrayDivider, width: 2),
                    bottom: BorderSide(color: sccLightGrayDivider, width: 2),
                  ),
                ),
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 16, top: 8, right: 8),
                      width: 100,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "No",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold,
                          color: sccBlack,
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "Part No",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(16),
                            fontWeight: FontWeight.bold,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "Part Name",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(16),
                            fontWeight: FontWeight.bold,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.15,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "Supplier",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(16),
                            fontWeight: FontWeight.bold,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "Business Process",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: context.scaleFont(16),
                            fontWeight: FontWeight.bold,
                            color: sccBlack,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.canView ||
                          widget.canReject ||
                          widget.canApprove,
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          // width: context.deviceWidth() * 0.25,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Text(
                            "Action",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: context.scaleFont(16),
                              fontWeight: FontWeight.bold,
                              color: sccBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: sccChildTrackFilling,
                  border: Border(
                    bottom: BorderSide(color: sccLightGrayDivider, width: 1),
                  ),
                ),
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 8, left: 16, top: 8, right: 8),
                      width: 100,
                      // width: context.deviceWidth() * 0.05,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "element.no.toString()",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: context.scaleFont(14),
                          color: sccBlack,
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        child: const TableContent(
                          value: "element.partNo",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        child: const TableContent(
                          value: "element.partName",
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.15,
                        child: const TableContent(
                          value: "element.supplierName",
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        // width: context.deviceWidth() * 0.10,
                        child: const TableContent(
                          value: "element.useCaseName",
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.canView ||
                          widget.canApprove ||
                          widget.canReject,
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          // width: context.deviceWidth() * 0.25,
                          child: rowButton(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        SimplePaging(
          onClick: (val) {},
          onClickNext: () {},
          onClickLastPage: () {},
          onClickPrevious: () {},
          onClickFirstPage: () {},
          pageNo: 1,
          pageSize: 10,
          totalPages: 10,
          totalDataInPage: 10,
          pageToDisplay: 5,
          totalData: 100,
        ),
      ],
    );
  }
}
