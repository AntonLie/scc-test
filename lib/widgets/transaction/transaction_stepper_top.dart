import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/theme/colors.dart';

class TransactionTopStepper extends StatefulWidget {
  const TransactionTopStepper({super.key});

  @override
  State<TransactionTopStepper> createState() => _TransactionTopStepperState();
}

class _TransactionTopStepperState extends State<TransactionTopStepper> {
  int activeStep = 5; // Initial step set to 5.

  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2), // border width
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: sccPrimaryDashboard, //
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Image(image: AssetImage(Constant.rawMaterial)),
                  ),
                ),
              ),
            ),
            const Text("Raw Material",
                style: TextStyle(color: sccPrimaryDashboard, fontSize: 14.0))
          ],
        ),
        Container(
          color: Colors.grey.shade400,
          height: 2.5,
          width: 45.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2), // border width
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: sccPrimaryDashboard, //
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Image(image: AssetImage(Constant.manufacture)),
                  ),
                ),
              ),
            ),
            const Text("Production",
                style: TextStyle(color: sccPrimaryDashboard, fontSize: 14.0))
          ],
        ),
        Container(
          color: Colors.grey.shade400,
          height: 2.5,
          width: 45.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2), // border width
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: sccPrimaryDashboard, //
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Image(image: AssetImage(Constant.warehouse)),
                  ),
                ),
              ),
            ),
            const Text("Warehouse",
                style: TextStyle(color: sccPrimaryDashboard, fontSize: 14.0))
          ],
        ),
        Container(
          color: Colors.grey.shade400,
          height: 2.5,
          width: 45.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2), // border width
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: sccPrimaryDashboard, //
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Image(image: AssetImage(Constant.engineering)),
                  ),
                ),
              ),
            ),
            const Text("Tools Pairing",
                style: TextStyle(color: sccPrimaryDashboard, fontSize: 14.0))
          ],
        ),
        Container(
          color: Colors.grey.shade400,
          height: 2.5,
          width: 45.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(2), // border width
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: sccPrimaryDark, //
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        const Image(image: AssetImage(Constant.productStepper)),
                  ),
                ),
              ),
            ),
            const Text("Product Pairing",
                style: TextStyle(color: sccPrimaryDark, fontSize: 14.0))
          ],
        ),
      ],
    );
  }
}
