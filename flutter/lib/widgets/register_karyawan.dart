import 'package:flutter/material.dart';
import 'package:si_penggajian/models/jabatan_model.dart';

class RegisterKaryawan extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Jabatan> jabatan;
  const RegisterKaryawan({super.key, required this.formKey, required this.jabatan});

  @override
  State<RegisterKaryawan> createState() => RegisterKaryawanState();
}

class RegisterKaryawanState extends State<RegisterKaryawan> {
  final tecNama = TextEditingController();
  final tecUsia = TextEditingController();
  final tecJlhAnak = TextEditingController();
  final tecAlamat = TextEditingController();
  final tecNoTelp = TextEditingController();
  final tecNoRek = TextEditingController();
  String selectedMenikah = 'BELUM';
  String selectedGender = 'Laki-Laki';
  late int selectedIdJabatan;
  final List<Map<String, String>> _genderItems = [
    { 'value': 'Laki-Laki', 'text': 'Laki-Laki' },
    { 'value': 'Perempuan', 'text': 'Perempuan' },
  ];
  final List<Map<String, String>> _menikahItems = [
    { 'value': 'BELUM', 'text': 'BELUM' },
    { 'value': 'SUDAH', 'text': 'SUDAH' },
  ];
  late List<Map<String, dynamic>> _jabatanItems;

  @override
  void initState() {
    super.initState();
    _jabatanItems = widget.jabatan.map((j) => {
      'value': j.id,
      'text': j.nama,
    }).toList();
    selectedIdJabatan = _jabatanItems[0]['value'];
  }

  @override
  void dispose() {
    tecNama.dispose();
    tecUsia.dispose();
    tecJlhAnak.dispose();
    tecAlamat.dispose();
    tecNoTelp.dispose();
    tecNoRek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Nama',
            controller: tecNama,
            hintText: 'Nama',
            keyboardType: TextInputType.name
          ),
          const SizedBox(height: 10.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdownField<String>(
                  label: 'Gender',
                  value: selectedGender,
                  items: _genderItems,
                  onChanged: (value) => setState(() { selectedGender = value!; })
                ),
              ),
              Expanded(
                child: _buildTextField(
                  label: 'Usia',
                  controller: tecUsia,
                  hintText: 'Usia',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdownField<String>(
                  label: 'Status Menikah',
                  value: selectedMenikah,
                  items:  _menikahItems,
                  onChanged: (value) => setState(() { selectedMenikah = value!; })
                ),
              ),
              Expanded(
                child: _buildTextField(
                  label: 'Jumlah Anak',
                  controller: tecJlhAnak,
                  hintText: 'Jumlah Anak',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          _buildTextField(
            label: 'Alamat',
            controller: tecAlamat,
            hintText: 'Alamat',
          ),
          const SizedBox(height: 10.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'No. Telp',
                  controller: tecNoTelp,
                  hintText: 'Nomor Telepon',
                  keyboardType: TextInputType.number
                ),
              ),
              Expanded(
                child: _buildTextField(
                  label: 'No. Rek',
                  controller: tecNoRek,
                  hintText: 'Nomor Rekening',
                  keyboardType: TextInputType.number
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          _buildDropdownField<int>(
            label: 'Jabatan',
            value: selectedIdJabatan,
            items: _jabatanItems,
            onChanged: (value) => setState(() { selectedIdJabatan = value!; })
          ),
          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 3.0,),
        TextFormField(
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white60, fontSize: 12.0),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0),
            errorMaxLines: 3,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.deepPurple.shade200)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.deepPurple.shade500)
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) return '$label must be provided!';
            if (keyboardType == TextInputType.number) {
              if (value.contains(RegExp(r'\D+'))) return '$label must contain only numbers!';
            }
            if (keyboardType == TextInputType.name) {
              if (value.contains(RegExp(r'[^A-Za-z ]+'))) return '$label must contain only alphabets!';
            }
            else {
              if (value.contains(RegExp(r'[^A-Za-z0-9\.\- ]+'))) {
                return '$label must contain only alphabets and numbers!';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<Map<String, dynamic>> items,
    required void Function(T?) onChanged
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 3.0,),
        Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade400.withOpacity(0.3),
            border: Border.all(color: Colors.deepPurple.shade200),
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              style: const TextStyle(fontSize: 12.0),
              dropdownColor: Colors.deepPurple.shade400.withOpacity(0.85),
              menuMaxHeight: 200.0,
              value: value,
              items: items.map((item) => DropdownMenuItem(
                value: item['value'] as T,
                child: Text(item['text'].toString()),
              )).toList(),
              onChanged: onChanged
            ),
          ),
        ),
      ],
    );
  }
}