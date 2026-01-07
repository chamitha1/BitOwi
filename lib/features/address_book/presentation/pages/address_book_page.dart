import 'package:BitOwi/features/address_book/data/models/address_item.dart';
import 'package:BitOwi/features/address_book/presentation/widgets/address_card.dart';
import 'package:BitOwi/features/address_book/presentation/pages/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  // Dummy Data
  final List<AddressItem> dummyAddresses = [
    AddressItem(
      name: "Main USDT Wallet",
      currencyCode: "USDT",
      address: "wuqian//tajeoh.ggg:.5000.cb.id",
      date: "2024-07-12 04:42:44",
      iconPath: "assets/icons/profile_page/address/usdt.svg",
    ),
    AddressItem(
      name: "Savings Bitcoin",
      currencyCode: "BTC",
      address: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
      date: "2024-08-20 10:15:22",
      iconPath: "assets/icons/profile_page/address/btc.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: SvgPicture.asset(
                'assets/icons/merchant_details/arrow_left.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF151E2F),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Address Book",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF151E2F),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x73F6F9FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDAE0EE), width: 1),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Address or Currency",
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF717F9A),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/profile_page/address/search.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF717F9A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Address List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: dummyAddresses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return AddressCard(item: dummyAddresses[index]);
                },
              ),
            ),

            // Add address Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AddAddressPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Add Address",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
