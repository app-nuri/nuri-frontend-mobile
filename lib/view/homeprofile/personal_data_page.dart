import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalDataPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const PersonalDataPage({Key? key, this.userData}) : super(key: key);

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tglLahirController;
  late final TextEditingController _usiaController;
  late final TextEditingController _alamatController;
  late final TextEditingController _teleponController;
  late final TextEditingController _pendidikanController;
  late final TextEditingController _golonganDarahController;
  late final TextEditingController _pekerjaanController;
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  bool _submitting = false;
  String? _selectedPendidikan;
  String? _selectedGolongan;
  String? _selectedPekerjaan;

  @override
  void initState() {
    super.initState();
    final d = widget.userData ?? {};
    _namaController = TextEditingController(text: d['name']?.toString() ?? '');
    _emailController = TextEditingController(text: d['email']?.toString() ?? '');
    _tglLahirController = TextEditingController(text: d['tanggal_lahir']?.toString() ?? '');
    _usiaController = TextEditingController(text: d['usia']?.toString() ?? '');
    _alamatController = TextEditingController(text: d['alamat']?.toString() ?? '');
    _teleponController = TextEditingController(text: d['nomor_telepon']?.toString() ?? '');
    _pendidikanController = TextEditingController(text: d['pendidikan_terakhir']?.toString() ?? '');
    _golonganDarahController = TextEditingController(text: d['golongan_darah']?.toString() ?? '');
    _pekerjaanController = TextEditingController(text: d['pekerjaan']?.toString() ?? '');

    _selectedPendidikan = _pendidikanController.text.isEmpty ? null : _pendidikanController.text;
    _selectedGolongan = _golonganDarahController.text.isEmpty ? null : _golonganDarahController.text;
    _selectedPekerjaan = _pekerjaanController.text.isEmpty ? null : _pekerjaanController.text;

    // Hitung usia dari tanggal lahir jika memungkinkan
    final parsedDob = _parseDate(_tglLahirController.text);
    if (parsedDob != null) {
      _usiaController.text = _calculateAge(parsedDob).toString();
    }
  }

  @override
  void dispose() {
    _tglLahirController.dispose();
    _usiaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _pendidikanController.dispose();
    _golonganDarahController.dispose();
    _pekerjaanController.dispose();
    _namaController.dispose();
    _emailController.dispose();
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

  DateTime? _parseDate(String raw) {
    if (raw.isEmpty) return null;
    // Coba parse ISO lebih dulu
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;
    // Coba format lokal yang kita gunakan saat set (d MMMM yyyy)
    try {
      return DateFormat('d MMMM yyyy', 'id_ID').parseLoose(raw);
    } catch (_) {
      return null;
    }
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    final hadBirthdayThisYear = (now.month > dob.month) || (now.month == dob.month && now.day >= dob.day);
    if (!hadBirthdayThisYear) age -= 1;
    return age < 0 ? 0 : age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pribadi'),
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
                readOnly: true,
                decoration: _decor('Nama'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: _decor('Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tglLahirController,
                readOnly: true,
                decoration: _decor('Tanggal Lahir').copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                onTap: () async {
                  final now = DateTime.now();
                  DateTime firstDate = DateTime(now.year - 80);
                  DateTime lastDate = DateTime(now.year + 1);
                  DateTime? initialDate;
                  try {
                    initialDate = DateTime.tryParse(_tglLahirController.text);
                  } catch (_) {}
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate ?? DateTime(now.year - 25, now.month, now.day),
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );
                  if (picked != null) {
                    _tglLahirController.text = DateFormat('dd/MM/yyyy').format(picked);
                    _usiaController.text = _calculateAge(picked).toString();
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usiaController,
                readOnly: true,
                decoration: _decor('Usia'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: _decor('Alamat'),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
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
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPendidikan,
                decoration: _decor('Pendidikan Terakhir'),
                items: const [
                  DropdownMenuItem(value: 'SD', child: Text('SD')),
                  DropdownMenuItem(value: 'SMP', child: Text('SMP')),
                  DropdownMenuItem(value: 'SMA/SMK', child: Text('SMA/SMK')),
                  DropdownMenuItem(value: 'D1', child: Text('D1')),
                  DropdownMenuItem(value: 'D2', child: Text('D2')),
                  DropdownMenuItem(value: 'D3', child: Text('D3')),
                  DropdownMenuItem(value: 'S1', child: Text('S1')),
                  DropdownMenuItem(value: 'S2', child: Text('S2')),
                  DropdownMenuItem(value: 'S3', child: Text('S3')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedPendidikan = val;
                    _pendidikanController.text = val ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGolongan,
                decoration: _decor('Golongan Darah'),
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('A')),
                  DropdownMenuItem(value: 'B', child: Text('B')),
                  DropdownMenuItem(value: 'AB', child: Text('AB')),
                  DropdownMenuItem(value: 'O', child: Text('O')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedGolongan = val;
                    _golonganDarahController.text = val ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPekerjaan,
                decoration: _decor('Pekerjaan'),
                items: const [
                  DropdownMenuItem(value: 'Ibu Rumah Tangga', child: Text('Ibu Rumah Tangga')),
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
              ),
              const SizedBox(height: 24),
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    // TODO: panggil service API update profil di sini
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    // Kembalikan status berhasil dan payload minimal agar profil bisa refresh
    Navigator.of(context).pop(true);
  }
}


