import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/purchase/data/models/purchase_item_m.dart';
import 'package:moatmat_admin/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PurchasedItemsDS {
  //
  Future<Unit> cancelPurchase({required PurchaseItem item});
  //
  Future<List<PurchaseItem>> testPurchases({required Test test});
  //
  Future<List<PurchaseItem>> bankPurchases({required Bank bank});
  //
  Future<List<PurchaseItem>> teacherPurchases({required String email});
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
}
