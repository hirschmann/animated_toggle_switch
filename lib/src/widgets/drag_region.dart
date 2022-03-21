import 'package:flutter/material.dart';

class HoverRegion extends StatefulWidget {
  final MouseCursor? cursor;
  final MouseCursor hoverCursor;
  final Widget child;
  final bool Function(Offset offset) hoverCheck;

  const HoverRegion({
    Key? key,
    this.cursor,
    required this.hoverCursor,
    required this.child,
    this.hoverCheck = _defaultHoverCheck,
  }) : super(key: key);

  static bool _defaultHoverCheck(Offset offset) => true;

  @override
  State<HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<HoverRegion> {
  bool _hovering = false;
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    if (_position != null) _updateHovering(_position!, rebuild: false);
    return MouseRegion(
      opaque: false,
      cursor:
          widget.cursor ?? (_hovering ? widget.hoverCursor : MouseCursor.defer),
      onHover: (e) => _updateHovering(e.localPosition),
      onEnter: (e) => _updateHovering(e.localPosition),
      onExit: (e) => _setHovering(false),
      child: widget.child,
    );
  }

  void _updateHovering(Offset offset, {bool rebuild = true}) {
    _position = offset;
    _setHovering(widget.hoverCheck(offset), rebuild: rebuild);
  }

  void _setHovering(bool hovering, {bool rebuild = true}) {
    if (hovering == _hovering) return;
    _hovering = hovering;
    if (rebuild) setState(() {});
  }
}

class DragRegion extends StatelessWidget {
  final bool dragging;
  final Widget child;
  final bool Function(Offset offset) hoverCheck;

  const DragRegion({
    Key? key,
    this.dragging = false,
    required this.child,
    this.hoverCheck = HoverRegion._defaultHoverCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      cursor: dragging ? SystemMouseCursors.grabbing : null,
      hoverCursor: SystemMouseCursors.grab,
      child: child,
      hoverCheck: hoverCheck,
    );
  }
}