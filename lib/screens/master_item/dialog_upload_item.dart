import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/download/bloc/download_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/write_web_file.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/shared_widgets/add_edit_confirm_dialog.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/shared_widgets/dropzone_widget.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class DialogUploadItem extends StatefulWidget {
  final List<ListUseCaseData> listUseCase;
  final Function(AssignMstItem) onSubmit;

  const DialogUploadItem(
      {super.key, required this.listUseCase, required this.onSubmit});

  @override
  State<DialogUploadItem> createState() => _DialogUploadItemState();
}

class _DialogUploadItemState extends State<DialogUploadItem> {
  final controller = ScrollController();
  bool isHovered = false;
  String? selectedUseCase;
  List<KeyVal> listUseCase = [];
  bool validateList = false;
  AssignMstItem submitModel = AssignMstItem();
  String? selectedFile, selectedFileName;

  @override
  void initState() {
    for (var e in widget.listUseCase) {
      if (e.useCaseCd != null) {
        listUseCase.add(KeyVal(e.useCaseName ?? "[Undefined]", e.useCaseCd!));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> key = GlobalKey<FormState>();

    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    downloadBloc(DownloadEvent event) {
      BlocProvider.of<DownloadBloc>(context).add(event);
    }

    onConfirm(AssignMstItem val) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmSaveDialog(
              // sTitle: "Supplier",
              allTitle: "Upload Item",
              allValue: "Are you sure to upload this file?",
              textBtn: "Yes, Upload",
              // sValue: val.supplierName,
              onSave: () {
                widget.onSubmit(val);
                context.closeDialog();
              },
            );
          });
    }

    Widget btnItemTemplate() {
      return TextButton.icon(
        onPressed: () {
          downloadBloc(DownloadTemplateUploadMstItem());
        },
        style: ElevatedButton.styleFrom(
            // onPrimary: sccWhite,
            ),
        icon: HeroIcon(
          HeroIcons.arrowDownTray,
          color: primary,
          size: context.scaleFont(14),
        ),
        label: Text(
          "Download Template Upload Item",
          style: TextStyle(
              fontSize: context.scaleFont(14),
              color: primary,
              fontWeight: FontWeight.w600),
        ),
      );
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
        BlocListener<DownloadBloc, DownloadState>(
          listener: (context, state) {
            if (state is DownloadError) {
              showTopSnackBar(context, UpperSnackBar.error(message: state.msg));
            }
            if (state is FileDownloaded) {
              if (state.fileModel.fileBase64 != null) {
                writeFileWeb(
                    state.fileModel.fileBase64!, state.fileModel.fileName,
                    fileType: state.fileModel.fileType);
              }
            }
            if (state is OnLogoutDownload) {
              authBloc(AuthLogin());
            }
          },
        ),
      ],
      child: Dialog(
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
        child: Form(
          key: key,
          child: Container(
            width: context.deviceWidth(),
            // height: context.deviceHeight(),
            padding: isMobile
                ? const EdgeInsets.only(left: 8, right: 8, top: 28, bottom: 12)
                : const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upload Item",
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
                            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      text: 'Business Process ' '<r>*</r>' '',
                                      style: TextStyle(
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.w400),
                                      tags: {
                                        'r': StyledTextTag(
                                            style: TextStyle(
                                                fontSize: context.scaleFont(16),
                                                color: sccDanger))
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: context.deviceWidth() * 0.3,
                                      child: PortalFormDropdown(
                                        selectedUseCase,
                                        listUseCase,
                                        hintText: "Choose business process",
                                        // enabled: widget.formMode != Constant.editMode,
                                        onChange: (value) {
                                          setState(() {
                                            selectedUseCase = value;
                                          });
                                          submitModel.useCaseCd = value;
                                        },
                                        validator: (value) {
                                          if (selectedUseCase == null) {
                                            return "This field is mandatory";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
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
                          SizedBox(
                            height: context.deviceHeight() * 0.35,
                            width: context.deviceWidth() * 0.55,
                            child: DropZoneExcel(
                              onSubmit: (val) {
                                setState(() {
                                  selectedFile = val.fileBase64;
                                  selectedFileName = val.attrIconName;
                                });
                                // print(selectedFileName);
                                submitModel.file = selectedFile;
                                submitModel.fileName = selectedFileName;
                              },
                              fileName: selectedFileName,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                btnItemTemplate(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonCancel(
                                      text: "Cancel",
                                      // width: context.deviceWidth() *
                                      //     (context.isDesktop() ? 0.11 : 0.4),
                                      width: context.deviceWidth() * 0.1,
                                      marginVertical: !isMobile ? 11 : 8,
                                      onTap: () {
                                        context.closeDialog();
                                      },
                                    ),
                                    SizedBox(
                                      width: 8.wh,
                                    ),
                                    ButtonConfirm(
                                      text: "Submit",
                                      verticalMargin: !isMobile ? 11 : 8,
                                      width: context.deviceWidth() * 0.1,
                                      onTap: () {
                                        // print("object");
                                        if (key.currentState!.validate()) {
                                          if (submitModel.file == null) {
                                            showTopSnackBar(
                                                context,
                                                const UpperSnackBar.error(
                                                    message:
                                                        'Upload file first'));
                                          } else {
                                            onConfirm(submitModel);
                                          }
                                        }
                                      },
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}
