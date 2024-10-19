<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

if (
    isset($_POST["name"]) &&
    isset($_POST["email"]) &&
    isset($_POST["phone"]) &&
    isset($_POST["registered_date"]) // يمكنك جعل هذا الحقل اختياريًا
) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $name = htmlspecialchars(strip_tags($_POST["name"]));
    $email = htmlspecialchars(strip_tags($_POST["email"]));
    $phone = htmlspecialchars(strip_tags($_POST["phone"]));
    $registered_date = htmlspecialchars(strip_tags($_POST["registered_date"])); // يمكنك استخدام التاريخ الحالي إذا لم يتم توفيره

    // تحقق من صحة البريد الإلكتروني
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(array('status' => 'fail', 'message' => 'Invalid email format.'));
        exit();
    }

    // تحقق من أن رقم الهاتف هو رقم صحيح
    if (!preg_match('/^[0-9]+$/', $phone)) {
        echo json_encode(array('status' => 'fail', 'message' => 'Phone number must contain only digits.'));
        exit();
    }

    // إعداد الاستعلام لإضافة السائح
    $stmt = $con->prepare("INSERT INTO tourist (name, email, phone, registered_date) VALUES (?, ?, ?, ?)");

    // تنفيذ الاستعلام
    if ($stmt->execute([$name, $email, $phone, $registered_date])) {
        echo json_encode(array('status' => 'success', 'message' => 'Tourist added successfully.'));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'Failed to add tourist. Please try again later.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
