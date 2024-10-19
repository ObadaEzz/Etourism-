<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// استعلام لاسترجاع جميع البرامج
$stmt = $con->prepare("SELECT * FROM programme");
$stmt->execute();

// استرجاع البيانات
$programmes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($programmes) {
    echo json_encode(array('status' => 'success', 'data' => $programmes));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No programmes found.'));
}
?>
