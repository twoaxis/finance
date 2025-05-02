import 'package:flutter_bloc/flutter_bloc.dart';

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  void updateName(name) {
    emit(name);
  }

}