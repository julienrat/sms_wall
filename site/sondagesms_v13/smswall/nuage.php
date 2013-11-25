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
<meta name="description" content="Le nuage du mur de SMS"/>
<meta name="abstract" content="Le nuage du mur de SMS"/>


<!-- Titre de la fenêtre -->
<title>Le nuage de tags de votre mur de sms</title>

<!-- Styles généraux -->
<link rel="stylesheet" href="../general.css">

<!-- Styles spécifiques à la page -->
	<style type="text/css">
		canvas { display: block; margin: 0 auto; font-family: monospace; }
		body#nuagetags { background: #fff; }
		#nuagetags #page { width:100%; padding: 0; min-height: 95%; background-color: #fff }
	</style>

</head>
<body id="nuagetags">

<div id="bandeau">
<a href="../index.php" title="Retourner à la liste des outils de sondages"><img src="../favicon.gif" height="20px" /></a>
<h1>Nuage de mots de votre mur</h1>
</div>

<div id="page">

<canvas id="result" width="800" height="600"></canvas>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script type="text/javascript" src="nuage/jquery.wordcloud.js"></script>
<script type="text/javascript">
jQuery(function ($) {

	var $r = $('#result');

	$(function () {
			try {

				$r.wordCloud({
					database: {
						dbHost: 'localhost',
						dbUser: 'sondagesms',
						dbPass: '',
						dbName: 'sondagesms',
						selectFields: 'phrases',
						tableName: 'smswall',
						where: $('#where').val(),
						maxWords: '300',
						excludedWords: $('#excludedWords').val()
					},
					wordCountUrl: 'nuage/wordcounter.php',
					biggestWord: '100',
					shape: 'circle'
				});
			} catch (e) { alert(e); }
		}
	);


});

</script>


<!-- Fin div page -->
</div>


<!-- Retour au mur de sms -->
<div id="mention">
	<a href="index.php">Retour au mur de sms</a>.
</div>

</body>
</html>
