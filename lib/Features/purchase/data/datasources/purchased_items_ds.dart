import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/purchase/data/models/purchase_item_m.dart';
import 'package:moatmat_admin/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PurchasedItemsDS {
  //
  Future<Unit> cancelPurchase({required PurchaseItem item});
  //
  Future<Unit> createTeacherPurchase({required PurchaseItem item});
  //
  Future<List<PurchaseItem>> testPurchases({required Test test});
  //
  Future<List<PurchaseItem>> bankPurchases({required Bank bank});
  //
  Future<List<PurchaseItem>> teacherPurchases({required String email});
  //
  Future<List<PurchaseItem>> getTestPurchasesByIds({required List<int> testIds});
}

class PurchasedItemsDSImpl implements PurchasedItemsDS {
  @override
  Future<List<PurchaseItem>> bankPurchases({required Bank bank}) async {
    //
    var client = Supabase.instance.client;
    //
    var res = await client.from("purchases").select().eq("item_type", "bank").eq("item_id", "${bank.id}").order("id");
    //
    var list = res.map((e) => PurchaseItemModel.fromJson(e)).toList();
    //
    return list;
  }

  @override
  Future<List<PurchaseItem>> testPurchases({required Test test}) async {
    //
    var client = Supabase.instance.client;
    //
    var res = await client.from("purchases").select().eq("item_type", "test").eq("item_id", "${test.id}").order("id");
    //
    var list = res.map((e) => PurchaseItemModel.fromJson(e)).toList();
    //
    return list;
  }

  @override
  Future<List<PurchaseItem>> teacherPurchases({required String email}) async {
    //
    var client = Supabase.instance.client;
    //
    var res = await client.from("purchases").select().eq("item_type", "teacher").eq("item_id", email).order("id");
    //
    var list = res.map((e) => PurchaseItemModel.fromJson(e)).toList();
    //
    return list;
  }

  @override
  Future<Unit> cancelPurchase({required PurchaseItem item}) async {
    //
    var client = Supabase.instance.client;
    //
    await client.from("purchases").delete().eq("id", item.id);
    //
    return unit;
  }

  @override
  Future<Unit> createTeacherPurchase({required PurchaseItem item}) async {
    //
    var client = Supabase.instance.client;
    //
    var items = await client.from("purchases").select().eq("uuid", item.uuid).eq("item_type", item.itemType).eq("item_id", item.itemId);
    //
    if (items.isEmpty) {
      //
      await client.from("purchases").insert(PurchaseItemModel.fromClass(item).toJson());
      //
      return unit;
    } else {
      throw DuplicatedSubscriptionException();
    }
  }

  @override
  Future<List<PurchaseItem>> getTestPurchasesByIds({
    required List<int> testIds,
  }) async {
    var client = Supabase.instance.client;
    //
    final res = await client
      .from('purchases')
      .select()
      .eq('item_type', 'test')
      .inFilter('item_id', testIds);
    //
    var list = res.map((e) => PurchaseItemModel.fromJson(e)).toList();
    //
    return list;
  }
}
