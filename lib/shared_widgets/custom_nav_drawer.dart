// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
// import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
// import 'package:scc_web/helper/app_route.gr.dart';

// import 'package:scc_web/helper/app_scale.dart';
// import 'package:scc_web/helper/assisted_auto_route.dart';
// import 'package:scc_web/helper/constant.dart';
// import 'package:scc_web/helper/locator.dart';
// import 'package:scc_web/model/login.dart';
// import 'package:scc_web/model/menu.dart';
// import 'package:scc_web/shared_widgets/menu_list/menu_child.dart';
// import 'package:scc_web/shared_widgets/menu_list/parent_menu.dart';
// import 'package:scc_web/shared_widgets/menu_list/single_menu.dart';

// class PersistDrawer extends StatefulWidget {
//   final String? initialScreen;
//   final bool isExpanded;
//   final Function()? optionalCallback;
//   final Function(String?) onRoute;

//   const PersistDrawer({
//     this.isExpanded = true,
//     this.initialScreen,
//     required this.onRoute,
//     Key? key,
//     this.optionalCallback,
//   }) : super(key: key);

//   @override
//   _PersistDrawerState createState() => _PersistDrawerState();
// }

// class _PersistDrawerState extends State<PersistDrawer> {
//   String? selectedRoute;
//   List<Menu> listMenu = [];
//   List<Menu> listTransactionChildren = [];
//   List<Menu> listTpChildren = [];

//   Login? login;

//   @override
//   void initState() {
//     super.initState();
//     selectedRoute = selectedRoute;
//     locator<AppRouter>().addListener(() {
//       routeListener();
//     });
//   }

//   routeListener() {
//     if (!mounted) return;
//     setState(() {
//       selectedRoute = locator<AppRouter>().current.path;
//     });
//   }

//   authBloc(AuthEvent event) {
//     BlocProvider.of<AuthBloc>(context).add(event);
//   }

//   bloc(HomeEvent event) {
//     BlocProvider.of<HomeBloc>(context).add(event);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = ScrollController();
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthLoggedOut) {
//               context.push(LoginRoute());
//             }
//           },
//         ),
//         BlocListener<HomeBloc, HomeState>(
//           listener: (context, state) {
//             if (state is LoadHome) {
//               login = state.login;
//             }

//             if (state is OnLogoutHome) {
//               authBloc(AuthLogin());
//             }
//             if (state is MenuLoaded) {
//               login = state.login;
//               listMenu.clear();
//               listMenu.addAll(state.listMenu);
//             }
//           },
//         ),
//       ],
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.fastOutSlowIn,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           // border: Border(
//           //   right: BorderSide(color: Colors.grey),
//           // ),
//         ),
//         width: context.deviceWidth() *
//             ((context.isWideScreen() && widget.isExpanded) ? 0.170 : 0.065),
//         child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
//           if (state is HomeLoading) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return Scrollbar(
//               controller: controller,
//               child: ListView(
//                 controller: controller,
//                 padding: const EdgeInsets.all(8),
//                 children: listMenu.isNotEmpty
//                     ? listMenu.map((e) {
//                         if ((e.menuTypeCd ?? "")
//                             .toUpperCase()
//                             .contains("PARENT")) {
//                           return ParentMenu(
//                               title: e.menuName!,
//                               isActive: selectedRoute
//                                       ?.toLowerCase()
//                                       .contains(e.menuName!.toLowerCase()) ==
//                                   true,
//                               children: e.childs!.map((element) {
//                                 return MenuChild(
//                                   titleStr: element.menuName!,
//                                   isSelected: selectedRoute
//                                           ?.toLowerCase()
//                                           .contains(
//                                               element.menuName!.toLowerCase()) ==
//                                       true,
                                      
//                                   onPressed: () {
//                                     setState(() {
//                                       selectedRoute = element.menuCd;
//                                     });
//                                     widget.onRoute(selectedRoute);
//                                   },
//                                 );
//                               }).toList());
//                         }
//                         return SingleMenu(
//                           onRoute: () {
//                             setState(() {
//                               selectedRoute = e.menuCd;
//                             });
//                             widget.onRoute(selectedRoute);
//                           },
//                           title: e.menuName!,
//                           isSelected: selectedRoute
//                                   ?.toLowerCase()
//                                   .contains(e.menuName!.toLowerCase()) ==
//                               true,
//                         );
//                       }).toList()
//                     : [
//                         SingleMenu(
//                           icon: HeroIcon(
//                             HeroIcons.home,
//                             size: context.scaleFont(20),
//                           ),
//                           title: "Dashboard",
//                           isSelected: selectedRoute
//                                   ?.toLowerCase()
//                                   .contains("dashboard") ==
//                               true,
//                           onRoute: () {
//                             setState(() {
//                               selectedRoute = Constant.dashboard;
//                             });
//                             widget.onRoute(selectedRoute);
//                           },
//                         ),
//                         SingleMenu(
//                           title: "Register Product",
//                           icon: HeroIcon(
//                             HeroIcons.folderPlus,
//                             size: context.scaleFont(20),
//                           ),
//                           isSelected: selectedRoute
//                                   ?.toLowerCase()
//                                   .contains("product") ==
//                               true,
//                           onRoute: () {
//                             setState(() {
//                               selectedRoute = Constant.product;
//                             });
//                             widget.onRoute(selectedRoute);
//                           },
//                         ),
//                         ParentMenu(
//                           title: "Master",
//                           icon: const HeroIcon(HeroIcons.document),
//                           isActive:
//                               selectedRoute?.toLowerCase().contains("master") ==
//                                   true,
//                           children: [
//                             MenuChild(
//                                 titleStr: "Approval Item",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("approval_Item") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.approval_Item;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Role",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("role") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.role;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Package",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("package") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.package;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Supplier",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("supplier") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.supplier;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Admin",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("admin") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.admin;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Assign Master Item",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("item") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.item;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Attributes",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("attributes") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.attributes;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Template Attribute",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("tempAttribute") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.tempAttribute;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Point",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("point") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.point;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Product",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("product") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.mstProduct;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Use Case",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("UseCase") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.useCase;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                           ],
//                         ),
//                         ParentMenu(
//                           title: "Subscription",
//                           icon: const HeroIcon(HeroIcons.currencyDollar),
//                           isActive: selectedRoute
//                                   ?.toLowerCase()
//                                   .contains("subscription") ==
//                               true,
//                           children: [
//                             MenuChild(
//                                 titleStr: "Subscribers",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("subscribers") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.subscribers;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                             MenuChild(
//                                 titleStr: "Subscribtion",
//                                 isSelected: selectedRoute
//                                         ?.toLowerCase()
//                                         .contains("subscription") ==
//                                     true,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedRoute = Constant.subscription;
//                                   });
//                                   widget.onRoute(selectedRoute);
//                                 }),
//                           ],
//                         ),
//                       ],
//               ),
//             );
//           }
//         }),
//       ),
//     );
//   }
// }
