// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/model/use_case.dart';
import 'package:scc_web/services/restapi.dart';

part 'use_case_event.dart';
part 'use_case_state.dart';

class UseCaseBloc extends Bloc<UseCaseEvent, UseCaseState> {
  RestApi api = RestApi();

  Paging? paging;

  late Login _login;
  UseCaseBloc() : super(UseCaseInitial()) {
    on<UseCaseEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetUseCaseData) {
          emit(UseCaseLoading());
          List<ListUseCaseData> searchPointList = await searchUseCase(
            event.paging,
            event.useCaseCd,
            event.useCaseName,
            event.statusCd,
          );
          emit(DataUseCase(
            searchPointList,
            paging,
          ));
        } else if (event is LoadFormUseCase) {
          emit(UseCaseLoading());
          dynamic model;
          if (event.formMode != Constant.addMode) {
            model = await viewUseCase(event.useCaseCd);
          }
          List<KeyVal> listAttr = await getAttr();
          List<KeyVal> listPoint = await getPoint();
          List<KeyVal> listTouchPoint = await getTouchPoint();
          emit(UseCaseForm(listAttr, listPoint, listTouchPoint, model));
        } else if (event is DeleteUseCase) {
          emit(UseCaseLoading());

          await api.deleteUseCase(
            header: {
              "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
            },
            useCaseCd: event.useCaseCd!,
          );
          emit(UseCaseDeleted());
        } else if (event is SubmitUseCase) {
          emit(UseCaseLoading());
          String msg = await submitForm(event.model!, event.formMode);

          emit(UseCaseSubmited(msg));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutUseCase());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutUseCase());
        } else {
          emit(UseCaseError(e.toString()));
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

  refreshToken(DatabaseHelper db, {UseCaseEvent? event}) async {
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

  Future<List<ListUseCaseData>> searchUseCase(
    Paging? paging,
    String? useCaseCd,
    String? useCaseName,
    String? statusCd,
    // String? companyCd,
    // String method,
    // String url,
  ) async {
    List<ListUseCaseData> listUseCase = [];
    Map<String, String> params = {
      "useCaseCd": useCaseCd ?? "",
      "useCaseName": useCaseName ?? "",
      "statusCd": statusCd ?? "",
      // "companyCd": companyCd ?? "",
    };
    if (paging != null) params.addAll(paging.toJson());
    var response = await api.searchUseCase(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);

    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listUseCase.add(ListUseCaseData.fromJson(element));
      }
    }
    //// print(response);

    return listUseCase;
  }

  Future<List<KeyVal>> getAttr() async {
    List<KeyVal> listAttr = [];

    var response = await api.searchAttribute(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageSize": "1000",
        "pageNo": "1",
        "attributeCd": "",
        "attributeName": "",
        "companyCd": "",
        "attrTypeCd": ""
      },
    );

    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listAttr
              .add(KeyVal(element["attributeName"], element["attributeCd"]));
        }
      }
    }
    return listAttr;
  }

  Future<List<KeyVal>> getPoint() async {
    List<KeyVal> listPoint = [];
    Map<String, String> params = {
      "pageSize": "1000",
      "pageNo": "1",
      "pointTypeCd": "",
      "pointName": "",
      "type": "",
    };

    var response = await api.searchPoint(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;
    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listPoint.add(KeyVal(element["pointName"], element["pointCd"]));
        }
      }
    }
    return listPoint;
  }

  Future<List<KeyVal>> getTouchPoint() async {
    List<KeyVal> listTouchPoint = [];
    Map<String, String> params = {
      "pageSize": "1000",
      "pageNo": "1",
      "pointTypeCd": "",
      "pointName": "",
      "type": "",
    };

    var response = await api.searchPoint(
      // method,
      // url,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: params,
    ) as Map<String, dynamic>;
    if (response['listData'] != null) {
      for (var element in (response['listData'] as List)) {
        if (element is Map) {
          listTouchPoint.add(KeyVal(element["pointType"], element["pointCd"]));
        }
      }
    }
    return listTouchPoint;
  }

  Future<dynamic> viewUseCase(
    String? useCaseCd,
  ) async {
    var response = await api.viewUseCase(
      // method,
      // url,
      useCaseCd: useCaseCd,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;

    return ListUseCaseData.fromJson(response);
  }

  Future<String> submitForm(
    ListUseCaseData model,
    String? formMode,
    // String createMethod,
    // String createUrl,
    // String updateMethod,
    // String updateUrl,
  ) async {
    String message = "";

    if (formMode == Constant.addMode) {
      await api.saveUseCase(
        // createMethod,
        // createUrl,
        header: {
          "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
        },
        body: model.toSubmit(),
      ) as Map;
      message =
          "${model.useCaseName ?? "[Username]"} has been successfully added to the master role list.";
    } else {
      await api.editUseCase(
          // updateMethod,
          // updateUrl,
          useCaseCd: model.useCaseCd,
          header: {
            "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
          },
          body: model.toSubmit()) as Map;
      message =
          "${model.useCaseName ?? "[UserName]"} has been successfully edited.";
    }

    return message;
  }
}
