// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, avoid_function_literals_in_foreach_calls, unnecessary_cast, unnecessary_null_comparison, avoid_print
import 'package:coffee_house/VoucherCard.dart';
import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserScreen/MainUserScreen.dart';
import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'cartItems.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CartItem> cartItems = [];
  int totalQuantity = 0;
  int test = 0;
  int totalPrice = 0;
  String address = "";
  String phoneNumber = "";
  String name = "";
  String selectedVoucher = "";
  List<VoucherCard> vouchers = [];
  double discountPercent = 0.0;
  bool isVoucherSelected = false;
  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  void fetchAllData() async {
    await Future.wait([
      fetchVouchers(),
      fetchCartItems(),
      fetchContactInfo(),
    ] as Iterable<Future>);
    applyDiscount(selectedVoucher);
  }

  Future<void> fetchContactInfo() async {
    try {
      DatabaseEvent event = await usersContact.once();
      DataSnapshot snapshot = event.snapshot;
      var data = snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          address = data['address'] ?? '';
          phoneNumber = data['phoneNumber'] ?? '';
          name = data['name'] ?? '';
        });
      }
    } catch (error) {
      displayToastMessage("$error", context);
    }
  }

  Future<void> fetchVouchers() async {
    try {
      DatabaseEvent event = await usersRefVoucher.once();
      DataSnapshot snapshot = event.snapshot;
      var data = snapshot.value;

      if (data != null && data is Map<Object?, Object?>) {
        vouchers = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            vouchers.add(VoucherCard.fromMap(key.toString(), value));
          } else {
            print("Không có sản phẩm với Id = : $key");
          }
        });
        print("Vouchers: $vouchers");
        applyDiscount(selectedVoucher);
      } else {
        print("Voucher không có sẵn");
      }
    } catch (error) {
      displayToastMessage("$error", context);
      print("$error");
    }
  }

  void handlePayment() {
    if (cartItems.isEmpty) {
      displayToastMessage("Giỏ hàng của bạn trống!", context);
    } else {
      sendOrderToAdmin();
      removeAppliedVoucher();
      displayToastMessage("Đặt hàng thành công!", context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainUserScreen.idScreen,
        (route) => false,
      );
    }
  }

  void sendOrderToAdmin() {
    String? orderId = Order.push().key;
    List<Map<String, dynamic>> orderList = [];
    cartItems.forEach((item) {
      Map<String, dynamic> productInfo = {
        'Tên sản phẩm': item.name,
        'Giá': item.price,
        'Số lượng': item.quantity,
      };
      orderList.add(productInfo);
    });
    Map<String, dynamic> orderInfo = {
      'Tên khách hàng': name,
      'Số điện thoại': phoneNumber,
      'Địa chỉ': address,
      'Thông tin sản phẩm': orderList,
    };
    int totalAmount =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    orderInfo['Tổng tiền'] = totalAmount;

    DatabaseReference newOrderRef = adminOrder.child(orderId!);
    DatabaseReference newOrderRefUser = usersRef
        .child(currentfirebaseUser!.uid)
        .child("HistoryOrders")
        .child(orderId);
    newOrderRef.set(orderInfo);
    newOrderRefUser.set(orderInfo);
    usersCartRef.remove();
  }

  void removeProductFromCart(int index) {
    setState(() {
      totalQuantity -= cartItems[index].quantity;
      totalPrice -= cartItems[index].price * cartItems[index].quantity;
      cartItems.removeAt(index);
    });
  }

  void increaseProductQuantity(int index) {
    setState(() {
      totalQuantity++;
      totalPrice += cartItems[index].price;
      CartItem updatedItem =
          cartItems[index].copyWith(quantity: cartItems[index].quantity + 1);
      cartItems[index] = updatedItem;
    });
  }

  void decreaseProductQuantity(int index) {
    setState(() {
      totalQuantity--;
      totalPrice -= cartItems[index].price;
      CartItem updatedItem =
          cartItems[index].copyWith(quantity: cartItems[index].quantity - 1);
      cartItems[index] = updatedItem;
    });
  }

  double originalTotalPrice = 0.0;

  void fetchCartItems() async {
    try {
      DatabaseEvent event = await usersCartRef.once();
      DataSnapshot snapshot = event.snapshot;
      var data = snapshot.value;
      if (data != null) {
        List<CartItem> items = [];
        Map<dynamic, dynamic>? cartData = data as Map<dynamic, dynamic>?;
        if (cartData != null) {
          items = cartData.entries.map((entry) {
            return CartItem.fromMap(
                entry.key, entry.value as Map<dynamic, dynamic>);
          }).toList();
        }

        int calculatedTotalPrice =
            items.fold(0, (sum, item) => sum + (item.price * item.quantity));

        setState(() {
          cartItems = items;
          totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
          originalTotalPrice = calculatedTotalPrice.toDouble();
          totalPrice = originalTotalPrice.toInt();
          print('Original Total Price: $originalTotalPrice VNĐ');
          print('Total Price: $totalPrice VNĐ');
        });
      }
    } catch (error) {
      displayToastMessage("$error", context);
    }
  }

  void applyDiscount(String voucherCode) {
    if (voucherCode.isEmpty) {
      setState(() {
        isVoucherSelected = false;
        discountPercent = 0.0;
        totalPrice = originalTotalPrice.toInt();
      });
      return;
    }

    VoucherCard? selectedVoucherCard;
    for (var voucherCard in vouchers) {
      if (voucherCard.code == voucherCode) {
        selectedVoucherCard = voucherCard;
        break;
      }
    }

    if (selectedVoucherCard != null) {
      setState(() {
        isVoucherSelected = true;
        discountPercent = selectedVoucherCard!.discount;
        totalPrice =
            (originalTotalPrice * (1.0 - discountPercent / 100)).toInt();
      });
    } else {
      displayToastMessage("Không có sẵn voucher", context);
    }
  }

  void removeAppliedVoucher() {
    setState(() {
      selectedVoucher = "";
      isVoucherSelected = false;
      discountPercent = 0.0;
    });
  }

  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Thông tin đơn hàng',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 30.0,
            thickness: 5.0,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                String image = cartItems[index].image;
                String name = cartItems[index].name;
                int price = cartItems[index].price;
                int quantity = cartItems[index].quantity;
                return ListTile(
                  leading: Image.network(image),
                  title: Text(name),
                  subtitle: Text('Giá: $price'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeProductFromCart(index);
                        },
                      ),
                      Text('Số lượng: $quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          increaseProductQuantity(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 20.0,
            thickness: 5.0,
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Text(
            'Chọn mã giảm giá:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (isVoucherSelected) {
                displayToastMessage("Mã chỉ được chọn 1 lần duy nhất", context);
                return;
              }

              if (vouchers.isNotEmpty) {
                final RenderBox overlay = Overlay.of(context)!
                    .context
                    .findRenderObject() as RenderBox;
                final width = overlay.size.width;
                final height = overlay.size.height;
                final position = RelativeRect.fromLTRB(
                    width / 4, height / 3, width / 4 * 3, height / 3 * 2);
                showMenu(
                  context: context,
                  position: position,
                  items: vouchers.map((voucher) {
                    return PopupMenuItem<String>(
                      value: voucher.code,
                      child: Text(
                          '${voucher.code} - Giảm giá: ${voucher.discount}%'),
                    );
                  }).toList(),
                ).then((value) {
                  if (value != null) {
                    print('Selected voucher: $value');
                    setState(() {
                      selectedVoucher = value;
                      isVoucherSelected = true;
                    });
                    applyDiscount(value);
                  }
                });
              } else {
                print("No vouchers available.");
              }
            },
            child: Text('Chọn mã giảm giá'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng số lượng:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Text(
                '$totalQuantity',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tổng thành tiền:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Text(
                isVoucherSelected
                    ? '${((totalPrice + 10000) * (1 - discountPercent / 100)).toInt()} VNĐ'
                    : '$totalPrice VNĐ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (selectedVoucher.isNotEmpty)
            Column(
              children: [
                Text('Mã giảm giá: $selectedVoucher'),
                Text('Số tiền trước khi giảm giá: ${(totalPrice + 10000)}VNĐ'),
                Text(
                  'Số tiền sau khi giảm giá: ${((totalPrice + 10000) * (1 - discountPercent / 100)).toInt()} VNĐ',
                ),
              ],
            ),
          Text(
            'Tên :',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Địa chỉ:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            address,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Số điện thoại:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            phoneNumber,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              handlePayment();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onPrimary: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Thanh toán',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
