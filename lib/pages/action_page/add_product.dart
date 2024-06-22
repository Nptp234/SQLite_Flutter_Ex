import 'dart:io';

import 'package:bt_tuan6/data/database_service.dart';
import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/models/product.dart';
import 'package:bt_tuan6/pages/category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:quickalert/quickalert.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget{
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct>{

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ProductModel productModel = ProductModel();
  DatabaseServiceProduct databaseServiceProduct = DatabaseServiceProduct();

  void addProduct(String name, String des, String price, String img, String cateId){
    productModel = ProductModel(id: Uuid().v4(), name: name, desc: des, price: double.parse(price), img: img, cateId: cateId);
    databaseServiceProduct.insertProduct(productModel);
  }

  CategoryModel categoryModel = CategoryModel();
  List<CategoryModel> listCategory = [];
  DatabaseServiceCategory databaseServiceCategory = DatabaseServiceCategory();
  String? categoryId;

  Future<List<CategoryModel>> getListCategory() async{
    // databaseServiceCategory.getCategoyList().whenComplete(() {
    //   setState(() async{
    //     listCategory = await databaseServiceCategory.getCategoyList();
    //   });
    // });
    listCategory = CategoryPageState.listCategory;
    return listCategory;
  }

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Image selection cancelled.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listCategory = CategoryPageState.listCategory;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Add', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: _bodyCustom(context),
    );
  }

  Widget _bodyCustom(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            Container(
              width: double.infinity,

              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: _image!=null?
                            Image.file(_image!, fit: BoxFit.cover,)
                            : Image.asset('assets/custom.png', fit: BoxFit.cover,)
                        ),
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.black.withOpacity(0.5)),
                            
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },

                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),

                        child: Text('Choose image', style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
              ),
            ),
            const SizedBox(height: 30,),

            SizedBox(
              width: double.infinity,
              height: 200,

              child: TextFormField(
                controller: descController,
                maxLines: 20,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
              ),
            ),
            const SizedBox(height: 30,),

            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Price',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
                suffixText: 'VND',
                suffixStyle: TextStyle(fontSize: 20, color: Colors.black87)
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*(\.[0-9]*)?$')),  // Allow only digits and decimal
              ],
            ),
            const SizedBox(height: 30,),

            Container(
              width: double.infinity,

              child: Row(
                children: [
                  Text('Branch: ', style: TextStyle(fontSize: 17, color: Colors.black87),),
                  _dropdownButton(context),
                ],
              ),
            ),
            const SizedBox(height: 30,),

            GestureDetector(
              onTap: (){
                addProduct(nameController.text, descController.text, priceController.text, _image!.path, categoryId!);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),

                child: Center(child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 20),),),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? dropdownValue;

  Widget _dropdownButton(BuildContext context) {

    return Container(
      width: 150,
      padding: EdgeInsets.only(left: 10, right: 10),

      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),

      child: Center(
        child: FutureBuilder<List<CategoryModel>>(
          future: getListCategory(), // Fetch data on widget build
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final categories = snapshot.data!;

              return DropdownButton(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down, size: 20,),
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: listCategory.map<DropdownMenuItem<String>>((CategoryModel category){
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name!),
                    onTap: () {
                      categoryId = category.id;
                    },
                  );
                }).toList(), 
              );
            } 
            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle errors
            }

            // Display a loading indicator while data is being fetched
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

}