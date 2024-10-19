<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// استعلام لاسترجاع جميع السائقين
$stmt = $con->prepare("SELECT * FROM driver");
$stmt->execute();

// استرجاع البيانات
$drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($drivers) {
    echo json_encode(array('status' => 'success', 'data' => $drivers));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No drivers found.'));
}
?>
