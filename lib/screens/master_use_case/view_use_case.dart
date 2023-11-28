import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_use_case/bloc/use_case_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogUseCase extends StatefulWidget {
  final Function onEdit;
  const ViewDialogUseCase({super.key, required this.onEdit});

  @override
  State<ViewDialogUseCase> createState() => _ViewDialogUseCaseState();
}

class _ViewDialogUseCaseState extends State<ViewDialogUseCase> {
  ListUseCaseData? model;
  @override
  Widget build(BuildContext context) {
    return BlocListener<UseCaseBloc, UseCaseState>(
      listener: (context, state) {
        if (state is UseCaseForm) {
          model = state.model;
        }
      },
      child: BlocBuilder<UseCaseBloc, UseCaseState>(builder: (context, state) {
        if (state is! UseCaseForm) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Dialog(
              backgroundColor: sccWhite,
              insetPadding: context.isDesktop()
                  ? EdgeInsets.symmetric(
                      horizontal: (context.deviceWidth() * 0.22),
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
                      Row(
                        children: [
                          const Text('Last Update On :'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            model!.lastUpdateDt!,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('-'),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Last Update By :'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            model!.lastUpdateBy!,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.deviceWidth() * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bussiness Process Name & Code'),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${model!.useCaseCd!} & ${model!.useCaseName!}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Format Serial Number'),
                                const SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: model!.attrSerialNumber!.isNotEmpty,
                                  child: SizedBox(
                                    height: context.deviceHeight() * 0.1,
                                    width: context.deviceWidth() * 0.15,
                                    child: ListView.builder(
                                      itemCount: (model!
                                                  .attrSerialNumber!.length /
                                              2)
                                          .ceil(), // Jumlah baris, membagi data menjadi 2 per baris
                                      itemBuilder:
                                          (BuildContext context, int rowIndex) {
                                        // Membuat baris dalam ListView
                                        return SizedBox(
                                          height: 17,
                                          width: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${model!.attrSerialNumber![rowIndex * 2]} , ",
                                                style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(12),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), // Item pertama dalam baris

                                              if (rowIndex * 2 + 1 <
                                                  model!.attrSerialNumber!
                                                      .length) // Memastikan ada item kedua dalam baris
                                                Text(
                                                  "${model!.attrSerialNumber![rowIndex * 2 + 1]} , ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        context.scaleFont(12),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ), // Item kedua dalam baris
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: model!.attrSerialNumber!.isEmpty,
                                  child: const Text(
                                    "-",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bussiness Process Description'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              model!.useCaseDesc ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.deviceWidth() * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Start & End Date'),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${model!.startDt ?? ""} & ${model!.endDt ?? ""}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Touch Point',
                        style: TextStyle(
                            fontSize: context.scaleFont(18),
                            fontWeight: FontWeight.w700,
                            color: sccTextGray2),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: model!.listTouchPoint!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                        bottom: 10,
                                        right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 0.2, color: sccBlack)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sequence Point ${e.seq}',
                                          style: TextStyle(
                                              fontSize: context.scaleFont(18),
                                              fontWeight: FontWeight.w700,
                                              color: sccTextGray2),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                          color: sccLightGrayDivider,
                                          height: 25,
                                          thickness: 2,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text('Touch Point'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${model!.useCaseCd!} & ${model!.useCaseName!}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text('Point Code'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        e.pointCd!,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text('Type'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        e.pointType!,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: e.checkParent,
                                                    onChanged: (val) {}),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  'Check Master Consume',
                                                  style: TextStyle(
                                                      fontSize: context
                                                              .isFullScreen()
                                                          ? context
                                                              .scaleFont(12)
                                                          : context
                                                              .scaleFont(9)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: e.pointSupplierFlag,
                                                    onChanged: (val) {}),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  'Last Supplier Point',
                                                  style: TextStyle(
                                                      fontSize: context
                                                              .isFullScreen()
                                                          ? context
                                                              .scaleFont(12)
                                                          : context
                                                              .scaleFont(9)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: e.pointreceiveFlag,
                                                    onChanged: (val) {}),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  'Receiver Point',
                                                  style: TextStyle(
                                                      fontSize: context
                                                              .isFullScreen()
                                                          ? context
                                                              .scaleFont(12)
                                                          : context
                                                              .scaleFont(9)),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: e.blockchainFlag,
                                                    onChanged: (val) {}),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  'Push Blockchain',
                                                  style: TextStyle(
                                                      fontSize: context
                                                              .isFullScreen()
                                                          ? context
                                                              .scaleFont(12)
                                                          : context
                                                              .scaleFont(9)),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
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
                    ]),
              )));
        }
      }),
    );
  }
}
