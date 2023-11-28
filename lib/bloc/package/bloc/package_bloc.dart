// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/contact_admin.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/pkg_list.dart';
import 'package:scc_web/model/pricing.dart';
import 'package:scc_web/model/subs_features.dart';
import 'package:scc_web/services/restapi.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  PackageBloc() : super(PackageInitial()) {
    on<PackageEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetTeksImage) {
          emit(PackageLoading());
          List<Tittle> listTitle = await getTeksImage();

          emit(PackageDataImage(listTitle));
        } else if (event is GetPricing) {
          emit(PackageLoading());
          List<Pricing> listPricing = await getPricing();
          emit(LoadPricing(listPricing));
        } else if (event is GetSubsFeatures) {
          emit(PackageLoading());
          List<SubsFeatures> rawData = await getSubsFeatures();

          List<Map<String, dynamic>> listBody = listElements(rawData);
          Map<String, dynamic> completeBody = fullMap(listBody);
          // !OPT 1
          // List<SubsFeatures> listSubsFeatures = reorderFeatures(rawData, listBody, completeBody);
          // !OPT 2
          Map<String, Map<String, dynamic>> completeComp =
              completeCompact(completeBody);
          List<SubsFeatures> listCompact =
              reorderCompact(rawData, completeComp);

          emit(LoadSubsFeatures(
              // listSubsFeatures, completeBody,
              listCompact,
              completeComp));
        } else if (event is GetPackageTypeDropdown) {
          emit(PackageLoading());
          List<KeyVal> listPlantOpt = await getPackageDrop();
          List<KeyVal> listCountry = await getCountryDrop();
          List<KeyVal> listSystem = await getSystemDrop();

          emit(PackageTypeLoad(listPlantOpt, listCountry, listSystem));
        } else if (event is SubmitContactAdmin) {
          emit(PackageLoading());

          await api.submitContact(
            body: event.model.toSubmit(),
            header: {
              "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
            },
          );
          emit(ContactAdminSuccrss());
        } else if (event is GetPackageInfo) {
          emit(PackageLoading());
          Contacted contact = await getContact(event.package);
          emit(LoadContact(contact));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            await deleteUser(db);

            emit(OnLogout());
          }
        } else if (e is InvalidSessionExpression) {
          await deleteUser(db);

          emit(OnLogout());
        } else {
          emit(PackageError(e.toString()));
        }
      }
    });
  }

  _query(DatabaseHelper db) async {
    final user = await db.getUser();
    if (user != null) {
      _login = user;
      DateTime now = DateTime.now();
      DateTime date = convertStringToDateFormat(
          _login.accessTokenExpDate!, "dd-MMM-yyyy HH:mm:ss");
      if ((date.difference(now).inSeconds - 10).isNegative) {
        await refreshToken(db);
      }
    } else {
      throw UnauthorisedException('Session is Expired');
    }
  }

  deleteUser(db) async {
  

    await db.dbClear();
  }

  refreshToken(DatabaseHelper db, {PackageEvent? event}) async {
   
    String? username = _login.username;
    try {
      var result = await api.refreshToken(body: _login.toRefresh())
          as Map<String, dynamic>;
      _login = Login.map(result);
      _login.username = username;
      await db.saveUser(_login);
    
      if (event != null) add(event);
    } catch (e) {
      throw InvalidSessionExpression('Session is Expired');
    }
  }

  Future<List<Pricing>> getPricing() async {
    List<Pricing> listPricing = [];
    var response = await api.getPricing();
    if (response is List) {
      for (var element in response) {
        if (element is Map) {
          listPricing.add(Pricing.map(element));
        }
      }
    }
    return listPricing;
  }

  Future<List<KeyVal>> getPackageDrop() async {
    List<KeyVal> listPlantOpt = [];
    var response = await api.getPackageType();

    if (response != null) {
      for (var element in (response['packageTypes'] as List)) {
        if (element is Map) {
          listPlantOpt.add(
              KeyVal(element["packageTypeName"], element["packageTypeCd"]));
        }
      }
    }
    return listPlantOpt;
  }

  Future<Contacted> getContact(int packageCd) async {
    Contacted? contactInfo;
    var response = await api.getContact(
      packageCd: packageCd,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );
    if (response != null) {
      contactInfo = Contacted.fromJson(response);
    }
    return contactInfo!;
  }

  Future<List<KeyVal>> getCountryDrop() async {
    List<KeyVal> listPlantOpt = [];
    var response = await api.getCountry();

    if (response != null) {
      for (var element in (response['countries'] as List)) {
        if (element is Map) {
          listPlantOpt.add(
              KeyVal(element["countryName"], element["countryId"].toString()));
        }
      }
    }
    return listPlantOpt;
  }

  Future<List<KeyVal>> getSystemDrop() async {
    List<KeyVal> listPlantOpt = [];
    var response = await api.getSystemDropdown(params: {
      "pageNo": "1",
      "pageSize": "99999",
      "systemCd": "",
      "systemTypeCd": "PACKAGE_PERIOD",
      "systemValue": "",
      "company": "",
      "traceType": ""
    });

    if (response != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listPlantOpt
              .add(KeyVal(element["systemValue"] + " Month", element["systemValue"]));
        }
      }
    }
    return listPlantOpt;
  }

  Future<List<Tittle>> getTeksImage() async {
    List<Tittle> listTeksImage = [];
    var response = await api.teksImage();
    if (response is List) {
      for (var element in response) {
        if (element is Map) {
          listTeksImage.add(Tittle.map(element));
        }
      }
    }
    return listTeksImage;
  }

  Future<List<SubsFeatures>> getSubsFeatures() async {
    List<SubsFeatures> listSubFeatures = [];
    var response = await api.getSubsFeatures(
      header: {},
    );
    if (response is List) {
      for (var i in response) {
        if ((i is Map) && (i['packageCd'] != null)) {
          SubsFeatures model = SubsFeatures();
          model.packageName = i['packageName'];
          model.packageCd = i['packageCd'];
          model.packageColor = i['packageColor'];

          Map<String, dynamic> body = {};
          Map<String, Map<String, dynamic>> rawBody = {};
          for (var j in i.entries) {
            //i is model
            if ((j.key is String) && (j.value is Map)) {
              //j is Maps inside i
              body[j.key] = Constant.isParent;
              Map value = (j.value as Map);
              for (var k in value.entries) {
                if ((k.key is String) && (k.value != null)) {
                  //k is Maps inside j
                  body[k.key] = k.value;
                }
              }
              if (value.entries.every((element) => element.key is String)) {
                rawBody[j.key] = value as Map<String, dynamic>;
              }
            }
          }
          model.body = body;
          model.rawBody = rawBody;
          listSubFeatures.add(model);
        }
      }
    }
    return listSubFeatures;
  }

  List<Map<String, dynamic>> listElements(List<SubsFeatures> listSubFeatures) {
    List<Map<String, dynamic>> listElements = [];

    for (var element in listSubFeatures) {
      if (element.body != null) {
        listElements.add(element.body!);
      }
    }
    return listElements;
  }

  Map<String, dynamic> fullMap(List<Map<String, dynamic>> listElements) {
    Map<String, dynamic> fullMap = {};
    try {
      for (var i in listElements) {
        for (var j in i.entries) {
          if (!(fullMap.containsKey(j.key))) {
            fullMap[j.key] = j.value ?? "";
          } else if (fullMap[j.key] == "" && j.value != null) {
            fullMap[j.key] = j.value;
          }
        }
      }
      return fullMap;
    } catch (e) {
      throw "Failed to sort data";
    }
  }

  // completeBody
  Map<String, Map<String, dynamic>> completeCompact(
      Map<String, dynamic> fullBody) {
    Map<String, Map<String, dynamic>> fullMap = {};

    try {
      String? currentKey;
      for (var e in fullBody.entries) {
        if (e.value == Constant.isParent) {
          currentKey = e.key;
          fullMap[currentKey] = {};
        } else if (e.value != Constant.isParent &&
            currentKey != null &&
            (fullMap[currentKey] is Map)) {
          fullMap[currentKey]![e.key] = e.value;
        } else if (fullMap[e.key] == null) {
          fullMap[e.key] = e.value;
        }
      }
      return fullMap;
    } catch (e) {
      throw "Failed to sort data";
    }
  }

  List<SubsFeatures> reorderCompact(
    List<SubsFeatures> listSubFeatures,
    Map<String, Map<String, dynamic>> completeComp,
  ) {
    List<SubsFeatures> reorderedList = [];

    try {
      for (var element in listSubFeatures) {
        SubsFeatures model = element;
        Map<String, Map<String, dynamic>> orderedBody = {};
        Map<String, Map<String, dynamic>> rawBody = model.rawBody ?? {};
        // if (rawBody.isNotEmpty) {
        //! vvvvvvvvvv is Map<String, Map<String, dynamic>>
        for (var i in completeComp.entries) {
          Map<String, dynamic> innerBody = rawBody[i.key] ?? {};
          Map<String, dynamic> completeValue = i.value;
          if (innerBody.isEmpty) {
            //! addAll
            innerBody = {};
            for (var j in completeValue.entries) {
              innerBody[j.key] = "";
            }
          } else {
            for (var j in completeValue.entries) {
              dynamic val = innerBody[j.key];
              //! add if null
              if (val == null) {
                innerBody[j.key] = "";
              }
            }
          }
          orderedBody[i.key] = innerBody;
        }
        // }
        model.rawBody = orderedBody;
        reorderedList.add(model);
      }
      return reorderedList;
    } catch (e) {
      throw (e.toString());
    }
  }
}
