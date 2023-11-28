import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/point/bloc/point_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/point.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogPoint extends StatefulWidget {
  final Function onEdit;
  const ViewDialogPoint({super.key, required this.onEdit});

  @override
  State<ViewDialogPoint> createState() => _ViewDialogPointState();
}

class _ViewDialogPointState extends State<ViewDialogPoint> {
  ViewPointModel model = ViewPointModel();
  @override
  Widget build(BuildContext context) {
    return BlocListener<PointBloc, PointState>(
      listener: (context, state) {
        if (state is PointView) {
          setState(() {
            model = state.model!;
          });
        }
      },
      child: BlocBuilder<PointBloc, PointState>(builder: (context, state) {
        if (state is! PointView) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
            child: SingleChildScrollView(
              child: Container(
                width: context.deviceWidth(),
                padding: isMobile
                    ? const EdgeInsets.only(
                        left: 8, right: 8, top: 28, bottom: 12)
                    : const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "View",
                          style: TextStyle(
                            fontSize: context.scaleFont(28),
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
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Information',
                      style: TextStyle(
                        fontSize: context.scaleFont(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Point Type'),
                              Text(
                                model.pointType ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(' Type'),
                              Text(
                                model.pointTypeCd ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Product Type'),
                              Text(
                                model.pointProductCd ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Node Blockchain'),
                              Text(
                                model.nodeBlockchain.toString(),
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Point Name'),
                              Text(
                                model.pointName ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Point Code surfix'),
                              Text(
                                model.pointCdSuffix ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Max Livenes (in seconds)'),
                              Text(
                                (model.maxLiveness ?? "-").toString(),
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Maximum Date'),
                              Text(
                                (model.maxConsumeDt ?? "-").toString(),
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: context.deviceWidth() * 0.45,
                          // color: sccAmber,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Point Description'),
                              Text(
                                model.pointDesc ?? "-",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Attribute ',
                      style: TextStyle(
                        fontSize: context.scaleFont(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Template Attribute'),
                                Text(
                                  model.tmplAttrCd ?? "-",
                                  style: TextStyle(
                                      color: sccBlack,
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('Out Date From Touch Point'),
                                Text(
                                  model.pointAttrInOutdate ?? "-",
                                  style: TextStyle(
                                      color: sccBlack,
                                      fontSize: context.scaleFont(14),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Attribute Key'),
                                    Text(
                                      model.attrKey.toString(),
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text('Out Date From Touch Point'),
                                    Text(
                                      model.pointAttrIndate ?? "-",
                                      style: TextStyle(
                                          color: sccBlack,
                                          fontSize: context.scaleFont(14),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]))
                        ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: isMobile
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.center,
                        children: [
                          ButtonCancel(
                            text: "Edit",
                            width: context.deviceWidth() *
                                (context.isDesktop() ? 0.11 : 0.35),
                            onTap: () {
                              widget.onEdit();
                            },
                          ),
                          SizedBox(
                            width: 8.wh,
                          ),
                          ButtonConfirm(
                            text: "Ok",
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
          );
        }
      }),
    );
  }
}
