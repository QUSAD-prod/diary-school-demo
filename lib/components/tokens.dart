import 'package:flutter/material.dart';

/// Дизайн-токены VKUI 8 (@vkontakte/vkui-tokens 4.96).
///
/// Цвета — темы vkIOS / vkIOSDark (они же используются VKUI на Android,
/// у vkBase отличаются только размеры). Размеры зависят от платформы.
@immutable
class VKTheme extends ThemeExtension<VKTheme> {
  const VKTheme._({
    required this.colors,
    required this.text,
    required this.isIOS,
  });

  factory VKTheme.build(Brightness brightness, TargetPlatform platform) {
    final isIOS =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    return VKTheme._(
      colors: brightness == Brightness.dark ? VKColors.dark : VKColors.light,
      text: VKTypography(isIOS: isIOS),
      isIOS: isIOS,
    );
  }

  final VKColors colors;
  final VKTypography text;
  final bool isIOS;

  // sizeBorderRadius
  double get borderRadius => isIOS ? 10 : 8;
  // sizeBorderRadiusPaper
  double get borderRadiusPaper => 12;
  // sizeBasePaddingHorizontal
  double get paddingHorizontal => isIOS ? 12 : 16;
  // sizePanelHeaderHeight
  double get panelHeaderHeight => isIOS ? 52 : 56;
  // sizeFieldHeight
  double get fieldHeight => 44;
  // sizeCellHeight
  double get cellHeight => 48;
  // --vkui_internal--tabbar_height
  double get tabbarHeight => 48;
  // animationEasingPlatform
  Curve get easing => isIOS
      ? const Cubic(0.36, 0.66, 0.04, 1)
      : const Cubic(0.4, 0, 0.2, 1);

  /// Толщина обводки `--vkui--size_border--regular`: один физический пиксель.
  static double hairline(BuildContext context) =>
      1 / MediaQuery.devicePixelRatioOf(context);

  static VKTheme of(BuildContext context) =>
      Theme.of(context).extension<VKTheme>()!;

  @override
  VKTheme copyWith() => this;

  @override
  VKTheme lerp(VKTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

extension VKThemeContext on BuildContext {
  VKTheme get vk => VKTheme.of(this);
  VKColors get colors => VKTheme.of(this).colors;
}

@immutable
class VKColors {
  const VKColors({
    required this.backgroundAccent,
    required this.backgroundAccentThemed,
    required this.background,
    required this.backgroundContent,
    required this.backgroundContentInverse,
    required this.backgroundSecondary,
    required this.backgroundSecondaryAlpha,
    required this.backgroundTertiary,
    required this.backgroundContrastThemed,
    required this.backgroundModal,
    required this.backgroundPositive,
    required this.backgroundNegative,
    required this.backgroundNegativeTint,
    required this.backgroundInfoTint,
    required this.headerBackground,
    required this.fieldBackground,
    required this.fieldBorderAlpha,
    required this.textPrimary,
    required this.textSecondary,
    required this.textSubhead,
    required this.textTertiary,
    required this.textAccent,
    required this.textAccentThemed,
    required this.textContrast,
    required this.textContrastThemed,
    required this.textPositive,
    required this.textNegative,
    required this.iconAccent,
    required this.iconAccentThemed,
    required this.iconPrimary,
    required this.iconMedium,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconContrast,
    required this.strokeAccent,
    required this.strokeAccentThemed,
    required this.strokePositive,
    required this.strokeNegative,
    required this.separatorPrimary,
    required this.separatorPrimaryAlpha,
    required this.imageBorderAlpha,
    required this.transparentActive,
    required this.segmentedControl,
    required this.tabbarTextInactive,
    required this.overlayPrimary,
    required this.avatarOverlay,
    required this.accentBlue,
    required this.accentGreen,
    required this.accentOrange,
    required this.accentPurple,
    required this.accentRaspberryPink,
    required this.accentViolet,
    required this.elevation2,
    required this.elevation3,
    required this.elevation4,
  });

  final Color backgroundAccent;
  final Color backgroundAccentThemed;
  final Color background;
  final Color backgroundContent;
  final Color backgroundContentInverse;
  final Color backgroundSecondary;
  final Color backgroundSecondaryAlpha;
  final Color backgroundTertiary;
  final Color backgroundContrastThemed;
  final Color backgroundModal;
  final Color backgroundPositive;
  final Color backgroundNegative;
  final Color backgroundNegativeTint;
  final Color backgroundInfoTint;
  final Color headerBackground;
  final Color fieldBackground;
  final Color fieldBorderAlpha;
  final Color textPrimary;
  final Color textSecondary;
  final Color textSubhead;
  final Color textTertiary;
  final Color textAccent;
  final Color textAccentThemed;
  final Color textContrast;
  final Color textContrastThemed;
  final Color textPositive;
  final Color textNegative;
  final Color iconAccent;
  final Color iconAccentThemed;
  final Color iconPrimary;
  final Color iconMedium;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconContrast;
  final Color strokeAccent;
  final Color strokeAccentThemed;
  final Color strokePositive;
  final Color strokeNegative;
  final Color separatorPrimary;
  final Color separatorPrimaryAlpha;
  final Color imageBorderAlpha;

  /// `colorTransparent` в состоянии active — подсветка нажатия.
  final Color transparentActive;
  final Color segmentedControl;
  final Color tabbarTextInactive;
  final Color overlayPrimary;
  final Color avatarOverlay;
  final Color accentBlue;
  final Color accentGreen;
  final Color accentOrange;
  final Color accentPurple;
  final Color accentRaspberryPink;
  final Color accentViolet;
  final List<BoxShadow> elevation2;
  final List<BoxShadow> elevation3;
  final List<BoxShadow> elevation4;

  static const light = VKColors(
    backgroundAccent: Color(0xFF2688EB),
    backgroundAccentThemed: Color(0xFF2688EB),
    background: Color(0xFFEBEDF0),
    backgroundContent: Color(0xFFFFFFFF),
    backgroundContentInverse: Color(0xFF19191A),
    backgroundSecondary: Color(0xFFF5F5F5),
    backgroundSecondaryAlpha: Color(0x0A000000),
    backgroundTertiary: Color(0xFFF9F9F9),
    backgroundContrastThemed: Color(0xFFFFFFFF),
    backgroundModal: Color(0xFFFFFFFF),
    backgroundPositive: Color(0xFF4BB34B),
    backgroundNegative: Color(0xFFE64646),
    backgroundNegativeTint: Color(0xFFFFE9E9),
    backgroundInfoTint: Color(0xFFDEEEFF),
    headerBackground: Color(0xFFFFFFFF),
    fieldBackground: Color(0xFFF2F3F5),
    fieldBorderAlpha: Color(0x1F000000),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF818C99),
    textSubhead: Color(0xFF6D7885),
    textTertiary: Color(0xFF99A2AD),
    textAccent: Color(0xFF2688EB),
    textAccentThemed: Color(0xFF2688EB),
    textContrast: Color(0xFFFFFFFF),
    textContrastThemed: Color(0xFFFFFFFF),
    textPositive: Color(0xFF4BB34B),
    textNegative: Color(0xFFE64646),
    iconAccent: Color(0xFF2688EB),
    iconAccentThemed: Color(0xFF2688EB),
    iconPrimary: Color(0xFF2C2D2E),
    iconMedium: Color(0xFF818C99),
    iconSecondary: Color(0xFF99A2AD),
    iconTertiary: Color(0xFFB8C1CC),
    iconContrast: Color(0xFFFFFFFF),
    strokeAccent: Color(0xFF2688EB),
    strokeAccentThemed: Color(0xFF2688EB),
    strokePositive: Color(0xFF4BB34B),
    strokeNegative: Color(0xFFE64646),
    separatorPrimary: Color(0xFFD7D8D9),
    separatorPrimaryAlpha: Color(0x1F000000),
    imageBorderAlpha: Color(0x14000000),
    transparentActive: Color(0x1400103D),
    segmentedControl: Color(0xFFFFFFFF),
    tabbarTextInactive: Color(0xFF99A2AD),
    overlayPrimary: Color(0x66000000),
    avatarOverlay: Color(0x99000000),
    accentBlue: Color(0xFF2688EB),
    accentGreen: Color(0xFF4BB34B),
    accentOrange: Color(0xFFFFA000),
    accentPurple: Color(0xFF735CE6),
    accentRaspberryPink: Color(0xFFE03FAB),
    accentViolet: Color(0xFF792EC0),
    elevation2: [
      BoxShadow(color: Color(0x0A000000), offset: Offset(0, 4), blurRadius: 8),
      BoxShadow(color: Color(0x0F000000), blurRadius: 4),
    ],
    elevation3: [
      BoxShadow(color: Color(0x14000000), blurRadius: 2),
      BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 16),
    ],
    elevation4: [
      BoxShadow(color: Color(0x1F000000), blurRadius: 8),
      BoxShadow(color: Color(0x29000000), offset: Offset(0, 16), blurRadius: 16),
    ],
  );

  static const dark = VKColors(
    backgroundAccent: Color(0xFF529EF4),
    backgroundAccentThemed: Color(0xFFFFFFFF),
    background: Color(0xFF0A0A0A),
    backgroundContent: Color(0xFF19191A),
    backgroundContentInverse: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFF232324),
    backgroundSecondaryAlpha: Color(0x1AFFFFFF),
    backgroundTertiary: Color(0xFF202021),
    backgroundContrastThemed: Color(0xFF2C2D2E),
    backgroundModal: Color(0xFF1C1D1E),
    backgroundPositive: Color(0xFF4BB34B),
    backgroundNegative: Color(0xFFFF5C5C),
    backgroundNegativeTint: Color(0xFF522E2E),
    backgroundInfoTint: Color(0xFF1C3954),
    headerBackground: Color(0xFF19191A),
    fieldBackground: Color(0xFF232324),
    fieldBorderAlpha: Color(0x1FFFFFFF),
    textPrimary: Color(0xFFE1E3E6),
    textSecondary: Color(0xFF76787A),
    textSubhead: Color(0xFF969A9F),
    textTertiary: Color(0xFF5D5F61),
    textAccent: Color(0xFF529EF4),
    textAccentThemed: Color(0xFFFFFFFF),
    textContrast: Color(0xFFFFFFFF),
    textContrastThemed: Color(0xFF000000),
    textPositive: Color(0xFF4BB34B),
    textNegative: Color(0xFFFF5C5C),
    iconAccent: Color(0xFF529EF4),
    iconAccentThemed: Color(0xFFFFFFFF),
    iconPrimary: Color(0xFFE1E3E6),
    iconMedium: Color(0xFFB0B1B6),
    iconSecondary: Color(0xFF76787A),
    iconTertiary: Color(0xFF5D5F61),
    iconContrast: Color(0xFFFFFFFF),
    strokeAccent: Color(0xFF529EF4),
    strokeAccentThemed: Color(0xFFFFFFFF),
    strokePositive: Color(0xFF4BB34B),
    strokeNegative: Color(0xFFFF5C5C),
    separatorPrimary: Color(0xFF363738),
    separatorPrimaryAlpha: Color(0x1FFFFFFF),
    imageBorderAlpha: Color(0x14FFFFFF),
    transparentActive: Color(0x14FFFFFF),
    segmentedControl: Color(0xFF626364),
    tabbarTextInactive: Color(0xFF76787A),
    overlayPrimary: Color(0x66000000),
    avatarOverlay: Color(0x99000000),
    accentBlue: Color(0xFF71AAEB),
    accentGreen: Color(0xFF4BB34B),
    accentOrange: Color(0xFFFFA000),
    accentPurple: Color(0xFF9985FF),
    accentRaspberryPink: Color(0xFFF060C0),
    accentViolet: Color(0xFFA94FFF),
    elevation2: [
      BoxShadow(color: Color(0x26000000), offset: Offset(0, 4), blurRadius: 8),
      BoxShadow(color: Color(0x33000000), blurRadius: 4),
    ],
    elevation3: [
      BoxShadow(color: Color(0x4D000000), blurRadius: 2),
      BoxShadow(color: Color(0x4D000000), offset: Offset(0, 4), blurRadius: 16),
    ],
    elevation4: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 8),
      BoxShadow(color: Color(0x33000000), offset: Offset(0, 16), blurRadius: 16),
    ],
  );
}

/// Типографика VKUI (плотность regular).
///
/// Шрифт системный, как и в VKUI: SF Pro на iOS, Roboto на Android.
/// На iOS добавляем трекинг SF Pro, который браузер применяет сам,
/// а движок Flutter — нет.
@immutable
class VKTypography {
  VKTypography({required this.isIOS})
      : title1 = _style(isIOS, 24, 28, FontWeight.w600),
        title2 = _style(isIOS, 20, 24, FontWeight.w500),
        title3 = _style(isIOS, 17, 22, FontWeight.w600),
        headline1 = _style(isIOS, 16, 20, FontWeight.w500),
        headline2 = _style(isIOS, 15, 20, FontWeight.w500),
        text = _style(isIOS, 16, 20, FontWeight.w400),
        paragraph = _style(isIOS, 15, 20, FontWeight.w400),
        subhead = _style(isIOS, 14, 18, FontWeight.w400),
        footnote = _style(isIOS, 13, 16, FontWeight.w400),
        footnoteCaps = _style(isIOS, 13, 16, FontWeight.w600),
        caption1 = _style(isIOS, 12, 14, FontWeight.w400),
        caption2 = _style(isIOS, 11, 14, FontWeight.w400),
        tabbarLabel = _style(isIOS, 10, 12, FontWeight.w500),
        panelHeader = _style(isIOS, isIOS ? 21 : 23, 28, FontWeight.w500);

  final bool isIOS;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle text;
  final TextStyle paragraph;
  final TextStyle subhead;
  final TextStyle footnote;
  final TextStyle footnoteCaps;
  final TextStyle caption1;
  final TextStyle caption2;
  final TextStyle tabbarLabel;
  final TextStyle panelHeader;

  // Трекинг SF Pro из Apple HIG, pt -> pt
  static const _sfTracking = <int, double>{
    10: 0.12, 11: 0.06, 12: 0, 13: -0.08, 14: -0.15, 15: -0.23, 16: -0.31,
    17: -0.43, 18: -0.44, 19: -0.45, 20: -0.45, 21: -0.36, 22: -0.26,
    23: -0.1, 24: 0.07,
  };

  static TextStyle _style(
    bool isIOS,
    double size,
    double lineHeight,
    FontWeight weight,
  ) {
    return TextStyle(
      fontFamily: isIOS
          ? (size >= 20 ? 'CupertinoSystemDisplay' : 'CupertinoSystemText')
          : null,
      fontSize: size,
      height: lineHeight / size,
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: weight,
      letterSpacing: isIOS ? _sfTracking[size.round()] ?? 0 : 0,
    );
  }
}
