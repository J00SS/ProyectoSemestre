-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-06-2024 a las 07:07:20
-- Versión del servidor: 8.0.35
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `foro`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `name` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `description` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `parent_cat` int NOT NULL,
  `icon` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `num_topics` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `parent_cat`, `icon`, `num_topics`) VALUES
(1, 'Carrera', '', 1, '', 0),
(2, 'Ingeniería de Sistemas', '', 1, '', 0),
(3, 'Psicología', '', 1, '', 0),
(4, 'Administración de Empresas', '', 1, '', 0),
(5, 'Derecho', '', 1, '', 0),
(6, 'Auditoría', 'Información útil sobre el foro', 1, '', 0),
(8, 'General', 'Hilos', 2, '', 1),
(9, 'General', 'Hilos', 3, '', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages`
--

CREATE TABLE `messages` (
  `id` int NOT NULL,
  `text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `date_creation` datetime NOT NULL,
  `user_origin` int NOT NULL,
  `show_message` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `messages`
--

INSERT INTO `messages` (`id`, `text`, `date_creation`, `user_origin`, `show_message`) VALUES
(1, '', '2024-06-09 08:59:00', 1, 1),
(2, '', '2024-06-09 09:00:00', 1, 1),
(3, '<p>no xd</p>', '2024-06-09 09:00:00', 1, 1),
(4, '<p>123</p>', '2024-06-09 19:59:00', 1, 1),
(5, '<p>123</p>', '2024-06-09 20:03:00', 2, 1),
(6, 'xd', '2024-06-09 21:12:00', 1, 1),
(7, '<p>a</p>', '2024-06-09 22:03:00', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages_private`
--

CREATE TABLE `messages_private` (
  `id_message` int NOT NULL,
  `user_destiny` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages_public`
--

CREATE TABLE `messages_public` (
  `id_message` int NOT NULL,
  `id_topic` int NOT NULL,
  `message_index` int DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `messages_public`
--

INSERT INTO `messages_public` (`id_message`, `id_topic`, `message_index`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 1, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `rol` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `rol`) VALUES
(1, 'admin'),
(2, 'user');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `topics`
--

CREATE TABLE `topics` (
  `id` int NOT NULL,
  `title` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `date_creation` datetime NOT NULL,
  `creator_user` int NOT NULL,
  `open` int NOT NULL,
  `views` int NOT NULL,
  `id_cat` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `topics`
--

INSERT INTO `topics` (`id`, `title`, `date_creation`, `creator_user`, `open`, `views`, `id_cat`) VALUES
(1, 'ayuda', '2024-06-09 08:59:00', 1, 1, 0, 8);

--
-- Disparadores `topics`
--
DELIMITER $$
CREATE TRIGGER `update_num_topics_delete` AFTER DELETE ON `topics` FOR EACH ROW BEGIN
    
    declare num_topics_update int(11);
    	
    SELECT count(*) into num_topics_update FROM topics WHERE id_cat = OLD.id_cat;
    
   	UPDATE categories SET num_topics = num_topics_update where id = OLD.id_cat;
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_num_topics_insert` AFTER INSERT ON `topics` FOR EACH ROW BEGIN
    
    declare num_topics_update int(11);
    	
    SELECT count(*) into num_topics_update FROM topics WHERE id_cat = NEW.id_cat;
    
   	UPDATE categories SET num_topics = num_topics_update where id = NEW.id_cat;
   
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_num_topics_update` AFTER UPDATE ON `topics` FOR EACH ROW BEGIN
    
    declare num_topics_update int(11);
    
    SELECT count(*) into num_topics_update FROM topics WHERE id_cat = NEW.id_cat;
    
    UPDATE categories SET num_topics = num_topics_update where id = NEW.id_cat;
        
    SELECT count(*) into num_topics_update FROM topics WHERE id_cat = OLD.id_cat;
    
    UPDATE categories SET num_topics = num_topics_update where id = OLD.id_cat;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unread_messages_public`
--

CREATE TABLE `unread_messages_public` (
  `id_user` int NOT NULL,
  `id_topic` int NOT NULL,
  `id_message` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `unread_messages_public`
--

INSERT INTO `unread_messages_public` (`id_user`, `id_topic`, `id_message`) VALUES
(2, 1, 6),
(2, 1, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unread_message_private`
--

CREATE TABLE `unread_message_private` (
  `id_message` int NOT NULL,
  `id_user_destiny` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `surname` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `nickname` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `email` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `pass` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `registry_date` date NOT NULL,
  `avatar` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL,
  `rol` int NOT NULL,
  `last_connection` datetime NOT NULL,
  `baneado` int NOT NULL,
  `borrado` int NOT NULL,
  `verificado` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `surname`, `nickname`, `email`, `pass`, `registry_date`, `avatar`, `rol`, `last_connection`, `baneado`, `borrado`, `verificado`) VALUES
(1, 'Jose', 'Sarmiento', 'J0S', 'josemanuel312661@gmail.com', '417fb5ea19867ed49e87b65622ae85a16ae7984689bfe93e4b68a6885bd2d5dbe2ad60b6783c75780a5f14be034be9f154a507c2ffa319a682f29e2e8b7501cf', '2024-06-02', 'http://localhost/foro/public/img/default-avatar.jpg', 1, '2024-06-06 00:00:00', 0, 0, 1),
(2, 'ter', 'fer', 'JS', 'email@email.com', '417fb5ea19867ed49e87b65622ae85a16ae7984689bfe93e4b68a6885bd2d5dbe2ad60b6783c75780a5f14be034be9f154a507c2ffa319a682f29e2e8b7501cf', '2024-06-02', 'http://localhost/foro/public/img/default-avatar.jpg', 2, '2024-06-06 20:09:00', 0, 0, 1),
(3, 'fer', 'er', 'fer', 'fer@fer.es', '417fb5ea19867ed49e87b65622ae85a16ae7984689bfe93e4b68a6885bd2d5dbe2ad60b6783c75780a5f14be034be9f154a507c2ffa319a682f29e2e8b7501cf', '2024-06-02', 'http://localhost/foro/public/img/default-avatar.jpg', 2, '2024-06-06 19:19:00', 0, 0, 1),
(15, 'a', 'aa', 'aaa', 'aaaa@amail.com', '417fb5ea19867ed49e87b65622ae85a16ae7984689bfe93e4b68a6885bd2d5dbe2ad60b6783c75780a5f14be034be9f154a507c2ffa319a682f29e2e8b7501cf', '2024-06-10', 'http://localhost/foro/public/img/default-avatar.jpg', 2, '2024-06-10 05:32:00', 0, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_activation`
--

CREATE TABLE `users_activation` (
  `id_user` int NOT NULL,
  `user_key` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_remember`
--

CREATE TABLE `users_remember` (
  `id_user` int NOT NULL,
  `user_key` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

--
-- Volcado de datos para la tabla `users_remember`
--

INSERT INTO `users_remember` (`id_user`, `user_key`) VALUES
(14, 'aWfn01PD68pkuQ322vFY');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categories_parent_cat` (`parent_cat`);

--
-- Indices de la tabla `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_messages_user_origin` (`user_origin`);

--
-- Indices de la tabla `messages_private`
--
ALTER TABLE `messages_private`
  ADD PRIMARY KEY (`id_message`),
  ADD KEY `fk_messages_private_id_user` (`user_destiny`);

--
-- Indices de la tabla `messages_public`
--
ALTER TABLE `messages_public`
  ADD PRIMARY KEY (`id_message`,`id_topic`),
  ADD KEY `fk_messages_public_id_topic` (`id_topic`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_topics_id_user` (`creator_user`),
  ADD KEY `fk_topics_id_cat` (`id_cat`);

--
-- Indices de la tabla `unread_messages_public`
--
ALTER TABLE `unread_messages_public`
  ADD PRIMARY KEY (`id_user`,`id_topic`,`id_message`),
  ADD KEY `fk_unread_messages_public_id_message` (`id_message`),
  ADD KEY `fk_unread_messages_public_id_topic` (`id_topic`);

--
-- Indices de la tabla `unread_message_private`
--
ALTER TABLE `unread_message_private`
  ADD KEY `fk_unread_messages_private_id_message` (`id_message`),
  ADD KEY `fk_unread_messages_private_id_user` (`id_user_destiny`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_users_id_rol` (`rol`);

--
-- Indices de la tabla `users_activation`
--
ALTER TABLE `users_activation`
  ADD PRIMARY KEY (`id_user`);

--
-- Indices de la tabla `users_remember`
--
ALTER TABLE `users_remember`
  ADD PRIMARY KEY (`id_user`,`user_key`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_categories_parent_cat` FOREIGN KEY (`parent_cat`) REFERENCES `categories` (`id`);

--
-- Filtros para la tabla `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_messages_user_origin` FOREIGN KEY (`user_origin`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `messages_private`
--
ALTER TABLE `messages_private`
  ADD CONSTRAINT `fk_messages_private_id_message` FOREIGN KEY (`id_message`) REFERENCES `messages` (`id`),
  ADD CONSTRAINT `fk_messages_private_id_user` FOREIGN KEY (`user_destiny`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `messages_public`
--
ALTER TABLE `messages_public`
  ADD CONSTRAINT `fk_messages_public_id_message` FOREIGN KEY (`id_message`) REFERENCES `messages` (`id`),
  ADD CONSTRAINT `fk_messages_public_id_topic` FOREIGN KEY (`id_topic`) REFERENCES `topics` (`id`);

--
-- Filtros para la tabla `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `fk_topics_id_cat` FOREIGN KEY (`id_cat`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `fk_topics_id_user` FOREIGN KEY (`creator_user`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `unread_messages_public`
--
ALTER TABLE `unread_messages_public`
  ADD CONSTRAINT `fk_unread_messages_public_id_message` FOREIGN KEY (`id_message`) REFERENCES `messages` (`id`),
  ADD CONSTRAINT `fk_unread_messages_public_id_topic` FOREIGN KEY (`id_topic`) REFERENCES `topics` (`id`),
  ADD CONSTRAINT `fk_unread_messages_public_id_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `unread_message_private`
--
ALTER TABLE `unread_message_private`
  ADD CONSTRAINT `fk_unread_messages_private_id_message` FOREIGN KEY (`id_message`) REFERENCES `messages` (`id`),
  ADD CONSTRAINT `fk_unread_messages_private_id_user` FOREIGN KEY (`id_user_destiny`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_id_rol` FOREIGN KEY (`rol`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `users_activation`
--
ALTER TABLE `users_activation`
  ADD CONSTRAINT `users_user_activation` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
