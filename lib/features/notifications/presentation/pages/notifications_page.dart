import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/sms_model.dart';
import 'package:BitOwi/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:BitOwi/features/notifications/presentation/widgets/confirm_read_dialog.dart';
import 'package:BitOwi/utils/string_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int tabIndex = 0;
  late EasyRefreshController _controller;
  List<Sms> list = [];
  int pageNum = 1;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    getList(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      await getList(true);
      if (!mounted) return;
    } catch (e) {
      print("Refresh error: $e");
    }
    _controller.finishRefresh();
    _controller.resetFooter();
  }

  Future<void> onLoad() async {
    try {
      await getList();
      if (!mounted) return;
    } catch (e) {
      print("Load error: $e");
    }
    _controller.finishLoad(
      isEnd ? IndicatorResult.noMore : IndicatorResult.success,
    );
  }

  Future<void> getList([bool isRefresh = false]) async {
    try {
      if (isRefresh) {
        pageNum = 1;
      } else if (isEnd) {
        return;
      }

      final res = await CommonApi.getSmsPageByType(
        pageNum: pageNum,
        pageSize: 10,
        type: tabIndex == 0 ? "1" : "2", // 1 Announcements, 2 Notifications
      );

      final List<dynamic> dataList = res['data']['list'] ?? [];
      final List<Sms> fetchedList = dataList
          .map((e) => Sms.fromJson(e))
          .toList();

      final int total = res['data']['total'] ?? 0;
      final int pages = res['data']['pages'] ?? 1;

      setState(() {
        if (isRefresh) {
          list = fetchedList;
          isEnd = false;
        } else {
          list.addAll(fetchedList);
        }

        if (fetchedList.isEmpty || list.length >= total) {
          isEnd = true;
        } else {
          isEnd = false;
        }
        pageNum++;
      });
    } catch (e) {
      print("Get list error: $e");
      setState(() {
        if (isRefresh) isEnd = true;
      });
    }
  }

  void onTabChange(int index) {
    if (index != tabIndex) {
      setState(() {
        tabIndex = index;
        list.clear();
        isEnd = false;
      });
      _controller.callRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: _buildTabBar(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmReadDialog(
                  onConfirm: () async {
                    try {
                      await CommonApi.readAllNotice();
                      onRefresh();
                    } catch (e) {
                      print("Read all error: $e");
                    }
                  },
                ),
              );
            },
            icon: const Icon(Icons.cleaning_services, color: Color(0xFF151E2F)),
          ),
        ],
      ),
      body: EasyRefresh(
        controller: _controller,
        onRefresh: onRefresh,
        onLoad: onLoad,
        child: list.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildNotificationItem(list[index]);
                },
              ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 32,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabItem("Announcements", 0),
            const SizedBox(width: 12),
            _buildTabItem("Notifications", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = tabIndex == index;
    return GestureDetector(
      onTap: () => onTabChange(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF151E2F)
                  : const Color(0xFF83869D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 100,
              color: Color(0xFFBEBEC0),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: Color(0xFFBEBEC0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Sms item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          item.isRead = '1';
        });
        Get.to(() => NotificationDetailPage(id: item.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF151E2F),
                  ),
                ),
              ),
              if (item.isRead == '0')
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xffE74C3C),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            StringUtils.removeAllHtmlTags(item.content),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              color: Color(0xFF717F9A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.createDatetime,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              color: Color(0xFFB0B4C3),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
