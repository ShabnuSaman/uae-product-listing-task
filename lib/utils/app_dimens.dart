import 'package:flutter/material.dart';

abstract final class AppDimens {
  // ── Spacing scale ──────────────────────────────────────────────────────────
  static const double sp3 = 3.0;
  static const double sp4 = 4.0;
  static const double sp6 = 6.0;
  static const double sp8 = 8.0;
  static const double sp10 = 10.0;
  static const double sp12 = 12.0;
  static const double sp16 = 16.0;
  static const double sp20 = 20.0;
  static const double sp24 = 24.0;
  static const double sp32 = 32.0;
  static const double sp48 = 48.0;

  // ── Border radii ───────────────────────────────────────────────────────────
  static const double cardRadius = 12.0;
  static const double chipRadius = 20.0;
  static const double searchRadius = 12.0;

  // ── EdgeInsets presets ─────────────────────────────────────────────────────
  static const EdgeInsets gridPadding =
      EdgeInsets.fromLTRB(sp16, sp16, sp16, 0);
  static const EdgeInsets searchBarPadding =
      EdgeInsets.fromLTRB(sp16, sp12, sp16, sp4);
  static const EdgeInsets categoryBarPadding =
      EdgeInsets.symmetric(horizontal: sp16, vertical: sp6);
  static const EdgeInsets cardContentPadding =
      EdgeInsets.fromLTRB(sp10, sp8, sp10, sp10);
  static const EdgeInsets detailContentPadding = EdgeInsets.all(sp20);
  static const EdgeInsets imageCardPadding = EdgeInsets.all(sp12);
  static const EdgeInsets heroImagePadding = EdgeInsets.all(sp32);
  static const EdgeInsets errorPadding = EdgeInsets.all(sp32);

  // ── Component heights ──────────────────────────────────────────────────────
  static const double categoryBarHeight = 44.0;
  static const double productImageHeight = 100.0;
  static const double heroImageHeight = 300.0;

  // ── Splash ─────────────────────────────────────────────────────────────────
  static const double splashIconContainerSize = 96.0;
  static const double splashIconSize = 52.0;
  static const double splashTitleSize = 28.0;
  static const double splashSubtitleSize = 14.0;

  // ── Grid ───────────────────────────────────────────────────────────────────
  static const int gridCrossAxisCount = 2;
  static const double gridSpacing = 12.0;
  static const double gridChildAspectRatio = 0.68;
  static const int shimmerItemCount = 6;

  // ── Icon sizes ─────────────────────────────────────────────────────────────
  static const double starIconCard = 14.0;
  static const double starIconDetail = 20.0;
  static const double emptyStateIconSize = 72.0;
  static const double brokenImageCard = 36.0;
  static const double brokenImageDetail = 60.0;
}
