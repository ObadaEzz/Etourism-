<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً


if (isset($_POST["name"])) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $name = htmlspecialchars(strip_tags($_POST["name"]));
    $stmtCheck = $con->prepare("SELECT * FROM tour WHERE name = ?");
    $stmtCheck->execute([$name]);

    // التحقق مما إذا كان البرنامج موجودًا
    if ($stmtCheck->rowCount() > 0) {
        // إذا كان البرنامج موجودًا، نقوم بحذفه
        $stmtDelete = $con->prepare("DELETE FROM tour WHERE name = ?");
        $success = $stmtDelete->execute([$name]);

        if ($success) {
            echo json_encode(array('status' => 'success', 'message' => 'Tour deleted successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to delete tour.'));
        }
    } else {
        // إذا لم يتم العثور على البرنامج، نعيد حالة الفشل
        echo json_encode(array('status' => 'fail', 'message' => 'Tour not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'Tour name is required.'));
}
?>
