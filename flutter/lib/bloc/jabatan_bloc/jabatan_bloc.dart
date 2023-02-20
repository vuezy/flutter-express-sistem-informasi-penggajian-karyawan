import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/repositories/jabatan_repository.dart';

part 'jabatan_event.dart';
part 'jabatan_state.dart';

class JabatanBloc extends Bloc<JabatanEvent, JabatanState> {
  final JabatanRepository jabatanRepository;

  JabatanBloc({required this.jabatanRepository}) : super(JabatanInitial()) {
    on<SearchJabatan>(_searchJabatan);
    on<CreateJabatan>(_createJabatan);
    on<UpdateJabatan>(_updateJabatan);
    on<DeleteJabatan>(_deleteJabatan);
  }

  void _searchJabatan(SearchJabatan event, Emitter<JabatanState> emit) async {
    emit(JabatanLoading());
    try {
      final jabatan = await jabatanRepository.searchJabatan(event.query);
      emit(JabatanLoaded(jabatan: jabatan));
    }
    catch (e) {
      emit(JabatanError(message: e.toString()));
    }
  }

  void _createJabatan(CreateJabatan event, Emitter<JabatanState> emit) async {
    emit(JabatanLoading());
    try {
      final message = await jabatanRepository.createJabatan(event.jabatan, event.token!);
      emit(JabatanCreated(message: message));
    }
    catch (e) {
      emit(JabatanError(message: e.toString()));
    }
  }

  void _updateJabatan(UpdateJabatan event, Emitter<JabatanState> emit) async {
    emit(JabatanLoading());
    try {
      await jabatanRepository.updateJabatan(event.id, event.jabatan, event.token!);
      emit(JabatanUpdated());
    }
    catch (e) {
      emit(JabatanError(message: e.toString()));
    }
  }

  void _deleteJabatan(DeleteJabatan event, Emitter<JabatanState> emit) async {
    emit(JabatanLoading());
    try {
      await jabatanRepository.deleteJabatan(event.id, event.token!);
      emit(JabatanDeleted());
    }
    catch (e) {
      emit(JabatanError(message: e.toString()));
    }
  }
}
