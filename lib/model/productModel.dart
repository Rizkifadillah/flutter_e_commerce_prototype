class ProductModel{
  final String id;
  final String productName;
  final int sellingPrice;
  final String createdDate;
  final String cover;
  final String status;
  final String description;

  ProductModel({this.id, this.productName, this.sellingPrice, this.createdDate, this.cover, this.status, this.description});

  factory ProductModel.fromJson(Map<String, dynamic> jsonParse){
    return ProductModel(
      id: jsonParse['id'],
      productName: jsonParse['productName'],
      sellingPrice: jsonParse['sellingPrice'],
      createdDate: jsonParse['createdDate'],
      cover: jsonParse['cover'],
      status: jsonParse['status'],
      description: jsonParse['description'],
    );
  }

}