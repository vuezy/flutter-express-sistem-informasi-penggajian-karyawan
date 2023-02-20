part of 'karyawan_bloc.dart';

abstract class KaryawanEvent {
  final String token;
  const KaryawanEvent({required this.token});
}

class GetProfileKaryawan extends KaryawanEvent {
  final int id;
  const GetProfileKaryawan({required this.id, required super.token});
}

class UpdateProfileKaryawan extends KaryawanEvent {
  final int id;
  final Map<String, dynamic> karyawan;
  const UpdateProfileKaryawan({required this.id, required this.karyawan, required super.token});
}

class SearchKaryawan extends KaryawanEvent {
  final String query;
  const SearchKaryawan({required this.query, required super.token});
}

class DeleteKaryawan extends KaryawanEvent {
  final int id;
  const DeleteKaryawan({required this.id, required super.token});
}