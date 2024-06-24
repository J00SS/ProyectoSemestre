<?php

class AdminTopicController extends Controller
{
    private $model;
    private $modelCategory;

    function __construct()
    {
        $this->model = $this->model("AdminTopic");
        $this->modelCategory = $this->model("AdminCategory");
    }

    function display()
    {
        isLogged();

        $data = $this->model->getTopics();

        $this->view("AdminTopicView", $data);
    }

    function display_edit($id_topic)
    {
        isLogged();

        $data = $this->model->getTopic($id_topic);

        $data['display_edit'] = true;

        $params = array(
            'mode' => ONLY_CHILDS
        );

        $data['categories'] = $this->modelCategory->getCategories($params)['categories'];

        $this->view("AdminTopicView", $data);
    }

    function edit_topic()
    {
        isLogged();

        if (isset($_POST) && $_SERVER['REQUEST_METHOD'] == "POST") {

            if (isset($_POST['action'])) {

                $params = array(
                    'title' => $_POST['title'],
                    'category' => $_POST['category'],
                    'id' => $_POST['id']
                );

                $this->model->edit_topic($params);
            }
            header("Location: index.php?url=AdminTopicController/display");
        }
    }

    function toggle_topic_status($id_topic)
    {
        isLogged();

        $this->model->toggle_topic_status($id_topic);

        header("Location: index.php?url=AdminTopicController/display");
    }
}
