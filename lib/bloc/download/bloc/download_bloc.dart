import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/db_helper.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/model/file_model.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/model/mon_log.dart';
import 'package:scc_web/services/restapi.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  RestApi api = RestApi();
  late Login _login;

  DownloadBloc() : super(DownloadInitial()) {
    on<DownloadEvent>((event, emit) async {
      var db = DatabaseHelper();
      try {
        await _query(db);
        if (event is DownloadTemplateUploadMstItem) {
          emit(TemplateUploadItemloading());
          FileModel fileModel = await downloadTemplateItem();
          emit(FileDownloaded(fileModel));
        } else if (event is DownloadTemplateUploadMaterial) {
          emit(TemplateUploadItemloading());
          FileModel fileModel = await downloadTemplateMaterial();
          emit(FileDownloaded(fileModel));
        } else if (event is DownloadLogDetails) {
          emit(DownloadLoading());
          FileModel fileModel =
              await downloadLogDetail(event.model, event.processId);
          emit(FileDownloaded(fileModel));
        }
      } catch (e) {
        if (e is UnauthorisedException) {
          try {
            await refreshToken(db, event: event);
          } catch (e) {
            // print(e.toString());
            await deleteUser(db);
            // print("Logout success");
            emit(OnLogoutDownload());
          }
        } else if (e is InvalidInputException) {
          await deleteUser(db);
          // print("Logout success");
          emit(OnLogoutDownload());
        } else {
          emit(DownloadError(e.toString()));
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

  refreshToken(DatabaseHelper db, {DownloadEvent? event}) async {
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

  Future<FileModel> downloadTemplateItem() async {
    var resp = await api.downloadTemplateItem(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      // param: {"base64": "true"},
    ) as Map<String, dynamic>;
    return FileModel.map(resp);
  }

  Future<FileModel> downloadTemplateMaterial() async {
    var resp = await api.downloadTemplateMaterial(
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      // param: {"base64": "true"},
    ) as Map<String, dynamic>;
    return FileModel.map(resp);
  }

  Future<FileModel> downloadLogDetail(LogModel model, String? processId) async {
    var resp = await api.downloadLogDetail(
      processId ?? "",
      header: {
        "Authorization": "${_login.tokenType!} ${_login.accessToken!}",
      },
      param: {
        "pageNo": "1",
        "pageSize": "100000",
        "messageId": model.messageId ?? "",
        "messageType": model.messageType ?? "",
        "location": model.location ?? "",
        "messageDetail": model.messageDetail ?? "",
      },
    ) as Map<String, dynamic>;
    return FileModel.map(resp);
  }
}
