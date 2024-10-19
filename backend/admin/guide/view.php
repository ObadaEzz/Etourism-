<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; 

// استعلام لاسترجاع جميع المرشدين
$stmt = $con->prepare("SELECT * FROM guide");
$stmt->execute();

// استرجاع البيانات
$guides = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($guides) {
    echo json_encode(array('status' => 'success', 'data' => $guides));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No guides found.'));
}
?>
