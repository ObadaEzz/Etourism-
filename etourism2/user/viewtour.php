<?php
// إعداد الرؤوس لتحديد نوع المحتوى والسماح بالوصول من أي أصل
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// تضمين الاتصال بقاعدة البيانات
include "../connect.php"; 

// التحقق مما إذا كان تم تمرير معلمة tour_id في URL
$tourId = isset($_GET['tour_id']) ? (int)$_GET['tour_id'] : 0;

if ($tourId > 0) {
    // استعلام لاسترجاع تفاصيل الجولة بناءً على tour_id
    $sql = "
        SELECT 
            t.tour_id AS tour_id, 
            t.name AS tour_name, 
            t.price, 
            t.image_url, 
            t.description, 
            t.start_date, 
            t.end_date 
        FROM tour t 
        WHERE t.tour_id = :tourId
    ";

    // تحضير الاستعلام باستخدام PDO
    $stmt = $con->prepare($sql);
    // ربط المعلمة tour_id بالاستعلام
    $stmt->bindParam(':tourId', $tourId, PDO::PARAM_INT);

    // تنفيذ الاستعلام
    $stmt->execute();

    // استرجاع النتائج
    $tour = $stmt->fetch(PDO::FETCH_ASSOC);

    // التحقق مما إذا كانت البيانات موجودة
    if ($tour) {
        echo json_encode(array('status' => 'success', 'data' => $tour));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'No tour found.'));
    }
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'Invalid tour ID.'));
}
?>
