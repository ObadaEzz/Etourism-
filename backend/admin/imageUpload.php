<?php
// API: upload.php
header('Content-Type: application/json');

include '../connect2.php'; // ملف يحتوي على الاتصال بقاعدة البيانات

// تحقق من رفع الملف
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    // إعدادات مسار رفع الصور
    $uploadDir = 'uploads/images/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true); // إنشاء المجلد إذا لم يكن موجودًا
    }

    // اسم الملف
    $fileName = basename($_FILES['image']['name']);
    $uploadFilePath = $uploadDir . $fileName;

    // تحقق من رفع الملف بنجاح
    if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadFilePath)) {
        $imageUrl = 'http://etourism.free.nf/etourism/' . $uploadFilePath; // رابط الصورة

        echo json_encode([
            'status' => 'success',
            'image_url' => $imageUrl
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to upload image'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'No image uploaded or an error occurred'
    ]);
}
?>
