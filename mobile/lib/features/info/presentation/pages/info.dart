import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/version/domain/entities/version.dart';
import 'package:twoaxis_finance/features/version/presentation/cubit/version_cubit.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: BlocBuilder<VersionCubit, Version>(
        builder: (context, version) {
          return ListView(
            children: [
              ListTile(
                title: Text("Version",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                subtitle: Text(version.version,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                leading: Icon(Icons.build,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                onTap: () {},
              ),
              Divider(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  height: 1),
              ListTile(
                title: Text("Build Number",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                subtitle: Text(version.buildNumber,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                leading: Icon(Icons.build,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                onTap: () {},
              ),
              Divider(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  height: 1),
              const SizedBox(height: 30),
              Text(
                "(c) ${DateTime.now().year} TwoAxis. All Rights Reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          );
        },
      ),
    );
  }
}
