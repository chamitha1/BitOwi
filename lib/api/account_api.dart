import 'package:BitDo/config/api_client.dart';
import 'package:BitDo/models/account.dart';
import 'package:BitDo/models/account_detail_res.dart';
import 'package:BitDo/models/chain_symbol_list_res.dart';
import 'package:BitDo/models/withdraw_rule_detail_res.dart';

class AccountApi {
  static Future<AccountDetailAssetRes> getBalanceAccount({
    required String assetCurrency,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/account/balance_account',
        data: {'accountType': '4', 'assetCurrency': assetCurrency},
      );
      print("Get Balance Response ${res.data}");

      final resData = res.data as Map<String, dynamic>;

      if (resData['code'] == 200 || resData['code'] == '200') {
        // Extract the nested 'data' object
        final data = resData['data'] as Map<String, dynamic>;

        // Parse the AccountDetailAssetRes from the 'data' object
        final result = AccountDetailAssetRes.fromJson(data);

        print('Parsed result - Total Amount: ${result.totalAmount}');
        print('Parsed result - Total Asset: ${result.totalAsset}');
        print(
          'Parsed result - Account List length: ${result.accountList.length}',
        );

        return result;
      } else {
        throw Exception('API Error: ${resData['errorMsg']}');
      }
      // return AccountDetailAssetRes.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      print("GetBalanceAccount erroe: $e");
      rethrow;
    }
  }

  static Future<List<ChainSymbolListRes>> getChainSymbolList({
    String chargeFlag = '',
    String withdrawFlag = '',
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/chain_symbol/list_front',
        data: {"chargeFlag": chargeFlag, "withdrawFlag": withdrawFlag},
      );
      List<ChainSymbolListRes> list = (res.data['data'] as List<dynamic>)
          .map((item) => ChainSymbolListRes.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      print("getChainSymbolList error: $e");
      rethrow;
    }
  }

  //Deposit Address
  static Future<String> getChainAddress(String symbol) async {
    try {
      final res = await ApiClient.dio.post(
        '/xaccount/get_chain_address',
        data: {"symbol": symbol},
      );
      return res.data['data']["address"];
    } catch (e) {
      print("getChainAddress error: $e");
      rethrow;
    }
  }

  //📝TODO
  static Future<void> createBankCard(Map<String, dynamic> params) async {
    // try {
    //   final id = await HttpUtil.post('/core/v1/bankcard/create', params);
    //   return id;
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  static Future<void> editBankCard(Map<String, dynamic> params) async {
    // try {
    //   final id = await HttpUtil.post('/core/v1/bankcard/modify', params);
    //   return id;
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  static Future<void> deleteBankCard(String id) async {
    // try {
    //   await HttpUtil.post('/core/v1/bankcard/remove/$id');
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  static Future<void> createMobileBankCard(Map<String, dynamic> params) async {
    // try {
    //   final id =
    //       await HttpUtil.post('/core/v1/bankcard/mobile_money/create', params);
    //   return id;
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  static Future<void> editeMobileBankCard(Map<String, dynamic> params) async {
    // try {
    //   final id =
    //       await HttpUtil.post('/core/v1/bankcard/mobile_money/modify', params);
    //   return id;
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  static Future<void> deleteeMobileBankCard(String id) async {
    // try {
    //   await HttpUtil.post('/core/v1/bankcard/mobile_money/remove/$id');
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  //📝TODO
  // Future<List<BankcardChannelListRes>> getBankChannelList() async {
  // try {
  //   final res =
  //       await HttpUtil.post('/core/v1/bank_channel/public/list_front');
  //   List<BankcardChannelListRes> list = (res as List<dynamic>)
  //       .map((item) =>
  //           BankcardChannelListRes.fromJson(CommonUtils.removeNullKeys(item)))
  //       .toList();
  //   return list;
  // } catch (e) {
  //   e.printError();
  //   rethrow;
  // }
  // }

  //📝TODO
  // static Future<List<BankcardListRes>> getBankCardList() async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/bankcard/listByUserId');
  //   //   List<BankcardListRes> list = (res as List<dynamic>)
  //   //       .map(
  //   //         (item) =>
  //   //             BankcardListRes.fromJson(CommonUtils.removeNullKeys(item)),
  //   //       )
  //   //       .toList();
  //   //   return list;
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  //📝TODO
  // static Future<BankcardListRes> getBankCardDetail(String id) async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/bankcard/detail_front/$id');
  //   //   return BankcardListRes.fromJson(CommonUtils.removeNullKeys(res));
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  //📝TODO
  // static Future<List<CoinListRes>> getCoinList([
  //   Map<String, dynamic>? params,
  // ]) async {
  //   //   try {
  //   //     final res = await HttpUtil.post('/core/v1/coin/list_front', params);
  //   //     List<CoinListRes> list = (res as List<dynamic>)
  //   //         .map((item) => CoinListRes.fromJson(CommonUtils.removeNullKeys(item)))
  //   //         .toList();
  //   //     return list;
  //   //   } catch (e) {
  //   //     e.printError();
  //   //     rethrow;
  //   //   }
  // }

  //📝TODO
  // static Future<List<PersonalAddressListRes>> getAddressList() async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/personal_address/list_front');
  //   //   List<PersonalAddressListRes> list = (res as List<dynamic>)
  //   //       .map(
  //   //         (item) => PersonalAddressListRes.fromJson(
  //   //           CommonUtils.removeNullKeys(item),
  //   //         ),
  //   //       )
  //   //       .toList();
  //   //   return list;
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  /// 📝TODO
  static Future<void> createAddress(Map<String, dynamic> params) async {
    // try {
    //   await HttpUtil.post('/core/v1/personal_address/create', params);
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  /// 📝TODO
  static Future<void> editAddress(Map<String, dynamic> params) async {
    // try {
    //   final id = await HttpUtil.post(
    //     '/core/v1/personal_address/modify',
    //     params,
    //   );
    //   return id;
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  /// 📝TODO
  static Future<void> deleteAddress(String id) async {
    // try {
    //   await HttpUtil.post('/core/v1/personal_address/remove/$id');
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  /// 📝TODO
  // static Future<PersonalAddressListRes> getAddressDetail(String id) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/personal_address/detail_front/$id',
  //   //   );
  //   //   return PersonalAddressListRes.fromJson(CommonUtils.removeNullKeys(res));
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  /// 📝TODO
  // static Future<AccountAssetRes> getHomeAsset([String? currency]) async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/account/home_asset', {
  //   //     "currency": currency,
  //   //   });
  //   //   return AccountAssetRes.fromJson(CommonUtils.removeNullKeys(res));
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  /// 📝TODO
  // static Future<AccountDetailAccountAndJourRes> getDetailAccountAndJour(
  //   String accountNumber,
  //   String currency,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/account/detail_account_and_jour',
  //   //     {'accountNumber': accountNumber, 'currency': currency},
  //   //   );
  //   //   return AccountDetailAccountAndJourRes.fromJson(
  //   //     CommonUtils.removeNullKeys(res),
  //   //   );
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  /// 📝TODO
  static Future<Account> getDetailAccount(String currency) async {
    try {
      final res = await ApiClient.dio.post(
        '/account/detailByUser',
        data: {'accountType': '4', 'currency': currency},
      );
      return Account.fromJson(res.data['data']);
    } catch (e) {
      print("getDetailAccount error: $e");
      rethrow;
    }
  }

  // /// 📝TODO
  // static Future<PageInfo<Jour>> getJourPageList(
  //   Map<String, dynamic> params,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/jour/my/page', params);
  //   //   return PageInfo.fromJson<Jour>(res, Jour.fromJson);
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  // /// 📝TODO
  // static Future<JourFrontDetail> getJourDetail(String id) async {
  //   try {
  //     final res = await HttpUtil.post('/core/v1/jour/detail_front/$id');
  //     return JourFrontDetail.fromJson(CommonUtils.removeNullKeys(res));
  //   } catch (e) {
  //     e.printError();
  //     rethrow;
  //   }
  // }

  // /// 📝TODO
  // static Future<String> getTbayBalance() async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/exchange_order/user_balance');
  //   //   return res;
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }
  // //📝TODO
  // static Future<String> getCardGoalBalance() async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/exchange_order/cardgoal_balance',
  //   //   );
  //   //   return res;
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  // /// 📝TODO
  // static Future<PageInfo<ExchangeSymbolPairPageRes>> getExchangePairPageList(
  //   Map<String, dynamic> params,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/exchange_symbol_pair/page_front',
  //   //     params,
  //   //   );
  //   //   return PageInfo.fromJson<ExchangeSymbolPairPageRes>(
  //   //     res,
  //   //     ExchangeSymbolPairPageRes.fromJson,
  //   //   );
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  // //📝TODO
  // static Future<PageInfo<ExchangeSymbolPairPageRes>> getExchangePairPageListCG(
  //   Map<String, dynamic> params,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/exchange_order/cardgoal_exchange',
  //   //     params,
  //   //   );
  //   //   return PageInfo.fromJson<ExchangeSymbolPairPageRes>(
  //   //     res,
  //   //     ExchangeSymbolPairPageRes.fromJson,
  //   //   );
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  /// 📝TODO
  static Future<void> createExchangeOrder(Map<String, dynamic> params) async {
    // try {
    //   await HttpUtil.post('/core/v1/exchange_order/create', params);
    // } catch (e) {
    //   e.printError();
    //   rethrow;
    // }
  }

  /// 📝TODO  (show list of history / records in swap to usdt page)
  // static Future<PageInfo<ExchangeOrderPageRes>> getExchangeOrderPageList(
  //   Map<String, dynamic> params,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/exchange_order/page_front',
  //   //     params,
  //   //   );
  //   //   return PageInfo.fromJson<ExchangeOrderPageRes>(
  //   //     res,
  //   //     ExchangeOrderPageRes.fromJson,
  //   //   );
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  // /// 📝TODO
  // static Future<ExchangeOrderPageRes> getExchangeOrderDetails(String id) async {
  //   // try {
  //   //   final res = await HttpUtil.post(
  //   //     '/core/v1/exchange_order/detail_front/$id',
  //   //   );
  //   //   return ExchangeOrderPageRes.fromJson(CommonUtils.removeNullKeys(res));
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  ///

  // /// /📝TODO
  static Future<WithdrawRuleDetailRes> getWithdrawRuleDetail(
    String symbol,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/withdraw_rule/detail_front',
        data: {"symbol": symbol},
      );
      return WithdrawRuleDetailRes.fromJson(res.data['data']);
    } catch (e) {
      print("getWithdrawRuleDetail error: $e");
      rethrow;
    }
  }

  /// 📝TODO
  static Future<void> withdrawCheck(Map<String, dynamic> params) async {
    try {
      await ApiClient.dio.post('/withdraw/check', data: params);
    } catch (e) {
      print("withdrawCheck error: $e");
      rethrow;
    }
  }

  /// 📝TODO
  static Future<void> createWithdraw(Map<String, dynamic> params) async {
    try {
      await ApiClient.dio.post('/withdraw/create', data: params);
    } catch (e) {
      print("createWithdraw error: $e");
      rethrow;
    }
  }

  /// 📝TODO
  // static Future<PageInfo<WithdrawPageRes>> getWithdrawPageList(
  //   Map<String, dynamic> params,
  // ) async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/withdraw/page_front', params);
  //   //   return PageInfo.fromJson<WithdrawPageRes>(res, WithdrawPageRes.fromJson);
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }

  // ///📝TODO
  // static Future<WithdrawDetailRes> getWithdrawDetail(String id) async {
  //   // try {
  //   //   final res = await HttpUtil.post('/core/v1/withdraw/detail_front/$id');
  //   //   return WithdrawDetailRes.fromJson(CommonUtils.removeNullKeys(res));
  //   // } catch (e) {
  //   //   e.printError();
  //   //   rethrow;
  //   // }
  // }
}
