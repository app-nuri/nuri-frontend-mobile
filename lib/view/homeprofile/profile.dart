import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Sehati/view/homeprofile/updatedata.dart';
import 'package:Sehati/view/homeprofile/updateicon.dart';
import 'package:Sehati/view/homeprofile/home.dart';
import 'package:Sehati/view/komunitas/index_komunitas.dart';
import 'package:Sehati/view/shop/shop_index.dart'; 
import 'package:provider/provider.dart';
import 'package:Sehati/providers/auth_provider.dart';
import 'package:Sehati/view/registerlogin/login_screen.dart';
import 'package:Sehati/view/homeprofile/personal_data_page.dart';
import 'package:Sehati/view/homeprofile/husband_data_page.dart';
import 'package:Sehati/view/homeprofile/reset_password_page.dart';

// Clipper gelombang bawah header (top-level)
class _BottomWaveClipper extends CustomClipper<Path> {
  // Wave based on 393x213 reference, scaled to actual size
  @override
  Path getClip(Size size) {
    const double baseW = 393.0;
    const double baseH = 213.0;
    final double sx = size.width / baseW;
    final double sy = size.height / baseH;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, 160 * sy);
    path.cubicTo(98 * sx, 175 * sy, 196 * sx, 205 * sy, 196.5 * sx, 205 * sy);
    path.cubicTo(297 * sx, 205 * sy, 345 * sx, 175 * sy, size.width, 160 * sy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class UserDataViewPage extends StatefulWidget {
  @override
  _UserDataViewPageState createState() => _UserDataViewPageState();
}

class _UserDataViewPageState extends State<UserDataViewPage> {
  final _secureStorage = FlutterSecureStorage();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  int _currentIndex = 3; // Indeks untuk halaman Profil

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to get JWT token from secure storage
  Future<String?> getJwtToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  // Fetch user data from API
  Future<void> _fetchUserData() async {
     try {
      final token = await getJwtToken();
      
      if (token == null) {
        if(mounted){
          setState(() {
            _errorMessage = 'Anda belum login. Silakan login terlebih dahulu.';
            _isLoading = false;
          });
        }
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user-data'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      
      if(!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _userData = responseData['data'] ?? responseData;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Data tidak ditemukan. Silakan lengkapi data Anda terlebih dahulu.';
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data (${response.statusCode}). Silakan coba lagi.';
        });
      }
    } catch (e) {
      if(mounted){
        setState(() {
          _isLoading = false;
          _errorMessage = 'Terjadi kesalahan: $e';
        });
      }
    }
  }

  // Refresh data
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _userData = null;
    });
    await _fetchUserData();
  }

  // Helper method to display data field
  Widget _buildDataField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Tidak tersedia',
              style: TextStyle(
                color: value != null ? Color(0xFF1E293B) : Color(0xFF4C617F),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  // Widget untuk menampilkan gambar profil user
  Widget _buildUserProfileImage() {
    final imageUrl = _userData?['selected_icon_data_cache'];
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Color(0x29000000),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, width: 120, height: 120, fit: BoxFit.cover)
                : Image.asset('assets/images/default_user.png', width: 120, height: 120, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectProfilePage()),
              ).then((_) => _refreshData());
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(color: Color(0x29000000), blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.edit, size: 16, color: Color(0xFF1E293B)),
            ),
          ),
        ),
      ],
    );
  }

  // Header bergelombang
  Widget _buildWaveHeader() {
    return SizedBox(
      width: double.infinity,
      height: 213,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _BottomWaveClipper(),
              child: Container(color: Color(0xFFFC7286)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text(
                'Data Pengguna',
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Positioned(bottom: 6, left: 0, right: 0, child: Center(child: _buildUserProfileImage())),
        ],
      ),
    );
  }

  // Clipper dideklarasikan di top-level (lihat atas file)

  // Method untuk membangun Bottom Navigation Bar
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (!mounted) return;
        if (_currentIndex == index && index == 3) return;

        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CommunityPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ShopPage()),
            );
            break;
          case 3:
            if (ModalRoute.of(context)?.settings.name != '/user_data_view') {
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserDataViewPage(), settings: RouteSettings(name: '/user_data_view')),
                );
            }
            break;
        }
      },
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFC7286),
      unselectedItemColor: const Color(0xFF4C617F),
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Komunitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.pink[100]),
                  SizedBox(height: 16),
                  Text(
                    'Memuat data...',
                    style: TextStyle(
                      color: Colors.pink[50],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCEFEE),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Color(0xFFFC5C9C),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: Text(
                            'Coba Lagi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4DBAFF),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  color: Color(0xFF4DBAFF),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildWaveHeader(),
                        // Konten utama tanpa kartu (lebih mirip referensi)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_userData != null) ...[
                                Center(
                                  child: Text(
                                    (_userData?['name'] ?? '-') as String,
                                    style: TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    '${_userData?['email'] ?? '-'} | ${_userData?['nomor_telepon'] ?? '-'}',
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              SizedBox(height: 12),
                              Divider(color: Color(0xFFF1F5F9)),
                              SizedBox(height: 12),
                              Text('Data', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600)),
                              _MenuItem(
                                icon: Icons.person_outline,
                                title: 'Data Pribadi',
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => PersonalDataPage(userData: _userData)),
                                  );
                                  if (result == true && mounted) {
                                    await _refreshData();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Data pribadi berhasil diperbarui')),
                                    );
                                  }
                                },
                              ),
                              _MenuItem(
                                icon: Icons.person_add_alt_1_outlined,
                                title: 'Data Suami',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => HusbandDataPage(userData: _userData)));
                                },
                              ),
                              _MenuItem(
                                icon: Icons.key_outlined,
                                title: 'Reset Password',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
                                },
                              ),
                              Divider(color: Color(0xFFF1F5F9)),
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, _) {
                                  return InkWell(
                                    onTap: () async {
                                      final success = await authProvider.logout();
                                      if (success && mounted) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout, color: Color(0xFFB91C1C)),
                                          SizedBox(width: 12),
                                          Text('Log Out', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 16, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
      // Tidak ada FAB pada desain baru; edit per section di halaman tujuan
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}

// Item menu standar seperti referensi
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuItem({Key? key, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFF0F172A), size: 26),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
        Divider(color: Color(0xFFF1F5F9)),
      ],
    );
  }
}