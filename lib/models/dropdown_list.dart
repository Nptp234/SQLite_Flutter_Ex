import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/pages/action_page/edit_product.dart';
import 'package:bt_tuan6/pages/category_page.dart';
import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget{

  String? currentCateId;
  DropdownCustom({this.currentCateId});

  _DropdownCustom createState() => _DropdownCustom();
}

class _DropdownCustom extends State<DropdownCustom>{

  List<CategoryModel> listCategory = [];
  Future<List<CategoryModel>> getListCategory() async{
    listCategory = CategoryPageState.listCategory;
    return listCategory;
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    return listCategory.map((cate) {
      return DropdownMenuItem(child: Text(cate.name!),value: cate.id, onTap: (){EditProductState.categoryId = cate.id;},);
    }).toList();
  }
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentCateId;
  }

  @override
  Widget build(BuildContext context) {
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
              
              return DropdownButton(
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down, size: 20,),
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                  });
                },

                items: dropdownItems
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