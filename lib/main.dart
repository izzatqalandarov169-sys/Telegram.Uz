import 'dart00:async';
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
      title: 'Telegram 1ga1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        cardColor: const Color(0xFF1E293B),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Foydalanuvchi ma'lumotlari
  final String myUserId = "ADMIN_777";
  final String adminUserId = "ADMIN_777";

  int userStars = 100;
  double userTon = 0.5;
  bool isPremium = true;
  bool isMuted = false;
  bool isSpammed = false;

  List<String> myGifts = ["🧸 Teddy Bear", "🏆 Golden Trophy", "🚀 Rocket Gift"];
  
  // Referal tizimi
  int invitedFriends = 12;
  int timerSeconds = 604800; // 1 hafta
  Timer? _weeklyTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _weeklyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      } else {
        _giveWeeklyRewards();
        setState(() => timerSeconds = 604800);
      }
    });
  }

  void _giveWeeklyRewards() {
    setState(() {
      userStars += 100;
      myGifts.add("🎁 100 Stars Special Gift");
      isPremium = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎉 Haftalik referal tanlovi tugadi! G'olibga 100 Stars + 100 Stars Gift + 3 oylik Premium o'tkazildi!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _weeklyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ChatListTab(),
      OmadTab(
        stars: userStars,
        ton: userTon,
        gifts: myGifts,
        invitedCount: invitedFriends,
        secondsLeft: timerSeconds,
        onSpin: (cost, win) {
          if (userStars >= cost) {
            setState(() {
              userStars -= cost;
              if (win) userStars += (cost * 2);
            });
          }
        },
        onTransfer: (giftName) {
          setState(() {
            myGifts.remove(giftName);
          });
        },
      ),
      ProfileTab(
        userId: myUserId,
        adminId: adminUserId,
        stars: userStars,
        isPremium: isPremium,
        isMuted: isMuted,
        isSpammed: isSpammed,
        onUpdateAdmin: (newStars, muted, spammed, prem) {
          setState(() {
            userStars = newStars;
            isMuted = muted;
            isSpammed = spammed;
            isPremium = prem;
          });
        },
        onAddGift: (newGift) {
          setState(() => myGifts.add(newGift));
        },
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFFF59E0B),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Suhbatlar"),
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: "Omad"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

// ================= 1. TELEGRAM 1GA1 CHAT TAB =================
class ChatListTab extends StatelessWidget {
  const ChatListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telegram 1-ga-1", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text("U${i + 1}"),
            ),
            title: Text("Foydalanuvchi ${i + 1} ⭐"),
            subtitle: const Text("Salom! Omad bo'limida o'ynaymizmi? 😎🔥"),
            trailing: const Text("14:35", style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => ChatDetailScreen(userName: "Foydalanuvchi ${i + 1}")),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  const ChatDetailScreen({super.key, required this.userName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<String> msgs = ["Salom!", "Telegram 1ga1 APK tayyor! 🔥👑"];
  final TextEditingController inputCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(radius: 18, child: Text(widget.userName[0])),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (context, idx) => Align(
                alignment: idx % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: idx % 2 == 0 ? const Color(0xFF1E293B) : const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msgs[idx], style: const TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: inputCtrl,
                    decoration: const InputDecoration(
                      hintText: "Xabar yozing... 🎉🎁",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF38BDF8)),
                  onPressed: () {
                    if (inputCtrl.text.isNotEmpty) {
                      setState(() => msgs.add(inputCtrl.text));
                      inputCtrl.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================= 2. OMAD (GIFT SPINNER & TANLOV) TAB =================
class OmadTab extends StatelessWidget {
  final int stars;
  final double ton;
  final List<String> gifts;
  final int invitedCount;
  final int secondsLeft;
  final Function(int cost, bool win) onSpin;
  final Function(String giftName) onTransfer;

  const OmadTab({
    super.key,
    required this.stars,
    required this.ton,
    required this.gifts,
    required this.invitedCount,
    required this.secondsLeft,
    required this.onSpin,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎰 Omad Bo'limi (Gift Spinner)"),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
            child: Text("⭐️ $stars Stars | 💎 $ton TON", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text("🚀 Rocket & Slots (Gifts Spinner)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                    const SizedBox(height: 10),
                    const Text("Stavka tikib Stars va noyob Giftlarni yutib oling!", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
                          onPressed: () {
                            bool win = Random().nextBool();
                            onSpin(10, win);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(win ? "🎉 Omadingiz keldi! +20 Stars yutdingiz!" : "❌ Yutqazdingiz (10 Stars ketdi)")),
                            );
                          },
                          child: const Text("SPIN (10 ⭐️)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                          onPressed: () {
                            bool win = Random().nextDouble() > 0.3;
                            onSpin(20, win);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(win ? "🚀 Rocket Uchdi! +40 Stars yutdingiz!" : "💥 Rocket portladi!")),
                            );
                          },
                          child: const Text("ROCKET (20 ⭐️)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text("🏆 Haftalik Avto-Referal Tanlovi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                    const SizedBox(height: 8),
                    Text("Siz taklif qilgan do'stlar: $invitedCount ta"),
                    Text("Tanlov tugashiga: ${secondsLeft ~/ 3600} soat ${ (secondsLeft % 3600) ~/ 60 } daqiqa qoldi"),
                    const SizedBox(height: 10),
                    const Text("🎁 G'olibga: 100 Stars + 100 Stars'lik Gift + 3 Oylik Premium!", textAlign: TextAlign.center, style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text("🎁 Mening Giftlarim (Transfer)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    gifts.isEmpty
                        ? const Text("Sizda sovga yo'q", style: TextStyle(color: Colors.grey))
                        : Column(
                            children: gifts.map((g) {
                              return ListTile(
                                leading: const Icon(Icons.card_giftcard, color: Colors.amber),
                                title: Text(g),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                                  onPressed: () {
                                    onTransfer(g);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("$g boshqa foydalanuvchiga muvaffaqiyatli o'tkazildi!")),
                                    );
                                  },
                                  child: const Text("Transfer"),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ================= 3. PROFIL VA ADMIN PANEL TAB =================
class ProfileTab extends StatelessWidget {
  final String userId;
  final String adminId;
  final int stars;
  final bool isPremium;
  final bool isMuted;
  final bool isSpammed;
  final Function(int, bool, bool, bool) onUpdateAdmin;
  final Function(String) onAddGift;

  const ProfileTab({
    super.key,
    required this.userId,
    required this.adminId,
    required this.stars,
    required this.isPremium,
    required this.isMuted,
    required this.isSpammed,
    required this.onUpdateAdmin,
    required this.onAddGift,
  });

  @override
  Widget build(BuildContext context) {
    bool isAdmin = (userId == adminId);

    return Scaffold(
      appBar: AppBar(title: const Text("Profil"), backgroundColor: const Color(0xFF1E293B)),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ListTile(
            leading: const CircleAvatar(radius: 28, child: Icon(Icons.person, size: 30)),
            title: Text("ID: $userId", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(isPremium ? "⭐ Telegram Premium" : "O'zbekiston | Oddiy profil"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text("Stars Balansi: $stars ⭐️"),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.green),
            title: const Text("Karta qo'shish (Stars/Gift/Premium Xaridi)"),
            onTap: () => _openCardDialog(context),
          ),
          const SizedBox(height: 30),

          if (isAdmin)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.all(15),
              ),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("🛠 ADMIN PANEL (Faqat Men Uchun)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AdminControlScreen(
                      stars: stars,
                      isMuted: isMuted,
                      isSpammed: isSpammed,
                      isPremium: isPremium,
                      onSave: onUpdateAdmin,
                      onAddGift: onAddGift,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _openCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("💳 Karta Rekvizitlarini Qo'shish"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(hintText: "8600 **** **** ****")),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(hintText: "Muddati (MM/YY)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Bekor qilish")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Karta muvaffaqiyatli saqlandi!")),
              );
            },
            child: const Text("Saqlash"),
          )
        ],
      ),
    );
  }
}

// ================= 4. ADMIN CONTROL PANEL =================
class AdminControlScreen extends StatefulWidget {
  final int stars;
  final bool isMuted;
  final bool isSpammed;
  final bool isPremium;
  final Function(int, bool, bool, bool) onSave;
  final Function(String) onAddGift;

  const AdminControlScreen({
    super.key,
    required this.stars,
    required this.isMuted,
    required this.isSpammed,
    required this.isPremium,
    required this.onSave,
    required this.onAddGift,
  });

  @override
  State<AdminControlScreen> createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  late int currentStars;
  late bool muted;
  late bool spammed;
  late bool premium;

  @override
  void initState() {
    super.initState();
    currentStars = widget.stars;
    muted = widget.isMuted;
    spammed = widget.isSpammed;
    premium = widget.isPremium;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🛠 Bosh Admin Paneli"), backgroundColor: Colors.redDark),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ListTile(
            title: const Text("➕ Promo Code Yaratish"),
            trailing: const Icon(Icons.add_card),
            onTap: () => _notify(context, "Yangi Promokod yaratildi!"),
          ),
          ListTile(
            title: const Text("💳 Karta qo'shish / Rekvizitlarni yangilash"),
            trailing: const Icon(Icons.payment),
            onTap: () => _notify(context, "Karta rekvizitlari saqlandi!"),
          ),
          ListTile(
            title: const Text("🏷 Narxlarni Yangilash"),
            trailing: const Icon(Icons.price_change),
            onTap: () => _notify(context, "Barcha xizmat va Gift narxlari yangilandi!"),
          ),
          ListTile(
            title: const Text("⭐️ Stars Balansini Qo'shish (+100 Stars)"),
            trailing: const Icon(Icons.star),
            onTap: () {
              setState(() => currentStars += 100);
              widget.onSave(currentStars, muted, spammed, premium);
              _notify(context, "Balansga +100 Stars qo'shildi!");
            },
          ),
          ListTile(
            title: const Text("🎁 Gift Yuborish"),
            trailing: const Icon(Icons.card_giftcard),
            onTap: () {
              widget.onAddGift("💎 Crown Special Gift");
              _notify(context, "Foydalanuvchiga yangi Gift yuborildi!");
            },
          ),
          ListTile(
            title: Text(premium ? "⭐ Premium'ni Olib Tashlash" : "⭐ Hisobga Telegram Premium Qo'shish"),
            trailing: const Icon(Icons.workspace_premium),
            onTap: () {
              setState(() => premium = !premium);
              widget.onSave(currentStars, muted, spammed, premium);
              _notify(context, "Premium holati o'zgartirildi!");
            },
          ),
          SwitchListTile(
            title: const Text("🔇 Mute / Unmute Qilish"),
            value: muted,
            onChanged: (val) {
              setState(() => muted = val);
              widget.onSave(currentStars, muted, spammed, premium);
            },
          ),
          SwitchListTile(
            title: const Text("🚫 Spam / Unspam Qilish"),
            value: spammed,
            onChanged: (val) {
              setState(() => spammed = val);
              widget.onSave(currentStars, muted, spammed, premium);
            },
          ),
        ],
      ),
    );
  }

  void _notify(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }
}
