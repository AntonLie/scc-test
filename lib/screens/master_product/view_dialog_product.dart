import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_product/bloc/master_product_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/screens/master_product/attribute_detail_view.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogProduct extends StatefulWidget {
  final Function onEdit;
  final bool canUpdate;
  const ViewDialogProduct(
      {super.key, required this.onEdit, required this.canUpdate});

  @override
  State<ViewDialogProduct> createState() => _ViewDialogProductState();
}

class _ViewDialogProductState extends State<ViewDialogProduct> {
  late MasterProductModel? model;
  List<ProductDetail> listProduct = [];
  List<ProductDetail> detailOnTraceabilityTop = [];
  List<ProductDetail> detailOnTraceabilityButtom = [];
  List<ProductDetail> detailOnTraceTop = [];
  List<ProductDetail> detailOnTraceButtom = [];
  List<ProductDetail> detailOnChildTop = [];
  List<ProductDetail> detailOnChildButtom = [];
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MasterProductBloc, MasterProductState>(
      listener: (context, state) {
        if (state is ProductFormLoaded) {
          detailOnTraceabilityTop.clear();
          detailOnTraceabilityButtom.clear();
          detailOnTraceTop.clear();
          detailOnTraceButtom.clear();
          detailOnChildTop.clear();
          detailOnChildButtom.clear();
          model = state.model;
          if (model != null) {
            if (model!.detailOnTraceabilityTop != null) {
              detailOnTraceabilityTop.addAll(model!.detailOnTraceabilityTop!);
            }
            if (model!.detailOnTraceabilityButtom != null) {
              detailOnTraceabilityButtom
                  .addAll(model!.detailOnTraceabilityButtom!);
            }
            if (model!.detailOnTraceTop != null) {
              detailOnTraceTop.addAll(model!.detailOnTraceTop!);
            }
            if (model!.detailOnTraceButtom != null) {
              detailOnTraceButtom.addAll(model!.detailOnTraceButtom!);
            }
            if (model!.detailOnChildTop != null) {
              detailOnChildTop.addAll(model!.detailOnChildTop!);
            }
            if (model!.detailOnChildButtom != null) {
              detailOnChildButtom.addAll(model!.detailOnChildButtom!);
            }
          }
        }
      },
      child: BlocBuilder<MasterProductBloc, MasterProductState>(
        builder: (context, state) {
          if (state is! ProductFormLoaded) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(child: CircularProgressIndicator()));
          } else {
            return Dialog(
              backgroundColor: sccWhite,
              insetPadding: context.isDesktop()
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.19),
                      vertical: (context.deviceHeight() * 0.1),
                    )
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: context.deviceWidth(),
                // height: context.deviceHeight(),
                padding: isMobile
                    ? const EdgeInsets.only(
                        left: 8, right: 8, top: 28, bottom: 12)
                    : const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "View",
                          style: TextStyle(
                            fontSize: context.scaleFont(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.closeDialog();
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            // color: sccRed,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: sccWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                ]),
                            child: HeroIcon(
                              HeroIcons.xMark,
                              color: sccButtonPurple,
                              size: context.scaleFont(28),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: sccLightGrayDivider,
                      height: 25,
                      thickness: 2,
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: false,
                        controller: controller,
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Product Name',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.productName ?? "-",
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.productType ==
                                                  Constant.productItem
                                              ? "ITEM"
                                              : model!.productType ==
                                                      Constant.productParent
                                                  ? "PARENT"
                                                  : "-",
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Product Description',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: context.deviceWidth() * 0.45,
                                          child: Text(
                                            model!.productDesc ?? "-",
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.scaleFont(14),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        // SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ProductDetailChildren(
                                      detailOnTraceabilityTop:
                                          detailOnTraceabilityTop,
                                      detailOnTraceabilityButtom:
                                          detailOnTraceabilityButtom,
                                      detailOnTraceTop: detailOnTraceTop,
                                      detailOnTraceButtom: detailOnTraceButtom,
                                      detailOnChildTop: detailOnChildTop,
                                      detailOnChildButtom: detailOnChildButtom,
                                      productType: model!.productType,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: isMobile
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.canUpdate,
                            child: ButtonCancel(
                              text: "Edit",
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.11 : 0.35),
                              onTap: () {
                                widget.onEdit();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8.wh,
                          ),
                          ButtonConfirm(
                            text: "OK",
                            onTap: () {
                              context.back();
                            },
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.1 : 0.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
