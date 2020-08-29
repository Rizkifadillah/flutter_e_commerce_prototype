class ProductCartModel{
  final String id;
  final String productName;
  final int sellingPrice;
  final String createdDate;
  final String cover;
  final String status;
  final String description;
  final String qty;

  ProductCartModel({this.id, this.productName, this.sellingPrice, this.createdDate, this.cover, this.status, this.description, this.qty});

  factory ProductCartModel.fromJson(Map<String, dynamic> jsonParse){
    return ProductCartModel(
      id: jsonParse['id'],
      productName: jsonParse['productName'],
      sellingPrice: jsonParse['sellingPrice'],
      createdDate: jsonParse['createdDate'],
      cover: jsonParse['cover'],
      status: jsonParse['status'],
      description: jsonParse['description'],
      qty: jsonParse['qty'],
    );
  }

}