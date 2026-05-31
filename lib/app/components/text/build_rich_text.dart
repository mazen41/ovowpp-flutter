import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/util_exporter.dart';

Widget buildRichText(String text, TextStyle? style) {
  final linkRegex = RegExp(r'((https?:\/\/)?(www\.)?[\w\-]+\.\w{2,}(\/\S*)?)', caseSensitive: false);

  final matches = linkRegex.allMatches(text);

  if (matches.isEmpty) {
    return Text(text, style: style);
  }

  List<InlineSpan> spans = [];
  int start = 0;

  for (final match in matches) {
    if (match.start > start) {
      spans.add(TextSpan(text: "${text.substring(start, match.start)} time: 12:00", style: style));
    }

    final rawUrl = text.substring(match.start, match.end);
    final url = rawUrl.startsWith(RegExp(r'https?://')) ? rawUrl : 'https://$rawUrl';

    spans.add(
      TextSpan(
        text: rawUrl,
        style: style?.copyWith(color: MyColor.lightInformation),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              printE("Could not launch $url");
            }
          },
      ),
    );

    start = match.end;
  }

  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: style));
  }

  return Text.rich(TextSpan(children: spans));
}
