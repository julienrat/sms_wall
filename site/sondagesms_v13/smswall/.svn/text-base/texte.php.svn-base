<?php
//Rafraichissement de la page

$page = $_SERVER['PHP_SELF'];
$sec = "10";
header("Refresh: $sec; url=$page#details");


//Connexion à la base de données
$nombre_mess=0;
$mysql_hostname = "localhost";
$mysql_user     = "sondagesms";
$mysql_password = "";
$mysql_database = "sondagesms";
$titre="";
$bd             = mysql_connect($mysql_hostname, $mysql_user, $mysql_password) or die("Oops quelque chose ne s'est pas passé comme il faut");
mysql_select_db($mysql_database, $bd) or die("Oops quelque chose ne s'est pas passé comme il faut");

//récuperation des infos

$result = mysql_query("SELECT phrases FROM smswall");
$titre=mysql_query("SELECT titre FROM smswall ORDER BY ID DESC LIMIT 0, 1");	

	$data = mysql_fetch_assoc($titre);
{
    // on affiche le titre
    echo "<h1>";
    echo $data['titre'];
    echo "</h1>";

}

	while($data = mysql_fetch_assoc($result))
    {
    // on affiche les informations de l'enregistrement en cours
    	if($data['phrases']!=""){
	$nombre_mess++;
    echo "<p>".$data['phrases']."</p>";
	}

    }
?>
