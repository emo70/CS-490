<?php
    $decode = file_get_contents('php://input');
    $data = json_decode($decode, true);

    $data_obj = json_encode($data,true);
    
    // Curls to Our Database
    function curl_backend($data){
        $url = "localhost/test/back/login.php";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        //curl_setopt($ch, CURLOPT_HEADER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION,true);
        $result = curl_exec($ch);
        curl_close($ch);
        return $result; 
    }


    // Curls to the Njit Database
    function curl_njit($data){
        $url = "https://myhub.njit.edu/vrs/ldapAuthenticateServlet";
        $data = "user_name=" . $data['username'] . "&passwd=" . $data['password'] . "&SUBMIT=Login";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        //curl_setopt($ch, CURLOPT_HEADER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION,true);
        
        $result = curl_exec($ch);
        curl_close($ch);
        //return $result;

        if(strpos($result,"Invalid UCID/Password") !==false){
            return json_encode("No User in NJIT system");
        }else{
            return json_encode("NJIT Login Success");
        }
        
    }

    $njit = curl_njit($data);
    $back = curl_backend($data_obj);
    print "<center>"."DB Login: ".$back.'<br>'."NJIT Login: ".$njit."</center>";

?>