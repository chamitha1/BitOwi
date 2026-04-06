import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/storage/storage_service.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  bool _initialized = false;
  Uri? _pendingUri;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _pendingUri = initialUri;
        debugPrint('Initial deep link: $initialUri');
      }
    } catch (e, st) {
      debugPrint('DeepLink initial link error: $e\n$st');
    }

    _sub = _appLinks.uriLinkStream.listen(
      (uri) async {
        final isLoggedIn = await _isLoggedIn();
        await handleIncomingLink(uri, isLoggedIn: isLoggedIn);
      },
      onError: (Object e, StackTrace st) {
        debugPrint('DeepLink stream error: $e\n$st');
      },
    );
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  Future<bool> _isLoggedIn() async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) return false;
    return StorageService.isTokenValid();
  }

  Future<void> routeAppOnLaunch() async {
    final isLoggedIn = await _isLoggedIn();

    if (isLoggedIn) {
      final handled = await handlePendingLink(isLoggedIn: true);
      if (!handled) {
        Get.offAllNamed(Routes.home);
      }
      return;
    }

    Get.offAllNamed(Routes.login);
  }

  Future<void> onLoginSuccess() async {
    final handled = await handlePendingLink(isLoggedIn: true);
    if (!handled) {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<bool> handlePendingLink({required bool isLoggedIn}) async {
    final uri = _pendingUri;
    if (uri == null) return false;

    _pendingUri = null;
    return handleIncomingLink(uri, isLoggedIn: isLoggedIn);
  }

  Future<bool> handleIncomingLink(
    Uri uri, {
    required bool isLoggedIn,
  }) async {
    final route = _mapUriToRoute(uri);

    debugPrint('DeepLink received: $uri');
    debugPrint('Mapped route: $route');

    if (!_canNavigateNow()) {
      _pendingUri = uri;
      return false;
    }

    if (!isLoggedIn) {
      _pendingUri = uri;
      Get.offAllNamed(Routes.login);
      return true;
    }

    if (route == null || route.trim().isEmpty) {
      Get.offAllNamed(Routes.home);
      return false;
    }

    try {
      Get.offAllNamed(route);
      return true;
    } catch (e, st) {
      debugPrint('DeepLink navigation failed: $e\n$st');
      Get.offAllNamed(Routes.home);
      return false;
    }
  }

  bool _canNavigateNow() {
    return Get.key.currentContext != null;
  }

  String? _mapUriToRoute(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    final pathSegments = uri.pathSegments.where((e) => e.isNotEmpty).toList();

    String withQuery(String route) {
      if (uri.queryParameters.isEmpty) return route;
      final query = uri.queryParameters.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
          )
          .join('&');
      return '$route?$query';
    }

    String? resolvePath(List<String> segments) {
      if (segments.isEmpty) return null;

      final normalized = segments
          .map((segment) => segment.trim().toLowerCase())
          .where((segment) => segment.isNotEmpty)
          .toList();

      if (normalized.isEmpty) return null;

      final first = normalized.first;

      switch (first) {
        case 'home':
        case 'homescreen':
          return withQuery(Routes.homeAlias);

        case 'withdraw':
        case 'withdrawal':
          return withQuery(Routes.withdrawAlias);

        case 'deposit':
          return withQuery(Routes.deposit);

        case 'changepassword':
        case 'change-password':
          return withQuery(Routes.changePassword);

        case 'changeemail':
        case 'change-email':
          return withQuery(Routes.changeEmail);

        case 'profile':
          return withQuery(Routes.profile);

        case 'postads':
        case 'post-ads':
        case 'myadspage':
          return withQuery(Routes.postAdsAlias);

        case 'order':
          if (segments.length >= 2) {
            return withQuery('${Routes.orderDetailPage}/${segments[1]}');
          }
          final orderId = uri.queryParameters['orderId'];
          if (orderId != null && orderId.isNotEmpty) {
            return withQuery('${Routes.orderDetailPage}/$orderId');
          }
          return null;

        default:
          final orderId = uri.queryParameters['orderId'];
          if (orderId != null && orderId.isNotEmpty) {
            return withQuery('${Routes.orderDetailPage}/$orderId');
          }
          return null;
      }
    }

    if (scheme == 'bitowi') {
      final combinedSegments = <String>[];
      if (host.isNotEmpty) {
        combinedSegments.add(host);
      }
      combinedSegments.addAll(pathSegments);
      return resolvePath(combinedSegments);
    }

    if (scheme == 'https' || scheme == 'http') {
      const supportedHosts = {
        'm.bitowi.com',
        'm-test.bitowi.com',
        'www.bitowi.com',
        'bitowi.com',
        'localhost',
      };

      if (supportedHosts.contains(host)) {
        return resolvePath(pathSegments);
      }
    }

    return null;
  }
}
