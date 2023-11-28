import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:scc_web/helper/ddlog.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:tuple/tuple.dart';

class TransactionStepper extends StatefulWidget {
  const TransactionStepper({super.key});

  @override
  State<TransactionStepper> createState() => _TransactionStepperState();
}

class _TransactionStepperState extends State<TransactionStepper> {
  int _index = 2;
  final StepperType _type = StepperType.vertical;
  List<Tuple5> tuples = const [
    Tuple5(Icons.location_on, StepState.indexed, "Raw Material",
        "Sugity Creatives, Cibitung", "1 August 2023 - 3 August 2023"),
    Tuple5(Icons.location_on, StepState.indexed, "Production",
        "TMMIN Plant 1, KIIC, Karawang", "3 August 2023 - 9 August 2023"),
    Tuple5(Icons.location_on, StepState.indexed, "Warehouse",
        "TMMIN Plant 2, KIIC, Karawang", "10 August 2023 - 11 August 2023"),
    Tuple5(Icons.location_on, StepState.indexed, "Tools Pairing",
        "TMMIN Plant 3, KIIC, Karawang", "1 August 2023 - 3 August 2023"),
  ];

  void ddlog(dynamic? obj) {
    DDTraceModel model = DDTraceModel(StackTrace.current);

    var list = [
      DateTime.now().toString(),
      model.fileName,
      model.className,
      model.selectorName,
      model.lineNumber == ""
          ? ""
          : "[${model.lineNumber}:${model.columnNumber}]"
    ].where((element) => element != "");
    print("${list.join(" ")}: $obj");
  }

  void go(int index) {
    if (index == -1 && _index <= 0) {
      ddlog("it's first Step!");
      return;
    }

    if (index == 1 && _index >= tuples.length - 1) {
      ddlog("it's last Step!");
      return;
    }

    setState(() {
      _index += index;
    });
  }

  handleTap(index) {
    ddlog(tuples.indexOf(index));
    setState(() {
      _index = tuples.indexOf(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EnhanceStepper(
        stepIconSize: 40,
        type: _type,
        horizontalTitlePosition: HorizontalTitlePosition.bottom,
        horizontalLinePosition: HorizontalLinePosition.top,
        currentStep: _index,
        physics: const ClampingScrollPhysics(),
        steps: tuples
            .map((e) => EnhanceStep(
                icon: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: _index == tuples.indexOf(e)
                        ? sccPrimaryDashboard
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.shade400,
                      style: _index == tuples.indexOf(e)
                          ? BorderStyle.none
                          : BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      e.item1,
                      color: _index == tuples.indexOf(e)
                          ? Colors.white
                          : Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                ),
                state: StepState.values[tuples.indexOf(e)],
                isActive: _index == tuples.indexOf(e),
                title: InkWell(
                  onTap: () => {handleTap(e)},
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${e.item3}",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: _index == tuples.indexOf(e)
                                  ? sccPrimaryDashboard
                                  : sccInfoGrey)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: _index != tuples.indexOf(e),
                              child: Text("${e.item5}",
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: sccInfoGrey))),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 20.0,
                            color: sccInfoGrey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                subtitle: InkWell(
                    onTap: () => {handleTap(e)},
                    child: Text("${e.item4}",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            color: _index == tuples.indexOf(e)
                                ? sccPrimaryDashboard
                                : sccInfoGrey))),
                content: Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        ...List.generate(20, (index) {
                          return const Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Test 1',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: sccPrimaryDashboard),
                                ),
                              ),
                              SizedBox(
                                width: 200.0,
                              ),
                              Center(
                                child: Text(
                                  'Test 2',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: sccPrimaryDashboard),
                                ),
                              )
                            ],
                          );
                        })
                      ],
                    ))))
            .toList(),
        onStepTapped: (index) {
          ddlog(index);
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return const SizedBox();
        });
  }
}
