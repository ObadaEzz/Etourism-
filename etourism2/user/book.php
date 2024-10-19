<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, OPTIONS, GET");

include "../connect.php";
echo "done";
// التحقق من استلام البيانات
if (
    isset($_POST["name"]) &&
    isset($_POST["email"]) &&
    isset($_POST["phone"]) &&
    isset($_POST["tour_name"]) &&
    isset($_POST["registered_date"])
) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات من الأكواد الضارة
    $name            = htmlspecialchars(strip_tags($_POST["name"]));
    $email           = htmlspecialchars(strip_tags($_POST["email"]));
    $phone           = htmlspecialchars(strip_tags($_POST["phone"]));
    $tour_name       = htmlspecialchars(strip_tags($_POST["tour_name"]));
    $registered_date = htmlspecialchars(strip_tags($_POST["registered_date"]));

    // التحضير والاستعلام
    try {
        $stmt = $con->prepare("INSERT INTO `tourist` (`name`, `email`, `phone`, `tour_name`, `registered_date`) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute(array($name, $email, $phone, $tour_name, $registered_date));

        // التحقق من عدد الصفوف المتأثرة
        $count = $stmt->rowCount();
        if ($count > 0) {
            echo json_encode(array('status' => 'success', 'message' => 'Booking successful.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to book the tour.'));
        }
    } catch (PDOException $e) {
        // التعامل مع الخطأ وإرسال رسالة مفصلة
        echo json_encode(array('status' => 'error', 'message' => 'Database error: ' . $e->getMessage()));
    }
} else {
    // في حال عدم اكتمال البيانات المطلوبة
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
