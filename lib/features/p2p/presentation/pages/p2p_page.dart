import 'package:BitOwi/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/models/coin_list_res.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:get/get.dart';

import '../widgets/p2p_order_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/p2p_empty_state.dart';

class P2PPage extends StatefulWidget {
  const P2PPage({super.key});

  @override
  State<P2PPage> createState() => _P2PPageState();
}

class _P2PPageState extends State<P2PPage> {
  bool isBuySelected = true;

  // Filters
  List<CoinListRes> _coinList = [];
  CoinListRes? _selectedCoin;
  String? _minPrice;

  late final TextEditingController _searchController;

  // Ads List State
  List<AdItem> _adsList = [];
  int _pageNum = 1;
  bool _isEnd = false;
  
  Dict? _selectedCurrency;

  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  CoinListRes? _defaultCoin(List<CoinListRes> list) {
    if (list.isEmpty) return null;
    return list.firstWhere(
      (e) => e.symbol == 'USDT',
      orElse: () => list.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _fetchCoins();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCoins() async {
    try {
      final list = await AccountApi.getCoinList();

      if (!mounted) return;

      setState(() {
        _coinList = list;
        _selectedCoin = _defaultCoin(list);
      });

      await _fetchAds(isRefresh: true);
    } catch (e) {
      debugPrint("Error fetching coins: $e");

      await _fetchAds(isRefresh: true);
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
        "tradeCoin": _selectedCoin?.symbol ?? "USDT",
        "tradeType": isBuySelected ? "1" : "0",
      };

      final String nickName = _searchController.text.trim();

      if (nickName.isNotEmpty) {
        params["nickName"] = nickName;
      } else {
        if (_minPrice != null && _minPrice!.trim().isNotEmpty) {
          params["minPrice"] = _minPrice!.trim();
        }
        // Add tradeCurrency filter if selected via bottom sheet
        if (_selectedCurrency != null) {
          params['tradeCurrency'] = _selectedCurrency!.key;
        }
      }
      
      debugPrint("P2PPage: Fetching ads with params: $params");

      final res = await P2PApi.getAdsPageList(params);

      if (!mounted) return;

      setState(() {
        if (isRefresh) {
          _adsList = res.list;
        } else {
          _adsList.addAll(res.list);
        }

        // End check
        if (res.list.isEmpty ||
            (res.total != null && _adsList.length >= res.total!)) {
          _isEnd = true;
        }

        _pageNum++;
      });

      if (isRefresh) {
        _refreshController.finishRefresh(IndicatorResult.success);
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

  Widget _emptyScrollable() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: const [
        SizedBox(height: 60),
        P2PEmptyState(),
      ],
    );
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
              child: EasyRefresh(
                controller: _refreshController,
                onRefresh: () => _fetchAds(isRefresh: true),
                onLoad: () => _fetchAds(),
                child: _adsList.isEmpty
                    ? _emptyScrollable()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: _adsList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          return P2POrderCard(
                            isBuy: isBuySelected,
                            adItem: _adsList[index],
                          );
                        },
                      ),
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
          onTap: () async {
            final result = await Get.toNamed(Routes.postAdsPage);
            // refresh after coming back
            if (result == true) {
              _fetchAds(isRefresh: true);
            }
          },
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
              if (!isBuySelected) {
                setState(() => isBuySelected = true);
                _fetchAds(isRefresh: true);
              }
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
              if (isBuySelected) {
                setState(() => isBuySelected = false);
                _fetchAds(isRefresh: true);
              }
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
                  color:
                      !isBuySelected ? Colors.white : const Color(0xFF717F9A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinDropdown() {
    final bool hasCoins = _coinList.isNotEmpty;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CoinListRes>(
          value: hasCoins ? _selectedCoin : null,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
            color: Color(0xFF151E2F),
          ),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF151E2F),
          ),
          items: _coinList.map((CoinListRes coin) {
            return DropdownMenuItem<CoinListRes>(
              value: coin,
              child: Text(
                coin.symbol ?? 'USDT',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF151E2F),
                ),
              ),
            );
          }).toList(),
          onChanged: hasCoins
              ? (CoinListRes? newValue) {
                  if (newValue == null) return;
                  setState(() => _selectedCoin = newValue);
                  _fetchAds(isRefresh: true);
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        // Currency Dropdown
        // Container(
        //   height: 48,
        //   padding: const EdgeInsets.symmetric(horizontal: 12),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<Dict>(
        //       value: hasCurrencies ? _selectedCurrency : null,
        //       icon: SvgPicture.asset(
        //         'assets/icons/p2p/down-arrow.svg',
        //         width: 10,
        //         height: 6,
        //         colorFilter: const ColorFilter.mode(
        //           Color(0xFF151E2F),
        //           BlendMode.srcIn,
        //         ),
        //       ),
        //       items: _currencyList.map((Dict currency) {
        //         return DropdownMenuItem<Dict>(
        //           value: currency,
        //           child: Text(
        //             currency.key,
        //             style: const TextStyle(
        //               fontFamily: 'Inter',
        //               fontWeight: FontWeight.w500,
        //               fontSize: 14,
        //               color: Color(0xFF151E2F),
        //             ),
        //           ),
        //         );
        //       }).toList(),
        //       onChanged: hasCurrencies
        //           ? (Dict? newValue) {
        //               if (newValue == null) return;
        //               setState(() {
        //                 _selectedCurrency = newValue;
        //                 // optional: if user changes currency, clear search
        //                 // _searchController.clear();
        //               });
        //               _fetchAds(isRefresh: true);
        //             }
        //           : null,
        //     ),
        //   ),
        // ),
        _buildCoinDropdown(),
        const SizedBox(width: 12),

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
                  onTap: () => _fetchAds(isRefresh: true),
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
                    onSubmitted: (_) => _fetchAds(isRefresh: true),
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
              builder: (_) => FilterBottomSheet(
                initialAmount: _minPrice,
                initialCurrency: _selectedCurrency?.key,
              ),
            );

            if (!mounted || result == null) return;

            if (result['type'] == 'reset') {
              setState(() {
                _minPrice = null;
                _selectedCurrency = null; // Clear filter currency
              });
              _fetchAds(isRefresh: true);
              return;
            }

            if (result['type'] == 'filter') {
              final amount = (result['amount'] ?? '').toString();
              final currency = result['currency'] as Dict?;
              
              debugPrint("P2PPage: Filter result received. Amount=$amount, Currency=${currency?.key}");

              setState(() {
                _minPrice = amount.trim().isEmpty ? null : amount.trim();
                if (currency != null) {
                   _selectedCurrency = currency;
                }
              });

              _fetchAds(isRefresh: true);
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
