<?php 
  function dbconnection()
  {
      $con = mysqli_connect('localhost', 'hangout1_topkittipoom', 'hangout2021', "hangout1_hangout");
      return $con;
  }
?>