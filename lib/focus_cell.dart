import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'android_keycode.dart';

import 'package:fluttertoast/fluttertoast.dart';

/// 可以根据焦点动态改变状态的控件
/// FIXME:放大效果时Z轴没有变化导致被其他控件遮挡
class FocusCell extends StatefulWidget {

  const FocusCell({
    this.key, //获取宽高的KEY
    this.child,
    @required this.focusNode,
    @required this.onKey,
    this.nextFocusNodeLeft,
    this.nextFocusNodeRight,
    this.nextFocusNodeUp,
    this.nextFocusNodeDown,
  })  : assert(focusNode != null),
        super(key: key);

  /// Controls whether this widget has keyboard focus.
  final FocusNode focusNode;

  final FocusNode nextFocusNodeLeft;
  final FocusNode nextFocusNodeRight;
  final FocusNode nextFocusNodeUp;
  final FocusNode nextFocusNodeDown;
  final GlobalKey key;

  final Widget child;

  /// Called whenever this widget receives a raw keyboard event.
  final ValueChanged<RawKeyEvent> onKey;

  @override
  FocusCellState createState() => FocusCellState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
  }
}

class FocusCellState extends State<FocusCell> {

  AnimWidget item;
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(FocusCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    _detachKeyboardIfAttached();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (widget.focusNode.hasFocus) {
      _attachKeyboardIfDetached();
      item.startAnim();
    } else {
      _detachKeyboardIfAttached();
      item.reverseAnim();
    }
  }

  bool _listening = false;

  void _attachKeyboardIfDetached() {
    if (_listening) return;
    RawKeyboard.instance.addListener(_handleRawKeyEvent);
    _listening = true;
  }

  void _detachKeyboardIfAttached() {
    if (!_listening) return;
    RawKeyboard.instance.removeListener(_handleRawKeyEvent);
    _listening = false;
  }

  void _handleRawKeyEvent(RawKeyEvent event) {

    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      RawKeyDownEvent rawKeyDownEvent = event;
      RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data;
      switch (rawKeyEventDataAndroid.keyCode) {
        case KEYCODE_DPAD_LEFT:
          if (widget.nextFocusNodeLeft != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNodeLeft);
          }
          break;
        case KEYCODE_DPAD_RIGHT:
          if (widget.nextFocusNodeRight != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNodeRight);
          }
          break;
        case KEYCODE_DPAD_UP:
          if (widget.nextFocusNodeUp != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNodeUp);
          }
          break;
        case KEYCODE_DPAD_DOWN:
          if (widget.nextFocusNodeDown != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNodeDown);
          }
          break;
        case KEYCODE_DPAD_CENTER:
          //user clicked ,do what you want
          Fluttertoast.showToast(
              msg: "Poster clicked",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 12.0
          );
          break;
        default:
          break;
      }
      if (widget.onKey != null) widget.onKey(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    item = new AnimWidget(child: widget.child,myKey: widget.key,);
    return item;
  }
}

class AnimWidget extends StatefulWidget {
  AnimWidget({
    this.myKey,
    this.child,
  });

  final Widget child;
  GlobalKey myKey;
  _AnimWidgetState state;

  void startAnim() {
    if (state != null) {
      state.statAnim();
    }
  }

  void reverseAnim() {
    if (state != null) {
      state.reverseAnim();
    }
  }

  @override
  State createState() {
    state = new _AnimWidgetState();
    return state;
  }
}

class _AnimWidgetState extends State<AnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  bool animed = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      lowerBound: 1.0,
      upperBound: 1.1,
      // 动画的时长
      duration: Duration(milliseconds: 200),
      // 提供 vsync 最简单的方式，就是直接继承 SingleTickerProviderStateMixin
      vsync: this,
    );
  }

  void statAnim() {
    // 调用 forward 方法开始动画
    if (controller != null) {
      if (!animed) {
        controller.forward();
        animed = true;
      }
    }
  }

  void reverseAnim() {
    // 调用 forward 方法开始动画
    if (controller != null) {
      if (animed) {
        controller.reverse();
        animed = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new AnimatedBuilder(
          animation: controller,
          child: widget.child,
          builder: (BuildContext context, Widget _widget) {
            //获取控件的宽高
            Size size = Size.zero;
            if(widget.myKey.currentContext != null){
              RenderObject renderObject = widget.myKey.currentContext.findRenderObject();
              if(renderObject != null){
                size = renderObject.paintBounds.size;
              }
            }
            return new Transform(
              //以控件的中心位置为原点放大或缩小
              transform: Matrix4.diagonal3Values(
                  controller.value, controller.value, 0.1)
                ..translate((1 - controller.value) * size.width / 2,
                    (1 - controller.value) * size.height / 2, 0.1),
              child: _widget,
            );
          },
        ));
  }
}
