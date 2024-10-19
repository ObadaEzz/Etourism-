<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include "../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

// الحصول على التواريخ من طلب المستخدم (مع إزالة الوقت إن وجد)
$startDate = isset($_GET['start_date']) ? substr($_GET['start_date'], 0, 10) : null;
$endDate = isset($_GET['end_date']) ? substr($_GET['end_date'], 0, 10) : null;

// طباعة التواريخ للتحقق من استقبالها بشكل صحيح
error_log("Start Date: $startDate");
error_log("End Date: $endDate");

// إعداد الاستعلام الافتراضي
$query = "
    SELECT 
        p.programme_id, 
        p.name, 
        p.price, 
        p.description, 
        p.image_path, 
        p.start_date,
        p.end_date,
        CONCAT(d.fName, ' ', d.lName) AS driverName,
        CONCAT(g.fName, ' ', g.lName) AS guideName
    FROM programme p
    LEFT JOIN driver d ON p.driver_id = d.driver_id
    LEFT JOIN guide g ON p.guide_id = g.guide_id
";

// إضافة شروط التواريخ إذا كانت موجودة
if ($startDate && $endDate) {
    $query .= " WHERE DATE(p.start_date) >= :startDate AND DATE(p.end_date) <= :endDate";
}

$stmt = $con->prepare($query);

// ربط المتغيرات إذا كانت التواريخ موجودة
if ($startDate && $endDate) {
    $stmt->bindParam(':startDate', $startDate);
    $stmt->bindParam(':endDate', $endDate);
}

// تنفيذ الاستعلام
$stmt->execute();

// استرجاع البيانات
$programmes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// طباعة البيانات للتحقق من صحة النتائج
error_log("Programmes: " . print_r($programmes, true));

// التحقق مما إذا كانت البيانات موجودة
if ($programmes) {
    echo json_encode(array('status' => 'success', 'data' => $programmes));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No programmes found.'));
}
?>
