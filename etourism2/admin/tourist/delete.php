<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// التحقق من أن `tourist_id` قد تم إرساله في الطلب
if (isset($_POST["tourist_id"])) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $tourist_id = htmlspecialchars(strip_tags($_POST["tourist_id"]));

    // تحقق من وجود السائح بناءً على `tourist_id`
    $stmtCheck = $con->prepare("SELECT * FROM tourist WHERE tourist_id = ?");
    $stmtCheck->execute([$tourist_id]);

    // التحقق مما إذا كان السائح موجوداً
    if ($stmtCheck->rowCount() > 0) {
        // إذا كان السائح موجوداً، نقوم بحذفه
        $stmtDelete = $con->prepare("DELETE FROM tourist WHERE tourist_id = ?");
        $success = $stmtDelete->execute([$tourist_id]);

        if ($success) {
            echo json_encode(array('status' => 'success', 'message' => 'Tourist deleted successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to delete tourist.'));
        }
    } else {
        // إذا لم يتم العثور على السائح، نعيد حالة الفشل
        echo json_encode(array('status' => 'fail', 'message' => 'Tourist not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'Tourist ID is required.'));
}
?>
