<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../connect.php";

if (
    isset($_POST["username"]) &&
    isset($_POST["password"])
) {
    $username = htmlspecialchars(strip_tags($_POST["username"]));
    $password = htmlspecialchars(strip_tags($_POST["password"]));

    // إعداد الاستعلام
    $stmt = $con->prepare("SELECT * FROM `users` WHERE `username`=?");
    $stmt->execute(array($username));
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    $count = $stmt->rowCount();

    // التحقق من وجود المستخدم
    if ($count > 0) {
        // تحقق من كلمة المرور
        if (password_verify($password, $data['password'])) {
            echo json_encode(array('status' => 'success', 'data' => $data));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Incorrect password.'));
        }
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'User not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
