<?php

include('dbconnection.php');
$con=dbconnection();


if (isset($_POST["data"])) {
    $data=$_POST["data"];
} else return;

if (isset($_POST["nameImage"])) {
    $nameImage=$_POST["nameImage"];
} else return;


$path="store/$nameImage"; //ที่อยู่ไฟล์

//$query= "INSERT INTO `usertable`(`imageTable`) VALUES ('$path')";

file_put_contents($path,base64_decode($data)); //อัพโหลด

$arr=[];
$exe=mysqli_query($con);
if($exe) {
  $arr["success"] = "true";

} else 
    $arr["success"] = "false";

    print(json_decode($arr));

?>