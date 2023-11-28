// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
// import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
// import 'package:scc_web/helper/app_route.gr.dart';
// import 'package:scc_web/helper/app_scale.dart';
// import 'package:scc_web/helper/assisted_auto_route.dart';
// import 'package:scc_web/helper/constant.dart';
// import 'package:scc_web/helper/db_helper.dart';
// import 'package:scc_web/model/login.dart';
// import 'package:scc_web/model/menu.dart';
// import 'package:scc_web/shared_widgets/nav_drawer_menu.dart';
// import 'package:scc_web/shared_widgets/redirect_dialog.dart';
// import 'package:scc_web/shared_widgets/scroll_to_index.dart';
// import 'package:scc_web/theme/colors.dart';

// class PersistDrawer extends StatefulWidget {
//   final Function()? optionalCallback;
//   final Function(List<Menu>)? onMenuLoaded;
//   final String selectedTile;
//   final bool initiallyExpanded;

//   const PersistDrawer({
//     required this.selectedTile,
//     this.optionalCallback,
//     this.onMenuLoaded,
//     this.initiallyExpanded = true,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _PersistDrawerState createState() => _PersistDrawerState();
// }

// class _PersistDrawerState extends State<PersistDrawer> {
//   // late bool isExpanded;
//   double initialScrollOffsett = 0;
//   bool initiallyExpanded = true;
//   // bool permission = true;
//   late bool isTransactionExpanded;
//   Login? login;
//   late AutoScrollController navDrawerController;

//   bool isLoading = true;
//   List<Menu> listMenu = [];

//   @override
//   void initState() {
//     navDrawerController = AutoScrollController(
//         viewportBoundaryGetter: () =>
//             Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
//         axis: Axis.vertical);
//     isTransactionExpanded = (widget.selectedTile == Constant.admin ||
//         widget.selectedTile == Constant.username); //&& isExpanded;
//     // navDrawerController.addListener(() => _scrollListener());
//     initiallyExpanded = widget.initiallyExpanded;
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       // navDrawerController.addListener(() => _scrollListener());
//       // _scrollToIndex(listMenu.indexWhere((element) => element.menuCd == widget.selectedTile));
//     });
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(PersistDrawer oldWidget) {
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       setState(() {
//         initiallyExpanded = widget.initiallyExpanded;
//       });
//     });
//     super.didUpdateWidget(oldWidget);
//   }

//   Future _scrollToIndex(int index) async {
//     if (!index.isNegative && index <= listMenu.length) {
//       await navDrawerController.scrollToIndex(index,
//           preferPosition: AutoScrollPosition.begin);
//     }
//   }

//   bool checkMenu(List<Menu> list) {
//     bool valid = false;

//     for (Menu menu in list) {
//       if (menu.menuCd == widget.selectedTile) {
//         valid = true;
//         break;
//       } else if (menu.childs != null && menu.childs!.isNotEmpty) {
//         valid = checkMenu(menu.childs!);
//         if (valid) break;
//       }
//     }
//     // }
//     return valid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if (!context.isDesktop()) isExpanded = false;
//     authBloc(AuthEvent event) {
//       BlocProvider.of<AuthBloc>(context).add(event);
//     }

//     bloc(HomeEvent event) {
//       BlocProvider.of<HomeBloc>(context).add(event);
//     }

//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       // reverseDuration: Duration(),
//       curve: Curves.fastOutSlowIn,
//       width: context.deviceWidth() *
//           ((context.isWideScreen() && widget.initiallyExpanded) ? 0.16 : 0.065),
//       // width: context.deviceWidth() * ((context.isWideScreen() && widget.initiallyExpanded) ? 0.16 : 0.065),
//       color: sccWhite,
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<AuthBloc, AuthState>(
//             listener: (context, state) {
//               if (state is AuthLoggedOut) {
//                 context.push(LoginRoute());
//                 isLoading = false;
//               }
//             },
//           ),
//           BlocListener<HomeBloc, HomeState>(
//             listener: (context, state) {
//               if (state is LoadHome) {
//                 login = state.login;
//               }
//               if (state is OnLogoutHome) {
//                 authBloc(AuthLogin());
//               }
//               if (state is MenuLoaded) {
//                 login = state.login;
//                 listMenu.clear();
//                 listMenu.addAll(state.listMenu);
//                 if (widget.onMenuLoaded != null) {
//                   widget.onMenuLoaded!(listMenu);
//                 }
//                 // listMenu.add(Menu(
//                 //   menuCd: Constant.PACKAGE_LIST,
//                 //   menuName: "Subscriber",
//                 //   menuTypeCd: "MNT_MENU",
//                 //   menuSeq: 200,
//                 // ));
//                 listMenu.sort(
//                     (a, b) => (a.menuSeq ?? 0).compareTo(b.menuSeq ?? 1000));
//                 if (!checkMenu(listMenu) &&
//                     widget.selectedTile != Constant.home &&
//                     widget.selectedTile != Constant.packageName) {
//                   showDialog(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (ctx) {
//                       return RedirectDialog(
//                         onTap: () async {
//                           await DatabaseHelper().dbClear();
//                           context.push(LoginRoute());
//                         },
//                       );
//                     },
//                   );
//                 }
//                 setState(() {});
//               }
//               if (state is HomeLoading) {
//                 isLoading = true;
//               } else {
//                 isLoading = false;
//               }
//             },
//           ),
//         ],
//         child: BlocBuilder<HomeBloc, HomeState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                     ),
//                     child: listMenu.isNotEmpty
//                         ? NavDrawerMenu(
//                             isLoading: isLoading,
//                             listMenu: listMenu,
//                             navDrawerController: navDrawerController,
//                             isExpanded: context.isWideScreen() &&
//                                 widget.initiallyExpanded,
//                             onLogout: () => bloc(DoLogout()),
//                             optionalCallback: () {
//                               if (widget.optionalCallback != null) {
//                                 widget.optionalCallback!();
//                               }
//                             },
//                             selectedTile: widget.selectedTile,
//                             onWidgetBuilt: () {
//                               int index = listMenu.indexWhere(
//                                   (element) =>
//                                       element.menuCd == widget.selectedTile ||
//                                       (element.childs != null &&
//                                           element.childs!.any((element) =>
//                                               element.menuCd ==
//                                               widget.selectedTile)),
//                                   1);
//                               _scrollToIndex(index);
//                             },
//                           )
//                         : SizedBox(),
//                   ),
//                 ),
//                 // ! use this space for menu test
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
