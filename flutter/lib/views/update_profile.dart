import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/bloc/user_bloc/user_bloc.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/widgets/background_image.dart';
import 'package:si_penggajian/widgets/custom_text_field.dart';
import 'package:si_penggajian/widgets/dropdown_field.dart';
import 'package:si_penggajian/widgets/form_header.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';

class UpdateProfile extends StatefulWidget {
  final String viewType;
  final Karyawan karyawan;
  const UpdateProfile({super.key, required this.viewType, required this.karyawan});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tecNama;
  late TextEditingController _tecUsia;
  late TextEditingController _tecJlhAnak;
  late TextEditingController _tecAlamat;
  late TextEditingController _tecNoTelp;
  late TextEditingController _tecNoRek;
  late String _selectedMenikah;
  late int _selectedIdJabatan;
  final List<Map<String, String>> _menikahItems = [
    { 'value': 'BELUM', 'text': 'BELUM' },
    { 'value': 'SUDAH', 'text': 'SUDAH' },
  ];

  @override
  void initState() {
    super.initState();
    _tecNama = TextEditingController(text: widget.karyawan.nama);
    _tecUsia = TextEditingController(text: widget.karyawan.usia.toString());
    _tecJlhAnak = TextEditingController(text: widget.karyawan.jlhAnak.toString());
    _tecAlamat = TextEditingController(text: widget.karyawan.alamat);
    _tecNoTelp = TextEditingController(text: widget.karyawan.noTelp);
    _tecNoRek = TextEditingController(text: widget.karyawan.noRek);
    _selectedMenikah = widget.karyawan.menikah!;
    _selectedIdJabatan = widget.karyawan.idJabatan!;
  }

  @override
  void dispose() {
    _tecNama.dispose();
    _tecUsia.dispose();
    _tecJlhAnak.dispose();
    _tecAlamat.dispose();
    _tecNoTelp.dispose();
    _tecNoRek.dispose();
    super.dispose();
  }

  void _updateProfile(String token) {
    if (_formKey.currentState!.validate()) {
      context.read<KaryawanBloc>().add(UpdateProfileKaryawan(
        id: widget.karyawan.id!,
        karyawan: {
          'nama': _tecNama.text,
          'usia': _tecUsia.text,
          'menikah': _selectedMenikah,
          'jlh_anak': _tecJlhAnak.text,
          'alamat': _tecAlamat.text,
          'no_telp': _tecNoTelp.text,
          'no_rek': _tecNoRek.text,
          'id_jabatan': _selectedIdJabatan
        },
        token: token
      ));
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
              FormHeader(title: 'Update Profile', showId: true, id: widget.karyawan.id!), 
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoggedIn) {
                    final token = state.account.token;

                    return BlocConsumer<KaryawanBloc, KaryawanState>(
                      listener: (context, state) {
                        if (state is KaryawanError) {
                          MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
                        }
                  
                        if (state is ProfileKaryawanUpdated) {
                          if (widget.viewType == 'ADMIN') {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/admin',
                              arguments: { 'pageIndex': 4, 'profileId': widget.karyawan.id },
                              (route) => false
                            );
                          }
                          else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home',
                              arguments: { 'pageIndex': 3 },
                              (route) => false
                            );
                          }
                          
                          const MyFlushbar(
                            message: 'Profile updated successfully!',
                            flushbarType: FlushbarType.success
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is KaryawanLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (widget.viewType == 'ADMIN') {
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
                                return _buildForm(token: token!, jabatan: state.jabatan);
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          );
                        }
                        return _buildForm(token: token!);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _buildForm({required String token, List<Jabatan>? jabatan}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CustomTextField(
                  label: 'Nama',
                  controller: _tecNama,
                  hintText: 'Nama',
                  keyboardType: TextInputType.name
                ),
              ),
              const SizedBox(width: 5.0,),
              Expanded(
                child: CustomTextField(
                  label: 'Usia',
                  controller: _tecUsia,
                  hintText: 'Usia',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: DropdownField(
                  label: 'Status Menikah',
                  value: _selectedMenikah,
                  items: _menikahItems,
                  onChanged: (value) => setState(() { _selectedMenikah = value!; })
                ),
              ),
              Expanded(
                child: CustomTextField(
                  label: 'Jumlah Anak',
                  controller: _tecJlhAnak,
                  hintText: 'Jumlah Anak',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0,),
          CustomTextField(
            label: 'Alamat',
            controller: _tecAlamat,
            hintText: 'Alamat'
          ),
          const SizedBox(height: 20.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'No. Telp',
                  controller: _tecNoTelp,
                  hintText: 'Nomor Telepon',
                  keyboardType: TextInputType.number
                ),
              ),
              const SizedBox(width: 5.0,),
              Expanded(
                child: CustomTextField(
                  label: 'No. Rek',
                  controller: _tecNoRek,
                  hintText: 'Nomor Rekening',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0,),

          if (widget.viewType == 'ADMIN')
          DropdownField(
            label: 'Jabatan',
            value: _selectedIdJabatan,
            items: jabatan!.map((j) => {
              'value': j.id,
              'text': j.nama,
            }).toList(),
            onChanged: (value) => setState(() { _selectedIdJabatan = value!; })
          ),
          if (widget.viewType == 'ADMIN')
          const SizedBox(height: 20.0,),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              onPressed: () { _updateProfile(token); },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 5.0,),
                  Text('Update', style: TextStyle(fontSize: 16.0))
                ],
              )
            ),
          ),
          const SizedBox(height: 20.0,),
        ],
      ),
    );
  }
}