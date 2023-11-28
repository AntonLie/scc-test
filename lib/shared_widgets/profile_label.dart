import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/profile.dart';
import 'package:scc_web/theme/colors.dart';

class ProfileLabel extends StatefulWidget {
  final String? label;

  const ProfileLabel({
    Key? key,
    this.label,
  }) : super(key: key);

  @override
  State<ProfileLabel> createState() => _ProfileLabelState();
}

class _ProfileLabelState extends State<ProfileLabel> {
  Profile profile = Profile();

  authBloc(AuthEvent event) {
    BlocProvider.of<AuthBloc>(context).add(event);
  }

  profileBloc(ProfileEvent event) {
    BlocProvider.of<ProfileBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(listener: (context, state) {
          if (state is ProfileError) {
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(failSnackBar(message: state.error));
          }
          if (state is OnLogoutProfile) {
            authBloc(AuthLogin());
          }
          if (state is ProfileView) {
            setState(() {
              profile = state.profile;
            });
          }
        })
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return SelectableText('${widget.label}${profile.fullName ?? ""}',
            style: TextStyle(
                fontSize: context.scaleFont(24),
                fontWeight: FontWeight.w600,
                color: sccPrimaryDashboard));
      }),
    );
  }
}
