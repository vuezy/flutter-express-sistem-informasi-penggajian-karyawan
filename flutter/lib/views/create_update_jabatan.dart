import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/custom_text_field.dart';
import 'package:si_penggajian/widgets/form_header.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

enum JabatanActionType { create, update }

class CreateUpdateJabatan extends StatefulWidget {
  final Jabatan? jabatan;
  const CreateUpdateJabatan({super.key, this.jabatan});

  @override
  State<CreateUpdateJabatan> createState() => _CreateUpdateJabatanState();
}

class _CreateUpdateJabatanState extends State<CreateUpdateJabatan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tecNama;
  late TextEditingController _tecGajiPokok;
  late TextEditingController _tecTunjanganJabatan;
  late JabatanActionType action;

  @override
  void initState() {
    super.initState();
    _tecNama = TextEditingController(text: widget.jabatan?.nama);
    _tecGajiPokok = TextEditingController(
      text: widget.jabatan?.gajiPokok!.replaceFirst('.00', '') ?? '0'
    );
    _tecTunjanganJabatan = TextEditingController(
      text: widget.jabatan?.tunjanganJabatan!.replaceFirst('.00', '') ?? '0'
    );

    if (widget.jabatan == null) {
      action = JabatanActionType.create;
    }
    else {
      action = JabatanActionType.update;
    }
  }

  @override
  void dispose() {
    _tecNama.dispose();
    _tecGajiPokok.dispose();
    _tecTunjanganJabatan.dispose();
    super.dispose();
  }

  void _submitForm(String token) {
    if (_formKey.currentState!.validate()) {
      if (action == JabatanActionType.create) {
        context.read<JabatanBloc>().add(CreateJabatan(
          jabatan: {
            'nama': _tecNama.text,
            'gaji_pokok': _tecGajiPokok.text,
            'tunjangan_jabatan': _tecTunjanganJabatan.text,
          },
          token: token
        ));
      }

      if (action == JabatanActionType.update) {
        context.read<JabatanBloc>().add(UpdateJabatan(
          id: widget.jabatan!.id!,
          jabatan: {
            'nama': _tecNama.text,
            'gaji_pokok': _tecGajiPokok.text,
            'tunjangan_jabatan': _tecTunjanganJabatan.text,
          },
          token: token
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      image: 'assets/images/light-purple-bg.jpg',
      gradientType: GradientType.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            children: [
              if (action == JabatanActionType.create)
              const FormHeader(title: 'Create Jabatan')
              else
              FormHeader(title: 'Update Jabatan', showId: true, id: widget.jabatan!.id),
    
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoggedIn) {
                    final token = state.account.token;
    
                    return BlocConsumer<JabatanBloc, JabatanState>(
                      listener: (context, state) {
                        if (state is JabatanError) {
                          MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                        }
    
                        if (state is JabatanCreated) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/admin',
                            arguments: { 'pageIndex': 2 },
                            (route) => false
                          );
                          MyFlushbar(message: state.message, flushbarType: FlushbarType.success).show(context);
                        }
    
                        if (state is JabatanUpdated) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/admin',
                            arguments: { 'pageIndex': 2 },
                            (route) => false
                          );
                          const MyFlushbar(
                            message: 'Jabatan updated successfully!',
                            flushbarType: FlushbarType.success
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is JabatanLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return _buildForm(token: token!);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
              )
            ]
          )
        )
      ),
    );
  }

  Widget _buildForm({required String token}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Nama',
            controller: _tecNama,
            hintText: 'Nama Jabatan',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20.0,),
          CustomTextField(
            label: 'Gaji Pokok',
            controller: _tecGajiPokok,
            hintText: 'Gaji Pokok',
            prefixText: 'Rp ',
            suffixText: ',00',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20.0,),
          CustomTextField(
            label: 'Tunjangan Jabatan',
            controller: _tecTunjanganJabatan,
            hintText: 'Tunjangan Jabatan',
            prefixText: 'Rp ',
            suffixText: ',00',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20.0,),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              onPressed: () { _submitForm(token); },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(action == JabatanActionType.create ? Icons.add : Icons.save),
                  const SizedBox(width: 5.0,),
                  Text(
                    action == JabatanActionType.create ? 'Create' : 'Update',
                    style: const TextStyle(fontSize: 16.0)
                  )
                ],
              )
            ),
          ),
          const SizedBox(height: 20.0,),
        ],
      )
    );
  }
}