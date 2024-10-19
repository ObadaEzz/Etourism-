<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // تأكد من تعديل المسار إذا كان مختلفاً

if (isset($_POST["guideName"]) && isset($_POST["mobile"]) && isset($_POST["fName"]) && isset($_POST["lName"]) && isset($_POST["description"])) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $guideName = htmlspecialchars(strip_tags($_POST["guideName"]));
    $mobile = htmlspecialchars(strip_tags($_POST["mobile"]));
    $fName = htmlspecialchars(strip_tags($_POST["fName"]));
    $lName = htmlspecialchars(strip_tags($_POST["lName"]));
    $description = htmlspecialchars(strip_tags($_POST["description"]));

    // التحقق مما إذا كان المرشد موجودًا
    $stmtCheck = $con->prepare("SELECT * FROM guide WHERE guideName = ?");
    $stmtCheck->execute([$guideName]);

    if ($stmtCheck->rowCount() > 0) {
        // تحديث معلومات المرشد
        $stmtUpdate = $con->prepare("UPDATE guide SET fName = ?, lName = ?, description = ?, mobile = ? WHERE guideName = ?");
        $success = $stmtUpdate->execute([$fName, $lName, $description, $mobile, $guideName]);

        if ($success) {
            echo json_encode(array('status' => 'success', 'message' => 'Guide information updated successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to update guide information.'));
        }
    } else {
        // إذا لم يتم العثور على المرشد، نعيد حالة الفشل
        echo json_encode(array('status' => 'fail', 'message' => 'Guide not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'Guide Name, Mobile number, first name, last name, and description are required.'));
}
?>
