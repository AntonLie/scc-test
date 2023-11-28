import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/master_package/bloc/master_package_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogPackage extends StatefulWidget {
  final Function onEdit;
  final bool edit;

  const ViewDialogPackage(
      {super.key, required this.onEdit, required this.edit});

  @override
  State<ViewDialogPackage> createState() => _ViewDialogPackageState();
}

class _ViewDialogPackageState extends State<ViewDialogPackage> {
  late PackageData? model;
  List<PackageData> listPackage = [];
  List<PackageInfo> pkgInfo = [];
  List<Role> listRole = [];
  List<KeyVal> nodeSelected = [];
  KeyVal? colorSelected;
  List<KeyVal> colorOpts = [];
  List<KeyVal> listAllRole = [];
  String? roleSelected;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MasterPackageBloc, MasterPackageState>(
      listener: (context, state) {
        if (state is PackageFormLoaded) {
          model = state.model;
          listAllRole = state.listRoleAll;
          if (model!.packageInfo != null) {
            pkgInfo.addAll(model!.packageInfo!);
          }
          if (model!.role != null) {
            listRole.addAll(model!.role!);
            for (var element in listRole) {
              if (element.roleCd != null) {
                for (var e in listAllRole) {
                  if (element.roleCd == e.value) {
                    nodeSelected.add(KeyVal(e.label, e.value));
                  }
                }
              }
            }
          }
        }
      },
      child: BlocBuilder<MasterPackageBloc, MasterPackageState>(
        builder: (context, state) {
          if (state is! PackageFormLoaded) {
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
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: false,
                        controller: controller,
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      // color: sccRed,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Package Name',
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.scaleFont(12),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            model!.packageName ?? "-",
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.dynamicFont(14),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Price Package(Yearly)',
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
                                            "Rp. ${model!.pricePackage}",
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.dynamicFont(14),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Gas Fee (Per Transaction)',
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.scaleFont(12),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Rp. ${model!.gasFee.toString()}",
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.dynamicFont(14),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Number of Supplier',
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
                                            "${model!.totalSupplier}",
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.dynamicFont(14),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Role',
                                            style: TextStyle(
                                                color: sccBlack,
                                                fontSize: context.scaleFont(12),
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                              height: nodeSelected.length >= 8
                                                  ? context.deviceHeight() * 0.15
                                                  : context.deviceHeight() * 0.08,
                                              width: context.deviceWidth() * 0.3,
                                              child: ListView.builder(
                                                itemCount:
                                                    (nodeSelected.length / 4)
                                                        .ceil(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int rowIndex) {
                                                  int startIndex = rowIndex * 4;
                                                  int endIndex =
                                                      (rowIndex + 1) * 4;
                                  
                                                  // Membuat sebuah List<Text> untuk menyimpan elemen-elemen dalam satu baris
                                                  List<Widget> rowElements = [];
                                  
                                                  for (int i = startIndex;
                                                      i < endIndex;
                                                      i++) {
                                                    if (i < nodeSelected.length) {
                                                      String labelText =
                                                          nodeSelected[i].label;
                                  
                                                      rowElements.add(
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 1),
                                                          child: Container(
                                                            alignment:
                                                                Alignment.center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: sccDisabled,
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          4),
                                                                  child: Text(
                                                                    labelText,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: context
                                                                          .dynamicFont(
                                                                              12),
                                                                      color:
                                                                          sccTextGray2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      rowElements.add(
                                                          const SizedBox(
                                                              width: 5));
                                                    }
                                                  }
                                  
                                                  // Mengembalikan baris dengan elemen-elemen yang telah dibuat
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: rowElements,
                                                  );
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // color: sccAmber,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Number of Accounts',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.totalAccount.toString(),
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.dynamicFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'Number of Parts',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.totalPart.toString(),
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.dynamicFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'Color',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.colorCd!.replaceAll(
                                              "PC_", "Package Color - "),
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.dynamicFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'Blockchain',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.scaleFont(12),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          model!.statusBlockchain.toString() ==
                                                  Constant.statusTrue
                                              ? 'Active'
                                              : 'Inactive',
                                          style: TextStyle(
                                              color: sccBlack,
                                              fontSize: context.dynamicFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          // color: sccBlue,
                                          // width: 10,
                                          height: context.deviceHeight() * 0.1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: context.deviceWidth() * 0.45,
                                            // color: sccAmber,
                                            child: Column(
                                              children: pkgInfo
                                                  .asMap()
                                                  .entries
                                                  .map((e) {
                                                int idx = e.key;
                                                PackageInfo val = e.value;
                                                int i = idx + 1;
                                                return Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          context.deviceWidth() *
                                                              0.45,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      decoration: BoxDecoration(
                                                        color: sccBackground,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    12)),
                                                        border: Border.all(
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Package Info $i",
                                                            style: TextStyle(
                                                                color: sccBlack,
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            val.packageInfo ??
                                                                "-",
                                                            style: TextStyle(
                                                                color: sccBlack,
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        14),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "Package Desc $i",
                                                            style: TextStyle(
                                                                color: sccBlack,
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        12),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            val.packageInfoDesc ??
                                                                "-",
                                                            style: TextStyle(
                                                                color: sccBlack,
                                                                fontSize: context
                                                                    .scaleFont(
                                                                        14),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                  mainAxisAlignment: widget.edit
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: widget.edit,
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
