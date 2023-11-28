part of 'download_bloc.dart';


abstract class DownloadEvent {}

class DownloadTemplateUploadMstItem extends DownloadEvent {}

class DownloadTemplateUploadMaterial extends DownloadEvent {}

class DownloadLogDetails extends DownloadEvent {
  final LogModel model;
  final String? processId;
  DownloadLogDetails(this.model, this.processId);
}