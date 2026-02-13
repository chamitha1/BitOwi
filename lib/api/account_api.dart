import 'dart:convert';

import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/account.dart';
import 'package:BitOwi/models/account_asset_res.dart';
import 'package:BitOwi/models/account_detail_res.dart';
import 'package:BitOwi/models/bankcard_channel_list_res.dart';
import 'package:BitOwi/models/bankcard_list_res.dart';
import 'package:BitOwi/models/chain_symbol_list_res.dart';
import 'package:BitOwi/models/withdraw_page_res.dart';
import 'package:BitOwi/models/withdraw_rule_detail_res.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/models/jour_front_detail.dart';
import 'package:BitOwi/models/account_detail_account_and_jour_res.dart';
import 'package:BitOwi/models/withdraw_detail_res.dart';
import 'package:BitOwi/features/address_book/data/models/personal_address_list_res.dart';
import 'package:BitOwi/models/coin_list_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';

class AccountApi {
  static Future<AccountDetailAssetRes> getBalanceAccount({
    String? assetCurrency,
  }) async {
    try {
      final Map<String, dynamic> data = {'accountType': '4'};
      if (assetCurrency != null) {
        data['assetCurrency'] = assetCurrency;
      }
      final res = await ApiClient.dio.post(
        '/core/v1/account/balance_account',
        data: data,
      );
      AppLogger.d("Get Balance Response ${res.data}");

      final resData = res.data as Map<String, dynamic>;

      if (resData['code'] == 200 || resData['code'] == '200') {
        // Extract the nested 'data' object
        final data = resData['data'] as Map<String, dynamic>;

        // Parse the AccountDetailAssetRes from the 'data' object
        final result = AccountDetailAssetRes.fromJson(data);

        AppLogger.d('Parsed result - Total Amount: ${result.totalAmount}');
        AppLogger.d('Parsed result - Total Asset: ${result.totalAsset}');
        AppLogger.d(
          'Parsed result - Account List length: ${result.accountList.length}',
        );

        return result;
      } else {
        throw Exception('API Error: ${resData['errorMsg']}');
      }
      // return AccountDetailAssetRes.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      AppLogger.d("GetBalanceAccount erroe: $e");
      rethrow;
    }
  }

  static Future<List<ChainSymbolListRes>> getChainSymbolList({
    String chargeFlag = '',
    String withdrawFlag = '',
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/chain_symbol/list_front',
        data: {"chargeFlag": chargeFlag, "withdrawFlag": withdrawFlag},
      );
      List<ChainSymbolListRes> list = (res.data['data'] as List<dynamic>)
          .map((item) => ChainSymbolListRes.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      AppLogger.d("getChainSymbolList error: $e");
      rethrow;
    }
  }

  //Deposit Address
  static Future<String> getChainAddress(String symbol) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/xaccount/get_chain_address',
        data: {"symbol": symbol},
      );
      return res.data['data']["address"];
    } catch (e) {
      AppLogger.d("getChainAddress error: $e");
      rethrow;
    }
  }

  static Future<WithdrawRuleDetailRes> getWithdrawRuleDetail(
    String symbol,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/withdraw_rule/detail_front',
        data: {"symbol": symbol},
      );
      final resData = res.data as Map<String, dynamic>;
      if (resData['code'] == 200 || resData['code'] == '200') {
        if (resData['data'] == null) {
          return WithdrawRuleDetailRes();
        }
        return WithdrawRuleDetailRes.fromJson(resData['data']);
      } else {
        throw Exception('API Error: ${resData['errorMsg']}');
      }
    } catch (e) {
      AppLogger.d("getWithdrawRuleDetail error: $e");
      rethrow;
    }
  }

  static Future<WithdrawDetailRes> getWithdrawDetail(String id) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/withdraw/detail_front/$id',
      );
      AppLogger.d("Raw Withdraw Detail Response (Dio): ${res.data}");
      AppLogger.d("Raw Withdraw Detail Response (Dio): $res");

      var data = res.data;
      if (data is Map) {
        if (data.containsKey('data')) {
          data = data['data'];
        }
      }

      if (data == null) {
        AppLogger.d("Warning: Withdraw detail data is null");
        return WithdrawDetailRes(
          id: id,
          userId: '',
          amount: '0',
          actualAmount: '0',
          fee: '0',
          currency: '',
          status: '',
          createDatetime: '',
        );
      }

      final cleanData = _removeNullKeys(Map<String, dynamic>.from(data));
      AppLogger.d("Cleaned Data for Model: $cleanData");

      return WithdrawDetailRes.fromJson(cleanData);
    } catch (e) {
      AppLogger.d("getWithdrawDetail error: $e");
      rethrow;
    }
  }

  static Map<String, dynamic> _removeNullKeys(Map<String, dynamic> map) {
    map.removeWhere((key, value) => value == null);
    return map;
  }

  static Future<void> withdrawCheck(Map<String, dynamic> params) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/withdraw/check',
        data: params,
      );
      final resData = res.data as Map<String, dynamic>;
      if (resData['code'] != 200 && resData['code'] != '200') {
        throw Exception(
          resData['errorMsg'] ?? resData['msg'] ?? 'Check failed',
        );
      }
    } catch (e) {
      AppLogger.d("withdrawCheck error: $e");
      rethrow;
    }
  }

  static Future<void> createWithdraw(Map<String, dynamic> params) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/withdraw/create',
        data: params,
      );
      final resData = res.data as Map<String, dynamic>;
      if (resData['code'] == 200 || resData['code'] == '200') {
        // Success
        return;
      } else {
        throw Exception(
          resData['errorMsg'] ?? resData['msg'] ?? 'Withdrawal failed',
        );
      }
    } catch (e) {
      AppLogger.d("createWithdraw error: $e");
      rethrow;
    }
  }

  static Future<PageInfo<WithdrawPageRes>> getWithdrawPageList(
    Map<String, dynamic> params,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/withdraw/page_front',
        data: params,
      );
      return PageInfo<WithdrawPageRes>.fromJson(
        res.data,
        WithdrawPageRes.fromJson,
      );
    } catch (e) {
      AppLogger.d("getWithdrawPageList error: $e");
      rethrow;
    }
  }

  static Future<Account> getDetailAccount(String currency) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/account/detailByUser',
        data: {'accountType': '4', 'currency': currency},
      );

      final data = res.data['data'];
      AppLogger.d('Data before parsing: ${jsonEncode(data)}');
      final Map<String, dynamic> accountData = {};
      if (data != null && data is Map<String, dynamic>) {
        // Map API fields to model fields
        accountData['id'] = data['id']?.toString();
        accountData['accountNumber'] = data['accountNumber']?.toString();
        accountData['accountType'] = data['accountType']?.toString();
        accountData['currency'] = data['currency']?.toString();
        accountData['totalAmount'] = data['amount']
            ?.toString(); // Map 'amount' to 'totalAmount'
        accountData['availableAmount'] = data['availableAmount']?.toString();
        accountData['frozenAmount'] = data['frozenAmount']?.toString();
        accountData['usableAmount'] = data['usableAmount']?.toString();
        accountData['amount'] = data['amount']?.toString(); //keep as 'amount'
      }

      AppLogger.d("Account data prepared: $accountData");
      return Account.fromJson(accountData);
      // AppLogger.d(data);
      // return Account.fromJson(data);
    } catch (e) {
      AppLogger.d("getDetailAccount error: $e");
      rethrow;
    }
  }

  static Future<PageInfo<Jour>> getJourPageList(
    Map<String, dynamic> params,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/jour/my/page',
        data: params,
      );
      // Assuming res.data is the JSON map
      return PageInfo<Jour>.fromJson(res.data, Jour.fromJson);
    } catch (e) {
      AppLogger.d("getJourPageList error: $e");
      rethrow;
    }
  }

  static Future<List<PersonalAddressListRes>> getAddressList() async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/personal_address/list_front',
        data: {},
      );
      final data = res.data;
      AppLogger.d('AddressBook Response: $data');
      if (data is Map<String, dynamic> && data['code'] == '200') {
        final listData = data['data'] as List<dynamic>;
        return listData
            .map(
              (e) => PersonalAddressListRes.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else if (data is List) {
        return data
            .map(
              (e) => PersonalAddressListRes.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.d('Error fetching address list: $e');
      rethrow;
    }
  }

  /// Add new bank card
  static Future<Response<dynamic>> createBankCard(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/bankcard/create',
        data: params,
      );
      return response;
    } catch (e) {
      AppLogger.d("createBankCard error: $e");
      rethrow;
    }
  }

  /// Modify bank card
  static Future<Response<dynamic>> editBankCard(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/bankcard/modify',
        data: params,
      );
      return response;
    } catch (e) {
      AppLogger.d("editBankCard error: $e");
      rethrow;
    }
  }

  //📝TODO
  static Future<void> deleteBankCard(String id) async {
    try {
      await ApiClient.dio.post('/core/v1/bankcard/remove/$id');
    } catch (e) {
      AppLogger.d("deleteBankCard error: $e");
      rethrow;
    }
  }

  //📝TODO
  static Future<Response<dynamic>> createMobileBankCard(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/bankcard/mobile_money/create',
        data: params,
      );
      return response;
    } catch (e) {
      AppLogger.d("createMobileBankCard error: $e");
      rethrow;
    }
  }

  //📝TODO
  static Future<Response<dynamic>> editeMobileBankCard(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/bankcard/mobile_money/modify',
        data: params,
      );
      return response;
    } catch (e) {
      AppLogger.d("editeMobileBankCard error: $e");
      rethrow;
    }
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
  static Future<List<BankcardChannelListRes>> getBankChannelList() async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/bank_channel/public/list_front',
        data: {},
      );
      final data = res.data['data'];
      // Check if the response is null or not a list
      if (data is! List) {
        AppLogger.d("API returned null or invalid data: $res");
        return []; // Return an empty list in case of error
      }
      List<BankcardChannelListRes> list = data
          .map((item) => BankcardChannelListRes.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      AppLogger.d("getBankChannelList Error: $e");
      rethrow;
    }
  }

  // 📝TODO
  /// Check bank card list
  static Future<List<BankcardListRes>> getBankCardList() async {
    try {
      final res = await ApiClient.dio.post('/core/v1/bankcard/listByUserId');
      List<BankcardListRes> list = (res.data['data'] as List<dynamic>)
          .map((item) => BankcardListRes.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      AppLogger.d("getBankCardList error: $e");
      rethrow;
    }
  }

  // Check bank card details
  static Future<BankcardListRes> getBankCardDetail(String id) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/bankcard/detail_front/$id',
      );
      // final cleanData = _removeNullKeys(Map<String, dynamic>.from(res.data));
      final Map<String, dynamic> body = Map<String, dynamic>.from(res.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(body['data']);
      return BankcardListRes.fromJson(data);
    } catch (e) {
      AppLogger.d("getBankCardDetail error: $e");
      rethrow;
    }
  }

  static Future<List<CoinListRes>> getCoinList() async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/coin/list_front',
        data: {},
      );
      final data = res.data;
      if (data is Map<String, dynamic> &&
          (data['code'] == 200 || data['code'] == '200')) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => CoinListRes.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.d("getCoinList error: $e");
      rethrow;
    }
  }

  static Future<void> createAddress(Map<String, dynamic> params) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/personal_address/create',
        data: params,
      );
      final data = res.data;
      if (data['code'] == 200 || data['code'] == '200') {
        return;
      } else {
        throw Exception(data['errorMsg'] ?? 'Failed to create address');
      }
    } catch (e) {
      AppLogger.d("createAddress error: $e");
      rethrow;
    }
  }

  static Future<void> editAddress(Map<String, dynamic> params) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/personal_address/modify',
        data: params,
      );
      final data = res.data;
      if (data['code'] == 200 || data['code'] == '200') {
        return;
      } else {
        throw Exception(data['errorMsg'] ?? 'Failed to update address');
      }
    } catch (e) {
      AppLogger.d("editAddress error: $e");
      rethrow;
    }
  }

  static Future<void> deleteAddress(String id) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/personal_address/remove/$id',
      );
      final data = res.data;
      if (data['code'] == 200 || data['code'] == '200') {
        return;
      } else {
        throw Exception(data['errorMsg'] ?? 'Failed to delete address');
      }
    } catch (e) {
      AppLogger.d("deleteAddress error: $e");
      rethrow;
    }
  }

  static Future<PersonalAddressListRes> getAddressDetail(String id) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/personal_address/detail_front/$id',
      );
      final resData = res.data;
      if (resData['code'] == 200 || resData['code'] == '200') {
        return PersonalAddressListRes.fromJson(resData['data']);
      } else {
        throw Exception(
          resData['errorMsg'] ?? 'Failed to fetching address detail',
        );
      }
    } catch (e) {
      AppLogger.d("getAddressDetail error: $e");
      rethrow;
    }
  }

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

  /// Home page account total assets
  static Future<AccountAssetRes> getHomeAsset([String? currency]) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/account/home_asset',
        data: {"currency": currency},
      );

      final resData = res.data;
      if (resData['data'] == null) {
        final empty = AccountAssetRes()
          ..totalAmount = '0.00'
          ..totalAmountCurrency = 'USDT'
          ..totalAsset = '0.00'
          ..totalAssetCurrency = currency ?? 'NGN'
          ..totalTbayAsset = '0'
          ..totalCardgoalAsset = '0'
          ..merchantStatus = '0';
        return empty;
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        resData['data'],
      );
      return AccountAssetRes.fromJson(data);
    } catch (e) {
      AppLogger.d("getHomeAsset error: $e");
      rethrow;
    }
  }

  static Future<AccountDetailAccountAndJourRes> getDetailAccountAndJour(
    String accountNumber,
    String currency,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/account/detail_account_and_jour',
        data: {'accountNumber': accountNumber, 'currency': currency},
      );

      var data = res.data['data'];
      if (data != null && data is Map<String, dynamic>) {
        final fields = [
          'totalAmount',
          'usableAmount',
          'frozenAmount',
          'totalAmountUsdt',
          'totalAsset',
        ];
        for (var field in fields) {
          if (data[field] is num) {
            data[field] = data[field].toString();
          }
        }
      }

      return AccountDetailAccountAndJourRes.fromJson(data);
    } catch (e) {
      AppLogger.d("getDetailAccountAndJour error: $e");
      rethrow;
    }
  }

  // /// 📝TODO
  static Future<JourFrontDetail> getJourDetail(String id) async {
    try {
      final res = await ApiClient.dio.post('/core/v1/jour/detail_front/$id');
      AppLogger.d("Jour Detail Response: ${res.data}");
      return JourFrontDetail.fromJson(res.data['data']);
    } catch (e) {
      AppLogger.d("getJourDetail error: $e");
      rethrow;
    }
  }

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
}
