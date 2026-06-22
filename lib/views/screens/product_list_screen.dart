import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_controller.dart';
import '../../utils/app_constants.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_grid.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          final selected = controller.selectedCategory == cat;
          return ChoiceChip(
            label: Text(cat == kAllCategories ? 'All' : cat),
            selected: selected,
            onSelected: (_) => controller.setCategory(cat),
            selectedColor: theme.colorScheme.primary,
            labelStyle: TextStyle(
              color: selected ? Colors.white : null,
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: products[index]),
              childCount: products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
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
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!controller.hasMore && controller.visibleProducts.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(height: 15,)
        ),
      );
    }

    return const SizedBox(height: 16);
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
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
          Icon(Icons.search_off_rounded, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
