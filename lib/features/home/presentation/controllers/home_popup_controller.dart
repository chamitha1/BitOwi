import 'dart:collection';

import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/common_dynamic_popup.dart';
import 'package:get/get.dart';
import 'package:BitOwi/utils/app_logger.dart';

class HomePopupController extends GetxController {
  final RxList<CommonDynamicPopup> popups = <CommonDynamicPopup>[].obs;
  final Queue<CommonDynamicPopup> _popupQueue = Queue<CommonDynamicPopup>();
  final RxBool isLoading = false.obs;
  final RxBool isShowingPopup = false.obs;
  bool _requested = false;

  Future<void> loadHomePopups({bool force = false}) async {
    if (_requested && !force) return;

    isLoading.value = true;
    try {
      final items = await CommonApi.getDynamicPopupList(location: 0);
      AppLogger.d('Home popup count: ${items.length}');
      popups.assignAll(items);
      _popupQueue
        ..clear()
        ..addAll(items.where((item) => item.hasImage));
      _requested = true;
    } finally {
      isLoading.value = false;
    }
  }

  CommonDynamicPopup? nextPopup() {
    if (_popupQueue.isEmpty) return null;
    return _popupQueue.removeFirst();
  }

  Future<void> markHandled(CommonDynamicPopup popup) async {
    final id = popup.id;
    if (id == null) return;
    await CommonApi.checkDynamicPopup(id);
  }
}
