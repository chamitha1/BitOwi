import 'dart:async';
import 'package:BitOwi/api/common_api.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';


class RichTextConfig extends StatefulWidget {
  final String title;
  final String configKey;
  final String configType;
  final String content;

  const RichTextConfig({
    super.key,
    required this.title,
    required this.configKey,
    required this.configType,
    this.content = '',
  });

  const RichTextConfig.content({
    super.key,
    required this.title,
    required this.content,
    this.configKey = '',
    this.configType = '',
  });

  @override
  _RichTextConfigState createState() => _RichTextConfigState();
}

class _RichTextConfigState extends State<RichTextConfig> {
  final Completer<String> configText = Completer<String>();

  @override
  void initState() {
    super.initState();
    if (widget.configKey.isNotEmpty && widget.configType.isNotEmpty) {
      getConfigText();
    } else {
      getContentText();
    }
  }

  Future<void> getConfigText() async {
    try {
      final res = await CommonApi.getConfig(
        type: widget.configType,
        key: widget.configKey,
      );
      final rawHtml = res.data[widget.configKey] ?? '';
      configText.complete(cleanHtml(rawHtml));
    } catch (e) {
      configText.completeError("");
    }
  }

  Future<void> getContentText() async {
    try {
      configText.complete(cleanHtml(widget.content));
    } catch (e) {
      configText.completeError("");
    }
  }

  String cleanHtml(String rawHtml) {
    // Remove unwanted full document tags if present
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
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarPro(title: Text(widget.title)),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: const Color(0xFFF6F9FF),
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<String>(
        future: configText.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint("Rendered HTML: ${snapshot.data}");
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: HtmlWidget(
                onLoadingBuilder: (context, element, loadingProgress) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1D5DE5),
                          ),
                        ),
                      );
                    },
                  );
                },
                snapshot.data ?? '',
                textStyle: TextStyle(
                  // color: customTheme.primaryText,
                  // color: Color(0xFF151E2F),
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontSize: 15,
                  fontFamily: 'SFPro',
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    // color: customTheme.downPriceColor,
                    // color: const Color(0xFFFF4D4F),
                    color: Theme.of(context).colorScheme.error,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(snapshot.error.toString()),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              // child: CircularProgressIndicator(
              //   strokeWidth: 2,
              //   color: Color(0xFF1D5DE5),
              // ),
              child: SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
