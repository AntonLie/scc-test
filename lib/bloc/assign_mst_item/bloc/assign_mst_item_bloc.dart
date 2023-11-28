import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/assign_mst_item.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/services/restapi.dart';
import 'package:scc_web/model/system_master.dart';

part 'assign_mst_item_event.dart';
part 'assign_mst_item_state.dart';

class AssignMstItemBloc extends Bloc<AssignMstItemEvent, AssignMstItemState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  AssignMstItemBloc() : super(AssignMstItemInitial()) {
    on<AssignMstItemEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetMstItemData) {
          emit(MstItemLoading());
          var data = await getDataMstItemTable(event.paging, event.model);
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("USECASE_ITEM_STATUS");
          List<KeyVal> listPoint = await searchPoint();
          List<ListUseCaseData> listUseCase = await searchUseCase();
          emit(MstItemLoaded(
              data, paging, listSysMaster, listPoint, listUseCase));
        } else if (event is SubmitMstItemData) {
          emit(MstItemLoading());
          try {
            await addMstItem(event.model);
            emit(MstItemAdd(
                "${event.model.itemName} has been successfully added in Assign Master Item"));
          } catch (e) {
            emit(MstItemError(e.toString()));
          }
        } else if (event is ToMstItemAddEdit) {
          emit(MstItemLoading());
          AssignMstItem? listItem;
          if (event.model != null) {
            listItem = await getViewMstItem(event.model!);
          }
          emit(MstItemFormLoaded(listItem));
        } else if (event is UploadMstItem) {
          emit(LoadUpload());
          try {
            var message = await uploadMasterItem(event.model);
            emit(SuccesUpload(message));
          } catch (e) {
            emit(MstItemUploadError(e.toString()));
          }
        } else if (event is GetProductName) {
          emit(MstItemLoading());
          String pointCd = await getProductName(event.pointCd);
          emit(MstItemGetProduct(pointCd));
        } else if (event is UploadBillMaterial) {
          emit(LoadUpload());
          try {
            var message = await uploadBillMaterial(event.model);
            emit(SuccesUpload(message));
            // emit(MstItemAdd(
            //     "Upload has been successfully in Assign Master Item"));
          } catch (e) {
            emit(MstItemUploadError(e.toString()));
          }
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutMstItem());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutMstItem());
        } else {
          emit(MstItemError(e.toString()));
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

  refreshToken(DatabaseHelper db, {AssignMstItemEvent? event}) async {
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

  Future<List<AssignMstItem>> getDataMstItemTable(
    Paging? paging,
    AssignMstItem model,
  ) async {
    List<AssignMstItem> listData = [];
    Map<String, String> param = {
      "searchBy": model.searchBy ?? "",
      "searchValue": model.searchValue ?? "",
      "statusCd": model.statusCd ?? "",
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.getMstItemDataTable(
      param: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(AssignMstItem.fromJson(element));
      }
    } else {
      listData = [];
    }
    return listData;
  }

  Future<List<SystemMaster>> searchSystemMaster(String systemTypeCd) async {
    List<SystemMaster> listSysMaster = [];
    var response = await api.searchSystemMaster(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "systemTypeCd": systemTypeCd,
      },
    );
    if (response['listData'] != null && response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listSysMaster.add(SystemMaster.map(element));
      }
    }
    return listSysMaster;
  }

  Future<List<KeyVal>> searchPoint() async {
    List<KeyVal> listPoint = [];
    var response = await api.getPointUpload(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    );

    if (response != null) {
      for (var element in (response as List)) {
        if (element is Map) {
          listPoint.add(KeyVal(element["pointName"], element["pointCd"]));
        }
      }
    }

    // listPoint.add(TouchPointUpload.fromJson(response));

    return listPoint;
  }

  Future<List<ListUseCaseData>> searchUseCase() async {
    List<ListUseCaseData> listUseCase = [];
    Map<String, String> params = {
      "useCaseCd": "",
      "useCaseName": "",
      "statusCd": "",
      "pageNo": "1",
      "pageSize": "1000",
    };
    var response = await api.searchUseCase(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listUseCase.add(ListUseCaseData.fromJson(element));
      }
    }
    return listUseCase;
  }

  addMstItem(
    AssignMstItem model,
  ) async {
    var response = await api.addMstItem(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: model.toAdd(),
    ) as Map<String, dynamic>;

    return response;
  }

  Future<AssignMstItem> getViewMstItem(
    AssignMstItem model,
  ) async {
    Map<String, String> params = {
      "itemCd": model.itemCd!,
      "supplierCd": model.supplierCd!,
    };
    var response = await api.getMstItemView(
      param: params,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    return AssignMstItem.fromJson(response);
  }

  Future<MessageUpload> uploadBillMaterial(
    AssignMstItem model,
  ) async {
    Map<String, String> bodys = {
      "fileBase64": model.fileBase64 ?? "",
      "otherParam": model.pointCd ?? "",
    };
    var response = await api.uploadBillMaterial(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      body: bodys,
      // body: model.toAdd(),
    ) as Map<String, dynamic>;

    MessageUpload message = MessageUpload.fromJson(response['data']);

    return message;
  }

  Future<String> getProductName(String? pointCd) async {
    String? point;

    var response = await api.getProductName(header: {
      "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
    }, param: {
      "ItemCd": pointCd ?? "",
    });

    point = response ?? "";
    // return FileModel.map(resp);
    return point!;
  }

  Future<MessageUpload> uploadMasterItem(
    AssignMstItem model,
  ) async {
    Map<String, String> bodys = {
      "fileBase64": model.file ?? "",
      "otherParam": model.useCaseCd ?? "",
    };
    var response = await api.uploadMstItem(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      // body: model.toAdd(),
      body: bodys,
    ) as Map<String, dynamic>;
    MessageUpload message = MessageUpload.fromJson(response['data']);

    return message;
  }
}
