
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_supplier/bloc/master_supplier_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/master_supplier.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogSupplier extends StatefulWidget {
  final Function onEdit;
  final bool canUpdate;
  const ViewDialogSupplier({super.key, required this.onEdit, required this.canUpdate});

  @override
  State<ViewDialogSupplier> createState() => _ViewDialogSupplierState();
}

class _ViewDialogSupplierState extends State<ViewDialogSupplier> {
  late Supplier? model;
  List<Supplier> listSupplier = [];
  List<String>? supplierCd;
  List<SystemMaster> listSupplierType = [];
  String? suppTypeSelected;

  @override
  void initState() {
    for (var element in listSupplierType) {
      if (element.systemCd != null) {
        listSupplierType.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!)
                as SystemMaster);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MasterSupplierBloc, MasterSupplierState>(
      listener: (context, state) {
        if (state is LoadForm) {
          model = state.submitSupplier;
          listSupplierType = state.listSysMaster;
          for (var element in listSupplierType) {
            if (element.systemCd != null &&
                element.systemCd == model?.supplierTypeCd!.toUpperCase()) {
              suppTypeSelected = element.systemValue;
            }
          }
        }
      },
      child: BlocBuilder<MasterSupplierBloc, MasterSupplierState>(
        builder: (context, state) {
          if (state is! LoadForm) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(child: CircularProgressIndicator()));
          } else {
            return Dialog(
              backgroundColor: sccWhite,
              insetPadding: context.isDesktop()
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.25),
                      vertical: (context.deviceHeight() * 0.1),
                    )
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: context.deviceWidth(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   width: 1,
                        // ),
                        Container(
                          // color: sccRed,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Supplier Code & Name',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model!.supplierCd} - ${model!.supplierName}",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Country',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.supplierCountry ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model!.dialCode}${model!.supplierContactNo}",
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
                          // color: sccAmber,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type of Supplier',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                // model!.supplierTypeCd ?? "-",
                                // suppTypeSelected ?? "",
                                suppTypeSelected ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'City',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.supplierCity ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Postal Code',
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(12),
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model!.postalCd ?? "-",
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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
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
                                  model!.supplierAddr ?? "-",
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
