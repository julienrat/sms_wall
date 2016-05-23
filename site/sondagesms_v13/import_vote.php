<?php 

//connect to the database
$connect = mysql_connect('mysql51-132.perso', 'moumoutesms', 'xxxx');
mysql_select_db('moumoutesms',$connect);

//

if ($_FILES[csv][size] > 0) {

    //get the csv file
    $file = $_FILES[csv][tmp_name];
    $handle = fopen($file,"r");
    
    //loop through the csv file and insert into database
    do {
        if ($data[0]) {
            mysql_query("INSERT INTO smswall (date, id, phrases) VALUES
                (
                    '".addslashes($data[0])."',
                    '".addslashes($data[1])."',
                    '".addslashes($data[2])."'
                )
            ");
        }
    } while ($data = fgetcsv($handle,1000,",","\n"));
    //

    //redirect
    header('Location: import_vote.php?success=1'); die;

}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Importez vos votes sauvegardés</title>
</head>

<body>

<?php if (!empty($_GET[success])) { echo "<b>Vos votes on étés réimportés </b><br><br>"; } //generic success notice ?>

<form action="" method="post" enctype="multipart/form-data" name="form1" id="form1">
  Choisissez votre fichier : <br />
  <input name="csv" type="file" id="csv" />
  <input type="submit" name="Submit" value="envoyer" />
</form>

</body>
</html> 