import 'package:flutter/material.dart';

class OverlayBackgroundMap extends StatefulWidget {
  const OverlayBackgroundMap({super.key});

  @override
  State<OverlayBackgroundMap> createState() => _OverlayBackgroundMapState();
}

class _OverlayBackgroundMapState extends State<OverlayBackgroundMap> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5.0,
      left: 0.0,
      child: Container(
        color: Colors.white.withOpacity(0.85),
        width: MediaQuery.of(context).size.width * 0.95,
        height: 575.0,
      ),
    );
  }
}
