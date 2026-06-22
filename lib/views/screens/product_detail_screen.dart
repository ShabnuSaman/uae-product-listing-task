import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/product_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_strings.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetailsTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroImage(imageUrl: product.image),
            Padding(
              padding: AppDimens.detailContentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryChip(category: product.category),
                  const SizedBox(height: AppDimens.sp12),
                  Text(
                    product.title,
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDimens.sp12),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _RatingRow(rating: product.rating),
                    ],
                  ),
                  const Divider(height: AppDimens.sp32),
                  Text(
                    AppStrings.descriptionLabel,
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDimens.sp8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      height: 1.6,
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppDimens.heroImageHeight,
      color: AppColors.imageBg,
      padding: AppDimens.heroImagePadding,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(color: AppColors.white),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.broken_image_outlined,
          size: AppDimens.brokenImageDetail,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(category),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final ProductRating rating;

  const _RatingRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          color: AppColors.starColor,
          size: AppDimens.starIconDetail,
        ),
        const SizedBox(width: AppDimens.sp4),
        Text(
          '${rating.rate.toStringAsFixed(1)} (${rating.count} reviews)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
