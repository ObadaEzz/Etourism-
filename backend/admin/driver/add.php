<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include "../../connect.php";

if (
    isset($_POST["driverName"]) &&
    isset($_POST["fName"]) &&
    isset($_POST["lName"]) &&
    isset($_POST["plateNumber"]) &&
    isset($_POST["description"])
) {
    
    $driverName = htmlspecialchars(strip_tags($_POST["driverName"]));
    $fName = htmlspecialchars(strip_tags($_POST["fName"]));
    $lName = htmlspecialchars(strip_tags($_POST["lName"]));
    $plateNumber = htmlspecialchars(strip_tags($_POST["plateNumber"]));
    $description = htmlspecialchars(strip_tags($_POST["description"]));

    // Check if driver already exists based on driverName
    $checkStmt = $con->prepare("SELECT * FROM driver WHERE driverName = ?");
    $checkStmt->execute([$driverName]);

    if ($checkStmt->rowCount() > 0) {
        // If driver with same name exists
        echo json_encode(array('status' => 'fail', 'message' => 'Driver already exists.'));
    } else {
        // Prepare query to add driver
        $stmt = $con->prepare("INSERT INTO driver (driverName, fName, lName, plateNumber, description) VALUES (?, ?, ?, ?, ?)");

        // Execute query
        if ($stmt->execute([$driverName, $fName, $lName, $plateNumber, $description])) {
            echo json_encode(array('status' => 'success', 'message' => 'Driver added successfully.'));
        } else {
            echo json_encode(array('status' => 'fail', 'message' => 'Failed to add driver.'));
        }
    }
} else {
    echo json_encode(array('status' => 'empty', 'message' => 'All fields are required.'));
}
?>
