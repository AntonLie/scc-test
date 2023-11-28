// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
// import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
// import 'package:scc_web/helper/app_route.gr.dart';
// import 'package:scc_web/helper/app_scale.dart';
// import 'package:scc_web/helper/constant.dart';
// import 'package:scc_web/shared_widgets/gradient_widgets.dart';
// import 'package:scc_web/bloc/bloc/auth_bloc.dart';
// import 'package:scc_web/bloc/bloc/home_bloc.dart';
// import 'package:scc_web/bloc/bloc/trace_bloc.dart';
// import 'package:scc_web/bloc/event/auth_event.dart';
// import 'package:scc_web/bloc/event/home_event.dart';
// import 'package:scc_web/bloc/state/auth_state.dart';
// import 'package:scc_web/bloc/state/home_state.dart';
// import 'package:scc_web/bloc/state/trace_state.dart';
// import 'package:scc_web/helper/approute.gr.dart';
// import 'package:scc_web/helper/assisted_auto_route.dart';
// import 'package:scc_web/helper/db_helper.dart';
// // import 'package:scc_web/helper/route_generator.dart';
// import 'package:scc_web/helper/scroll_to_index.dart';
// import 'package:scc_web/model/login.dart';
// import 'package:scc_web/model/menu.dart';
// import 'package:scc_web/model/tracing.dart';
// import 'package:scc_web/model/tracking_point.dart';
// import 'package:scc_web/shared_widgets/common_shimmer.dart';
// import 'package:collection/collection.dart';
// import 'package:scc_web/shared_widgets/expandable_widget.dart';
// import 'package:scc_web/shared_widgets/form_dialog.dart';
// import 'package:scc_web/shared_widgets/nav_drawer_menu.dart';
// import 'package:scc_web/shared_widgets/redirect_dialog.dart';
// import 'package:scc_web/shared_widgets/scroll_to_index.dart';
// // import 'package:scc_web/shared_widgets/parent_menu.dart';
// import 'package:scc_web/theme/colors.dart';
// import 'package:scc_web/ui/tracing/touch_point_timeline.dart';

// class NavDrawer extends StatefulWidget {
//   final String selectedTile;
//   final Function()? optionalCallback;
//   const NavDrawer(this.selectedTile, {this.optionalCallback});
//   @override
//   _NavDrawerState createState() => _NavDrawerState();
// }

// class _NavDrawerState extends State<NavDrawer> {
//   final navDrawerController = ScrollController();
//   Login? login;
//   List<Menu> listMenu = [];
//   List<Menu> listTransactionChildren = [];
//   List<Menu> listTpChildren = [];
//   bool isLoading = true;
//   bool isTransactionExpanded = false;

//   @override
//   void initState() {
//     isTransactionExpanded = (widget.selectedTile == Constant.TP_INPUT_FORM || widget.selectedTile == Constant.TP_UPLOAD);
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     authBloc(AuthEvent event) {
//       BlocProvider.of<AuthBloc>(context).add(event);
//     }

//     bloc(HomeEvent event) {
//       BlocProvider.of<HomeBloc>(context).add(event);
//     }

//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthLoggedOut) {
//               context.push(LoginRoute());
//               // locator<NavigatorService>()
//               //     .navigateReplaceTo(Constant.MENU_LOGIN);
//             }
//           },
//         ),
//         BlocListener<HomeBloc, HomeState>(
//           listener: (context, state) {
//             if (state is LoadHome) {
//               login = state.login;
//             }
//             if (state is HomeLoading) {
//               isLoading = true;
//             } else {
//               isLoading = false;
//             }
//             if (state is OnLogoutHome) {
//               authBloc(AuthLogin());
//             }
//             if (state is MenuLoaded) {
//               login = state.login;
//               listMenu.clear();
//               listMenu.addAll(state.listMenu);
//               listTransactionChildren.clear();
//               listTransactionChildren.addAll((listMenu.firstWhereOrNull(
//                         (element) => element.menuCd == "TRANSACTION",
//                       ) ??
//                       Menu(childs: []))
//                   .childs!);
//               listTpChildren.clear();
//               listTpChildren.addAll((listTransactionChildren.firstWhereOrNull(
//                         (element) => element.menuCd == "TOUCH_POINT",
//                       ) ??
//                       Menu(childs: []))
//                   .childs!);
//             }
//           },
//         ),
//       ],
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: sccWhite,
//         ),
//         child: Drawer(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               headerMenu(context),
//               Expanded(
//                 child: Container(
//                   child: BlocBuilder<HomeBloc, HomeState>(
//                     builder: (context, state) {
//                       if (state is HomeLoading) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else {
//                         return Scrollbar(
//                           controller: navDrawerController,
//                           isAlwaysShown: true,
//                           child: ListView(
//                             controller: navDrawerController,
//                             padding: const EdgeInsets.all(0),
//                             children: [
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(HomeRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.MENU_DASHBOARD_TMMIN
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.MENU_DASHBOARD_TMMIN
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.MENU_DASHBOARD_TMMIN ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.MENU_DASHBOARD_TMMIN ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.chartPie,
//                                             size: context.scaleFont(20),
//                                             // color: widget.selectedTile ==
//                                             //         Constant.MENU_DASHBOARD_TMMIN
//                                             //     ? sccWhite
//                                             //     : sccText1,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Container(
//                                                   child: Text(
//                                                     'Dashboard',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       color: widget.selectedTile == Constant.MENU_DASHBOARD_TMMIN ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               Visibility(
//                                 visible: listMenu.any((element) => element.menuCd == "TRACEABILITY"),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   // crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: 8.wh),
//                                     TextButton(
//                                       style: ButtonStyle(
//                                         padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                       ),
//                                       onPressed: () {
//                                         if (widget.optionalCallback != null) widget.optionalCallback!();
//                                         context.push(TracingRoute());
//                                       },
//                                       child: CommonShimmer(
//                                         isLoading: isLoading,
//                                         child: Container(
//                                           margin: EdgeInsets.only(right: 8.wh),
//                                           padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                           decoration: BoxDecoration(
//                                             gradient: widget.selectedTile == Constant.TRACEABILITY
//                                                 ? LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       sccButtonLightBlue,
//                                                       sccButtonBlue,
//                                                     ],
//                                                   )
//                                                 : null,
//                                             // color: widget.selectedTile ==
//                                             //         Constant.TRACEABILITY
//                                             //     ? sccWarningText
//                                             //     : null,
//                                             borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                           ),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               GradientWidget(
//                                                 gradient: LinearGradient(
//                                                   begin: Alignment.topCenter,
//                                                   end: Alignment.bottomCenter,
//                                                   colors: [
//                                                     widget.selectedTile == Constant.TRACEABILITY ? sccWhite : sccButtonLightBlue,
//                                                     widget.selectedTile == Constant.TRACEABILITY ? sccWhite : sccButtonBlue,
//                                                   ],
//                                                 ),
//                                                 child: HeroIcon(
//                                                   HeroIcons.searchCircle,
//                                                   size: context.scaleFont(20),
//                                                   // color: widget.selectedTile ==
//                                                   //         Constant.TRACEABILITY
//                                                   //     ? sccWhite
//                                                   //     : sccText1,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   child: Row(
//                                                     children: [
//                                                       SizedBox(
//                                                         width: 4.wh,
//                                                       ),
//                                                       Text(
//                                                         'Traceability',
//                                                         textAlign: TextAlign.left,
//                                                         style: TextStyle(
//                                                           fontSize: context.scaleFont(16),
//                                                           // fontWeight: FontWeight.w300,
//                                                           color: widget.selectedTile == Constant.TRACEABILITY ? sccWhite : sccText1,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               SizedBox(height: 8.wh),
//                               // ! ////////////////////////////////////////////
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(KiteRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.KITE_REALIZATION
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.KITE_REALIZATION
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.KITE_REALIZATION ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.KITE_REALIZATION ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.library,
//                                             size: context.scaleFont(20),
//                                             // color: widget.selectedTile ==
//                                             //         Constant.KITE_REALIZATION
//                                             //     ? sccWhite
//                                             //     : sccText1,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Text(
//                                                   'KITE Realization (D)',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontSize: context.scaleFont(16),
//                                                     // fontWeight: FontWeight.w300,
//                                                     color: widget.selectedTile == Constant.KITE_REALIZATION ? sccWhite : sccText1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // ! ////////////////////////////////////////////
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MONITORING") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MON_AGENT"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(MonitoringAgentRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MON_AGENT
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MON_AGENT
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MON_AGENT ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MON_AGENT ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.users,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MON_AGENT
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Monitoring Agent',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MON_AGENT ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MONITORING") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MON_STOCK"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(MonitoringStockRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MON_STOCK
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MON_STOCK
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MON_STOCK ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MON_STOCK ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.cube,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MON_STOCK
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Monitoring Stock',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MON_STOCK ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MST_POINT"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(PointRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MST_POINT
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MST_POINT
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MST_POINT ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MST_POINT ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.locationMarker,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MST_POINT
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Master Point',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MST_POINT ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MST_WORKFLOW"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(MasterWorkflowRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MST_WORKFLOW
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MST_WORKFLOW
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MST_WORKFLOW ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MST_WORKFLOW ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.cubeTransparent,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MST_WORKFLOW
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Master Workflow',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MST_WORKFLOW ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MST_COMPANY"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(CompanyRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MST_COMPANY
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MST_COMPANY
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MST_COMPANY ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MST_COMPANY ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.officeBuilding,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MST_COMPANY
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Master Company',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MST_COMPANY ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "PART_GROUP_WORKFLOW"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(PgWorkflowRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.PART_GROUP_WORKFLOW
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.PART_GROUP_WORKFLOW
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.PART_GROUP_WORKFLOW ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.PART_GROUP_WORKFLOW ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.support,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant
//                                               //             .PART_GROUP_WORKFLOW
//                                               //     ? sccWhite
//                                               // : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Part Group Workflow',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.PART_GROUP_WORKFLOW ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "KATASHIKI_GROUP_WORKFLOW"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(KgWorkflowRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.KATASHIKI_GROUP_WORKFLOW
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //     Constant
//                                         //         .KATASHIKI_GROUP_WORKFLOW
//                                         // ? sccWarningText
//                                         // : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.KATASHIKI_GROUP_WORKFLOW ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.KATASHIKI_GROUP_WORKFLOW ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.truck,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant
//                                               //             .KATASHIKI_GROUP_WORKFLOW
//                                               //     ? sccWhite
//                                               // : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Katashiki Group Workflow',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.KATASHIKI_GROUP_WORKFLOW ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MST_ATTRIBUTE"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(MstAttrRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MST_ATTRIBUTE
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MST_ATTRIBUTE
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MST_ATTRIBUTE ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MST_ATTRIBUTE ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.table,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MST_ATTRIBUTE
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Master Attribute',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MST_ATTRIBUTE ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MASTER") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "TEMP_ATTRIBUTE"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(TemplateAttributeRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.TEMP_ATTRIBUTE
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //     Constant
//                                         //         .TEMP_ATTRIBUTE
//                                         // ? sccWarningText
//                                         // : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.TEMP_ATTRIBUTE ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.TEMP_ATTRIBUTE ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.template,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant
//                                               //             .TEMP_ATTRIBUTE
//                                               //     ? sccWhite
//                                               // : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Master Template Attribute',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.TEMP_ATTRIBUTE ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   // Container(
//                                                   //   padding:
//                                                   //       const EdgeInsets.all(2),
//                                                   //   decoration: BoxDecoration(
//                                                   //       color: sccDanger,
//                                                   //       shape: BoxShape.circle),
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               Visibility(
//                                 visible: ((listMenu.firstWhereOrNull((element) => element.menuCd == "MONITORING") ?? Menu(childs: [])).childs ?? [])
//                                     .any((element) => element.menuCd == "MON_LOG"),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                   ),
//                                   onPressed: () {
//                                     if (widget.optionalCallback != null) widget.optionalCallback!();
//                                     context.push(MonitoringLogRoute());
//                                   },
//                                   child: CommonShimmer(
//                                     isLoading: isLoading,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 8.wh),
//                                       padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                       decoration: BoxDecoration(
//                                         gradient: widget.selectedTile == Constant.MON_LOG
//                                             ? LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [
//                                                   sccButtonLightBlue,
//                                                   sccButtonBlue,
//                                                 ],
//                                               )
//                                             : null,
//                                         // color: widget.selectedTile ==
//                                         //         Constant.MON_LOG
//                                         //     ? sccWarningText
//                                         //     : null,
//                                         borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           GradientWidget(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 widget.selectedTile == Constant.MON_LOG ? sccWhite : sccButtonLightBlue,
//                                                 widget.selectedTile == Constant.MON_LOG ? sccWhite : sccButtonBlue,
//                                               ],
//                                             ),
//                                             child: HeroIcon(
//                                               HeroIcons.documentText,
//                                               size: context.scaleFont(20),
//                                               // color: widget.selectedTile ==
//                                               //         Constant.MON_LOG
//                                               //     ? sccWhite
//                                               //     : sccText1,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 4.wh,
//                                                   ),
//                                                   Text(
//                                                     'Monitoring Log',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       // fontWeight: FontWeight.w300,
//                                                       color: widget.selectedTile == Constant.MON_LOG ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               // Visibility(
//                               //   visible: ((listMenu.firstWhereOrNull((element) =>
//                               //                       element.menuCd == "MASTER") ??
//                               //                   Menu(childs: []))
//                               //               .childs ??
//                               //           [])
//                               //       .any((element) =>
//                               //           element.menuCd == "MST_KATASHIKI_GROUP"),
//                               //child:
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(KatashikiGroupRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.KATASHIKI_GROUP
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.KATASHIKI_GROUP
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.KATASHIKI_GROUP ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.KATASHIKI_GROUP ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.badgeCheck,
//                                             size: context.scaleFont(20),
//                                             // color: widget.selectedTile ==
//                                             //         Constant
//                                             //             .KATASHIKI_GROUP
//                                             //     ? sccWhite
//                                             // : sccText1,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Text(
//                                                   'Master Katashiki Group',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontSize: context.scaleFont(16),
//                                                     // fontWeight: FontWeight.w300,
//                                                     color: widget.selectedTile == Constant.KATASHIKI_GROUP ? sccWhite : sccText1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                                 // Container(
//                                                 //   padding:
//                                                 //       const EdgeInsets.all(2),
//                                                 //   decoration: BoxDecoration(
//                                                 //       color: sccDanger,
//                                                 //       shape: BoxShape.circle),
//                                                 // ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               //),
//                               SizedBox(height: 8.wh),
//                               // Visibility(
//                               //   visible: ((listMenu.firstWhereOrNull((element) =>
//                               //                       element.menuCd == "MASTER") ??
//                               //                   Menu(childs: []))
//                               //               .childs ??
//                               //           [])
//                               //       .any((element) =>
//                               //           element.menuCd == "MST_KATASHIKI_GROUP"),
//                               //child:
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(PartGroupRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.PART_GROUP
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.PART_GROUP
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.PART_GROUP ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.PART_GROUP ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.checkCircle,
//                                             size: context.scaleFont(20),
//                                             // color: widget.selectedTile ==
//                                             //         Constant.PART_GROUP
//                                             //     ? sccWhite
//                                             //     : sccText1,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Text(
//                                                   'Master Part Group',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontSize: context.scaleFont(16),
//                                                     // fontWeight: FontWeight.w300,
//                                                     color: widget.selectedTile == Constant.PART_GROUP ? sccWhite : sccText1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                                 // Container(
//                                                 //   padding:
//                                                 //       const EdgeInsets.all(2),
//                                                 //   decoration: BoxDecoration(
//                                                 //       color: sccDanger,
//                                                 //       shape: BoxShape.circle),
//                                                 // ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(MstRoleRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.ROLE
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.MENU_SETTINGS
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.ROLE ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.ROLE ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.cog,
//                                             size: context.scaleFont(20),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     'Master User Role (D)',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       color: widget.selectedTile == Constant.ROLE ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(FunctionRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.MST_FUNCTION
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.MENU_SETTINGS
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.MST_FUNCTION ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.MST_FUNCTION ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.cog,
//                                             size: context.scaleFont(20),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     'Master Function (D)',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       color: widget.selectedTile == Constant.MST_FUNCTION ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(MstFeature());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.MST_FEATURE
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.MENU_SETTINGS
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.MST_FEATURE ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.MST_FEATURE ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.cog,
//                                             size: context.scaleFont(20),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     'Master Feature (D)',
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                       fontSize: context.scaleFont(16),
//                                                       color: widget.selectedTile == Constant.MST_FEATURE ? sccWhite : sccText1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 8.wh),
//                               TextButton(
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                 ),
//                                 onPressed: () {
//                                   if (widget.optionalCallback != null) widget.optionalCallback!();
//                                   context.push(SettingsRoute());
//                                 },
//                                 child: CommonShimmer(
//                                   isLoading: isLoading,
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 8.wh),
//                                     padding: EdgeInsets.symmetric(horizontal: 8.wh, vertical: 4.wh),
//                                     decoration: BoxDecoration(
//                                       gradient: widget.selectedTile == Constant.MENU_SETTINGS
//                                           ? LinearGradient(
//                                               begin: Alignment.topCenter,
//                                               end: Alignment.bottomCenter,
//                                               colors: [
//                                                 sccButtonLightBlue,
//                                                 sccButtonBlue,
//                                               ],
//                                             )
//                                           : null,
//                                       // color: widget.selectedTile ==
//                                       //         Constant.MENU_SETTINGS
//                                       //     ? sccWarningText
//                                       //     : null,
//                                       borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         GradientWidget(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             colors: [
//                                               widget.selectedTile == Constant.MENU_SETTINGS ? sccWhite : sccButtonLightBlue,
//                                               widget.selectedTile == Constant.MENU_SETTINGS ? sccWhite : sccButtonBlue,
//                                             ],
//                                           ),
//                                           child: HeroIcon(
//                                             HeroIcons.cog,
//                                             size: context.scaleFont(20),
//                                             // color:
//                                             //     widget.selectedTile == Constant.MENU_SETTINGS
//                                             //         ? sccWhite
//                                             //         : sccText1,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 4.wh,
//                                                 ),
//                                                 Text(
//                                                   'Settings',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontSize: context.scaleFont(16),
//                                                     color: widget.selectedTile == Constant.MENU_SETTINGS ? sccWhite : sccText1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               ExpandableWidget(
//                                 expand: widget.selectedTile == Constant.MENU_SETTINGS,
//                                 child: Container(
//                                   // child: Visibility(
//                                   // visible: widget.selectedTile == Constant.MENU_SETTINGS,
//                                   child: Column(
//                                     children: [
//                                       SizedBox(height: 8.wh),
//                                       TextButton(
//                                         style: ButtonStyle(
//                                           padding: MaterialStateProperty.all(EdgeInsets.only(right: 8, top: 8, bottom: 8)),
//                                         ),
//                                         onPressed: () {
//                                           if (widget.optionalCallback != null) widget.optionalCallback!();
//                                           bloc(DoLogout(login: login));
//                                         },
//                                         child: CommonShimmer(
//                                           isLoading: isLoading,
//                                           child: Container(
//                                             margin: EdgeInsets.only(right: 8.wh),
//                                             padding: EdgeInsets.symmetric(horizontal: 16.wh, vertical: 4.wh),
//                                             // decoration: BoxDecoration(
//                                             //   gradient: widget.selectedTile
//                                             //       ? LinearGradient(
//                                             //           begin: Alignment.topCenter,
//                                             //           end: Alignment.bottomCenter,
//                                             //           colors: [
//                                             //             sccButtonLightBlue,
//                                             //             sccButtonBlue,
//                                             //           ],
//                                             //         )
//                                             //       : null,
//                                             //   // color: sccWhite,
//                                             //   borderRadius: BorderRadius.only(
//                                             //       topRight: Radius.circular(50),
//                                             //       bottomRight: Radius.circular(50)),
//                                             // ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 GradientWidget(
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       sccButtonLightBlue,
//                                                       sccButtonBlue,
//                                                     ],
//                                                   ),
//                                                   child: HeroIcon(
//                                                     HeroIcons.logout,
//                                                     // color: sccText1,
//                                                     size: context.scaleFont(20),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Container(
//                                                     child: Row(
//                                                       children: [
//                                                         SizedBox(
//                                                           width: 4.wh,
//                                                         ),
//                                                         Text(
//                                                           'Logout',
//                                                           textAlign: TextAlign.left,
//                                                           style: TextStyle(
//                                                             fontSize: context.scaleFont(16),
//                                                             color: sccText1,
//                                                             overflow: TextOverflow.ellipsis,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 8.wh),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: 4.wh),
//                                     ],
//                                   ),
//                                   // ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   dynamic headerMenu(BuildContext context) {
//     return Container(
//       height: context.deviceHeight() * 0.15,
//       child: DrawerHeader(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: sccWhite,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 4, right: 8, top: 8, bottom: 8),
//           child: Image.asset(
//             "assets/tmmin_logo_50_tahun.png",
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }

//   dynamic bottomMenu(Login? login, String selectedTile, Function() onLogout) {
//     return Container(
//       child: Align(
//         alignment: FractionalOffset.bottomCenter,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(color: sccText1),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text(
//                   "Settings",
//                   style: TextStyle(
//                     fontSize: context.scaleFont(16),
//                     // fontWeight: FontWeight.w300,
//                     color: widget.selectedTile == Constant.MENU_SETTINGS ? sccWhite : sccText1,
//                   ),
//                 ),
//                 selected: widget.selectedTile == Constant.MENU_SETTINGS,
//                 selectedTileColor: sccWarningText,
//                 leading: HeroIcon(
//                   HeroIcons.cog,
//                   color: widget.selectedTile == Constant.MENU_SETTINGS ? sccWhite : sccText1,
//                   size: context.scaleFont(20),
//                 ),
//                 onTap: () {
//                   context.push(SettingsRoute());
//                 },
//               ),
//               SizedBox(height: 10),
//               ListTile(
//                 title: Text(
//                   "Logout",
//                   style: TextStyle(
//                     fontSize: context.scaleFont(16),
//                     // fontWeight: FontWeight.w300,
//                     color: sccText1,
//                   ),
//                 ),
//                 leading: HeroIcon(
//                   HeroIcons.logout,
//                   color: sccText1,
//                   size: context.scaleFont(20),
//                 ),
//                 onTap: () {
//                   alertDialogLogout(context, () => onLogout());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TimeLineDrawer extends StatefulWidget {
//   final String? partId;
//   final String? matNo;
//   final String? partName;
//   final Tracing? tracing;
//   final String? type;
//   const TimeLineDrawer({this.partId, this.matNo, this.partName, this.tracing, this.type, Key? key}) : super(key: key);

//   @override
//   _TimeLineDrawerState createState() => _TimeLineDrawerState();
// }

// class _TimeLineDrawerState extends State<TimeLineDrawer> {
//   List<TrackingPointModel> listData = [];
//   // bool isShipmentExpanded = false;
//   // bool isDeclarationExpanded = false;
//   // bool isGrExpanded = false;
//   // bool isUnpackExpanded = false;

//   //bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     authBloc(AuthEvent event) {
//       BlocProvider.of<AuthBloc>(context).add(event);
//     }

//     // bloc(TraceEvent event) {
//     //   BlocProvider.of<TraceBloc>(context).add(event);
//     // }

//     final drawerController = ScrollController();

//     return Theme(
//       data: Theme.of(context).copyWith(
//         canvasColor: sccWhite,
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
//         child: Drawer(
//           child: Padding(
//             padding: EdgeInsets.only(top: 20.wh, bottom: 20.wh, left: 20.wh, right: 10.wh), //EdgeInsets.all(6.wh),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 SelectableText(
//                   "Tracking Details",
//                   style: TextStyle(color: sccText3, fontSize: context.scaleFont(18), fontWeight: FontWeight.w800),
//                 ),
//                 SizedBox(height: 30),
//                 trackDetailColumn(widget.tracing),
//                 SizedBox(height: 38),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     SelectableText(
//                 //       "Tracking List",
//                 //       style: TextStyle(
//                 //         color: sccHintText,
//                 //         fontSize: context.scaleFont(16),
//                 //       ),
//                 //     ),
//                 //     IconButton(
//                 //       splashRadius: 20,
//                 //       iconSize: context.scaleFont(16),
//                 //       icon: Icon(
//                 //         Icons.close,
//                 //       ),
//                 //       onPressed: () => context.back(),
//                 //       // locator<NavigatorService>().goBack(),
//                 //     ),
//                 //   ],
//                 // ),
//                 Expanded(
//                   child: MultiBlocListener(
//                     listeners: [
//                       BlocListener<AuthBloc, AuthState>(
//                         listener: (context, state) {
//                           if (state is AuthLoggedOut) {
//                             context.back();
//                             context.push(LoginRoute());
//                             // locator<NavigatorService>()
//                             //     .navigateReplaceTo(Constant.MENU_LOGIN);
//                           }
//                         },
//                       ),
//                       BlocListener<TraceBloc, TraceState>(
//                         listener: (context, state) {
//                           if (state is OnLogoutTrace) {
//                             authBloc(AuthLogin());
//                           }
//                           if (state is TracePtsLoaded) {
//                             listData.clear();
//                             listData.addAll(state.listData);
//                           }
//                         },
//                       )
//                     ],
//                     child: Container(
//                       // padding: EdgeInsets.only(right: 12.wh, left: 12.wh),
//                       child: Scrollbar(
//                         controller: drawerController,
//                         isAlwaysShown: true,
//                         child: SingleChildScrollView(
//                           controller: drawerController,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Container(
//                               //   child: FittedBox(
//                               //     child: SelectableText(
//                               //       "${(widget.matNo ?? "<Mat No>")} - ${(widget.partName ?? "<Part Name>")}",
//                               //       maxLines: 1,
//                               //       style: TextStyle(
//                               //         color: sccText1,
//                               //       ),
//                               //       // overflow: TextOverflow.clip,
//                               //     ),
//                               //   ),
//                               // ),
//                               // SizedBox(
//                               //   height: 8,
//                               // ),
//                               // Container(
//                               //   child: FittedBox(
//                               //     child: SelectableText(
//                               //       widget.partId ?? "-",
//                               //       maxLines: 1,
//                               //       style: TextStyle(fontWeight: FontWeight.bold),
//                               //       // overflow: TextOverflow.clip,
//                               //     ),
//                               //   ),
//                               // ),
//                               SelectableText(
//                                 "History",
//                                 style: TextStyle(color: sccText3, fontSize: context.scaleFont(18), fontWeight: FontWeight.w800),
//                               ),
//                               SizedBox(height: 30),
//                               Container(
//                                 child: BlocBuilder<TraceBloc, TraceState>(
//                                   builder: (context, state) {
//                                     if (state is TraceLoading) {
//                                       return Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     } else {
//                                       return Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: listData.isNotEmpty
//                                             ? listData.map((element) {
//                                                 return TouchPointTimeline(
//                                                   title: element.pointName ?? "",
//                                                   content: element.attribute,
//                                                   isFirst: element == listData.first,
//                                                   isLast: element == listData.last,
//                                                 );
//                                               }).toList()
//                                             : [
//                                                 SelectableText(
//                                                   "There is no tracking data",
//                                                   style: TextStyle(
//                                                     fontSize: context.scaleFont(16),
//                                                     color: sccBlack,
//                                                   ),
//                                                 )
//                                               ],
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget columnItem(String title, String? desc, {bool isGradien = false}) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SelectableText(title, style: TextStyle(fontSize: context.scaleFont(18), color: sccText2, fontWeight: FontWeight.w600)),
//           isGradien
//               ? GradientWidget(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [sccButtonLightBlue, sccButtonBlue],
//                   ),
//                   child: SelectableText(desc ?? "-", style: TextStyle(fontSize: context.scaleFont(16), color: sccText3, fontWeight: FontWeight.w600)),
//                 )
//               : SelectableText(desc ?? "-", style: TextStyle(fontSize: context.scaleFont(16), color: sccText3, fontWeight: FontWeight.w600))
//         ],
//       ),
//     );
//   }

//   Widget trackDetailColumn(Tracing? tracing) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             columnItem("Type", tracing?.type),
//             SizedBox(
//               width: 8,
//             ),
//             columnItem("Prod Month", tracing?.prodMonth),
//             // columnItem("Tracking Number", 'XXX')
//           ],
//         ),
//         SizedBox(height: 17),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: widget.type?.toUpperCase().contains("VEHICLE") == true
//               ? [
//                   columnItem("VIN", tracing?.vinNo),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   columnItem("Line Off", tracing?.lineOff),
//                   // columnItem("Status", "XXX", isGradien: true)
//                 ]
//               : [
//                   columnItem("Part ID", tracing?.partId),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   columnItem("Part No ", tracing?.partNo),
//                 ],
//         ),
//         SizedBox(height: 17),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             columnItem("Hash No", tracing?.trackHash),
//             // SizedBox(
//             //   width: 8,
//             // ),
//             Expanded(
//               child: SizedBox(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/menu.dart';
import 'package:scc_web/shared_widgets/nav_drawer_menu.dart';
import 'package:scc_web/shared_widgets/redirect_dialog.dart';
import 'package:scc_web/shared_widgets/scroll_to_index.dart';
import 'package:scc_web/theme/colors.dart';

class PersistDrawer extends StatefulWidget {
  final Function()? optionalCallback;
  final Function(List<Menu>)? onMenuLoaded;
  final String selectedTile;
  final bool initiallyExpanded;

  const PersistDrawer({
    required this.selectedTile,
    this.optionalCallback,
    this.onMenuLoaded,
    this.initiallyExpanded = true,
    Key? key,
  }) : super(key: key);

  @override
  _PersistDrawerState createState() => _PersistDrawerState();
}

class _PersistDrawerState extends State<PersistDrawer> {
  // late bool isExpanded;
  double initialScrollOffsett = 0;
  bool initiallyExpanded = true;
  // bool permission = true;
  late bool isTransactionExpanded;
  Login? login;
  late AutoScrollController navDrawerController;
  String superAdmin = "";

  bool isLoading = true;
  List<Menu> listMenu = [];

  @override
  void initState() {
    navDrawerController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    isTransactionExpanded = (widget.selectedTile == Constant.TP_INPUT_FORM ||
        widget.selectedTile == Constant.TP_UPLOAD); //&& isExpanded;
    // navDrawerController.addListener(() => _scrollListener());
    initiallyExpanded = widget.initiallyExpanded;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // navDrawerController.addListener(() => _scrollListener());
      // _scrollToIndex(listMenu.indexWhere((element) => element.menuCd == widget.selectedTile));
    });
    super.initState();
  }

  @override
  void didUpdateWidget(PersistDrawer oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initiallyExpanded = widget.initiallyExpanded;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  Future _scrollToIndex(int index) async {
    if (!index.isNegative && index <= listMenu.length) {
      await navDrawerController.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin);
    }
  }

  bool checkMenu(List<Menu> list) {
    bool valid = false;
    // if (list.any((element) => element.menuCd == widget.selectedTile)) {
    //   valid = true;
    // } else {
    for (Menu menu in list) {
      if (menu.menuCd == widget.selectedTile ||
          widget.selectedTile == Constant.transaction) {
        valid = true;
        break;
      } else if (menu.childs != null && menu.childs!.isNotEmpty) {
        valid = checkMenu(menu.childs!);
        if (valid) break;
      }
    }
    // }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    // if (!context.isDesktop()) isExpanded = false;
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    bloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),

      curve: Curves.fastOutSlowIn,
      width: context.deviceWidth() *
          ((context.isWideScreen() && widget.initiallyExpanded) ? 0.17 : 0.065),
      // width: context.deviceWidth() * ((context.isWideScreen() && widget.initiallyExpanded) ? 0.16 : 0.065),
      color: sccWhite,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                context.push(const LoginRoute());
                isLoading = false;
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is LoadHome) {
                login = state.login;
              }
              if (state is OnLogoutHome) {
                authBloc(AuthLogin());
              }
              if (state is MenuLoaded) {
                login = state.login;
                listMenu.clear();
                listMenu.addAll(state.listMenu);
                if (widget.onMenuLoaded != null) {
                  widget.onMenuLoaded!(listMenu);
                }
                if (state.listSysMaster.isNotEmpty) {
                  for (var e in state.listSysMaster) {
                    if (e.systemCd != null) {
                      superAdmin = e.systemValue ?? "UNKNOWN";
                    }
                  }
                }
                listMenu.sort(
                    (a, b) => (a.menuSeq ?? 0).compareTo(b.menuSeq ?? 1000));

                if (login!.username == superAdmin) {
                  if (!checkMenu(listMenu) &&
                      widget.selectedTile != Constant.MENU_SETTINGS &&
                      widget.selectedTile != Constant.menu &&
                      widget.selectedTile != Constant.ROLE) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) {
                        return RedirectDialog(
                          onTap: () async {
                            await DatabaseHelper().dbClear();
                            bloc(DoLogout());
                          },
                        );
                      },
                    );
                  }
                } else {
                  if (!checkMenu(listMenu) &&
                          widget.selectedTile != Constant.MENU_SETTINGS ||
                      (widget.selectedTile == Constant.menu &&
                          widget.selectedTile == Constant.ROLE)) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) {
                        return RedirectDialog(
                          onTap: () async {
                            await DatabaseHelper().dbClear();
                            bloc(DoLogout());
                          },
                        );
                      },
                    );
                  }
                }

                // if (!checkMenu(listMenu) ||
                //     widget.selectedTile != Constant.MENU_SETTINGS &&
                //         widget.selectedTile != Constant.PLAN_LIST &&
                //         (login!.username != superAdmin &&
                //             (widget.selectedTile == Constant.menu ||
                //                 widget.selectedTile == Constant.ROLE))) {
                //   showDialog(
                //     barrierDismissible: false,
                //     context: context,
                //     builder: (ctx) {
                //       return RedirectDialog(
                //         onTap: () async {
                //           await DatabaseHelper().dbClear();
                //           context.push(const LoginRoute());
                //         },
                //       );
                //     },
                //   );
                // }
                setState(() {});
              }
              if (state is HomeLoading) {
                isLoading = true;
              } else {
                isLoading = false;
              }
            },
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: listMenu.isNotEmpty
                        ? NavDrawerMenu(
                            isLoading: isLoading,
                            listMenu: listMenu,
                            navDrawerController: navDrawerController,
                            isExpanded: context.isWideScreen() &&
                                widget.initiallyExpanded,
                            onLogout: () => bloc(DoLogout()),
                            optionalCallback: () {
                              if (widget.optionalCallback != null) {
                                widget.optionalCallback!();
                              }
                            },
                            selectedTile: widget.selectedTile,
                            onWidgetBuilt: () {
                              int index = listMenu.indexWhere(
                                  (element) =>
                                      element.menuCd == widget.selectedTile ||
                                      (element.childs != null &&
                                          element.childs!.any((element) =>
                                              element.menuCd ==
                                              widget.selectedTile)),
                                  1);
                              _scrollToIndex(index);
                            },
                          )
                        : const SizedBox(),
                  ),
                ),
                // ! use this space for menu test
              ],
            );
          },
        ),
      ),
    );
  }
}
