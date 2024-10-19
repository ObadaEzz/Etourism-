<?php
#include "functions.php";

$dsn ="mysql:host=sql210.infinityfree.com;dbname=if0_37371102_etourism"; 
$user = "if0_37371102";
$pass = "eXsBCqqDJUOTnP";
$option = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES UTF8" // لدعم اللغة العربية
);

try {
    // إنشاء اتصال PDO مع قاعدة البيانات
    $con = new PDO($dsn, $user, $pass, $option);
    $con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // إعدادات CORS
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Access-Control-Allow-Origin");
    header("Access-Control-Allow-Methods: POST, OPTIONS, GET");
    /* // تحقق من الاتصال
    if ($con) {
      echo "Connection successful!";
    } else {
        echo "Connection failed!";
    } */

} catch (PDOException $e) {
    // في حالة وجود خطأ في الاتصال، يتم عرض الرسالة
    echo $e->getMessage();   
}
?>
