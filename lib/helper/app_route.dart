import 'package:auto_route/auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/screens/MasterAttributtes/Master_Attributes_Screen.dart';
import 'package:scc_web/screens/MasterPoint/Master_Point_Screen.dart';
import 'package:scc_web/screens/Traceability/traceability_screen.dart';
import 'package:scc_web/screens/forgot_password/forgot_password.dart';
import 'package:scc_web/screens/master_approval/master_approval_screen.dart';
import 'package:scc_web/screens/master_product/master_product_screen.dart';
import 'package:scc_web/screens/master_template_attr/tmpl_attr_screen.dart';
import 'package:scc_web/screens/master_use_case/master_use_case_screen.dart';
import 'package:scc_web/screens/master_user_role/master_user_role_screen.dart';

import 'package:scc_web/screens/dashboard/dashboard_screen.dart';
import 'package:scc_web/screens/dashboard/route_test.dart';

import 'package:scc_web/screens/login/login_screen.dart';
import 'package:scc_web/screens/master_menu/master_menu_screen.dart';
import 'package:scc_web/screens/master_package/master_package_screen.dart';

import 'package:scc_web/screens/master_role/master_role_screen.dart';
import 'package:scc_web/screens/monitoring_agent/monitoring_agent_screen.dart';
import 'package:scc_web/screens/monitoring_log/monitoring_log_screen.dart';
import 'package:scc_web/screens/profile_settings/profile_settings_screen.dart';

import 'package:scc_web/screens/subscribers/subscribers_screen.dart';
import 'package:scc_web/screens/subscription/subscription_screen.dart';
import 'package:scc_web/screens/transaction/transaction_screen.dart';

import '../screens/master_item/master_item_screen.dart';
import '../screens/master_supplier/master_supplier_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    CustomRoute(
      path: '${Constant.pathFe}/login',
      page: LoginScreen,
      initial: true,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/dashboard',
      page: DashboardScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      initial: true,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/transaction',
      page: TransactionScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      initial: true,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/route-test',
      page: RouteTestScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/traceability',
      page: TraceabilityScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-supplier',
      page: MasterSupplierScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-package',
      page: MasterPackageScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      initial: true,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-Approval',
      page: MasterApprovalScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-user-role',
      page: MasterUserRoleScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    // CustomRoute(
    //     path: '${Constant.pathFe}/master-admin/form',
    //     page: AdminFormScreen,
    //     initial: true,
    //     transitionsBuilder: TransitionsBuilders.fadeIn),
    // CustomRoute(
    //   path: '${Constant.pathFe}/master-supplier/form',
    //   page: SupplierFormAddEdit,
    //   initial: true,
    //   transitionsBuilder: TransitionsBuilders.fadeIn,
    // ),
    CustomRoute(
      path: '${Constant.pathFe}/master-menu',
      page: MasterMenuScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-role',
      page: MasterRoleScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-item',
      page: MasterItemScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    // CustomRoute(
    //   path: '${Constant.pathFe}/master-role/form',
    //   page: MasterRoleForm,
    //   initial: true,
    //   transitionsBuilder: TransitionsBuilders.fadeIn,
    // ),
    CustomRoute(
      path: '${Constant.pathFe}/master-attributes',
      page: MasterAttributesScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-point',
      page: MasterPointScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/subscription-subscribers',
      page: SubscribersScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-template-attribute',
      page: TemplateAttributeScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/subscription-subscription',
      page: SubscriptionScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/master-product',
      page: MasterProductScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/business-process',
      page: MasterUseCaseScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/monitoring-log',
      page: MonitoringLogScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/monitoring-agent',
      page: MonitoringAgentScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/settings',
      page: ProfileSettingsScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '${Constant.pathFe}/forgot-password',
      page: ForgotPasswordScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ],
)
class $AppRouter {}
