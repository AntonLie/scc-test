part of 'use_case_bloc.dart';

@immutable
abstract class UseCaseEvent {}

class GetUseCaseData extends UseCaseEvent {
  final Paging? paging;
  // final String? companyCd;
  final String? useCaseCd;
  final String? useCaseName;
  final String? statusCd;
  GetUseCaseData({
    this.paging,
    this.useCaseCd,
    this.useCaseName,
    // this.companyCd,
    this.statusCd,
  });
}

class LoadFormUseCase extends UseCaseEvent {
  final String? useCaseCd;
  final String? formMode;
  LoadFormUseCase({this.useCaseCd, this.formMode});
}

class SubmitUseCase extends UseCaseEvent {
  final String? useCaseCd;
  final ListUseCaseData? model;
  final String? formMode;
  SubmitUseCase({this.model, this.useCaseCd, this.formMode});
}

class DeleteUseCase extends UseCaseEvent {
  final String? useCaseCd;
  DeleteUseCase({
    required this.useCaseCd,
  });
}
