<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// استعلام لاسترجاع جميع البرامج مع معلومات السائق والمرشد
$stmt = $con->prepare("
    SELECT t.*, 
           p.name AS programmeName
    FROM tour t
    LEFT JOIN programme p ON t.programme_id = p.programme_id
");

try {
    $stmt->execute();

    // استرجاع البيانات
    $programmes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // التحقق مما إذا كانت البيانات موجودة
    if ($programmes) {
        echo json_encode(array('status' => 'success', 'data' => $programmes));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'No programmes found.'));
    }
} catch (Exception $e) {
    echo json_encode(array('status' => 'fail', 'message' => 'Error: ' . $e->getMessage()));
}
?>
