import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:scc_web/bloc/auth/bloc/auth_bloc.dart';
import 'package:scc_web/bloc/home/bloc/home_bloc.dart';
import 'package:scc_web/bloc/profile/bloc/profile_bloc.dart';
import 'package:scc_web/helper/app_route.gr.dart';
import 'package:scc_web/helper/app_scale.dart';
import 'package:scc_web/helper/assisted_auto_route.dart';
import 'package:scc_web/helper/constant.dart';
import 'package:scc_web/model/login.dart';
import 'package:scc_web/shared_widgets/custom_app_bar.dart';
import 'package:scc_web/shared_widgets/expandable_widget.dart';
import 'package:scc_web/shared_widgets/nav_drawer.dart';
import 'package:scc_web/theme/colors.dart';
import 'package:scc_web/theme/padding.dart';
import 'package:scc_web/widgets/transaction/divider_detail.dart';
import 'package:scc_web/widgets/transaction/search_transaction.dart';
import 'package:scc_web/widgets/transaction/spacing.dart';
import 'package:scc_web/widgets/transaction/transaction_detail.dart';
import 'package:scc_web/widgets/transaction/transaction_table.dart';
import 'package:scc_web/widgets/transaction/transaction_title.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc()..add(GetMenu()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: const Scaffold(
          backgroundColor: sccBackground,
          drawerEnableOpenDragGesture: false,
          body: Transaction()),
    );
  }
}

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Login? login;
  String formMode = "";
  bool expandNavBar = true;
  bool showNavBar = true;
  final controller = ScrollController();
  final ScrollController scrollController = ScrollController();

  void handleSearch() async {
    final dio = Dio(BaseOptions());
    final dioAdapter = DioAdapter(dio: dio);
    // Set up a mock response for GET requests to "https://example.com"
    dioAdapter.onGet(
      'https://example.com',
      (server) => server.reply(
        200,
        {'message': 'Success!'},
        // Delay the response by 1 second
        delay: const Duration(seconds: 1),
      ),
    );
    // Send a GET request to "https://example.com" using Dio
    final response = await dio.get('https://example.com');
    // The response should contain the mock data we registered
    print(response.data); // {message: Success!}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authBloc(AuthEvent event) {
      BlocProvider.of<AuthBloc>(context).add(event);
    }

    homeBloc(HomeEvent event) {
      BlocProvider.of<HomeBloc>(context).add(event);
    }

    return MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                context.push(const LoginRoute());
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is LoadHome) {
                login = state.login;
                if (login == null) {
                  homeBloc(DoLogout(login: login));
                }
              }
              if (state is OnLogoutHome) {
                authBloc(AuthLogin());
              }
            },
          ),
        ],
        child: Column(
          children: [
            BlocProvider(
              create: (context) => ProfileBloc()..add(GetProfileData()),
              child: CustomAppBar(
                menuTitle: "Dashboard",
                formMode: formMode,
                showNavBar: showNavBar,
                initiallyExpanded: expandNavBar,
                onExpand: () {
                  setState(() {
                    expandNavBar = !expandNavBar;
                  });
                },
              ),
            ),
            Expanded(
                child: Row(
              children: [
                ExpandableWidget(
                  expand: context.isDesktop(),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => HomeBloc()..add(GetMenu()),
                      ),
                      BlocProvider(
                        create: (context) => AuthBloc(),
                      ),
                    ],
                    child: PersistDrawer(
                      initiallyExpanded: expandNavBar,
                      selectedTile: Constant.transaction,
                    ),
                  ),
                ),
                Flexible(
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => HomeBloc(),
                        ),
                        BlocProvider(
                          create: (context) => AuthBloc(),
                        ),
                      ],
                      child: Scrollbar(
                        thumbVisibility: false,
                        controller: scrollController,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          controller: scrollController,
                          children: [
                            Column(
                              children: [
                                Container(
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      controller: controller,
                                      padding: sccOutterPadding,
                                      child: const Column(
                                        children: [
                                          //Need To Move
                                          TransactionTitle(),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          SearchTransaction(),
                                          Spacing(),
                                          TransactionTable(),
                                          DividerDetail(),
                                          TranssactionDetail(),
                                          SizedBox(
                                            height: 50.0,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ))
          ],
        ));
  }
}
