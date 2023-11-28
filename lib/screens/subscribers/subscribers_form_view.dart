import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/subs/bloc/subs_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/countries.dart';
import 'package:scc_web/model/subscribers.dart';
import 'package:scc_web/shared_widgets/custom_textfield.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/shared_widgets/buttons.dart';

class SubscribersFormViewBody extends StatefulWidget {
  const SubscribersFormViewBody({super.key});

  @override
  State<SubscribersFormViewBody> createState() =>
      _SubscribersFormViewBodyState();
}

class _SubscribersFormViewBodyState extends State<SubscribersFormViewBody> {
  final scroll = ScrollController();
  bool checked = false;
  bool checked2 = false;
  ListSubsTable submitModel = ListSubsTable();
  final fullNameCo = TextEditingController();
  final emailCo = TextEditingController();
  final companyName = TextEditingController();
  final abbreviationName = TextEditingController();
  final industryType = TextEditingController();
  final packageTime = TextEditingController();
  final phoneCo = TextEditingController();
  final country = TextEditingController();
  final companyCo = TextEditingController();
  final msgCo = TextEditingController();
  List<Countries>? listCountry = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubsBloc, SubsState>(
      listener: (context, state) {
        if (state is ViewSubs) {
          setState(() {
            submitModel = state.data!;
            listCountry = state.listCountry;
          });

          for (var element in listCountry!) {
            if (submitModel.countryId == element.countryId) {
              country.text = element.countryName!;
            }
          }
          emailCo.text = submitModel.email!;
          fullNameCo.text = submitModel.fullName!;
          companyName.text = submitModel.companyName!;
          abbreviationName.text = submitModel.email!;
          industryType.text = submitModel.industryType!;
          packageTime.text = "${submitModel.packageTime} Month";
          phoneCo.text = submitModel.phoneNumber!;
          companyCo.text = submitModel.companyCd!;
          msgCo.text = submitModel.msgText!;
          checked = submitModel.aggrement!;
          checked2 = submitModel.consent!;
        }
      },
      child: BlocBuilder<SubsBloc, SubsState>(builder: (context, state) {
        if (state is SubsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: sccBlue,
            ),
          );
        } else {
          return Dialog(
            insetPadding: kIsWeb && !isWebMobile
                ? EdgeInsets.symmetric(
                    horizontal: (context.deviceWidth() * 0.08),
                    vertical: (context.deviceHeight() * 0.05),
                  )
                : const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !isMobile,
                  child: Container(
                    width: context.deviceWidth(),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: sccButtonGrey,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Tooltip(
                                    message: "close",
                                    decoration: BoxDecoration(
                                      color: sccBlack.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    textStyle: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: sccWhite,
                                      fontSize: context.scaleFont(14),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        context.back();
                                      },
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        // color: sccRed,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
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
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      'Package : ${submitModel.packageName ?? '-'}',
                                      style: const TextStyle(
                                          color: sccBlack,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: scroll,
                    child: SingleChildScrollView(
                      controller: scroll,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FocusTraversalGroup(
                            descendantsAreFocusable: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Full Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: fullNameCo,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Company Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: companyName,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Abbreviation Company',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: abbreviationName,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Industries Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: industryType,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: emailCo,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Country',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  enabled: false,
                                  controller: country,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: phoneCo,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Package Time',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  controller: packageTime,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Message',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomFormTextField(
                                  enabled: false,
                                  minLine: 5,
                                  controller: msgCo,
                                ),
                                const SizedBox(height: 20),
                                CheckboxListTile(
                                  title: const Text(
                                      'I have read and I Agree to the privacy policy.'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: checked,
                                  onChanged: (value) {
                                    setState(() {
                                      checked = value!;
                                    });
                                  },
                                  enabled: false,
                                  activeColor: sccButtonPurple,
                                  checkColor: sccBlack,
                                ),
                                // const SizedBox(height: 5),
                                CheckboxListTile(
                                  title: const Text(
                                      'I consent to receiving promotional emails from SCC, including marketing offers and product updates'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: checked2,
                                  enabled: false,
                                  onChanged: (value) {
                                    setState(() {
                                      checked2 = value!;
                                    });
                                  },
                                  activeColor: sccButtonPurple,
                                  checkColor: sccBlack,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonConfirm(
                                      width: context.deviceWidth() * 0.085,
                                      text: 'OK',
                                      colour: sccButtonPurple,
                                      textColour: sccWhite,
                                      onTap: () {
                                        context.back();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
