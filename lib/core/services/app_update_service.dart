import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionService {

  static Future<void> checkVersion(BuildContext context) async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ),
    );

    await remoteConfig.fetchAndActivate();

    final maintenance = remoteConfig.getBool("maintenance_mode");
    final minVersion = remoteConfig.getString("min_version");
    final latestVersion = remoteConfig.getString("latest_version");
    final updateUrl = remoteConfig.getString("update_url");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    if (maintenance) {
      _showMaintenanceDialog(context);
      return;
    }

    if (_isVersionLower(currentVersion, minVersion)) {
      _showForceUpdate(context, updateUrl);
      return;
    }

    if (_isVersionLower(currentVersion, latestVersion)) {
      _showOptionalUpdate(context, updateUrl);
    }
  }

  static bool _isVersionLower(String current, String remote) {
    List<int> currentParts =
        current.split('.').map(int.parse).toList();

    List<int> remoteParts =
        remote.split('.').map(int.parse).toList();

    for (int i = 0; i < remoteParts.length; i++) {
      if (currentParts[i] < remoteParts[i]) return true;
      if (currentParts[i] > remoteParts[i]) return false;
    }

    return false;
  }

  static void _showForceUpdate(BuildContext context, String url) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Required"),
        content: const Text(
            "A new version of the app is required to continue."),
        actions: [
          ElevatedButton(
            onPressed: () => _openStore(url),
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  static void _showOptionalUpdate(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Available"),
        content: const Text(
            "A new version of the app is available."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () => _openStore(url),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  static void _showMaintenanceDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Maintenance"),
        content: Text(
            "The system is currently under maintenance. Please try again later."),
      ),
    );
  }

  static Future<void> _openStore(String url) async {
    await launchUrl(Uri.parse(url));
  }
}