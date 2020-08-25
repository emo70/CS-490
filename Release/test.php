<?php

$myfile = fopen("test.py", "w") or die("Unable to write to file test.py!");
fwrite($myfile, "fullprogram2");
fclose($myfile);
echo 'done';
  
?>