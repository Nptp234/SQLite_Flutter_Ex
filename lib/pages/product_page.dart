import 'dart:io';

import 'package:bt_tuan6/data/database_service.dart';
import 'package:bt_tuan6/models/product.dart';
import 'package:bt_tuan6/pages/action_page/add_product.dart';
import 'package:bt_tuan6/pages/action_page/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ProductPage extends StatefulWidget{

  String? cateId;
  ProductPage({this.cateId});

  _ProductPage createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage>{


  ProductModel productModel = ProductModel();
  List<ProductModel> listProduct = [];
  DatabaseServiceProduct databaseServiceProduct = DatabaseServiceProduct();

  @override
  void initState() {
    super.initState();
    setState(() {
      getList();
    });
  }

  getList() async{
    databaseServiceProduct.getProductList().whenComplete(() {
      setState(() async{
        listProduct = await databaseServiceProduct.getProductList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: _bodyCustom(),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _bodyCustom(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),

      child: Container(
        padding: EdgeInsets.all(10),

        child: FutureBuilder(
          future: databaseServiceProduct.getProductListByCateId(widget.cateId!), 
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data found'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true, 

                itemBuilder: (BuildContext context, int index) { 
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage()));
                    },
                    child: _customItem(index, snapshot.data![index]),
                  );
                },
              );
            }
            return const Center(
              child: Text('No data found'),
            );
          }
        ),
      ),
    );  
  }

  Widget _customItem(int index, ProductModel productModel){
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),

        child: Column(
          children: [
            Row(
              children: [
                Image.file(File(productModel.img!), width: 140,),
                const SizedBox(width: 15,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(productModel.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                    Text("Price: ${productModel.price}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amberAccent[700]),),
                    Text(productModel.desc!, maxLines: 1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),

                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    // padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                    child: IconButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          showCancelBtn: true,
                          type: QuickAlertType.warning,
                          title: 'Are you sure?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onConfirmBtnTap: (){
                            setState((){
                              databaseServiceProduct.deleteProduct(productModel.id!);
                              QuickAlert.show(context: context, type: QuickAlertType.success);
                            });
                            return;
                          },
                        );
                      },

                      icon: Icon(Icons.delete, size: 30, color: Colors.white,),
                    ),
                  )
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    // padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(productModel: productModel,)));
                      },

                      icon: Icon(Icons.edit, size: 30, color: Colors.white,),
                    ),
                  )
                ),
              ],
            )
          ],
        )
      ),
    );
  }

}