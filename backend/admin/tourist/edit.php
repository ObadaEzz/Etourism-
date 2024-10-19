<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// التحقق من أن `id`, `name`, `email`, `phone`, و `registered_date` قد تم إرسالهم في الطلب
if (
    isset($_POST["id"]) &&
    isset($_POST["name"]) &&
    isset($_POST["email"]) &&
    isset($_POST["phone"]) &&
    isset($_POST["registered_date"])
) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $tourist_id = htmlspecialchars(strip_tags($_POST["id"])); // تغيير إلى id
    $name = htmlspecialchars(strip_tags($_POST["name"]));
    $email = htmlspecialchars(strip_tags($_POST["email"]));
    $phone = htmlspecialchars(strip_tags($_POST["phone"]));
    $registered_date = htmlspecialchars(strip_tags($_POST["registered_date"]));

    // تحقق من وجود السائح بناءً على `tourist_id`
    $stmtCheck = $con->prepare("SELECT * FROM tourist WHERE tourist_id = ?");
    $stmtCheck->execute([$tourist_id]);

    // التحقق مما إذا كان السائح موجوداً
    if ($stmtCheck->rowCount() > 0) {
        // تحديث معلومات السائح
        $stmtUpdate = $con->prepare("UPDATE tourist SET name = ?, email = ?, phone = ?, registered_date = ? WHERE tourist_id = ?");
        $success = $stmtUpdate->execute([$name, $email, $phone, $registered_date, $tourist_id]);

        if ($success) {
            echo json_encode(array('status' => 'success', 'message' => 'Tourist information updated successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to update tourist information.'));
        }
    } else {
        // إذا لم يتم العثور على السائح، نعيد حالة الفشل
        echo json_encode(array('status' => 'fail', 'message' => 'Tourist not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'ID, name, email, phone, and registered date are required.'));
}
?>
