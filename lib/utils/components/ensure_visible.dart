import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class EnsureVisibleWhenFocused extends StatefulWidget {
  final FocusNode focusNode;

  final Widget child;

  final Curve curve;

  final Duration duration;
  const EnsureVisibleWhenFocused({
    super.key,
    required this.child,
    required this.focusNode,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  EnsureVisibleWhenFocusedState createState() =>
      EnsureVisibleWhenFocusedState();
}

class EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode.addListener(_ensureVisible);
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  void _ensureVisible() {
    if (!widget.focusNode.hasFocus) return;

    final RenderObject? object = context.findRenderObject();
    assert(object != null);
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    final ScrollableState? scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    final ScrollPosition position = scrollableState!.position;
    double alignment;
    if (position.pixels > viewport!.getOffsetToReveal(object!, 0.0).offset) {
      alignment = 0.0;
    } else if (position.pixels <
        viewport.getOffsetToReveal(object, 1.0).offset) {
      alignment = 1.0;
    } else {
      return;
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
