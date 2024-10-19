<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php"; // Make sure the url is correct

// Check if `name`, `description`, `start_date`, `end_date`, `price`, and `image` are set
if (
    isset($_POST["name"]) &&
    isset($_POST["description"]) &&
    isset($_POST["start_date"]) &&
    isset($_POST["end_date"]) &&
    isset($_POST["price"]) &&
    isset($_FILES["image"]) // Check if the image is set
) {
    // Use htmlspecialchars and strip_tags to protect data
    $name = htmlspecialchars(strip_tags($_POST["name"]));
    $description = htmlspecialchars(strip_tags($_POST["description"]));
    $start_date = htmlspecialchars(strip_tags($_POST["start_date"]));
    $end_date = htmlspecialchars(strip_tags($_POST["end_date"]));
    $price = htmlspecialchars(strip_tags($_POST["price"]));

    // Check if the price is a non-negative number
    if (!is_numeric($price) || $price < 0) {
        echo json_encode(array('status' => 'fail', 'message' => 'Price must be a non-negative number.'));
        exit();
    }

    // Check if the tour exists based on `name`
    $stmtCheck = $con->prepare("SELECT * FROM tour WHERE name = ?");
    $stmtCheck->execute([$name]);

    // Check if the tour exists
    if ($stmtCheck->rowCount() > 0) {
        // Handle the image upload
        $target_dir = "uploads/"; // Ensure this directory exists
        $target_file = $target_dir . basename($_FILES["image"]["name"]);
        $uploadOk = 1;
        $imageFileType = strtolower(urlinfo($target_file, PATHINFO_EXTENSION));

        // Check if the image is an actual image
        $check = getimagesize($_FILES["image"]["tmp_name"]);
        if ($check === false) {
            echo json_encode(array('status' => 'fail', 'message' => 'File is not an image.'));
            $uploadOk = 0;
        }

        // Check file size (e.g., less than 2MB)
        if ($_FILES["image"]["size"] > 2000000) {
            echo json_encode(array('status' => 'fail', 'message' => 'Sorry, your file is too large.'));
            $uploadOk = 0;
        }

        // Allow only certain file formats
        if (!in_array($imageFileType, array('jpg', 'jpeg', 'png', 'gif'))) {
            echo json_encode(array('status' => 'fail', 'message' => 'Sorry, only JPG, JPEG, PNG & GIF files are allowed.'));
            $uploadOk = 0;
        }

        // If $uploadOk is set to 1, try to upload the file
        if ($uploadOk == 1) {
            if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
                // Update tour information
                $stmtUpdate = $con->prepare("UPDATE tour SET description = ?, start_date = ?, end_date = ?, price = ?, image_url = ? WHERE name = ?");
                $success = $stmtUpdate->execute([$description, $start_date, $end_date, $price, $target_file, $name]);

                if ($success) {
                    echo json_encode(array('status' => 'success', 'message' => 'Tour information updated successfully.'));
                } else {
                    echo json_encode(array('status' => 'fail', 'message' => 'Failed to update tour information.'));
                }
            } else {
                echo json_encode(array('status' => 'fail', 'message' => 'Sorry, there was an error uploading your file.'));
            }
        }
    } else {
        // If the tour is not found, return a fail state
        echo json_encode(array('status' => 'fail', 'message' => 'Tour not found.'));
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'Name, description, start date, end date, price, and image are required.'));
}
?>
