import 'package:crud_app/features/directory/presentation/bloc/directory_event.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DirectoryBloc extends Bloc<DirectoryEvent, DirectoryState> {
  DirectoryBloc() : super(DirectoryState.initial()) {
    on<UpdateAppBarTitle>((event, emit) {
      emit(state.copyWith(appBarTitle: event.title));
    });
  }
}