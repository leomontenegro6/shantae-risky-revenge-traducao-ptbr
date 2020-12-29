<?php
$handle = fopen("./3 - traduzidos/ShantaeText.loctext.txt", "r");
if ($handle === false) {
    die('Erro ao abrir arquivos');
}

$whiteColorTag = false;

while (($line = fgets($handle)) !== false) {
	$chars = str_split($line);
	foreach($chars as $i=>$char){
		if($char == '#'){
			if($whiteColorTag === true){
				$whiteColorTag = false;
			} else {
				$whiteColorTag = true;
			}
			continue;
		}
		
		if($whiteColorTag === true){
			echo $char;
		}
	}
	echo PHP_EOL;
}

fclose($handle);
