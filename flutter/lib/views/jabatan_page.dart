import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:si_penggajian/bloc/jabatan_bloc/jabatan_bloc.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/utils.dart';
import 'package:si_penggajian/widgets/confirmation_dialog.dart';
import 'package:si_penggajian/widgets/custom_app_bar.dart';
import 'package:si_penggajian/widgets/my_flushbar.dart';
import 'package:si_penggajian/widgets/option_selector.dart';
import 'package:si_penggajian/widgets/search_bar.dart';

class JabatanPage extends StatefulWidget {
  final String viewType;
  final String token;
  const JabatanPage({super.key, required this.viewType, required this.token});

  @override
  State<JabatanPage> createState() => _JabatanPageState();
}

class _JabatanPageState extends State<JabatanPage> {
  final _tecSearch = TextEditingController();
  String _selectedOrderBy = 'ASC';
  final List<String> _orderByItems = ['ASC', 'DESC'];

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  List<Jabatan> _sort(List<Jabatan> jabatan) {
    jabatan.sort((a, b) {
      final comp1 = double.parse(a.gajiPokok!).compareTo(double.parse(b.gajiPokok!));
      if (comp1 == 0) {
        final comp2 = double.parse(a.tunjanganJabatan!).compareTo(double.parse(b.tunjanganJabatan!));
        if (_selectedOrderBy == 'ASC') return comp2;
        return -1 * comp2;
      }

      if (_selectedOrderBy == 'ASC') return comp1;
      return -1 * comp1;
    });
    return jabatan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        toolbarHeight: 100.0,
        searchBar: SearchBar(
          controller: _tecSearch,
          hintText: 'Search Nama Jabatan',
          onSubmitted: (query) {
            context.read<JabatanBloc>().add(SearchJabatan(query: query ?? ''));
          }
        ),
        content: [
          OptionSelector(
            label: 'Order By Gaji Pokok: ',
            currentValue: _selectedOrderBy,
            items:  _orderByItems,
            onChanged: (value) { setState(() { _selectedOrderBy = value!; }); },
          ),

          if (widget.viewType == 'ADMIN')
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              backgroundColor: Colors.deepPurple.withOpacity(0.7)
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/create-update-jabatan');
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 5.0,),
                Text('Create Jabatan', style: TextStyle(color: Colors.white)),
              ],
            )
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: BlocConsumer<JabatanBloc, JabatanState>(
        listener: (context, state) {
          if (state is JabatanError) {
            MyFlushbar(message: state.message, flushbarType: FlushbarType.error).show(context);
          }
          
          if (state is JabatanDeleted) {
            const MyFlushbar(
              message: 'Jabatan deleted successfully!',
              flushbarType: FlushbarType.success
            ).show(context);
            context.read<JabatanBloc>().add(SearchJabatan(query: _tecSearch.text));
          }
        },
        builder: (context, state) {
          if (state is JabatanLoaded) {
            final jabatan = _sort(state.jabatan);

            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                childAspectRatio: widget.viewType == 'ADMIN' ? 110.0/210.0 : 110.0/150.0
              ),
              itemCount: jabatan.length,
              itemBuilder: (context, index) {
                return _buildJabatanCard(jabatan: jabatan[index]);
              },
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0,),
                Text('Loading Jabatan...', style: TextStyle(color: Colors.deepPurple.shade900),)
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildJabatanCard({required Jabatan jabatan}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 10.0,
      color: Colors.purple.shade100.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  jabatan.nama!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade900
                  ),
                ),
                Divider(color: Colors.blueGrey.shade900),
                Text(
                  'Gaji Pokok',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade900
                  ),
                ),
                Text(
                  Utils.formatToRupiah(jabatan.gajiPokok!),
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade800
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  'Tunjangan Jabatan',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade900
                  ),
                ),
                Text(
                  Utils.formatToRupiah(jabatan.tunjanganJabatan!),
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade800
                  ),
                ),
              ],
            ),
            if (widget.viewType == 'ADMIN') _buildActionButtons(jabatan: jabatan)
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons({required Jabatan jabatan}) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.cyan.shade700.withOpacity(0.8)
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/create-update-jabatan', arguments: { 'jabatan': jabatan });
          },
          child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 15.0),)
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Colors.redAccent.shade200.withOpacity(0.8)
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Jabatan',
                content: 'Apakah Anda ingin delete data jabatan ini?',
                onConfirmed: () {
                  context.read<JabatanBloc>().add(DeleteJabatan(id: jabatan.id!, token: widget.token));
                }
              )
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 15.0),)
        )
      ],
    );
  }
}