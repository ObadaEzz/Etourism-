<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include "../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// استعلام لاسترجاع جميع البرامج السياحية
$stmt = $con->prepare("
    SELECT 
        p.programme_id, 
        p.name, 
        p.price, 
        p.description, 
        p.image_path, 
        p.start_date,
        p.end_date,
        p.image_path,
        CONCAT(d.fName, ' ', d.lName) AS driverName,
        CONCAT(g.fName, ' ', g.lName) AS guideName
    FROM programme p
    LEFT JOIN driver d ON p.driver_id = d.driver_id
    LEFT JOIN guide g ON p.guide_id = g.guide_id
");
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
