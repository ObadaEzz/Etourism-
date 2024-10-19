<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// تأكد من تعديل المسار إذا كان مختلفاً
include "../connect.php"; 

// التحقق مما إذا كان تم تمرير ID البرنامج في URL
if (!isset($_GET['program_id'])) {
    echo json_encode(array('status' => 'fail', 'message' => 'Program ID not provided.'));
    exit();
}

$program_id = $_GET['program_id']; // استقبل ID البرنامج من الطلب

// استعلام لاسترجاع جميع الجولات المرتبطة ببرنامج معين
$stmt = $con->prepare("
    SELECT 
        t.tour_id AS tour_id, 
        t.name AS tour_name, 
        t.price, 
        t.image_url,
        t.programme_id
    FROM tour t
    WHERE t.programme_id = :program_id
");
$stmt->bindParam(':program_id', $program_id, PDO::PARAM_INT);
$stmt->execute();

// استرجاع البيانات
$tours = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($tours) {
    echo json_encode(array('status' => 'success', 'data' => $tours));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No tours found.'));
}
?>
