import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AplicationTheme {
  static ThemeData getTheme() {
    final TextTheme _textTheme = ThemeData.light().textTheme;
    const ColorScheme _colorScheme = ColorScheme(
      primary: Color(0xFF355C7D),
      primaryVariant: Color(0xFF6C5B7B),
      secondary: Color(0xFFC06C84),
      secondaryVariant: Color(0xFFF67280),
      surface: Colors.white,
      background: Colors.white,
      error: Color(0xFFBB0520),
      onBackground: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      brightness: Brightness.light,
    );

    final MaterialColor _primarySwatch =
        createPrimarySwatch(_colorScheme.primary);
    final Color? _primaryColorDark = _primarySwatch[800];
    final Color? _primaryColorLight = _primarySwatch[100];
    final Color? _secondaryHeaderColor = _primarySwatch[50];

    final Color _effectiveAppBarColor = _colorScheme.primary;
    final Brightness _appBarBrightness =
        ThemeData.estimateBrightnessForColor(_effectiveAppBarColor);

    final TargetPlatform _platform = defaultTargetPlatform;

    final Typography _typography = Typography.material2018(platform: _platform);

    final Color _selectedTabColor = _colorScheme.primary;

    final Color _unselectedTabColor = _colorScheme.onSurface.withOpacity(0.6);

    double _tooltipFontSize() {
      switch (_platform) {
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return 12;
        default:
          return 14;
      }
    }

    EdgeInsets _tooltipPadding() {
      switch (_platform) {
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return const EdgeInsets.fromLTRB(8, 3, 8, 4);
        default:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      }
    }

    final Color _dividerColor = _colorScheme.onSurface.withOpacity(0.12);
    final Color _disabledColor = Colors.black38;
    final Color _hintColor = Colors.black.withOpacity(0.6);

    return ThemeData(
      fontFamily: "Brandon Grotesque",
      typography: _typography,
      platform: _platform,
      brightness: _colorScheme.brightness,
      primaryColor: _colorScheme.primary,
      primaryColorBrightness:
          ThemeData.estimateBrightnessForColor(_colorScheme.primary),
      canvasColor: _colorScheme.background,
      scaffoldBackgroundColor: _colorScheme.background,
      cardColor: _colorScheme.surface,
      dividerColor: _dividerColor,
      backgroundColor: _colorScheme.background,
      disabledColor: _disabledColor,
      hintColor: _hintColor,
      dialogBackgroundColor: _colorScheme.surface,
      errorColor: _colorScheme.error,
      indicatorColor: _selectedTabColor,
      applyElevationOverlayColor: false,
      colorScheme: _colorScheme,
      toggleableActiveColor: _colorScheme.secondary,
      primaryColorDark: _primaryColorDark,
      primaryColorLight: _primaryColorLight,
      secondaryHeaderColor: _secondaryHeaderColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _effectiveAppBarColor,
        foregroundColor:
            _appBarBrightness == Brightness.dark ? Colors.white : Colors.black,
        iconTheme: _appBarBrightness == Brightness.dark
            ? const IconThemeData(color: Colors.white)
            : const IconThemeData(color: Colors.black87),
        actionsIconTheme: _appBarBrightness == Brightness.dark
            ? const IconThemeData(color: Colors.white)
            : const IconThemeData(color: Colors.black87),
        elevation: 0.2,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0x40000000),
          statusBarBrightness: _appBarBrightness,
          statusBarIconBrightness: _appBarBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: const Color(0xFF000000),
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: null,
        ),
      ),
      bottomAppBarColor: _colorScheme.background,
      bottomAppBarTheme: BottomAppBarTheme(
        color: _colorScheme.background,
        elevation: 0.2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: _colorScheme.primary.withOpacity(0.30),
        selectionHandleColor: _primaryColorDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _colorScheme.primary.withOpacity(0.035),
      ),
      buttonTheme: const ButtonThemeData(
        colorScheme: _colorScheme,
        textTheme: ButtonTextTheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: _colorScheme.primary,
        brightness: _colorScheme.brightness,
        labelStyle: _textTheme.bodyText1!,
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextTheme().button,
        labelColor: _selectedTabColor,
        unselectedLabelColor: _unselectedTabColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(
          color: _colorScheme.primary,
        ),
        selectedItemColor: _colorScheme.primary,
      ),
      tooltipTheme: TooltipThemeData(
        padding: _tooltipPadding(),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: _textTheme.bodyText2!.copyWith(
          inherit: false,
          color: Colors.white,
          fontSize: _tooltipFontSize(),
        ),
        decoration: BoxDecoration(
          color: const Color(0xF0FCFCFC),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: _dividerColor),
        ),
      ),
    );
  }

  static MaterialColor createPrimarySwatch(Color? color) {
    color ??= const Color(0xff6200ee);
    const List<double> strengths = <double>[
      0.05,
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.6,
      0.7,
      0.8,
      0.9
    ];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;
    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
