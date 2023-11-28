// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/master_menu/bloc/master_menu_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/menu_model.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/shared_widgets/bread_cumb.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class FormMasterMenu extends StatefulWidget {
  final MenuModel? model;
  final String? formMode;
  final List<ParentMenu> listParentMenu;
  final List<SystemMaster> listMenuType;
  final Function() onClose;
  final Function(MasterMenuSubmitted) onSuccesSubmit;
  final Paging paging;
  final String createMethod,
      createUrl,
      updateMethod,
      updateUrl,
      searchMethod,
      searchUrl;
  const FormMasterMenu(
      {this.model,
      required this.listParentMenu,
      required this.listMenuType,
      required this.formMode,
      required this.onClose,
      required this.paging,
      required this.onSuccesSubmit,
      required this.createMethod,
      required this.createUrl,
      required this.updateMethod,
      required this.updateUrl,
      required this.searchMethod,
      required this.searchUrl,
      Key? key})
      : super(key: key);

  @override
  _FormMasterMenuState createState() => _FormMasterMenuState();
}

class _FormMasterMenuState extends State<FormMasterMenu> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => MasterMenuBloc(),
        ),
      ],
      child: FormMasterMenuBody(
        model: widget.model,
        formMode: widget.formMode,
        onClose: widget.onClose,
        onSuccesSubmit: widget.onSuccesSubmit,
        paging: widget.paging,
        listParentMenu: widget.listParentMenu,
        listMenuType: widget.listMenuType,
        createMethod: widget.createMethod,
        createUrl: widget.createUrl,
        updateMethod: widget.updateMethod,
        updateUrl: widget.updateUrl,
        searchMethod: widget.searchMethod,
        searchUrl: widget.searchUrl,
      ),
    );
  }
}

class FormMasterMenuBody extends StatefulWidget {
  final MenuModel? model;
  final String? formMode;
  final List<ParentMenu> listParentMenu;
  final List<SystemMaster> listMenuType;
  final Function() onClose;
  final Function(MasterMenuSubmitted) onSuccesSubmit;
  final String createMethod,
      createUrl,
      updateMethod,
      updateUrl,
      searchMethod,
      searchUrl;
  final Paging paging;
  const FormMasterMenuBody(
      {this.model,
      required this.listParentMenu,
      required this.listMenuType,
      required this.formMode,
      required this.onClose,
      required this.onSuccesSubmit,
      required this.paging,
      required this.createMethod,
      required this.createUrl,
      required this.updateMethod,
      required this.updateUrl,
      required this.searchMethod,
      required this.searchUrl,
      Key? key})
      : super(key: key);

  @override
  _FormMasterMenuBodyState createState() => _FormMasterMenuBodyState();
}

class _FormMasterMenuBodyState extends State<FormMasterMenuBody> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<KeyVal> listParentMenu = [];
  List<KeyVal> listMenuType = [];
  MenuModel submitModel = MenuModel();
  late TextEditingController menuCdCo;
  late TextEditingController menuNameCo;
  late TextEditingController menuSeqCo;
  late TextEditingController menuDescCo;
  String? parentMenuSelected;
  String? menuTypeSelected;
  @override
  void initState() {
    for (var element in widget.listParentMenu) {
      if (element.menuCd != null) {
        listParentMenu
            .add(KeyVal(element.menuName ?? "[Undefined]", element.menuCd!));
      }
    }
    for (var element in widget.listMenuType) {
      if (element.systemCd != null) {
        listMenuType.add(
            KeyVal(element.systemValue ?? "[Undefined]", element.systemCd!));
      }
    }
    if (widget.model != null) {
      submitModel = widget.model!;
      parentMenuSelected = submitModel.parentMenuCd;
      menuTypeSelected = submitModel.menuTypeCdStr;
    }

    menuCdCo = TextEditingController(text: submitModel.menuCd);
    menuNameCo = TextEditingController(text: submitModel.menuName);
    menuSeqCo =
        TextEditingController(text: (submitModel.menuSeq ?? "").toString());
    menuDescCo = TextEditingController(text: submitModel.menuDesc);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(MasterMenuEvent event) {
      BlocProvider.of<MasterMenuBloc>(context).add(event);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.push(const LoginRoute());
            }
          },
        ),
        BlocListener<MasterMenuBloc, MasterMenuState>(
          listener: (context, state) {
            // if (state is MasterMenuError) {
            //   showTopSnackBar(context, UpperSnackBar.error(message: state.error));
            // }

            if (state is MasterMenuSubmitted) {
              widget.onSuccesSubmit(state);
            }
          },
        ),
      ],
      child: Container(
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
                TitleFormCloseButton(
                  formTitle: widget.formMode == Constant.viewMode
                      ? "${submitModel.menuName ?? "[UNIDENTIFIED Function Feature]"} Details"
                      : widget.formMode == Constant.editMode
                          ? "Edit ${submitModel.menuName ?? "[UNIDENTIFIED Function Feature]"}"
                          : "Add Menu",
                  onClose: () => widget.onClose(),
                ),
                const SizedBox(height: 42),
                StyledText(
                  text:
                      'Menu Code${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                  controller: menuCdCo,
                  hint: "Input Code",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: sccFillLoginField)),
                  enabled: widget.formMode == Constant.addMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else
                    // else if() {
                    //   return "Only 200 characters for maximum allowed";
                    // } else
                    {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value == null) {
                      submitModel.menuCd = value;
                    } else {
                      submitModel.menuCd = value.trim();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text:
                      'Menu Type${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                  menuTypeSelected,
                  listMenuType,
                  hintText: "Select Menu Type",
                  enabled: widget.formMode == Constant.addMode,
                  onChange: (value) {
                    setState(() {
                      menuTypeSelected = value;
                      submitModel.menuTypeCdStr = menuTypeSelected;
                    });
                  },
                  validator: (value) {
                    if (menuTypeSelected == null) {
                      return "This field is mandatory";
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
                      'Menu Name${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                  controller: menuNameCo,
                  hint: "Input Name",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: sccFillLoginField)),
                  enabled: widget.formMode != Constant.viewMode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    } else
                    // else if() {
                    //   return "Only 200 characters for maximum allowed";
                    // } else
                    {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value == null) {
                      submitModel.menuName = value;
                    } else {
                      submitModel.menuName = value.trim();
                    }
                  },
                ),
                const SizedBox(height: 20),
                StyledText(
                  text:
                      'Menu Seq${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                  controller: menuSeqCo,
                  hint: "Input Seq",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: sccFillLoginField)),
                  inputType: TextInputType.number,
                  maxLength: 3,
                  enabled: widget.formMode != Constant.viewMode,
                  onChanged: (value) {
                    submitModel.menuSeq =
                        int.tryParse((value ?? "").trim().number);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is mandatory";
                    }
                    // else if (value.trim().length > 100) {
                    //   return "Only 100 characters for maximum allowed";
                    // }
                    else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledText(
                  text: 'Parent Menu',
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
                  parentMenuSelected,
                  listParentMenu,
                  hintText: "Select Parent Menu",
                  enabled: widget.formMode == Constant.addMode,
                  onChange: (value) {
                    setState(() {
                      parentMenuSelected = value;
                      submitModel.parentMenuCd = parentMenuSelected;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    'Description',
                    style: TextStyle(
                        fontSize: context.scaleFont(14),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                CustomFormTextField(
                  controller: menuDescCo,
                  enabled: widget.formMode != Constant.viewMode,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.trim().length > 250) {
                      return "Only 250 characters for maximum allowed";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (value == null) {
                      submitModel.menuDesc = value;
                    } else {
                      submitModel.menuDesc = value.trim();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
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
                        // marginVertical: !isMobile ? 11 : 8,
                        onTap: widget.onClose,
                      ),
                      SizedBox(
                        width: 8.wh,
                      ),
                      BlocBuilder<MasterMenuBloc, MasterMenuState>(
                        builder: (context, state) {
                          if (state is MasterMenuLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ButtonConfirm(
                            text: widget.formMode == Constant.editMode
                                ? "Save"
                                : "Submit",
                            borderRadius: 8,
                            // verticalMargin: !isMobile ? 11 : 8,
                            onTap: () {
                              if (key.currentState!.validate()) {
                                bloc(SubmitMasterMenu(
                                  widget.formMode,
                                  submitModel,
                                  widget.paging,
                                  createMethod: widget.createMethod,
                                  createUrl: widget.createUrl,
                                  updateMethod: widget.updateMethod,
                                  updateUrl: widget.updateUrl,
                                  searchMethod: widget.searchMethod,
                                  searchUrl: widget.searchUrl,
                                ));
                              }
                            },
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.13 : 0.37),
                            // borderRadius: 8,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
