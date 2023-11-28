import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/theme/colors.dart';

class ProductDetailChildren extends StatelessWidget {
  final List<ProductDetail>? detailOnTraceabilityTop;
  final List<ProductDetail>? detailOnTraceabilityButtom;
  final List<ProductDetail>? detailOnTraceTop;
  final List<ProductDetail>? detailOnTraceButtom;
  final List<ProductDetail>? detailOnChildTop;
  final List<ProductDetail>? detailOnChildButtom;
  final String? productType;

  const ProductDetailChildren(
      {super.key,
      this.detailOnTraceabilityTop,
      this.detailOnTraceabilityButtom,
      this.detailOnTraceTop,
      this.detailOnTraceButtom,
      this.detailOnChildTop,
      this.detailOnChildButtom,
      this.productType});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: detailOnTraceabilityTop!.isNotEmpty ||
                  detailOnTraceabilityButtom!.isNotEmpty,
              child: Column(
                children: [
                  Text(
                    'Display Attributes on Main Traceability${(productType != Constant.productItem) ? ' (Parent Item)' : ''}',
                    style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: detailOnTraceabilityTop!.length < 3
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: detailOnTraceabilityTop != null &&
                            detailOnTraceabilityTop!.isNotEmpty
                        ? detailOnTraceabilityTop!.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CardDetailProduct(
                                  labelName: e.labelName, attrCd: e.attrCd),
                            );
                          }).toList()
                        : [Container()],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: detailOnTraceabilityButtom!.length < 3
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: detailOnTraceabilityButtom != null &&
                            detailOnTraceabilityButtom!.isNotEmpty
                        ? detailOnTraceabilityButtom!.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CardDetailProduct(
                                  labelName: e.labelName, attrCd: e.attrCd),
                            );
                          }).toList()
                        : [Container()],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: detailOnTraceTop!.isNotEmpty ||
                  detailOnTraceButtom!.isNotEmpty,
              child: Column(
                children: [
                  Text(
                    'Display Attributes on Trace${(productType != Constant.productItem) ? ' (Parent Item)' : ''}',
                    style: TextStyle(
                        color: sccBlack,
                        fontSize: context.scaleFont(18),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: detailOnTraceTop!.length < 3
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children:
                        detailOnTraceTop != null && detailOnTraceTop!.isNotEmpty
                            ? detailOnTraceTop!.map((e) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: CardDetailProduct(
                                      labelName: e.labelName, attrCd: e.attrCd),
                                );
                              }).toList()
                            : [Container()],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: detailOnTraceButtom!.length < 3
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: detailOnTraceButtom != null &&
                            detailOnTraceButtom!.isNotEmpty
                        ? detailOnTraceButtom!.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CardDetailProduct(
                                  labelName: e.labelName, attrCd: e.attrCd),
                            );
                          }).toList()
                        : [Container()],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: productType != Constant.productItem &&
                  (detailOnChildTop!.isNotEmpty ||
                      detailOnChildButtom!.isNotEmpty),
              child: SizedBox(
                child: Column(
                  children: [
                    Text(
                      'Display Attributes on Trace (Child Item)',
                      style: TextStyle(
                          color: sccBlack,
                          fontSize: context.scaleFont(18),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: detailOnChildTop!.length < 3
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: detailOnChildTop != null &&
                              detailOnChildTop!.isNotEmpty
                          ? detailOnChildTop!.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: CardDetailProduct(
                                    labelName: e.labelName, attrCd: e.attrCd),
                              );
                            }).toList()
                          : [Container()],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: detailOnChildButtom!.length < 3
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: detailOnChildButtom != null &&
                              detailOnChildButtom!.isNotEmpty
                          ? detailOnChildButtom!.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: CardDetailProduct(
                                    labelName: e.labelName, attrCd: e.attrCd),
                              );
                            }).toList()
                          : [Container()],
                    ),
                  ],
                ),
              ),
            ),

            // const SizedBox(
            //   height: 30,
            // ),
          ],
        ),
      ),
    );
  }
}

class CardDetailProduct extends StatefulWidget {
  final String? labelName;
  final String? attrCd;
  const CardDetailProduct({super.key, this.labelName, this.attrCd});

  @override
  State<CardDetailProduct> createState() => _CardDetailProductState();
}

class _CardDetailProductState extends State<CardDetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: sccBackground,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          width: 0.2,
        ),
      ),
      width: context.isFullScreen()
          ? context.deviceWidth() * 0.18
          : context.deviceWidth() * 0.15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: TextStyle(
                color: sccBlack,
                fontSize: context.dynamicFont(12),
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            widget.labelName ?? "_",
            style: TextStyle(
                color: sccBlack,
                fontSize: context.dynamicFont(14),
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            'Value',
            style: TextStyle(
                color: sccBlack,
                fontSize: context.dynamicFont(12),
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            widget.attrCd ?? "-",
            style: TextStyle(
                color: sccBlack,
                fontSize: context.dynamicFont(14),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
