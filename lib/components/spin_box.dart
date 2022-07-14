import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SpinFormatter extends TextInputFormatter {
  SpinFormatter({required this.min, required this.max, required this.decimals});

  final double min;
  final double max;
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final input = newValue.text;
    if (input.isEmpty) {
      return newValue;
    }

    final minus = input.startsWith('-');
    if (minus && min >= 0) {
      return oldValue;
    }

    final plus = input.startsWith('+');
    if (plus && max < 0) {
      return oldValue;
    }

    if ((minus || plus) && input.length == 1) {
      return newValue;
    }

    if (decimals <= 0 && !_validateValue(int.tryParse(input))) {
      return oldValue;
    }

    if (decimals > 0 && !_validateValue(double.tryParse(input))) {
      return oldValue;
    }

    final dot = input.lastIndexOf('.');
    if (dot >= 0 && decimals < input.substring(dot + 1).length) {
      return oldValue;
    }

    return newValue;
  }

  bool _validateValue(num? value) {
    if (value == null) {
      return false;
    }

    if (value >= min && value <= max) {
      return true;
    }

    if (value >= 0) {
      return value <= max;
    } else {
      return value >= min;
    }
  }
}

abstract class BaseSpinBox extends StatefulWidget {
  const BaseSpinBox({Key? key}) : super(key: key);

  double get min;

  double get max;

  double get instruction;

  double get value;

  int get decimals;

  ValueChanged<double>? get onChanged;

  bool Function(double value)? get canChange;

  VoidCallback? get beforeChange;

  VoidCallback? get afterChange;

  bool get readOnly;
}

abstract class BaseSpinBoxState<T extends BaseSpinBox> extends State<T> {
  late double _value;
  late double _cachedValue;
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  double get value => _value;

  bool get hasFocus => _focusNode.hasFocus;

  FocusNode get focusNode => _focusNode;

  TextEditingController get controller => _controller;

  SpinFormatter get formatter => SpinFormatter(
      min: widget.min, max: widget.max, decimals: widget.decimals);

  static double _parseValue(String text) => double.tryParse(text) ?? 0;

  String _formatText(double value) => value.toStringAsFixed(widget.decimals);

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _cachedValue = widget.value;
    _controller = TextEditingController(text: _formatText(_value));
    _controller.addListener(_updateValue);
    _focusNode = FocusNode(onKey: (node, event) => _handleKey(event));
    _focusNode.addListener(() => setState(_selectAll));
    _focusNode.addListener(() {
      if (hasFocus) return;
      fixupValue(controller.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(RawKeyEvent event) {
    KeyEventResult result = KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (event is RawKeyUpEvent || setValue(value + widget.instruction)) {
        result = KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (event is RawKeyUpEvent || setValue(value - widget.instruction)) {
        result = KeyEventResult.handled;
      }
    }
    return result;
  }

  void _updateValue() {
    final v = _parseValue(_controller.text);
    if (v == _value) return;

    if (widget.canChange?.call(v) == false) {
      controller.text = _cachedValue.toStringAsFixed(widget.decimals);
      setState(() {
        _value = _cachedValue;
      });
      return;
    }

    setState(() => _value = v);
    widget.onChanged?.call(v);
  }

  bool setValue(double v) {
    final newValue = v.clamp(widget.min, widget.max).toDouble();
    if (newValue == value) return false;

    if (widget.canChange?.call(newValue) == false) return false;

    widget.beforeChange?.call();
    setState(() => _updateController(value, newValue));
    widget.afterChange?.call();

    return true;
  }

  void _updateController(double oldValue, double newValue) {
    final text = _formatText(newValue);
    final selection = _controller.selection;
    final oldOffset = value.isNegative ? 1 : 0;
    final newOffset = _parseValue(text).isNegative ? 1 : 0;

    _controller.value = _controller.value.copyWith(
      text: text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset - oldOffset + newOffset,
        extentOffset: selection.extentOffset - oldOffset + newOffset,
      ),
    );
  }

  @protected
  void fixupValue(String value) {
    final v = _parseValue(value);
    if (value.isEmpty || (v < widget.min || v > widget.max)) {
      _controller.text = _formatText(_cachedValue);
    } else {
      _cachedValue = _value;
    }
  }

  void _selectAll() {
    if (!_focusNode.hasFocus) return;
    _controller.selection = _controller.selection
        .copyWith(baseOffset: 0, extentOffset: _controller.text.length);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.removeListener(_updateValue);
      _value = _cachedValue = widget.value;
      _updateController(oldWidget.value, widget.value);
      _controller.addListener(_updateValue);
    }
  }
}

typedef SpinCallback = bool Function(double value);

class SpinGesture extends StatefulWidget {
  const SpinGesture({
    Key? key,
    this.enabled = true,
    required this.child,
    required this.instruction,
    this.acceleration,
    required this.interval,
    required this.onInstruction,
  }) : super(key: key);

  final bool enabled;
  final Widget child;
  final double instruction;
  final double? acceleration;
  final Duration interval;
  final SpinCallback onInstruction;

  @override
  SpinGestureState createState() => SpinGestureState();
}

class SpinGestureState extends State<SpinGesture> {
  Timer? timer;
  late double instruction;

  @override
  void initState() {
    super.initState();
    instruction = widget.instruction;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: widget.enabled ? (_) => startTimer() : null,
      onLongPressEnd: widget.enabled ? (_) => stopTimer() : null,
      child: widget.child,
    );
  }

  bool onInstruction() {
    if (!widget.enabled) return false;
    if (widget.acceleration != null) {
      instruction += widget.acceleration!;
    }
    return widget.onInstruction(instruction);
  }

  void startTimer() {
    if (timer != null) return;
    timer = Timer.periodic(widget.interval, (timer) {
      if (!onInstruction()) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    instruction = widget.instruction;
  }
}

class SpinButton extends StatelessWidget {
  const SpinButton({
    Key? key,
    required this.icon,
    this.color,
    this.enabled = true,
    required this.instruction,
    this.acceleration,
    required this.interval,
    required this.onInstruction,
  }) : super(key: key);

  final Icon icon;
  final Color? color;
  final bool enabled;
  final double instruction;
  final double? acceleration;
  final Duration interval;
  final SpinCallback onInstruction;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: SpinGesture(
        enabled: enabled,
        instruction: instruction,
        interval: interval,
        acceleration: acceleration,
        onInstruction: onInstruction,
        child: InkWell(
          onTap: enabled ? () => onInstruction(instruction) : null,
          child: icon,
        ),
      ),
    );
  }
}

class SpinBox extends BaseSpinBox {
  SpinBox({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.instruction = 1,
    this.value = 0,
    this.interval = const Duration(milliseconds: 100),
    this.acceleration,
    this.decimals = 0,
    bool? enabled,
    this.readOnly = false,
    this.autofocus = false,
    TextInputType? keyboardType,
    this.textInputAction,
    InputDecoration? decoration,
    this.validator,
    this.keyboardAppearance,
    Icon? incrementIcon,
    Icon? decrementIcon,
    this.showButtons = true,
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.textStyle,
    this.toolbarOptions,
    this.showCursor,
    this.cursorColor,
    this.enableInteractiveSelection = true,
    this.spacing = 8,
    this.onChanged,
    this.canChange,
    this.beforeChange,
    this.afterChange,
  })  : assert(min <= max),
        keyboardType = keyboardType ??
            TextInputType.numberWithOptions(
              signed: min < 0,
              decimal: decimals > 0,
            ),
        enabled = (enabled ?? true) && min < max,
        decoration = decoration ?? const InputDecoration(),
        incrementIcon = incrementIcon ?? const Icon(Icons.add),
        decrementIcon = decrementIcon ?? const Icon(Icons.remove),
        super(key: key) {
    assert(this.decoration.prefixIcon == null,
        'InputDecoration.prefixIcon is reserved for SpinBox decrement icon');
    assert(this.decoration.suffixIcon == null,
        'InputDecoration.suffixIcon is reserved for SpinBox increment icon');
  }

  @override
  final double min;

  @override
  final double max;

  @override
  final double instruction;

  @override
  final double value;

  @override
  final int decimals;

  final Duration interval;

  final double? acceleration;

  final double spacing;

  final Icon incrementIcon;

  final Icon decrementIcon;

  final bool showButtons;

  @override
  final ValueChanged<double>? onChanged;

  @override
  final bool Function(double value)? canChange;

  @override
  final VoidCallback? beforeChange;

  @override
  final VoidCallback? afterChange;

  final bool enabled;

  @override
  final bool readOnly;

  final bool autofocus;

  final TextInputType keyboardType;

  final TextInputAction? textInputAction;

  final InputDecoration decoration;

  final FormFieldValidator<String>? validator;

  final Brightness? keyboardAppearance;

  final bool? showCursor;

  final Color? cursorColor;

  final bool enableInteractiveSelection;

  final TextAlign textAlign;

  final TextDirection textDirection;

  final TextStyle? textStyle;

  final ToolbarOptions? toolbarOptions;

  @override
  SpinBoxState createState() => SpinBoxState();
}

class SpinBoxState extends BaseSpinBoxState<SpinBox> {
  Color _activeColor(ThemeData theme) {
    if (hasFocus) return theme.primaryColor;

    return theme.hintColor;
  }

  Color? _iconColor(ThemeData theme, String? errorText) {
    if (!widget.enabled) return theme.disabledColor;
    if (hasFocus && errorText == null) return _activeColor(theme);

    switch (theme.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return theme.iconTheme.color;
    }
  }

  double _textHeight(String? text, TextStyle style) {
    final painter = TextPainter(
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      text: TextSpan(style: style, text: text),
    );
    painter.layout();
    return painter.height;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final decoration = widget.decoration;

    final errorText =
        decoration.errorText ?? widget.validator?.call(controller.text);
    final iconColor = _iconColor(theme, errorText);

    var bottom = 0.0;

    final caption = theme.textTheme.caption;
    if (errorText != null) {
      bottom = _textHeight(errorText, caption!.merge(decoration.errorStyle));
    }
    if (decoration.helperText != null) {
      bottom = max(
          bottom,
          _textHeight(
              decoration.helperText, caption!.merge(decoration.helperStyle)));
    }
    if (decoration.counterText != null) {
      bottom = max(
          bottom,
          _textHeight(
              decoration.counterText, caption!.merge(decoration.counterStyle)));
    }
    if (bottom > 0) bottom += 8.0;

    final inputDecoration = widget.decoration;

    final textField = TextField(
      controller: controller,
      style: widget.textStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      toolbarOptions: widget.toolbarOptions,
      keyboardAppearance: widget.keyboardAppearance,
      inputFormatters: [formatter],
      decoration: inputDecoration,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      showCursor: widget.showCursor,
      cursorColor: widget.cursorColor,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      focusNode: focusNode,
      onSubmitted: fixupValue,
    );

    final incrementButton = SpinButton(
      instruction: widget.instruction,
      color: iconColor,
      icon: widget.incrementIcon,
      enabled: widget.enabled && value < widget.max,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onInstruction: (instruction) => setValue(value + instruction),
    );

    if (!widget.showButtons) return textField;

    final decrementButton = SpinButton(
      instruction: widget.instruction,
      color: iconColor,
      icon: widget.decrementIcon,
      enabled: widget.enabled && value > widget.min,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onInstruction: (instruction) => setValue(value - instruction),
    );

    return Stack(
      children: [
        textField,
        Positioned.fill(
          bottom: bottom,
          child: Align(
            alignment: Alignment.centerLeft,
            child: decrementButton,
          ),
        ),
        Positioned.fill(
          bottom: bottom,
          child: Align(
            alignment: Alignment.centerRight,
            child: incrementButton,
          ),
        )
      ],
    );
  }
}
