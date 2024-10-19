<?php
// إعداد الرؤوس لتحديد نوع المحتوى والسماح بالوصول من أي أصل
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// تضمين الاتصال بقاعدة البيانات
include "../connect.php"; 

// التحقق مما إذا كان تم تمرير معلمة البحث (query) في URL
$searchQuery = isset($_GET['query']) ? trim($_GET['query']) : '';

// استعلام لاسترجاع الجولات. إذا كان هناك استعلام بحث، سيتم تعديله لاحقاً
$sql = "
    SELECT 
        t.tour_id AS tour_id, 
        t.name AS tour_name, 
        t.price, 
        t.image_url,
        t.programme_id 
    FROM tour t
";

// إذا كان هناك استعلام بحث، تعديل الاستعلام باستخدام LIKE
if (!empty($searchQuery)) {
    $sql .= " WHERE t.name LIKE :searchQuery";
}

// تحضير الاستعلام باستخدام PDO
$stmt = $con->prepare($sql);

// إذا كان هناك استعلام بحث، ربط المعلمة بالاستعلام
if (!empty($searchQuery)) {
    $searchQuery = "%$searchQuery%"; // تجهيز قيمة البحث لفلترة النتائج
    $stmt->bindParam(':searchQuery', $searchQuery, PDO::PARAM_STR);
}

// تنفيذ الاستعلام
$stmt->execute();

// استرجاع النتائج
$tours = $stmt->fetchAll(PDO::FETCH_ASSOC);

// التحقق مما إذا كانت البيانات موجودة
if ($tours) {
    echo json_encode(array('status' => 'success', 'data' => $tours));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No tours found.'));
}
?>
