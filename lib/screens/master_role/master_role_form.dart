// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/new_edit_role/bloc/new_edit_role_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/new_edit_role.dart';
import 'package:scc_web/screens/master_role/master_role_item_details.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class MasterRoleForm extends StatefulWidget {
  final EditRoleForm? model;
  final List<KeyVal> listMenuDrpdwnForm;
  final String formMode;
  final Function() onClose;
  final Function(EditRoleForm) onSubmit;
  const MasterRoleForm({
    Key? key,
    this.model,
    required this.listMenuDrpdwnForm,
    required this.formMode,
    required this.onClose,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<MasterRoleForm> createState() => _MasterRoleFormState();
}

class _MasterRoleFormState extends State<MasterRoleForm> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  EditRoleForm submitModel = EditRoleForm();
  List<KeyVal> listMenuDrpdwn = [];
  ListFeature listFeatCollection = ListFeature();

  late TextEditingController roleName;
  late TextEditingController roleDescription;

  List<ListFeature> listFeature = [];
  List<ListMenuFeat> listMenuFeat = [];
  List<String> listUnvalidated = [];

  bool validateList = false;

  @override
  void initState() {
    if (widget.model != null) {
      submitModel = widget.model!;
      submitModel.listMenuFeat?.forEach((e) {
        listMenuFeat.add(e);
      });
    }
    listMenuDrpdwn = widget.listMenuDrpdwnForm;
    roleName = TextEditingController(text: submitModel.roleName ?? "");
    roleDescription = TextEditingController(text: submitModel.roleDesc ?? "");

    if (widget.formMode == Constant.addMode && listMenuFeat.isEmpty) {
      listMenuFeat.add(ListMenuFeat());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  onConfirm(EditRoleForm val) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmSaveDialog(
            allTitle: widget.formMode == Constant.addMode
                ? "Create New Role?"
                : "Edit Role?",
            allValue: widget.formMode == Constant.addMode
                ? "Are you sure to create new Role : ${val.roleName}?"
                : "Are you sure to edit Role ${val.roleName}?",
            textBtn:
                "Yes, ${widget.formMode == Constant.addMode ? "Save" : "Save"}",
            onSave: () {
              widget.onSubmit(submitModel);
              context.closeDialog();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    removeItem(int index) {
      setState(() {
        listMenuFeat.removeAt(index);
      });
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: isMobile ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8)),
      child: Form(
        key: key,
        child: FocusTraversalGroup(
          descendantsAreFocusable: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.formMode == Constant.addMode
                    ? "Add New"
                    : widget.formMode == Constant.editMode
                        ? "Edit"
                        : "View",
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
              const SizedBox(height: 10),
              StyledText(
                text:
                    'Role Name${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                controller: roleName,
                hint: 'Input Role Name',
                enabled: widget.formMode != Constant.viewMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is mandatory";
                  } else if (value.trim().length > 200) {
                    return "Only 200 characters for maximum allowed";
                  } else if (!(RegExp(
                          r'^([a-zA-Z0-9\_\-]+\s)*[a-zA-Z0-9\-\_]+$')
                      .hasMatch(value.trim()))) {
                    return "Only one [' ','-','_'] between words are allowed";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  if (value != null) {
                    submitModel.roleName = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              SelectableText(
                'Role Description',
                style: TextStyle(
                    fontSize: context.scaleFont(14),
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              CustomFormTextField(
                controller: roleDescription,
                hint: 'Input Role Description',
                enabled: widget.formMode != Constant.viewMode,
                onChanged: (value) {
                  if (value != null) {
                    submitModel.roleDesc = value;
                  }
                },
                maxLine: 5,
              ),
              Visibility(
                visible: listMenuFeat
                    .isNotEmpty, // && widget.formMode != Constant.viewMode,
                child: const SizedBox(
                  height: 20,
                ),
              ),
              Visibility(
                visible: listMenuFeat
                    .isNotEmpty, // && widget.formMode != Constant.viewMode,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listMenuFeat.isNotEmpty ? listMenuFeat.length : 1,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    if (listMenuFeat.isNotEmpty) {
                      return BlocProvider(
                        create: (context) => NewEditRoleBloc(),
                        child: NewEditRoleItemDetail(
                          formMode: widget.formMode,
                          listMenuDrpdwnDetail: listMenuDrpdwn,
                          onChangeFeature: (value) =>
                              listMenuFeat[index].listFeature = value,
                          model: listMenuFeat[index],
                          onClose: (returnKey) {
                            removeItem(index);
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Visibility(
                visible: validateList,
                child: Column(
                  children: [
                    // const SizedBox(height: 10),
                    Text(
                      "This field is mandatory. Please, add one menu access",
                      style: TextStyle(
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.w400, color: sccDanger,
                        overflow: TextOverflow.fade,
                        // fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              // Visibility(
              //   visible: validateList,
              //   child: const SizedBox(height: 5),
              // ),
              Visibility(
                visible: widget.formMode != Constant.viewMode,
                child: DottedAddButton(
                  text: 'Add Menu Access',
                  onTap: () {
                    setState(() {
                      validateList = false;
                      listMenuFeat.add(ListMenuFeat());
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              Visibility(
                visible: widget.formMode == Constant.viewMode,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
                  children: [
                    ButtonReset(
                      text: "OK",
                      width: context.deviceWidth() *
                          (context.isDesktop() ? 0.11 : 0.35),
                      borderRadius: 8,
                      onTap: () => widget.onClose(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Visibility(
                visible: widget.formMode != Constant.viewMode,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
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
                    ButtonConfirm(
                      width: context.deviceWidth() *
                          (context.isDesktop() ? 0.13 : 0.37),
                      borderRadius: 8,
                      text: (widget.formMode == Constant.editMode)
                          ? "Submit"
                          : (widget.formMode == Constant.addMode)
                              ? "Save"
                              : "Save",
                      onTap: () {
                        submitModel.listMenuFeat = List.from(listMenuFeat);
                        //// print(submitModel);
                        listUnvalidated.clear();
                        setState(() {
                          for (var element in listMenuFeat) {
                            if (element.menuCd == null) {
                              listUnvalidated
                                  .add(element.menuCd ?? "Undefined");
                            }
                          }
                          validateList = listUnvalidated.isNotEmpty;
                        });
                        if (key.currentState!.validate() && !validateList) {
                          onConfirm(submitModel);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
