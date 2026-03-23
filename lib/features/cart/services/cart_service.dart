import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as dev;

class CartService {
  final client = Supabase.instance.client;

  /// Get the current user ID from Supabase auth
  String? getCurrentUserId() {
    return client.auth.currentSession?.user?.id;
  }

  Future<List<Map<String, dynamic>>> getCart() async {
  try {
    final userId = getCurrentUserId();
    if (userId == null) {
      dev.log("No user logged in");
      return [];
    }

    final response = await client
        .from("carts")
        .select()
        .eq('user_id', userId);

    dev.log("Cart response: ${response.toString()}");
    dev.log("Cart response type: ${response.runtimeType}");
    dev.log("Cart response details: ${response.runtimeType} - ${'List'}");
    
    final cartList = List<Map<String, dynamic>>.from(response);
    dev.log("Cart list processed: ${cartList.length} items");
    return cartList;
  
  } catch (e) {
    dev.log("Error getting cart: $e");
    return [];
  }
}

  Future<void> addToCart(String productId, int quantity) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        dev.log("No user logged in");
        return;
      }

      await client.from("carts").insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
        'added_at': DateTime.now().toIso8601String(),
      });
      dev.log("Added to cart successfully");
    } catch (e) {
      dev.log("Error adding to cart: $e");
    }
  }

  Future<void> updateCartQty({required final productId, required int qty })async{
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        dev.log("No user logged in");
        return;
      }

      await client.from("carts").update({'quantity': qty})
        .eq('user_id', userId)
        .eq('product_id', productId);
      dev.log("update cart");
    } catch (e) {
      dev.log("$e");
      
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        dev.log("No user logged in");
        return;
      }

      await client.from("carts").delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
      dev.log("Removed from cart successfully");
    } catch (e) {
      dev.log("Error removing from cart: $e");
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        dev.log("No user logged in");
        return;
      }

      await client.from("carts").update({'quantity': quantity})
        .eq('user_id', userId)
        .eq('product_id', productId);
      dev.log("Updated quantity successfully");
    } catch (e) {
      dev.log("Error updating quantity: $e");
    }
  }

  Future<void> clearCart() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) {
        dev.log("No user logged in");
        return;
      }

      await client.from("carts").delete().eq('user_id', userId);
      dev.log("Cleared cart successfully");
    } catch (e) {
      dev.log("Error clearing cart: $e");
    }
  }
}
