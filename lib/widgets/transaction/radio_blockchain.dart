import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class RadioBlockChain extends StatefulWidget {
  const RadioBlockChain({super.key});

  @override
  State<RadioBlockChain> createState() => _RadioBlockChainState();
}

enum SingingCharacter { all, yes, no }

class _RadioBlockChainState extends State<RadioBlockChain> {
  SingingCharacter? _character = SingingCharacter.all;

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
            title: const Text('All'),
            leading: Radio(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.all,
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
            title: const Text('Yes'),
            leading: Radio<SingingCharacter>(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.yes,
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
            title: const Text('No'),
            leading: Radio<SingingCharacter>(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.no,
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
