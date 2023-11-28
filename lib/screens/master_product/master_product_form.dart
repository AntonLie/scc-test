import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/master_product/bloc/master_product_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/screens/master_product/card_attribute.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class ProductFormAddEdit extends StatefulWidget {
  final String formMode;
  final MasterProductModel? model;
  final Function() onClose;
  final List<SystemMaster> listType;
  final List<MstAttribute> listAttribute;
  final Function(AddProductSubmit) onSuccesSubmit;
  final Paging? paging;

  const ProductFormAddEdit(
      {super.key,
      required this.formMode,
      this.model,
      required this.onClose,
      required this.onSuccesSubmit,
      required this.listType,
      required this.listAttribute,
      this.paging});

  @override
  State<ProductFormAddEdit> createState() => _ProductFormAddEditState();
}

class _ProductFormAddEditState extends State<ProductFormAddEdit> {
  late ScrollController controller;

  bool validateList = false;
  MasterProductModel submitModel = MasterProductModel();

  List<KeyVal> listType = [];
  List<ProductDetail> detailOnTraceabilityTop = [];
  List<ProductDetail> detailOnTraceabilityBottom = [];
  List<ProductDetail> detailOnTraceTop = [];
  List<ProductDetail> detailOnTraceButtom = [];
  List<ProductDetail> detailOnChildTop = [];
  List<ProductDetail> detailOnChildBottom = [];

  String? selectedAttribute;
  String? selectedType;
  bool isSelected = false;

  late TextEditingController productNameCo;
  late TextEditingController productDescCo;

  @override
  void initState() {
    for (var element in widget.listType) {
      if (element.systemCd != null) {
        listType.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!));
      }
    }

    if (widget.model != null) {
      submitModel = widget.model!;
      selectedType = submitModel.productType ?? "";
    }

    //detailOnTraceabilityTop
    if (submitModel.detailOnTraceabilityTop?.length == 1) {
      detailOnTraceabilityTop.addAll(
          submitModel.detailOnTraceabilityTop as Iterable<ProductDetail>);
      detailOnTraceabilityTop.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnTraceabilityTop?.length == 2) {
      detailOnTraceabilityTop.addAll(
          submitModel.detailOnTraceabilityTop as Iterable<ProductDetail>);
      detailOnTraceabilityTop
          .addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnTraceabilityTop?.length == 3) {
      detailOnTraceabilityTop.addAll(
          submitModel.detailOnTraceabilityTop as Iterable<ProductDetail>);
    } else {
      detailOnTraceabilityTop.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

    //detailOnTraceabilityButtom
    if (submitModel.detailOnTraceabilityButtom?.length == 1) {
      detailOnTraceabilityBottom.addAll(
          submitModel.detailOnTraceabilityButtom as Iterable<ProductDetail>);
      detailOnTraceabilityBottom.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnTraceabilityButtom?.length == 2) {
      detailOnTraceabilityBottom.addAll(
          submitModel.detailOnTraceabilityButtom as Iterable<ProductDetail>);
      detailOnTraceabilityBottom
          .addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnTraceabilityButtom?.length == 3) {
      detailOnTraceabilityBottom.addAll(
          submitModel.detailOnTraceabilityButtom as Iterable<ProductDetail>);
    } else {
      detailOnTraceabilityBottom.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

    //detailOnTraceTop
    if (submitModel.detailOnTraceTop?.length == 1) {
      detailOnTraceTop
          .addAll(submitModel.detailOnTraceTop as Iterable<ProductDetail>);
      detailOnTraceTop.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnTraceTop?.length == 2) {
      detailOnTraceTop
          .addAll(submitModel.detailOnTraceTop as Iterable<ProductDetail>);
      detailOnTraceTop.addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnTraceTop?.length == 3) {
      detailOnTraceTop
          .addAll(submitModel.detailOnTraceTop as Iterable<ProductDetail>);
    } else {
      detailOnTraceTop.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

    //detailOnTraceButtom
    if (submitModel.detailOnTraceButtom?.length == 1) {
      detailOnTraceButtom
          .addAll(submitModel.detailOnTraceButtom as Iterable<ProductDetail>);
      detailOnTraceButtom.addAll([
        // ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnTraceButtom?.length == 2) {
      detailOnTraceButtom
          .addAll(submitModel.detailOnTraceButtom as Iterable<ProductDetail>);
      detailOnTraceButtom.addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnTraceButtom?.length == 3) {
      detailOnTraceButtom
          .addAll(submitModel.detailOnTraceButtom as Iterable<ProductDetail>);
    } else {
      detailOnTraceButtom.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

    // detailOnChildTop
    if (submitModel.detailOnChildTop?.length == 1) {
      detailOnChildTop
          .addAll(submitModel.detailOnChildTop as Iterable<ProductDetail>);
      detailOnChildTop.addAll([
        // ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnChildTop?.length == 2) {
      detailOnChildTop
          .addAll(submitModel.detailOnChildTop as Iterable<ProductDetail>);
      detailOnChildTop.addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnChildTop?.length == 3) {
      detailOnChildTop
          .addAll(submitModel.detailOnChildTop as Iterable<ProductDetail>);
    } else {
      detailOnChildTop.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

// detailOnChildBottom
    if (submitModel.detailOnChildButtom?.length == 1) {
      detailOnChildBottom
          .addAll(submitModel.detailOnChildButtom as Iterable<ProductDetail>);
      detailOnChildBottom.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    } else if (submitModel.detailOnChildButtom?.length == 2) {
      detailOnChildBottom
          .addAll(submitModel.detailOnChildButtom as Iterable<ProductDetail>);
      detailOnChildBottom.addAll([ProductDetail(attrCd: "", labelName: "")]);
    } else if (submitModel.detailOnChildButtom?.length == 3) {
      detailOnChildBottom
          .addAll(submitModel.detailOnChildButtom as Iterable<ProductDetail>);
    } else {
      detailOnChildBottom.addAll([
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: ""),
        ProductDetail(attrCd: "", labelName: "")
      ]);
    }

    productNameCo = TextEditingController(text: submitModel.productName ?? "");
    productDescCo = TextEditingController(text: submitModel.productDesc ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(MasterProductEvent event) {
      BlocProvider.of<MasterProductBloc>(context).add(event);
    }

    final key = GlobalKey<FormState>();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.push(const LoginRoute());
            }
          },
        ),
        BlocListener<MasterProductBloc, MasterProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is AddProductSubmit) {
              widget.onSuccesSubmit(state);
            }
          },
        ),
      ],
      child: Column(
        children: [
          Form(
            key: key,
            child: FocusTraversalGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isMobile ? Colors.white : sccWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.formMode == Constant.addMode ? "Add New" : "Edit",
                          "Product Information",
                          style: TextStyle(
                            fontSize: context.scaleFont(18),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2B2B2B),
                          ),
                        ),
                        const Divider(
                          color: sccLightGrayDivider,
                          height: 25,
                          thickness: 2,
                        ),
                        StyledText(
                          text:
                              'Product Name ${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
                          style: TextStyle(
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w400),
                          tags: {
                            'r': StyledTextTag(
                              style: TextStyle(
                                  fontSize: context.scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: sccDanger),
                            ),
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomFormTextField(
                          hint: "Input Product Name",
                          controller: productNameCo,
                          // focusNode: focusAttrCd,
                          // enabledBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(8),
                          //     borderSide: const BorderSide(color: sccFillLoginField)),
                          enabled: widget.formMode != Constant.editMode,
                          onChanged: (value) {
                            submitModel.productName = value?.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is mandatory";
                            } else if (validateCode(value)) {
                              return "Only letters, capitalized letters, numbers, hypen (-), and underscores (_) are allowed";
                            } else if (value.trim().length > 100) {
                              return "Only 100 characters for maximum allowed";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StyledText(
                          text:
                              'Product Description ${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
                          style: TextStyle(
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w400),
                          tags: {
                            'r': StyledTextTag(
                                style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400,
                                    color: sccDanger))
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomFormTextField(
                          controller: productDescCo,
                          hint: "Input Product Description",
                          // focusNode: focusAttrName,
                          maxLine: 5,
                          enabled: widget.formMode != Constant.viewMode,
                          onChanged: (value) {
                            submitModel.productDesc = value?.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is mandatory";
                            } else if (value.trim().length > 250) {
                              return "Only 250 characters for maximum allowed";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StyledText(
                          text: 'Type ' '<r>*</r>' '',
                          style: TextStyle(
                              fontSize: context.scaleFont(14),
                              fontWeight: FontWeight.w400),
                          tags: {
                            'r': StyledTextTag(
                                style: TextStyle(
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.w400,
                                    color: sccDanger))
                          },
                        ),
                        const SizedBox(height: 10),
                        PortalFormDropdown(
                          selectedType,
                          listType,
                          hintText: "Choose Supplier Type",
                          enabled: widget.formMode != Constant.editMode,
                          onChange: (value) {
                            setState(() {
                              selectedType = value;
                              submitModel.productType = value;
                            });
                          },
                          validator: (value) {
                            if (selectedType == null) {
                              return "This field is mandatory";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: selectedType != null &&
                        (selectedType == Constant.productItem ||
                            selectedType == Constant.productParent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isMobile ? Colors.white : sccWhite,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledText(
                                text:
                                    'Display Attributes on Main Traceability${(selectedType != Constant.productItem) ? ' (Parent Item)' : ''}'
                                    '<r> *</r>'
                                    '',
                                style: TextStyle(
                                    fontSize: context.scaleFont(18),
                                    fontWeight: FontWeight.w600),
                                tags: {
                                  'r': StyledTextTag(
                                      style: TextStyle(
                                          fontSize: context.scaleFont(18),
                                          fontWeight: FontWeight.w600,
                                          color: sccDanger))
                                },
                              ),
                              const Divider(
                                color: sccLightGrayDivider,
                                height: 25,
                                thickness: 2,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: detailOnTraceabilityTop
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    int idx = e.key;
                                    ProductDetail val = e.value;
                                    return ChildCard(
                                      labelName: val.labelName,
                                      labelAttr: val.attrCd,
                                      detailData: (value) {
                                        // detailOnTraceabilityTop[idx] = value!;
                                      },
                                      detailAttribute: (value) {
                                        detailOnTraceabilityTop[idx].attrCd =
                                            value;
                                      },
                                      detailName: (value) {
                                        detailOnTraceabilityTop[idx].labelName =
                                            value!;
                                      },
                                    );
                                  }).toList()),
                              const SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: detailOnTraceabilityBottom
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    int idx = e.key;
                                    ProductDetail val = e.value;
                                    return ChildCard(
                                      labelName: val.labelName,
                                      labelAttr: val.attrCd,
                                      detailData: (value) {
                                        // detailOnTraceabilityBottom[idx] = value!;
                                      },
                                      detailAttribute: (value) {
                                        detailOnTraceabilityBottom[idx].attrCd =
                                            value;
                                      },
                                      detailName: (value) {
                                        detailOnTraceabilityBottom[idx]
                                            .labelName = value!;
                                      },
                                    );
                                  }).toList()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: selectedType != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isMobile ? Colors.white : sccWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      text:
                                          // 'Display Attributes on Trace (Parent Item)'
                                          'Display Attributes on Trace${(selectedType != Constant.productItem) ? ' (Parent Item)' : ''}'
                                          '<r> *</r>'
                                          '',
                                      style: TextStyle(
                                          fontSize: context.scaleFont(18),
                                          fontWeight: FontWeight.w600),
                                      tags: {
                                        'r': StyledTextTag(
                                            style: TextStyle(
                                                fontSize: context.scaleFont(18),
                                                fontWeight: FontWeight.w600,
                                                color: sccDanger))
                                      },
                                    ),
                                    const Divider(
                                      color: sccLightGrayDivider,
                                      height: 25,
                                      thickness: 2,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: detailOnTraceTop
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          int idx = e.key;
                                          ProductDetail val = e.value;
                                          return ChildCard(
                                            labelName: val.labelName,
                                            labelAttr: val.attrCd,
                                            detailData: (value) {
                                              // detailOnTraceTop[idx] = value!;
                                            },
                                            detailAttribute: (value) {
                                              detailOnTraceTop[idx].attrCd =
                                                  value;
                                            },
                                            detailName: (value) {
                                              detailOnTraceTop[idx].labelName =
                                                  value!;
                                            },
                                          );
                                        }).toList()),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: detailOnTraceButtom
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          int idx = e.key;
                                          ProductDetail val = e.value;
                                          return ChildCard(
                                            labelName: val.labelName,
                                            labelAttr: val.attrCd,
                                            detailData: (value) {
                                              // detailOnTraceButtom[idx] = value!;
                                            },
                                            detailAttribute: (value) {
                                              detailOnTraceButtom[idx].attrCd =
                                                  value;
                                            },
                                            detailName: (value) {
                                              detailOnTraceButtom[idx]
                                                  .labelName = value!;
                                            },
                                          );
                                        }).toList()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: selectedType != null &&
                              selectedType != Constant.productItem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isMobile ? Colors.white : sccWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      text:
                                          'Display Attributes on Trace (Child Item)'
                                          '<r> *</r>'
                                          '',
                                      style: TextStyle(
                                          fontSize: context.scaleFont(18),
                                          fontWeight: FontWeight.w600),
                                      tags: {
                                        'r': StyledTextTag(
                                            style: TextStyle(
                                                fontSize: context.scaleFont(18),
                                                fontWeight: FontWeight.w600,
                                                color: sccDanger))
                                      },
                                    ),
                                    const Divider(
                                      color: sccLightGrayDivider,
                                      height: 25,
                                      thickness: 2,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: detailOnChildTop
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          int idx = e.key;
                                          ProductDetail val = e.value;
                                          return ChildCard(
                                            labelName: val.labelName,
                                            labelAttr: val.attrCd,
                                            detailData: (value) {
                                              // detailOnChildTop[idx] = value!;
                                            },
                                            detailAttribute: (value) {
                                              detailOnChildTop[idx].attrCd =
                                                  value;
                                            },
                                            detailName: (value) {
                                              detailOnChildTop[idx].labelName =
                                                  value!;
                                            },
                                          );
                                        }).toList()),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: detailOnChildBottom
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          int idx = e.key;
                                          ProductDetail val = e.value;
                                          return ChildCard(
                                            labelName: val.labelName,
                                            labelAttr: val.attrCd,
                                            detailData: (value) {
                                              // detailOnChildBottom[idx] = value!;
                                            },
                                            detailAttribute: (value) {
                                              detailOnChildBottom[idx].attrCd =
                                                  value;
                                            },
                                            detailName: (value) {
                                              detailOnChildBottom[idx]
                                                  .labelName = value!;
                                            },
                                          );
                                        }).toList()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: widget.formMode != Constant.viewMode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonCancel(
                          text: "Cancel",
                          width: context.deviceWidth() *
                              (context.isDesktop() ? 0.13 : 0.37),
                          borderRadius: 8,
                          onTap: () => widget.onClose(),
                        ),
                        SizedBox(
                          width: 8.wh,
                        ),
                        BlocBuilder<MasterProductBloc, MasterProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ButtonConfirm(
                              text: widget.formMode == Constant.addMode
                                  ? "Submit"
                                  : "Save",
                              width: context.deviceWidth() *
                                  (context.isDesktop() ? 0.13 : 0.37),
                              borderRadius: 8,
                              onTap: () {
                                if (key.currentState!.validate()) {
                                  submitModel.detailOnTraceabilityTop =
                                      detailOnTraceabilityTop;
                                  submitModel.detailOnTraceabilityButtom =
                                      detailOnTraceabilityBottom;
                                  if (selectedType == Constant.productParent) {
                                    submitModel.detailOnChildTop =
                                        detailOnChildTop;
                                    submitModel.detailOnChildButtom =
                                        detailOnChildBottom;
                                  }
                                  submitModel.detailOnTraceTop =
                                      detailOnTraceTop;
                                  submitModel.detailOnTraceButtom =
                                      detailOnTraceButtom;
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmSaveDialog(
                                          sTitle: "Product",
                                          sValue: submitModel.productName,
                                          onSave: () {
                                            // widget.onSave(val);
                                            bloc(
                                              AddProductData(
                                                  submitModel,
                                                  widget.formMode,
                                                  widget.paging),
                                            );
                                            context.closeDialog();
                                          },
                                        );
                                      });
                                  // widget.onSuccesSubmit(submitModel);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
