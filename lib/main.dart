// ================= OMAD GAME SCREEN =================

class OmadTabScreen extends StatelessWidget {
  final int stars;
  final int spinCost;
  final int rocketCost;
  final List<Map<String, dynamic>> gifts;
  final Function(int) onSpin;

  const OmadTabScreen({
    super.key,
    required this.stars,
    required this.spinCost,
    required this.rocketCost,
    required this.gifts,
    required this.onSpin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎰 Omad Bo'limi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF1E2C3A),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Mavjud Balans: $stars ⭐️",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => onSpin(spinCost),
                        child: Text(
                          "SPIN ($spinCost ⭐️)",
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                        ),
                        onPressed: () => onSpin(rocketCost),
                        child: Text(
                          "ROCKET ($rocketCost ⭐️)",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "🎁 Sovg'alar va Narxlari",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...gifts.map(
            (g) => Card(
              color: const Color(0xFF1E2C3A),
              child: ListTile(
                leading: const Icon(
                  Icons.card_giftcard,
                  color: Colors.amber,
                ),
                title: Text(g["name"].toString()),
                trailing: Text(
                  "${g["price"]} ⭐️",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= ADMIN PANEL =================

class AdminControlScreen extends StatefulWidget {
  final int stars;
  final double ton;
  final double premiumPrice;
  final double starsPrice;
  final int spinCost;
  final int rocketCost;
  final List<Map<String, dynamic>> gifts;

  final Function(double, double, int, int) onSavePrices;
  final Function(int, double) onUpdateBalance;

  const AdminControlScreen({
    super.key,
    required this.stars,
    required this.ton,
    required this.premiumPrice,
    required this.starsPrice,
    required this.spinCost,
    required this.rocketCost,
    required this.gifts,
    required this.onSavePrices,
    required this.onUpdateBalance,
  });

  @override
  State<AdminControlScreen> createState() =>
      _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  late double pPrice;
  late double sPrice;
  late int sCost;
  late int rCost;
  late int currentStars;
  late double currentTon;

  final TextEditingController giftNameCtrl =
      TextEditingController();

  final TextEditingController giftPriceCtrl =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    pPrice = widget.premiumPrice;
    sPrice = widget.starsPrice;
    sCost = widget.spinCost;
    rCost = widget.rocketCost;
    currentStars = widget.stars;
    currentTon = widget.ton;
  }

  @override
  void dispose() {
    giftNameCtrl.dispose();
    giftPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛠 Bosh Admin Panel"),
        backgroundColor: Colors.red[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "1. FOYDALANUVCHI BALANSI",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            color: const Color(0xFF1E2C3A),
            child: Column(
              children: [
                ListTile(
                  title: Text("Stars: $currentStars ⭐️"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        onPressed: () => _changeStars(-50),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () => _changeStars(50),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "TON: ${currentTon.toStringAsFixed(1)} 💎",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        onPressed: () => _changeTon(-0.5),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () => _changeTon(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "2. PREMIUM VA STARS NARXINI O'ZGARTIRISH",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            color: const Color(0xFF1E2C3A),
            child: Column(
              children: [
                ListTile(
                  title: Text("Premium narxi: \$$pPrice"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            pPrice = max(
                              0.99,
                              pPrice - 1,
                            );
                          });
                          _savePrices();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            pPrice += 1;
                          });
                          _savePrices();
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("100 Stars narxi: \$$sPrice"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            sPrice = max(
                              0.99,
                              sPrice - 0.5,
                            );
                          });
                          _savePrices();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            sPrice += 0.5;
                          });
                          _savePrices();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "3. GIFT (SOVG'ALAR) NARXLARINI BOSHQARISH",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            color: const Color(0xFF1E2C3A),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: giftNameCtrl,
                          decoration: const InputDecoration(
                            hintText: "Nomi",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: giftPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Stars narxi",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                        onPressed: _addGift,
                      ),
                    ],
                  ),
                  const Divider(),
                  ...widget.gifts.map(
                    (g) => ListTile(
                      title: Text(g["name"].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${g["price"]} ⭐️",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.gifts.remove(g);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addGift() {
    final name = giftNameCtrl.text.trim();
    final priceText = giftPriceCtrl.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      return;
    }

    final price = int.tryParse(priceText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Stars narxini raqam bilan kiriting!",
          ),
        ),
      );
      return;
    }

    setState(() {
      widget.gifts.add({
        "name": name,
        "price": price,
      });

      giftNameCtrl.clear();
      giftPriceCtrl.clear();
    });
  }

  void _changeStars(int delta) {
    setState(() {
      currentStars = max(
        0,
        currentStars + delta,
      );
    });

    widget.onUpdateBalance(
      currentStars,
      currentTon,
    );
  }

  void _changeTon(double delta) {
    setState(() {
      currentTon = max(
        0.0,
        currentTon + delta,
      );
    });

    widget.onUpdateBalance(
      currentStars,
      currentTon,
    );
  }

  void _savePrices() {
    widget.onSavePrices(
      pPrice,
      sPrice,
      sCost,
      rCost,
    );
  }
}
