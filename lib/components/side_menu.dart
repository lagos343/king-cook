import 'package:flutter/material.dart';
import 'package:king_cook/components/info_card.dart';
import 'package:king_cook/screens/home_screen.dart';
import 'package:rive/rive.dart';
import 'package:king_cook/components/side_menu_tile.dart';
import 'package:king_cook/models/rive_assets.dart';
import 'package:king_cook/utils/rive_utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<StatefulWidget> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sideMenus.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 250,
        height: double.infinity,
        color: const Color(0xFF17203A), //Background del menu
        child: SafeArea(
          child: SingleChildScrollView(
            //Para evitar el problema del bottom pixels
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoCard(
                    name: 'Usuario' //Enviar por parametro el nombre de usuario
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 22, bottom: 16),
                  child: Text(
                    'menú'
                        .toUpperCase(), //El titulo que aparece sobre las opciones
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sideMenus.map(
                  //ir al archivo rive_assets en modelos
                  (menu) => SideMenuTile(
                    menu: menu,
                    riveonInit: (artboard) {
                      //Animacion al presionar
                      StateMachineController controller =
                          RiveUtils.getRiveController(artboard,
                              stateMachineName: menu.stateMachineName);
                      menu.input = controller.findSMI("active") as SMIBool;
                    },
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          menu.pagina,
                          (route) => false,
                        ); //Para ir a otra pagina
                      });
                      setState(() {
                        selectedMenu = menu;
                      });
                    },
                    isActive: selectedMenu == menu,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
