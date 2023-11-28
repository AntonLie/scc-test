import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/detail_transaction.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/services/restapi.dart';

part 'detail_transaction_event.dart';
part 'detail_transaction_state.dart';

class DetailTransactionBloc
    extends Bloc<DetailTransactionEvent, DetailTransactionState> {
  RestApi api = RestApi();
  Paging? paging;
  late Login _login;

  DetailTransactionBloc() : super(DetailTransactionInitial()) {
    on<DetailTransactionEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is GetDetailtransactionData) {
          emit(TransactionLoading());
          var data =
              await getDataDetailTransactionTable(event.paging, event.model);
          emit(DetailTransactionLoaded(data, paging));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            await deleteUser(db);
            emit(OnLogoutTransaction());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          emit(OnLogoutTransaction());
        } else {
          emit(TransactionError(e.toString()));
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

  refreshToken(DatabaseHelper db, {DetailTransactionEvent? event}) async {
    String? username = _login.username;
    var result = await api.refreshToken(body: _login.toRefresh())
        as Map<String, dynamic>;
    _login = Login.map(result);
    _login.username = username;
    await db.saveUser(_login);
    if (event != null) add(event);
  }

  deleteUser(db) async {
    await db.dbClear();
  }

  Future<List<DetailTransactionModel>> getDataDetailTransactionTable(
    Paging? paging,
    DetailTransactionModel model,
  ) async {
    List<DetailTransactionModel> listData = [];
    Map<String, String> param = {
      "searchBy": model.searchBy ?? "",
      "searchValue": model.searchValue ?? "",
      "type": model.type ?? "",
    };
    if (paging != null) param.addAll(paging.toJson());
    var response = await api.getDetailTransactionTable(
      param: param,
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
    ) as Map<String, dynamic>;
    this.paging = Paging.map(response);
    if (response['listData'] is List) {
      for (var element in (response['listData'] as List)) {
        listData.add(DetailTransactionModel.fromJson(element));
      }
    } else {
      listData = [];
    }
    return listData;
  }
}
