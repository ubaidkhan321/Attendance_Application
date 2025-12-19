import 'package:attendance_system_app/resource/constant/assets.dart';
import 'package:attendance_system_app/utils/custom_drawer.dart';
import 'package:attendance_system_app/view_model/controller/navbar/navbar.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarController controller = Get.put(NavBarController());

    return Scaffold(
      appBar: AppBar(
        title: Image(
          height: MediaQuery.of(context).size.height * 0.12,
          fit: BoxFit.contain,
          image: AssetImage(Assets.DISTRHO_LOGO),
        ),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {},
          child: SizedBox(width: 55, child: Image.asset(Assets.APP_LOGO)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(1, (index) {
                    final isSelected = controller.selectedIndex.value == index;
                    return _buildNavItem(
                      icon: controller.icondata[index],
                      label: controller.labels[index],
                      isSelected: isSelected,
                      onTap: () => controller.updateIndex(index),
                    );
                  }),
                ),
                Row(
                  children: List.generate(1, (index) {
                    final actualIndex = index + 1;
                    final isSelected =
                        controller.selectedIndex.value == actualIndex;
                    return _buildNavItem(
                      icon: controller.icondata[actualIndex],
                      label: controller.labels[actualIndex],
                      isSelected: isSelected,
                      onTap: () => controller.updateIndex(actualIndex),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.orange : Colors.white, size: 26),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.orange : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
