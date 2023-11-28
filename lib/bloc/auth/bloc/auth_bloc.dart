
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/helper/db_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthLogin) {
          var db = DatabaseHelper();
          var loginModel = await db.getUser();
          // print('Checking Shared Preferences');
          if (loginModel != null) {
            // print('Shared Preferences is Exist');
            emit(AuthLoggedIn());
          } else {
            // print('Shared Preferences Not Found');
            emit(AuthLoggedOut());
          }
        }
      } catch (e) {
        // print(e.toString());
        emit(AuthError(e.toString()));
      }
    });
  }
}
