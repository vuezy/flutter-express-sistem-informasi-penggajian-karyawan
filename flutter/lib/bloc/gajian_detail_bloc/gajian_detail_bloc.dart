import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/gajian_detail_model.dart';
import 'package:si_penggajian/repositories/gajian_repository.dart';

part 'gajian_detail_event.dart';
part 'gajian_detail_state.dart';

class GajianDetailBloc extends Bloc<GajianDetailEvent, GajianDetailState> {
  final GajianRepository gajianRepository;

  GajianDetailBloc({required this.gajianRepository}) : super(GajianDetailInitial()) {
    on<GetGajianDetail>(_getGajianDetail);
    on<PreviewGajian>(_previewGajian);
  }

  void _getGajianDetail(GetGajianDetail event, Emitter<GajianDetailState> emit) async {
    emit(GajianDetailLoading());
    try {
      final gajian = await gajianRepository.getGajianDetail(event.id, event.token);
      emit(GajianDetailLoaded(gajian: gajian));
    }
    catch (e) {
      emit(GajianDetailError(message: e.toString()));
    }
  }

  void _previewGajian(PreviewGajian event, Emitter<GajianDetailState> emit) async {
    emit(GajianDetailLoading());
    try {
      final gajian = await gajianRepository.previewGajian(event.gajian, event.token);
      emit(GajianDetailLoaded(gajian: gajian));
    }
    catch (e) {
      emit(GajianDetailError(message: e.toString()));
    }
  }
}
