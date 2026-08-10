import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const TelegramFullApp());
}

class TelegramFullApp extends StatelessWidget {
  const TelegramFullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF17212B),
        primaryColor: const Color(0xFF5288C1),
        cardColor: const Color(0xFF1E2C3A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF242F3D),
          elevation: 0,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

// ================= AUTH / LOGIN =================

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;

  final TextEditingController phoneOrEmailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  static final Map<String, String> registeredUsers = {
    "+998975182526": "12345",
    "dilshod": "12345",
  };

  void _handleAuth() {
    String input = phoneOrEmailCtrl.text.trim();
    String pass = passwordCtrl.text.trim();

    if (input.isEmpty || pass.isEmpty) {
      _showError("Iltimos, telefon raqam/email va parolni kiriting!");
      return;
    }

    if (isLoginMode) {
      if (registeredUsers.containsKey(input) &&
          registeredUsers[input] == pass) {
        _navigateToMainApp(input);
      } else {
        _showError("Telefon raqam (email) yoki parol xato!");
      }
    } else {
      registeredUsers[input] = pass;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akkount muvaffaqiyatli yaratildi!"),
        ),
      );

      _navigateToMainApp(input);
    }
  }

  void _navigateToMainApp(String user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => MainNavigationScreen(userAccount: user),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  void dispose() {
    phoneOrEmailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17212B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF5288C1),
                child: Icon(
                  Icons.send,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isLoginMode
                    ? "Telegram'ga Kirish"
                    : "Ro'yxatdan O'tish",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "SMS tasdiqlash talab qilinmaydi. Parolingizni kiriting.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: phoneOrEmailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: Colors.grey,
                  ),
                  hintText: "Telefon raqam yoki Email",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  hintText: "Parolingizni kiriting",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E2C3A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5288C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleAuth,
                  child: Text(
                    isLoginMode
                        ? "KIRISH"
                        : "RO'YXATDAN O'TISH",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginMode = !isLoginMode;
                  });
                },
                child: Text(
                  isLoginMode
                      ? "Akkountingiz yo'qmi? Ro'yxatdan o'ting"
                      : "Akkountingiz bormi? Kirish",
                  style: const TextStyle(
                    color: Color(0xFF64B5F6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MAIN NAVIGATION =================

class MainNavigationScreen extends StatefulWidget {
  final String userAccount;

  const MainNavigationScreen({
    super.key,
    required this.userAccount,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  String userName = "_ORG_DilshoD_";
  String userBio = "Salom hammaga";
  String userHandle = "@Dilshod_ORG_015";

  int userStars = 250;
  double userTon = 3.5;
  bool isPremium = true;

  double premiumPriceUsd = 4.99;
  double stars100PriceUsd = 1.99;

  List<Map<String, dynamic>> availableGifts = [
    {
      "name": "🧸 Teddy Bear",
      "price": 50,
    },
    {
      "name": "🏆 Golden Trophy",
      "price": 150,
    },
    {
      "name": "👑 Imperial Crown",
      "price": 500,
    },
  ];

  int spinCost = 10;
  int rocketCost = 25;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ChatListTab(),
      const ContactsTab(),
      SettingsTab(
        stars: userStars,
        ton: userTon,
        premiumPrice: premiumPriceUsd,
        starsPrice: stars100PriceUsd,
        openAdminPanel: _openAdminPanel,
      ),
      ProfileTab(
        name: userName,
        phone: widget.userAccount,
        bio: userBio,
        handle: userHandle,
        stars: userStars,
        ton: userTon,
        openAdminPanel: _openAdminPanel,
        openOmadGame: _openOmadGame,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E2C3A),
        selectedItemColor: const Color(0xFF64B5F6),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chatlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Kontaktlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Sozlamalar",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.redAccent,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  void _openAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminControlScreen(
          stars: userStars,
          ton: userTon,
          premiumPrice: premiumPriceUsd,
          starsPrice: stars100PriceUsd,
          spinCost: spinCost,
          rocketCost: rocketCost,
          gifts: availableGifts,
          onSavePrices: (
            pPrice,
            sPrice,
            sCost,
            rCost,
          ) {
            setState(() {
              premiumPriceUsd = pPrice;
              stars100PriceUsd = sPrice;
              spinCost = sCost;
              rocketCost = rCost;
            });
          },
          onUpdateBalance: (newStars, newTon) {
            setState(() {
              userStars = newStars;
              userTon = newTon;
            });
          },
        ),
      ),
    );
  }

  void _openOmadGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => OmadTabScreen(
          stars: userStars,
          spinCost: spinCost,
          rocketCost: rocketCost,
          gifts: availableGifts,
          onSpin: (cost) {
            if (userStars >= cost) {
              setState(() {
                userStars -= cost;

                if (Random().nextBool()) {
                  userStars += cost * 2;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "O'yin o'ynaldi! Balansingiz yangilandi.",
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Stars balansi yetarli emas!",
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// ================= CHATLAR =================

class ChatListTab extends StatelessWidget {
  const ChatListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Telegram",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildChatItem(
            Icons.archive,
            "Arxivlangan chatlar",
            "FREE FIRE UZBEKISTAN...",
            "19",
            color: Colors.blueGrey,
          ),
          _buildChatItem(
            Icons.pets,
            "Dadya's Gift",
            "Что вам раздать? 🤔",
            "2",
            time: "02:55",
            color: Colors.orange,
          ),
          _buildChatItem(
            Icons.group,
            "UZBEKISTAN FREE FIRE CHAT",
            "Qanday zormi ishlar bolyaptimi",
            "",
            time: "00:06",
            color: Colors.purple,
          ),
          _buildChatItem(
            Icons.bookmark,
            "Saqlangan xabarlar",
            "🦈",
            "",
            time: "21:21",
            color: Colors.blue,
          ),
          _buildChatItem(
            Icons.verified,
            "Telegram Notifications",
            "Login kodi: ****",
            "",
            time: "Dush",
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    IconData icon,
    String title,
    String subtitle,
    String badge, {
    String time = "",
    Color color = Colors.blue,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ================= KONTAKTLAR =================

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kontaktlar"),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_add),
            ),
            title: Text("Tanishlarni taklif qilish"),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.call),
            ),
            title: Text("Oxirgi chaqiruvlar"),
          ),
        ],
      ),
    );
  }
}

// ================= SOZLAMALAR =================

class SettingsTab extends StatelessWidget {
  final int stars;
  final double ton;
  final double premiumPrice;
  final double starsPrice;
  final VoidCallback openAdminPanel;

  const SettingsTab({
    super.key,
    required this.stars,
    required this.ton,
    required this.premiumPrice,
    required this.starsPrice,
    required this.openAdminPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sozlamalar"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.star,
              color: Colors.purple,
            ),
            title: const Text("Telegram Premium"),
            trailing: Text(
              "\$$premiumPrice / oy",
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.star_border,
              color: Colors.amber,
            ),
            title: const Text("Telegram Yulduzlar (Stars)"),
            trailing: Text(
              "$stars ⭐️ (\$$starsPrice)",
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.diamond_outlined,
              color: Colors.blue,
            ),
            title: const Text("TONlarim"),
            trailing: Text(
              "$ton 💎",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
              ),
              icon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
              label: const Text(
                "BOSH ADMIN PANELGA KIRISH",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: openAdminPanel,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PROFIL =================

class ProfileTab extends StatelessWidget {
  final String name;
  final String phone;
  final String bio;
  final String handle;
  final int stars;
  final double ton;
  final VoidCallback openAdminPanel;
  final VoidCallback openOmadGame;

  const ProfileTab({
    super.key,
    required this.name,
    required this.phone,
    required this.bio,
    required this.handle,
    required this.stars,
    required this.ton,
    required this.openAdminPanel,
    required this.openOmadGame,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF242F3D),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(bio),
            subtitle: const Text("Tarjimayi hol"),
          ),
          ListTile(
            title: Text(handle),
            subtitle: const Text("Foydalanuvchi nomi"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.casino,
              color: Colors.amber,
            ),
            title: const Text(
              "🎰 Omad Bo'limi (Spin / Rocket)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Balansingiz: $stars ⭐️",
            ),
            onTap: openOmadGame,
          ),
        ],
      ),
    );
  }
}

// ================= OMAD =================

class OmadTabScreen extends StatelessWidget {
  final int stars;
  final int spinCost;
  final int rocketCost;
  final List<Map<String, dynamic>> gifts;
  final Function(int) onSpin;

  const OmadTabScreen({
    sup
