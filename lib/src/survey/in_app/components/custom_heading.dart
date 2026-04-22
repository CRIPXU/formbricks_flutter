import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../formbricks_flutter.dart';
import '../../../utils/helper.dart';
import '../../../utils/theme_manager.dart';
import 'formbricks_video_player.dart';

class CustomHeading extends StatelessWidget {
  final Question question;
  final bool required;

  const CustomHeading({
    super.key,
    required this.question,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.imageUrl?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: question.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              onTap: () => showFullScreenImage(context, question.imageUrl!),
            ),
          )
        else if (question.videoUrl?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                theme.extension<MyCustomTheme>()?.styleRoundness ?? 8.0,
              ),
              child: FormbricksVideoPlayer(videoUrl: question.videoUrl!),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                stripHtml(translate(question.headline, context)),
                style: theme.textTheme.headlineMedium,
              ),
            ),
            if (!required)
              Builder(
                builder: (context) {
                  final customTheme = theme.extension<MyCustomTheme>();
                  final headlineStyling = customTheme?.headlineStyling;
                  final isDarkMode = customTheme?.isDarkMode ?? false;
                  
                  Color themedColor(Map<String, dynamic>? colorMap, {required Color fallback}) {
                    if (colorMap == null) return fallback;
                    final hex = isDarkMode && colorMap.containsKey('dark') ? colorMap['dark'] : colorMap['light'];
                    if (hex == null || hex.isEmpty) return fallback;
                    String h = hex.replaceFirst('#', '');
                    if (h.length == 6) h = 'FF$h';
                    return Color(int.tryParse('0x$h') ?? fallback.toARGB32());
                  }

                  final upperLabelColor = themedColor(headlineStyling?.upperLabelColor, fallback: theme.textTheme.titleMedium?.color ?? Colors.grey);

                  return Text(
                    AppLocalizations.of(context)!.optional,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: upperLabelColor,
                      fontSize: (headlineStyling?.upperLabelFontSize ?? 12).toDouble(),
                      fontWeight: headlineStyling?.upperLabelFontWeight == 'bold' ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }
              ),
          ],
        ),
        if (translate(question.subheader, context)?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              stripHtml(translate(question.subheader, context)),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
