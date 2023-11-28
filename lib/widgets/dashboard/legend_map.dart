import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/detail_transaction/bloc/detail_transaction_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/model/detail_transaction.dart';
import 'package:scc_web/model/paging.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/widgets/dashboard/detail-transcation/detail_transaction.dart';

class LegendMap extends StatefulWidget {
  const LegendMap({super.key});

  @override
  State<LegendMap> createState() => _LegendMapState();
}

class _LegendMapState extends State<LegendMap> {
  onConfirm(String type) {
    showDialog(
        context: context,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeBloc(),
              ),
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
              BlocProvider(
                create: (context) => DetailTransactionBloc()
                  ..add(
                    GetDetailtransactionData(
                      model: DetailTransactionModel(),
                      paging: Paging(pageNo: 1, pageSize: 5),
                    ),
                  ),
              ),
            ],
            child: DetailTransaction(type: type),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 15.0,
        top: 25.0,
        child: Row(
          children: [
            PointerInterceptor(
                child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: sccPrimaryDashboard),
                    color: sccMapContainer,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("This is your position",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.scaleFont(12))))
                  ],
                ),
              ),
            )),
            const SizedBox(width: 10),
            PointerInterceptor(
                child: InkWell(
              onTap: () {
                onConfirm("Outbound");
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: sccPrimaryDashboard),
                    color: sccMapContainer,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("Outbound",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.scaleFont(12)))),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("Inbound",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.scaleFont(12))))
                  ],
                ),
              ),
            )),
            const SizedBox(width: 10),
            PointerInterceptor(
                child: InkWell(
              onTap: () {
                onConfirm("Inbound");
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: sccPrimaryDashboard),
                    color: sccMapContainer,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0,
                      height: 5.0,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("Transaction Outbound",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.scaleFont(12)))),
                    const SizedBox(width: 10),
                    Container(
                      width: 20.0,
                      height: 5.0,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("Transaction Inbound",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.scaleFont(12)))),
                  ],
                ),
              ),
            )),
          ],
        ));
  }
}
