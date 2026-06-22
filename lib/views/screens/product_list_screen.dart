import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_strings.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_grid.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productsTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, _) {
          if (controller.state == ViewState.loading) {
            return const SingleChildScrollView(child: ShimmerGrid());
          }

          if (controller.state == ViewState.error) {
            return _ErrorView(
              message: controller.errorMessage,
              onRetry: controller.loadProducts,
            );
          }

          return Column(
            children: [
              _SearchBar(controller: controller),
              _CategoryFilter(controller: controller),
              Expanded(
                child: controller.visibleProducts.isEmpty &&
                        !controller.isLoadingMore
                    ? const _EmptyView()
                    : _ProductGrid(controller: controller),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ProductController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimens.searchBarPadding,
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.searchRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.searchFill,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final ProductController controller;

  const _CategoryFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: AppDimens.categoryBarHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppDimens.categoryBarPadding,
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimens.sp8),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          final selected = controller.selectedCategory == cat;
          return ChoiceChip(
            label: Text(
              cat == kAllCategories ? AppStrings.allCategoryLabel : cat,
            ),
            selected: selected,
            onSelected: (_) => controller.setCategory(cat),
            selectedColor: theme.colorScheme.primary,
            labelStyle: TextStyle(
              color: selected ? AppColors.white : null,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final ProductController controller;

  const _ProductGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final products = controller.visibleProducts;

    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        SliverPadding(
          padding: AppDimens.gridPadding,
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: products[index]),
              childCount: products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppDimens.gridCrossAxisCount,
              crossAxisSpacing: AppDimens.gridSpacing,
              mainAxisSpacing: AppDimens.gridSpacing,
              childAspectRatio: AppDimens.gridChildAspectRatio,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _BottomLoader(controller: controller),
        ),
      ],
    );
  }
}

class _BottomLoader extends StatelessWidget {
  final ProductController controller;

  const _BottomLoader({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.sp24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!controller.hasMore && controller.visibleProducts.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.sp24),
        child: Center(
          child: Text(
            AppStrings.allProductsSeen(controller.filteredProducts.length),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return const SizedBox(height: AppDimens.sp16);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimens.errorPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: AppDimens.emptyStateIconSize,
              color: AppColors.iconMuted,
            ),
            const SizedBox(height: AppDimens.sp16),
            Text(
              AppStrings.errorTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimens.sp8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppDimens.sp24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: AppDimens.emptyStateIconSize,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: AppDimens.sp16),
          Text(
            AppStrings.emptyTitle,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
