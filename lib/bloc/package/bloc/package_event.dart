part of 'package_bloc.dart';

@immutable
abstract class PackageEvent {}

class GetPricing extends PackageEvent {}

class GetSubsFeatures extends PackageEvent {}

class GetContactAdmin extends PackageEvent {}

class SubmitContactAdmin extends PackageEvent {
  final ContactAdmin model;
  SubmitContactAdmin(this.model);
}

class GetTeksCard extends PackageEvent {}

class GetPackageInfo extends PackageEvent {
  final int package;
  GetPackageInfo(this.package);
}

class GetTeksImage extends PackageEvent {}

class GetPackageTypeDropdown extends PackageEvent {}
