<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php";

if (
    isset($_POST["name"]) &&
    isset($_POST["description"]) &&
    isset($_POST["start_date"]) &&
    isset($_POST["end_date"]) &&
    isset($_POST["price"]) &&
    isset($_POST["programme"]) &&
    isset($_FILES["image"]) 
) {
    $name = htmlspecialchars(strip_tags($_POST["name"]));
    $description = htmlspecialchars(strip_tags($_POST["description"]));
    $start_date = htmlspecialchars(strip_tags($_POST["start_date"]));
    $end_date = htmlspecialchars(strip_tags($_POST["end_date"]));
    $price = htmlspecialchars(strip_tags($_POST["price"]));
    $programme_name = htmlspecialchars(strip_tags($_POST["programme"]));

    if (!is_numeric($price) || $price < 0) {
        echo json_encode(array('status' => 'fail', 'message' => 'Price must be a non-negative number.'));
        exit();
    }

    // معالجة رفع الصورة
    $target_dir = "uploads/"; // تأكد من وجود هذا المجلد
    $target_file = $target_dir . basename($_FILES["image"]["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    // تحقق مما إذا كانت الصورة هي صورة فعلية
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if($check === false) {
        echo json_encode(array('status' => 'fail', 'message' => 'File is not an image.'));
        $uploadOk = 0;
    }

    // تحقق من حجم الملف (مثلاً: أقل من 2MB)
    if ($_FILES["image"]["size"] > 2000000) {
        echo json_encode(array('status' => 'fail', 'message' => 'Sorry, your file is too large.'));
        $uploadOk = 0;
    }

    // فقط أنواع الملفات المسموح بها
    if(!in_array($imageFileType, array('jpg', 'jpeg', 'png', 'gif'))) {
        echo json_encode(array('status' => 'fail', 'message' => 'Sorry, only JPG, JPEG, PNG & GIF files are allowed.'));
        $uploadOk = 0;
    }

    // إذا كان $uploadOk لا يساوي 0، حاول رفع الملف
    if ($uploadOk == 1) {
        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
            // تخزين معلومات البرنامج في قاعدة البيانات
            $stmt = $con->prepare("SELECT COUNT(*) FROM tour WHERE name = ?");
            $stmt->execute([$name]);
            $count = $stmt->fetchColumn();

            if ($count > 0) {
                echo json_encode(array('status' => 'fail', 'message' => 'Tour name already exists.'));
                exit();
            }

            $stmt = $con->prepare("INSERT INTO Tour (name, description, start_date, end_date, price, programme_id, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)");

            $programme_id_query = $con->prepare("SELECT programme_id FROM programme WHERE name = ?");
            $programme_id_query->execute([$programme_name]);
            $programme = $programme_id_query->fetch();


            if (!$programme) {
                echo json_encode(array('status' => 'fail', 'message' => 'programme not found.'));
                exit();
            }

            $programme_id = $programme['programme_id'];


            // إضافة مسار الصورة إلى قاعدة البيانات
            if ($stmt->execute([$name, $description, $start_date, $end_date, $price, $programme_id, $target_file])) {
                echo json_encode(array('status' => 'success', 'message' => 'Program added successfully.'));
            } else {
                echo json_encode(array('status' => 'fail', 'message' => 'Failed to add program. Please try again later.'));
            }
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Sorry, there was an error uploading your file.'));
        }
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
