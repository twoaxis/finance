import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/account/presentation/bloc/account_bloc.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';

class AccountCurrency extends StatelessWidget {
  const AccountCurrency({super.key});

  static const currencies = {
    'USD': 'United States Dollar',
    'EUR': 'Euro',
    'EGP': 'Egyptian Pound',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'CNY': 'Chinese Yuan',
    'INR': 'Indian Rupee',
    'SAR': 'Saudi Riyal',
    'AED': 'UAE Dirham',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'CHF': 'Swiss Franc',
    'ZAR': 'South African Rand',
    'KWD': 'Kuwaiti Dinar',
    'QAR': 'Qatari Riyal',
    'TRY': 'Turkish Lira',
    'NOK': 'Norwegian Krone',
    'SEK': 'Swedish Krona',
    'DKK': 'Danish Krone',
    'RUB': 'Russian Ruble',
    'MXN': 'Mexican Peso',
    'BRL': 'Brazilian Real',
    'ARS': 'Argentine Peso',
    'PKR': 'Pakistani Rupee',
    'THB': 'Thai Baht',
    'IDR': 'Indonesian Rupiah',
    'KRW': 'South Korean Won',
    'SGD': 'Singapore Dollar',
    'MYR': 'Malaysian Ringgit',
    'NGN': 'Nigerian Naira',
    'TWD': 'Taiwan Dollar',
    'VND': 'Vietnamese Dong',
    'PLN': 'Polish Zloty',
    'CZK': 'Czech Koruna',
    'HUF': 'Hungarian Forint',
    'ILS': 'Israeli Shekel',
    'RON': 'Romanian Leu',
    'UAH': 'Ukrainian Hryvnia',
    'DZD': 'Algerian Dinar',
    'MAD': 'Moroccan Dirham',
    'JOD': 'Jordanian Dinar',
    'LBP': 'Lebanese Pound',
    'TND': 'Tunisian Dinar',
    'OMR': 'Omani Rial',
    'BHD': 'Bahraini Dinar',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Currency'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is! UserStateAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          var selectedCurrency = state.user.currency;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: currencies.length,
            separatorBuilder: (_, __) => Divider(
              color: Theme.of(context).colorScheme.surfaceContainer, height: 1),
            itemBuilder: (context, index) {
              var code = currencies.keys.elementAt(index);
              var name = currencies[code]!;

              var isSelected = code == selectedCurrency;

              return ListTile(
                title: Text('$code - $name'),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.read<AccountBloc>().add(UpdateCurrencyEvent(code));
                },
              );
            },
          );
        },
      ),
    );
  }
}
