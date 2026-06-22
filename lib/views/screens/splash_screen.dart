import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/splash_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_strings.dart';
import 'product_list_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashController(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    final ready = context.watch<SplashController>().ready;

    if (ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ProductListScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeIn,
          builder: (context, fadeValue, child) =>
              Opacity(opacity: fadeValue, child: child),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.75, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            builder: (context, scaleValue, child) =>
                Transform.scale(scale: scaleValue, child: child),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimens.splashIconContainerSize,
                  height: AppDimens.splashIconContainerSize,
                  decoration: BoxDecoration(
                    color: AppColors.splashText
                        .withValues(alpha: AppColors.splashIconBgAlpha),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: AppDimens.splashIconSize,
                    color: AppColors.splashText,
                  ),
                ),
                const SizedBox(height: AppDimens.sp24),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.splashText,
                    fontSize: AppDimens.splashTitleSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppDimens.sp8),
                Text(
                  AppStrings.splashTagline,
                  style: TextStyle(
                    color: AppColors.splashText
                        .withValues(alpha: AppColors.splashSubtitleAlpha),
                    fontSize: AppDimens.splashSubtitleSize,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppDimens.sp48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
