import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/bloc/mst_usr_role/bloc/mst_usr_role_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/user_role.dart';
import 'package:scc_web/shared_widgets/buttons.dart';
import 'package:scc_web/theme/colors.dart';

class ViewDialogUserRole extends StatefulWidget {
  final Function onEdit;
  const ViewDialogUserRole({super.key, required this.onEdit});

  @override
  State<ViewDialogUserRole> createState() => _ViewDialogUserRoleState();
}

class _ViewDialogUserRoleState extends State<ViewDialogUserRole> {
  @override
  void initState() {
    super.initState();
  }

  late MasterRoleSubmit? model;
  List<Role> listRole = [];
  List<String>? roleCd;
  @override
  Widget build(BuildContext context) {
    return BlocListener<MstUsrRoleBloc, MstUsrRoleState>(
      listener: (context, state) {
        if (state is LoadShape) {
          model = state.model;

          if (model!.roleList != null) {
            listRole.clear();
            listRole.addAll(model!.roleList!);
          }
        }
      },
      child: BlocBuilder<MstUsrRoleBloc, MstUsrRoleState>(
        builder: (context, state) {
          if (state is! LoadShape) {
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
              child: Container(
                width: context.deviceWidth(),
                padding: isMobile
                    ? const EdgeInsets.only(
                        left: 8, right: 8, top: 28, bottom: 12)
                    : const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Brand'),
                              Text(
                                model!.brand ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Fullname'),
                              Text(
                                model!.fullName ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Phone number'),
                              Text(
                                model!.phoneNumber ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Username'),
                              Text(
                                model!.username ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Company'),
                              Text(
                                model!.companyName ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Division'),
                              Text(
                                model!.division ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Email Address'),
                              Text(
                                model!.email ?? "",
                                style: TextStyle(
                                    color: sccBlack,
                                    fontSize: context.scaleFont(14),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Roles'),
                                  SizedBox(
                                    height: context.deviceHeight() * 0.1,
                                    width: context.deviceWidth() * 0.25,
                                    child: ListView.builder(
                                      itemCount: (listRole.length / 2)
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
                                                "${listRole[rowIndex * 2].roleCd} , ",
                                                style: TextStyle(
                                                  fontSize:
                                                      context.scaleFont(12),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), // Item pertama dalam baris

                                              if (rowIndex * 2 + 1 <
                                                  listRole
                                                      .length) // Memastikan ada item kedua dalam baris
                                                Text(
                                                  "${listRole[rowIndex * 2 + 1].roleCd} , ",
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(),
                      ],
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
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
