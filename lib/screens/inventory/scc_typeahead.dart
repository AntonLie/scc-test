import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/debouncer.dart';
import 'package:scc_web/helper/drag_behaviour.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/services/restapi.dart';
import 'package:scc_web/shared_widgets/gradient_widgets.dart';
import 'package:scc_web/shared_widgets/outline_gradient_button.dart';
import 'package:scc_web/shared_widgets/vcc_checkbox_tile.dart';

import 'package:scc_web/theme/colors.dart';

class SccTypeAhead extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String? hintText, selectedItem;
  final Map<String, String>? additionalParam;
  final String url, apiKey;
  final Function(String?) onSelectionChange, onError;
  final Function() onLogout;
  final Function(String?)? onStrChange;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor, focusColor, idleColor, hoverColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const SccTypeAhead(
      {super.key,
      this.margin,
      this.hintText,
      this.selectedItem,
      this.additionalParam,
      required this.url,
      required this.apiKey,
      required this.onSelectionChange,
      required this.onError,
      required this.onLogout,
      this.onStrChange,
      this.validator,
      this.suffix,
      this.style,
      this.readOnly = false,
      this.enabled = true,
      this.enableBorderColor = false,
      this.isDense,
      this.hideKeyboard,
      this.focusNode,
      this.borderRadius = 8,
      this.fillColor,
      this.focusColor,
      this.idleColor,
      this.hoverColor,
      this.fontSize,
      this.fontWeight});

  @override
  State<SccTypeAhead> createState() => _SccTypeAheadState();
}

class _SccTypeAheadState extends State<SccTypeAhead> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  // String? selectedItem;
  // Timer? timer;
  // List<String> options = [];
  DatabaseHelper db = DatabaseHelper();
  FocusNode focusNode = FocusNode();
  RestApi api = RestApi();
  Debouncer debouncer = Debouncer();
  Color fillColor = sccFillLoginField;
  bool valid = false;

  @override
  void didUpdateWidget(SccTypeAhead oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // setState(() {
      textController.clear();
      textController.value = textController.value.copyWith(
          text: widget.selectedItem,
          selection: TextSelection(
              baseOffset: widget.selectedItem?.length ?? 0,
              extentOffset: widget.selectedItem?.length ?? 0));
      // });
    });
  }

  @override
  void initState() {
    textController = TextEditingController();
    // selectedItem = widget.selectedItem;
    textController.value =
        textController.value.copyWith(text: widget.selectedItem);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          fillColor = widget.focusColor ?? sccWhite;
        });
      } else {
        setState(() {
          fillColor = widget.idleColor ?? sccFillLoginField;
        });
      }
    });
    super.initState();
  }

  Future<List<String>> getItem(String pattern) async {
    List<String> matches = [];
    try {
      Login? log = await db.getUser();
      if (log == null) {
        throw InvalidSessionExpression();
      }
      // if (timer != null) {
      //   timer!.cancel();
      // }
      // timer = Timer(Duration(milliseconds: 800), () async {
      Map<String, String> param = {
        widget.apiKey: pattern,
        "pageNo": "1",
        "pageSize": "1000",
      };
      if (widget.additionalParam != null) {
        param.addAll(widget.additionalParam!);
      }
      var resp = await api.customUrlGet(
        url: widget.url,
        header: {
          "Authorization": "${log.tokenType!} ${log.accessToken!}",
        },
        param: param,
      ) as Map<String, dynamic>;
      List list = resp['listData'];
      for (var element in list) {
        if (element is Map) {
          matches.add(element[widget.apiKey]);
          // debugprint("SE : ${widget.selectedItem} == item :" + element[widget.apiKey]);
          if (widget.selectedItem == element[widget.apiKey]) {
            // debugprint("matched");
          }
        }
      }

      // });
    } catch (e) {
      if (e is InvalidSessionExpression) {
        widget.onLogout();
      } else {
        widget.onError(e.toString());
      }
    }
    // matches.add("tester");
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      suggestionsBoxController: boxController,
      validator: (value) {
        if (widget.validator != null) {
          setState(() {
            if (value == null || value.isEmpty) {
              valid = true;
            } else {
              valid = false;
            }
          });
          return widget.validator!(value);
        } else {
          return null;
        }
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        enabled:
            //  options.isNotEmpty &&
            widget.enabled,
        onTap: () => boxController,
        onChanged: (val) {
          // if (!boxController.isOpened() && !options.any((element) => element == val)) {
          //   boxController;
          // }
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        onEditingComplete: () {
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        onSubmitted: (val) {
          // setState(() {
          //   selectedItem = val;
          // });
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
          widget.onStrChange!(val);
          widget.onSelectionChange(val);
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        style: widget.style ??
            TextStyle(
              color: sccBlack,
              fontSize: widget.fontSize ?? context.scaleFont(15),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.style ??
              TextStyle(
                color: sccText4,
                fontSize: widget.fontSize ?? context.scaleFont(16),
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                overflow: TextOverflow.fade,
              ),
          suffixIcon: widget.enabled
              ? ExcludeFocus(
                  child: widget.suffix ??
                      IconButton(
                        onPressed: () {
                          if (widget.enabled) {
                            boxController;
                            textController.selection = TextSelection(
                                baseOffset: textController.text.length,
                                extentOffset: textController.text.length);
                          }
                        },
                        splashRadius: 10,
                        icon: HeroIcon(
                          HeroIcons.chevronDown,
                          size: context.scaleFont(28),
                          color: sccText4,
                        ),
                      ),
                )
              : Container(
                  width: 1,
                ),
          // suffixIconColor: sccButtonBlue,
          isDense: widget.isDense,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabled: widget.enabled,
          // labelText: widget.label,
          // labelStyle: TextStyle(
          //   fontSize: context.scaleFont(16),
          //   color: sccBlack,
          // ),
          filled: true,
          hoverColor: widget.hoverColor ?? sccFillField,
          fillColor: (widget.fillColor != null)
              ? widget.fillColor
              : (!widget.enabled)
                  ? sccDisabledTextField
                  : valid
                      ? sccValidateField
                      : fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color:
                      widget.enableBorderColor ? sccBorder : Colors.transparent,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccButtonPurple, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 1)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 1)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? false,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
        hasScrollbar: false,
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (pattern)
          // => debouncer.run(() async {
          //   await getItem(pattern);
          // }),
          async {
        return await getItem(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hoverColor: Colors.transparent,
            horizontalTitleGap: 8,
            minLeadingWidth: 10,
            onTap: () {
              boxController;
              textController.value =
                  textController.value.copyWith(text: suggestion);
              widget.onSelectionChange(suggestion);
            },
            leading: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlineGradientButton(
                onTap: () {
                  boxController;
                  textController.value =
                      textController.value.copyWith(text: suggestion);
                  widget.onSelectionChange(suggestion);
                },
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.selectedItem != null &&
                          widget.selectedItem == suggestion
                      ? [
                          sccButtonBlue,
                          sccButtonBlue,
                        ]
                      : [
                          sccInfoGrey,
                          sccInfoGrey,
                        ],
                ),
                strokeWidth: widget.selectedItem != null &&
                        widget.selectedItem == suggestion
                    ? 1
                    : 0.5,
                padding: const EdgeInsets.all(1),
                radius: const Radius.circular(125),
                child: GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.selectedItem != null &&
                            widget.selectedItem == suggestion
                        ? [
                            sccButtonBlue,
                            sccButtonBlue,
                          ]
                        : [
                            Colors.transparent,
                            Colors.transparent,
                          ],
                  ),
                  child: Icon(
                    Icons.circle,
                    size: context.scaleFont(13),
                  ),
                ),
              ),
            ),
            title: Text(
              suggestion,
              style: TextStyle(
                color: sccBlack,
                fontSize: context.scaleFont(16),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      hideOnEmpty: true,
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onSelectionChange(value);
      },
    );
  }
}

class SccTypeAheadKeyval extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String? hintText, selectedItem;
  final String url, apiKeyLabel, apiKeyValue;
  final Function(String?) onSelectionChange, onError;
  final String? Function(String?)? validator;
  final Function() onLogout;
  final Function(String?)? onStrChange;
  final Map<String, String>? additionalParam;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard, formBehaviour;
  final FocusNode? focusNode;
  final double borderRadius;
  final int? totalData;
  final Color? fillColor, focusColor, idleColor, hoverColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const SccTypeAheadKeyval(
      {super.key,
      this.margin,
      this.hintText,
      this.selectedItem,
      required this.url,
      required this.apiKeyLabel,
      required this.apiKeyValue,
      required this.onSelectionChange,
      required this.onError,
      this.validator,
      required this.onLogout,
      this.onStrChange,
      this.additionalParam,
      this.suffix,
      this.style,
      required this.readOnly,
      required this.enabled,
      required this.enableBorderColor,
      this.isDense,
      this.hideKeyboard,
      this.formBehaviour,
      this.focusNode,
      required this.borderRadius,
      this.totalData,
      this.fillColor,
      this.focusColor,
      this.idleColor,
      this.hoverColor,
      this.fontSize,
      this.fontWeight});

  @override
  State<SccTypeAheadKeyval> createState() => _SccTypeAheadKeyvalState();
}

class _SccTypeAheadKeyvalState extends State<SccTypeAheadKeyval> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  // String? selectedItem;
  // Timer? timer;
  // List<String> options = [];
  DatabaseHelper db = DatabaseHelper();
  RestApi api = RestApi();
  Debouncer debouncer = Debouncer();
  FocusNode focusNode = FocusNode();
  bool valid = false;
  Color fillColor = sccFillLoginField;

  @override
  void initState() {
    textController = TextEditingController();
    // selectedItem = widget.selectedItem;
    textController.value =
        textController.value.copyWith(text: widget.selectedItem);

    if (widget.formBehaviour ?? false) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          setState(() {
            fillColor = sccWhite;
          });
        } else {
          setState(() {
            fillColor = sccFillLoginField;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(SccTypeAheadKeyval oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedItem?.isNotEmpty != true) {
        textController.clear();
      }
    });
  }

  Future<List<KeyVal>> getItem(String pattern) async {
    List<KeyVal> matches = [];
    try {
      Login? log = await db.getUser();
      if (log == null) {
        throw InvalidSessionExpression();
      }
      // if (timer != null) {
      //   timer!.cancel();
      // }
      // timer = Timer(Duration(milliseconds: 800), () async {
      Map<String, String> param = {
        widget.apiKeyLabel: pattern,
        "pageNo": "1",
        "pageSize": "${widget.totalData ?? 1000}",
      };
      if (widget.additionalParam != null) {
        param.addAll(widget.additionalParam!);
      }
      String url = widget.url;
      var resp = await api.customUrlGet(
        url: url,
        header: {
          "Authorization": "${log.tokenType!} ${log.accessToken!}",
        },
        param: param,
      ) as Map<String, dynamic>;
      List list = resp['listData'];
      matches.add(KeyVal('All', ''));
      for (var element in list) {
        if (element is Map) {
          matches.add(
              KeyVal(element[widget.apiKeyLabel], element[widget.apiKeyValue]));
        }
      }

      // });
    } catch (e) {
      if (e is InvalidSessionExpression) {
        widget.onLogout();
      } else {
        widget.onError(e.toString());
      }
    }
    // matches.add(KeyVal("Tester", "Tester"));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<KeyVal>(
      suggestionsBoxController: boxController,
      validator: (value) {
        if (widget.validator != null) {
          setState(() {
            if (value == null || value.isEmpty) {
              valid = true;
            } else {
              valid = false;
            }
          });
          return widget.validator!(value);
        } else {
          return null;
        }
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        enabled:
            //  options.isNotEmpty &&
            widget.enabled,
        onTap: () => boxController,
        onChanged: (val) {
          // if (!boxController.isOpened() && !options.any((element) => element == val)) {
          //   boxController;
          // }
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        onEditingComplete: () {
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        onSubmitted: (val) {
          // setState(() {
          //   selectedItem = val;
          // });
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
          widget.onStrChange!(val);
          widget.onSelectionChange(val);
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        style: widget.style ??
            TextStyle(
              color: sccBlack,
              fontSize: widget.fontSize ?? context.scaleFont(15),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.style ??
              TextStyle(
                color: sccText4,
                fontSize: widget.fontSize ?? context.scaleFont(16),
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                overflow: TextOverflow.fade,
              ),
          suffixIcon: widget.enabled
              ? widget.suffix ??
                  IconButton(
                    onPressed: () {
                      if (widget.enabled) {
                        boxController;
                        textController.selection = TextSelection(
                            baseOffset: textController.text.length,
                            extentOffset: textController.text.length);
                      }
                    },
                    splashRadius: 10,
                    icon: HeroIcon(
                      HeroIcons.chevronDown,
                      size: context.scaleFont(28),
                      color: sccButtonBlue,
                    ),
                  )
              : Container(
                  width: 1,
                ),
          // suffixIconColor: sccButtonBlue,
          isDense: widget.isDense,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabled: widget.enabled,
          // labelText: widget.label,
          // labelStyle: TextStyle(
          //   fontSize: context.scaleFont(14),
          //   color: sccBlack,
          // ),
          filled: true,
          hoverColor: widget.hoverColor ?? sccFillField,
          fillColor: (widget.fillColor != null)
              ? widget.fillColor
              : (!widget.enabled)
                  ? sccDisabledTextField
                  : valid
                      ? sccValidateField
                      : fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color:
                      widget.enableBorderColor ? sccBorder : Colors.transparent,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: (widget.formBehaviour ?? false)
                      ? widget.fillColor ?? sccButtonBlue
                      : Colors.transparent,
                  width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? false,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
        hasScrollbar: false,
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (pattern)
          // => debouncer.run(() async {
          //   await getItem(pattern);
          // }),
          async {
        return await getItem(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hoverColor: Colors.transparent,
            horizontalTitleGap: 8,
            minLeadingWidth: 10,
            onTap: () {
              boxController;
              textController.value =
                  textController.value.copyWith(text: suggestion.label);
              widget.onSelectionChange(suggestion.value);
            },
            leading: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlineGradientButton(
                onTap: () {
                  boxController;
                  textController.value =
                      textController.value.copyWith(text: suggestion.label);
                  widget.onSelectionChange(suggestion.value);
                },
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.selectedItem != null &&
                          widget.selectedItem == suggestion.value
                      ? [
                          sccButtonBlue,
                          sccButtonBlue,
                        ]
                      : [
                          sccInfoGrey,
                          sccInfoGrey,
                        ],
                ),
                strokeWidth: widget.selectedItem != null &&
                        widget.selectedItem == suggestion.value
                    ? 1
                    : 0.5,
                padding: const EdgeInsets.all(1),
                radius: const Radius.circular(125),
                child: GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.selectedItem != null &&
                            widget.selectedItem == suggestion.value
                        ? [
                            sccButtonBlue,
                            sccButtonBlue,
                          ]
                        : [
                            Colors.transparent,
                            Colors.transparent,
                          ],
                  ),
                  child: Icon(
                    Icons.circle,
                    size: context.scaleFont(13),
                  ),
                ),
              ),
            ),
            title: Text(
              suggestion.label,
              style: TextStyle(
                color: sccBlack,
                fontSize: context.scaleFont(14),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      hideOnEmpty: true,
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onSelectionChange(value);
      },
    );
  }
}

class SccMultipleTypeAhead extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String? hintText;
  final List<String> selectedItems;
  final Function(List<String>)? onSelectionChange;
  final Map<String, String>? additionalParam;
  final String url, apiKey;
  final Function(String?) onError;
  final Function() onLogout;
  final Function(String?)? onStrChange;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard, onSubmitEnabled;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor, focusColor, idleColor, hoverColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const SccMultipleTypeAhead(
      {super.key,
      this.margin,
      this.hintText,
      required this.selectedItems,
      this.onSelectionChange,
      this.additionalParam,
      required this.url,
      required this.apiKey,
      required this.onError,
      required this.onLogout,
      this.onStrChange,
      this.validator,
      this.suffix,
      this.style,
      required this.readOnly,
      required this.enabled,
      required this.enableBorderColor,
      this.isDense,
      this.hideKeyboard,
      this.onSubmitEnabled,
      this.focusNode,
      required this.borderRadius,
      this.fillColor,
      this.focusColor,
      this.idleColor,
      this.hoverColor,
      this.fontSize,
      this.fontWeight});

  @override
  State<SccMultipleTypeAhead> createState() => _SccMultipleTypeAheadState();
}

class _SccMultipleTypeAheadState extends State<SccMultipleTypeAhead> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  List<String> selectedItems = [];
  // Timer? timer;
  // List<String> options = [];
  DatabaseHelper db = DatabaseHelper();
  FocusNode focusNode = FocusNode();
  RestApi api = RestApi();
  Color fillColor = sccWhite;
  bool valid = false;

  @override
  void didUpdateWidget(SccMultipleTypeAhead oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textController.clear();
    });
  }

  @override
  void initState() {
    textController = TextEditingController();
    selectedItems.addAll(widget.selectedItems);
    super.initState();
  }

  Future<List<String>> getItem(String pattern) async {
    List<String> matches = [];
    try {
      Login? log = await db.getUser();
      if (log == null) {
        throw InvalidSessionExpression();
      }
      // if (timer != null) {
      //   timer!.cancel();
      // }
      // timer = Timer(Duration(milliseconds: 800), () async {
      Map<String, String> param = {
        widget.apiKey: pattern,
        "pageNo": "1",
        "pageSize": "100",
      };
      if (widget.additionalParam != null) {
        param.addAll(widget.additionalParam!);
      }
      var resp = await api.customUrlGet(
        url: widget.url,
        header: {
          "Authorization": "${log.tokenType!} ${log.accessToken!}",
        },
        param: param,
      ) as Map<String, dynamic>;
      List list = resp['listData'];
      for (var element in list) {
        if (element is Map) {
          matches.add(element[widget.apiKey]);
          // if (widget.selectedItems.contains(element[widget.apiKey])) {
          //   // debugprint("matched");
          // }
        }
      }

      // });
    } catch (e) {
      if (e is InvalidSessionExpression) {
        widget.onLogout();
      } else {
        widget.onError(e.toString());
      }
    }
    // matches.add("tester");
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      suggestionsBoxController: boxController,
      validator: (value) {
        if (widget.validator != null) {
          setState(() {
            if (value == null || value.isEmpty) {
              valid = true;
            } else {
              valid = false;
            }
          });
          return widget.validator!(value);
        } else {
          return null;
        }
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        enabled:
            //  options.isNotEmpty &&
            widget.enabled,
        onTap: () => boxController,
        onChanged: (val) {
          // if (!boxController.isOpened() && !options.any((element) => element == val)) {
          //   boxController;
          // }
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        // onEditingComplete: () {
        //   if (!boxController.isOpened()) {
        //     boxController;
        //   }
        // },
        onSubmitted: (val) {
          // setState(() {
          //   selectedItem = val;
          // });
          if (widget.onSubmitEnabled == true) {
            textController.clear();
            setState(() {
              selectedItems.add(val);
            });
            if (widget.onSelectionChange != null) {
              widget.onSelectionChange!(selectedItems);
            }
            if (widget.onStrChange != null) {
              widget.onStrChange!(val);
            }

            if (!boxController.isOpened()) {
              boxController;
            }
          }
        },
        style: widget.style ??
            TextStyle(
              color: sccBlack,
              fontSize: widget.fontSize ?? context.scaleFont(15),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.style ??
              TextStyle(
                color: sccText4,
                fontSize: widget.fontSize ?? context.scaleFont(16),
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                overflow: TextOverflow.fade,
              ),
          prefixIcon: selectedItems.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: LayoutBuilder(builder: (ctx, ctn) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: ctn.maxWidth * 0.65),
                      child: ScrollConfiguration(
                        behavior: DragBehavior(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                              children: selectedItems.map((e) {
                            // if (searchList.any((element) => element.value == e)) {
                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.borderRadius),
                                color: sccDisabled,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        color: sccTextGray,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.enabled != false,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedItems.remove(e);
                                        });
                                        if (widget.onSelectionChange != null) {
                                          widget.onSelectionChange!(
                                              selectedItems);
                                        }
                                      },
                                      child: HeroIcon(
                                        HeroIcons.xCircle,
                                        size: context.scaleFont(18),
                                        color: sccText4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // } else {
                            //   return SizedBox();
                            // }
                          }).toList()),
                        ),
                      ),
                    );
                  }),
                )
              : null,
          suffixIcon: widget.enabled
              ? ExcludeFocus(
                  child: widget.suffix ??
                      IconButton(
                        onPressed: () {
                          if (widget.enabled) {
                            boxController;
                            // textController.selection =
                            //     TextSelection(baseOffset: textController.text.length, extentOffset: textController.text.length);
                          }
                        },
                        splashRadius: 10,
                        icon: HeroIcon(
                          HeroIcons.chevronDown,
                          size: context.scaleFont(28),
                          color: sccButtonBlue,
                        ),
                      ),
                )
              : const SizedBox(
                  width: 1,
                ),
          // suffixIconColor: sccButtonBlue,
          isDense: widget.isDense,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabled: widget.enabled,
          // labelText: widget.label,
          // labelStyle: TextStyle(
          //   fontSize: context.scaleFont(16),
          //   color: sccBlack,
          // ),
          filled: true,
          hoverColor: widget.hoverColor ?? sccFillField,
          fillColor: (widget.fillColor != null)
              ? widget.fillColor
              : (!widget.enabled)
                  ? sccDisabledTextField
                  : valid
                      ? sccValidateField
                      : fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.enableBorderColor ? sccBorder : sccBorder,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccButtonPurple, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? false,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
        hasScrollbar: false,
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (pattern)
          // => debouncer.run(() async {
          //   await getItem(pattern);
          // }),
          async {
        return await getItem(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: VccCheckboxTile(
            title: suggestion,
            enabled: widget.enabled,
            value: selectedItems.any((element) => element == suggestion),
            onChanged: (value) {
              boxController;
              textController.clear();
              setState(() {
                if (selectedItems.contains(suggestion)) {
                  selectedItems.remove(suggestion);
                } else {
                  selectedItems.add(suggestion);
                }
              });
              if (widget.onSelectionChange != null) {
                widget.onSelectionChange!(selectedItems);
              }
            },
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      hideOnEmpty: true,
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onSelectionChange(value);
      },
    );
  }
}

class SccMultipleTypeAheadKeyVal extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String? hintText;
  final List<KeyVal> selectedItems;
  final Function(List<KeyVal>)? onSelectionChange;
  final Map<String, String>? additionalParam;
  final String url, apiKeyLabel, apiKeyValue;
  final Function(String?) onError;
  final Function() onLogout;
  final Function(String?)? onStrChange;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard, onSubmitEnabled;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor, focusColor, idleColor, hoverColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const SccMultipleTypeAheadKeyVal({
    Key? key,
    this.isDense,
    this.margin,
    this.suffix,
    this.validator,
    required this.onLogout,
    required this.onError,
    required this.onSelectionChange,
    required this.selectedItems,
    required this.url,
    required this.apiKeyLabel,
    required this.apiKeyValue,
    this.onStrChange,
    this.readOnly = false,
    this.focusColor,
    this.hoverColor,
    this.idleColor,
    this.enabled = true,
    this.hideKeyboard,
    this.additionalParam,
    this.fillColor,
    this.style,
    this.focusNode,
    this.hintText = '',
    this.borderRadius = 8,
    this.fontSize,
    this.fontWeight,
    this.enableBorderColor = false,
    this.onSubmitEnabled,
  }) : super(key: key);

  @override
  State<SccMultipleTypeAheadKeyVal> createState() =>
      _SccMultipleTypeAheadKeyValState();
}

class _SccMultipleTypeAheadKeyValState
    extends State<SccMultipleTypeAheadKeyVal> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  List<KeyVal> selectedItems = [];
  // Timer? timer;
  // List<String> options = [];
  DatabaseHelper db = DatabaseHelper();
  FocusNode focusNode = FocusNode();
  RestApi api = RestApi();
  Color fillColor = sccWhite;
  bool valid = false;

  @override
  void didUpdateWidget(SccMultipleTypeAheadKeyVal oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        textController.clear();
        selectedItems.clear();
        selectedItems.addAll(widget.selectedItems);
        // textController.value = textController.value.copyWith(text: widget.selectedItem);
      });
    });
  }

  @override
  void initState() {
    textController = TextEditingController();
    selectedItems.clear();
    selectedItems.addAll(widget.selectedItems);
    // textController.value = textController.value.copyWith(text: widget.selectedItem);
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     setState(() {
    //       fillColor = widget.focusColor ?? sccWhite;
    //     });
    //   } else {
    //     setState(() {
    //       fillColor = widget.idleColor ?? sccFillLoginField;
    //     });
    //   }
    // });
    super.initState();
  }

  Future<List<KeyVal>> getItem(String pattern) async {
    List<KeyVal> matches = [];
    try {
      Login? log = await db.getUser();
      if (log == null) {
        throw InvalidSessionExpression();
      }
      // if (timer != null) {
      //   timer!.cancel();
      // }
      // timer = Timer(Duration(milliseconds: 800), () async {
      Map<String, String> param = {
        widget.apiKeyLabel: pattern,
        "pageNo": "1",
        "pageSize": "1000",
      };
      if (widget.additionalParam != null) {
        param.addAll(widget.additionalParam!);
      }
      var resp = await api.customUrlGet(
        url: widget.url,
        header: {
          "Authorization": "${log.tokenType!} ${log.accessToken!}",
        },
        param: param,
      ) as Map<String, dynamic>;
      List list = resp['listData'];
      list.forEach((element) {
        if (element is Map) {
          if (element[widget.apiKeyValue] is String) {
            matches.add(KeyVal((element[widget.apiKeyLabel] ?? "UNIDENTIFIED"),
                element[widget.apiKeyValue]!));
          } // if (widget.selectedItems.contains(element[widget.apiKey])) {
          //   // debugprint("matched");
          // }
        }
      });

      // });
    } catch (e) {
      if (e is InvalidSessionExpression) {
        widget.onLogout();
      } else {
        widget.onError(e.toString());
      }
    }
    // matches.add("tester");
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<KeyVal>(
      suggestionsBoxController: boxController,
      validator: (value) {
        if (selectedItems.isEmpty) {
          if (widget.validator != null) {
            setState(() {
              if (value == null || value.isEmpty) {
                valid = true;
              } else {
                valid = false;
              }
            });
            return widget.validator!(value);
          } else {
            return null;
          }
        }
        return null;
      },
      textFieldConfiguration: TextFieldConfiguration(
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            Constant.regExp, // Hanya huruf, angka, _, -, spasi, @, +, dan .
          ),
        ],
        controller: textController,
        enabled:
            //  options.isNotEmpty &&
            widget.enabled == true,
        onTap: () => boxController,
        onChanged: (val) {
          // if (!boxController.isOpened() && !options.any((element) => element == val)) {
          //   boxController;
          // }
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        // onEditingComplete: () {
        //   if (!boxController.isOpened()) {
        //     boxController;
        //   }
        // },
        onSubmitted: (val) {
          // setState(() {
          //   selectedItem = val;
          // });
          if (widget.onSubmitEnabled == true) {
            textController.clear();
            setState(() {
              selectedItems.add(KeyVal(val, val));
            });
            if (widget.onSelectionChange != null) {
              widget.onSelectionChange!(selectedItems);
            }
            if (widget.onStrChange != null) {
              widget.onStrChange!(val);
            }

            if (!boxController.isOpened()) {
              boxController;
            }
          }
        },
        style: widget.style ??
            TextStyle(
              color: sccBlack,
              fontSize: widget.fontSize ?? context.scaleFont(15),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText:
              // widget.enabled == true ?
              widget.hintText
          //  : ''
          ,
          hintStyle: widget.style ??
              TextStyle(
                color: sccText4,
                fontSize: widget.fontSize ?? context.scaleFont(16),
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                overflow: TextOverflow.fade,
              ),
          prefixIcon: selectedItems.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: LayoutBuilder(builder: (ctx, ctn) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: ctn.maxWidth * 0.65),
                      child: ScrollConfiguration(
                        behavior: DragBehavior(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                              children: selectedItems.map((e) {
                            // if (searchList.any((element) => element.value == e)) {
                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.borderRadius),
                                color: sccDisabled,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      e.label,
                                      style: TextStyle(
                                        fontSize: context.scaleFont(14),
                                        color: sccTextGray2,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.enabled != false,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedItems.removeWhere(
                                            (element) =>
                                                element.value == e.value,
                                          );
                                        });
                                        if (widget.onSelectionChange != null) {
                                          widget.onSelectionChange!(
                                              selectedItems);
                                        }
                                      },
                                      child: HeroIcon(
                                        HeroIcons.xMark,
                                        size: context.scaleFont(18),
                                        color: sccText4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // } else {
                            //   return SizedBox();
                            // }
                          }).toList()),
                        ),
                      ),
                    );
                  }),
                )
              : null,
          suffixIcon: widget.enabled
              ? ExcludeFocus(
                  child: widget.suffix ??
                      IconButton(
                        onPressed: () {
                          if (widget.enabled) {
                            boxController;
                            // textController.selection =
                            //     TextSelection(baseOffset: textController.text.length, extentOffset: textController.text.length);
                          }
                        },
                        splashRadius: 10,
                        icon: HeroIcon(
                          HeroIcons.chevronDown,
                          size: context.scaleFont(24),
                          color: sccText4,
                        ),
                      ),
                )
              : SizedBox(
                  width: 1,
                ),
          // suffixIconColor: sccButtonBlue,
          isDense: widget.isDense,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabled: widget.enabled,
          // labelText: widget.label,
          // labelStyle: TextStyle(
          //   fontSize: context.scaleFont(16),
          //   color: sccBlack,
          // ),
          filled: true,
          hoverColor: widget.hoverColor ?? sccFillField,
          fillColor: (widget.fillColor != null)
              ? widget.fillColor
              : (!widget.enabled)
                  ? sccDisabledTextField
                  : valid
                      ? sccValidateField
                      : fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.enableBorderColor ? sccBorder : sccBorder,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: sccBorder, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: sccButtonPurple, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: sccDanger, width: 1)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: sccDanger, width: 1)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? false,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
        hasScrollbar: false,
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (pattern)
          // => debouncer.run(() async {
          //   await getItem(pattern);
          // }),
          async {
        return await getItem(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: VccCheckboxTile(
            title: suggestion.label,
            enabled: widget.enabled,
            value: selectedItems
                .any((element) => element.value == suggestion.value),
            onChanged: (value) {
              boxController;
              textController.clear();
              setState(() {
                if (selectedItems
                    .any((element) => element.value == suggestion.value)) {
                  selectedItems.removeWhere(
                      (element) => element.value == suggestion.value);
                } else {
                  selectedItems.add(suggestion);
                }
              });
              if (widget.onSelectionChange != null) {
                widget.onSelectionChange!(selectedItems);
              }
            },
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      hideOnEmpty: true,
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onSelectionChange(value);
      },
    );
  }
}

class SccTypeAheadPayLoad extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String? hintText, selectedItem, apiKeyPayload;
  final String url, apiKeyLabel, apiKeyValue;
  final Function(String?) onError;
  final Function(KeyVal) onSelectionChange;
  final String? Function(String?)? validator;
  final Function() onLogout;
  final Function(String?)? onStrChange;
  final Map<String, String>? additionalParam;
  final Widget? suffix;
  final TextStyle? style;
  final bool readOnly, enabled, enableBorderColor;
  final bool? isDense, hideKeyboard, formBehaviour;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color? fillColor, focusColor, idleColor, hoverColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const SccTypeAheadPayLoad(
      {super.key,
      this.isDense,
      this.margin,
      this.suffix,
      this.selectedItem,
      required this.onLogout,
      required this.onError,
      required this.onSelectionChange,
      required this.url,
      required this.apiKeyLabel,
      required this.apiKeyValue,
      this.apiKeyPayload,
      this.onStrChange,
      this.validator,
      this.additionalParam,
      this.formBehaviour,
      this.readOnly = false,
      this.enabled = true,
      this.hideKeyboard,
      this.fillColor,
      this.focusColor,
      this.hoverColor,
      this.idleColor,
      this.style,
      this.focusNode,
      this.hintText = '',
      this.borderRadius = 8,
      this.fontSize,
      this.fontWeight,
      this.enableBorderColor = false});

  @override
  State<SccTypeAheadPayLoad> createState() => _SccTypeAheadPayLoadState();
}

class _SccTypeAheadPayLoadState extends State<SccTypeAheadPayLoad> {
  final boxController = SuggestionsBoxController();
  late TextEditingController textController;
  // String? selectedItem;
  // Timer? timer;
  // List<String> options = [];
  DatabaseHelper db = DatabaseHelper();
  RestApi api = RestApi();
  Debouncer debouncer = Debouncer();
  FocusNode focusNode = FocusNode();
  bool valid = false;
  Color fillColor = sccFillLoginField;

  @override
  void initState() {
    textController = TextEditingController();
    // selectedItem = widget.selectedItem;
    textController.value =
        textController.value.copyWith(text: widget.selectedItem);

    if (widget.formBehaviour ?? false) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          setState(() {
            fillColor = sccWhite;
          });
        } else {
          setState(() {
            fillColor = sccFillLoginField;
          });
        }
      });
    }
    super.initState();
  }

  Future<List<KeyVal>> getItem(String pattern) async {
    List<KeyVal> matches = [];
    try {
      Login? log = await db.getUser();
      if (log == null) {
        throw InvalidSessionExpression();
      }
      // if (timer != null) {
      //   timer!.cancel();
      // }
      // timer = Timer(Duration(milliseconds: 800), () async {
      Map<String, String> param = {
        widget.apiKeyLabel: pattern,
        "pageNo": "1",
        "pageSize": "1000",
      };
      if (widget.additionalParam != null) {
        param.addAll(widget.additionalParam!);
      }
      String url = widget.url;
      var resp = await api.customUrlGet(
        url: url,
        header: {
          "Authorization": "${log.tokenType!} ${log.accessToken!}",
        },
        param: param,
      ) as Map<String, dynamic>;
      List list = resp['listData'];
      for (var element in list) {
        if (element is Map) {
          matches.add(KeyVal(
            element[widget.apiKeyLabel],
            element[widget.apiKeyValue],
            payload: (widget.apiKeyPayload != null)
                ? element[widget.apiKeyPayload]
                : element,
          ));
        }
      }

      // });
    } catch (e) {
      if (e is InvalidSessionExpression) {
        widget.onLogout();
      } else {
        widget.onError(e.toString());
      }
    }
    // matches.add(KeyVal("Tester", "Tester"));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<KeyVal>(
      suggestionsBoxController: boxController,
      validator: (value) {
        if (widget.validator != null) {
          setState(() {
            if (value == null || value.isEmpty) {
              valid = true;
            } else {
              valid = false;
            }
          });
          return widget.validator!(value);
        } else {
          return null;
        }
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: textController,
        enabled:
            //  options.isNotEmpty &&
            widget.enabled,
        onTap: () => boxController,
        onChanged: (val) {
          // if (!boxController.isOpened() && !options.any((element) => element == val)) {
          //   boxController;
          // }
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
        },
        onEditingComplete: () {
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        onSubmitted: (val) {
          // setState(() {
          //   selectedItem = val;
          // });
          if (widget.onStrChange != null) {
            widget.onStrChange!(val);
          }
          widget.onStrChange!(val);
          // widget.onSelectionChange(val);
          if (!boxController.isOpened()) {
            boxController;
          }
        },
        style: widget.style ??
            TextStyle(
              color: sccBlack,
              fontSize: widget.fontSize ?? context.scaleFont(15),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              overflow: TextOverflow.fade,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,

          hintStyle: widget.style ??
              TextStyle(
                color: sccText4,
                fontSize: widget.fontSize ?? context.scaleFont(16),
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                overflow: TextOverflow.fade,
              ),
          suffixIcon: widget.enabled
              ? widget.suffix ??
                  IconButton(
                    onPressed: () {
                      if (widget.enabled) {
                        boxController;
                        textController.selection = TextSelection(
                            baseOffset: textController.text.length,
                            extentOffset: textController.text.length);
                      }
                    },
                    splashRadius: 10,
                    icon: HeroIcon(
                      HeroIcons.chevronDown,
                      size: context.scaleFont(28),
                      color: sccButtonBlue,
                    ),
                  )
              : Container(
                  width: 1,
                ),
          // suffixIconColor: sccButtonBlue,
          isDense: widget.isDense,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabled: widget.enabled,
          // labelText: widget.label,
          // labelStyle: TextStyle(
          //   fontSize: context.scaleFont(14),
          //   color: sccBlack,
          // ),
          filled: true,
          hoverColor: widget.hoverColor ?? sccFillField,
          fillColor: (widget.fillColor != null)
              ? widget.fillColor
              : (!widget.enabled)
                  ? sccDisabledTextField
                  : valid
                      ? sccValidateField
                      : fillColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                  color: widget.enableBorderColor ? sccBorder : sccBorder,
                  width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccBorder, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: (widget.formBehaviour ?? false)
                      ? widget.fillColor ?? sccButtonBlue
                      : sccBorder,
                  width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)), //
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: sccDanger, width: 0.5)),
        ),
      ),
      hideKeyboard: widget.hideKeyboard ?? false,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        constraints: BoxConstraints(maxHeight: context.deviceHeight() / 4),
        hasScrollbar: false,
      ),
      suggestionsBoxVerticalOffset: 8,
      suggestionsCallback: (pattern)
          // => debouncer.run(() async {
          //   await getItem(pattern);
          // }),
          async {
        return await getItem(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hoverColor: Colors.transparent,
            horizontalTitleGap: 8,
            minLeadingWidth: 10,
            onTap: () {
              boxController;
              textController.value =
                  textController.value.copyWith(text: suggestion.label);
              widget.onSelectionChange(suggestion);
            },
            leading: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlineGradientButton(
                onTap: () {
                  boxController;
                  textController.value =
                      textController.value.copyWith(text: suggestion.label);
                  widget.onSelectionChange(suggestion);
                },
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: widget.selectedItem != null &&
                          widget.selectedItem == suggestion.value
                      ? [
                          sccButtonBlue,
                          sccButtonBlue,
                        ]
                      : [
                          sccInfoGrey,
                          sccInfoGrey,
                        ],
                ),
                strokeWidth: widget.selectedItem != null &&
                        widget.selectedItem == suggestion.value
                    ? 1
                    : 0.5,
                padding: const EdgeInsets.all(1),
                radius: const Radius.circular(125),
                child: GradientWidget(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.selectedItem != null &&
                            widget.selectedItem == suggestion.value
                        ? [
                            sccButtonBlue,
                            sccButtonBlue,
                          ]
                        : [
                            Colors.transparent,
                            Colors.transparent,
                          ],
                  ),
                  child: Icon(
                    Icons.circle,
                    size: context.scaleFont(13),
                  ),
                ),
              ),
            ),
            title: Text(
              suggestion.label,
              style: TextStyle(
                color: sccBlack,
                fontSize: context.scaleFont(14),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      loadingBuilder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      hideOnEmpty: true,
      onSuggestionSelected: (value) {
        // textController.value = textController.value.copyWith(text: value.label);
        // widget.onSelectionChange(value);
      },
    );
  }
}
