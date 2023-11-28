// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final isWebMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

class Constant extends InheritedWidget {
  static Constant? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Constant>();

  const Constant({required Widget child, Key? key})
      : super(key: key, child: child);
  //& BASEPATH
  static const String pathFe = '/scc/web';

  //& MENUS
  //& MENUS
  static const String MENU_MASTER = 'MASTER';
  static const String MST_INVENTORY_PARAMETER = 'MST_INVENTORY_PARAMETER';
  static const String MENU_LOGIN = 'LOGIN';
  static const String MENU_DASHBOARD = 'DASHBOARD';
  static const String MENU_DASHBOARD_TMMIN = 'DASHBOARD_TMMIN';
  static const String MENU_DASHBOARD_SUPPLIER = 'DASHBOARD_SUPPLIER';
  static const String PACKAGE_LIST = 'SBC_UPGRADE';
  static const String PLAN_LIST = 'PLAN_LIST';
  static const String SUBSCRIBERS = 'SBC_SUBSCRIBERS';
  static const String PACKAGE_NAME = 'packageName';
  static const String COMPANY_NM = 'companyName';
  static const String SUBSCRIPTION = 'SUBSCRIPTION';
  static const String TRACEABILITY = 'TRACEABILITY';
  static const String MENU_SETTINGS = 'SETTINGS';
  static const String MENU_LOGOUT = 'LOGOUT';
  static const String INVENTORY = 'INVENTORY';
  static const String MONITORING = 'MONITORING';
  static const String KITE_REALIZATION = "KITE_REALIZATION";
  static const String TRANSACTION = "TRANSACTION";
  static const String MON_STOCK = "MON_STOCK";
  static const String MON_AGENT = "MON_AGENT";
  static const String ROLE = "ROLE";
  static const String MON_LOG = "MON_LOG";
  static const String MST_POINT = 'MST_POINT';
  static const String MST_COMPANY = 'MST_COMPANY';
  static const String MST_WORKFLOW = 'MST_WORKFLOW';
  static const String PART_NUMBER = 'PART_NUMBER';
  static const String USE_CASE = 'USE_CASE';
  static const String PART_GROUP = 'PART_GROUP';
  static const String KATASHIKI_GROUP = 'KATASHIKI_GROUP';
  static const String PART_GROUP_WORKFLOW = 'PART_GROUP_WORKFLOW';
  static const String KATASHIKI_GROUP_WORKFLOW = 'KATASHIKI_GROUP_WORKFLOW';
  static const String MST_ATTRIBUTE = 'MST_ATTRIBUTE';
  static const String TEMP_ATTRIBUTE = 'TEMP_ATTRIBUTE';
  static const String MST_FUNCTION = 'MST_FUNCTION';
  static const String MST_FEATURE = 'MST_FEATURE';
  static const String MST_MENU = 'MST_MENU';
  static const String MST_PART = 'MST_PART';
  static const String MY_PART = 'MY_PARTS';
  static const String MST_FUNC_FEAT = 'MST_FUNC_FEAT';
  static const String MST_USER_ROLE = 'USER_ROLE';
  static const String MST_ROLE_MENU_FUNC_FEAT = 'MST_ROLE_MENU_FUNC_FEAT';
  static const String MST_MENU_FUNC_FEAT = 'MST_MENU_FUNC_FEAT';
  static const String INVENTORY_DASHBOARD = 'INVENTORY_DASHBOARD';
  static const String SECURITY = 'SECURITY';

  //& FORMS
  static const String TP_INPUT_FORM = 'TP_INPUT_FORM';
  static const String TP_UPLOAD = "TP_UPLOAD";
  static const String MENU_FORM_SHIPMENT = 'SHIPMENT';
  static const String MENU_FORM_DECLARATION = 'DECLARATION';
  static const String MENU_FORM_GOOD_RECEIVED = 'GOOD_RECEIVED';
  static const String MENU_FORM_UNPACK = 'UNPACK';

  //& STATUS
  static const String INITIAL_PORTAL = 'Choose Period';
  static const String STATUS_SUCCESS = 'success';
  static const String STATUS_ERROR = 'error';
  static const String STATUS_IN_PROCESS = 'In Progress';
  static const String STATUS_PENDING = 'pending';
  static const String STATUS_DELIVERED = 'Delivery';
  static const String statusTrue = 'true';
  static const String statusFalse = 'false';

  //& APP SETTINGS
  static const String PLATFORM = "PLATFORM";
  static const String BLOCKCHAIN = "BLOCKCHAIN";
  static const String VIN_NO = "VIN_NO";
  static const String KTSK_CD = "KTSK_CD";
  static const String KTSK_NAME = "KTSK_NM";
  static const String EGN_NO = "EGN_NO";
  static const String PART_ID = "PART_ID";
  static const String PART_NO = "PART_NO";
  static const String PART_NAME = "PART_NM";
  static const String LOT_NO = "LOT_NO";
  static const String COMPANY_CODE = "COMPANY_CD";
  static const String COMPANY_NAME = "COMPANY_NM";
  static const String POINT_CD = "POINT_CD";
  static const String POINT_NAME = "POINT_NM";
  static const String TYPE = "type";
  static const String SYS_VEHICLE = "PVT_VEHICLE";
  static const String SYS_PART = "PVT_PART";
  static const String VEHICLE = "VEHICLE";
  static const String PART = "PART";
  static const String FT_VEHICLE = "T_VEHICLE";
  static const String FT_PART = "T_PART";
  static const String FT_ENGINE = "T_ENGINE";
  static const String RAW_TYPE_PART = "RT_PART";
  static const String RAW_TYPE_MANIFEST = "RT_MANIFEST";
  static const String RAW_TYPE_LOT = "RT_LOT";
  static const String STATUS_UP = "AMST_UP";
  static const String STATUS_WARN = "AMST_WARN";
  static const String STATUS_DOWN = "AMST_DOWN";
  static const String WORKFLOW_CODE = "WF_CD";
  static const String WORKFLOW_NAME = "WF_NM";
  static const String USE_CASE_NAME = "USE_CASE_NM";
  static const String ENGINE_NO = "ENGINE_NO";
  static const String ENGINE_PREFIX = "ENGINE_PREFIX";
  static const String FORM_MODE_TABLE = "TABLE";
  static const String FORM_MODE_VIEW = "VIEW";
  static const String FORM_MODE_ADD = "ADD";
  static const String FORM_MODE_EDIT = "EDIT";
  static const String PART_GROUP_NAME = "PG_NM";
  static const String PART_GROUP_CD = "PG_CD";
  static const String KATASHIKI_GROUP_NAME = "KG_NM";
  static const String KATASHIKI_GROUP_CD = "KG_CD";
  static const String VALID_FROM_DT = "VALID_FROM";
  static const String ATTR_DATA_TYPE = "ATTR_DATA_TYPE";
  static const String ATTR_TYPE = "ATTR_TYPE";
  static const String ATTRIBUTE_CD = "ATTR_CD";
  static const String ATTRIBUTE_NAME = "ATTR_NAME";
  static const String ATTRIBUTE_API_KEY = "ATTR_API_KEY";
  static const String ATTRIBUTE_TYPE_CD = "ATTR_TP_CD";
  static const String PROCESS_ID = "PROCESS_ID";
  static const String FUNCTION_CD = "FUNCTION_CD";
  static const String FUNCTION = "FUNCTION";
  static const String MODULE = "MODULE";
  static const String USER_ID = "USER_ID";
  static const String CREATED_BY = "CREATED_BY";
  static const String MSG_ID = "MSG_ID";
  static const String MSG_TYPE = "MSG_TYPE";
  static const String MSG_LOCATION = "LOCATION";
  static const String MSG_DETAIL = "MSG_DETAIL";
  static const String SYSTEM_CODE = "SYS_CD";
  static const String MESSAGE_CODE = "MSG_CD";
  static const String MESSAGE_TEXT = "MSG_TXT";
  static const String LOCATION = "LOCATION";
  static const String MNT_PARENT_MENU = "MNT_PARENT_MENU";
  static const String MNT_PARENT_MENU_ROUTING = "MNT_PARENT_MENU_ROUTING";
  static const String USER_NM = "USER_NM";
  static const String EMAIL = "EMAIL";
  static const String ROLE_NAME = "ROLE_NM";
  static const String ROLE_CD = "ROLE_CD";
  static const String SUPER_ADMIN = "SUPER_ADMIN";
  static const String NOT_SUPER_ADMIN = "NOT_SUPER_ADMIN";
  static const String ALL_ADMIN = "ALL_ADMIN";
  static const String MANIFEST_NO_API_KEY = "manifestNo";
  static const String PLANT_CD = "plantCd";
  static const String PLANT_NAME = "plantName";
  static const String FUNCTION_NAME = "FUNCTION_NAME";
  static const String FEATURE_NAME = "FEATURE_NAME";
  static const String FUNC_FEAT_NAME = "FUNC_FEAT_NAME";
  static const String FEATURE_CD = "FEATURE_CD";
  static const String MENU_NAME = "MENU_NAME";
  static const String MENU_CODE = "MENU_CODE";
  static const String PNS_APPROVED = "PNS_APPROVED";
  static const String PNS_REJECTED = "PNS_REJECTED";
  static const String PNS_UNREGISTERED = "Unregistered";
  static const String PNS_WAITING = "Waiting";
  // static const String ROLE_NAME = "ROLE_NAME";
  static const String TP_TRACK = "TP_TRACK";
  static const String TP_TRACK_PART = "TP_TRACK_PART";
  static const String TP_TRACK_VEHICLE = "TP_TRACK_VEHICLE";
  static const String TP_VEHICLE_FINISHED = "TP_VEHICLE_FINISHED";
  static const String TP_CHILD_VEHICLE_FINISHED = "TP_CHILD_VEHICLE_FINISHED";
  static const String TP_PART_FINISHED = "TP_PART_FINISHED";
  static const String TP_CHILD_PART_FINISHED = "TP_CHILD_PART_FINISHED";
  static const String TP_VEHICLE_INPROGRESS = "TP_VEHICLE_INPROGRESS";
  static const String TP_PART_INPROGRESS = "TP_PART_INPROGRESS";
  static const String TP_CHILD_PART_INPROGRESS = "TP_CHILD_PART_INPROGRESS";
  static const String TP_VEHICLE = "TP_VEHICLE";
  static const String TP_PART = "TP_PART";
  static const String TP_UPLOAD_VEHICLE = "TP_UPLOAD_VEHICLE";
  static const String TP_UPLOAD_PART = "TP_UPLOAD_PART";
  static const String F_SEARCH = "F_SEARCH";
  static const String F_CHECK = "F_CHECK";
  static const String F_CREATE = "F_CREATE";
  static const String F_ADD = "F_ADD";
  static const String F_CHANGE = "F_CHANGE";
  static const String F_SUBMIT = "F_SUBMIT";
  static const String F_CANCEL = "F_CANCEL";
  static const String F_DOWNLOAD_VEHICLE_TEMPLATE =
      "F_DOWNLOAD_VEHICLE_TEMPLATE";
  static const String F_DOWNLOAD_PART_TEMPLATE = "F_DOWNLOAD_PART_TEMPLATE";
  static const String F_BROWSE = "F_BROWSE";
  static const String F_EDIT = "F_EDIT";
  static const String F_IMPORT_FILE = "F_IMPORT_FILE";
  static const String F_GET = "F_GET";
  static const String F_VIEW = "F_VIEW";
  static const String F_APPROVE = "F_APPROVE";
  static const String F_REJECT = "F_REJECT";
  static const String F_DETAIL = "F_DETAIL";
  static const String F_APPROVAL_TABLE = "F_APPROVAL_TABLE";
  static const String F_TRACE = "F_TRACE";
  static const String F_RESET = "F_RESET";
  static const String F_UPDATE = "F_UPDATE";
  static const String F_DELETE = "F_DELETE";
  static const String F_ENABLE_DISABLE = "F_ENABLE_DISABLE";
  static const String F_PUSH_BLOCKCHAIN = "F_PUSH_BLOCKCHAIN";
  static const String F_UPLOAD = "F_UPLOAD";
  static const String F_REMOVE = "F_REMOVE";
  static const String F_DOWNLOAD = "F_DOWNLOAD";
  static const String PART_NO_API_KEY = "partNo";
  static const String FUNC_ATTRIBUTE = "FUNC_ATTRIBUTE";
  static const String FUNC_TEMP_ATTRIBUTE = "FUNC_TEMP_ATTRIBUTE";
  static const String FUNC_COMPANY = "FUNC_COMPANY";
  static const String FUNC_WORKFLOW = "FUNC_WORKFLOW";
  static const String FUNC_POINT = "FUNC_POINT";
  static const String FUNC_PART_GROUP = 'FUNC_PART_GROUP';
  static const String FUNC_PART_GROUP_WORKFLOW = 'FUNC_PART_GROUP_WORKFLOW';
  static const String FUNC_ROLE_MENU_FUNC_FEAT = 'FUNC_ROLE_MENU_FUNC_FEAT';
  static const String FUNC_MENU_FUNC_FEAT = 'FUNC_MENU_FUNC_FEAT';
  static const String FUNC_FUNCTION = 'FUNC_FUNCTION';
  static const String FUNC_FEATURE = 'FUNC_FEATURE';
  static const String FUNC_ROLE = 'FUNC_ROLE';
  static const String FUNC_FUNC_FEAT = 'FUNC_FUNC_FEAT';
  static const String FUNC_USER_ROLE = 'FUNC_USER_ROLE';
  static const String FUNC_MENU = 'FUNC_MENU';
  static const String TODAY = 'TODAY';
  static const String LASTWEEK = 'LASTWEEK';
  static const String LASTMONTHSDAY = 'LASTMONTHSDAY';
  static const String THISMONTH = 'THISMONTH';
  static const String HIGH_USAGE = 'high';
  static const String MEDIUM_USAGE = 'medium';
  static const String LOW_USAGE = 'low';
  static const String NORMAL = 'NORMAL';
  static const String INPROCESS = 'INPROCESS';
  static const String INSTOCK = 'INSTOCK';
  static const String RECEIVED = 'RECEIVED';
  static const String OVERFLOW = 'OVERFLOW';
  static const String CRITICAL = 'CRITICAL';
  static const String SHORTAGE = 'SHORTAGE';
  static const String TOTAL_ORDER = 'TOTAL_ORDER';
  static const String PART_ID_TRACE = "SB_PART_ID";
  static const String PART_NO_TRACE = "SB_PART_NO";
  static const String VIN_NO_TRACE = "SB_VIN_NO";
  static const String ENGINE_NO_TRACE = "SB_ENGINE_NO";
  static const String PRD_PART_TRACE = "PRD_PART";
  static const String PRD_VEHICLE_TRACE = "PRD_VEHICLE";
  static const String PRD_ENGINE_TRACE = "PRD_ENGINE";
  static const String SELECT_DATE = "SELECT_DATE";
  static const String SELECT_WEEK = "SELECT_WEEK";
  static const String ALL_TIME = "ALL_TIME";
  // static const String INVENTORY = 'INVENTORY';
  static const String ENGINE = 'ENGINE';
  static const String UCS_ENABLE = "UCS_ENABLE";
  static const String UCS_DISABLE = "UCS_DISABLE";
  // static const String VEHICLE = 'VEHICLE';
  static const String PS_INPROGRESS = "PS_INPROGRESS";
  static const String PS_SUCCESS = "PS_SUCCESS";
  static const String PS_SUCCESS_WARN = "PS_SUCCESS_WARN";
  static const String PS_FAIL = 'PS_FAIL';
  static const String MLT_ERROR = 'M_L_T_ERROR';
  static const String KATASHIKI_NAME = 'katashikiName';
  static const String KATASHIKI_CD = 'katashikiCd';
  static const String ENGINE_NO_KEY = 'engineNo';
  static const String IS_PARENT = 'ISPARENT';
  static const String YEARLY = 'YEARLY';
  static const String MONTHLY = 'MONTHLY';
  static const String isParent = 'ISPARENT';
  static const String attrDataType = "ATTR_DATA_TYPE";
  static const String attrType = "ATTR_TYPE";
  static const String attributeCd = "ATTR_CD";
  static const String attributeName = "ATTR_NAME";
  static const String attributeApiKey = "ATTR_API_KEY";
  static const String attributeTypeCd = "ATTR_TP_CD";
  static const String tempAttrName = "TEMPLATE ATTRIBUTE NAME";
  static const String tempAttrCode = "TEMPLATE ATTRIBUTE CODE";
  static const String supplierCode = "SUPPLIER_CD";
  static const String supplierTypeCd = "SUPPLIER_TYPE_CD";
  static const String supplierName = "SUPPLIER_NAME";
  static const String productCode = "PRODUCT_CD";
  static const String productDesc = "PRODUCT_DESC";
  static const String touchPoint = "POINT_CD";
  static const String productName = "PRODUCT_NAME";
  static const String approval_Item = "MST_ITEM";
  static const String dashboard = "DASHBOARD";
  static const String transaction = "TRACE AND TRACK";
  static const String contactAdmin = "contactAdmin";
  static const String login = "login";
  static const String supplier = "MST_SUPPLIER";
  static const String product = "product";
  static const String home = "home";
  static const String package = "SBC_PACKAGE_LIST";
  static const String admin = "USER_ROLE";
  static const String menu = "menu";
  static const String menuAccessRole = "menuAccessRole";
  static const String role = "role";
  static const String item = "MY_ITEM";
  static const String attributes = "MST_ATTRIBUTE";
  static const String point = "MST_POINT";
  static const String tempAttribute = "TEMP_ATTRIBUTE";
  static const String subscribers = "SBC_SUBSCRIBERS";
  static const String subscription = "SBC_UPGRADE";
  static const String monitoringLog = "MON_LOG";
  static const String monitoringAgent = "MON_AGENT";
  // static const String isParent = 'ISPARENT';
  static const String logOut = 'ISLOGOUT';
  static const String settingMenu = 'SettingMenu';
  static const String mntParentMenuRouting = 'MNT_PARENT_MENU_ROUTING';
  static const String mstProduct = "MST_PRODUCT";
  static const String useCase = "USE_CASE";
  static const String productParent = "P_TYPE_PAREN";
  static const String productItem = "P_ITEM";
  static const String assignMstItem = "ASSIGN_MASTER_ITEM";
  static const String rejected = "PNS_REJECTED";
  static const String waiting = "PNS_WAITING";
  static const String registered = "PNS_APPROVED";
  static const String required = "PNS_REQUIRED";
  static const String unregistered = "PNS_UNREGISTERED";
  static const String maximum = "PNS_MAXIMUM";

  //& FORMS
  static const String yearly = 'YEARLY';
  static const String monthly = 'MONTHLY';
  //& STATUS
  static const String statusSuccess = "success";
  static const String initialPortal = 'Choose Period';
  static const String statusError = 'error';
  static const String statusInProcess = 'In Process';
  static const String statusInPending = 'pending';
  static const String statusDelivered = 'Delivered';

  //& APP SETTINGS
  static const String addMode = "ADD";
  static const String editMode = "EDIT";
  static const String viewMode = "VIEW";
  static const String viewNotif = "NOTIF";
  static const String tableMode = "TABLE";
  static const String menuName = "MENU_NAME";
  static const String menuCode = "MENU_CODE";

  static const String packageName = "PACKAGE_NAME";
  static const String packageCode = "PACKAGE_CODE";
  static const String packageTypeName = "PACKAGE_TYPE_NAME";
  static const String packageTypeCode = "PACKAGE_TYPE_CODE";

  static const String username = "USERNAME";
  static const String email = "EMAIL";
  static const String itemCode = "ITEM_CODE";
  static const String itemDesc = "ITEM_DESC";
  static const String itemName = "ITEM_NAME";
  static const String useCaseCode = "USE_CASE_CODE";
  static const String useCaseName = "USE_CASE_NAME";
  static const String itemId = "ITEM_ID";
  static const String itemCd = "ITEM_CD";
  static const String blockchainStatus = "BLOCKCHAIN_STS";

  // REQUEST
  static const String get = "GET";
  static const String post = "POST";
  static const String patch = "PATCH";
  static const String put = "PUT";
  static const String delete = "DELETE";

  //& URIS
  static String mstFeatureUrl = "${dotenv.get('sccUserMgmt')}/feature";
  static String mstRoleUrl = "${dotenv.get('sccUserMgmt')}/role/search-role";
  static String mstAttributeUrl =
      "${dotenv.get('sccMasterProduct')}/attribute/search";
  static String mstRoleDial =
      "${dotenv.get('sccUserMgmt')}/role/search-rolepackage";

  //& icon
  static const String iconSearch = "assets/images/icons-search.svg";

  //& RegExp
  static RegExp regExp = RegExp(
      r'[a-zA-Z0-9_\-@+. ()]+'); // Hanya huruf, angka, _, -, spasi, @, +, {spasi} , ), ( dan .

  //& images
  static const String compLogo = "assets/images/onlyLogo.svg";
  static const String avatar = "assets/images/avatar.png";
  static const String arrowBusiness = "assets/images/arrow.png";
  static const String menuBullet = "assets/images/menu_bullet.svg";
  static const String cloudUpload = "assets/images/cloud_upload.svg";
  static const String inventoryValue = "assets/images/inventoryValue.svg";
  static const String receivableAmountIcon =
      "assets/images/receivableAmountIcon.svg";
  static const String gasFee = "assets/images/gasFee.svg";
  static const String vectorSvg = "assets/images/Vector.svg";
  static const String bgLogin = "assets/images/vcc_potrait_bg_login.jpg";
  static const String bgResigst = "assets/images/background.png";
  static const String bgToch = "assets/images/image.png";
  static const String emptyData = "assets/images/EmptyStates.svg";
  static const String noresult = "assets/images/no_results_found.svg";
  static const String iconChecklist = "assets/images/icon_checklist.svg";
  static const String bgGlobe = "assets/images/Map.svg";
  static const String checked = "assets/images/checked.svg";
  static const String uncheck = "assets/images/uncheck.svg";
  static const String knobOff = "assets/images/KnobOFF.svg";
  static const String knobOn = "assets/images/KnobON.svg";
  static const String brandSvg = "assets/images/LogoSCC.svg";
  static const String iconTrace = "assets/images/IconTrace.png";
  static const String emptyJourney = "assets/images/empty_journey.svg";
  static const String iconprofile = "assets/images/icon_profile.svg";
  static const String green = "assets/images/Green.jpg";
  static const String blue = "assets/images/Blue.jpg";
  static const String red = "assets/images/Red.jpg";
  static const String iconDollarGreen = "assets/images/iconDollarGreen2.svg";
  static const String iconExitRed = "assets/images/IconExitRed2.svg";
  static const String iconGroupBlue = "assets/images/iconGroupBlue.svg";
  static const String iconError = "assets/images/iconError.svg";
  static const String landscape_login_blur =
      "assets/images/landscape_login_blur.jpg";
  static const String vcc_potrait_bg_login =
      "assets/images/vcc_potrait_bg_login.jpg";
  static const String scc_blockchain = "assets/images/blockchain.svg";
  static const String scc_map_grid = "assets/images/maps_grid.png";
  static const String rawMaterial = "/images/rawMaterial.png";
  static const String engineering = "/images/engineering.png";
  static const String manufacture = "/images/manufacture.png";
  static const String productStepper = "/images/product.png";
  static const String warehouse = "/images/warehouse.png";

  static const String profileBase64Img =
      "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";
  @override
  bool updateShouldNotify(Constant oldWidget) => false;
}
