import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/karyawan_bloc/karyawan_bloc.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/option_selector.dart';
import 'package:si_penggajian/widgets/search_bar.dart';

class KaryawanPage extends StatefulWidget {
  final String token;
  const KaryawanPage({super.key, required this.token});

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  final _tecSearch = TextEditingController();
  String _selectedOrderBy = 'Usia (ASC)';
  final List<String> _orderByItems = [
    'Usia (ASC)',
    'Usia (DESC)',
    'Jumlah Anak (ASC)',
    'Jumlah Anak (DESC)'
  ];

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  List<Karyawan> _sort(List<Karyawan> karyawan) {
    karyawan.sort((a, b) {
      final comp1 = a.usia!.compareTo(b.usia!);
      final comp2 = a.menikah!.compareTo(b.menikah!);
      final comp3 = a.jlhAnak!.compareTo(b.jlhAnak!);

      if (_selectedOrderBy == 'Usia (ASC)') {
        if (comp1 == 0) {
          if (comp2 == 0) return comp3;
          return comp2;
        }
        return comp1;
      }

      if (_selectedOrderBy == 'Usia (DESC)') {
        if (comp1 == 0) {
          if (comp2 == 0) return -1 * comp3;
          return -1 * comp2;
        }
        return -1 * comp1;
      }

      if (_selectedOrderBy == 'Jumlah Anak (ASC)') {
        if (comp2 == 0) {
          if (comp3 == 0) return comp1;
          return comp3;
        }
        return comp2;
      }

      if (_selectedOrderBy == 'Jumlah Anak (DESC)') {
        if (comp2 == 0) {
          if (comp3 == 0) return -1 * comp1;
          return -1 * comp3;
        }
        return -1 * comp2;
      }

      return 0;
    });

    return karyawan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        backgroundColor: Colors.purple.shade200,
        elevation: 10.0,
        title: SearchBar(
          controller: _tecSearch,
          hintText: 'Search Nama Karyawan',
          onSubmitted: (query) {
            context.read<KaryawanBloc>().add(SearchKaryawan(query: query ?? '', token: widget.token));
          }
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OptionSelector(
                label: 'Order By: ',
                currentValue: _selectedOrderBy,
                items: _orderByItems,
                onChanged: (value) { setState(() { _selectedOrderBy = value!; }); },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: BlocConsumer<KaryawanBloc, KaryawanState>(
        listener: (context, state) {
          if (state is KaryawanError) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
          }
          if (state is KaryawanDeleted) {
            const MyFlushbar(
              message: 'Karyawan deleted successfully!',
              flushbarType: FlushbarType.success,
            ).show(context);
            context.read<KaryawanBloc>().add(SearchKaryawan(query: '', token: widget.token));
          }
        },
        builder: (context, state) {
          if (state is KaryawanLoaded) {
            final karyawan = _sort(state.karyawan);

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: karyawan.length,
              itemBuilder: (context, index) {
                return _buildKaryawanListTile(karyawan: karyawan[index]);
              },
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0,),
                Text('Loading Karyawan...', style: TextStyle(color: Colors.deepPurple.shade900),)
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildKaryawanListTile({required Karyawan karyawan}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.purple.shade100,
            Colors.purple.shade200.withOpacity(0.8),
            Colors.deepPurple.shade100.withOpacity(0.6)
          ]
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0.0, 10.0), blurRadius: 8.0)
        ]
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 5.0),
        title: Text(
          karyawan.nama!,
          style: const TextStyle(
            color: Colors.black87,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w600,
            fontSize: 22.0
          )
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(text: karyawan.jabatan!, style: const TextStyle(fontSize: 18.0)),
                  TextSpan(text: '\nUsia: ${karyawan.usia} tahun', style: const TextStyle(fontSize: 16.0)),
                ]
              )
            )
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            context.read<KaryawanBloc>().add(GetProfileKaryawan(id: karyawan.id!, token: widget.token));
            Navigator.of(context).pushReplacementNamed(
              '/admin',
              arguments: { 'pageIndex': 4, 'profileId': karyawan.id }
            );
          },
          child: const Text('View Profile'),
        ),
      ),
    );
  }
}