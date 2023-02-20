import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/repositories/karyawan_repository.dart';

part 'karyawan_event.dart';
part 'karyawan_state.dart';

class KaryawanBloc extends Bloc<KaryawanEvent, KaryawanState> {
  final KaryawanRepository karyawanRepository;

  KaryawanBloc({required this.karyawanRepository}) : super(KaryawanInitial()) {
    on<GetProfileKaryawan>(_getProfileKaryawan);
    on<UpdateProfileKaryawan>(_updateProfileKaryawan);
    on<SearchKaryawan>(_searchKaryawan);
    on<DeleteKaryawan>(_deleteKaryawan);
  }

  void _getProfileKaryawan(GetProfileKaryawan event, Emitter<KaryawanState> emit) async {
    emit(KaryawanLoading());
    try {
      final karyawan = await karyawanRepository.getProfile(event.id, event.token);
      emit(ProfileKaryawanLoaded(karyawan: karyawan));
    }
    catch (e) {
      emit(KaryawanError(message: e.toString()));
    }
  }

  void _updateProfileKaryawan(UpdateProfileKaryawan event, Emitter<KaryawanState> emit) async {
    emit(KaryawanLoading());
    try {
      await karyawanRepository.updateProfile(event.id, event.karyawan, event.token);
      emit(ProfileKaryawanUpdated());
    }
    catch (e) {
      emit(KaryawanError(message: e.toString()));
    }
  }

  void _searchKaryawan(SearchKaryawan event, Emitter<KaryawanState> emit) async {
    emit(KaryawanLoading());
    try {
      final karyawan = await karyawanRepository.searchKaryawan(event.query, event.token);
      emit(KaryawanLoaded(karyawan: karyawan));
    }
    catch (e) {
      emit(KaryawanError(message: e.toString()));
    }
  }

  void _deleteKaryawan(DeleteKaryawan event, Emitter<KaryawanState> emit) async {
    emit(KaryawanLoading());
    try {
      await karyawanRepository.deleteKaryawan(event.id, event.token);
      emit(KaryawanDeleted());
    }
    catch (e) {
      emit(KaryawanError(message: e.toString()));
    }
  }
}
