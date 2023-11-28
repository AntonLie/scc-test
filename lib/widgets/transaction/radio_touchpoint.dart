import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';

class RadioTouchPoint extends StatefulWidget {
  const RadioTouchPoint({super.key});

  @override
  State<RadioTouchPoint> createState() => _RadioTouchPointState();
}

enum SingingCharacter { all, item, consume }

class _RadioTouchPointState extends State<RadioTouchPoint> {
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
            title: const Text('Item'),
            leading: Radio<SingingCharacter>(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.item,
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
            title: const Text('Consume'),
            leading: Radio<SingingCharacter>(
              activeColor: sccPrimaryDashboard,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: SingingCharacter.consume,
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
