<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../connect.php";

// التحقق من اتصال قاعدة البيانات
if (!$con) {
    echo json_encode(array('status' => 'error', 'message' => 'Database connection failed.'));
    exit();
}

if (isset($_POST["email"])) {
    $email = htmlspecialchars(strip_tags($_POST["email"]));

    // إعداد الاستعلام
    $stmt = $con->prepare("SELECT * FROM `users` WHERE `email` = ?");
    $stmt->execute(array($email));
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    $count = $stmt->rowCount();

     //التحقق من وجود المستخدم
     if ($count > 0) {
        echo json_encode(array('status' => 'success', 'data' => $data));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'User not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'Email is required.'));
} 
?>
