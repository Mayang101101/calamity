import 'package:flutter/material.dart';
import '../models/emergency_item.dart';
import '../services/supabase_service.dart';

class EmergencyProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<EmergencyItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<EmergencyItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get items by category
  List<EmergencyItem> getItemsByCategory(String category) {
    if (category == 'All') return _items;
    return _items.where((item) => item.category == category).toList();
  }

  // Get total items count
  int get totalItemsCount => _items.length;

  // Get ready items count
  int get readyCount => _items.where((item) => item.isReady).length;

  // Get not ready items count
  int get notReadyCount => _items.where((item) => !item.isReady).length;

  // Fetch all items
  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _supabaseService.getItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new item
  Future<void> addItem(EmergencyItem item) async {
    try {
      final newItem = await _supabaseService.createItem(item);
      _items.insert(0, newItem);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update an item
  Future<void> updateItem(String id, EmergencyItem item) async {
    try {
      final updatedItem = await _supabaseService.updateItem(id, item);
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    try {
      await _supabaseService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Toggle ready status
  Future<void> toggleReady(String id) async {
    try {
      final item = _items.firstWhere((i) => i.id == id);
      final updatedItem = await _supabaseService.toggleReady(id, !item.isReady);
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
