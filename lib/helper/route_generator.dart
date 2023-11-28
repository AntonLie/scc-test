import 'package:auto_route/auto_route.dart';

import 'package:scc_web/helper/app_route.gr.dart';
import 'package:heroicons/heroicons.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/locator.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';

navigate(PageRouteInfo route) {
  locator<AppRouter>().replace(route);
}

extension RouteGenerator on BuildContext {
  Future navigate(PageRouteInfo route) {
    if (isMobile) {
      return pushRoute(route);
    } else {
      return replaceRoute(route);
    }
  }

  Future generateRoute(String? menuCd) {
    switch (menuCd) {
      case Constant.dashboard:
        return navigate(const DashboardRoute());

      case Constant.login:
        return navigate(const LoginRoute());
      case Constant.package:
        return navigate(const MasterPackageRoute());
      case Constant.MST_USER_ROLE:
        return navigate(const MasterUserRoleRoute());
      case Constant.approval_Item:
        return navigate(const MasterApprovalRoute());
      case Constant.supplier:
        return navigate(const MasterSupplierRoute());
      case Constant.item:
        return navigate(const MasterItemRoute());
      case Constant.attributes:
        return navigate(const MasterAttributesRoute());
      case Constant.point:
        return navigate(const MasterPointRoute());
      case Constant.subscribers:
        return navigate(const SubscribersRoute());
      case Constant.subscription:
        return navigate(const SubscriptionRoute());
      case Constant.TRACEABILITY:
        return navigate(const TraceabilityRoute());
      case Constant.tempAttribute:
        return navigate(const TemplateAttributeRoute());
      case Constant.mstProduct:
        return navigate(const MasterProductRoute());
      case Constant.useCase:
        return navigate(const MasterUseCaseRoute());
      case Constant.monitoringLog:
        return navigate(const MonitoringLogRoute());
      case Constant.monitoringAgent:
        return navigate(const MonitoringAgentRoute());
      case Constant.MENU_SETTINGS:
        return navigate(const ProfileSettingsRoute());
      default:
        return navigate(const DashboardRoute());
    }
  }

  Widget mapMenuIcons(String menuCd) {
    switch (menuCd) {
      case Constant.MENU_DASHBOARD:
        return HeroIcon(
          HeroIcons.home,
          size: scaleFont(20),
        );
      case Constant.MENU_DASHBOARD_TMMIN:
        return HeroIcon(
          HeroIcons.home,
          size: scaleFont(20),
        );
      case Constant.MST_INVENTORY_PARAMETER:
        return HeroIcon(
          HeroIcons.film,
          size: scaleFont(20),
        );
      case Constant.TRACEABILITY:
        return HeroIcon(
          HeroIcons.serverStack,
          size: scaleFont(20),
        );
      case Constant.MST_USER_ROLE:
        return HeroIcon(
          HeroIcons.document,
          size: scaleFont(20),
        );
      case Constant.TRANSACTION:
        return HeroIcon(
          HeroIcons.document,
          size: scaleFont(20),
        );
      case Constant.MENU_SETTINGS:
        return HeroIcon(
          HeroIcons.cog,
          size: scaleFont(20),
        );
      case Constant.MENU_LOGOUT:
        return HeroIcon(
          HeroIcons.lockOpen,
          size: scaleFont(20),
        );
      // break;
      case Constant.INVENTORY:
        return HeroIcon(
          HeroIcons.bookmark,
          size: scaleFont(20),
        );
      // break;
      case Constant.KITE_REALIZATION:
        return HeroIcon(
          HeroIcons.archiveBox,
          size: scaleFont(20),
        );
      // break;
      case Constant.MON_STOCK:
        return HeroIcon(
          HeroIcons.cube,
          size: scaleFont(20),
        );
      case Constant.ROLE:
        return HeroIcon(
          HeroIcons.identification,
          size: scaleFont(20),
        );
      // break;
      case Constant.MON_AGENT:
        return HeroIcon(
          HeroIcons.users,
          size: scaleFont(20),
        );
      // break;
      case Constant.MON_LOG:
        return HeroIcon(
          HeroIcons.documentText,
          size: scaleFont(20),
        );
      // break;
      case Constant.MST_POINT:
        return HeroIcon(
          HeroIcons.lockClosed,
          size: scaleFont(20),
        );
      // break;
      case Constant.MST_COMPANY:
        return HeroIcon(
          HeroIcons.buildingOffice,
          size: scaleFont(20),
        );
      // break;
      case Constant.MST_WORKFLOW:
        return HeroIcon(
          HeroIcons.cubeTransparent,
          size: scaleFont(20),
        );
      // break;
      case Constant.PART_GROUP:
        return HeroIcon(
          HeroIcons.checkCircle,
          size: scaleFont(20),
        );
      // break;
      case Constant.KATASHIKI_GROUP:
        return HeroIcon(
          HeroIcons.checkBadge,
          size: scaleFont(20),
        );
      // break;
      case Constant.MONITORING:
        return HeroIcon(
          HeroIcons.computerDesktop,
          size: scaleFont(20),
        );
      // break;
      case Constant.PART_GROUP_WORKFLOW:
        return HeroIcon(
          HeroIcons.square2Stack,
          size: scaleFont(20),
        );
      // break;
      case Constant.KATASHIKI_GROUP_WORKFLOW:
        return HeroIcon(
          HeroIcons.truck,
          size: scaleFont(20),
        );
      // break;
      case Constant.MST_ATTRIBUTE:
        return HeroIcon(
          HeroIcons.deviceTablet,
          size: scaleFont(20),
        );
      // break;
      case Constant.TEMP_ATTRIBUTE:
        return HeroIcon(
          HeroIcons.tableCells,
          size: scaleFont(20),
        );
      // break;
      case Constant.TP_INPUT_FORM:
        return HeroIcon(
          HeroIcons.document,
          size: scaleFont(20),
        );
      // break;
      case Constant.TP_UPLOAD:
        return HeroIcon(
          HeroIcons.document,
          size: scaleFont(20),
        );
      // break;
      case Constant.MENU_MASTER:
        return HeroIcon(
          HeroIcons.buildingLibrary,
          size: scaleFont(20),
        );
      case Constant.MY_PART:
        return HeroIcon(
          HeroIcons.cpuChip,
          size: scaleFont(20),
        );

      case Constant.SECURITY:
        return HeroIcon(
          HeroIcons.shieldCheck,
          size: scaleFont(20),
        );
      case Constant.SUBSCRIPTION:
        return HeroIcon(
          HeroIcons.currencyDollar,
          // solid: true,
          size: scaleFont(20),
        );
      case Constant.item:
        return HeroIcon(
          HeroIcons.archiveBox,
          // solid: true,
          size: scaleFont(20),
        );
      // break;
      default:
        return HeroIcon(
          HeroIcons.chevronRight,
          size: scaleFont(20),
        );
    }
  }
}
