<?php


class Message
{

    function __construct()
    {
    }


    function getMessagesByTopic($params)
    {

        $sql = "select m.text, DATE_FORMAT(m.date_creation, '%d/%m/%Y %T') as 'date_creation', u.nickname, m.show_message, ";
        $sql .= "u.avatar, DATE_FORMAT(u.last_connection, '%d/%m/%Y %T') as last_connection,  DATE_FORMAT(u.registry_date, '%d/%m/%Y') as registry_date, mp.message_index ";
        $sql .= "from messages m, messages_public mp, users u ";
        $sql .= "where m.id = mp.id_message and ";
        $sql .= "u.id = m.user_origin and ";
        $sql .= "mp.id_topic = " . filter_var($params['id_topic'], FILTER_SANITIZE_NUMBER_INT) . " ";
        $sql .= "order by m.date_creation ";
        $sql .= "LIMIT " . ($params['page'] - 1) * NUM_ITEMS_PAG . "," . NUM_ITEMS_PAG;

        $db = new MySQLDB();

        $data['messages'] = $db->getData($sql);

        $data["pag"] = $params['page'];
        $data['id_topic'] = $params['id_topic'];

        $sql = "SELECT title, open ";
        $sql .= "FROM topics ";
        $sql .= "WHERE id = " . $params['id_topic'];

        $data_single = $db->getDataSingle($sql);

        if ($data_single) {
            $data['title_topic'] = $data_single['title'];
            $data['open_topic'] = $data_single['open'];
        }

        $sql = "select count(*) as num_messages ";
        $sql .= "from messages m, messages_public mp, users u ";
        $sql .= "where m.id = mp.id_message and ";
        $sql .= "u.id = m.user_origin and ";
        $sql .= "mp.id_topic = " . $params['id_topic'] . " ";

        $data_single = $db->getDataSingle($sql);

        if ($data_single) {
            $data['num_messages'] = $data_single['num_messages'];
        }

        $data['last_page'] = ceil($data['num_messages'] / NUM_ITEMS_PAG);

        $data['url_base'] = "MessageController/display/" . $data['id_topic'];

        $db->close();

        return $data;
    }

    function reply_topic($params)
    {

        $db = new MySQLDB();

        $sql = "INSERT INTO messages VALUES (";
        $sql .= "null, ";
        $sql .= "'" . $params['text'] . "', ";
        $sql .= "'" . today() . "' , ";
        $sql .= $params['id_user'] . ", ";
        $sql .=  "1 ";
        $sql .= ")";

        $success = $db->executeInstruction($sql);

        if ($success) {

            $id_message = $db->getLastId();

            $sql = "SELECT (count(*) + 1) as num_index ";
            $sql .= "FROM messages_public ";
            $sql .= "WHERE id_topic = " . $params['id_topic'];

            $num_index = $db->getDataSingle($sql)['num_index'];

            $sql = "INSERT INTO messages_public VALUES (";
            $sql .= $id_message . ", ";
            $sql .= $params['id_topic'] . ", ";
            $sql .= $num_index;
            $sql .= ")";

            $success = $db->executeInstruction($sql);

            $data['id_message'] = $id_message;
        }

  

        $data['success'] = $success;

        $db->close();


        return $data;
    }

    function is_open_topic($params)
    {

        $db = new MySQLDB();

        $sql = "SELECT open ";
        $sql .= "FROM topics ";
        $sql .= "WHERE id = " . $params['id_topic'];

        $data_single = $db->getDataSingle($sql);

        $db->close();
        if ($data_single) {
            return $data_single['open'] == tTRUE;
        }

        return false;
    }

    function notifyNoReadMessages($params)
    {

        $db = new MySQLDB();

        $sql = "SELECT DISTINCT m.user_origin ";
        $sql .= "FROM messages m, messages_public mp ";
        $sql .= "WHERE m.id = mp.id_message ";
        $sql .= "and mp.id_topic = " . $params['id_topic'] . " ";
        $sql .= "and m.user_origin <> " . $params['id_user'];

        $datadb = $db->getData($sql);

        foreach ($datadb  as $key => $value) {
            
            $sql = "INSERT INTO unread_messages_public VALUES( ";
            $sql .= $value['user_origin'] . ", ";
            $sql .= $params['id_topic'] . ", ";
            $sql .= $params['id_message'] . "); ";

            print($sql);

            $db->executeInstruction($sql);

        }

        $db->close();

        $data = array();

        $data['success'] = true;

        return $data;
    }
}
