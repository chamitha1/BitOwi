import 'package:BitOwi/features/profile/presentation/widgets/partner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["My Trusted", "Trusted me", "Block List"];
  final TextEditingController _searchController = TextEditingController();

  final List<PartnerItem> _allPartners = [
    PartnerItem(
      name: "Patsy Willms",
      avatarUrl: "assets/images/home/avatar.png",
      isOnline: true,
      isCertified: true,
      goodRate: "98",
      trustCount: 124,
      tradeCount: 450,
      finishRate: "99",
      addedDate: "2024-07-12",
    ),
    PartnerItem(
      name: "Dianne Russell",
      avatarUrl: "assets/images/home/avatar.png",
      isOnline: false,
      isCertified: false,
      goodRate: "95",
      trustCount: 88,
      tradeCount: 200,
      finishRate: "97",
      addedDate: "2024-06-20",
    ),
    PartnerItem(
      name: "Ralph Edwards",
      avatarUrl: "assets/images/home/avatar.png",
      isOnline: true,
      isCertified: true,
      goodRate: "100",
      trustCount: 300,
      tradeCount: 1200,
      finishRate: "100",
      addedDate: "2024-05-15",
    ),
    PartnerItem(
      name: "Courtney Henry",
      avatarUrl: "assets/images/home/avatar.png",
      isOnline: false,
      isCertified: false,
      goodRate: "92",
      trustCount: 45,
      tradeCount: 120,
      finishRate: "94",
      addedDate: "2024-08-01",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Partners",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF151E2F),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildTabs(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              itemCount: _allPartners.length,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                return PartnerCard(item: _allPartners[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFFECEFF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w700,
                  fontSize: 16,
                  color: isSelected ? Colors.white : const Color(0xFF717F9A),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        // color: const Color(0xffF6F9FF).withOpacity(0.45),
        color: Color.fromRGBO(246, 249, 255, 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search by name",
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
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'assets/icons/profile_page/microphone.svg',
              width: 20,
              height: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
