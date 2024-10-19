// ignore_for_file: constant_identifier_names

const String linkServerName = "http://etourism13.atwebpages.com";
const String linkServerName2 = "http://etourism.free.nf/etourism";
//"http://etourism13.atwebpages.com";
//"http://10.0.2.2/etourism";
//  "http://etourism.free.nf/etourism";

// Auth######
// روابط تسجيل الدخول والتسجيل
const String linkSignUp = '$linkServerName/auth/signup.php';
const String linkLogin = '$linkServerName/auth/login.php';
const String linkForgotPassword = '$linkServerName/auth/forget.php';
const String linkAdminLogin = '$linkServerName/auth/adminlogin.php';
const String linkimage = '$linkServerName2/admin/programme/';
const String linkimagetour = '$linkServerName2/admin/tour/';
// Admin
// driver
const String driverAdd = '$linkServerName/admin/driver/add.php';
const String driverDelete = '$linkServerName/admin/driver/delete.php';
const String driverUpdate = '$linkServerName/admin/driver/edit.php';
const String driverView = '$linkServerName/admin/driver/view.php';
// guide
const String guideAdd = '$linkServerName/admin/guide/add.php';
const String guideDelete = '$linkServerName/admin/guide/delete.php';
const String guideUpdate = '$linkServerName/admin/guide/edit.php';
const String guideView = '$linkServerName/admin/guide/view.php';
// tour
const String tourAdd = '$linkServerName/admin/tour/add.php';
const String tourDelete = '$linkServerName/admin/tour/delete.php';
const String tourUpdate = '$linkServerName/admin/tour/edit.php';
const String tourView = '$linkServerName/admin/tour/view.php';
// programme
const String programmeAdd = '$linkServerName/admin/programme/add.php';
const String programmeDelete = '$linkServerName/admin/programme/delete.php';
const String programmeUpdate = '$linkServerName/admin/programme/edit.php';
const String programmeView = '$linkServerName/admin/programme/view.php';
const String programmesGet =
    '$linkServerName/admin/programme/programmesGet.php';
// tourist
const String touristAdd = '$linkServerName/admin/tourist/add.php';
const String touristDelete = '$linkServerName/admin/tourist/delete.php';
const String touristUpdate = '$linkServerName/admin/tourist/edit.php';
const String touristView = '$linkServerName/admin/tourist/view.php';

// روابط لاسترجاع بيانات السائقين والمرشدين
const String driversGet = '$linkServerName/admin/driversGet.php';
const String guidesGet = '$linkServerName/admin/guidesGet.php';
const String report = '$linkServerName/admin/report.php';
// رابط رفع الصور
const String imageUpload = '$linkServerName/admin/imageUpload.php';

// رابط لاسترجاع البرامج مع معلومات السائق والمرشد والجولات
const String getdata = '$linkServerName/user/getdata.php';
const String getdataspecific = '$linkServerName/user/getdataspecific.php';
const String gettour = '$linkServerName/user/gettour.php';
const String searchtour = '$linkServerName/user/searchtour.php';
const String viewtour = '$linkServerName/user/viewtour.php';
const String book = '$linkServerName/user/book.php';
// رابط لاسترجاع البرامج
const String programmeGet = '$linkServerName/user/programmeGet.php';
