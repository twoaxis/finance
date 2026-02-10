import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/income/presentation/bloc/income_bloc.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';

class IncomeEditItem extends StatefulWidget {
  const IncomeEditItem({super.key, required this.index, required this.income});

  final int index;
  final Income income;

  @override
  State<IncomeEditItem> createState() => _IncomeEditItemState();
}

class _IncomeEditItemState extends State<IncomeEditItem> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.income.name;
    valueController.text = widget.income.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomeBloc, IncomeState>(
      listener: (context, state) {
        if (state is IncomeActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is IncomeActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (state is IncomeActionFailure) {
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
            padding: const EdgeInsets.all(fullscreenSpacing),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is! UserStateAuthenticated) {
                  return const Center(child: CircularProgressIndicator());
                }

                var incomeList = state.user.income;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              ThemedInputField(
                                  label: "Name",
                                  controller: nameController,
                                  placeholder: "Job",
                                enabled: !pending,
                                  textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              ThemedInputField(
                                label: "Value",
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
                      text: "Update income source",
                      enabled: !pending,
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            valueController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please fill all fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Okay"),
                                  )
                                ],
                              );
                            },
                          );
                        } else if (double.tryParse(valueController.text) == null ||
                            double.parse(valueController.text) < 0) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please enter a valid positive value."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Okay"),
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          var newIncomeList = List<Income>.from(incomeList);
                          newIncomeList[widget.index] = Income(
                            name: nameController.text,
                            value: double.parse(valueController.text),
                          );

                          context.read<IncomeBloc>().add(UpdateIncomeListEvent(newIncomeList));
                        }
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
