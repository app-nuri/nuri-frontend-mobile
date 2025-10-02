import 'package:flutter/material.dart';

class HusbandDataPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const HusbandDataPage({Key? key, this.userData}) : super(key: key);

  @override
  State<HusbandDataPage> createState() => _HusbandDataPageState();
}

class _HusbandDataPageState extends State<HusbandDataPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _teleponController;
  late final TextEditingController _usiaController;
  late final TextEditingController _pekerjaanController;
  bool _submitting = false;
  String? _selectedPekerjaan;

  @override
  void initState() {
    super.initState();
    final d = widget.userData ?? {};
    _namaController = TextEditingController(text: d['nama_suami']?.toString() ?? '');
    _teleponController = TextEditingController(text: d['telepon_suami']?.toString() ?? '');
    _usiaController = TextEditingController(text: d['usia_suami']?.toString() ?? '');
    _pekerjaanController = TextEditingController(text: d['pekerjaan_suami']?.toString() ?? '');
    _selectedPekerjaan = _pekerjaanController.text.isEmpty ? null : _pekerjaanController.text;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _usiaController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  InputDecoration _decor(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF3F7FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF94A3B8))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Suami'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _namaController,
                decoration: _decor('Nama Suami'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teleponController,
                keyboardType: TextInputType.phone,
                decoration: _decor('Nomor Telepon'),
                validator: (v) {
                  final s = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                  if (s.isEmpty) return 'Wajib diisi';
                  if (s.length != 12) return 'Nomor telepon harus 12 digit !';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usiaController,
                keyboardType: TextInputType.number,
                decoration: _decor('Usia'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return 'Usia tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPekerjaan,
                decoration: _decor('Pekerjaan Suami'),
                items: const [
                  DropdownMenuItem(value: 'Pelajar/Mahasiswa', child: Text('Pelajar/Mahasiswa')),
                  DropdownMenuItem(value: 'Karyawan', child: Text('Karyawan')),
                  DropdownMenuItem(value: 'Wiraswasta', child: Text('Wiraswasta')),
                  DropdownMenuItem(value: 'PNS', child: Text('PNS')),
                  DropdownMenuItem(value: 'Tenaga Kesehatan', child: Text('Tenaga Kesehatan')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedPekerjaan = val;
                    _pekerjaanController.text = val ?? '';
                  });
                },
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitting ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC7286),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop(true);
  }
}


