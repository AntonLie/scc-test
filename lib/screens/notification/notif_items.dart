import 'package:flutter/material.dart';
import 'package:scc_web/helper/app_scale.dart';


class NotifItem extends StatefulWidget {
  const NotifItem({Key? key}) : super(key: key);

  @override
  State<NotifItem> createState() => _NotifItemState();
}

class _NotifItemState extends State<NotifItem> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hovered ? Colors.grey.shade400 : Colors.white,
        ),
        // constraints: BoxConstraints(
        //   minHeight: 0,
        //   maxHeight: context.deviceHeight() / 5,
        // ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade300,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const SizedBox(),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SelectableText(
                        "Title",
                        minLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: context.scaleFont(16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "testing with long text",
                    style: TextStyle(color: Colors.blue, fontSize: context.scaleFont(14)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SelectableText(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam, quis nostrud exercitation ullamco.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: context.scaleFont(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
