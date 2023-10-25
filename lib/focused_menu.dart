library focused_menu;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final Color? moreTextcolor;
  final int? chunkSize;
  final double? offsetHeight;
  final double customMaxHeight;
  final double? customHeight;
  final EdgeInsets padding;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.moreTextcolor,
      this.openWithTap = false,
      this.chunkSize = 4,
      this.offsetHeight = 0,
      this.padding = EdgeInsets.zero,
      this.customHeight = 0.0,
      this.customMaxHeight = 0.35})
      : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;
  List<FocusedMenuItem> tempList = [];
  List<FocusedMenuItem> prevList = [];

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  changeList(List<FocusedMenuItem> newCount) {
    print('newCount ${newCount.length}');
    setState(() {
      prevList = tempList;
      tempList = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            var listHeight =
                widget.menuItems.length * (widget.menuItemExtent ?? 50.0);
            print('onPressed $listHeight');
            await openMenu(context, listHeight: listHeight);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            changeList(widget.menuItems);
            var listHeight =
                widget.menuItems.length * (widget.menuItemExtent ?? 50.0);
            print('onLongPress $listHeight');
            await openMenu(context, listHeight: listHeight);
          }
        },
        child: widget.child);
  }

  reOpenMenu(List<FocusedMenuItem> newCount) async {
    changeList(newCount);
    var listHeight = newCount.length * (widget.menuItemExtent ?? 50.0);
    print('reOpenMenu $listHeight');
    Navigator.pop(context);
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: tempList,
                    prevItems: prevList,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    listHeight: listHeight,
                    reOpenMenu: reOpenMenu,
                    moreTextColor: widget.moreTextcolor,
                    offset: widget.offsetHeight,
                    customMaxHeight: widget.customMaxHeight,
                    padding: widget.padding,
                    customHeight: widget.customHeight,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }

  Future openMenu(BuildContext context, {listHeight}) async {
    getOffset();
    print('openMenu $listHeight');
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    child: widget.child,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: tempList,
                    prevItems: [],
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    listHeight: listHeight,
                    reOpenMenu: reOpenMenu,
                    moreTextColor: widget.moreTextcolor,
                    lengthSize: widget.chunkSize,
                    customMaxHeight: widget.customMaxHeight,
                    padding: widget.padding,
                    customHeight: widget.customHeight,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  List<FocusedMenuItem> menuItems;
  List<FocusedMenuItem> prevItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final Function? reOpenMenu;
  final Color? moreTextColor;
  final listHeight;
  final int? lengthSize;
  final double? offset;
  final double customMaxHeight;
  final EdgeInsets padding;
  final double? customHeight;

  FocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.prevItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.listHeight,
      this.moreTextColor,
      this.reOpenMenu,
      this.menuOffset,
      this.lengthSize = 4,
      this.offset = 0,
      this.customMaxHeight = 0.35,
      this.padding = EdgeInsets.zero,
      this.customHeight = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * this.customMaxHeight;

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    var menuHeight = listHeight < maxMenuHeight
        ? listHeight + this.customHeight
        : maxMenuHeight + offset!;
    var leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    var topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;

    print('maxMenuHeight $maxMenuHeight');
    print('listHeight $listHeight');
    print('menuHeight $menuHeight');

    if (leftOffset < 10) {
      leftOffset = 100;
    }
    if (topOffset < 10) {
      topOffset = 100;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                  child: Container(
                    color:
                        (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                  ),
                )),
            Positioned(
                top: childOffset.dy,
                left: childOffset.dx,
                child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                        width: childSize!.width,
                        height: childSize!.height,
                        child: child))),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 1)
                          ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: StatefulBuilder(builder: (context, setState) {
                      var chunks = [];
                      var pos = 0;
                      chunks = [];
                      var prevItem = prevItems;
                      var itemTemp = menuItems;
                      var chunkSize = lengthSize!;
                      for (var i = 0; i < menuItems.length; i += chunkSize) {
                        setState(() {
                          chunks.add(menuItems.sublist(
                              i,
                              i + chunkSize > menuItems.length
                                  ? menuItems.length
                                  : i + chunkSize));
                        });
                      }
                      return ListView.builder(
                        itemCount: chunks[pos].length + 1,
                        padding: padding,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == chunks[pos].length) {
                            if (menuItems.length <= chunkSize &&
                                itemTemp.length <= chunkSize) {
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    pos--;
                                  });

                                  if (pos < 0)
                                    setState(() {
                                      pos = 0;
                                      menuItems = prevItem;
                                    });
                                  else
                                    setState(() {
                                      menuItems = chunks[pos];
                                    });
                                  reOpenMenu!(menuItems);
                                },
                                title: Text(
                                  "More...",
                                  style: TextStyle(color: this.moreTextColor),
                                ),
                              );
                            } else {
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    pos++;
                                  });
                                  prevItem = menuItems;
                                  if (pos > chunks.length - 1)
                                    setState(() {
                                      pos = 0;
                                      menuItems = itemTemp;
                                    });
                                  else
                                    setState(() {
                                      menuItems = chunks[pos];
                                    });
                                  reOpenMenu!(menuItems);
                                },
                                title: Text(
                                  "More...",
                                  style: TextStyle(color: this.moreTextColor),
                                ),
                              );
                            }
                          }
                          menuItems[index] = chunks[pos][index];
                          FocusedMenuItem item = menuItems[index];
                          Widget listItem = GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                item.onPressed();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 1),
                                  color: item.backgroundColor ?? Colors.white,
                                  height: itemExtent ?? 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        if (item.leadingIcon != null) ...[
                                          item.leadingIcon!
                                        ],
                                        item.title,
                                        if (item.trailingIcon != null) ...[
                                          item.trailingIcon!
                                        ]
                                      ],
                                    ),
                                  )));
                          if (animateMenu) {
                            return TweenAnimationBuilder(
                                builder: (context, dynamic value, child) {
                                  return Transform(
                                    transform:
                                        Matrix4.rotationX(1.5708 * value),
                                    alignment: Alignment.bottomCenter,
                                    child: child,
                                  );
                                },
                                tween: Tween(begin: 1.0, end: 0.0),
                                duration: Duration(milliseconds: index * 200),
                                child: listItem);
                          } else {
                            return listItem;
                          }
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
