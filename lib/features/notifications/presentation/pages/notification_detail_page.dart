import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/sms_model.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationDetailPage extends StatefulWidget {
  final String id;
  const NotificationDetailPage({super.key, required this.id});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  var isLoading = true.obs;
  var detail = Rxn<Sms>();

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  void _fetchDetail() async {
    try {
      isLoading.value = true;
      final res = await CommonApi.getNoticeDetail(widget.id);
      detail.value = res;
    } catch (e) {
      AppLogger.d("Fetch notice detail error: $e");
    } finally {
      isLoading.value = false;
    }
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
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            detail.value?.title ?? "",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF151E2F),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (detail.value == null) {
          return const Center(child: Text("Details not found"));
        }

        final sms = detail.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sms.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF151E2F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sms.createDatetime,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFFB0B4C3),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEFF2F7)),
                const SizedBox(height: 16),
                Html(
                  data: sms.content,
                  style: {
                    "body": Style(
                      fontFamily: 'Inter',
                      fontSize: FontSize(14),
                      color: const Color(0xFF717F9A),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
