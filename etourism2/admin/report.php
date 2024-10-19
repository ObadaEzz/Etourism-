<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include "../connect.php"; 

// تحقق مما إذا كانت تواريخ البداية والنهاية موجودة في POST
if (!isset($_POST['start_date']) || !isset($_POST['end_date'])) {
    echo json_encode(array('status' => 'fail', 'message' => 'Start date or end date not provided.'));
    exit();
}

$start_date = $_POST['start_date'];
$end_date = $_POST['end_date'];

$stmt = $con->prepare("SELECT d.driverName, d.plateNumber, COUNT(t.tour_id) AS total_tours
                       FROM driver d
                       LEFT JOIN programme p ON d.driver_id = p.driver_id
                       LEFT JOIN tour t ON p.programme_id = t.programme_id
                       WHERE t.start_date BETWEEN :start_date AND :end_date
                       GROUP BY d.driver_id
                       ORDER BY total_tours DESC");
                       
$stmt->bindParam(':start_date', $start_date, PDO::PARAM_STR);
$stmt->bindParam(':end_date', $end_date, PDO::PARAM_STR);
$stmt->execute();

$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);

if ($reports) {
    echo json_encode(array('status' => 'success', 'data' => $reports));
} else {
    echo json_encode(array('status' => 'fail', 'message' => 'No tours found for the specified date range.'));
}
?>
