// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, file_names, unused_field, deprecated_member_use, prefer_final_fields, avoid_unnecessary_containers
import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminWidgets/AddPopularPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/DetailPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/EditPopularPage.dart';
import 'package:coffee_house/admin/ModelsAdmin/PDr-Admin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PopularAdminPage extends StatefulWidget {
  @override
  _PopularAdminPageState createState() => _PopularAdminPageState();
}

class _PopularAdminPageState extends State<PopularAdminPage> {
  late DatabaseReference _ppsRef;
  List<Drink> _pps = [];
  bool _showDeleteDialog = false;
  bool _isDeleting = false;
  Drink? _selectedDrink;

  @override
  void initState() {
    super.initState();
    _ppsRef = FirebaseDatabase.instance.ref().child('product').child('populars');
    _loadPP();
  }

  void _loadPP() {
    _ppsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        dynamic ppsData = event.snapshot.value;

        if (ppsData is Map<dynamic, dynamic>) {
          if (mounted) {
            setState(() {
              _pps = ppsData.entries.map((entry) {
                Map<dynamic, dynamic> ppData = entry.value as Map<dynamic, dynamic>;
                return Drink(
                  id: entry.key as String,
                  image: ppData['image'] as String,
                  price: double.parse(ppData['price'].toString()),
                  name: ppData['name'] as String,
                  quantity: int.parse(ppData['quantity'].toString()),
                  description: ppData['description'] as String,
                );
              }).toList();
            });
          }
        }
      }
    });
  }

  void _showConfirmationDialog(Drink pp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isDeleting = true;
                });
                String productId = pp.id.toString();
                String imageUrl = pp.image;
                await deleteProduct(productId, imageUrl);
                displayToastMessage("Xóa thành công", context);
                Navigator.pop(context);
              },
              child: Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(String productId, String imageUrl) async {
    DatabaseReference ppsRef = FirebaseDatabase.instance.ref().child('product').child('populars').child(productId);
    await ppsRef.remove();
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.refFromURL(imageUrl);
    await imageRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) { // ignore: unnecessary_non_null_assertion
      if (_showDeleteDialog) {
        _showConfirmationDialog(_selectedDrink!);
        _showDeleteDialog = false;
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _pps.length,
            itemBuilder: (context, index) {
              final pp = _pps[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(product: pp)),
                  );
                },
                child: Container(
                  child: ListTile(
                    title: Text(pp.name),
                    subtitle: Text(pp.description),
                    leading: Image.network(
                      pp.image,
                      width: 50,
                      height: 50,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(pp.price.toStringAsFixed(2)),
                        Text("VND"),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditPopularPage(pp: pp)),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showDeleteDialog = true;
                              _selectedDrink = pp;
                            });
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPopularPage()),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Thêm'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}