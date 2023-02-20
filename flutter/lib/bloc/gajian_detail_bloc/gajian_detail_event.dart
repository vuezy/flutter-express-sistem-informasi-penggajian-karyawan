part of 'gajian_detail_bloc.dart';

abstract class GajianDetailEvent {
  final String token;
  const GajianDetailEvent({required this.token});
}

class GetGajianDetail extends GajianDetailEvent {
  final int id;
  const GetGajianDetail({required this.id, required super.token});
}

class PreviewGajian extends GajianDetailEvent {
  final Map<String, int> gajian;
  const PreviewGajian({required this.gajian, required super.token});
}