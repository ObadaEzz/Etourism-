<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// استعلام لاسترجاع جميع السياح
$stmt = $con->prepare("SELECT * FROM tourist");
$stmt->execute();

// استرجاع البيانات
$tourists = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($tourists) {
    echo json_encode(array('status' => 'success', 'data' => $tourists));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No tourists found.'));
}
?>
