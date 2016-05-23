<?php
// output headers so that the file is downloaded rather than displayed
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=data.csv');

// create a file pointer connected to the output stream
$output = fopen('php://output', 'w');

// output the column headings
fputcsv($output, array('date','ID', 'Phrase'));

// fetch the data
mysql_connect('mysql51-132.perso', 'moumoutesms', 'xxxxxx);
mysql_select_db('moumoutesms');
$rows = mysql_query('SELECT date,id,phrases FROM smswall');

// loop over the rows, outputting them
while ($row = mysql_fetch_assoc($rows)) fputcsv($output, $row);
?>