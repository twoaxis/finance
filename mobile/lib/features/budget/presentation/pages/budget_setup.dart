import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';

class BudgetSetup extends StatefulWidget {
  const BudgetSetup({super.key});

  @override
  State<BudgetSetup> createState() => _BudgetSetupState();
}

class _BudgetSetupState extends State<BudgetSetup> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    var state = context.read<UserCubit>().state;
    if (state is UserStateAuthenticated && state.user.budget != null) {
      valueController.text = state.user.budget!.value.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is BudgetActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
        } else if (state is BudgetActionFailure) {
          setState(() {
            pending = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(fullscreenSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Set a budget.",
                                      style: TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Setting up the budget will remove all previous budget and spending data.",
                                      style:
                                      TextStyle(fontSize: 15, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.money_off_csred,
                                size: 100,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          ThemedInputField(
                            label: "Limit (leave empty to remove budget)",
                            controller: valueController,
                            placeholder: "2000",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Set the budget",
                  enabled: !pending,
                  onPressed: () {
                    if (valueController.text.isEmpty) {
                      context.read<BudgetBloc>().add(const UpdateBudgetEvent(null));
                    } else if (double.tryParse(valueController.text) == null ||
                        double.parse(valueController.text) < 1) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Limit has to be a valid number and at least 1."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Okay"),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      context.read<BudgetBloc>().add(
                            UpdateBudgetEvent(
                              Budget(
                                spent: 0,
                                value: double.parse(valueController.text),
                              ),
                            ),
                          );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
