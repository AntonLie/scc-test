import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/master_attribute.dart';
import 'package:scc_web/model/master_product.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/system_master.dart';
import 'package:scc_web/services/restapi.dart';

part 'master_product_event.dart';
part 'master_product_state.dart';

class MasterProductBloc extends Bloc<MasterProductEvent, MasterProductState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  MasterProductBloc() : super(MasterProductInitial()) {
    on<MasterProductEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetProductData) {
          emit(ProductLoading());
          var data = await getDataProductTable(event.paging, event.model);
          emit(ProductDataLoaded(data, paging));
        } else if (event is DeleteProductData) {
          emit(ProductLoading());
          await api.deleteMasterProduct(
            header: {
              "Authorization": "${_login.tokenType} ${_login.accessToken}"
            },
            productCd: event.productCd!,
          );
          emit(ProductDataDeleted());
        } else if (event is ToProductForm) {
          emit(ProductLoading());
          MasterProductModel? productData;
          if (event.model != null) {
            productData = await getProductData(event.model!);
          }
          List<SystemMaster> listSysMaster =
              await searchSystemMaster("PRODUCT");
          List<MstAttribute> listAttribute = await searchMstAttr();
          emit(ProductFormLoaded(productData, listSysMaster, listAttribute));
        } else if (event is AddProductData) {
          emit(ProductLoading());
          try {
            String msg =
                await addProduct(model: event.model, formMode: event.formMode);
            // List<MasterProductModel> listModel =
            //     await getDataProductTable(event.paging, event.model);
            emit(AddProductSubmit(msg, paging));
          } catch (e) {
            emit(ProductError(e.toString()));
          }
        }
        //  else if (event is EditProductData) {
        //   emit(ProductLoading());
        //   try {
        //     await editProduct(event.model);
        //     emit(EditProductSubmit(
        //         "${event.model.productName} has been successfully updated in Master Product"));
        //   } catch (e) {
        //     emit(ProductError(e.toString()));
        //   }
        // }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutProduct());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutProduct());
        } else {
          emit(ProductError(e.toString()));
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

  refreshToken(DatabaseHelper db, {MasterProductEvent? event}) async {
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

  Future<List<MasterProductModel>> getDataProductTable(
    Paging? paging,
    MasterProductModel model,
  ) async {
    List<MasterProductModel> listData = [];
    Map<String, String> param = {
      "productName": model.productName ?? "",
      "productDesc": model.productDesc ?? "",
      "touchPoint": model.touchPoint ?? "",
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.getProductDataTable(
      param: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(MasterProductModel.fromJson(element));
      }
    }
    return listData;
  }

  Future<MasterProductModel> getProductData(
    MasterProductModel modelView,
  ) async {
    var response = await api.getMstProduct(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      productCd: modelView.productCd!,
    ) as Map<String, dynamic>;
    MasterProductModel model = MasterProductModel.fromJson(response);
    return model;
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

  Future<List<MstAttribute>> searchMstAttr() async {
    List<MstAttribute> listData = [];
    Map<String, String> param = // model.toSearch();
        {
      "attributeName": "",
      "attributeCd": "",
      "attrTypeCd": "",
      "pageNo": "1",
      "pageSize": "1000",
    };
    var response = await api.searchMstAttr(
      header: {"Authorization": "${_login.tokenType} ${_login.accessToken}"},
      param: param,
    ) as Map<String, dynamic>;

    for (var element in (response['listData'] as List)) {
      MstAttribute wfResp = MstAttribute.map(element);
      listData.add(wfResp);
    }

    return listData;
  }

  Future<String> addProduct({
    required MasterProductModel model,
    String? formMode,
    String? createMethod,
    String? updateMethod,
  }) async {
    String message = "";
    if (formMode == Constant.addMode) {
      await api.addMstProduct(
        createMethod ?? "POST",
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toAdd(),
      ) as Map;
      message =
          "${model.productName} has been successfully added to the master product.";
    } else {
      await api.updateMstProduct(
        updateMethod ?? "PUT",
        productCd: model.productCd,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toAdd(),
      ) as Map;
      message = "${model.productName} has been successfully edited.";
    }
    return message;
  }
}
