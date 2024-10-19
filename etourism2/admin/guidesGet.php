<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include '../connect.php'; // تأكد من تعديل المسار إذا كان مختلفاً

try {
    // استعلام لاسترجاع جميع المرشدين
    $stmt = $con->prepare("SELECT guide_id, guideName FROM guide"); // استعلام لجلب معرّف المرشد والاسم الأول والكنية
    $stmt->execute();

    // استرجاع البيانات
    $guides = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // التحقق مما إذا كانت البيانات موجودة
    if ($guides) {
        // تغيير أسماء المفاتيح لتكون أكثر وضوحًا
        $guidesResponse = [];
        foreach ($guides as $row) {
            $guidesResponse[] = [
                'id' => $row['guide_id'],             // استخدام 'id' بدلاً من 'guide_id'
                'fullName' => $row['guideName'], // دمج الاسم الأول والكنية
            ];
        }

        echo json_encode(array('status' => 'success', 'data' => $guidesResponse));
    } else {
        echo json_encode(array('status' => 'fail', 'message' => 'No guides found.'));
    }
} catch (PDOException $e) {
    echo json_encode(array('status' => 'error', 'message' => $e->getMessage()));
}
?>
