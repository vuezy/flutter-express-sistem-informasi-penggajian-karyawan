part of 'gajian_bloc.dart';

abstract class GajianEvent {
  final String token;
  const GajianEvent({required this.token});
}

class GetGajianList extends GajianEvent {
  const GetGajianList({required super.token});
}

class ReceiveGajian extends GajianEvent {
  final int id;
  const ReceiveGajian({required this.id, required super.token});
}

class SearchGajian extends GajianEvent {
  final String query;
  const SearchGajian({required this.query, required super.token});
}

class CreateGajian extends GajianEvent {
  final Map<String, int> gajian;
  const CreateGajian({required this.gajian, required super.token});
}

class UpdateGajian extends GajianEvent {
  final int id;
  final Map<String, int> gajian;
  const UpdateGajian({required this.id, required this.gajian, required super.token});
}

class DeleteGajian extends GajianEvent {
  final int id;
  const DeleteGajian({required this.id, required super.token});
}