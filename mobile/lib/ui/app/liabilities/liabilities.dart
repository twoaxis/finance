import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities_action_button.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liability_details.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/money_format.dart';

class LiabilitiesPage extends StatefulWidget {
  const LiabilitiesPage({super.key});

  @override
  State<LiabilitiesPage> createState() => _LiabilitiesPageState();
}

class _LiabilitiesPageState extends State<LiabilitiesPage> {
  bool pending = false;
  String errorPayment = "";
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liabilities"),
        backgroundColor: darkTheme.surfaceContainer,
        actions: [LiabilitiesActionButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<LiabilitiesCubit, List<dynamic>>(
                builder: (context, liabilities) {
                  if (liabilities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              "assets/images/empty_data.png",
                              width: 200,
                            ),
                          ),
                          SizedBox(height: 20,),
                          Opacity(
                            opacity: 0.3,
                            child: Text("No liabilities added", style: TextStyle(fontSize: 25),),
                          )
                        ],
                      ),
                    );
                  }
              return ListView.separated(
                itemCount: liabilities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiabilityDetails(
                              index: index,
                              liability: liabilities[index],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(liabilities[index]["name"],
                                  style: const TextStyle(fontSize: 15)),
                            ),
                            Text(
                              formatMoneyWithContext(context, liabilities[index]["value"]),
                              style: TextStyle(
                                  color: darkTheme.surfaceTint, fontSize: 15),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios, size: 15)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: darkTheme.surfaceContainer, height: 1);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
