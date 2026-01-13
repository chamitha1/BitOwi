import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/models/article_type.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> with TickerProviderStateMixin {
  List<ArticleType> helpCententList = [];
  late EasyRefreshController _controller;

  bool isLoading = false;

  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(controlFinishRefresh: true);
    onRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true;
    });
    try {
      final list = await CommonApi.getArticleList("0");
      if (!mounted) return;

      setState(() {
        helpCententList = list;
        expandedSectionIndex = -1;
        expandedQuestionIndex.clear();
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } finally {
      _controller.finishRefresh();
    }
  }

  int expandedSectionIndex = -1;
  final Map<int, int> expandedQuestionIndex = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Help", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: EasyRefresh(
          controller: _controller,
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: SoftCircularLoader(),
                  ),
                )
              else
                ...List.generate(
                  helpCententList.length,
                  (index) => _buildSectionCard(
                    section: helpCententList[index],
                    sectionIndex: index,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28A6FF), Color(0xFF1D5DE5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello, ${userController.user.value?.nickname ?? userController.userName.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Inter',
                      letterSpacing: -0.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Help Center',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SvgPicture.asset(
            "assets/icons/public/help_question.svg",
            height: 105,
            width: 100,
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ArticleType section,
    required int sectionIndex,
  }) {
    final isExpanded = expandedSectionIndex == sectionIndex;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Section Title
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                expandedSectionIndex = isExpanded ? -1 : sectionIndex;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _sectionIcon(iconUrl: section.icon ?? ''),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.p2Medium(section.name),
                        const SizedBox(height: 2),
                        AppText.p3Regular(
                          "${section.articleList.length.toString()} Questions",
                          color: Color(0xFF717F9A),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 500),
                    turns: isExpanded ? -0.25 : 0,
                    child: SvgPicture.asset(
                      "assets/icons/merchant_details/arrow_down_keyboard.svg",
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Questions Section
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: isExpanded
                ? _buildQuestions(section, sectionIndex)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions(ArticleType section, int sectionIndex) {
    return Column(
      children: List.generate(section.articleList.length, (qIndex) {
        final isOpen = expandedQuestionIndex[sectionIndex] == qIndex;

        return Column(
          children: [
            const Divider(height: 1, color: Color(0xFFECEFF5)),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              // Question Title
              title: AppText.p2Medium(section.articleList[qIndex].title),
              trailing: AnimatedRotation(
                duration: const Duration(milliseconds: 500),
                turns: isOpen ? -0.25 : 0,
                child: SvgPicture.asset(
                  "assets/icons/merchant_details/arrow_down_keyboard.svg",
                ),
              ),
              onTap: () {
                setState(() {
                  expandedQuestionIndex[sectionIndex] = isOpen ? -1 : qIndex;
                });
              },
            ),
            // Answer Section
            SizedBox(
              width: double.infinity,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: isOpen
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
                        child: HtmlWidget(
                          cleanHtml(section.articleList[qIndex].content ?? ''),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF151E2F),
                            fontFamily: 'Inter',
                          ),
                          customWidgetBuilder: (element) {
                            if (element.localName == 'img') {
                              final src = element.attributes['src'];
                              if (src == null) return null;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Image.network(
                                  src,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              );
                            }
                            return null;
                          },
                          customStylesBuilder: (element) {
                            switch (element.localName) {
                              case 'p':
                                return {'margin-bottom': '8px'};

                              case 'br':
                                return {'margin-bottom': '4px'};

                              case 'strong':
                              case 'b':
                                return {'font-weight': '600'};

                              case 'table':
                                return {
                                  'width': '100%',
                                  'margin-bottom': '12px',
                                };

                              case 'td':
                              case 'th':
                                return {
                                  'padding': '4px 0',
                                  'vertical-align': 'top',
                                };

                              case 'a':
                                return {
                                  'color': '#1D5DE5',
                                  'text-decoration': 'underline',
                                  'font-weight': '500',
                                };

                              case 'span':
                                return {'font-weight': '400'};
                            }
                            return null;
                          },
                          onTapUrl: (url) async {
                            debugPrint('Tapped link: $url');

                            if (url.startsWith('mailto:')) {
                              // Optional: open email app
                              // await launchUrl(Uri.parse(url));
                              return true;
                            }

                            if (url.startsWith('http')) {
                              // Optional: open browser
                              // await launchUrl(
                              //   Uri.parse(url),
                              //   mode: LaunchMode.externalApplication,
                              // );
                              return true;
                            }

                            return false;
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _sectionIcon({required String iconUrl}) {
    return CommonImage(iconUrl, width: 40, height: 40);
  }
}

String cleanHtml(String rawHtml) {
  return rawHtml
      .replaceAll(RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<html[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'</html>', caseSensitive: false), '')
      .replaceAll(
        RegExp(r'<head[^>]*>.*?</head>', caseSensitive: false, dotAll: true),
        '',
      )
      .replaceAll(RegExp(r'<body[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'</body>', caseSensitive: false), '')
      .replaceAll(RegExp(r'height:\s*[\d.]+px;?', caseSensitive: false), '')
      .replaceAll(RegExp(r'width:\s*[\d.]+%;?', caseSensitive: false), '')
      .replaceAll(RegExp(r'width:\s*[\d.]+px;?', caseSensitive: false), '')
      .replaceAll(
        RegExp(r'<p[^>]*>(&nbsp;|\s*)<\/p>', caseSensitive: false),
        '',
      )
      .replaceAll(
        RegExp(
          r'<tr[^>]*>\s*<td[^>]*>(&nbsp;|\s*)<\/td>\s*<\/tr>',
          caseSensitive: false,
        ),
        '',
      )
      .trim();
}

class SectionIconConfig {
  final String svgPath;
  final Color backgroundColor;

  const SectionIconConfig({
    required this.svgPath,
    required this.backgroundColor,
  });
}
