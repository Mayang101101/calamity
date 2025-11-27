import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emergency_item.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch all emergency items
  Future<List<EmergencyItem>> getItems() async {
    try {
      final response = await _client
          .from('emergency_items')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((json) => EmergencyItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  // Create a new item
  Future<EmergencyItem> createItem(EmergencyItem item) async {
    try {
      final response = await _client
          .from('emergency_items')
          .insert(item.toJson())
          .select()
          .single();
      
      return EmergencyItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create item: $e');
    }
  }

  // Update an item
  Future<EmergencyItem> updateItem(String id, EmergencyItem item) async {
    try {
      final response = await _client
          .from('emergency_items')
          .update(item.toJson())
          .eq('id', id)
          .select()
          .single();
      
      return EmergencyItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    try {
      await _client
          .from('emergency_items')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  // Toggle ready status
  Future<EmergencyItem> toggleReady(String id, bool isReady) async {
    try {
      final response = await _client
          .from('emergency_items')
          .update({
            'is_ready': isReady,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();
      
      return EmergencyItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
