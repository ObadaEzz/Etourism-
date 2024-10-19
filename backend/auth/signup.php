<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Access-Control-Allow-Origin");
header("Access-Control-Allow-Methods: POST, OPTIONS, GET");

include "../connect.php";

// التحقق من استلام البيانات
if (
    isset($_POST["username"]) &&
    isset($_POST["password"]) &&
    isset($_POST["fName"]) &&
    isset($_POST["lName"]) &&
    isset($_POST["email"])
) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات من الأكواد الضارة
    $username = htmlspecialchars(strip_tags($_POST["username"]));
    $password = htmlspecialchars(strip_tags($_POST["password"]));
    $fName    = htmlspecialchars(strip_tags($_POST["fName"]));
    $lName    = htmlspecialchars(strip_tags($_POST["lName"]));
    $email    = htmlspecialchars(strip_tags($_POST["email"]));
    $role     = "tourist"; // يمكنك تعديل هذا الدور بناءً على الحاجة

    // تشفير كلمة المرور باستخدام password_hash
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // التحضير والاستعلام
    try {
        $stmt = $con->prepare("INSERT INTO `users` (`username`, `password`, `fName`, `lName`, `email`, `role`) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute(array($username, $hashed_password, $fName, $lName, $email, $role));

        // التحقق من عدد الصفوف المتأثرة
        $count = $stmt->rowCount();
        if ($count > 0) {
            echo json_encode(array('status' => 'success', 'message' => 'User registered successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to register user.'));
        }
    } catch (PDOException $e) {
        // التعامل مع الخطأ وإرسال رسالة مفصلة
        echo json_encode(array('status' => 'error', 'message' => 'Database error: ' . $e->getMessage()));
    }
} else {
    // في حال عدم اكتمال البيانات المطلوبة
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
