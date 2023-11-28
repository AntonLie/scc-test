import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scc_web/bloc/system/bloc/system_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/keyval.dart';
import 'package:scc_web/helper/utils.dart';
import 'package:scc_web/shared_widgets/portal_dropdown.dart';
import 'package:scc_web/shared_widgets/snackbars.dart';
import 'package:scc_web/theme/colors.dart';

class PagingDropdown extends StatefulWidget {
  final String? selected;
  final Function(int) onSelect;

  const PagingDropdown({
    Key? key,
    required this.onSelect,
    required this.selected,
  }) : super(key: key);

  @override
  State<PagingDropdown> createState() => _PagingDropdownState();
}

class _PagingDropdownState extends State<PagingDropdown> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SystemBloc()..add(GetOption('PAGING'))),
        ],
        child: PagingDropdownBody(
          selected: widget.selected,
          onSelect: (val) => widget.onSelect(val),
        ));
    // return PagingDropdownBody(
    //   selected: widget.selected,
    //   onSelect: (val) => widget.onSelect(val),
    // );
  }
}

class PagingDropdownBody extends StatefulWidget {
  final String? selected;
  final Function(int) onSelect;
  const PagingDropdownBody(
      {Key? key, required this.onSelect, required this.selected})
      : super(key: key);

  @override
  State<PagingDropdownBody> createState() => _PagingDropdownBodyState();
}

class _PagingDropdownBodyState extends State<PagingDropdownBody> {
  String? selected;
  List<KeyVal> opt = [];

  @override
  void initState() {
    selected = widget.selected;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  void didUpdateWidget(PagingDropdownBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(
        () {
          selected = widget.selected;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SystemBloc, SystemState>(
          listener: (context, state) {
            if (state is SystemError) {
              showTopSnackBar(
                  context, UpperSnackBar.error(message: state.error));
            }
            if (state is OptionLoaded) {
              opt.clear();
              for (var element in state.listData) {
                if (element.systemValue != null) {
                  opt.add(KeyVal(
                      "${element.systemValue!} Rows", element.systemValue!));
                }
              }
              if (opt.isNotEmpty && (selected == null || selected == "0")) {
                selected = opt.first.value;
                widget.onSelect(int.tryParse(selected.number) ?? 0);
              }
            }
            if (state is OnLogoutSystem) {
              context.push(const LoginRoute());
            }
          },
        ),
      ],
      child: SizedBox(
        width: context.deviceWidth() * 0.09,
        child: BlocBuilder<SystemBloc, SystemState>(
          builder: (context, state) {
            return PortalFormDropdown(
              selected,
              opt,
              borderRadius: 8,
              fontweight: FontWeight.bold,
              borderColour: Colors.transparent,
              fillColour: sccWhite,
              hintText: 'Paging',
              enabled: opt.length > 1,
              onChange: (val) {
                setState(() {
                  selected = val;
                });
                widget.onSelect(int.tryParse(selected.number) ?? 0);
              },
            );
          },
        ),
      ),
    );
  }
}
