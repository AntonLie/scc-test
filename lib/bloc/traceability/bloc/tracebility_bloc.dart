// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/traceability_model.dart';
import 'package:scc_web/services/restapi.dart';

part 'tracebility_event.dart';
part 'tracebility_state.dart';

class TracebilityBloc extends Bloc<TracebilityEvent, TracebilityState> {
  RestApi api = RestApi();

  Paging? paging;

  late Login _login;
  TracebilityBloc() : super(TracebilityInitial()) {
    on<TracebilityEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is LoadTraceabilityTrace) {
          emit(TracebilityLoading());
          List<ListTraceability> listTrace =
              await searchTrace(event.paging, event.trace);

          emit(TracebilityTracing(listTrace, paging));
        } else if (event is DropdownGetKey) {
          List<KeyVal> listKey =
              await dropdownKey(event.pointType, event.pointProductCd);
          List<KeyVal> listProduct = await getProductList(event.isConsume);
          List<KeyVal> listUseCd = await getUseCd();
          List<KeyVal> listTouchCd = await getTouchCd();
          emit(ListKey(listKey, listProduct, listUseCd, listTouchCd));
        } else if (event is LoadTraceabilityForm) {
          emit(TracebilityLoading());
          List<ListId> traceform = await getItemId(event.paging,
              event.trace.itemCd, event.itemId, event.trace.supplierCd);
          ListTraceability listTrace =
              await getContainer(event.trace.itemId, event.trace.itemCd);
          emit(TracebilityForm(traceform, listTrace));
        } else if (event is LoadTraceabilityConsumeForm) {
          emit(TracebilityLoading());

          List<ListTraceability> listTrace = await searchConsume(
              event.paging, event.trace, event.pointCd, event.itemName);
          emit(TracebilityConsumeForm(listTrace, paging));
        } else if (event is DataTraceabilityForm) {
          emit(TracebilityLoading());
          List<ListId> traceform = await getItemId(
              event.paging, event.itemCd, event.itemId, event.supplierCd);
          emit(DataTracebilityForm(traceform, paging));
        } else if (event is LoadTraceabilityDetail) {
          emit(TracebilityLoading());
          DetailId listIdDetial =
              await getItemIdDetail(event.itemId, event.itemCd);
          emit(TracebilityDetail(listIdDetial));
        } else if (event is TraceDetailList) {
          emit(TracebilityLoading());
          List<TpAttribute> detail = await getDetailTp(event.itemId,
              event.itemCd, event.pointCd, event.childItem, event.childItemCd);

          emit(TraceDetailListTp(detail));
        } else if (event is LoadTraceabilityDetailConsume) {
          emit(TracebilityLoading());
          DetailId listIdDetail =
              await getItemIdDetail(event.itemId, event.itemCd);
          ListTraceability listTrace =
              await getContainerConsume(event.itemId, event.itemCd);
          emit(TracebilityDetailConsume(listIdDetail, listTrace));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutTracebility());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutTracebility());
        } else {
          emit(TracebilityError(e.toString()));
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

  refreshToken(DatabaseHelper db, {TracebilityEvent? event}) async {
    // print('RefreshToken..');
    String? username = _login.username;
    var result = await api.refreshToken(body: _login.toRefresh())
        as Map<String, dynamic>;
    _login = Login.map(result);
    _login.username = username;
    await db.saveUser(_login);
    // print('RerouteEventToken..');
    if (event != null) add(event);
  }

  deleteUser(db) async {
    // print("Delete user story..");

    await db.dbClear();
  }

  Future<List<ListTraceability>> searchTrace(
    Paging? paging,
    TraceSearch trace,
    // String? companyCd,
    // String method,
    // String url,
  ) async {
    List<ListTraceability> listTrace = [];
    Map<String, String> param = {};
    if (paging != null) param.addAll(paging.toJson());
    param.addAll(trace.toSearch());

    var response = await api.searchTraceability(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: param,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listTrace.add(ListTraceability.fromJson(element));
      }
    }

    return listTrace;
  }

  Future<List<KeyVal>> getUseCd() async {
    List<KeyVal> listUseCd = [];

    var response = await api.dropdownUseCase(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listUseCd.add(KeyVal(element["cbName"], element["cbKey"]));
        }
      }
    }
    return listUseCd;
  }

  Future<List<KeyVal>> getTouchCd() async {
    List<KeyVal> listTouchCd = [];

    var response = await api.dropdownTouchPoint(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listTouchCd.add(KeyVal(element["cbName"], element["cbKey"]));
        }
      }
    }
    return listTouchCd;
  }

  Future<List<KeyVal>> dropdownKey(
      String? pointType, String? pointProductCd) async {
    List<KeyVal> listTouchCd = [];
    Map<String, String> body = {
      "pointType": pointType ?? "",
      "pointProductCd": pointProductCd ?? "",
    };
    var response = await api.dropdownKey(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listTouchCd.add(KeyVal(element["cbName"], element["cbKey"]));
        }
      }
    }
    return listTouchCd;
  }

  Future<List<ListId>> getItemId(Paging? paging, String? itemCd, String? itemId,
      String? supplierCd) async {
    List<ListId> listItemId = [];
    Map<String, String> body = {
      "itemCd": itemCd ?? "",
      "itemId": itemId ?? "",
      "supplierCd": supplierCd ?? ""
    };
    if (paging != null) body.addAll(paging.toJson());

    var response = await api.getItemIdList(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listItemId.add(ListId.fromJson(element));
      }
    }

    return listItemId;
  }

  Future<ListTraceability> getContainer(String? itemId, String? itemCd) async {
    ListTraceability? listTrace;
    Map<String, String> body = {
      "itemId": itemId ?? "",
      "itemCd": itemCd ?? "",
    };

    var response = await api.getContainerForm(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);

    listTrace = ListTraceability.toForm(response);

    return listTrace;
  }

  Future<ListTraceability> getContainerConsume(
      String? itemId, String? itemCd) async {
    ListTraceability? listTrace;
    Map<String, String> body = {
      "itemId": itemId ?? "",
      "itemCd": itemCd ?? "",
    };

    var response = await api.getContainerFormConsume(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);

    listTrace = ListTraceability.toForm(response);

    return listTrace;
  }

  Future<DetailId> getItemIdDetail(String? itemId, String? itemCd) async {
    DetailId? listTrace;
    Map<String, String> body = {
      "itemId": itemId ?? "",
      "itemCd": itemCd ?? "",
    };

    var response = await api.getItemIdDetail(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);

    listTrace = DetailId.fromJson(response);

    return listTrace;
  }

  Future<List<ListTraceability>> searchConsume(
    Paging? paging,
    ListTraceability trace,
    String? pointCd,
    String? itemName,
    // String method,
    // String url,
  ) async {
    List<ListTraceability> listTrace = [];
    Map<String, String> body = {
      "consumedByParentId": trace.itemId ?? "",
      "itemName": itemName ?? "",
      "pointCd": pointCd ?? "",
      "connsumedByItemCd": trace.itemCd ?? "",
    };

    if (paging != null) body.addAll(paging.toJson());
    var response = await api.getConsumeList(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: body,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listTrace.add(ListTraceability.fromJson(element));
      }
    }

    return listTrace;
  }

  Future<List<TpAttribute>> getDetailTp(String? itemId, String? itemCd,
      String? pointCd, String? childItem, String? childItemCd) async {
    List<TpAttribute> listProduct = [];
    Map<String, String> body = {
      "itemId": itemId ?? "",
      "itemCd": itemCd ?? "",
      "pointCd": pointCd ?? "",
      "childItemId": childItem ?? "",
      "childItemCd": childItemCd ?? "",
    };

    var response = await api.getAttributeList(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body) as Map<String, dynamic>;

    if (response['tpAttribute'] is List) {
      for (var element in (response['tpAttribute'] as List)) {
        listProduct.add(TpAttribute.map(element));
      }
    }

    return listProduct;
  }

  Future<List<KeyVal>> getProductList(
    bool? isConsume,
  ) async {
    Map<String, dynamic> body = {
      "isConsume": isConsume ?? false,
      "pointCd": "",
      "pointType": "",
      "companyCd": "",
      "cbKey": "",
      "cbName": "",
      "cbDesc": "",
    };
    List<KeyVal> listProduct = [];

    var response = await api.getProduct(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, body: body);

    for (var element in (response as List)) {
      if (element is Map) {
        listProduct.add(KeyVal(element["cbName"], element["cbKey"]));
      }
    }
    return listProduct;
  }
}
