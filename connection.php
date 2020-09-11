<?php
$servername = "localhost";
$username = "root";
$password = "DBp@ssw0rd";

// Create connection
$conn = new mysqli($servername, $username, $password);
 

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
//echo "Connected successfully </br></br>";

$sql = "use sentinel;";
if ($conn->query($sql) === TRUE) {
  // echo " Database selected </br></br> ";
} else {
  echo "Error creating database: " . $conn->error;
}





/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
$sql = "insert into userinfo values(71);";
if ($conn->query($sql) === TRUE) {
  echo " Value Entered Successfully";
} else {
  echo "Error creating database: " . $conn->error;
}



//FETCH DATA

  $sql = $conn->
      query("SELECT * FROM userinfo");


$result = array();
 while ($fetchdata=$sql->fetch_assoc()) {
      $result[] = $fetchdata;
  }

echo json_encode($result);	
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
?>



