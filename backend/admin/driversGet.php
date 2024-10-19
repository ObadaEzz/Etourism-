<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include '../connect.php'; // تأكد من تعديل المسار إذا كان مختلفاً

try {
    // استعلام لاسترجاع جميع السائقين
    $stmt = $con->prepare("SELECT driver_id, driverName FROM driver"); // استعلام لجلب معرّف السائق واسم السائق
    $stmt->execute();

    // استرجاع البيانات
    $drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // التحقق مما إذا كانت البيانات موجودة
    if ($drivers) {
        // تغيير أسماء المفاتيح لتكون أكثر وضوحًا
        $driversResponse = [];
        foreach ($drivers as $row) {
            $driversResponse[] = [
                'id' => $row['driver_id'],     // استخدام 'id' بدلاً من 'driver_id'
                'name' => $row['driverName'],  // استخدام 'name' بدلاً من 'driverName'
            ];
        }

        echo json_encode(array('status' => 'success', 'data' => $driversResponse));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'No drivers found.'));
    }
} catch (PDOException $e) {
    echo json_encode(array('status' => 'error', 'message' => $e->getMessage()));
}
?>
