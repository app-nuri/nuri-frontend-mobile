import 'package:flutter/material.dart';
import 'package:Sehati/services/api/api_service_shop.dart';
import 'package:Sehati/view/homeprofile/home.dart';
import 'package:Sehati/view/komunitas/index_komunitas.dart';
import 'package:Sehati/models/product_model.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:Sehati/view/homeprofile/profile.dart';
import 'package:google_fonts/google_fonts.dart'; 

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Future<List<ProductModel>> _products = Future.value([]);
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool isLoading = false;
  int _currentIndex = 2; 
  final TextEditingController _searchController = TextEditingController();
 
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    
    setState(() => isLoading = true);
    
    try {
      final products = await ApiServiceShop.fetchProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
          _products = Future.value(products);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar('Error: ${e.toString()}');
        _products = Future.value([]);
      }
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.produk.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _products = Future.value(_filteredProducts);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper function to safely show SnackBar
  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    if (!mounted) return;
    
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Helper function to format price
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]}.'
    )}';
  }

  // Function to launch URL
  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      _showSnackBar('Link produk tidak tersedia', backgroundColor: Colors.orange);
      return;
    }

    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Membuka di browser eksternal
        );
      } else {
        _showSnackBar('Tidak dapat membuka link: $url');
      }
    } catch (e) {
      _showSnackBar('Error membuka link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
           
              // App Bar without Back Button
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Belanja',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFB7D92),
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hari ini mau beli apa moms?',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFB7D92),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Main Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Header with Search
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Bar - Functional
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _filterProducts,
                                decoration: InputDecoration(
                                  hintText: "Search products...",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFFBDBDBD),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xFFBDBDBD),
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Category Tabs
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            _buildCategoryChip("All", true),
                            const SizedBox(width: 8),
                            _buildCategoryChip("Vitamin", false),
                            const SizedBox(width: 8),
                            _buildCategoryChip("Makanan", false),
                            const SizedBox(width: 8),
                            _buildCategoryChip("Peralatan Bayi", false),
                          ],
                        ),
                      ),
                      
                      // Products Grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _loadProducts();
                            },
                            color: const Color(0xFFFB7D92),
                            child: FutureBuilder<List<ProductModel>>(
                              future: _products,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(color: Color(0xFFFB7D92)),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error, color: Color(0xFFFB7D92), size: 64),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Error: ${snapshot.error}",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF1E293B),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: _loadProducts,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFB7D92),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('Refresh'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_bag, color: Color(0xFFFB7D92), size: 64),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Belum ada produk",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF1E293B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                
                                final products = snapshot.data!;
                                return GridView.builder(
                                  padding: const EdgeInsets.only(top: 16, bottom: 20),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.65, // Lebih panjang (dari 0.75 ke 0.65)
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return _buildProductCard(products[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(),
        ),
      );
    }

    Widget _buildCategoryChip(String label, bool isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFB7D92) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFB7D92) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : const Color(0xFF757575),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      );
    }

    Widget _buildBottomNavigation() {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityPage()),
              );
            }   else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDataViewPage()),
              );
            }
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFB7D92),
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
        items: [
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
            label: 'Belanja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun Saya',
          ),
        ],
      );
    }

    Widget _buildProductCard(ProductModel product) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Container
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: _buildProductImage(product.gambar),
                ),
              ),
            ),
            
            // Content Padding
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.produk,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Button "Lihat" - Align Left
                  ElevatedButton(
                    onPressed: () {
                      _showProductDetail(product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB7D92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 0,
                      minimumSize: const Size(0, 28),
                    ),
                    child: Text(
                      'Lihat',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildProductImage(String? imageUrl) {
      if (imageUrl == null || imageUrl.isEmpty) {
        return Container(
          color: const Color(0xFFF4F4F4),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              color: Color(0xFF64748B),
              size: 40,
            ),
          ),
        );
      }

      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFFF4F4F4),
            child: Center(
              child: CircularProgressIndicator(
                color: const Color(0xFFFB7D92),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / 
                      loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFF4F4F4),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: Color(0xFF64748B),
                size: 40,
              ),
            ),
          );
        },
      );
    }

    void _showProductDetail(ProductModel product) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: _buildProductImage(product.gambar),
                    ),
                  ),
                  
                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.produk,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          _formatPrice(product.harga),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFB7D92),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Deskripsi:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          product.deskripsi,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Color(0xFF64748B),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Action Buttons - Button utama untuk buka link
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _launchURL(product.link); // Mengarahkan ke link produk
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFB7D92),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.open_in_new,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Beli Sekarang',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Color(0xFFFB7D92)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'Tutup',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFB7D92),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
}