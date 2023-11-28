import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class RadioSort extends StatefulWidget {
  const RadioSort({super.key});

  @override
  State<RadioSort> createState() => _RadioSortState();
}

enum SingingCharacter { asc, desc }

class _RadioSortState extends State<RadioSort> {
  SingingCharacter? _character = SingingCharacter.asc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('Ascending (A-Z)'),
            leading: Radio(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.asc,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('Descending (Z-A)'),
            leading: Radio<SingingCharacter>(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.desc,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
