// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/model_base.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';

class Dropzone extends StatefulWidget {
  final String? base64, fileName, formMode;
  final Function(Base) onSubmit;
  const Dropzone(
      {super.key,
      required this.onSubmit,
      this.base64,
      this.fileName,
      this.formMode});

  @override
  State<Dropzone> createState() => _DropzoneState();
}

class _DropzoneState extends State<Dropzone> {
  List<dynamic> listFiles = [];
  Base base = Base();
  Uint8List? fileBytes;
  String? fileNameIcon;
  String? base64File;
  bool isHovered = false;
  DropzoneViewController? controllerDz;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (widget.base64 != null) {
      fileNameIcon = widget.fileName;
      base64File = widget.base64;
      listFiles.add(base64File);
      fileBytes = base64Decode(widget.base64!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              accFileMobile();
            },
            child: DottedBorder(
              color: sccHintText,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              dashPattern: const [10, 7],
              radius: const Radius.circular(8),
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: const EdgeInsets.all(4),
                width: context.deviceWidth() * 0.1,
                height: context.deviceHeight() * 0.2,
                child: (listFiles.isEmpty && widget.base64 == null)
                    ? Stack(
                        children: [
                          Visibility(
                            visible: context.isDesktop(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isHovered
                                    ? sccButtonLightBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropzoneView(
                                onDrop: accFile,
                                onCreated: (controller) =>
                                    controllerDz = controller,
                                onHover: () => setState(() {
                                  isHovered = true;
                                }),
                                onLeave: () => isHovered = false,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          sccButtonLightBlue,
                                          sccButtonBlue,
                                        ]),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    padding: const EdgeInsets.all(20),
                                    child:
                                        SvgPicture.asset(Constant.cloudUpload),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Drag and drop or ",
                                        style: TextStyle(
                                          fontSize: context.scaleFont(10),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Browse",
                                        style: TextStyle(
                                            fontSize: context.scaleFont(10),
                                            color: sccButtonBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          child: Image.memory(fileBytes!),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: context.deviceWidth() * 0.5,
            height: context.deviceHeight() * 0.2,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: context.scaleFont(7),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SelectableText(
                      'File Format : .JPG, .PNG, .JPEG',
                      style: TextStyle(fontSize: context.scaleFont(14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: context.scaleFont(7),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SelectableText(
                      'File Size Max 1MB.',
                      style: TextStyle(fontSize: context.scaleFont(14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: context.scaleFont(7),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SelectableText(
                      'File resolution 100px x 100px.',
                      style: TextStyle(fontSize: context.scaleFont(14)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  accFileMobile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      // withData: true,
      // withReadStream: true

      allowMultiple: false,
    );

    if (result != null) {
      try {
        fileBytes = result.files.first.bytes!;
        base64File = base64Encode(fileBytes!);

        fileNameIcon = result.files.first.name;
        fileBytes = fileBytes;
        final splitName = fileNameIcon?.split('.');
        String fileName = splitName![0];

        if (result.files.first.size > 1000000) {
          showTopSnackBar(
              context, const UpperSnackBar.error(message: 'File size max 1MB'));
        }

        // print(result);
        setState(() {
          isHovered = true;

          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          base.fileBase64 = base64File;
          base.attrIconPath = fileNameIcon;
          base.attrIconName = fileName;
          // submitModel.file = fileBytes;
          widget.onSubmit(base);
          // print(listFiles);
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    }
    // else {
    //   showTopSnackBar(
    //       context, const UpperSnackBar.error(message: 'File not supported'));
    // }
  }

  accFile(dynamic file) async {
    fileNameIcon = file.name;
    // final mime = await controllerDz!.getFileMIME(file);
    // final size = await controllerDz!.getFileSize(file);
    // final url = await controllerDz!.createFileUrl(file);
    // final base64FileS = await controllerDz!.getFileData(file);
    // print("name = $fileNameIcon");
    // print("mime = $mime");
    // print("size = $size");
    // print("url = $url");
    // print("base64FileS = $base64FileS");

    if (controllerDz != null &&
        file != null &&
        (fileNameIcon!.split('.').last.contains("png") ||
            fileNameIcon!.split('.').last.contains("jpg") ||
            fileNameIcon!.split('.').last.contains("jpeg"))) {
      try {
        fileBytes = await controllerDz!.getFileData(file);
        base64File = base64Encode(fileBytes!);

        final splitName = fileNameIcon?.split('.');
        String fileName = splitName![0];

        setState(() {
          isHovered = false;
          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          base.fileBase64 = base64File;
          base.attrIconPath = fileNameIcon;
          base.attrIconName = fileName;
          widget.onSubmit(base);
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    } else {
      showTopSnackBar(
          context, const UpperSnackBar.error(message: 'File not supported'));
    }
  }
}

class DropZoneExcel extends StatefulWidget {
  final Function(Base) onSubmit;
  final String? fileName;

  const DropZoneExcel({super.key, required this.onSubmit, this.fileName});

  @override
  State<DropZoneExcel> createState() => _DropZoneExcelState();
}

class _DropZoneExcelState extends State<DropZoneExcel> {
  bool isHovered = false;
  DropzoneViewController? controller;
  List<dynamic> listFiles = [];
  String? fileName;
  Uint8List? fileBytes;
  bool formatValidate = false;
  String? base64File;
  Base base = Base();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: sccHintText,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      dashPattern: const [10, 7],
      radius: const Radius.circular(8),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: isHovered ? sccButtonLightBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Visibility(
              visible: context.isDesktop(),
              child: DropzoneView(
                onDrop: accFileExcel,
                onCreated: (controller) => this.controller = controller,
                onHover: () => setState(() {
                  isHovered = true;
                }),
                onLeave: () => isHovered = false,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            sccButtonLightBlue,
                            sccButtonBlue,
                          ]),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: (listFiles.isEmpty && widget.fileName == null)
                          ? SvgPicture.asset(
                              Constant.cloudUpload,
                              colorFilter: const ColorFilter.mode(
                                  sccTextGray, BlendMode.srcIn),
                            )
                          : const GradientWidget(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    sccButtonLightBlue,
                                    sccButtonBlue,
                                  ]),
                              child: HeroIcon(
                                HeroIcons.paperClip,
                                // solid: true,
                                size: 19,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SelectableText(
                    (listFiles.isNotEmpty && fileName != null) ||
                            widget.fileName != null
                        ? fileName ?? widget.fileName!
                        : 'No file choosen',
                    style: TextStyle(
                        color: const Color(0xffACB5BD),
                        fontSize: context.scaleFont(16)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  context.isDesktop()
                      ? RichText(
                          text: TextSpan(children: [
                          TextSpan(
                            text: "Drag and drop or ",
                            style: TextStyle(
                                fontSize: context.scaleFont(16),
                                color: sccText3),
                          ),
                          TextSpan(
                              text: "Browse",
                              style: TextStyle(
                                  fontSize: context.scaleFont(16),
                                  color: sccButtonBlue),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    // premittedBrowse != null || isSuperAdmin
                                    //     ?
                                    () async {
                                  if (controller != null) {
                                    final files = await controller!.pickFiles();
                                    if (files.isEmpty) return;

                                    accFileExcel(files[0]);
                                  }
                                }
                              // : null
                              ),
                        ]))
                      : InkWell(
                          onTap: () async {
                            accFileMobileExcel();
                          }
                          // : null
                          ,
                          child: Text("Browse",
                              style: TextStyle(
                                  fontSize: context.scaleFont(16),
                                  color: sccButtonBlue)),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  SelectableText(
                    "Allowed file formats: .xls, .xlsx",
                    style: TextStyle(
                        fontSize: context.scaleFont(16),
                        color: formatValidate ? sccDanger : sccText3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  accFileMobileExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
      withData: true,
      // withReadStream: true,
    );

    if (result != null) {
      try {
        fileBytes = result.files.first.bytes!;
        base.fileBase64 = base64Encode(fileBytes!);

        fileName = result.files.first.name;
        fileBytes = fileBytes;

        setState(() {
          isHovered = false;

          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          widget.onSubmit(base);
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    } else {
      showTopSnackBar(
          context, UpperSnackBar.error(message: 'File not supported'));
    }
  }

  accFileExcel(dynamic file) async {
    fileName = file.name;
    // final mime = await controller!.getFileMIME(file);
    // final size = await controller!.getFileSize(file);
    // final url = await controller!.createFileUrl(file);
    // print("name = $fileName");
    // print("mime = $mime");
    // print("size = $size");
    // print("url = $url");
    if (controller != null &&
        file != null &&
        (fileName!.split('.').last.contains("xls") ||
            fileName!.split('.').last.contains("xlsx"))) {
      try {
        fileBytes = await controller!.getFileData(file);
        base64File = base64Encode(fileBytes!);

        setState(() {
          isHovered = false;
          if (listFiles.isNotEmpty) listFiles.clear();

          listFiles.add(fileBytes);
          base.fileBase64 = base64File;

          final splitName = fileName?.split('.');
          base.attrIconName = splitName![0];
          widget.onSubmit(base);
        });
      } catch (e) {
        showTopSnackBar(context, UpperSnackBar.error(message: e.toString()));
      }
    } else {
      setState(() {
        formatValidate = true;
      });
      showTopSnackBar(
          context, const UpperSnackBar.error(message: 'File not supported'));
    }
  }
}
