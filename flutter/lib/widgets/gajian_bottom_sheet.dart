import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/gajian_bloc/gajian_bloc.dart';
import 'package:si_penggajian/bloc/gajian_detail_bloc/gajian_detail_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/models/gajian_model.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/widgets/custom_text_field.dart';
import 'package:si_penggajian/widgets/dropdown_field.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

enum GajianActionType { create, update }

class GajianBottomSheet extends StatefulWidget {
  final Gajian? gajian;
  const GajianBottomSheet({super.key, this.gajian});

  @override
  State<GajianBottomSheet> createState() => _GajianBottomSheetState();
}

class _GajianBottomSheetState extends State<GajianBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedIdKaryawan;
  late int _selectedIdJabatan;
  late TextEditingController _tecIdAttendance;
  late GajianActionType action;

  @override
  void initState() {
    super.initState();
    _tecIdAttendance = TextEditingController(text: widget.gajian?.idAttendance.toString());

    if (widget.gajian == null) {
      action = GajianActionType.create;
      _selectedIdKaryawan = 0;
      _selectedIdJabatan = 0;
    }
    else {
      action = GajianActionType.update;
      _selectedIdKaryawan = widget.gajian!.idKaryawan!;
      _selectedIdJabatan = widget.gajian!.idJabatan!;
    }
  }

  @override
  void dispose() {
    _tecIdAttendance.dispose();
    super.dispose();
  }

  void _submitForm(String token) {
    if (_formKey.currentState!.validate()) {
      if (action == GajianActionType.create) {
        context.read<GajianBloc>().add(CreateGajian(
          gajian: {
            'id_karyawan': _selectedIdKaryawan,
            'id_jabatan': _selectedIdJabatan,
            'id_attendance': int.parse(_tecIdAttendance.text)
          },
          token: token
        ));
      }

      if (action == GajianActionType.update) {
        context.read<GajianBloc>().add(UpdateGajian(
          id: widget.gajian!.id!,
          gajian: {
            'id_karyawan': _selectedIdKaryawan,
            'id_jabatan': _selectedIdJabatan,
            'id_attendance': int.parse(_tecIdAttendance.text)
          },
          token: token
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade200,
            Colors.purple.shade100,
            Colors.pink.shade100,
          ]
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.purple.shade200,
              boxShadow: const [
                BoxShadow(color: Colors.black26, offset: Offset(0.0, 5.0), blurRadius: 8.0)
              ]
            ),
            child: Text(
              action == GajianActionType.create ? 'Create Gajian' : 'Update Gajian (ID: ${widget.gajian!.id})',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade900
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoggedIn) {
                  final token = state.account.token;

                  return BlocConsumer<GajianBloc, GajianState>(
                    listener: (context, state) {
                      if (state is GajianError) {
                        MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                      }
  
                      if (state is GajianReceivedOrCreated) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/admin',
                          arguments: { 'pageIndex': 1 },
                          (route) => false
                        );
                        MyFlushbar(message: state.message, flushbarType: FlushbarType.success).show(context);
                      }
  
                      if (state is GajianUpdated) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/admin',
                          arguments: { 'pageIndex': 1 },
                          (route) => false
                        );
                        const MyFlushbar(
                          message: 'Gajian updated successfully!',
                          flushbarType: FlushbarType.success
                        ).show(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is GajianLoading) return const Center(child: CircularProgressIndicator());

                      return BlocConsumer<KaryawanBloc, KaryawanState>(
                        listener: (context, state) {
                          if (state is KaryawanError) {
                            MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                          }
                        },
                        builder: (context, state) {
                          if (state is KaryawanLoaded) {
                            final karyawan = state.karyawan;

                            return BlocConsumer<JabatanBloc, JabatanState>(
                              listener: (context, state) {
                                if (state is JabatanError) {
                                  MyFlushbar(
                                    message: state.message,
                                    flushbarType: FlushbarType.error
                                  ).show(context);
                                }
                              },
                              builder: (context, state) {
                                if (state is JabatanLoaded) {
                                  final jabatan = state.jabatan;
                                  
                                  if (_selectedIdKaryawan == 0) {
                                    _selectedIdKaryawan = karyawan[0].id!;
                                  }
                                  if (_selectedIdJabatan == 0) {
                                    _selectedIdJabatan = jabatan[0].id!;
                                  }

                                  return _buildForm(token: token!, karyawan: karyawan, jabatan: jabatan);
                                }
                                return const Center(child: CircularProgressIndicator());
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          )
        ],
      ),
    );
  }

  Widget _buildForm({
    required String token,
    required List<Karyawan> karyawan,
    required List<Jabatan> jabatan
  }) {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          DropdownField(
            label: 'Karyawan',
            value: _selectedIdKaryawan,
            items: karyawan.map((k) => {
              'value': k.id,
              'text': k.nama
            }).toList(),
            onChanged: (value) => { setState(() { _selectedIdKaryawan = value!; }) }
          ),
          const SizedBox(height: 20.0,),
          DropdownField(
            label: 'Jabatan',
            value: _selectedIdJabatan,
            items: jabatan.map((j) => {
              'value': j.id,
              'text': j.nama
            }).toList(),
            onChanged: (value) => { setState(() { _selectedIdJabatan = value!; }) }
          ),
          const SizedBox(height: 20.0,),
          CustomTextField(
            label: 'ID Attendance',
            controller: _tecIdAttendance,
            hintText: 'ID Attendance',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20.0,),
          ButtonBar(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700.withOpacity(0.7)
                ),
                onPressed: () {
                  context.read<GajianDetailBloc>().add(PreviewGajian(
                    gajian: {
                      'id_karyawan': _selectedIdKaryawan,
                      'id_jabatan': _selectedIdJabatan,
                      'id_attendance': int.parse(_tecIdAttendance.text)
                    },
                    token: token
                  ));
                  Navigator.of(context).pushNamed('/preview-gajian');
                },
                child: const Text('Preview')
              ),
              ElevatedButton(
                onPressed: () { _submitForm(token); },
                child: Text(action == GajianActionType.create ? 'Create' : 'Update')
              )
            ],
          )
        ]
      )
    );
  }
}