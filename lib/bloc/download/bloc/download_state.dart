part of 'download_bloc.dart';

abstract class DownloadState {}

class DownloadInitial extends DownloadState {}

class DownloadLoading extends DownloadState {}

class TemplateUploadItemloading extends DownloadState {}

class FileDownloaded extends DownloadState {
  final FileModel fileModel;
  FileDownloaded(this.fileModel);
}

class DownloadError extends DownloadState {
  final String msg;
  DownloadError(this.msg);
}

class OnLogoutDownload extends DownloadState {}
