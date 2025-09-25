import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        title: const Text('JAXSTORE by Izha Valensy'),
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

class JasaListView extends StatelessWidget {
  final void Function(PaketJasa, {int? stars}) onPesan;
  JasaListView({super.key, required this.onPesan});

  final List<PaketJasa> daftarPaket = [
    PaketJasa(id: 'p1', judul: 'Epic ke Legend', deskripsi: 'Joki dari rank Epic V ke Legend V. Proses cepat dan aman.', harga: 30000, estimasi: '1 Hari', rankAwalUrl: 'assets/epic.png', rankTujuanUrl: 'assets/legend.png'),
    PaketJasa(id: 'p2', judul: 'Legend ke Mythic', deskripsi: 'Joki dari rank Legend V ke Mythic. Dikerjakan oleh pro player.', harga: 70000, estimasi: '1-2 Hari', rankAwalUrl: 'assets/legend.png', rankTujuanUrl: 'assets/mythic.png'),
    PaketJasa(id: 'p3', judul: 'Mythic ke Honor', deskripsi: 'Joki dari Mythic Placement ke Mythical Honor (Bintang 25).', harga: 150000, estimasi: '2-4 Hari', rankAwalUrl: 'assets/mythic.png', rankTujuanUrl: 'assets/honor.png'),
    PaketJasa(id: 'p4', judul: 'Honor ke Glory', deskripsi: 'Joki dari Mythical Honor (Bintang 25) ke Mythical Glory (Bintang 50).', harga: 250000, estimasi: '3-5 Hari', rankAwalUrl: 'assets/honor.png', rankTujuanUrl: 'assets/glory.png'),
    PaketJasa(id: 'p5', judul: 'Glory ke Immortal', deskripsi: 'Joki dari Mythical Glory (Bintang 50) ke Mythical Immortal. Harga per bintang.', harga: 25000, estimasi: 'Request Bintang', rankAwalUrl: 'assets/glory.png', rankTujuanUrl: 'assets/immortal.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: daftarPaket.length,
      itemBuilder: (context, index) {
        final paket = daftarPaket[index];
        return JasaCard(
          paket: paket,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DetailPage(paket: paket, onPesan: onPesan),
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
      },
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

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, size: 60, color: appbarColor)),
          const SizedBox(height: 24),
          Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}