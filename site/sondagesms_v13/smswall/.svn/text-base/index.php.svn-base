
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
?>



<!-- Début de la page html -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>

<!-- Jeux de caractères utilisés -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<!-- Diverses infos -->
<meta http-equiv="Content-Language" content="fr"/>
<meta http-equiv="imagetoolbar" content="no" />
<meta name="Distribution" content="Global"/>
<meta name="Rating" content="General"/>
<meta name="robots" content="none"/>
<link rel="icon" type="image/gif" href="../favicon.gif" />
<link rel="shortcut icon" type="image/gif" href="../favicon.gif" />

<!-- Références auteurs & licence, description -->
<meta name="author" content="Julien Rat & Marpa - CC BY-SA 3.0">
<meta name="description" content="SMS Wall : un mur pour afficher vos messages"/>
<meta name="abstract" content="SMS Wall : un mur pour afficher vos messages"/>


<!-- Titre de la fenêtre -->
<title>SMS Wall</title>

<!-- Styles généraux -->
<link rel="stylesheet" href="../general.css">

<!-- Styles spécifiques à la page -->
	<style type="text/css">
		#mur #page { min-height: 91.3%; }
		#mur h2 { position: fixed; margin-top: 25px; }
	</style>

</head>


<body id="mur">


<div id="bandeau">
<a href="../index.php" title="Retourner à la liste des outils de sondages"><img src="../favicon.gif" height="20px" /></a>
<h1>SMS Wall</h1>
</div>


<div id="page">
	<div id="cache"></div>


	<!-- Affichage du titre -->
<?php	
if ($data = mysql_fetch_assoc($titre)) {
    // on affiche le titre
    echo "<h2>".$data['titre']."</h2>";
    }
	else {
  echo "<h2>Il n'y a pas de sondage existant pour l'instant</h2>";
}
?>


	<!-- Affichage de chaque SMS -->
	<div id="messages">
<?php	
	while($data = mysql_fetch_assoc($result))
    {
    // on affiche les informations de l'enregistrement en cours
    	if($data['phrases']!=""){
	$nombre_mess++;
    echo "<p>".$data['phrases']."</p>";
	}
    }
?>
	</div>


	<!-- Affichage du nombre de messages -->
<?php	
echo "<div id='details'>".$nombre_mess." messages</div>";
?>


	<!-- Affichage du nuage de tags du mur -->
	<a href="nuage.php" id="voirnuage">Voir le nuage de mots de votre mur</a>



<!-- Fin div page -->
</div>


<!-- Mention CC BY-SA -->
<div id="mention">
	<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.fr">
	<img alt="Licence Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" height="20px" /></a> 
	<span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">SMS Wall</span>
	 de 
	<span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Julien Rat & Marpa</span>
	 est mis à disposition selon les termes de la <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.fr">licence Creative Commons Attribution -  CC BY-SA 3.0</a>.
</div>


</body>
</html>

