<?php
//include "functions.php";

// بيانات الاتصال بقاعدة البيانات المحلية عبر XAMPP
$dsn = "mysql:host=localhost;dbname=etourism";  // تأكد من أن اسم قاعدة البيانات "etourism" تم إنشاؤها في MySQL
$user = "root";  // المستخدم الافتراضي لـ XAMPP
$pass = "";  // كلمة المرور الافتراضية فارغة في XAMPP

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

    // تحقق من الاتصال
   // if ($con) {
     //   echo "Connection successful!";
    //} else {
      //  echo "Connection failed!";
    //}

} catch (PDOException $e) {
    // في حالة وجود خطأ في الاتصال، يتم عرض الرسالة
    echo $e->getMessage();   
}
?>
