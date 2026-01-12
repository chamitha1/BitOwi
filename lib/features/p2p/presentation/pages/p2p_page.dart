import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/p2p_order_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/p2p_empty_state.dart';

import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:easy_refresh/easy_refresh.dart';

class P2PPage extends StatefulWidget {
  const P2PPage({super.key});

  @override
  State<P2PPage> createState() => _P2PPageState();
}

class _P2PPageState extends State<P2PPage> {
  bool isBuySelected = true;
  List<Dict> _currencyList = [];
  Dict? _selectedCurrency;
  String? _minPrice;
  late TextEditingController _searchController;

  // Ads List State
  List<AdItem> _adsList = [];
  int _pageNum = 1;
  bool _isEnd = false;
  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchCurrencies();
    // Verify init fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAds(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrencies() async {
    try {
      final list = await CommonApi.getDictList(parentKey: 'ads_trade_currency');
      if (list.isNotEmpty) {
        setState(() {
          _currencyList = list;
          _selectedCurrency = list.firstWhere(
            (e) => e.key == 'NGN',
            orElse: () => list.first,
          );
        });
        // Fetch ads after currency is set
        _fetchAds(isRefresh: true);
      }
    } catch (e) {
      debugPrint("Error fetching currencies: $e");
    }
  }

  Future<void> _fetchAds({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _pageNum = 1;
        _isEnd = false;
      } else if (_isEnd) {
        _refreshController.finishLoad(IndicatorResult.noMore);
        return;
      }

      final Map<String, dynamic> params = {
        "pageNum": _pageNum,
        "pageSize": 10,
        "tradeCoin": "USDT",
        "tradeType": isBuySelected ? "1" : "0",
      };

      final String nickName = _searchController.text.trim();

      if (nickName.isNotEmpty) {
        params["nickName"] = nickName;
      } else {
        params["tradeCurrency"] = _selectedCurrency?.key ?? "";
        params["minPrice"] = _minPrice;
      }

      final res = await P2PApi.getAdsPageList(params);

      setState(() {
        if (isRefresh) {
          _adsList = res.list;
        } else {
          _adsList.addAll(res.list);
        }
        if (res.list.isEmpty ||
            (res.total != null && _adsList.length >= res.total!)) {
          _isEnd = true;
        }
        _pageNum++;
      });

      if (isRefresh) {
        _refreshController.finishRefresh();
        _refreshController.resetFooter();
      } else {
        _refreshController.finishLoad(
          _isEnd ? IndicatorResult.noMore : IndicatorResult.success,
        );
      }
    } catch (e) {
      debugPrint("Error fetching ads: $e");
      if (isRefresh) {
        _refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        _refreshController.finishLoad(IndicatorResult.fail);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  SizedBox(height: 56, child: _buildHeader()),
                  const SizedBox(height: 20),
                  _buildTradeTypeToggle(),
                  const SizedBox(height: 20),
                  _buildFilterRow(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isEmpty = false;

                  return EasyRefresh(
                    controller: _refreshController,
                    onRefresh: () async {
                      await _fetchAds(isRefresh: true);
                    },
                    onLoad: () async {
                      await _fetchAds();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: _adsList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return P2POrderCard(
                          isBuy: isBuySelected,
                          adItem: _adsList[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "P2P",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color(0xFF151E2F),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1D5DE5), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/p2p/plus.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1D5DE5),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Post an Ad",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF1D5DE5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradeTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => isBuySelected = true);
              _fetchAds(isRefresh: true);
            },
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isBuySelected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFFE8ECF4),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(right: 8),
              child: Text(
                "Buy",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isBuySelected ? Colors.white : const Color(0xFF717F9A),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => isBuySelected = false);
              _fetchAds(isRefresh: true);
            },
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !isBuySelected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFFE8ECF4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Sell",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: !isBuySelected
                      ? Colors.white
                      : const Color(0xFF717F9A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        // Currency Dropdown
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Dict>(
              value: _selectedCurrency,
              icon: SvgPicture.asset(
                'assets/icons/p2p/down-arrow.svg',
                width: 10,
                height: 6,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF151E2F),
                  BlendMode.srcIn,
                ),
              ),
              items: _currencyList.map((Dict currency) {
                return DropdownMenuItem<Dict>(
                  value: currency,
                  child: Text(
                    currency.key,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Dict? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                  _fetchAds(isRefresh: true);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Search Bar
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDAE0EE)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _fetchAds(isRefresh: true);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/p2p/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF717F9A),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _fetchAds(isRefresh: true);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Here",
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF717F9A),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Filter Button
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => FilterBottomSheet(
                initialAmount: _minPrice,
                initialCurrency: _selectedCurrency?.key,
              ),
            );

            if (result != null) {
              if (result['type'] == 'reset') {
                setState(() {
                  _minPrice = null;
                  _selectedCurrency = null;
                });
                _fetchAds(isRefresh: true);
              } else if (result['type'] == 'filter') {
                final amount = result['amount'];
                final currencyKey = result['currency'];

                setState(() {
                  _minPrice = amount;
                  if (currencyKey != null) {
                    try {
                      _selectedCurrency = _currencyList.firstWhere(
                        (e) => e.key == currencyKey,
                        orElse: () =>
                            Dict(key: currencyKey, value: currencyKey),
                      );
                    } catch (_) {}
                  }
                });
                _fetchAds(isRefresh: true);
              }
            }
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1D5DE5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/icons/p2p/filter.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
