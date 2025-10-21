import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:carousel_slider/carousel_slider.dart';
import '../model/order.dart';
import '../model/paket_jasa.dart';
import '../model/user.dart';
import 'detail_page.dart';
import '../main.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late User _currentUser;
  final List<Order> _orders = [];

  void _addOrder(PaketJasa paket, {int? stars}) {
    setState(() {
      _orders.add(Order(
        orderId: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        paket: paket,
        orderDate: DateTime.now(),
        stars: stars,
      ));
      _selectedIndex = 1;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUser = User(id: 'guest', name: 'Guest', email: 'guest@email.com');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is User) {
      _currentUser = arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      JasaListView(onPesan: _addOrder),
      HistoryPage(orders: _orders),
      ProfilePage(user: _currentUser),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JAXSTORE'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/IJAK LOGO.png', height: 36),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class JasaListView extends StatefulWidget {
  final void Function(PaketJasa, {int? stars}) onPesan;
  JasaListView({super.key, required this.onPesan});

  @override
  State<JasaListView> createState() => _JasaListViewState();
}

class _JasaListViewState extends State<JasaListView> {
  int _currentSlide = 0;

  final List<Map<String, String>> _sliderData = [
    {'title': 'Promo Spesial', 'subtitle': 'Diskon 20% untuk pemesanan pertama', 'image': 'assets/fanny.jpg'},
    {'title': 'Paket Hemat A', 'subtitle': 'Epic -> Legend, cepat & aman', 'image': 'assets/ling.jpg'},
    {'title': 'Paket Hemat B', 'subtitle': 'Legend -> Mythic, harga terjangkau', 'image': 'assets/ruby.jpg'},
    {'title': 'Promo Weekend', 'subtitle': 'Tambahan bonus bintang', 'image': 'assets/nana.jpg'},
    {'title': 'Paket Hemat C', 'subtitle': 'Mythic -> Honor, by pro player', 'image': 'assets/freya.jpg'},
    {'title': 'Flash Sale', 'subtitle': 'Stok terbatas, pesan sekarang', 'image': 'assets/lesley.jpg'},
  ];

  final List<PaketJasa> daftarPaket = [
    PaketJasa(id: 'p1', judul: 'Epic ke Legend', deskripsi: 'Joki dari rank Epic V ke Legend V. Proses cepat dan aman.', harga: 30000, estimasi: '1 Hari', rankAwalUrl: 'assets/epic.png', rankTujuanUrl: 'assets/legend.png'),
    PaketJasa(id: 'p2', judul: 'Legend ke Mythic', deskripsi: 'Joki dari rank Legend V ke Mythic. Dikerjakan oleh pro player.', harga: 70000, estimasi: '1-2 Hari', rankAwalUrl: 'assets/legend.png', rankTujuanUrl: 'assets/mythic.png'),
    PaketJasa(id: 'p3', judul: 'Mythic ke Honor', deskripsi: 'Joki dari Mythic Placement ke Mythical Honor (Bintang 25).', harga: 150000, estimasi: '2-4 Hari', rankAwalUrl: 'assets/mythic.png', rankTujuanUrl: 'assets/honor.png'),
    PaketJasa(id: 'p4', judul: 'Honor ke Glory', deskripsi: 'Joki dari Mythical Honor (Bintang 25) ke Mythical Glory (Bintang 50).', harga: 250000, estimasi: '3-5 Hari', rankAwalUrl: 'assets/honor.png', rankTujuanUrl: 'assets/glory.png'),
    PaketJasa(id: 'p5', judul: 'Glory ke Immortal', deskripsi: 'Joki dari Mythical Glory (Bintang 50) ke Mythical Immortal. Harga per bintang.', harga: 25000, estimasi: 'Request Bintang', rankAwalUrl: 'assets/glory.png', rankTujuanUrl: 'assets/immortal.png'),
  ];

  @override
  Widget build(BuildContext context) {
    // Bangun daftar widget: header slider + kartu paket
    final slider = Column(
      children: [
        CarouselSlider.builder(
          itemCount: _sliderData.length,
          itemBuilder: (context, index, realIdx) {
            final item = _sliderData[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // overlay tipis agar teks terbaca
                  Positioned.fill(child: Container(color: Colors.black26)),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: [
                            Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(0,1))
                          ]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['subtitle'] ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.94,
            onPageChanged: (index, reason) {
              setState(() => _currentSlide = index);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _sliderData.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentSlide == entry.key ? Colors.white : Colors.white54,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
              ),
            );
          }).toList(),
        ),
      ],
    );

    final paketWidgets = daftarPaket.map((paket) {
      return JasaCard(
        paket: paket,
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailPage(paket: paket, onPesan: widget.onPesan),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
      );
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        slider,
        const SizedBox(height: 16),
        ...paketWidgets,
      ],
    );
  }
}

class JasaCard extends StatelessWidget {
  final PaketJasa paket;
  final VoidCallback onTap;
  const JasaCard({super.key, required this.paket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: appbarColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paket.judul,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: navbarColor),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(paket.rankAwalUrl, height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.arrow_forward_rounded, color: Colors.grey[400], size: 30),
                ),
                Image.asset(paket.rankTujuanUrl, height: 60),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatter.format(paket.harga),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: navbarColor, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: appbarColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: navbarColor.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Text(
                        paket.estimasi,
                        style: TextStyle(color: navbarColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<Order> orders;
  const HistoryPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text("Belum ada riwayat pesanan."));
    }
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        String subtitleText = "Tanggal: ${DateFormat('dd MMM yyyy').format(order.orderDate)}";
        if (order.stars != null) {
          subtitleText += "\nTarget: ${order.stars} Bintang";
        }

        return Card(
          child: ListTile(
            leading: Image.asset(order.paket.rankTujuanUrl, width: 40),
            title: Text(order.paket.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitleText),
            trailing: Text(formatter.format(order.paket.harga)),
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _deviceInfo = 'Memuat info perangkat...'; 
  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  // Fungsi async untuk mengambil data perangkat
 Future<void> _loadDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String info;

    try {
      if (kIsWeb) { 
        final WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
        info = 'Browser: ${webBrowserInfo.browserName.toString().split('.').last}\n'
               'User Agent: ${webBrowserInfo.userAgent?.substring(0, 50)}...'; 

      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        info = 'Perangkat: ${androidInfo.manufacturer} ${androidInfo.model}\n'
               'Versi: Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        info = 'Perangkat: ${iosInfo.name} (${iosInfo.model})\n'
               'Versi: ${iosInfo.systemName} ${iosInfo.systemVersion}';
      
      } else {
        info = 'Platform tidak didukung.';
      }

    } catch (e) {
      info = 'Gagal mendapatkan info perangkat.';
    }


    if (mounted) {
      setState(() {
        _deviceInfo = info;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: appbarColor),
            ),
            const SizedBox(height: 24),
            Text(widget.user.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(widget.user.email, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),
            
            const Spacer(),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              _deviceInfo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}