<?php 

// if called from command line, parse parameters into REQUEST first
if(defined('STDIN')) {
	parse_str(implode('&', array_slice($argv, 1)), $_REQUEST);
}

function getParameter($paramName, $ifNull = false) {
	if (isset($_REQUEST[$paramName]) && strlen($_REQUEST[$paramName]) > 0) {
		return $_REQUEST[$paramName];
	} else if ($ifNull === false) {
		// parameter is required
		die($paramName . " is required");
	} else {
		return $ifNull;
	}
}

include_once "connections.php";

$db_host = getParameter("dbHost",$_GLOBALS['mysqlconn']['host']);
$db_user = getParameter("dbUser",$_GLOBALS['mysqlconn']['user']);
$db_pass = getParameter("dbPass",$_GLOBALS['mysqlconn']['pass']);
$db_name = getParameter("dbName");

$select_fields = getParameter("selectFields","*");
$table_name = getParameter("tableName");
$where_clause = getParameter("where","TRUE");
$limit = getParameter("limit", "5000");
$order = getParameter("order", "NULL");

$excluded_words = getParameter("excludedWords","");
$max_words = getParameter("maxWords","0");
if (is_numeric($max_words)) {
	$max_words = intval($max_words);
	if ($max_words == 0) {
		$max_words = NULL;
	}
} else {
	die('maxWords must be numeric');
}

$query = <<<EOD
	SELECT
		$select_fields
	FROM
		$table_name
	WHERE $where_clause
	ORDER BY $order
	LIMIT $limit
		
EOD;

$db = new PDO(
	'mysql:host='.$db_host.';dbname='.$db_name.';charset=utf8', 
	$db_user,
	$db_pass
);
	
try {
	$stmt = $db->query($query);

	if (! $stmt) {
		$err = $db->errorInfo();
	
		throw new Exception($err[2]);
	}
	
	$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $pde) {
	die("MySQL Error : ".$pde);
} catch (Exception $e) {
	die("Exception : ".$e);
}

class WordCount {
	public $word = "";
	public $count = 0;
	
	function __construct($word, $count=1) {
		$this->word = $word;
		$this->count = $count;
	}
	
	function increment($inc = 1) {
		$this->count += $inc;
	}
	
	function checkWord($newWord) {
		if (strlen($this->word) > strlen($newWord)) {
			$this->word = $newWord;
		}
	}
}

function clean_string($str) {
	$str = preg_replace("#https?:?//[^\s]*#", "", $str);
	$str = strip_tags($str);
	$str = preg_replace("/&#?[0-9a-zA-Z]*;/","", $str);
	$str = preg_replace("/[#@\"!\(\):;?,\.]/", "", $str);
	
	return strtolower($str);
}

require_once "porter.php";
include_once "stopwords.php";

$delim = " ";

// add specified excluded words to stop words
$stop_tok = strtok(clean_string($excluded_words), $delim);
while ($stop_tok !== false) {
	$stopWords[] = trim(strtolower(PorterStemmer::Stem($stop_tok)));
	$stop_tok = strtok($delim);
}


$words = Array();

foreach($data as $data_item) {
// 	echo "Original : " . $data_item["text"] . "<br>";
	$clean_text = "";
	
	foreach($data_item as $field => $val) {
		$clean_text .= " " . clean_string($val);
	}
	
// 	echo "Clean : " . $clean_text . "<hr>";
	$tok = strtok($clean_text, $delim);
	
	while ($tok !== false) {
	    $stem = trim(strtolower(PorterStemmer::Stem($tok)));
	    
	    if (in_array($stem, $stopWords) || strlen($stem) < 3) {
	    	$tok = strtok($delim);
	    	continue;
	    }
	    
	    if (array_key_exists($stem, $words)) {
	    	$words[$stem]->checkWord($tok);
	    	$words[$stem]->increment();
	    } else {
	    	$words[$stem] = new WordCount($tok);
	    }
	    
	    $tok = strtok($delim);
	}
}

usort($words, function($a, $b) {
	return $a->count < $b->count;
});

$words = array_slice($words, 0, $max_words);

echo json_encode(array_map(function($word) {
	return Array($word->word,$word->count);
}, $words));

?>
