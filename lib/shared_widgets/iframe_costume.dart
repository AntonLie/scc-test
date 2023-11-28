import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';

import 'package:universal_html/html.dart';
import 'package:scc_web/theme/colors.dart';
import 'dart:ui' as ui;

class IframeCostume extends StatefulWidget {
  final String? src;
  final double? height, width;
  const IframeCostume({super.key, this.src, this.height, this.width});

  @override
  State<IframeCostume> createState() => _IframeCostumeState();
}

class _IframeCostumeState extends State<IframeCostume> {
  bool showNavBar = true;
  final IFrameElement _iFrameElement = IFrameElement();

  @override
  void initState() {
    _iFrameElement.height = '450';
    _iFrameElement.width = '250';
    _iFrameElement.style.width = '80%';
    _iFrameElement.style.height = '100%';
    _iFrameElement.src = widget.src;
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
      // (int viewId) => _iFrameElement2,
    );
    // ignore: undefined_prefixed_name

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? context.deviceWidth() * 0.4,
      height: widget.height ?? context.deviceHeight() * 0.4,
      child: _iframeWidget,
    );
  }
}
