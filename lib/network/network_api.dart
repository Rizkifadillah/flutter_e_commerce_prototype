class NetworkUrl{

  static String url = "http://192.168.43.205/Ecommerce/api";

  static String getProduct(){
    return "$url/getProduct.php";
  }

  static String getProductCategory(){
    return "$url/getProductWithCategory.php";
  }

  static String addFavorite(){
    return "$url/addFavorite.php";
  }

  static String getFavorite(String deviceID){
    return "$url/getFavorite.php?deviceID=$deviceID";
  }

  static String addCart(){
    return "$url/addCart.php";
  }

  static String getCart(String unikID){
    return "$url/getCart.php?unikID=$unikID";
  }

  static String getTotalCart(String unikID){
    return "$url/getTotalCart.php?unikID=$unikID";
  }

  static String updateQty(){
    return "$url/updateQty.php";
  }

  static String getTotalHargaCart(String unikID){
    return "$url/getTotalHargaCart.php?unikID=$unikID";
  }
}