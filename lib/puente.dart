import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kingcook/screens/photo_upload.dart';
import 'package:rive/rive.dart';
import 'package:kingcook/components/side_menu.dart';
import 'package:kingcook/constants.dart';
import 'package:kingcook/screens/home_screen.dart';
import 'package:kingcook/models/menu_btn.dart';
import 'package:kingcook/utils/rive_utils.dart';

class Puente extends StatefulWidget {
  final String namelocal;
  const Puente({super.key, required this.namelocal});
  @override
  State<Puente> createState() => _Puente();
}

class _Puente extends State<Puente> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;
  late SMIBool isSideBarClosed;
  bool isSideMenuClosed = true;
  String get nameLocal => widget.namelocal;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 250,
            left: isSideMenuClosed ? -250 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(), //Lama al menu deslizante
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  //borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: rutamenu(
                      nameLocal), //Aqui se declara la pantalla principal
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 9,
            child: MenuBtn(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                  artboard,
                  stateMachineName: 'State Machine',
                );
                isSideBarClosed = controller.findSMI('isOpen') as SMIBool;
                isSideBarClosed.value = true;
              },
              press: () {
                isSideBarClosed.value = !isSideBarClosed.value;
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClosed = isSideBarClosed.value;
                });
              },
            ),
          )
        ],
      ),
      bottomNavigationBar:
          Transform.translate(offset: Offset(0, 100 * animation.value)),
    );
  }
}

Widget rutamenu(String name) {
  switch (name) {
    case 'home':
      return HomePage();
      break;

    case 'photoupload':
      return PhotoUpload();
      break;

    default:
      return HomePage();
  }
}
