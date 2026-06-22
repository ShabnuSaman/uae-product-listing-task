import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/app_constants.dart';

enum ViewState { idle, loading, success, error }

class ProductController extends ChangeNotifier {
  final ApiService _apiService;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  ProductController({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    scrollController.addListener(_onScroll);
    loadProducts();
  }

  ViewState _state = ViewState.idle;
  List<Product> _allProducts = [];
  List<String> _categories = [kAllCategories];
  String _selectedCategory = kAllCategories;
  String _searchQuery = '';
  String _errorMessage = '';
  int _currentPage = 1;
  bool _isLoadingMore = false;

  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<String> get categories => _categories;
  bool get isLoadingMore => _isLoadingMore;

  List<Product> get filteredProducts {
    var products = _allProducts;

    if (_selectedCategory != kAllCategories) {
      products =
          products.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      products =
          products.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    return products;
  }

  List<Product> get visibleProducts {
    final all = filteredProducts;
    final end = _currentPage * kPageSize;
    return all.take(end > all.length ? all.length : end).toList();
  }

  bool get hasMore => visibleProducts.length < filteredProducts.length;

  void _onScroll() {
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> loadProducts() async {
    _setState(ViewState.loading);
    try {
      final results = await Future.wait([
        _apiService.fetchProducts(),
        _apiService.fetchCategories(),
      ]);

      _allProducts = results[0] as List<Product>;
      _categories = [kAllCategories, ...(results[1] as List<String>)];
      _currentPage = 1;
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setState(ViewState.error);
    }
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _currentPage = 1;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    setSearchQuery('');
  }

  Future<void> loadMore() async {
    if (!hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _currentPage++;
    _isLoadingMore = false;
    notifyListeners();
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
