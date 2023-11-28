// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i24;
import 'package:flutter/material.dart' as _i25;

import '../screens/dashboard/dashboard_screen.dart' as _i2;
import '../screens/dashboard/route_test.dart' as _i4;
import '../screens/forgot_password/forgot_password.dart' as _i23;
import '../screens/login/login_screen.dart' as _i1;
import '../screens/master_approval/master_approval_screen.dart' as _i8;
import '../screens/master_item/master_item_screen.dart' as _i12;
import '../screens/master_menu/master_menu_screen.dart' as _i10;
import '../screens/master_package/master_package_screen.dart' as _i7;
import '../screens/master_product/master_product_screen.dart' as _i18;
import '../screens/master_role/master_role_screen.dart' as _i11;
import '../screens/master_supplier/master_supplier_screen.dart' as _i6;
import '../screens/master_template_attr/tmpl_attr_screen.dart' as _i16;
import '../screens/master_use_case/master_use_case_screen.dart' as _i19;
import '../screens/master_user_role/master_user_role_screen.dart' as _i9;
import '../screens/MasterAttributtes/Master_Attributes_Screen.dart' as _i13;
import '../screens/MasterPoint/Master_Point_Screen.dart' as _i14;
import '../screens/monitoring_agent/monitoring_agent_screen.dart' as _i21;
import '../screens/monitoring_log/monitoring_log_screen.dart' as _i20;
import '../screens/profile_settings/profile_settings_screen.dart' as _i22;
import '../screens/subscribers/subscribers_screen.dart' as _i15;
import '../screens/subscription/subscription_screen.dart' as _i17;
import '../screens/Traceability/traceability_screen.dart' as _i5;
import '../screens/transaction/transaction_screen.dart' as _i3;

class AppRouter extends _i24.RootStackRouter {
  AppRouter([_i25.GlobalKey<_i25.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i24.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginScreen(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DashboardRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.DashboardScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TransactionRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.TransactionScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RouteTestRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i4.RouteTestScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TraceabilityRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.TraceabilityScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterSupplierRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i6.MasterSupplierScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterPackageRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i7.MasterPackageScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterApprovalRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i8.MasterApprovalScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterUserRoleRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i9.MasterUserRoleScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterMenuRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i10.MasterMenuScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterRoleRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i11.MasterRoleScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterItemRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i12.MasterItemScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterAttributesRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i13.MasterAttributesScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterPointRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i14.MasterPointScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SubscribersRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i15.SubscribersScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TemplateAttributeRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i16.TemplateAttributeScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SubscriptionRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i17.SubscriptionScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterProductRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i18.MasterProductScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MasterUseCaseRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i19.MasterUseCaseScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MonitoringLogRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i20.MonitoringLogScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MonitoringAgentRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i21.MonitoringAgentScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileSettingsRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i22.ProfileSettingsScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i23.ForgotPasswordScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i24.RouteConfig> get routes => [
        _i24.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/scc/web/login',
          fullMatch: true,
        ),
        _i24.RouteConfig(
          LoginRoute.name,
          path: '/scc/web/login',
        ),
        _i24.RouteConfig(
          DashboardRoute.name,
          path: '/scc/web/dashboard',
        ),
        _i24.RouteConfig(
          TransactionRoute.name,
          path: '/scc/web/transaction',
        ),
        _i24.RouteConfig(
          RouteTestRoute.name,
          path: '/scc/web/route-test',
        ),
        _i24.RouteConfig(
          TraceabilityRoute.name,
          path: '/scc/web/traceability',
        ),
        _i24.RouteConfig(
          MasterSupplierRoute.name,
          path: '/scc/web/master-supplier',
        ),
        _i24.RouteConfig(
          MasterPackageRoute.name,
          path: '/scc/web/master-package',
        ),
        _i24.RouteConfig(
          MasterApprovalRoute.name,
          path: '/scc/web/master-Approval',
        ),
        _i24.RouteConfig(
          MasterUserRoleRoute.name,
          path: '/scc/web/master-user-role',
        ),
        _i24.RouteConfig(
          MasterMenuRoute.name,
          path: '/scc/web/master-menu',
        ),
        _i24.RouteConfig(
          MasterRoleRoute.name,
          path: '/scc/web/master-role',
        ),
        _i24.RouteConfig(
          MasterItemRoute.name,
          path: '/scc/web/master-item',
        ),
        _i24.RouteConfig(
          MasterAttributesRoute.name,
          path: '/scc/web/master-attributes',
        ),
        _i24.RouteConfig(
          MasterPointRoute.name,
          path: '/scc/web/master-point',
        ),
        _i24.RouteConfig(
          SubscribersRoute.name,
          path: '/scc/web/subscription-subscribers',
        ),
        _i24.RouteConfig(
          TemplateAttributeRoute.name,
          path: '/scc/web/master-template-attribute',
        ),
        _i24.RouteConfig(
          SubscriptionRoute.name,
          path: '/scc/web/subscription-subscription',
        ),
        _i24.RouteConfig(
          MasterProductRoute.name,
          path: '/scc/web/master-product',
        ),
        _i24.RouteConfig(
          MasterUseCaseRoute.name,
          path: '/scc/web/business-process',
        ),
        _i24.RouteConfig(
          MonitoringLogRoute.name,
          path: '/scc/web/monitoring-log',
        ),
        _i24.RouteConfig(
          MonitoringAgentRoute.name,
          path: '/scc/web/monitoring-agent',
        ),
        _i24.RouteConfig(
          ProfileSettingsRoute.name,
          path: '/scc/web/settings',
        ),
        _i24.RouteConfig(
          ForgotPasswordRoute.name,
          path: '/scc/web/forgot-password',
        ),
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i24.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/scc/web/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.DashboardScreen]
class DashboardRoute extends _i24.PageRouteInfo<void> {
  const DashboardRoute()
      : super(
          DashboardRoute.name,
          path: '/scc/web/dashboard',
        );

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i3.TransactionScreen]
class TransactionRoute extends _i24.PageRouteInfo<void> {
  const TransactionRoute()
      : super(
          TransactionRoute.name,
          path: '/scc/web/transaction',
        );

  static const String name = 'TransactionRoute';
}

/// generated route for
/// [_i4.RouteTestScreen]
class RouteTestRoute extends _i24.PageRouteInfo<void> {
  const RouteTestRoute()
      : super(
          RouteTestRoute.name,
          path: '/scc/web/route-test',
        );

  static const String name = 'RouteTestRoute';
}

/// generated route for
/// [_i5.TraceabilityScreen]
class TraceabilityRoute extends _i24.PageRouteInfo<void> {
  const TraceabilityRoute()
      : super(
          TraceabilityRoute.name,
          path: '/scc/web/traceability',
        );

  static const String name = 'TraceabilityRoute';
}

/// generated route for
/// [_i6.MasterSupplierScreen]
class MasterSupplierRoute extends _i24.PageRouteInfo<void> {
  const MasterSupplierRoute()
      : super(
          MasterSupplierRoute.name,
          path: '/scc/web/master-supplier',
        );

  static const String name = 'MasterSupplierRoute';
}

/// generated route for
/// [_i7.MasterPackageScreen]
class MasterPackageRoute extends _i24.PageRouteInfo<void> {
  const MasterPackageRoute()
      : super(
          MasterPackageRoute.name,
          path: '/scc/web/master-package',
        );

  static const String name = 'MasterPackageRoute';
}

/// generated route for
/// [_i8.MasterApprovalScreen]
class MasterApprovalRoute extends _i24.PageRouteInfo<void> {
  const MasterApprovalRoute()
      : super(
          MasterApprovalRoute.name,
          path: '/scc/web/master-Approval',
        );

  static const String name = 'MasterApprovalRoute';
}

/// generated route for
/// [_i9.MasterUserRoleScreen]
class MasterUserRoleRoute extends _i24.PageRouteInfo<void> {
  const MasterUserRoleRoute()
      : super(
          MasterUserRoleRoute.name,
          path: '/scc/web/master-user-role',
        );

  static const String name = 'MasterUserRoleRoute';
}

/// generated route for
/// [_i10.MasterMenuScreen]
class MasterMenuRoute extends _i24.PageRouteInfo<void> {
  const MasterMenuRoute()
      : super(
          MasterMenuRoute.name,
          path: '/scc/web/master-menu',
        );

  static const String name = 'MasterMenuRoute';
}

/// generated route for
/// [_i11.MasterRoleScreen]
class MasterRoleRoute extends _i24.PageRouteInfo<void> {
  const MasterRoleRoute()
      : super(
          MasterRoleRoute.name,
          path: '/scc/web/master-role',
        );

  static const String name = 'MasterRoleRoute';
}

/// generated route for
/// [_i12.MasterItemScreen]
class MasterItemRoute extends _i24.PageRouteInfo<void> {
  const MasterItemRoute()
      : super(
          MasterItemRoute.name,
          path: '/scc/web/master-item',
        );

  static const String name = 'MasterItemRoute';
}

/// generated route for
/// [_i13.MasterAttributesScreen]
class MasterAttributesRoute extends _i24.PageRouteInfo<void> {
  const MasterAttributesRoute()
      : super(
          MasterAttributesRoute.name,
          path: '/scc/web/master-attributes',
        );

  static const String name = 'MasterAttributesRoute';
}

/// generated route for
/// [_i14.MasterPointScreen]
class MasterPointRoute extends _i24.PageRouteInfo<void> {
  const MasterPointRoute()
      : super(
          MasterPointRoute.name,
          path: '/scc/web/master-point',
        );

  static const String name = 'MasterPointRoute';
}

/// generated route for
/// [_i15.SubscribersScreen]
class SubscribersRoute extends _i24.PageRouteInfo<void> {
  const SubscribersRoute()
      : super(
          SubscribersRoute.name,
          path: '/scc/web/subscription-subscribers',
        );

  static const String name = 'SubscribersRoute';
}

/// generated route for
/// [_i16.TemplateAttributeScreen]
class TemplateAttributeRoute extends _i24.PageRouteInfo<void> {
  const TemplateAttributeRoute()
      : super(
          TemplateAttributeRoute.name,
          path: '/scc/web/master-template-attribute',
        );

  static const String name = 'TemplateAttributeRoute';
}

/// generated route for
/// [_i17.SubscriptionScreen]
class SubscriptionRoute extends _i24.PageRouteInfo<void> {
  const SubscriptionRoute()
      : super(
          SubscriptionRoute.name,
          path: '/scc/web/subscription-subscription',
        );

  static const String name = 'SubscriptionRoute';
}

/// generated route for
/// [_i18.MasterProductScreen]
class MasterProductRoute extends _i24.PageRouteInfo<void> {
  const MasterProductRoute()
      : super(
          MasterProductRoute.name,
          path: '/scc/web/master-product',
        );

  static const String name = 'MasterProductRoute';
}

/// generated route for
/// [_i19.MasterUseCaseScreen]
class MasterUseCaseRoute extends _i24.PageRouteInfo<void> {
  const MasterUseCaseRoute()
      : super(
          MasterUseCaseRoute.name,
          path: '/scc/web/business-process',
        );

  static const String name = 'MasterUseCaseRoute';
}

/// generated route for
/// [_i20.MonitoringLogScreen]
class MonitoringLogRoute extends _i24.PageRouteInfo<void> {
  const MonitoringLogRoute()
      : super(
          MonitoringLogRoute.name,
          path: '/scc/web/monitoring-log',
        );

  static const String name = 'MonitoringLogRoute';
}

/// generated route for
/// [_i21.MonitoringAgentScreen]
class MonitoringAgentRoute extends _i24.PageRouteInfo<void> {
  const MonitoringAgentRoute()
      : super(
          MonitoringAgentRoute.name,
          path: '/scc/web/monitoring-agent',
        );

  static const String name = 'MonitoringAgentRoute';
}

/// generated route for
/// [_i22.ProfileSettingsScreen]
class ProfileSettingsRoute extends _i24.PageRouteInfo<void> {
  const ProfileSettingsRoute()
      : super(
          ProfileSettingsRoute.name,
          path: '/scc/web/settings',
        );

  static const String name = 'ProfileSettingsRoute';
}

/// generated route for
/// [_i23.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i24.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(
          ForgotPasswordRoute.name,
          path: '/scc/web/forgot-password',
        );

  static const String name = 'ForgotPasswordRoute';
}
