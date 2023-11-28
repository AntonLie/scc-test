import 'package:flutter/material.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/transaction/transaction_map.dart';
import 'package:scc_web/widgets/transaction/transaction_stepper.dart';
import 'package:scc_web/widgets/transaction/transaction_stepper_top.dart';

class TranssactionDetail extends StatefulWidget {
  const TranssactionDetail({super.key});

  @override
  State<TranssactionDetail> createState() => _TranssactionDetailState();
}

class _TranssactionDetailState extends State<TranssactionDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 45.0),
      child: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Track Position",
                  style: TextStyle(
                      color: sccPrimaryDashboard,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "COVER SUB-ASSY",
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  "69210-bz390-c0#69210-bz390-c0#31-august",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TransactionTopStepper(),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(width: double.infinity, child: TransactionStepper()),
              ],
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Flexible(flex: 2, child: TransactionMap())
        ],
      ),
    );
  }
}
