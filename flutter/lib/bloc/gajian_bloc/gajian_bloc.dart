import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/gajian_model.dart';
import 'package:si_penggajian/repositories/gajian_repository.dart';

part 'gajian_event.dart';
part 'gajian_state.dart';

class GajianBloc extends Bloc<GajianEvent, GajianState> {
  final GajianRepository gajianRepository;

  GajianBloc({required this.gajianRepository}) : super(GajianInitial()) {
    on<GetGajianList>(_getGajianList);
    on<ReceiveGajian>(_receiveGajian);
    on<SearchGajian>(_searchGajian);
    on<CreateGajian>(_createGajian);
    on<UpdateGajian>(_updateGajian);
    on<DeleteGajian>(_deleteGajian);
  }

  void _getGajianList(GetGajianList event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      final gajian = await gajianRepository.getGajianList(event.token);
      emit(GajianLoaded(gajian: gajian));
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }

  void _receiveGajian(ReceiveGajian event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      final message = await gajianRepository.receiveGajian(event.id, event.token);
      emit(GajianReceivedOrCreated(message: message));
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }

  void _searchGajian(SearchGajian event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      final gajian = await gajianRepository.searchGajian(event.query, event.token);
      emit(GajianLoaded(gajian: gajian));
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }

  void _createGajian(CreateGajian event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      final message = await gajianRepository.createGajian(event.gajian, event.token);
      emit(GajianReceivedOrCreated(message: message));
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }

  void _updateGajian(UpdateGajian event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      await gajianRepository.updateGajian(event.id, event.gajian, event.token);
      emit(GajianUpdated());
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }

  void _deleteGajian(DeleteGajian event, Emitter<GajianState> emit) async {
    emit(GajianLoading());
    try {
      await gajianRepository.deleteGajian(event.id, event.token);
      emit(GajianDeleted());
    }
    catch (e) {
      emit(GajianError(message: e.toString()));
    }
  }
}
