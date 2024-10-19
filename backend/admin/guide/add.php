<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; 

if (
    isset($_POST["guideName"]) &&
    isset($_POST["fName"]) &&
    isset($_POST["lName"]) &&
    isset($_POST["address"]) && 
    isset($_POST["mobile"]) &&
    isset($_POST["description"])
) {
    // استخدام htmlspecialchars و strip_tags لحماية البيانات
    $guideName = htmlspecialchars(strip_tags($_POST["guideName"]));
    $fName = htmlspecialchars(strip_tags($_POST["fName"]));
    $lName = htmlspecialchars(strip_tags($_POST["lName"]));
    $address = htmlspecialchars(strip_tags($_POST["address"]));
    $mobile = htmlspecialchars(strip_tags($_POST["mobile"])); 
    $description = htmlspecialchars(strip_tags($_POST["description"]));

    // تحقق مما إذا كان الدليل موجوداً بالفعل
    $checkStmt = $con->prepare("SELECT * FROM guide WHERE guideName = ?");
    $checkStmt->execute([$guideName]);

    if ($checkStmt->rowCount() > 0) {
        // إذا كان الدليل موجوداً بالفعل
        echo json_encode(array('status' => 'fail', 'message' => 'Guide already exists.'));
    } else {
        // إعداد الاستعلام لإدخال بيانات الدليل
        $stmt = $con->prepare("INSERT INTO guide (guideName, fName, lName, Address, mobile, description) VALUES (?, ?, ?, ?, ?, ?)");

        // تنفيذ الاستعلام وإضافة البيانات
        if ($stmt->execute([$guideName, $fName, $lName, $address, $mobile, $description])) {
            echo json_encode(array('status' => 'success', 'message' => 'Guide added successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to add guide.'));
        }
    }
} else {
    // إذا كانت بعض الحقول فارغة
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
