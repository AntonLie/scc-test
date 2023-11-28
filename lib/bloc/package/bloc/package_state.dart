part of 'package_bloc.dart';

@immutable
abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class OnLogout extends PackageState {}

class PackageError extends PackageState {
  final String error;
  PackageError(this.error);
}

class LoadPricing extends PackageState {
  final List<Pricing> listPricing;
  LoadPricing(this.listPricing);
}

class LoadContact extends PackageState {
  final Contacted contact;
  LoadContact(this.contact);
}

class LoadSubsFeatures extends PackageState {
  // final Map<String, dynamic> completeBody;
  // final List<SubsFeatures> listSubsFeatures;
  final List<SubsFeatures> listSubsFeaturesComp;
  final Map<String, Map<String, dynamic>> completeCompact;
  LoadSubsFeatures(
      // this.listSubsFeatures, this.completeBody,
      this.listSubsFeaturesComp,
      this.completeCompact);
}

class LoadContactAdmin extends PackageState {
  final ContactAdmin model;
  LoadContactAdmin(
    this.model,
  );
}

class ContactAdminSuccrss extends PackageState {}

class PackageFormLoaded extends PackageState {
  final PackageData? model;
  final List<KeyVal> listColor;
  final String? msg;
  PackageFormLoaded(
    this.model,
    this.listColor, {
    this.msg,
  });
}

class PackageDataLoaded extends PackageState {
  final List<PackageList>? data;
  final Paging? paging;
  PackageDataLoaded(
    this.data,
    this.paging,
  );
}

class PackageDataSubmited extends PackageState {
  final String? msg;
  PackageDataSubmited(
    this.msg,
  );
}

class PackageDataDeleted extends PackageState {}

class PackageDataImage extends PackageState {
  final List<Tittle> data;
  PackageDataImage(this.data);
}

class PackageDataCard extends PackageState {
  final Tittle data;
  PackageDataCard(this.data);
}

class PackageTypeLoad extends PackageState {
  final List<KeyVal> listPlant;
  final List<KeyVal> listCountry;
  final List<KeyVal> listSystem;
  PackageTypeLoad(this.listPlant, this.listCountry, this.listSystem);
}
