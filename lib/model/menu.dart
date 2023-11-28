import 'package:scc_web/model/system_master.dart';


class Menu {
  String? menuCd;
  String? menuName;
  String? menuDesc;
  String? menuTypeCd;
  SystemMaster? menuType;
  int? menuSeq;
  String? parentMenuCd;
  List<Menu>? childs;

  Menu({this.menuCd, this.menuName, this.menuDesc, this.menuTypeCd, this.menuSeq, this.parentMenuCd, this.childs});

  Menu.map(Map<String, dynamic> obj) {
    childs = [];
    menuCd = obj['menuCd'];
    menuName = obj['menuName'];
    menuDesc = obj['menuDesc'];
    if (obj['menuTypeCd'] is String) {
      menuTypeCd = obj['menuTypeCd'];
    } else if ((obj['menuTypeCd'] is Map<String, dynamic>)) {
      menuType = SystemMaster.map(obj['menuTypeCd']);
      menuTypeCd = menuType!.systemCd;
    }

    menuSeq = obj['menuSeq'];
    parentMenuCd = obj['parentMenuCd'];
    if (obj['childs'] != null && obj['childs'] is List) {
      for (var v in (obj['childs'] as List)) {
        childs!.add(Menu.map(v));
      }
      childs!.sort((a, b) => (a.menuSeq ?? 0).compareTo(b.menuSeq ?? 1));
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['menuCd'] = menuCd;
    data['menuName'] = menuName;
    data['menuDesc'] = menuDesc;
    data['menuTypeCd'] = menuTypeCd;
    data['menuSeq'] = menuSeq;
    data['parentMenuCd'] = parentMenuCd;
    if (childs != null) {
      data['childs'] = childs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
