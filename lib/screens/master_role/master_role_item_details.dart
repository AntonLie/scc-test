// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/new_edit_role/bloc/new_edit_role_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/constant.dart';

import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/new_edit_role.dart';
import 'package:scc_web/shared_widgets/ta_dropdown.dart';
import 'package:scc_web/shared_widgets/vcc_checkbox_tile.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:styled_text/styled_text.dart';

class NewEditRoleItemDetail extends StatefulWidget {
  final String formMode;
  final List<KeyVal> listMenuDrpdwnDetail;
  final ListMenuFeat model;
  final Function(Key?) onClose;
  final Function(List<ListFeature>) onChangeFeature;
  const NewEditRoleItemDetail({
    Key? key,
    required this.formMode,
    required this.listMenuDrpdwnDetail,
    required this.model,
    required this.onClose,
    required this.onChangeFeature,
  }) : super(key: key);

  // @override
  // State<NewEditRoleItemDetail> createState() => _NewEditRoleItemDetailState();
  @override
  _TmplAttrDetailsItemsState createState() => _TmplAttrDetailsItemsState();
}

class _TmplAttrDetailsItemsState extends State<NewEditRoleItemDetail> {
  List<KeyVal> listMenuDrpdwnDetail = [];
  List<KeyVal> listMenuDetail = [];
  List<ListFeature> listFeature = [];

  String? selectedMenu;

  @override
  void initState() {
    listMenuDrpdwnDetail = widget.listMenuDrpdwnDetail;
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    widget.model.listFeature?.forEach((e) {
      listFeature.add(e);
    });
    if (widget.model.menuCd != null) {
      selectedMenu = widget.model.menuCd;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(NewEditRoleItemDetail oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        listMenuDrpdwnDetail = widget.listMenuDrpdwnDetail;
        listFeature.clear();
        widget.model.listFeature?.forEach((e) {
          listFeature.add(e);
        });
        if (widget.model.menuCd != null) {
          selectedMenu = widget.model.menuCd;
        }
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    bloc(NewEditRoleEvent event) {
      BlocProvider.of<NewEditRoleBloc>(context).add(event);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<NewEditRoleBloc, NewEditRoleState>(
          listener: (context, state) {
            if (state is ListFeatLoaded) {
              listFeature.clear();
              for (var e in state.listFeat) {
                listFeature.add(e);
              }
              widget.onChangeFeature(listFeature);
              widget.model.listFeature = List.from(listFeature);
            }
          },
        ),
      ],
      child: SizedBox(
        width: context.deviceWidth(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(
                  text:
                      'Menu${(widget.formMode != Constant.viewMode) ? ' <r>*</r>' : ''}',
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
                Visibility(
                  visible: widget.formMode != Constant.viewMode,
                  child: ExcludeFocus(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () => widget.onClose(widget.key),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: context.scaleFont(14),
                          fontWeight: FontWeight.w400,
                          color: sccDanger,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TAFormDropdown(
              selectedMenu,
              listMenuDrpdwnDetail,
              hideKeyboard: false,
              enabled: widget.formMode != Constant.viewMode,
              onChange: (value) {
                setState(() {
                  selectedMenu = value;
                  widget.model.menuCd = value;
                  widget.model.menuName = listMenuDrpdwnDetail
                      .firstWhere((e) => e.value == value)
                      .label;
                });
                bloc(GetFeatList(menuCd: selectedMenu));
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<NewEditRoleBloc, NewEditRoleState>(
              builder: (context, state) {
                return Wrap(
                    children: listFeature.isNotEmpty
                        ? listFeature.map((e) {
                            return VccCheckboxTileFitted(
                              title: e.featureName,
                              value: e.featureFlag,
                              enabled: widget.formMode != Constant.viewMode,
                              onChanged: (value) {
                                e.featureFlag = !(e.featureFlag ?? false);
                              },
                            );
                          }).toList()
                        : []);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
