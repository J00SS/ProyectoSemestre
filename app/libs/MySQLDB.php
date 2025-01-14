<?php

class MySQLDB {

    private $host = "localhost";
    private $usuario = "root";
    private $pass = "12345678";
    private $db = "foro";

    private $connection;

    function __construct()
    {
        
        $this->connection = mysqli_connect(
            $this->host, 
            $this->usuario, 
            $this->pass, 
            $this->db
        );

        $this->connection->set_charset("utf8");

        if(mysqli_connect_errno()){
            print("error al conectarse");
        }

    }

    function getData($sql){
        $data = array();
        $result = mysqli_query($this->connection, $sql);
        if(mysqli_num_rows($result) > 0){
            while($row = mysqli_fetch_assoc($result)){
                array_push($data, $row);
            }
        }
        return $data;
    }

    function numRows($sql){
        $result = mysqli_query($this->connection, $sql);
        return mysqli_num_rows($result);
    }

    function getDataSingle($sql){
        
        $result = mysqli_query($this->connection, $sql);
        if(mysqli_num_rows($result) > 0){
            return mysqli_fetch_assoc($result);
        }
        return null;
    }

    function executeInstruction($sql){
        return mysqli_query($this->connection, $sql);
    }

    function close(){
        mysqli_close($this->connection);
    }

    function getLastId(){
        return mysqli_insert_id($this->connection);
    }

}


?>