<?php

    $decode = file_get_contents('php://input');
    $data = json_decode($decode, true);
    

    $username = $data['username'];
    $password = $data['password'];
    $dataArray = array(
        "username" => $username,
        "password" => $password
    );
    echo curl($dataArray);
    
    // Take whatever data thats being passed in, encode it as json to be curled over to the middle end
    function curl ($data){
        $url = "localhost/test/middle/login.php";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data,true));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        //curl_setopt($ch, CURLOPT_HEADER, true);
        $result = curl_exec($ch);
        curl_close($ch);
        return $result;
    }

?>