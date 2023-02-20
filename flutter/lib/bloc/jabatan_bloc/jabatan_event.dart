part of 'jabatan_bloc.dart';

abstract class JabatanEvent {
  final String? token;
  const JabatanEvent({this.token});
}

class SearchJabatan extends JabatanEvent {
  final String query;
  const SearchJabatan({required this.query});
}

class CreateJabatan extends JabatanEvent {
  final Map<String, String> jabatan;
  const CreateJabatan({required this.jabatan, required super.token});
}

class UpdateJabatan extends JabatanEvent {
  final int id;
  final Map<String, String> jabatan;
  const UpdateJabatan({required this.id, required this.jabatan, required super.token});
}

class DeleteJabatan extends JabatanEvent {
  final int id;
  const DeleteJabatan({required this.id, required super.token});
}