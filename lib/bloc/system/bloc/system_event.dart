part of 'system_bloc.dart';


abstract class SystemEvent {}

class GetOption extends SystemEvent {
  final String? systemTypeCd;
  GetOption(this.systemTypeCd);
}
