import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_template_attribute/bloc/template_attribute_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/temp_attr.dart';
import 'package:scc_web/screens/master_template_attr/lov_attr_cd_item.dart';
import 'package:scc_web/shared_widgets/custom_textfield_new.dart';
import 'package:scc_web/shared_widgets/empty_container.dart';
import 'package:scc_web/shared_widgets/new_paging_display.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/theme/colors.dart';

class LovAttributeCd extends StatelessWidget {
  final Function(AttrCodeClass) onAttrCdSelected;

  const LovAttributeCd({super.key, required this.onAttrCdSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TemplateAttributeBloc()
        ..add(SearchAttributeCd(
          paging: Paging(pageNo: 1, pageSize: 5),
          attrCd: '',
        )),
      child: LovAttributeBody(
        onAttrCdSelected: (value) => onAttrCdSelected(value),
      ),
    );
  }
}

class LovAttributeBody extends StatefulWidget {
  final Function(AttrCodeClass) onAttrCdSelected;

  const LovAttributeBody({super.key, required this.onAttrCdSelected});

  @override
  State<LovAttributeBody> createState() => _LovAttributeBodyState();
}

class _LovAttributeBodyState extends State<LovAttributeBody> {
  late ScrollController controller;
  late TextEditingController searchCo;

  String? searchVal;
  late KeyVal selectedSearch;
  List<KeyVal> listSearchBy = [];
  List<AttrCodeClass> listAttribute = [];
  AttrCodeClass model = AttrCodeClass(attributeName: "");

  Paging paging = Paging(pageNo: 1, pageSize: 5);

  @override
  void initState() {
    controller = ScrollController();
    searchCo = TextEditingController();
    listSearchBy.add(KeyVal("Attribute Name", Constant.attributeName));
    listSearchBy.add(KeyVal("Attribute Code", Constant.attributeCd));
    selectedSearch = listSearchBy[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc(TemplateAttributeEvent event) {
      BlocProvider.of<TemplateAttributeBloc>(context).add(event);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.isDesktop()
          ? EdgeInsets.symmetric(
              horizontal: (context.deviceWidth() * 0.1),
              vertical: (context.deviceHeight() * 0.1),
            )
          : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: BlocListener<TemplateAttributeBloc, TemplateAttributeState>(
        listener: (context, state) {
          if (state is LoadAttribute) {
            if (state.paging != null) paging = state.paging!;
            listAttribute.clear();
            listAttribute.addAll(state.listAttr);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sccWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      'Select Attribute code',
                      style: TextStyle(
                        fontSize: context.scaleFont(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => context.back(),
                        icon: const Icon(Icons.close),
                        color: sccText2,
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: SelectableText(
                  'Search by : ',
                  style: TextStyle(
                    fontSize: context.scaleFont(18),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // flex: 2,
                      Expanded(
                        flex: 1,
                        child: PortalFormDropdownKeyVal(
                          selectedSearch,
                          listSearchBy,
                          // enabled: searchCat.length > 1,
                          // borderRadius: 12,
                          onChange: (value) {
                            setState(() {
                              selectedSearch = value;
                            });
                          },
                        ),
                      ),
                      // Expanded(
                      // child: TADropdown(
                      //   selectedSearch,
                      //   listSearchBy,
                      //   fillColor: sccWhite,
                      //   enableBorderColor: true,
                      //   borderRadius: 12,
                      //   onChange: (value) {
                      //     selectedSearch = value.trim();
                      //   },
                      // ),
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomSearchFieldNew(
                          borderRadius: 12,
                          enableBorderColor: true,
                          controller: searchCo,
                          prefix: searchCo.text.isNotEmpty
                              ? IconButton(
                                  // splashRadius: 0,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      searchCo.clear();
                                      searchVal = '';
                                      bloc(SearchAttributeCd(
                                        attrCd: searchVal,
                                        attrName: searchVal,
                                      ));
                                    });
                                  },
                                  icon: const HeroIcon(
                                    HeroIcons.xCircle,
                                    color: sccText4,
                                  ),
                                )
                              : null,
                          onChanged: (value) {
                            setState(() {
                              searchVal = value?.trim();
                            });
                          },
                          onAction: (value) {
                            model = AttrCodeClass(
                              attributeCd:
                                  selectedSearch.value == Constant.attributeCd
                                      ? value
                                      : null,
                              attributeName:
                                  selectedSearch.value == Constant.attributeName
                                      ? value
                                      : null,
                            );
                            paging.pageNo = 1;
                            bloc(SearchAttributeCd(
                              paging: paging,
                              attrCd: model.attributeCd,
                              attrName: model.attributeName,
                            ));
                          },
                          onSearch: () {
                            model = AttrCodeClass(
                              attributeCd:
                                  selectedSearch.value == Constant.attributeCd
                                      ? searchVal
                                      : null,
                              attributeName:
                                  selectedSearch.value == Constant.attributeName
                                      ? searchVal
                                      : null,
                            );
                            paging.pageNo = 1;
                            bloc(SearchAttributeCd(
                              paging: paging,
                              attrCd: model.attributeCd,
                              attrName: model.attributeName,
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SizedBox(
                  child: BlocBuilder<TemplateAttributeBloc,
                      TemplateAttributeState>(
                    builder: (context, state) {
                      if (state is TemplateAttributeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TemplateAttributeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SelectableText(
                                  "Oops! something went wrong. Please,  try again later. Disini"),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    searchCo.clear();
                                    searchVal = '';
                                    searchVal = "";
                                    model = AttrCodeClass(attributeCd: "");
                                    paging.pageNo = 1;
                                    bloc(SearchAttributeCd(
                                      paging: paging,
                                      attrCd: model.attributeCd,
                                    ));
                                  },
                                  child: const Icon(Icons.refresh_outlined))
                            ],
                          ),
                        );
                      } else {
                        if (listAttribute.isNotEmpty) {
                          return Scrollbar(
                            controller: controller,
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              controller: controller,
                              child: Column(
                                children: [
                                  Column(
                                    children: listAttribute.map((element) {
                                      return LovAttributeCodeItem(
                                        attrCd: element.attributeCd,
                                        attrName: element.attributeName,
                                        attrDataTypeLen:
                                            element.attrDataTypeLen,
                                        attrDataTypePrec:
                                            element.attrDataTypePrec,
                                        attrDesc: element.attrDesc,
                                        attrApiKey: element.attrApiKey,
                                        dataType: element.attrDataTypeCd,
                                        onPick: () {
                                          context.back();
                                          widget.onAttrCdSelected(element);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Visibility(
                                    visible: paging.totalPages != null &&
                                        paging.totalPages! > 1,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: PagingDisplayNew(
                                        pageNo: paging.pageNo!,
                                        pageToDisplay: isMobile ? 3 : 5,
                                        totalPages: paging.totalPages,
                                        totalRows: paging.pageSize,
                                        onChangeTotalData: (value) {
                                          paging.pageNo = 1;
                                          paging.pageSize = value;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                        onClickFirstPage: () {
                                          paging.pageNo = 1;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                        onClickPrevious: () {
                                          paging.pageNo = paging.pageNo! - 1;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                        onClick: (value) {
                                          paging.pageNo = value;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                        onClickNext: () {
                                          paging.pageNo = paging.pageNo! + 1;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                        onClickLastPage: () {
                                          paging.pageNo = paging.totalPages;
                                          bloc(SearchAttributeCd(
                                            paging: paging,
                                            attrCd: model.attributeCd,
                                            attrName: model.attributeName,
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const EmptyContainer();
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
