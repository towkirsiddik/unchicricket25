import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unchi_cricket/controllers/main_controller.dart';
import 'package:unchi_cricket/utils/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: controller.currentIndex.value == 0,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.star_rounded,
              label: 'Tournament',
              isActive: controller.currentIndex.value == 1,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.group_rounded,
              label: 'Teams',
              isActive: controller.currentIndex.value == 2,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.newspaper_rounded,
              label: 'News',
              isActive: controller.currentIndex.value == 3,
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.business_rounded,
              label: 'Sponsors',
              isActive: controller.currentIndex.value == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.find<MainController>().changeTabIndex(index);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.primary : Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
