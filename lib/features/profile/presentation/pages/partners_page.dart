import 'dart:async';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/features/profile/presentation/widgets/partner_card.dart';
import 'package:BitOwi/models/user_relation_page_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["My Trusted", "Trusted me", "Block List"];
  final TextEditingController _searchController = TextEditingController();
  late EasyRefreshController _controller;

  List<UserRelationPageRes> _list = [];
  List<UserRelationPageRes> _filteredList = [];
  int _pageNum = 1;
  bool _isEnd = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    // Initial fetch
    _onRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _filterList(query);
  }

  void _filterList(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList = List.from(_list);
      });
    } else {
      setState(() {
        _filteredList = _list.where((item) {
          final name = (item.nickname).toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> _onRefresh() async {
    try {
      await _getList(isRefresh: true);
      if (!mounted) return;
      setState(() {});
      _controller.finishRefresh();
      _controller.resetFooter();
    } catch (e) {
      _controller.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> _onLoad() async {
    try {
      await _getList();
      if (!mounted) return;
      setState(() {});
      _controller.finishLoad(
        _isEnd ? IndicatorResult.noMore : IndicatorResult.success,
      );
    } catch (e) {
      _controller.finishLoad(IndicatorResult.fail);
    }
  }

  Future<void> _getList({bool isRefresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      if (isRefresh) {
        _pageNum = 1;
      }

      // Tab 0 "My Trusted" -> type '1' (Trust)
      // Tab 1 "Trusted Me" -> type '2' (Trust me)
      // Tab 2 "Block List" -> type '0' (Block)
      String type = '1';
      if (_selectedTabIndex == 1) type = '2';
      if (_selectedTabIndex == 2) type = '0';

      AppLogger.d("Fetching partners list: page=$_pageNum, type=$type");

      final res = await UserApi.getUserRelationPageList({
        "pageNum": _pageNum,
        "pageSize": 10,
        "type": type,
      });

      _isEnd = res.isEnd;

      if (isRefresh) {
        _list = res.list;
      } else {
        _list.addAll(res.list);
      }

      _filterList(_searchController.text);

      _pageNum++;
    } catch (e) {
      AppLogger.d("Error fetching partners: $e");
    } finally {
      _isLoading = false;
    }
  }

  void _onTabChange(int index) async {
    if (_selectedTabIndex == index) return;
    setState(() {
      _selectedTabIndex = index;
    });
    // Refresh list when tab changes
    _controller.callRefresh();
  }

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
            child: EasyRefresh(
              controller: _controller,
              onRefresh: _onRefresh,
              onLoad: _onLoad,
              header: const ClassicHeader(),
              footer: const ClassicFooter(),
              child: _filteredList.isEmpty
                  ? SingleChildScrollView(
                      child: Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/profile_page/address/search.svg',
                              width: 80,
                              height: 80,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFDAE0EE),
                                BlendMode.srcIn,
                              ),
                            ).paddingOnly(bottom: 16),
                            const Text(
                              "No partners found",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF717F9A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      itemCount: _filteredList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final data = _filteredList[index];

                        String goodRate = "0";
                        if (data.commentCount > 0) {
                          goodRate =
                              ((data.commentGoodCount / data.commentCount) *
                                      100)
                                  .toStringAsFixed(0);
                        }

                        String finishRate = "0";
                        if (data.orderCount > 0) {
                          finishRate =
                              ((data.orderFinishCount / data.orderCount) * 100)
                                  .toStringAsFixed(1);
                        }

                        final partnerId = _selectedTabIndex == 1
                            ? data.userId.toString()
                            : data.toUser.toString();

                        //Format Date
                        String formattedDate = '';
                        final dynamic rawDate = data.createDatetime;
                        try {
                          DateTime? date;

                          // Handle timestamp (ms)
                          if (rawDate is int) {
                            date = DateTime.fromMillisecondsSinceEpoch(rawDate);
                          } else if (rawDate is String) {
                            // Handle string timestamp
                            if (RegExp(r'^\d+$').hasMatch(rawDate)) {
                              date = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(rawDate),
                              );
                            } else {
                              // Handle standard date strings
                              date =
                                  DateTime.tryParse(rawDate) ??
                                  DateFormat(
                                    "yyyy-MM-dd HH:mm:ss",
                                  ).parse(rawDate);
                            }
                          }

                          if (date != null) {
                            formattedDate = DateFormat(
                              'yyyy-MM-dd',
                            ).format(date);
                          } else {
                            formattedDate = rawDate.toString();
                          }
                        } catch (e) {
                          formattedDate = rawDate.toString();
                        }

                        final item = PartnerItem(
                          name: data.nickname,
                          userId: partnerId,
                          avatarUrl: data.photo.isNotEmpty
                              ? data.photo
                              : "assets/images/home/avatar.png",
                          isOnline: false, // Not in API
                          isCertified: false, // Not in API
                          goodRate: goodRate,
                          trustCount: data.confidenceCount,
                          tradeCount: data.orderCount,
                          finishRate: finishRate,
                          addedDate: formattedDate,
                        );

                        return PartnerCard(item: item);
                      },
                    ),
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
            onTap: () => _onTabChange(index),
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
        color: const Color.fromRGBO(246, 249, 255, 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
