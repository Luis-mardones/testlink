-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-11-2018 a las 04:26:27
-- Versión del servidor: 10.1.35-MariaDB
-- Versión de PHP: 7.1.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `testlink`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `UDFStripHTMLTags` (`Dirty` VARCHAR(4000)) RETURNS VARCHAR(4000) CHARSET utf8 BEGIN
DECLARE iStart, iEnd, iLength int;
   WHILE Locate( '<', Dirty ) > 0 And Locate( '>', Dirty, Locate( '<', Dirty )) > 0 DO
      BEGIN
        SET iStart = Locate( '<', Dirty ), iEnd = Locate( '>', Dirty, Locate('<', Dirty ));
        SET iLength = ( iEnd - iStart) + 1;
        IF iLength > 0 THEN
          BEGIN
            SET Dirty = Insert( Dirty, iStart, iLength, '');
          END;
        END IF;
      END;
    END WHILE;
RETURN Dirty;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `assignment_status`
--

CREATE TABLE `assignment_status` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` varchar(100) NOT NULL DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `assignment_status`
--

INSERT INTO `assignment_status` (`id`, `description`) VALUES
(1, 'open'),
(2, 'closed'),
(3, 'completed'),
(4, 'todo_urgent'),
(5, 'todo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `assignment_types`
--

CREATE TABLE `assignment_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_table` varchar(30) DEFAULT '',
  `description` varchar(100) NOT NULL DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `assignment_types`
--

INSERT INTO `assignment_types` (`id`, `fk_table`, `description`) VALUES
(1, 'testplan_tcversions', 'testcase_execution'),
(2, 'tcversions', 'testcase_review');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `attachments`
--

CREATE TABLE `attachments` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `fk_table` varchar(250) DEFAULT '',
  `title` varchar(250) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `file_name` varchar(250) NOT NULL DEFAULT '',
  `file_path` varchar(250) DEFAULT '',
  `file_size` int(11) NOT NULL DEFAULT '0',
  `file_type` varchar(250) NOT NULL DEFAULT '',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `content` longblob,
  `compression_type` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `builds`
--

CREATE TABLE `builds` (
  `id` int(10) UNSIGNED NOT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT 'undefined',
  `notes` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `release_date` date DEFAULT NULL,
  `closed_on_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Available builds';

--
-- Volcado de datos para la tabla `builds`
--

INSERT INTO `builds` (`id`, `testplan_id`, `name`, `notes`, `active`, `is_open`, `author_id`, `creation_ts`, `release_date`, `closed_on_date`) VALUES
(1, 2, 'Build 1', '<p>Build 1</p>\r\n', 1, 1, NULL, '2018-11-23 02:05:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_build_design_values`
--

CREATE TABLE `cfield_build_design_values` (
  `field_id` int(10) NOT NULL DEFAULT '0',
  `node_id` int(10) NOT NULL DEFAULT '0',
  `value` varchar(4000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_design_values`
--

CREATE TABLE `cfield_design_values` (
  `field_id` int(10) NOT NULL DEFAULT '0',
  `node_id` int(10) NOT NULL DEFAULT '0',
  `value` varchar(4000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_execution_values`
--

CREATE TABLE `cfield_execution_values` (
  `field_id` int(10) NOT NULL DEFAULT '0',
  `execution_id` int(10) NOT NULL DEFAULT '0',
  `testplan_id` int(10) NOT NULL DEFAULT '0',
  `tcversion_id` int(10) NOT NULL DEFAULT '0',
  `value` varchar(4000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_node_types`
--

CREATE TABLE `cfield_node_types` (
  `field_id` int(10) NOT NULL DEFAULT '0',
  `node_type_id` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_testplan_design_values`
--

CREATE TABLE `cfield_testplan_design_values` (
  `field_id` int(10) NOT NULL DEFAULT '0',
  `link_id` int(10) NOT NULL DEFAULT '0' COMMENT 'point to testplan_tcversion id',
  `value` varchar(4000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cfield_testprojects`
--

CREATE TABLE `cfield_testprojects` (
  `field_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `testproject_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `display_order` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `location` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `required_on_design` tinyint(1) NOT NULL DEFAULT '0',
  `required_on_execution` tinyint(1) NOT NULL DEFAULT '0',
  `monitorable` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `codetrackers`
--

CREATE TABLE `codetrackers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT '0',
  `cfg` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `custom_fields`
--

CREATE TABLE `custom_fields` (
  `id` int(10) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `label` varchar(64) NOT NULL DEFAULT '' COMMENT 'label to display on user interface',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `possible_values` varchar(4000) NOT NULL DEFAULT '',
  `default_value` varchar(4000) NOT NULL DEFAULT '',
  `valid_regexp` varchar(255) NOT NULL DEFAULT '',
  `length_min` int(10) NOT NULL DEFAULT '0',
  `length_max` int(10) NOT NULL DEFAULT '0',
  `show_on_design` tinyint(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT '1=> show it during specification design',
  `enable_on_design` tinyint(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT '1=> user can write/manage it during specification design',
  `show_on_execution` tinyint(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '1=> show it during test case execution',
  `enable_on_execution` tinyint(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '1=> user can write/manage it during test case execution',
  `show_on_testplan_design` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `enable_on_testplan_design` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `db_version`
--

CREATE TABLE `db_version` (
  `version` varchar(50) NOT NULL DEFAULT 'unknown',
  `upgrade_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `db_version`
--

INSERT INTO `db_version` (`version`, `upgrade_ts`, `notes`) VALUES
('DB 1.9.18', '2018-11-22 20:50:15', 'TestLink 1.9.18 Gaura');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `events`
--

CREATE TABLE `events` (
  `id` int(10) UNSIGNED NOT NULL,
  `transaction_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `log_level` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `source` varchar(45) DEFAULT NULL,
  `description` text NOT NULL,
  `fired_at` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `activity` varchar(45) DEFAULT NULL,
  `object_id` int(10) UNSIGNED DEFAULT NULL,
  `object_type` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `events`
--

INSERT INTO `events` (`id`, `transaction_id`, `log_level`, `source`, `description`, `fired_at`, `activity`, `object_id`, `object_type`) VALUES
(1, 1, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1542920028, 'LOCALIZATION', 0, NULL),
(2, 2, 16, 'GUI', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920034, 'LOGIN', 1, 'users'),
(3, 3, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_testproject_created\";s:6:\"params\";a:1:{i:0;s:9:\"ArtMarVal\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920144, 'CREATE', 1, 'testprojects'),
(4, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920152, 'PHP', 0, NULL),
(5, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920152, 'PHP', 0, NULL),
(6, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920152, 'PHP', 0, NULL),
(7, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920152, 'PHP', 0, NULL),
(8, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920152, 'PHP', 0, NULL),
(9, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920152, 'PHP', 0, NULL),
(10, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920152, 'PHP', 0, NULL),
(11, 4, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920152, 'PHP', 0, NULL),
(12, 5, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:20:\"audit_user_pwd_saved\";s:6:\"params\";a:1:{i:0;s:5:\"admin\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920190, 'SAVE', 1, 'users'),
(13, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920190, 'PHP', 0, NULL),
(14, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920190, 'PHP', 0, NULL),
(15, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920190, 'PHP', 0, NULL),
(16, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920190, 'PHP', 0, NULL),
(17, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920190, 'PHP', 0, NULL),
(18, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920190, 'PHP', 0, NULL),
(19, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920191, 'PHP', 0, NULL),
(20, 5, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920191, 'PHP', 0, NULL),
(21, 6, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:16:\"audit_user_saved\";s:6:\"params\";a:1:{i:0;s:5:\"admin\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920203, 'SAVE', 1, 'users'),
(22, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920203, 'PHP', 0, NULL),
(23, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920203, 'PHP', 0, NULL),
(24, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920203, 'PHP', 0, NULL),
(25, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920203, 'PHP', 0, NULL),
(26, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920203, 'PHP', 0, NULL),
(27, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920204, 'PHP', 0, NULL),
(28, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920204, 'PHP', 0, NULL),
(29, 6, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920204, 'PHP', 0, NULL),
(30, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920209, 'PHP', 0, NULL),
(31, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542920209, 'PHP', 0, NULL),
(32, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920209, 'PHP', 0, NULL),
(33, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542920209, 'PHP', 0, NULL),
(34, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920209, 'PHP', 0, NULL),
(35, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542920209, 'PHP', 0, NULL),
(36, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920209, 'PHP', 0, NULL),
(37, 7, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542920209, 'PHP', 0, NULL),
(38, 8, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:17:\"audit_user_logout\";s:6:\"params\";a:1:{i:0;s:5:\"admin\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920222, 'LOGOUT', 1, 'users'),
(39, 9, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1542920223, 'LOCALIZATION', 0, NULL),
(40, 10, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920228, 'LOGIN', 1, 'users'),
(41, 11, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:22:\"audit_testplan_created\";s:6:\"params\";a:2:{i:0;s:9:\"ArtMarVal\";i:1;s:19:\"Plan de Pruebas AMV\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920486, 'CREATED', 2, 'testplans'),
(42, 12, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:19:\"audit_build_created\";s:6:\"params\";a:3:{i:0;s:9:\"ArtMarVal\";i:1;s:19:\"Plan de Pruebas AMV\";i:2;s:7:\"Build 1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542920701, 'CREATE', 1, 'builds'),
(43, 13, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_keyword_created\";s:6:\"params\";a:1:{i:0;s:7:\"Critico\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542921029, 'CREATE', 1, 'keywords'),
(44, 14, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_keyword_created\";s:6:\"params\";a:1:{i:0;s:4:\"Alto\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542921045, 'CREATE', 2, 'keywords'),
(45, 15, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_keyword_created\";s:6:\"params\";a:1:{i:0;s:5:\"media\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542921060, 'CREATE', 3, 'keywords'),
(46, 16, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_keyword_created\";s:6:\"params\";a:1:{i:0;s:4:\"baja\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542921075, 'CREATE', 4, 'keywords'),
(47, 17, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-1:Ingreso_pagina\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922472, 'ASSIGN', 8, 'nodes_hierarchy'),
(48, 17, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-1:Ingreso_pagina\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922472, 'ASSIGN', 8, 'nodes_hierarchy'),
(49, 17, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-1:Ingreso_pagina\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922472, 'ASSIGN', 8, 'nodes_hierarchy'),
(50, 17, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-1:Ingreso_pagina\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922472, 'ASSIGN', 8, 'nodes_hierarchy'),
(51, 18, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-2:Titulo_Favicon\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922523, 'ASSIGN', 10, 'nodes_hierarchy'),
(52, 18, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-2:Titulo_Favicon\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922523, 'ASSIGN', 10, 'nodes_hierarchy'),
(53, 18, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-2:Titulo_Favicon\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922523, 'ASSIGN', 10, 'nodes_hierarchy'),
(54, 18, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-2:Titulo_Favicon\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922523, 'ASSIGN', 10, 'nodes_hierarchy'),
(55, 19, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:30:\"/ArtMarVal/AMV-Main/AMV-3:Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922549, 'ASSIGN', 12, 'nodes_hierarchy'),
(56, 19, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:30:\"/ArtMarVal/AMV-Main/AMV-3:Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922549, 'ASSIGN', 12, 'nodes_hierarchy'),
(57, 19, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:30:\"/ArtMarVal/AMV-Main/AMV-3:Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922549, 'ASSIGN', 12, 'nodes_hierarchy'),
(58, 19, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:30:\"/ArtMarVal/AMV-Main/AMV-3:Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922549, 'ASSIGN', 12, 'nodes_hierarchy'),
(59, 20, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:31:\"/ArtMarVal/AMV-Main/AMV-4:Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922584, 'ASSIGN', 14, 'nodes_hierarchy'),
(60, 20, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:31:\"/ArtMarVal/AMV-Main/AMV-4:Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922584, 'ASSIGN', 14, 'nodes_hierarchy'),
(61, 20, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:31:\"/ArtMarVal/AMV-Main/AMV-4:Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922584, 'ASSIGN', 14, 'nodes_hierarchy'),
(62, 20, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:31:\"/ArtMarVal/AMV-Main/AMV-4:Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922584, 'ASSIGN', 14, 'nodes_hierarchy'),
(63, 21, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-5:Imagen_Portada\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922611, 'ASSIGN', 16, 'nodes_hierarchy'),
(64, 21, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-5:Imagen_Portada\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922611, 'ASSIGN', 16, 'nodes_hierarchy'),
(65, 21, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-5:Imagen_Portada\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922611, 'ASSIGN', 16, 'nodes_hierarchy'),
(66, 21, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:40:\"/ArtMarVal/AMV-Main/AMV-5:Imagen_Portada\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922611, 'ASSIGN', 16, 'nodes_hierarchy'),
(67, 22, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:35:\"/ArtMarVal/AMV-Main/AMV-6:Productos\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922640, 'ASSIGN', 18, 'nodes_hierarchy'),
(68, 22, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:35:\"/ArtMarVal/AMV-Main/AMV-6:Productos\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922641, 'ASSIGN', 18, 'nodes_hierarchy'),
(69, 22, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:35:\"/ArtMarVal/AMV-Main/AMV-6:Productos\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922641, 'ASSIGN', 18, 'nodes_hierarchy'),
(70, 22, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:35:\"/ArtMarVal/AMV-Main/AMV-6:Productos\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542922641, 'ASSIGN', 18, 'nodes_hierarchy'),
(71, 23, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:38:\"/ArtMarVal/AMV-Main/AMV-7:Subscripcion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923332, 'ASSIGN', 20, 'nodes_hierarchy'),
(72, 23, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:38:\"/ArtMarVal/AMV-Main/AMV-7:Subscripcion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923332, 'ASSIGN', 20, 'nodes_hierarchy'),
(73, 23, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:38:\"/ArtMarVal/AMV-Main/AMV-7:Subscripcion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923332, 'ASSIGN', 20, 'nodes_hierarchy'),
(74, 23, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:38:\"/ArtMarVal/AMV-Main/AMV-7:Subscripcion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923332, 'ASSIGN', 20, 'nodes_hierarchy'),
(75, 24, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:32:\"/ArtMarVal/AMV-Main/AMV-8:Footer\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923367, 'ASSIGN', 22, 'nodes_hierarchy'),
(76, 24, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:32:\"/ArtMarVal/AMV-Main/AMV-8:Footer\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923367, 'ASSIGN', 22, 'nodes_hierarchy'),
(77, 24, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:32:\"/ArtMarVal/AMV-Main/AMV-8:Footer\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923368, 'ASSIGN', 22, 'nodes_hierarchy'),
(78, 24, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:32:\"/ArtMarVal/AMV-Main/AMV-8:Footer\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923368, 'ASSIGN', 22, 'nodes_hierarchy'),
(79, 25, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-9:Filtro_Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923456, 'ASSIGN', 24, 'nodes_hierarchy'),
(80, 25, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-9:Filtro_Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923456, 'ASSIGN', 24, 'nodes_hierarchy'),
(81, 25, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-9:Filtro_Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923456, 'ASSIGN', 24, 'nodes_hierarchy'),
(82, 25, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-9:Filtro_Menus\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923456, 'ASSIGN', 24, 'nodes_hierarchy'),
(83, 26, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:44:\"/ArtMarVal/AMV-Lista/AMV-10:Filtro_Categoria\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923509, 'ASSIGN', 26, 'nodes_hierarchy'),
(84, 26, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:44:\"/ArtMarVal/AMV-Lista/AMV-10:Filtro_Categoria\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923509, 'ASSIGN', 26, 'nodes_hierarchy'),
(85, 26, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:44:\"/ArtMarVal/AMV-Lista/AMV-10:Filtro_Categoria\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923509, 'ASSIGN', 26, 'nodes_hierarchy'),
(86, 26, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:44:\"/ArtMarVal/AMV-Lista/AMV-10:Filtro_Categoria\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923509, 'ASSIGN', 26, 'nodes_hierarchy'),
(87, 27, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:41:\"/ArtMarVal/AMV-Lista/AMV-11:Filtro_Precio\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923536, 'ASSIGN', 28, 'nodes_hierarchy'),
(88, 27, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:41:\"/ArtMarVal/AMV-Lista/AMV-11:Filtro_Precio\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923537, 'ASSIGN', 28, 'nodes_hierarchy'),
(89, 27, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:41:\"/ArtMarVal/AMV-Lista/AMV-11:Filtro_Precio\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923537, 'ASSIGN', 28, 'nodes_hierarchy'),
(90, 27, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:41:\"/ArtMarVal/AMV-Lista/AMV-11:Filtro_Precio\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923537, 'ASSIGN', 28, 'nodes_hierarchy'),
(91, 28, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-12:Titulo_Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923766, 'ASSIGN', 30, 'nodes_hierarchy'),
(92, 28, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-12:Titulo_Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923766, 'ASSIGN', 30, 'nodes_hierarchy'),
(93, 28, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-12:Titulo_Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923766, 'ASSIGN', 30, 'nodes_hierarchy'),
(94, 28, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:39:\"/ArtMarVal/AMV-Lista/AMV-12:Titulo_Logo\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923766, 'ASSIGN', 30, 'nodes_hierarchy'),
(95, 29, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:37:\"/ArtMarVal/AMV-Lista/AMV-13:Orden_por\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923816, 'ASSIGN', 32, 'nodes_hierarchy'),
(96, 29, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:37:\"/ArtMarVal/AMV-Lista/AMV-13:Orden_por\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923816, 'ASSIGN', 32, 'nodes_hierarchy'),
(97, 29, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:37:\"/ArtMarVal/AMV-Lista/AMV-13:Orden_por\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923817, 'ASSIGN', 32, 'nodes_hierarchy'),
(98, 29, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:37:\"/ArtMarVal/AMV-Lista/AMV-13:Orden_por\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923817, 'ASSIGN', 32, 'nodes_hierarchy'),
(99, 30, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:42:\"/ArtMarVal/AMV-Lista/AMV-14:Cantidad_lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923898, 'ASSIGN', 34, 'nodes_hierarchy'),
(100, 30, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:42:\"/ArtMarVal/AMV-Lista/AMV-14:Cantidad_lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923898, 'ASSIGN', 34, 'nodes_hierarchy'),
(101, 30, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:42:\"/ArtMarVal/AMV-Lista/AMV-14:Cantidad_lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923898, 'ASSIGN', 34, 'nodes_hierarchy'),
(102, 30, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:42:\"/ArtMarVal/AMV-Lista/AMV-14:Cantidad_lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542923898, 'ASSIGN', 34, 'nodes_hierarchy'),
(103, 31, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:43:\"/ArtMarVal/AMV-Lista/AMV-15:Navegador_Lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924009, 'ASSIGN', 36, 'nodes_hierarchy'),
(104, 31, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:43:\"/ArtMarVal/AMV-Lista/AMV-15:Navegador_Lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924009, 'ASSIGN', 36, 'nodes_hierarchy'),
(105, 31, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:43:\"/ArtMarVal/AMV-Lista/AMV-15:Navegador_Lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924009, 'ASSIGN', 36, 'nodes_hierarchy'),
(106, 31, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:43:\"/ArtMarVal/AMV-Lista/AMV-15:Navegador_Lista\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924009, 'ASSIGN', 36, 'nodes_hierarchy'),
(107, 32, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:41:\"/ArtMarVal/AMV-Productos/AMV-16:Direccion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924060, 'ASSIGN', 38, 'nodes_hierarchy'),
(108, 32, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:41:\"/ArtMarVal/AMV-Productos/AMV-16:Direccion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924060, 'ASSIGN', 38, 'nodes_hierarchy'),
(109, 32, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:41:\"/ArtMarVal/AMV-Productos/AMV-16:Direccion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924060, 'ASSIGN', 38, 'nodes_hierarchy'),
(110, 32, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:41:\"/ArtMarVal/AMV-Productos/AMV-16:Direccion\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924060, 'ASSIGN', 38, 'nodes_hierarchy'),
(111, 33, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:46:\"/ArtMarVal/AMV-Productos/AMV-17:Galeria_imagen\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924201, 'ASSIGN', 40, 'nodes_hierarchy'),
(112, 33, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:46:\"/ArtMarVal/AMV-Productos/AMV-17:Galeria_imagen\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924201, 'ASSIGN', 40, 'nodes_hierarchy'),
(113, 33, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:46:\"/ArtMarVal/AMV-Productos/AMV-17:Galeria_imagen\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924201, 'ASSIGN', 40, 'nodes_hierarchy'),
(114, 33, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:46:\"/ArtMarVal/AMV-Productos/AMV-17:Galeria_imagen\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924201, 'ASSIGN', 40, 'nodes_hierarchy'),
(115, 34, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-18:Informacion_producto\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924236, 'ASSIGN', 42, 'nodes_hierarchy'),
(116, 34, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-18:Informacion_producto\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924236, 'ASSIGN', 42, 'nodes_hierarchy'),
(117, 34, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-18:Informacion_producto\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924236, 'ASSIGN', 42, 'nodes_hierarchy'),
(118, 34, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-18:Informacion_producto\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924236, 'ASSIGN', 42, 'nodes_hierarchy'),
(119, 35, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:51:\"/ArtMarVal/AMV-Productos/AMV-19:Carro_deshabilitado\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924257, 'ASSIGN', 44, 'nodes_hierarchy'),
(120, 35, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:51:\"/ArtMarVal/AMV-Productos/AMV-19:Carro_deshabilitado\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924257, 'ASSIGN', 44, 'nodes_hierarchy'),
(121, 35, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:51:\"/ArtMarVal/AMV-Productos/AMV-19:Carro_deshabilitado\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924257, 'ASSIGN', 44, 'nodes_hierarchy'),
(122, 35, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:51:\"/ArtMarVal/AMV-Productos/AMV-19:Carro_deshabilitado\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924257, 'ASSIGN', 44, 'nodes_hierarchy'),
(123, 36, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-20:Descripcion_Detalles\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924283, 'ASSIGN', 46, 'nodes_hierarchy'),
(124, 36, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-20:Descripcion_Detalles\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924283, 'ASSIGN', 46, 'nodes_hierarchy'),
(125, 36, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-20:Descripcion_Detalles\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924283, 'ASSIGN', 46, 'nodes_hierarchy'),
(126, 36, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:52:\"/ArtMarVal/AMV-Productos/AMV-20:Descripcion_Detalles\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924283, 'ASSIGN', 46, 'nodes_hierarchy'),
(127, 37, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-21:Ingreso_Sin_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924347, 'ASSIGN', 48, 'nodes_hierarchy'),
(128, 37, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-21:Ingreso_Sin_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924347, 'ASSIGN', 48, 'nodes_hierarchy'),
(129, 37, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-21:Ingreso_Sin_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924347, 'ASSIGN', 48, 'nodes_hierarchy'),
(130, 37, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-21:Ingreso_Sin_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924347, 'ASSIGN', 48, 'nodes_hierarchy'),
(131, 38, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:47:\"/ArtMarVal/AMV-Login/Signin/AMV-22:Crear_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924361, 'ASSIGN', 50, 'nodes_hierarchy'),
(132, 38, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:47:\"/ArtMarVal/AMV-Login/Signin/AMV-22:Crear_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924361, 'ASSIGN', 50, 'nodes_hierarchy'),
(133, 38, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:47:\"/ArtMarVal/AMV-Login/Signin/AMV-22:Crear_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924361, 'ASSIGN', 50, 'nodes_hierarchy'),
(134, 38, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:47:\"/ArtMarVal/AMV-Login/Signin/AMV-22:Crear_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924361, 'ASSIGN', 50, 'nodes_hierarchy'),
(135, 39, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:49:\"/ArtMarVal/AMV-Login/Signin/AMV-23:Ingreso_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924386, 'ASSIGN', 52, 'nodes_hierarchy'),
(136, 39, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:49:\"/ArtMarVal/AMV-Login/Signin/AMV-23:Ingreso_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924386, 'ASSIGN', 52, 'nodes_hierarchy'),
(137, 39, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:49:\"/ArtMarVal/AMV-Login/Signin/AMV-23:Ingreso_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924386, 'ASSIGN', 52, 'nodes_hierarchy'),
(138, 39, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:49:\"/ArtMarVal/AMV-Login/Signin/AMV-23:Ingreso_Cuenta\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924386, 'ASSIGN', 52, 'nodes_hierarchy'),
(139, 40, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-24:Cambio_Contraseña\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924410, 'ASSIGN', 54, 'nodes_hierarchy'),
(140, 40, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"baja\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-24:Cambio_Contraseña\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924410, 'ASSIGN', 54, 'nodes_hierarchy'),
(141, 40, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-24:Cambio_Contraseña\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924411, 'ASSIGN', 54, 'nodes_hierarchy'),
(142, 40, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:53:\"/ArtMarVal/AMV-Login/Signin/AMV-24:Cambio_Contraseña\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542924411, 'ASSIGN', 54, 'nodes_hierarchy'),
(143, 41, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:14:\"Ingreso_pagina\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542926506, 'ASSIGN', 7, 'nodes_hierarchy'),
(144, 41, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Ingreso_pagina\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542926506, 'ASSIGN', 7, 'nodes_hierarchy'),
(145, 41, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:14:\"Ingreso_pagina\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542926506, 'ASSIGN', 7, 'nodes_hierarchy'),
(146, 42, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542926510, 'PHP', 0, NULL),
(147, 42, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542926510, 'PHP', 0, NULL),
(148, 42, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542926510, 'PHP', 0, NULL),
(149, 42, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542926510, 'PHP', 0, NULL),
(150, 43, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542928084, 'PHP', 0, NULL),
(151, 43, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542928084, 'PHP', 0, NULL),
(152, 43, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542928084, 'PHP', 0, NULL),
(153, 43, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542928084, 'PHP', 0, NULL),
(154, 44, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542932499, 'PHP', 0, NULL),
(155, 44, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542932499, 'PHP', 0, NULL),
(156, 44, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542932499, 'PHP', 0, NULL),
(157, 44, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542932499, 'PHP', 0, NULL),
(158, 45, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Titulo_Favicon\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935622, 'ASSIGN', 9, 'nodes_hierarchy'),
(159, 45, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:14:\"Titulo_Favicon\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935622, 'ASSIGN', 9, 'nodes_hierarchy'),
(160, 45, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:14:\"Titulo_Favicon\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935622, 'ASSIGN', 9, 'nodes_hierarchy'),
(161, 46, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935629, 'PHP', 0, NULL),
(162, 46, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935629, 'PHP', 0, NULL),
(163, 46, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935629, 'PHP', 0, NULL),
(164, 46, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935629, 'PHP', 0, NULL),
(165, 47, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935695, 'PHP', 0, NULL),
(166, 47, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935695, 'PHP', 0, NULL),
(167, 47, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935695, 'PHP', 0, NULL),
(168, 47, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935695, 'PHP', 0, NULL),
(169, 48, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:4:\"Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935914, 'ASSIGN', 11, 'nodes_hierarchy'),
(170, 48, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:4:\"Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935914, 'ASSIGN', 11, 'nodes_hierarchy'),
(171, 48, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:4:\"Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542935914, 'ASSIGN', 11, 'nodes_hierarchy'),
(172, 49, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935923, 'PHP', 0, NULL),
(173, 49, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542935923, 'PHP', 0, NULL),
(174, 49, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935923, 'PHP', 0, NULL),
(175, 49, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542935923, 'PHP', 0, NULL),
(176, 50, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542936047, 'PHP', 0, NULL);
INSERT INTO `events` (`id`, `transaction_id`, `log_level`, `source`, `description`, `fired_at`, `activity`, `object_id`, `object_type`) VALUES
(177, 50, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542936047, 'PHP', 0, NULL),
(178, 50, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542936047, 'PHP', 0, NULL),
(179, 50, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542936047, 'PHP', 0, NULL),
(180, 51, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:5:\"Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542936146, 'ASSIGN', 13, 'nodes_hierarchy'),
(181, 51, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:5:\"Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542936146, 'ASSIGN', 13, 'nodes_hierarchy'),
(182, 51, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:5:\"Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542936146, 'ASSIGN', 13, 'nodes_hierarchy'),
(183, 52, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542936163, 'PHP', 0, NULL),
(184, 52, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542936163, 'PHP', 0, NULL),
(185, 52, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542936164, 'PHP', 0, NULL),
(186, 52, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542936164, 'PHP', 0, NULL),
(187, 53, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542938626, 'PHP', 0, NULL),
(188, 53, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542938626, 'PHP', 0, NULL),
(189, 53, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542938626, 'PHP', 0, NULL),
(190, 53, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542938626, 'PHP', 0, NULL),
(191, 54, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:14:\"Imagen_Portada\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542939956, 'ASSIGN', 15, 'nodes_hierarchy'),
(192, 54, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Imagen_Portada\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542939956, 'ASSIGN', 15, 'nodes_hierarchy'),
(193, 54, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:14:\"Imagen_Portada\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542939956, 'ASSIGN', 15, 'nodes_hierarchy'),
(194, 55, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542940228, 'PHP', 0, NULL),
(195, 55, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542940228, 'PHP', 0, NULL),
(196, 55, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542940228, 'PHP', 0, NULL),
(197, 55, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542940229, 'PHP', 0, NULL),
(198, 56, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542940558, 'PHP', 0, NULL),
(199, 56, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542940558, 'PHP', 0, NULL),
(200, 56, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542940558, 'PHP', 0, NULL),
(201, 56, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542940558, 'PHP', 0, NULL),
(202, 57, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:17:\"Galeria_Productos\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542941358, 'ASSIGN', 17, 'nodes_hierarchy'),
(203, 57, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:17:\"Galeria_Productos\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542941358, 'ASSIGN', 17, 'nodes_hierarchy'),
(204, 57, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:17:\"Galeria_Productos\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542941359, 'ASSIGN', 17, 'nodes_hierarchy'),
(205, 58, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941369, 'PHP', 0, NULL),
(206, 58, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941370, 'PHP', 0, NULL),
(207, 58, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941370, 'PHP', 0, NULL),
(208, 58, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941370, 'PHP', 0, NULL),
(209, 59, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941510, 'PHP', 0, NULL),
(210, 59, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941510, 'PHP', 0, NULL),
(211, 59, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941510, 'PHP', 0, NULL),
(212, 59, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941510, 'PHP', 0, NULL),
(213, 60, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941567, 'PHP', 0, NULL),
(214, 60, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941567, 'PHP', 0, NULL),
(215, 60, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941568, 'PHP', 0, NULL),
(216, 60, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941568, 'PHP', 0, NULL),
(217, 61, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941572, 'PHP', 0, NULL),
(218, 61, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941572, 'PHP', 0, NULL),
(219, 61, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941572, 'PHP', 0, NULL),
(220, 61, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941572, 'PHP', 0, NULL),
(221, 62, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941639, 'PHP', 0, NULL),
(222, 62, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941639, 'PHP', 0, NULL),
(223, 62, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941639, 'PHP', 0, NULL),
(224, 62, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941639, 'PHP', 0, NULL),
(225, 63, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941915, 'PHP', 0, NULL),
(226, 63, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941915, 'PHP', 0, NULL),
(227, 63, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941915, 'PHP', 0, NULL),
(228, 63, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941916, 'PHP', 0, NULL),
(229, 64, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941974, 'PHP', 0, NULL),
(230, 64, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542941975, 'PHP', 0, NULL),
(231, 64, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941975, 'PHP', 0, NULL),
(232, 64, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542941975, 'PHP', 0, NULL),
(233, 65, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:12:\"Subscripcion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542943626, 'ASSIGN', 19, 'nodes_hierarchy'),
(234, 65, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:12:\"Subscripcion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542943627, 'ASSIGN', 19, 'nodes_hierarchy'),
(235, 65, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:12:\"Subscripcion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542943627, 'ASSIGN', 19, 'nodes_hierarchy'),
(236, 66, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943631, 'PHP', 0, NULL),
(237, 66, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943631, 'PHP', 0, NULL),
(238, 66, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943631, 'PHP', 0, NULL),
(239, 66, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943631, 'PHP', 0, NULL),
(240, 67, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943766, 'PHP', 0, NULL),
(241, 67, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943767, 'PHP', 0, NULL),
(242, 67, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943767, 'PHP', 0, NULL),
(243, 67, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943767, 'PHP', 0, NULL),
(244, 68, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943838, 'PHP', 0, NULL),
(245, 68, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542943838, 'PHP', 0, NULL),
(246, 68, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943838, 'PHP', 0, NULL),
(247, 68, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542943838, 'PHP', 0, NULL),
(248, 69, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944122, 'PHP', 0, NULL),
(249, 69, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944122, 'PHP', 0, NULL),
(250, 69, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944122, 'PHP', 0, NULL),
(251, 69, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944122, 'PHP', 0, NULL),
(252, 70, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944213, 'PHP', 0, NULL),
(253, 70, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944213, 'PHP', 0, NULL),
(254, 70, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944213, 'PHP', 0, NULL),
(255, 70, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944213, 'PHP', 0, NULL),
(256, 71, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:6:\"Footer\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542944260, 'ASSIGN', 21, 'nodes_hierarchy'),
(257, 71, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:6:\"Footer\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542944261, 'ASSIGN', 21, 'nodes_hierarchy'),
(258, 71, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:6:\"Footer\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542944261, 'ASSIGN', 21, 'nodes_hierarchy'),
(259, 72, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944266, 'PHP', 0, NULL),
(260, 72, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542944266, 'PHP', 0, NULL),
(261, 72, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944266, 'PHP', 0, NULL),
(262, 72, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542944266, 'PHP', 0, NULL),
(263, 73, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:12:\"Filtro_Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542945694, 'ASSIGN', 23, 'nodes_hierarchy'),
(264, 73, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:12:\"Filtro_Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542945694, 'ASSIGN', 23, 'nodes_hierarchy'),
(265, 73, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:12:\"Filtro_Menus\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542945694, 'ASSIGN', 23, 'nodes_hierarchy'),
(266, 74, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542945702, 'PHP', 0, NULL),
(267, 74, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542945702, 'PHP', 0, NULL),
(268, 74, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542945702, 'PHP', 0, NULL),
(269, 74, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542945702, 'PHP', 0, NULL),
(270, 75, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946015, 'PHP', 0, NULL),
(271, 75, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946015, 'PHP', 0, NULL),
(272, 75, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946015, 'PHP', 0, NULL),
(273, 75, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946015, 'PHP', 0, NULL),
(274, 76, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946031, 'PHP', 0, NULL),
(275, 76, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946031, 'PHP', 0, NULL),
(276, 76, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946031, 'PHP', 0, NULL),
(277, 76, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946031, 'PHP', 0, NULL),
(278, 77, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946079, 'PHP', 0, NULL),
(279, 77, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946079, 'PHP', 0, NULL),
(280, 77, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946079, 'PHP', 0, NULL),
(281, 77, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946079, 'PHP', 0, NULL),
(282, 78, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946234, 'PHP', 0, NULL),
(283, 78, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946234, 'PHP', 0, NULL),
(284, 78, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946234, 'PHP', 0, NULL),
(285, 78, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946234, 'PHP', 0, NULL),
(286, 79, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946320, 'PHP', 0, NULL),
(287, 79, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946320, 'PHP', 0, NULL),
(288, 79, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946320, 'PHP', 0, NULL),
(289, 79, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946320, 'PHP', 0, NULL),
(290, 80, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946333, 'PHP', 0, NULL),
(291, 80, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946333, 'PHP', 0, NULL),
(292, 80, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946333, 'PHP', 0, NULL),
(293, 80, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946333, 'PHP', 0, NULL),
(294, 81, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:16:\"Filtro_Categoria\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542946864, 'ASSIGN', 25, 'nodes_hierarchy'),
(295, 81, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:16:\"Filtro_Categoria\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542946864, 'ASSIGN', 25, 'nodes_hierarchy'),
(296, 81, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:16:\"Filtro_Categoria\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542946864, 'ASSIGN', 25, 'nodes_hierarchy'),
(297, 82, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946870, 'PHP', 0, NULL),
(298, 82, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542946871, 'PHP', 0, NULL),
(299, 82, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946871, 'PHP', 0, NULL),
(300, 82, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542946871, 'PHP', 0, NULL),
(301, 83, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947149, 'PHP', 0, NULL),
(302, 83, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947149, 'PHP', 0, NULL),
(303, 83, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947149, 'PHP', 0, NULL),
(304, 83, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947149, 'PHP', 0, NULL),
(305, 84, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:13:\"Filtro_Precio\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947378, 'ASSIGN', 27, 'nodes_hierarchy'),
(306, 84, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:13:\"Filtro_Precio\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947379, 'ASSIGN', 27, 'nodes_hierarchy'),
(307, 84, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:13:\"Filtro_Precio\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947379, 'ASSIGN', 27, 'nodes_hierarchy'),
(308, 85, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947382, 'PHP', 0, NULL),
(309, 85, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947383, 'PHP', 0, NULL),
(310, 85, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947383, 'PHP', 0, NULL),
(311, 85, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947383, 'PHP', 0, NULL),
(312, 86, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947384, 'PHP', 0, NULL),
(313, 86, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947385, 'PHP', 0, NULL),
(314, 86, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947385, 'PHP', 0, NULL),
(315, 86, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947385, 'PHP', 0, NULL),
(316, 87, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947573, 'PHP', 0, NULL),
(317, 87, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947573, 'PHP', 0, NULL),
(318, 87, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947573, 'PHP', 0, NULL),
(319, 87, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947573, 'PHP', 0, NULL),
(320, 88, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947577, 'PHP', 0, NULL),
(321, 88, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947577, 'PHP', 0, NULL),
(322, 88, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947577, 'PHP', 0, NULL),
(323, 88, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947577, 'PHP', 0, NULL),
(324, 89, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:11:\"Titulo_Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947661, 'ASSIGN', 29, 'nodes_hierarchy'),
(325, 89, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:11:\"Titulo_Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947662, 'ASSIGN', 29, 'nodes_hierarchy'),
(326, 89, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:11:\"Titulo_Logo\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542947662, 'ASSIGN', 29, 'nodes_hierarchy'),
(327, 90, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947665, 'PHP', 0, NULL),
(328, 90, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542947665, 'PHP', 0, NULL),
(329, 90, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947665, 'PHP', 0, NULL),
(330, 90, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542947665, 'PHP', 0, NULL),
(331, 91, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948086, 'PHP', 0, NULL),
(332, 91, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948086, 'PHP', 0, NULL),
(333, 91, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948087, 'PHP', 0, NULL),
(334, 91, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948087, 'PHP', 0, NULL),
(335, 92, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:9:\"Orden_por\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948307, 'ASSIGN', 31, 'nodes_hierarchy'),
(336, 92, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:9:\"Orden_por\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948307, 'ASSIGN', 31, 'nodes_hierarchy'),
(337, 92, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:9:\"Orden_por\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948307, 'ASSIGN', 31, 'nodes_hierarchy'),
(338, 93, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948468, 'PHP', 0, NULL),
(339, 93, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948468, 'PHP', 0, NULL),
(340, 93, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948468, 'PHP', 0, NULL),
(341, 93, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948468, 'PHP', 0, NULL),
(342, 94, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948553, 'PHP', 0, NULL),
(343, 94, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948553, 'PHP', 0, NULL),
(344, 94, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948553, 'PHP', 0, NULL),
(345, 94, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948553, 'PHP', 0, NULL),
(346, 95, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948659, 'PHP', 0, NULL),
(347, 95, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948659, 'PHP', 0, NULL),
(348, 95, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948659, 'PHP', 0, NULL),
(349, 95, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948660, 'PHP', 0, NULL),
(350, 96, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Cantidad_lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948793, 'ASSIGN', 33, 'nodes_hierarchy'),
(351, 96, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:14:\"Cantidad_lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948793, 'ASSIGN', 33, 'nodes_hierarchy'),
(352, 96, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:14:\"Cantidad_lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542948793, 'ASSIGN', 33, 'nodes_hierarchy'),
(353, 97, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948851, 'PHP', 0, NULL),
(354, 97, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542948851, 'PHP', 0, NULL),
(355, 97, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948851, 'PHP', 0, NULL),
(356, 97, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542948851, 'PHP', 0, NULL),
(357, 98, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:15:\"Navegador_Lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542949233, 'ASSIGN', 35, 'nodes_hierarchy'),
(358, 98, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:15:\"Navegador_Lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542949234, 'ASSIGN', 35, 'nodes_hierarchy'),
(359, 98, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:15:\"Navegador_Lista\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542949234, 'ASSIGN', 35, 'nodes_hierarchy'),
(360, 99, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949259, 'PHP', 0, NULL),
(361, 99, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949259, 'PHP', 0, NULL),
(362, 99, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949260, 'PHP', 0, NULL),
(363, 99, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949260, 'PHP', 0, NULL),
(364, 100, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949343, 'PHP', 0, NULL),
(365, 100, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949343, 'PHP', 0, NULL),
(366, 100, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949343, 'PHP', 0, NULL),
(367, 100, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949343, 'PHP', 0, NULL),
(368, 101, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949415, 'PHP', 0, NULL),
(369, 101, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949416, 'PHP', 0, NULL),
(370, 101, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949416, 'PHP', 0, NULL),
(371, 101, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949416, 'PHP', 0, NULL),
(372, 102, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949456, 'PHP', 0, NULL);
INSERT INTO `events` (`id`, `transaction_id`, `log_level`, `source`, `description`, `fired_at`, `activity`, `object_id`, `object_type`) VALUES
(373, 102, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949456, 'PHP', 0, NULL),
(374, 102, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949456, 'PHP', 0, NULL),
(375, 102, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949456, 'PHP', 0, NULL),
(376, 103, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949462, 'PHP', 0, NULL),
(377, 103, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949463, 'PHP', 0, NULL),
(378, 103, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949463, 'PHP', 0, NULL),
(379, 103, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949463, 'PHP', 0, NULL),
(380, 104, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949468, 'PHP', 0, NULL),
(381, 104, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949468, 'PHP', 0, NULL),
(382, 104, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949468, 'PHP', 0, NULL),
(383, 104, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949468, 'PHP', 0, NULL),
(384, 105, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949595, 'PHP', 0, NULL),
(385, 105, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949595, 'PHP', 0, NULL),
(386, 105, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949595, 'PHP', 0, NULL),
(387, 105, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949595, 'PHP', 0, NULL),
(388, 106, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949648, 'PHP', 0, NULL),
(389, 106, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542949648, 'PHP', 0, NULL),
(390, 106, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949648, 'PHP', 0, NULL),
(391, 106, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542949648, 'PHP', 0, NULL),
(392, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542950394, 'PHP', 0, NULL),
(393, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2045', 1542950394, 'PHP', 0, NULL),
(394, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542950394, 'PHP', 0, NULL),
(395, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2046', 1542950394, 'PHP', 0, NULL),
(396, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542950394, 'PHP', 0, NULL),
(397, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 2047', 1542950395, 'PHP', 0, NULL),
(398, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542950395, 'PHP', 0, NULL),
(399, 107, 2, 'GUI - Test Project ID : 1', 'E_WARNING\nA non-numeric value encountered - in C:\\xampp\\htdocs\\testlink\\locale\\ja_JP\\strings.txt - Line 3265', 1542950395, 'PHP', 0, NULL),
(400, 108, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:17:\"audit_user_logout\";s:6:\"params\";a:1:{i:0;s:5:\"admin\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542950396, 'LOGOUT', 1, 'users'),
(401, 109, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1542950397, 'LOCALIZATION', 0, NULL),
(402, 110, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1542996847, 'LOCALIZATION', 0, NULL),
(403, 111, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542996854, 'LOGIN', 1, 'users'),
(404, 112, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:9:\"Direccion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999175, 'ASSIGN', 37, 'nodes_hierarchy'),
(405, 112, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:7:\"Critico\";i:1;s:9:\"Direccion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999175, 'ASSIGN', 37, 'nodes_hierarchy'),
(406, 112, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:9:\"Direccion\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999175, 'ASSIGN', 37, 'nodes_hierarchy'),
(407, 113, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999178, 'PHP', 0, NULL),
(408, 113, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999178, 'PHP', 0, NULL),
(409, 113, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999178, 'PHP', 0, NULL),
(410, 113, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999178, 'PHP', 0, NULL),
(411, 114, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999394, 'PHP', 0, NULL),
(412, 114, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999394, 'PHP', 0, NULL),
(413, 114, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999394, 'PHP', 0, NULL),
(414, 114, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999394, 'PHP', 0, NULL),
(415, 115, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:14:\"Galeria_imagen\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999520, 'ASSIGN', 39, 'nodes_hierarchy'),
(416, 115, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Galeria_imagen\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999520, 'ASSIGN', 39, 'nodes_hierarchy'),
(417, 115, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:14:\"Galeria_imagen\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1542999520, 'ASSIGN', 39, 'nodes_hierarchy'),
(418, 116, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999561, 'PHP', 0, NULL),
(419, 116, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999562, 'PHP', 0, NULL),
(420, 116, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999562, 'PHP', 0, NULL),
(421, 116, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999562, 'PHP', 0, NULL),
(422, 117, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999828, 'PHP', 0, NULL),
(423, 117, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1542999828, 'PHP', 0, NULL),
(424, 117, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999828, 'PHP', 0, NULL),
(425, 117, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1542999829, 'PHP', 0, NULL),
(426, 118, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543000013, 'PHP', 0, NULL),
(427, 118, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543000013, 'PHP', 0, NULL),
(428, 118, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543000013, 'PHP', 0, NULL),
(429, 118, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543000013, 'PHP', 0, NULL),
(430, 119, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:20:\"Informacion_producto\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002220, 'ASSIGN', 41, 'nodes_hierarchy'),
(431, 119, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:20:\"Informacion_producto\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002221, 'ASSIGN', 41, 'nodes_hierarchy'),
(432, 119, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:20:\"Informacion_producto\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002221, 'ASSIGN', 41, 'nodes_hierarchy'),
(433, 120, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002224, 'PHP', 0, NULL),
(434, 120, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002224, 'PHP', 0, NULL),
(435, 120, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002224, 'PHP', 0, NULL),
(436, 120, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002224, 'PHP', 0, NULL),
(437, 121, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:19:\"Carro_deshabilitado\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002531, 'ASSIGN', 43, 'nodes_hierarchy'),
(438, 121, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:19:\"Carro_deshabilitado\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002531, 'ASSIGN', 43, 'nodes_hierarchy'),
(439, 121, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:19:\"Carro_deshabilitado\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002531, 'ASSIGN', 43, 'nodes_hierarchy'),
(440, 122, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002534, 'PHP', 0, NULL),
(441, 122, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002535, 'PHP', 0, NULL),
(442, 122, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002535, 'PHP', 0, NULL),
(443, 122, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002535, 'PHP', 0, NULL),
(444, 123, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:20:\"Descripcion_Detalles\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002703, 'ASSIGN', 45, 'nodes_hierarchy'),
(445, 123, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:20:\"Descripcion_Detalles\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002703, 'ASSIGN', 45, 'nodes_hierarchy'),
(446, 123, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:20:\"Descripcion_Detalles\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543002703, 'ASSIGN', 45, 'nodes_hierarchy'),
(447, 124, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002713, 'PHP', 0, NULL),
(448, 124, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002713, 'PHP', 0, NULL),
(449, 124, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002713, 'PHP', 0, NULL),
(450, 124, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002713, 'PHP', 0, NULL),
(451, 125, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002774, 'PHP', 0, NULL),
(452, 125, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543002774, 'PHP', 0, NULL),
(453, 125, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002774, 'PHP', 0, NULL),
(454, 125, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543002774, 'PHP', 0, NULL),
(455, 126, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:18:\"Ingreso_Sin_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003615, 'ASSIGN', 47, 'nodes_hierarchy'),
(456, 126, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:18:\"Ingreso_Sin_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003615, 'ASSIGN', 47, 'nodes_hierarchy'),
(457, 126, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:18:\"Ingreso_Sin_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003615, 'ASSIGN', 47, 'nodes_hierarchy'),
(458, 127, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543003619, 'PHP', 0, NULL),
(459, 127, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543003619, 'PHP', 0, NULL),
(460, 127, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543003619, 'PHP', 0, NULL),
(461, 127, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543003620, 'PHP', 0, NULL),
(462, 128, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543003834, 'PHP', 0, NULL),
(463, 128, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543003834, 'PHP', 0, NULL),
(464, 128, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543003834, 'PHP', 0, NULL),
(465, 128, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543003834, 'PHP', 0, NULL),
(466, 129, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:12:\"Crear_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003999, 'ASSIGN', 49, 'nodes_hierarchy'),
(467, 129, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:12:\"Crear_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003999, 'ASSIGN', 49, 'nodes_hierarchy'),
(468, 129, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:12:\"Crear_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543003999, 'ASSIGN', 49, 'nodes_hierarchy'),
(469, 130, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543004002, 'PHP', 0, NULL),
(470, 130, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543004003, 'PHP', 0, NULL),
(471, 130, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543004003, 'PHP', 0, NULL),
(472, 130, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543004003, 'PHP', 0, NULL),
(473, 131, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543006789, 'PHP', 0, NULL),
(474, 131, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543006789, 'PHP', 0, NULL),
(475, 131, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543006789, 'PHP', 0, NULL),
(476, 131, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543006789, 'PHP', 0, NULL),
(477, 132, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543006892, 'PHP', 0, NULL),
(478, 132, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543006892, 'PHP', 0, NULL),
(479, 132, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543006892, 'PHP', 0, NULL),
(480, 132, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543006892, 'PHP', 0, NULL),
(481, 133, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007012, 'PHP', 0, NULL),
(482, 133, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007012, 'PHP', 0, NULL),
(483, 133, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007012, 'PHP', 0, NULL),
(484, 133, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007012, 'PHP', 0, NULL),
(485, 134, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007066, 'PHP', 0, NULL),
(486, 134, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007066, 'PHP', 0, NULL),
(487, 134, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007066, 'PHP', 0, NULL),
(488, 134, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007066, 'PHP', 0, NULL),
(489, 135, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007156, 'PHP', 0, NULL),
(490, 135, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007156, 'PHP', 0, NULL),
(491, 135, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007156, 'PHP', 0, NULL),
(492, 135, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007156, 'PHP', 0, NULL),
(493, 136, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007299, 'PHP', 0, NULL),
(494, 136, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007299, 'PHP', 0, NULL),
(495, 136, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007299, 'PHP', 0, NULL),
(496, 136, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007299, 'PHP', 0, NULL),
(497, 137, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007305, 'PHP', 0, NULL),
(498, 137, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007305, 'PHP', 0, NULL),
(499, 137, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007305, 'PHP', 0, NULL),
(500, 137, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007305, 'PHP', 0, NULL),
(501, 138, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007318, 'PHP', 0, NULL),
(502, 138, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007318, 'PHP', 0, NULL),
(503, 138, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007318, 'PHP', 0, NULL),
(504, 138, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007318, 'PHP', 0, NULL),
(505, 139, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007321, 'PHP', 0, NULL),
(506, 139, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007321, 'PHP', 0, NULL),
(507, 139, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007321, 'PHP', 0, NULL),
(508, 139, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007321, 'PHP', 0, NULL),
(509, 140, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007330, 'PHP', 0, NULL),
(510, 140, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007330, 'PHP', 0, NULL),
(511, 140, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007330, 'PHP', 0, NULL),
(512, 140, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007330, 'PHP', 0, NULL),
(513, 141, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007332, 'PHP', 0, NULL),
(514, 141, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007332, 'PHP', 0, NULL),
(515, 141, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007332, 'PHP', 0, NULL),
(516, 141, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007332, 'PHP', 0, NULL),
(517, 142, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007338, 'PHP', 0, NULL),
(518, 142, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007338, 'PHP', 0, NULL),
(519, 142, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007338, 'PHP', 0, NULL),
(520, 142, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007339, 'PHP', 0, NULL),
(521, 143, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007341, 'PHP', 0, NULL),
(522, 143, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007341, 'PHP', 0, NULL),
(523, 143, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007341, 'PHP', 0, NULL),
(524, 143, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007341, 'PHP', 0, NULL),
(525, 144, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007347, 'PHP', 0, NULL),
(526, 144, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007347, 'PHP', 0, NULL),
(527, 144, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007347, 'PHP', 0, NULL),
(528, 144, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007347, 'PHP', 0, NULL),
(529, 145, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:14:\"Ingreso_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543007844, 'ASSIGN', 51, 'nodes_hierarchy'),
(530, 145, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:14:\"Ingreso_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543007844, 'ASSIGN', 51, 'nodes_hierarchy'),
(531, 145, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:14:\"Ingreso_Cuenta\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543007844, 'ASSIGN', 51, 'nodes_hierarchy'),
(532, 146, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007849, 'PHP', 0, NULL),
(533, 146, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543007849, 'PHP', 0, NULL),
(534, 146, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007849, 'PHP', 0, NULL),
(535, 146, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543007849, 'PHP', 0, NULL),
(536, 147, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543008218, 'PHP', 0, NULL),
(537, 147, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543008218, 'PHP', 0, NULL),
(538, 147, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543008218, 'PHP', 0, NULL),
(539, 147, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543008218, 'PHP', 0, NULL),
(540, 148, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"Alto\";i:1;s:18:\"Cambio_Contraseña\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543008313, 'ASSIGN', 53, 'nodes_hierarchy'),
(541, 148, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:4:\"baja\";i:1;s:18:\"Cambio_Contraseña\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543008313, 'ASSIGN', 53, 'nodes_hierarchy'),
(542, 148, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:35:\"audit_keyword_assignment_removed_tc\";s:6:\"params\";a:2:{i:0;s:5:\"media\";i:1;s:18:\"Cambio_Contraseña\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543008313, 'ASSIGN', 53, 'nodes_hierarchy'),
(543, 149, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543009278, 'PHP', 0, NULL),
(544, 149, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543009279, 'PHP', 0, NULL),
(545, 149, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543009279, 'PHP', 0, NULL),
(546, 149, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543009279, 'PHP', 0, NULL),
(547, 150, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543009431, 'PHP', 0, NULL),
(548, 150, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543009431, 'PHP', 0, NULL),
(549, 150, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543009431, 'PHP', 0, NULL),
(550, 150, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543009431, 'PHP', 0, NULL),
(551, 151, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:35:\"/ArtMarVal/AMV-Empresa/AMV-25:Envio\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543010522, 'ASSIGN', 62, 'nodes_hierarchy'),
(552, 152, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010526, 'PHP', 0, NULL),
(553, 152, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010526, 'PHP', 0, NULL),
(554, 152, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010526, 'PHP', 0, NULL),
(555, 152, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010526, 'PHP', 0, NULL),
(556, 153, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:41:\"/ArtMarVal/AMV-Empresa/AMV-26:Aviso_legal\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543010744, 'ASSIGN', 64, 'nodes_hierarchy'),
(557, 154, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010760, 'PHP', 0, NULL),
(558, 154, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010760, 'PHP', 0, NULL),
(559, 154, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010760, 'PHP', 0, NULL),
(560, 154, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010760, 'PHP', 0, NULL),
(561, 155, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:50:\"/ArtMarVal/AMV-Empresa/AMV-27:Terminos_Condiciones\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543010934, 'ASSIGN', 66, 'nodes_hierarchy'),
(562, 156, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010992, 'PHP', 0, NULL),
(563, 156, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543010992, 'PHP', 0, NULL),
(564, 156, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010992, 'PHP', 0, NULL),
(565, 156, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543010992, 'PHP', 0, NULL),
(566, 157, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:44:\"/ArtMarVal/AMV-Empresa/AMV-28:Sobre_Nosotros\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543011468, 'ASSIGN', 68, 'nodes_hierarchy'),
(567, 158, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543011472, 'PHP', 0, NULL),
(568, 158, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543011472, 'PHP', 0, NULL),
(569, 158, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543011472, 'PHP', 0, NULL),
(570, 158, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543011472, 'PHP', 0, NULL);
INSERT INTO `events` (`id`, `transaction_id`, `log_level`, `source`, `description`, `fired_at`, `activity`, `object_id`, `object_type`) VALUES
(571, 159, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:41:\"/ArtMarVal/AMV-Empresa/AMV-29:Pago_Seguro\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543011683, 'ASSIGN', 70, 'nodes_hierarchy'),
(572, 160, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543011686, 'PHP', 0, NULL),
(573, 160, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543011686, 'PHP', 0, NULL),
(574, 160, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543011686, 'PHP', 0, NULL),
(575, 160, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543011686, 'PHP', 0, NULL),
(576, 161, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:38:\"/ArtMarVal/AMV-Empresa/AMV-30:Contacto\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543012238, 'ASSIGN', 72, 'nodes_hierarchy'),
(577, 162, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012243, 'PHP', 0, NULL),
(578, 162, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012243, 'PHP', 0, NULL),
(579, 162, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012243, 'PHP', 0, NULL),
(580, 162, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012243, 'PHP', 0, NULL),
(581, 163, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012409, 'PHP', 0, NULL),
(582, 163, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012409, 'PHP', 0, NULL),
(583, 163, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012409, 'PHP', 0, NULL),
(584, 163, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012409, 'PHP', 0, NULL),
(585, 164, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012479, 'PHP', 0, NULL),
(586, 164, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543012479, 'PHP', 0, NULL),
(587, 164, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012479, 'PHP', 0, NULL),
(588, 164, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543012479, 'PHP', 0, NULL),
(589, 165, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:5:\"media\";i:1;s:34:\"/ArtMarVal/AMV-Empresa/AMV-31:Mapa\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543012989, 'ASSIGN', 74, 'nodes_hierarchy'),
(590, 166, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543013229, 'PHP', 0, NULL),
(591, 166, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543013229, 'PHP', 0, NULL),
(592, 166, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543013229, 'PHP', 0, NULL),
(593, 166, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543013229, 'PHP', 0, NULL),
(594, 167, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:37:\"/ArtMarVal/AMV-Empresa/AMV-32:Tiendas\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543013516, 'ASSIGN', 76, 'nodes_hierarchy'),
(595, 168, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543013522, 'PHP', 0, NULL),
(596, 168, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543013522, 'PHP', 0, NULL),
(597, 168, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543013522, 'PHP', 0, NULL),
(598, 168, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543013522, 'PHP', 0, NULL),
(599, 169, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1543014512, 'LOCALIZATION', 0, NULL),
(600, 170, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543014518, 'LOGIN', 1, 'users'),
(601, 171, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:7:\"Critico\";i:1;s:51:\"/ArtMarVal/AMV-SuCuenta/AMV-33:Informacion_Personal\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543014775, 'ASSIGN', 78, 'nodes_hierarchy'),
(602, 172, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543014778, 'PHP', 0, NULL),
(603, 172, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543014778, 'PHP', 0, NULL),
(604, 172, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543014778, 'PHP', 0, NULL),
(605, 172, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543014778, 'PHP', 0, NULL),
(606, 173, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016170, 'PHP', 0, NULL),
(607, 173, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016170, 'PHP', 0, NULL),
(608, 173, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016170, 'PHP', 0, NULL),
(609, 173, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016170, 'PHP', 0, NULL),
(610, 174, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016320, 'PHP', 0, NULL),
(611, 174, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016320, 'PHP', 0, NULL),
(612, 174, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016320, 'PHP', 0, NULL),
(613, 174, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016320, 'PHP', 0, NULL),
(614, 175, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:38:\"/ArtMarVal/AMV-SuCuenta/AMV-34:Pedidos\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543016609, 'ASSIGN', 80, 'nodes_hierarchy'),
(615, 176, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016612, 'PHP', 0, NULL),
(616, 176, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016612, 'PHP', 0, NULL),
(617, 176, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016612, 'PHP', 0, NULL),
(618, 176, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016612, 'PHP', 0, NULL),
(619, 177, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016649, 'PHP', 0, NULL),
(620, 177, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543016649, 'PHP', 0, NULL),
(621, 177, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016649, 'PHP', 0, NULL),
(622, 177, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543016649, 'PHP', 0, NULL),
(623, 178, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:39:\"/ArtMarVal/AMV-SuCuenta/AMV-35:Facturas\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543018236, 'ASSIGN', 82, 'nodes_hierarchy'),
(624, 179, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543018239, 'PHP', 0, NULL),
(625, 179, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543018239, 'PHP', 0, NULL),
(626, 179, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543018239, 'PHP', 0, NULL),
(627, 179, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543018239, 'PHP', 0, NULL),
(628, 180, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543018257, 'PHP', 0, NULL),
(629, 180, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543018257, 'PHP', 0, NULL),
(630, 180, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543018257, 'PHP', 0, NULL),
(631, 180, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543018258, 'PHP', 0, NULL),
(632, 181, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:42:\"/ArtMarVal/AMV-SuCuenta/AMV-36:Direcciones\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543019175, 'ASSIGN', 84, 'nodes_hierarchy'),
(633, 182, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019178, 'PHP', 0, NULL),
(634, 182, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019178, 'PHP', 0, NULL),
(635, 182, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019178, 'PHP', 0, NULL),
(636, 182, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019178, 'PHP', 0, NULL),
(637, 183, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019301, 'PHP', 0, NULL),
(638, 183, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019301, 'PHP', 0, NULL),
(639, 183, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019301, 'PHP', 0, NULL),
(640, 183, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019301, 'PHP', 0, NULL),
(641, 184, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019774, 'PHP', 0, NULL),
(642, 184, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543019774, 'PHP', 0, NULL),
(643, 184, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019774, 'PHP', 0, NULL),
(644, 184, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543019774, 'PHP', 0, NULL),
(645, 185, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:45:\"/ArtMarVal/AMV-FooterProductos/AMV-37:Ofertas\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543022787, 'ASSIGN', 86, 'nodes_hierarchy'),
(646, 186, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543022797, 'PHP', 0, NULL),
(647, 186, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543022797, 'PHP', 0, NULL),
(648, 186, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543022797, 'PHP', 0, NULL),
(649, 186, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543022797, 'PHP', 0, NULL),
(650, 187, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:47:\"/ArtMarVal/AMV-FooterProductos/AMV-38:Novedades\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543023818, 'ASSIGN', 88, 'nodes_hierarchy'),
(651, 188, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023822, 'PHP', 0, NULL),
(652, 188, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023822, 'PHP', 0, NULL),
(653, 188, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023822, 'PHP', 0, NULL),
(654, 188, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023822, 'PHP', 0, NULL),
(655, 189, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023825, 'PHP', 0, NULL),
(656, 189, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023825, 'PHP', 0, NULL),
(657, 189, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023825, 'PHP', 0, NULL),
(658, 189, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023825, 'PHP', 0, NULL),
(659, 190, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:25:\"audit_keyword_assigned_tc\";s:6:\"params\";a:3:{i:0;s:4:\"Alto\";i:1;s:52:\"/ArtMarVal/AMV-FooterProductos/AMV-39:Lo_mas_vendido\";i:2;i:1;}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543023933, 'ASSIGN', 90, 'nodes_hierarchy'),
(660, 191, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023938, 'PHP', 0, NULL),
(661, 191, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 40', 1543023938, 'PHP', 0, NULL),
(662, 191, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nUndefined index: args_testcase - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023938, 'PHP', 0, NULL),
(663, 191, 2, 'GUI - Test Project ID : 1', 'E_NOTICE\nTrying to get property of non-object - in C:\\xampp\\htdocs\\testlink\\gui\\templates_c\\0b894f7fa64e48077463361dcf39c88907a1c4aa.file.inc_tcbody.tpl.php - Line 42', 1543023938, 'PHP', 0, NULL),
(664, 192, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543082993, 'LOGIN', 1, 'users'),
(665, 193, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1543200647, 'LOCALIZATION', 0, NULL),
(666, 194, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543200664, 'LOGIN', 1, 'users'),
(667, 195, 32, 'GUI', 'string \'oauth_login\' is not localized for locale \'es_ES\'  - using en_GB', 1543202457, 'LOCALIZATION', 0, NULL),
(668, 196, 16, 'GUI - Test Project ID : 1', 'O:18:\"tlMetaStringHelper\":4:{s:5:\"label\";s:21:\"audit_login_succeeded\";s:6:\"params\";a:2:{i:0;s:5:\"admin\";i:1;s:3:\"::1\";}s:13:\"bDontLocalize\";b:0;s:14:\"bDontFireEvent\";b:0;}', 1543202467, 'LOGIN', 1, 'users');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `executions`
--

CREATE TABLE `executions` (
  `id` int(10) UNSIGNED NOT NULL,
  `build_id` int(10) NOT NULL DEFAULT '0',
  `tester_id` int(10) UNSIGNED DEFAULT NULL,
  `execution_ts` datetime DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tcversion_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tcversion_number` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `platform_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `execution_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 -> manual, 2 -> automated',
  `execution_duration` decimal(6,2) DEFAULT NULL COMMENT 'NULL will be considered as NO DATA Provided by user',
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `execution_bugs`
--

CREATE TABLE `execution_bugs` (
  `execution_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `bug_id` varchar(64) NOT NULL DEFAULT '0',
  `tcstep_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `execution_tcsteps`
--

CREATE TABLE `execution_tcsteps` (
  `id` int(10) UNSIGNED NOT NULL,
  `execution_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tcstep_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `notes` text,
  `status` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventory`
--

CREATE TABLE `inventory` (
  `id` int(10) UNSIGNED NOT NULL,
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `owner_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `ipaddress` varchar(255) NOT NULL,
  `content` text,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modification_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `issuetrackers`
--

CREATE TABLE `issuetrackers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT '0',
  `cfg` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `keywords`
--

CREATE TABLE `keywords` (
  `id` int(10) UNSIGNED NOT NULL,
  `keyword` varchar(100) NOT NULL DEFAULT '',
  `testproject_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `keywords`
--

INSERT INTO `keywords` (`id`, `keyword`, `testproject_id`, `notes`) VALUES
(1, 'Critico', 1, 'nivel de criticidad muy alta'),
(2, 'Alto', 1, 'nivel de criticidad alta'),
(3, 'media', 1, 'nivel de criticidad media'),
(4, 'baja', 1, 'nivel de criticidad baja');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `latest_req_version`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `latest_req_version` (
`req_id` int(10) unsigned
,`version` smallint(5) unsigned
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `latest_req_version_id`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `latest_req_version_id` (
`req_id` int(10) unsigned
,`version` smallint(5) unsigned
,`req_version_id` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `latest_rspec_revision`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `latest_rspec_revision` (
`req_spec_id` int(10) unsigned
,`testproject_id` int(10) unsigned
,`revision` smallint(5) unsigned
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `latest_tcase_version_id`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `latest_tcase_version_id` (
`testcase_id` int(10) unsigned
,`version` smallint(5) unsigned
,`tcversion_id` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `latest_tcase_version_number`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `latest_tcase_version_number` (
`testcase_id` int(10) unsigned
,`version` smallint(5) unsigned
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `milestones`
--

CREATE TABLE `milestones` (
  `id` int(10) UNSIGNED NOT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `target_date` date DEFAULT NULL,
  `start_date` date NOT NULL,
  `a` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `b` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `c` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT 'undefined'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nodes_hierarchy`
--

CREATE TABLE `nodes_hierarchy` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `node_type_id` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `node_order` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `nodes_hierarchy`
--

INSERT INTO `nodes_hierarchy` (`id`, `name`, `parent_id`, `node_type_id`, `node_order`) VALUES
(1, 'ArtMarVal', NULL, 1, 1),
(2, 'Plan de Pruebas AMV', 1, 5, 0),
(3, 'AMV-Main', 1, 2, 1),
(4, 'AMV-Lista', 1, 2, 2),
(5, 'AMV-Productos', 1, 2, 3),
(6, 'AMV-Login/Signin', 1, 2, 4),
(7, 'Ingreso_pagina', 3, 3, 1000),
(8, '', 7, 4, 0),
(9, 'Titulo_Favicon', 3, 3, 1001),
(10, '', 9, 4, 0),
(11, 'Logo', 3, 3, 1002),
(12, '', 11, 4, 0),
(13, 'Menus', 3, 3, 1003),
(14, '', 13, 4, 0),
(15, 'Imagen_Portada', 3, 3, 1004),
(16, '', 15, 4, 0),
(17, 'Galeria_Productos', 3, 3, 1005),
(18, '', 17, 4, 0),
(19, 'Subscripcion', 3, 3, 1006),
(20, '', 19, 4, 0),
(21, 'Footer', 3, 3, 1007),
(22, '', 21, 4, 0),
(23, 'Filtro_Menus', 4, 3, 1000),
(24, '', 23, 4, 0),
(25, 'Filtro_Categoria', 4, 3, 1001),
(26, '', 25, 4, 0),
(27, 'Filtro_Precio', 4, 3, 1002),
(28, '', 27, 4, 0),
(29, 'Titulo_Logo', 4, 3, 1003),
(30, '', 29, 4, 0),
(31, 'Orden_por', 4, 3, 1004),
(32, '', 31, 4, 0),
(33, 'Cantidad_lista', 4, 3, 1005),
(34, '', 33, 4, 0),
(35, 'Navegador_Lista', 4, 3, 1006),
(36, '', 35, 4, 0),
(37, 'Direccion', 5, 3, 1000),
(38, '', 37, 4, 0),
(39, 'Galeria_imagen', 5, 3, 1001),
(40, '', 39, 4, 0),
(41, 'Informacion_producto', 5, 3, 1002),
(42, '', 41, 4, 0),
(43, 'Carro_deshabilitado', 5, 3, 1003),
(44, '', 43, 4, 0),
(45, 'Descripcion_Detalles', 5, 3, 1004),
(46, '', 45, 4, 0),
(47, 'Ingreso_Sin_Cuenta', 6, 3, 1000),
(48, '', 47, 4, 0),
(49, 'Crear_Cuenta', 6, 3, 1001),
(50, '', 49, 4, 0),
(51, 'Ingreso_Cuenta', 6, 3, 1002),
(52, '', 51, 4, 0),
(53, 'Cambio_Contraseña', 6, 3, 1003),
(54, '', 53, 4, 0),
(55, '', 8, 9, 0),
(56, '', 8, 9, 0),
(57, 'AMV-Empresa', 1, 2, 5),
(59, 'AMV-SuCuenta', 1, 2, 6),
(60, 'AMV-FooterProductos', 1, 2, 7),
(61, 'Envio', 57, 3, 1000),
(62, '', 61, 4, 0),
(63, 'Aviso_legal', 57, 3, 1001),
(64, '', 63, 4, 0),
(65, 'Terminos_Condiciones', 57, 3, 1002),
(66, '', 65, 4, 0),
(67, 'Sobre_Nosotros', 57, 3, 1003),
(68, '', 67, 4, 0),
(69, 'Pago_Seguro', 57, 3, 1004),
(70, '', 69, 4, 0),
(71, 'Contacto', 57, 3, 1005),
(72, '', 71, 4, 0),
(73, 'Mapa', 57, 3, 1006),
(74, '', 73, 4, 0),
(75, 'Tiendas', 57, 3, 1007),
(76, '', 75, 4, 0),
(77, 'Informacion_Personal', 59, 3, 1000),
(78, '', 77, 4, 0),
(79, 'Pedidos', 59, 3, 1001),
(80, '', 79, 4, 0),
(81, 'Facturas', 59, 3, 1002),
(82, '', 81, 4, 0),
(83, 'Direcciones', 59, 3, 1003),
(84, '', 83, 4, 0),
(85, 'Ofertas', 60, 3, 1000),
(86, '', 85, 4, 0),
(87, 'Novedades', 60, 3, 1001),
(88, '', 87, 4, 0),
(89, 'Lo_mas_vendido', 60, 3, 1002),
(90, '', 89, 4, 0),
(91, '', 10, 9, 0),
(92, '', 10, 9, 0),
(93, '', 12, 9, 0),
(94, '', 12, 9, 0),
(95, '', 14, 9, 0),
(96, '', 14, 9, 0),
(97, '', 16, 9, 0),
(98, '', 16, 9, 0),
(99, '', 18, 9, 0),
(100, '', 18, 9, 0),
(101, '', 18, 9, 0),
(102, '', 18, 9, 0),
(103, '', 18, 9, 0),
(104, '', 20, 9, 0),
(105, '', 20, 9, 0),
(106, '', 20, 9, 0),
(107, '', 20, 9, 0),
(108, '', 22, 9, 0),
(109, '', 24, 9, 0),
(110, '', 24, 9, 0),
(111, '', 24, 9, 0),
(113, '', 26, 9, 0),
(114, '', 26, 9, 0),
(115, '', 28, 9, 0),
(116, '', 28, 9, 0),
(117, '', 30, 9, 0),
(118, '', 30, 9, 0),
(119, '', 32, 9, 0),
(120, '', 32, 9, 0),
(121, '', 32, 9, 0),
(122, '', 34, 9, 0),
(123, '', 36, 9, 0),
(124, '', 36, 9, 0),
(125, '', 36, 9, 0),
(126, '', 36, 9, 0),
(127, '', 38, 9, 0),
(128, '', 38, 9, 0),
(129, '', 40, 9, 0),
(130, '', 40, 9, 0),
(132, '', 42, 9, 0),
(133, '', 44, 9, 0),
(134, '', 46, 9, 0),
(135, '', 46, 9, 0),
(136, '', 48, 9, 0),
(137, '', 48, 9, 0),
(138, '', 50, 9, 0),
(139, '', 50, 9, 0),
(140, '', 50, 9, 0),
(141, '', 50, 9, 0),
(142, '', 50, 9, 0),
(143, '', 50, 9, 0),
(144, '', 52, 9, 0),
(145, '', 54, 9, 0),
(146, '', 54, 9, 0),
(147, '', 62, 9, 0),
(148, '', 64, 9, 0),
(149, '', 66, 9, 0),
(150, '', 68, 9, 0),
(151, '', 70, 9, 0),
(152, '', 72, 9, 0),
(153, '', 72, 9, 0),
(154, '', 72, 9, 0),
(155, '', 74, 9, 0),
(156, '', 76, 9, 0),
(157, '', 78, 9, 0),
(158, '', 78, 9, 0),
(159, '', 78, 9, 0),
(160, '', 80, 9, 0),
(161, '', 82, 9, 0),
(162, '', 84, 9, 0),
(163, '', 86, 9, 0),
(164, '', 88, 9, 0),
(165, '', 90, 9, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `node_types`
--

CREATE TABLE `node_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` varchar(100) NOT NULL DEFAULT 'testproject'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `node_types`
--

INSERT INTO `node_types` (`id`, `description`) VALUES
(1, 'testproject'),
(2, 'testsuite'),
(3, 'testcase'),
(4, 'testcase_version'),
(5, 'testplan'),
(6, 'requirement_spec'),
(7, 'requirement'),
(8, 'requirement_version'),
(9, 'testcase_step'),
(10, 'requirement_revision'),
(11, 'requirement_spec_revision'),
(12, 'build'),
(13, 'platform'),
(14, 'user');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `object_keywords`
--

CREATE TABLE `object_keywords` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `fk_table` varchar(30) DEFAULT '',
  `keyword_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `object_keywords`
--

INSERT INTO `object_keywords` (`id`, `fk_id`, `fk_table`, `keyword_id`) VALUES
(1, 3, 'nodes_hierarchy', 1),
(2, 3, 'nodes_hierarchy', 2),
(3, 3, 'nodes_hierarchy', 3),
(4, 3, 'nodes_hierarchy', 4),
(9, 4, 'nodes_hierarchy', 1),
(10, 4, 'nodes_hierarchy', 2),
(11, 4, 'nodes_hierarchy', 3),
(12, 4, 'nodes_hierarchy', 4),
(13, 5, 'nodes_hierarchy', 1),
(14, 5, 'nodes_hierarchy', 2),
(15, 5, 'nodes_hierarchy', 3),
(16, 5, 'nodes_hierarchy', 4),
(17, 6, 'nodes_hierarchy', 1),
(18, 6, 'nodes_hierarchy', 2),
(19, 6, 'nodes_hierarchy', 3),
(20, 6, 'nodes_hierarchy', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `platforms`
--

CREATE TABLE `platforms` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `notes` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plugins`
--

CREATE TABLE `plugins` (
  `id` int(11) NOT NULL,
  `basename` varchar(100) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plugins_configuration`
--

CREATE TABLE `plugins_configuration` (
  `id` int(11) NOT NULL,
  `testproject_id` int(11) NOT NULL,
  `config_key` varchar(255) NOT NULL,
  `config_type` int(11) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reqmgrsystems`
--

CREATE TABLE `reqmgrsystems` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` int(10) DEFAULT '0',
  `cfg` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requirements`
--

CREATE TABLE `requirements` (
  `id` int(10) UNSIGNED NOT NULL,
  `srs_id` int(10) UNSIGNED NOT NULL,
  `req_doc_id` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_coverage`
--

CREATE TABLE `req_coverage` (
  `id` int(10) UNSIGNED NOT NULL,
  `req_id` int(10) NOT NULL,
  `req_version_id` int(10) NOT NULL,
  `testcase_id` int(10) NOT NULL,
  `tcversion_id` int(10) NOT NULL,
  `link_status` int(11) NOT NULL DEFAULT '1',
  `is_active` int(11) NOT NULL DEFAULT '1',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `review_requester_id` int(10) UNSIGNED DEFAULT NULL,
  `review_request_ts` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='relation test case version ** requirement version';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_monitor`
--

CREATE TABLE `req_monitor` (
  `req_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `testproject_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_relations`
--

CREATE TABLE `req_relations` (
  `id` int(10) UNSIGNED NOT NULL,
  `source_id` int(10) UNSIGNED NOT NULL,
  `destination_id` int(10) UNSIGNED NOT NULL,
  `relation_type` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_revisions`
--

CREATE TABLE `req_revisions` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `id` int(10) UNSIGNED NOT NULL,
  `revision` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `req_doc_id` varchar(64) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `scope` text,
  `status` char(1) NOT NULL DEFAULT 'V',
  `type` char(1) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `expected_coverage` int(10) NOT NULL DEFAULT '1',
  `log_message` text,
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) UNSIGNED DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_specs`
--

CREATE TABLE `req_specs` (
  `id` int(10) UNSIGNED NOT NULL,
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `doc_id` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Dev. Documents (e.g. System Requirements Specification)';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_specs_revisions`
--

CREATE TABLE `req_specs_revisions` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `id` int(10) UNSIGNED NOT NULL,
  `revision` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `doc_id` varchar(64) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `scope` text,
  `total_req` int(10) NOT NULL DEFAULT '0',
  `status` int(10) UNSIGNED DEFAULT '1',
  `type` char(1) DEFAULT NULL,
  `log_message` text,
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) UNSIGNED DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `req_versions`
--

CREATE TABLE `req_versions` (
  `id` int(10) UNSIGNED NOT NULL,
  `version` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `revision` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `scope` text,
  `status` char(1) NOT NULL DEFAULT 'V',
  `type` char(1) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `expected_coverage` int(10) NOT NULL DEFAULT '1',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) UNSIGNED DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log_message` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rights`
--

CREATE TABLE `rights` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rights`
--

INSERT INTO `rights` (`id`, `description`) VALUES
(53, 'cfield_assignment'),
(18, 'cfield_management'),
(17, 'cfield_view'),
(51, 'codetracker_management'),
(52, 'codetracker_view'),
(22, 'events_mgt'),
(54, 'exec_assign_testcases'),
(36, 'exec_delete'),
(35, 'exec_edit_notes'),
(49, 'exec_ro_access'),
(41, 'exec_testcases_assigned_to_me'),
(31, 'issuetracker_management'),
(32, 'issuetracker_view'),
(29, 'keyword_assignment'),
(9, 'mgt_modify_key'),
(12, 'mgt_modify_product'),
(11, 'mgt_modify_req'),
(7, 'mgt_modify_tc'),
(48, 'mgt_plugins'),
(16, 'mgt_testplan_create'),
(30, 'mgt_unfreeze_req'),
(13, 'mgt_users'),
(20, 'mgt_view_events'),
(8, 'mgt_view_key'),
(10, 'mgt_view_req'),
(6, 'mgt_view_tc'),
(21, 'mgt_view_usergroups'),
(50, 'monitor_requirement'),
(24, 'platform_management'),
(25, 'platform_view'),
(26, 'project_inventory_management'),
(27, 'project_inventory_view'),
(33, 'reqmgrsystem_management'),
(34, 'reqmgrsystem_view'),
(28, 'req_tcase_link_management'),
(14, 'role_management'),
(19, 'system_configuration'),
(47, 'testcase_freeze'),
(43, 'testplan_add_remove_platforms'),
(2, 'testplan_create_build'),
(1, 'testplan_execute'),
(3, 'testplan_metrics'),
(40, 'testplan_milestone_overview'),
(4, 'testplan_planning'),
(45, 'testplan_set_urgent_testcases'),
(46, 'testplan_show_testcases_newest_versions'),
(37, 'testplan_unlink_executed_testcases'),
(44, 'testplan_update_linked_testcase_versions'),
(5, 'testplan_user_role_assignment'),
(38, 'testproject_delete_executed_testcases'),
(39, 'testproject_edit_executed_testcases'),
(42, 'testproject_metrics_dashboard'),
(23, 'testproject_user_role_assignment'),
(15, 'user_role_assignment');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `risk_assignments`
--

CREATE TABLE `risk_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `node_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `risk` char(1) NOT NULL DEFAULT '2',
  `importance` char(1) NOT NULL DEFAULT 'M'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` varchar(100) NOT NULL DEFAULT '',
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `description`, `notes`) VALUES
(1, '<reserved system role 1>', NULL),
(2, '<reserved system role 2>', NULL),
(3, '<no rights>', NULL),
(4, 'test designer', NULL),
(5, 'guest', NULL),
(6, 'senior tester', NULL),
(7, 'tester', NULL),
(8, 'admin', NULL),
(9, 'leader', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_rights`
--

CREATE TABLE `role_rights` (
  `role_id` int(10) NOT NULL DEFAULT '0',
  `right_id` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `role_rights`
--

INSERT INTO `role_rights` (`role_id`, `right_id`) VALUES
(4, 3),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 28),
(4, 29),
(4, 30),
(4, 50),
(5, 3),
(5, 6),
(5, 8),
(6, 1),
(6, 2),
(6, 3),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 11),
(6, 25),
(6, 27),
(6, 28),
(6, 29),
(6, 30),
(6, 50),
(7, 1),
(7, 3),
(7, 6),
(7, 8),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 10),
(8, 11),
(8, 12),
(8, 13),
(8, 14),
(8, 15),
(8, 16),
(8, 17),
(8, 18),
(8, 19),
(8, 20),
(8, 21),
(8, 22),
(8, 23),
(8, 24),
(8, 25),
(8, 26),
(8, 27),
(8, 28),
(8, 29),
(8, 30),
(8, 31),
(8, 32),
(8, 33),
(8, 34),
(8, 35),
(8, 36),
(8, 37),
(8, 38),
(8, 39),
(8, 40),
(8, 41),
(8, 42),
(8, 43),
(8, 44),
(8, 45),
(8, 46),
(8, 47),
(8, 48),
(8, 50),
(8, 51),
(8, 52),
(8, 53),
(8, 54),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(9, 11),
(9, 15),
(9, 16),
(9, 24),
(9, 25),
(9, 26),
(9, 27),
(9, 28),
(9, 29),
(9, 30),
(9, 47),
(9, 50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tcsteps`
--

CREATE TABLE `tcsteps` (
  `id` int(10) UNSIGNED NOT NULL,
  `step_number` int(11) NOT NULL DEFAULT '1',
  `actions` text,
  `expected_results` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `execution_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 -> manual, 2 -> automated'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tcsteps`
--

INSERT INTO `tcsteps` (`id`, `step_number`, `actions`, `expected_results`, `active`, `execution_type`) VALUES
(55, 1, '<p>El usuario ingresa al sitio</p>\r\n', '<p>La pagina carga correctamente con la direccion url:</p>\r\n\r\n<p>http://localhost/ArtMarVal/</p>\r\n', 1, 1),
(56, 2, '<p>El usuario verifica los componentes de la pagina</p>\r\n', '<p>La pagina debe contener lo siguiente:</p>\r\n\r\n<p>Cabecera:</p>\r\n\r\n<ul>\r\n	<li>Link Contacte con nosotros</li>\r\n	<li>Link Iniciar Sesion</li>\r\n	<li>Barra de Busqueda</li>\r\n	<li>Menus\r\n	<ul>\r\n		<li>Figuras de Madera</li>\r\n		<li>Cuadros y Pinturas</li>\r\n		<li>Otros</li>\r\n	</ul>\r\n	</li>\r\n	<li>Logo de la tienda</li>\r\n</ul>\r\n\r\n<p>Cuerpo:</p>\r\n\r\n<ul>\r\n	<li>Scroll de imagenes de portada</li>\r\n	<li>Galeria de productos destacados</li>\r\n	<li>Link Todos los Productos</li>\r\n</ul>\r\n\r\n<p>Pie:</p>\r\n\r\n<ul>\r\n	<li>Barra subscripcion</li>\r\n	<li>Links Productos\r\n	<ul>\r\n		<li>Ofertas</li>\r\n		<li>Novedades</li>\r\n		<li>Los Mas Vendidos</li>\r\n	</ul>\r\n	</li>\r\n	<li>Links Nuestra Empresa\r\n	<ul>\r\n		<li>Envio</li>\r\n		<li>Aviso Legal</li>\r\n		<li>T&eacute;rminos y condiciones</li>\r\n		<li>Sobre nosotros</li>\r\n		<li>Pago seguro</li>\r\n		<li>Contacte con nosotros</li>\r\n		<li>Mapa del sitio</li>\r\n		<li>Tiendas</li>\r\n	</ul>\r\n	</li>\r\n	<li>Links Su Cuenta\r\n	<ul>\r\n		<li>Informaci&oacute;n personal</li>\r\n		<li>Pedidos</li>\r\n		<li>Facturas por abono</li>\r\n		<li>Direcciones</li>\r\n	</ul>\r\n	</li>\r\n	<li>Informacion de la tienda\r\n	<ul>\r\n		<li>ArtMarVal<br />\r\n		Chile&nbsp;<br />\r\n		Env&iacute;enos un correo electr&oacute;nico:&nbsp;<a href=\"mailto:luis.mardones2017@twk.cl\">luis.mardones2017@twk.cl</a></li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(91, 1, '<p>El usuario valida que el titulo del sitio este correcto</p>\r\n', '<p>El titulo del sitio es: ArtMarVal</p>\r\n', 1, 1),
(92, 2, '<p>El usuario valida que el favicon corresponde</p>\r\n', '<p>El sitio contiene el favicon correspondiente a ArtMarVal</p>\r\n', 1, 1),
(93, 1, '<p>El usuario verifica que el logo existe dentro de la pagina y corresponde a esta</p>\r\n', '<p>El logo del sitio existe como : Artesanias MarVal</p>\r\n', 1, 1),
(94, 2, '<p>El usuario hace click en el logo del sitio</p>\r\n', '<p>El sistema redirige el sitio a la pagina principal de este</p>\r\n', 1, 1),
(95, 1, '<p>El usuario posiciona el mouse sobre alguno de los menus</p>\r\n', '<ul>\r\n	<li>El link del menu cambiara de color</li>\r\n	<li>El cursor cambiara al modo de seleccion</li>\r\n	<li>En el caso de que el menu tenga subcategorias estas apareceran en un recuadro debajo del menu seleccionado</li>\r\n	<li>Si se posiciona el mouse sobre las subcategorias, todas las reacciones del menu se aplicaran a ellas</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, 1),
(96, 2, '<p>El usuario hace click en uno de los menu o subcategorias</p>\r\n', '<p>El sitio recarga a la pagina con la galeria de productos relacionados al menu o Subcategoria</p>\r\n', 1, 1),
(97, 1, '<p>El usuario valida la existencia del carrusel de imagenes en el sitio</p>\r\n', '<p>El sitio contiene el carrusel de imagenes</p>\r\n', 1, 1),
(98, 2, '<p>El usuario hace click en una de las imagenes mostradas</p>\r\n', '<ul>\r\n	<li>La imagen corresponde a uno de los menu principales del sitio</li>\r\n	<li>El sitio es redirigido a la pagina del menu correspondiente</li>\r\n</ul>\r\n', 1, 1),
(99, 1, '<p>El usuario valida la galeria de productos en el sitio</p>\r\n', '<ul>\r\n	<li>La galeria debe contener 8 productos</li>\r\n	<li>Los productos consisten en:\r\n	<ul>\r\n		<li>una imagen del producto</li>\r\n		<li>el nombre del producto</li>\r\n		<li>el precio del producto en pesos chilenos</li>\r\n	</ul>\r\n	</li>\r\n	<li>Bajo la galeria debe encontrarse el link a la lista completa de productos</li>\r\n</ul>\r\n', 1, 1),
(100, 2, '<p>El usuario posiciona el mouse sobre uno de los productos</p>\r\n', '<p>una opcion de vista rapida aparece</p>\r\n', 1, 1),
(101, 3, '<p>El usuario selecciona vista rapida</p>\r\n', '<p>un pop-up aparece en la pagina el cual contiene esta informacion:</p>\r\n\r\n<ul>\r\n	<li>Imagen principal&nbsp;del producto</li>\r\n	<li>selector de imagenes&nbsp;</li>\r\n	<li>nombre del producto</li>\r\n	<li>precio del producto en pesos chilenos</li>\r\n	<li>detalles del producto</li>\r\n	<li>detalle de impuesto</li>\r\n	<li>selector de cantidad de producto</li>\r\n	<li>boton agregar al carro de compra(deshabilitado)</li>\r\n	<li>aviso de disponibilidad del producto</li>\r\n	<li>opcion de compartir producto en redes sociales(deshabilitado)</li>\r\n</ul>\r\n', 1, 1),
(102, 4, '<p>El usuario hace click en el nombre o imagen de un producto</p>\r\n', '<p>El sitio redirige a la pagina del producto</p>\r\n', 1, 1),
(103, 5, '<p>El usuario hace click al link Todos los productos</p>\r\n', '<p>El sitio redirige a la galeria con todos los productos disponibles sin aplicar filtro alguno</p>\r\n', 1, 1),
(104, 1, '<p>El usuario valida que exista el modulo de subscripcion en la pagina principal</p>\r\n', '<p>El modulo de subscripcion aparece en la pagina debajo de la galeria de productos</p>\r\n', 1, 1),
(105, 2, '<p>El usuario se subscribe con un correo valido</p>\r\n', '<ul>\r\n	<li>El usuario es subscrito al sistema de notificaciones de la tienda</li>\r\n	<li>el siguiente mensaje aparece en pantalla:&nbsp;Se ha suscrito correctamente a este bolet&iacute;n de noticias.</li>\r\n</ul>\r\n', 1, 1),
(106, 3, '<p>El usuario ingresa algun valor que no cumpla la estructura de correo basica: usuario@dominio</p>\r\n', '<ul>\r\n	<li>El usuario falla al subscribirse al sistema de notificaciones de la tienda</li>\r\n	<li>El siguiente mensaje aparece en pantalla:&nbsp;Direcci&oacute;n de correo electr&oacute;nico no v&aacute;lida.</li>\r\n</ul>\r\n', 1, 1),
(107, 4, '<p>El usuario ingresa un correo ya subscrito al servicio de notificaciones</p>\r\n', '<ul>\r\n	<li>El usuario falla al subscribirse al sistema de notificaciones de la tienda</li>\r\n	<li>El siguiente mensaje aparece en pantalla:&nbsp;Esta direcci&oacute;n de correo electr&oacute;nico ya est&aacute; registrada.</li>\r\n</ul>\r\n', 1, 1),
(108, 1, '<p>El usuario valida los componentes del footer</p>\r\n', '<p>El footer del sitio contiene los siguientes componentes con sus links respectivos:</p>\r\n\r\n<ul>\r\n	<li>Productos\r\n	<ul>\r\n		<li>Ofertas</li>\r\n		<li>Novedades</li>\r\n		<li>Los m&aacute;s vendidos</li>\r\n	</ul>\r\n	</li>\r\n	<li>Nuestra Empresa\r\n	<ul>\r\n		<li>Env&iacute;o</li>\r\n		<li>Aviso legal</li>\r\n		<li>T&eacute;rminos y condiciones</li>\r\n		<li>Sobre nosotros</li>\r\n		<li>Pago seguro</li>\r\n		<li>Contacte con nosotros</li>\r\n		<li>Mapa del sitio</li>\r\n		<li>Tiendas</li>\r\n	</ul>\r\n	</li>\r\n	<li>Su cuenta\r\n	<ul>\r\n		<li>Informaci&oacute;n personal</li>\r\n		<li>Pedidos</li>\r\n		<li>Facturas por abono</li>\r\n		<li>Direcciones</li>\r\n	</ul>\r\n	</li>\r\n	<li>Informacion de la tienda\r\n	<ul>\r\n		<li>Nombre del sitio</li>\r\n		<li>Ubicacion</li>\r\n		<li>Correo de contacto</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(109, 1, '<p>El usuario valida el panel de filtro por menu</p>\r\n', '<ol>\r\n	<li>Al acceder por el link de Todos los productos, el sistema redirige a la galeria con todos los productos disponibles, y en el panel de filtro&nbsp;debe&nbsp;aparecer&nbsp;los menu principales con sus subcategorias relacionadas:&nbsp;\r\n	<ul>\r\n		<li>Figuras de madera\r\n		<ul>\r\n			<li>Figuras Colgantes</li>\r\n			<li>Figuras de Pared</li>\r\n			<li>Figuras de Mesa</li>\r\n		</ul>\r\n		</li>\r\n		<li>Cuadros y Pinturas\r\n		<ul>\r\n			<li>Mosaicos</li>\r\n			<li>Perchas</li>\r\n			<li>Pinturas</li>\r\n		</ul>\r\n		</li>\r\n		<li>Otros</li>\r\n	</ul>\r\n	</li>\r\n	<li>Al acceder con uno de los menu principales, el sistema redirige a la galeria de productos relacionada, y en el panel de filtros solo apareceran&nbsp;los filtros por subcategoria ,solo si es que tiene alguna</li>\r\n	<li>Al acceder con subcategoria, el sistema redirige a la galeria de productos relacionada, y&nbsp;el panel de filtro aparece vacio</li>\r\n</ol>\r\n', 1, 1),
(110, 2, '<p>El usuario hace click en uno de los menu principales dentro del filtro</p>\r\n', '<ul>\r\n	<li>El sistema redirige la pagina a la galeria de producto relacionados al menu principal</li>\r\n	<li>Los demas menus desapareceran del panel de filtros</li>\r\n	<li>En el panel de filtro solo quedaran las subcategorias relacionadas</li>\r\n</ul>\r\n', 1, 1),
(111, 3, '<p>El usuario hace click en una de las subcategorias</p>\r\n', '<ul>\r\n	<li>El sistema redirige la pagina a la galeria de producto relacionada a la subcategoria</li>\r\n	<li>El panel de filtro aparece vacio</li>\r\n</ul>\r\n', 1, 1),
(113, 1, '<p>El usuario valida los filtros por categoria en el sitio</p>\r\n', '<ol>\r\n	<li>Al ingresar por el link todos los productos, el sitio redirige a la galeria de todos los productos del sitio, el cual contiene los siguientes filtros por categoria:\r\n	<ul>\r\n		<li>Figuras de madera</li>\r\n		<li>Cuadros y pinturas</li>\r\n		<li>Otros</li>\r\n	</ul>\r\n	</li>\r\n	<li>Al acceder al sitio por medio del menu principal o subcategoria los filtros deben aparecer vacios</li>\r\n</ol>\r\n', 1, 1),
(114, 2, '<p>El usuario selecciona uno de los filtros</p>\r\n', '<p>El sistema recarga la pagina mostrando solos los productos que cumplan con ese filtro</p>\r\n', 1, 1),
(115, 1, '<p>El usuario valida los filtros por precio en el sitio</p>\r\n', '<ol>\r\n	<li>Al ingresar por el link todos los productos, el sitio redirige a la galeria de todos los productos del sitio, el cual contiene los siguientes filtros por precio:\r\n	<ul>\r\n		<li>420,00&nbsp;CLP - 500,00&nbsp;CLP&nbsp;</li>\r\n		<li>840,00&nbsp;CLP - 1.000,00&nbsp;CLP&nbsp;</li>\r\n		<li>1.680,00&nbsp;CLP - 2.000,00&nbsp;CLP</li>\r\n		<li>2.100,00&nbsp;CLP - 2.500,00&nbsp;CLP</li>\r\n		<li>2.521,00&nbsp;CLP - 3.000,00&nbsp;CLP</li>\r\n		<li>4.201,00&nbsp;CLP - 5.000,00&nbsp;CLP</li>\r\n		<li>6.302,00&nbsp;CLP - 8.000,00&nbsp;CLP</li>\r\n		<li>8.403,00&nbsp;CLP - 10.000,00&nbsp;CLP</li>\r\n		<li>12.605,00&nbsp;CLP - 15.000,00&nbsp;CLP</li>\r\n	</ul>\r\n	</li>\r\n	<li>Al acceder al sitio por medio del menu principal o subcategoria los filtros deben aparecer vacios</li>\r\n</ol>\r\n', 1, 1),
(116, 2, '<p>El usuario selecciona uno de los filtros</p>\r\n', '<p>El sistema recarga la pagina mostrando solos los productos que cumplan con ese filtro</p>\r\n', 1, 1),
(117, 1, '<p>El usuario valida el titulo de la lista</p>\r\n', '<p>El titulo de la lista debe ser igual al link del menu o subcategoria&nbsp;del cual se accedio, y en el caso de utilizar el link todos los productos, el titulo debe ser Inicio</p>\r\n', 1, 1),
(118, 2, '<p>El usuario valida la imagen de portada</p>\r\n', '<p>La imagen de portada debe corresponder a uno de los productos relacionados al menu o subcategoria, y en el caso de utilizar el link todos los productos, no debe haber imagen de portada</p>\r\n', 1, 1),
(119, 1, '<p>El usuario valida la existencia del selector</p>\r\n', '<p>El selector aparece sobre la galeria de productos y debajo del titulo</p>\r\n', 1, 1),
(120, 2, '<p>El usuario hace click en el selector</p>\r\n', '<p>Este se despliega mostrando las siguientes opciones:</p>\r\n\r\n<ul>\r\n	<li>Relevancia</li>\r\n	<li>Nombre A a Z</li>\r\n	<li>Nombre Z a A</li>\r\n	<li>Precio: de mas Bajo a mas Alto</li>\r\n	<li>Precio, de mas Alto a mas&nbsp; Bajo</li>\r\n</ul>\r\n', 1, 1),
(121, 3, '<p>El usuario selecciona una de las opciones</p>\r\n', '<p>El sistema recarga la pagina mostrando los productos en el orden correspondiente al tipo de orden seleccionado</p>\r\n', 1, 1),
(122, 1, '<p>El usuario valida los contadores de productos en el sitio</p>\r\n', '<ul>\r\n	<li>Sobre la galeria de productos aparece la cantidad de productos relacionados al filtro seleccionado(o al total del sitio si no se eligio filtro alguno)</li>\r\n	<li>Debajo de la galeria de productos aparecera el contador de productos visibles en la pagina junto al total del filtro seleccionado</li>\r\n	<li>El contador de productos utilizando filtros no puede ser mayor al total de productos dentro del sitio</li>\r\n</ul>\r\n', 1, 1),
(123, 1, '<p>El usuario valida que exista el navegador de paginas</p>\r\n', '<ul>\r\n	<li>El navegador de paginas aparece solo cuando la cantidad de productos por filtro o en su totalidad supera los 12 productos</li>\r\n	<li>Cuando carga por primera vez la pagina la opcion pagina Anterior esta deshabilitada</li>\r\n</ul>\r\n', 1, 1),
(124, 2, '<p>El usuario utiliza la opcion pagina Siguiente</p>\r\n', '<p>El sitio redirige a la siguiente pagina de la galeria de productos, indicado con el numero de pagina resaltado en un color celeste a contraste del negro de los otros numero de pagina</p>\r\n', 1, 1),
(125, 3, '<p>El usuario hace click en un numero de pagina especifico</p>\r\n', '<p>El sitio redirige a la&nbsp;pagina seleccionada de la galeria de productos, indicado con el numero de pagina resaltado en un color celeste a contraste del negro de los otros numero de pagina</p>\r\n', 1, 1),
(126, 4, '<p>El usuario hace click en la ultima pagina disponible</p>\r\n', '<ul>\r\n	<li>El sitio redirige a la&nbsp;pagina seleccionada de la galeria de productos, indicado con el numero de pagina resaltado en un color celeste a contraste del negro de los otros numero de pagina</li>\r\n	<li>El boton siguiente esta deshabilitado</li>\r\n</ul>\r\n', 1, 1),
(127, 1, '<p>El usuario valida la ruta del producto</p>\r\n', '<p>La ruta aparece sobre la imagen principal del producto y contiene lo siguiente:&nbsp;</p>\r\n\r\n<ul>\r\n	<li>Al entrar desde la pagina principal o la galeria de todos los productos: Inicio/NombreProducto</li>\r\n	<li>Al entrar desde menu o subcategoria: Inicio/Menu/Subcategoria/NombreProducto</li>\r\n</ul>\r\n', 1, 1),
(128, 2, '<p>El usuario hace click en alguno de los link de la ruta</p>\r\n', '<p>El sitio redirige a la galeria de imagenes correspondiente al filtro seleccionado, o en el caso de Inicio, a la pagina principal del sitio</p>\r\n', 1, 1),
(129, 1, '<p>El usuario verifica la galeria de imagenes</p>\r\n', '<p>la galeria de imagenes esta compuesta por:</p>\r\n\r\n<ul>\r\n	<li>Una imagen principal que corresponde a la predeterminada para el producto</li>\r\n	<li>Un selector de imagenes</li>\r\n	<li>Botones direccionales para mover el&nbsp;carrusel de imagenes</li>\r\n</ul>\r\n', 1, 1),
(130, 2, '<p>El usuario selecciona una de la imagenes del carrusel de imagenes</p>\r\n', '<p>El sitio muestra la imagen seleccionada como imagen principal</p>\r\n', 1, 1),
(132, 1, '<p>El usuario valida los componentes de la descripcion</p>\r\n', '<p>La descripcion del producto contiene:</p>\r\n\r\n<ul>\r\n	<li>El nombre del producto como titulo</li>\r\n	<li>El precio del producto en Pesos Chilenos</li>\r\n	<li>La notificacion impuestos incluidos</li>\r\n	<li>El nombre del producto como detalle</li>\r\n	<li>El selector de cantidad de productos a comprar</li>\r\n	<li>El boton A&ntilde;adir al carro de compra</li>\r\n	<li>La notificacion de disponibilidad del producto</li>\r\n	<li>Botones para compartir el producto en redes sociales(Deshabilitado)</li>\r\n</ul>\r\n', 1, 1),
(133, 1, '<p>El usuario hace click en el boton A&ntilde;adir al Carrito</p>\r\n', '<p>No se ejecuta accion alguna por parte del sistema</p>\r\n', 1, 1),
(134, 1, '<p>El usuario valida la seccion Descripcion en la pagina de producto</p>\r\n', '<p>La seccion descripcion esta seleccionada predeterminadamente y muestra una descripcion breve del producto</p>\r\n', 1, 1),
(135, 2, '<p>El usuario hace click en la seccion Detalles del producto</p>\r\n', '<p>El sistema cambia de la pesta&ntilde;a Descripcion a la Detalles del Producto.</p>\r\n\r\n<p>En esta se muestra el Stock actual del producto</p>\r\n', 1, 1),
(136, 1, '<p>El usuario ingresa un correo existente pero sin registrar en el sitio</p>\r\n', '<p>El mensaje&nbsp;Error de autenticaci&oacute;n. aparece en pantalla</p>\r\n', 1, 1),
(137, 2, '<p>El usuario ingresa un valor que no cumpla con el formato de correo: usuario@server.dominio</p>\r\n', '<p>El mensaje&nbsp;Formato no v&aacute;lido. aparece en pantalla</p>\r\n', 1, 1),
(138, 1, '<p>El usuario hace click en el&nbsp; link&nbsp;&iquest;No tiene una cuenta? Cree una aqu&iacute;</p>\r\n', '<p>El sistema redirige a la pagina de creacion de cuentas</p>\r\n\r\n<p>La pagina esta compuesta por lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Crear Cuenta</li>\r\n	<li>Formulario de creacion de cuenta\r\n	<ul>\r\n		<li>Link de inicio de Sesion</li>\r\n		<li>Selector de genero</li>\r\n		<li>Ingreso de nombre</li>\r\n		<li>Ingreso de apellido</li>\r\n		<li>Ingreso Correo</li>\r\n		<li>Ingreso Contrase&ntilde;a</li>\r\n		<li>Boton mostrar contrase&ntilde;a</li>\r\n		<li>Ingreso fecha de nacimiento con formato DD/MM/YYYY (Opcional)</li>\r\n		<li>Opcion notificaciones de socios</li>\r\n		<li>Opcion notificaciones de tienda</li>\r\n		<li>Boton Guardar</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(139, 2, '<p>El usuario hace click en guardar sin llenar los campos requeridos</p>\r\n', '<p>Advertencia Completa este Campo Aparece debajo de Ingreso Nombre</p>\r\n', 1, 1),
(140, 3, '<p>El usuario completa el campo nombre y hace click en guardar</p>\r\n', '<p>Advertencia Completa este Campo Aparece debajo de Ingreso Apellido</p>\r\n', 1, 1),
(141, 4, '<p>El usuario completa el campo apellido y hace click en guardar</p>\r\n', '<p>Advertencia Completa este Campo Aparece debajo de Ingreso Correo</p>\r\n', 1, 1),
(142, 5, '<p>El usuario completa el campo correo y hace click en guardar</p>\r\n', '<p>Advertencia Completa este Campo Aparece debajo de Ingreso Contrase&ntilde;a</p>\r\n', 1, 1),
(143, 6, '<p>El usuario completa el campo contrase&ntilde;a&nbsp;y hace click en guardar</p>\r\n', '<ul>\r\n	<li>Si la contrase&ntilde;a no contiene mas de 4 caracteres la advertencia Haz coincidir el formato solicitado aparece, y no se puede continuar el llenado del formulario</li>\r\n	<li>Al cumplir con la regla de 5 caracteres minimo se validaran todos los campos\r\n	<ul>\r\n		<li>En el caso de que el correo no cumpla con el formato de correo Usuario@server.dominio el mensaje de error&nbsp;Formato no v&aacute;lido. aparecera debajo del Ingreso correo</li>\r\n		<li>En el caso que no haya error en el correo, el sistema redigira el sitio a la pagina principal con el usuario conectado predeterminadamente</li>\r\n		<li>En el caso de que el correo ya este registrado el mensaje de alerta&nbsp;La direcci&oacute;n de correo electr&oacute;nico &quot;usuario@server.dominio&quot; ya est&aacute; en uso, por favor, elija otra para iniciar sesi&oacute;n o registrarse, aparecera en pantalla</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(144, 1, '<p>El usuario ingresa un correo y contrase&ntilde;a validos y existentes dentro del sitio y hace click en el boton Iniciar Sesion</p>\r\n', '<p>El sistema redirige el sitio a la pagina Mi Cuenta la cual se compone de la siguiente manera:</p>\r\n\r\n<ul>\r\n	<li>Titulo Su cuenta</li>\r\n	<li>Boton Informacion</li>\r\n	<li>Boton Direcciones/A&ntilde;adir Primera Direccion(Cuenta Nueva)</li>\r\n	<li>Boton Historial y Detalles de mis Pedidos</li>\r\n	<li>Boton Facturas por Abono</li>\r\n	<li>Link Cerrar Sesion</li>\r\n</ul>\r\n', 1, 1),
(145, 1, '<p>El usuario hace click en el link &iquest;Olvido su Contrase&ntilde;a?</p>\r\n', '<p>El sistema redirige a la pagina de recuperacion de contrase&ntilde;a, esta se compone por:</p>\r\n\r\n<ul>\r\n	<li>Titulo &iquest;Olvido su Contrase&ntilde;a?</li>\r\n	<li>Formulario de recuperacion de contrase&ntilde;a</li>\r\n	<li>Ingreso correo de cuenta</li>\r\n	<li>Boton de recuperacion de contrase&ntilde;a</li>\r\n</ul>\r\n', 1, 1),
(146, 2, '<p>El usuario ingresa un correo valido y hace click en el boton de recuperacion de contrase&ntilde;a</p>\r\n', '<p>El sistema carga un mensaje de error&nbsp;Se ha producido un error al enviar el correo electr&oacute;nico. ya que el sistema de recuperacion de contrase&ntilde;a esta deshabilitado</p>\r\n', 1, 1),
(147, 1, '<p>El usuario valida los componentes de la pagina Envios</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Envio</li>\r\n	<li>Titulo Envio</li>\r\n	<li>Seccion Envios y Devoluciones</li>\r\n	<li>subtitulo&nbsp;Env&iacute;o del paquete</li>\r\n	<li>Informacion de medio de envio y formas de pago</li>\r\n</ul>\r\n', 1, 1),
(148, 1, '<p>El usuario valida la pagina Aviso Legal</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Aviso Legal</li>\r\n	<li>Titulo Aviso Legal</li>\r\n	<li>Seccion Legal</li>\r\n	<li>Subtitulo Creditos</li>\r\n	<li>Informacion del software con el cual se creo la tienda</li>\r\n</ul>\r\n', 1, 1),
(149, 1, '<p>El usuario valida la pagina Terminos y Condiciones</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Terminos y Condiciones</li>\r\n	<li>Titulos Terminos y Condiciones</li>\r\n	<li>La lista de Terminos y Condiciones del sitio</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, 1),
(150, 1, '<p>El usuario valida la pagina Sobre Nosotros</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Sobre Nosotros</li>\r\n	<li>Titulo Sobre Nosotros</li>\r\n	<li>Informacion de la empresa</li>\r\n</ul>\r\n', 1, 1),
(151, 1, '<p>El usuario valida los componentes de la pagina Pago Seguro</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Pago Seguro</li>\r\n	<li>Titulo Pago Seguro</li>\r\n	<li>Informacion del sistema de seguridad del sitio y de los medios de pago permitidos</li>\r\n</ul>\r\n', 1, 1),
(152, 1, '<p>El usuario valida los componentes de la pagina contacte con nosotros</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Seccion informacion de la tienda\r\n	<ul>\r\n		<li>Ubicacion</li>\r\n		<li>Correo de contacto</li>\r\n	</ul>\r\n	</li>\r\n	<li>Seccion contacte con nosotros\r\n	<ul>\r\n		<li>Selector de asunto</li>\r\n		<li>Correo del usuario</li>\r\n		<li>Ingreso de Archivo adjunto</li>\r\n		<li>Mensaje del usuario</li>\r\n		<li>Boton enviar</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, 1),
(153, 2, '<p>El usuario ingresa un correo y hace click en enviar</p>\r\n', '<p>El sistema muestra el mensaje de error&nbsp;El mensaje no puede estar en blanco.</p>\r\n', 1, 1),
(154, 3, '<p>El&nbsp;usuario ingresa un mensaje</p>\r\n', '<ul>\r\n	<li>Si el correo no cumple con el formato de correo usuario@server.dominio el mensaje de error&nbsp;Direcci&oacute;n de correo electr&oacute;nico no v&aacute;lida. aparece en pantalla</li>\r\n	<li>Si el correo cumple con el formato de correo el mensaje&nbsp;Su mensaje ha sido enviado a nuestro equipo. aparecera en pantalla</li>\r\n</ul>\r\n', 1, 1),
(155, 1, '<p>El usuario valida los componentes de la pagina Mapa del Sitio</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Mapa del sitio</li>\r\n	<li>Links a todas las paginas principales del sitio, menus y subcategorias:\r\n	<ul>\r\n		<li>Nuestras Ofertas\r\n		<ul>\r\n			<li>Novedades</li>\r\n			<li>Marcas\r\n			<ul>\r\n				<li>Artesanias MarVal</li>\r\n			</ul>\r\n			</li>\r\n			<li>Proveedores</li>\r\n		</ul>\r\n		</li>\r\n		<li>Categorias\r\n		<ul>\r\n			<li>Inicio</li>\r\n			<li>Figuras de Madera\r\n			<ul>\r\n				<li>Figuras colgantes</li>\r\n				<li>Figuras de pared</li>\r\n				<li>Figuras de mesa</li>\r\n			</ul>\r\n			</li>\r\n			<li>Cuadros y Pinturas\r\n			<ul>\r\n				<li>Mosaicos</li>\r\n				<li>Perchas</li>\r\n				<li>Pinturas</li>\r\n			</ul>\r\n			</li>\r\n			<li>Otros</li>\r\n		</ul>\r\n		</li>\r\n		<li>Su cuenta\r\n		<ul>\r\n			<li>Iniciar sesi&oacute;n</li>\r\n			<li>Crear nueva cuenta</li>\r\n		</ul>\r\n		</li>\r\n		<li>Paginas\r\n		<ul>\r\n			<li>Env&iacute;o</li>\r\n			<li>Aviso legal</li>\r\n			<li>T&eacute;rminos y condiciones</li>\r\n			<li>Sobre nosotros</li>\r\n			<li>Pago seguro</li>\r\n			<li>Nuestras tiendas</li>\r\n			<li>Contacte con nosotros</li>\r\n			<li>Mapa del sitio</li>\r\n		</ul>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(156, 1, '<p>El usuario valida los componentes de la pagina Tiendas del sitio</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Nuestras Tiendas</li>\r\n	<li>Lista de Tiendas\r\n	<ul>\r\n		<li>Imagen de Tienda</li>\r\n		<li>Informacion de tienda\r\n		<ul>\r\n			<li>Nombre</li>\r\n			<li>Ubicacion</li>\r\n			<li>Horario de atencion</li>\r\n		</ul>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n', 1, 1),
(157, 1, '<p>El usuario valida la pagina de Informacion personal</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/Su cuenta</li>\r\n	<li>Titulo Sus Datos Personales</li>\r\n	<li>Formulario de Datos Personales con informacion previamente ingresada\r\n	<ul>\r\n		<li>Selector Genero del usuario</li>\r\n		<li>Ingreso Nombre</li>\r\n		<li>Ingreso Apellido</li>\r\n		<li>Ingreso Correo</li>\r\n		<li>Ingreso Contrase&ntilde;a</li>\r\n		<li>Ingreso Nueva Contrase&ntilde;a</li>\r\n		<li>Ingreso Fecha de Nacimiento</li>\r\n		<li>Opcion Oferta de Socio</li>\r\n		<li>Opcion Notificaciones de Tienda</li>\r\n		<li>Boton Guardar</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n', 1, 1),
(158, 2, '<p>El usuario cambia alguno de los valores:</p>\r\n\r\n<ul>\r\n	<li>Genero</li>\r\n	<li>Nombre</li>\r\n	<li>Apellido</li>\r\n	<li>Correo</li>\r\n</ul>\r\n', '<p>El sistema cargara una notificacion de Completa este Campo debajo del Ingreso Contrase&ntilde;a</p>\r\n', 1, 1),
(159, 3, '<p>El usuario cambia alguno de los valores, ingresando una contrase&ntilde;a</p>\r\n', '<ul>\r\n	<li>Si la contrase&ntilde;a no es correcta el mensaje&nbsp;No se pudo actualizar su informaci&oacute;n, por favor, compruebe sus datos. aparecera en pantalla</li>\r\n	<li>Si la contrase&ntilde;a es correcta el mensaje&nbsp;Informaci&oacute;n actualizada correctamente. aparecera en pantalla</li>\r\n</ul>\r\n', 1, 1),
(160, 1, '<p>El usuario valida los componentes de la pagina de Mis Pedidos</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/ Su Cuenta</li>\r\n	<li>Titulo Historial de Pedidos</li>\r\n	<li>Lista de los pedidos realizados(No deben existir por que la funcionalidad del carrito esta deshabilitada)</li>\r\n</ul>\r\n', 1, 1),
(161, 1, '<p>El usuario valida los componentes de la pagina Facturas por Abono</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Ruta Inicio/ Su Cuenta</li>\r\n	<li>Titulo Facturas por Abono</li>\r\n	<li>Lista de Facturas recibidas, en el caso de no tener ninguna el mensaje&nbsp;No ha recibido ninguna factura por abono. aparecera en pantalla</li>\r\n</ul>\r\n', 1, 1),
(162, 1, '<p>El usuario valida la pagina de&nbsp;Direcciones</p>\r\n', '<ol>\r\n	<li>Si no existen direcciones, el boton Direcciones en la pagina mi cuenta aparecera como A&ntilde;adir Primera Direccion, y el link Direcciones del footer Su Cuenta redirigira a la pagina de registro Nueva Direccion</li>\r\n	<li>Si existen direcciones, el boton en la pagina mi cuenta aparecera como Direcciones y al utilizarlo, la pagina se redirigira a la pagina de Direcciones.</li>\r\n	<li>La pagina de Direcciones contiene lo siguiente:\r\n	<ul>\r\n		<li>Ruta Inicio/ Su Cuenta</li>\r\n		<li>Titulo Sus Direcciones</li>\r\n		<li>Lista de Direcciones registradas\r\n		<ul>\r\n			<li>Alias de la direccion (Opcional)</li>\r\n			<li>Nombre del Usuario</li>\r\n			<li>Apellido del Usuario</li>\r\n			<li>Empresa&nbsp;(Opcional)</li>\r\n			<li>Numero de IVA&nbsp;(Opcional)</li>\r\n			<li>Direccion</li>\r\n			<li>Direccion Complementaria(Opcional)</li>\r\n			<li>Codigo Postal / ZIP</li>\r\n			<li>Ciudad</li>\r\n			<li>Pais</li>\r\n			<li>Telefono(Opcional)</li>\r\n			<li>Opcion Actualizar Datos</li>\r\n			<li>Opcion Eliminar Direccion</li>\r\n		</ul>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ol>\r\n', 1, 1),
(163, 1, '<p>El usuario valida la pagina de Ofertas del sitio</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Ofertas</li>\r\n	<li>Galeria de productos en oferta</li>\r\n	<li>Filtro por menu</li>\r\n</ul>\r\n', 1, 1),
(164, 1, '<p>El usuario valida la pagina de Novedades del sitio</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Novedades</li>\r\n	<li>Galeria de productos nuevos</li>\r\n	<li>Filtro por menu</li>\r\n</ul>\r\n', 1, 1),
(165, 1, '<p>El usuario valida la pagina de Lo mas Vendido del sitio</p>\r\n', '<p>La pagina se compone de lo siguiente:</p>\r\n\r\n<ul>\r\n	<li>Titulo Los Mas Vendidos</li>\r\n	<li>Galeria de productos mas vendidos</li>\r\n	<li>Filtro por menu</li>\r\n</ul>\r\n', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tcversions`
--

CREATE TABLE `tcversions` (
  `id` int(10) UNSIGNED NOT NULL,
  `tc_external_id` int(10) UNSIGNED DEFAULT NULL,
  `version` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `layout` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `status` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `summary` text,
  `preconditions` text,
  `importance` smallint(5) UNSIGNED NOT NULL DEFAULT '2',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater_id` int(10) UNSIGNED DEFAULT NULL,
  `modification_ts` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `execution_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 -> manual, 2 -> automated',
  `estimated_exec_duration` decimal(6,2) DEFAULT NULL COMMENT 'NULL will be considered as NO DATA Provided by user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tcversions`
--

INSERT INTO `tcversions` (`id`, `tc_external_id`, `version`, `layout`, `status`, `summary`, `preconditions`, `importance`, `author_id`, `creation_ts`, `updater_id`, `modification_ts`, `active`, `is_open`, `execution_type`, `estimated_exec_duration`) VALUES
(8, 1, 1, 1, 1, '<p>Se valida el ingreso a la pagina principal del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n', 3, 1, '2018-11-23 02:34:32', 1, '2018-11-23 01:22:01', 1, 1, 1, NULL),
(10, 2, 1, 1, 1, '<p>Se verifica que el titulo de la pagina y el favicon corresponden</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 3, 1, '2018-11-23 02:35:22', 1, '2018-11-23 02:19:32', 1, 1, 1, NULL),
(12, 3, 1, 1, 1, '<p>Se verifica que el logo del sitio es correcto</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 3, 1, '2018-11-23 02:35:49', 1, '2018-11-23 02:21:48', 1, 1, 1, NULL),
(14, 4, 1, 1, 1, '<p>Se valida la funcionalidad de los menus del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 3, 1, '2018-11-23 02:36:24', 1, '2018-11-23 03:08:43', 1, 1, 1, NULL),
(16, 5, 1, 1, 1, '<p>Se verifica la existencia y funcionalidad de la imagen de portada</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 2, 1, '2018-11-23 02:36:51', 1, '2018-11-23 03:38:52', 1, 1, 1, NULL),
(18, 6, 1, 1, 1, '<p>Se valida la galeria de productos en la pagina principal del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 3, 1, '2018-11-23 02:37:20', 1, '2018-11-23 04:00:36', 1, 1, 1, NULL),
(20, 7, 1, 1, 1, '<p>Se valida la funcionalidad del modulo de subscripcion</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 2, 1, '2018-11-23 02:48:52', 1, '2018-11-23 04:36:43', 1, 1, 1, NULL),
(22, 8, 1, 1, 1, '<p>Se validan los componentes del footer del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar en la pagina principal del sitio</p>\r\n\r\n<p>-AMV-1:Ingreso_pagina debe haber pasado</p>\r\n', 2, 1, '2018-11-23 02:49:27', 1, '2018-11-23 04:58:19', 1, 1, 1, NULL),
(24, 9, 1, 1, 1, '<p>Se valida los filtros relacionados a los menus y submenus del sitio en la galeria de productos</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n\r\n<p>&nbsp;</p>\r\n', 3, 1, '2018-11-23 02:50:56', 1, '2018-11-23 05:15:34', 1, 1, 1, NULL),
(26, 10, 1, 1, 1, '<p>Se valida la funcionalidad del filtro por categoria</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n\r\n<p>&nbsp;</p>\r\n', 2, 1, '2018-11-23 02:51:49', 1, '2018-11-23 05:26:29', 1, 1, 1, NULL),
(28, 11, 1, 1, 1, '<p>Se valida la funcionalidad del filtro por&nbsp;precio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n', 2, 1, '2018-11-23 02:52:16', 1, '2018-11-23 05:33:15', 1, 1, 1, NULL),
(30, 12, 1, 1, 1, '<p>Se validan los componentes titulo e imagen de portada de la lista de productos</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n', 2, 1, '2018-11-23 02:56:06', 1, '2018-11-23 05:42:53', 1, 1, 1, NULL),
(32, 13, 1, 1, 1, '<p>Se valida la funcionalidad del selector Orden por, y su componentes</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n', 2, 1, '2018-11-23 02:56:56', 1, '2018-11-23 05:51:41', 1, 1, 1, NULL),
(34, 14, 1, 1, 1, '<p>Se valida la cantidad de productos presentes en la pagina a comparacion del total de la pagina por el filtro seleccionado</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n', 2, 1, '2018-11-23 02:58:18', 1, '2018-11-23 05:59:00', 1, 1, 1, NULL),
(36, 15, 1, 1, 1, '<p>Se valida la funcionalidad del cambio de pagina en la galeria de productos</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la lista de productos seleccionando alguno de los menu, subcategorias o desde el link Todos los productos en el sitio principal</p>\r\n', 2, 1, '2018-11-23 03:00:08', 1, '2018-11-23 06:08:24', 1, 1, 1, NULL),
(38, 16, 1, 1, 1, '<p>Se valida la ruta de ingreso a un producto</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de un producto desde la pagina principal, la galeria con todos los productos, o por medio de uno de los menu o subcategorias</p>\r\n', 2, 1, '2018-11-23 03:01:00', 1, '2018-11-23 19:57:59', 1, 1, 1, NULL),
(40, 17, 1, 1, 1, '<p>Se valida&nbsp;la galeria de imagenes de los productos</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de un producto desde la pagina principal, la galeria con todos los productos, o por medio de uno de los menu o subcategorias</p>\r\n', 2, 1, '2018-11-23 03:03:21', 1, '2018-11-23 20:07:04', 1, 1, 1, NULL),
(42, 18, 1, 1, 1, '<p>Se valida los componentes de la descripcion del producto</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de un producto desde la pagina principal, la galeria con todos los productos, o por medio de uno de los menu o subcategorias</p>\r\n', 2, 1, '2018-11-23 03:03:55', 1, '2018-11-23 20:48:03', 1, 1, 1, NULL),
(44, 19, 1, 1, 1, '<p>Se valida el estado de deshabilitado del boton de a&ntilde;adir a carro de compra</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de un producto desde la pagina principal, la galeria con todos los productos, o por medio de uno de los menu o subcategorias</p>\r\n', 3, 1, '2018-11-23 03:04:17', 1, '2018-11-23 20:49:43', 1, 1, 1, NULL),
(46, 20, 1, 1, 1, '<p>Se valida la seccion Descripcion y Detalles del Producto en el sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de un producto desde la pagina principal, la galeria con todos los productos, o por medio de uno de los menu o subcategorias</p>\r\n', 3, 1, '2018-11-23 03:04:43', 1, '2018-11-23 20:53:57', 1, 1, 1, NULL),
(48, 21, 1, 1, 1, '<p>Se valida la funcionalidad del login sin utilizar cuenta</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina del login por medio del link Inicia Sesion en la cabecera del sitio</p>\r\n', 2, 1, '2018-11-23 03:05:47', 1, '2018-11-23 21:12:22', 1, 1, 1, NULL),
(50, 22, 1, 1, 1, '<p>Se valida la creacion de cuentas</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina del login por medio del link Inicia Sesion en la cabecera del sitio</p>\r\n', 3, 1, '2018-11-23 03:06:01', 1, '2018-11-23 22:16:24', 1, 1, 1, NULL),
(52, 23, 1, 1, 1, '<p>Se valida la funcionalidad del ingreso de cuenta</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina del login por medio del link Inicia Sesion en la cabecera del sitio</p>\r\n\r\n<p>-Debe utilizar una cuenta existente</p>\r\n', 3, 1, '2018-11-23 03:06:26', 1, '2018-11-23 22:23:37', 1, 1, 1, NULL),
(54, 24, 1, 1, 1, '<p>Valida la opcion Cambio de contrase&ntilde;a</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina del login por medio del link Inicia Sesion en la cabecera del sitio</p>\r\n\r\n<p>-Debe tener una cuenta valida en el sitio</p>\r\n', 3, 1, '2018-11-23 03:06:50', 1, '2018-11-23 22:46:15', 1, 1, 1, NULL),
(62, 25, 1, 1, 1, '<p>Se valida la seccion de Envio del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de envio utilizando el link Envio&nbsp;en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:16:03', 1, '2018-11-23 23:04:26', 1, 1, 1, NULL),
(64, 26, 1, 1, 1, '<p>Validacion de la pagina Aviso Legal</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de aviso legal&nbsp;utilizando el link Aviso Legal&nbsp;en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:16:22', 1, '2018-11-23 23:07:59', 1, 1, 1, NULL),
(66, 27, 1, 1, 1, '<p>Valida la pagina Terminos y condiciones</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de terminos y condiciones utilizando el link Terminos y Condiciones en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:16:56', 1, '2018-11-23 23:15:26', 1, 1, 1, NULL),
(68, 28, 1, 1, 1, '<p>Se valida la pagina Sobre Nosotros</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina Sobre Nosotros utilizando el link Sobre Nosotros en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:17:16', 1, '2018-11-23 23:18:52', 1, 1, 1, NULL),
(70, 29, 1, 1, 1, '<p>Se valida la pagina Pago Seguro del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Pago Seguro utilizando el link Pago Seguro en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:17:34', 1, '2018-11-23 23:26:24', 1, 1, 1, NULL),
(72, 30, 1, 1, 1, '<p>Se valida la pagina de Contacte con Nosotros del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Contacte con nosotros utilizando el link Contacte con Nosotros en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:17:53', 1, '2018-11-23 23:37:22', 1, 1, 1, NULL),
(74, 31, 1, 1, 1, '<p>Se valida la pagina Mapa del Sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Mapa del Sitio utilizando el link Mapa del Sitio en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:18:21', 1, '2018-11-23 23:50:53', 1, 1, 1, NULL),
(76, 32, 1, 1, 1, '<p>El usuario valida la pagina de Tiendas del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Tiendas utilizando el link Tiendas en la seccion Nuestra Empresa del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:18:38', 1, '2018-11-23 23:53:43', 1, 1, 1, NULL),
(78, 33, 1, 1, 1, '<p>Se valida la pagina de Informacion personal de la cuenta de usuario</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar conectado como usuario al sitio de la tienda</p>\r\n\r\n<p>-Debe ingresar a la pagina de Informacion Personal utilizando el link Informacion Personal en la seccion Su Cuenta del footer del sitio o desde el boton Informacion en&nbsp;la pagina Mi Cuenta</p>\r\n', 2, 1, '2018-11-23 05:19:00', 1, '2018-11-24 00:40:50', 1, 1, 1, NULL),
(80, 34, 1, 1, 1, '<p>Se valida la pagina Mis pedidos del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar conectado como usuario al sitio de la tienda</p>\r\n\r\n<p>-Debe ingresar a la pagina de Pedidos utilizando el link Pedidos en la seccion Su Cuenta del footer del sitio o desde el boton Historial y Detalles de mis Pedidos en&nbsp;la pagina Mi Cuenta</p>\r\n', 3, 1, '2018-11-23 05:19:17', 1, '2018-11-24 01:01:27', 1, 1, 1, NULL),
(82, 35, 1, 1, 1, '<p>Se valida la pagina de Facturas por Abono del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar conectado como usuario al sitio de la tienda</p>\r\n\r\n<p>-Debe ingresar a la pagina de Facturas por Abono utilizando el link Facturas por Abono en la seccion Su Cuenta del footer del sitio o desde el boton Facturas por Abono&nbsp;en&nbsp;la pagina Mi Cuenta</p>\r\n', 2, 1, '2018-11-23 05:19:29', 1, '2018-11-24 01:13:05', 1, 1, 1, NULL),
(84, 36, 1, 1, 1, '<p>Se valida la pagina de direcciones del usuario en el sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe estar conectado como usuario al sitio de la tienda</p>\r\n\r\n<p>-Debe ingresar a la pagina de Direcciones utilizando el link Direcciones en la seccion Su Cuenta del footer del sitio,&nbsp;desde el boton Direcciones&nbsp;en&nbsp;la pagina Mi Cuenta o desde el boton A&ntilde;adir Primera Direccion en la pagina Mi Cuenta</p>\r\n', 2, 1, '2018-11-23 05:19:48', 1, '2018-11-24 01:36:46', 1, 1, 1, NULL),
(86, 37, 1, 1, 1, '<p>Se valida la pagina de Ofertas&nbsp;de productos del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Ofertas utilizando el link Ofertas en la seccion Productos del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:20:35', 1, '2018-11-24 02:28:02', 1, 1, 1, NULL),
(88, 38, 1, 1, 1, '<p>Se valida la pagina de novedades del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Novedades utilizando el link Novedades en la seccion Productos del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:20:51', 1, '2018-11-24 02:44:28', 1, 1, 1, NULL),
(90, 39, 1, 1, 1, '<p>Se valida la pagina de Lo mas Vendido del sitio</p>\r\n', '<p>-Acceso a localhost/ArtMarVal</p>\r\n\r\n<p>-Buscador: Microsoft Edge</p>\r\n\r\n<p>-Debe ingresar a la pagina de Lo mas Vendido utilizando el link Lo mas Vendido en la seccion Productos del footer del sitio</p>\r\n', 2, 1, '2018-11-23 05:21:13', 1, '2018-11-24 02:46:22', 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `tcversions_without_keywords`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `tcversions_without_keywords` (
`testcase_id` int(10) unsigned
,`id` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testcase_keywords`
--

CREATE TABLE `testcase_keywords` (
  `id` int(10) UNSIGNED NOT NULL,
  `testcase_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tcversion_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `keyword_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `testcase_keywords`
--

INSERT INTO `testcase_keywords` (`id`, `testcase_id`, `tcversion_id`, `keyword_id`) VALUES
(1, 7, 8, 1),
(6, 9, 10, 2),
(10, 11, 12, 2),
(13, 13, 14, 1),
(19, 15, 16, 3),
(22, 17, 18, 2),
(28, 19, 20, 4),
(30, 21, 22, 2),
(34, 23, 24, 2),
(38, 25, 26, 2),
(42, 27, 28, 2),
(46, 29, 30, 2),
(50, 31, 32, 2),
(54, 33, 34, 2),
(58, 35, 36, 2),
(62, 37, 38, 2),
(65, 39, 40, 1),
(69, 41, 42, 1),
(73, 43, 44, 1),
(77, 45, 46, 1),
(81, 47, 48, 1),
(85, 49, 50, 1),
(89, 51, 52, 1),
(93, 53, 54, 1),
(97, 61, 62, 2),
(98, 63, 64, 2),
(99, 65, 66, 2),
(100, 67, 68, 2),
(101, 69, 70, 2),
(102, 71, 72, 2),
(103, 73, 74, 3),
(104, 75, 76, 1),
(105, 77, 78, 1),
(106, 79, 80, 2),
(107, 81, 82, 2),
(108, 83, 84, 2),
(109, 85, 86, 2),
(110, 87, 88, 2),
(111, 89, 90, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testcase_relations`
--

CREATE TABLE `testcase_relations` (
  `id` int(10) UNSIGNED NOT NULL,
  `source_id` int(10) UNSIGNED NOT NULL,
  `destination_id` int(10) UNSIGNED NOT NULL,
  `link_status` tinyint(1) NOT NULL DEFAULT '1',
  `relation_type` smallint(5) UNSIGNED NOT NULL DEFAULT '1',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testcase_script_links`
--

CREATE TABLE `testcase_script_links` (
  `tcversion_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `project_key` varchar(64) NOT NULL,
  `repository_name` varchar(64) NOT NULL,
  `code_path` varchar(255) NOT NULL,
  `branch_name` varchar(64) DEFAULT NULL,
  `commit_id` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testplans`
--

CREATE TABLE `testplans` (
  `id` int(10) UNSIGNED NOT NULL,
  `testproject_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `notes` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_open` tinyint(1) NOT NULL DEFAULT '1',
  `is_public` tinyint(1) NOT NULL DEFAULT '1',
  `api_key` varchar(64) NOT NULL DEFAULT '829a2ded3ed0829a2dedd8ab81dfa2c77e8235bc3ed0d8ab81dfa2c77e8235bc'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `testplans`
--

INSERT INTO `testplans` (`id`, `testproject_id`, `notes`, `active`, `is_open`, `is_public`, `api_key`) VALUES
(2, 1, '<p>Plan de Pruebas ArtMarVal</p>', 1, 1, 1, '1e7c4e780c0560e85ee4632c4f255e6110ae4ea01aad323e2c8ff07752ebae25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testplan_platforms`
--

CREATE TABLE `testplan_platforms` (
  `id` int(10) UNSIGNED NOT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL,
  `platform_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Connects a testplan with platforms';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testplan_tcversions`
--

CREATE TABLE `testplan_tcversions` (
  `id` int(10) UNSIGNED NOT NULL,
  `testplan_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tcversion_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `node_order` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `urgency` smallint(5) NOT NULL DEFAULT '2',
  `platform_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testprojects`
--

CREATE TABLE `testprojects` (
  `id` int(10) UNSIGNED NOT NULL,
  `notes` text,
  `color` varchar(12) NOT NULL DEFAULT '#9BD',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `option_reqs` tinyint(1) NOT NULL DEFAULT '0',
  `option_priority` tinyint(1) NOT NULL DEFAULT '0',
  `option_automation` tinyint(1) NOT NULL DEFAULT '0',
  `options` text,
  `prefix` varchar(16) NOT NULL,
  `tc_counter` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `is_public` tinyint(1) NOT NULL DEFAULT '1',
  `issue_tracker_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `code_tracker_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `reqmgr_integration_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `api_key` varchar(64) NOT NULL DEFAULT '0d8ab81dfa2c77e8235bc829a2ded3edfa2c78235bc829a27eded3ed0d8ab81d'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `testprojects`
--

INSERT INTO `testprojects` (`id`, `notes`, `color`, `active`, `option_reqs`, `option_priority`, `option_automation`, `options`, `prefix`, `tc_counter`, `is_public`, `issue_tracker_enabled`, `code_tracker_enabled`, `reqmgr_integration_enabled`, `api_key`) VALUES
(1, '<p>Tienda de Artesania en prestashop</p>', '', 1, 0, 0, 0, 'O:8:\"stdClass\":4:{s:19:\"requirementsEnabled\";i:0;s:19:\"testPriorityEnabled\";i:1;s:17:\"automationEnabled\";i:1;s:16:\"inventoryEnabled\";i:1;}', 'AMV', 39, 1, 0, 0, 0, '31a3db5a2b32edac00b09de8c6d4b971ba10891e74287e9b40b0c5106e145241');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testproject_codetracker`
--

CREATE TABLE `testproject_codetracker` (
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `codetracker_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testproject_issuetracker`
--

CREATE TABLE `testproject_issuetracker` (
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `issuetracker_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testproject_reqmgrsystem`
--

CREATE TABLE `testproject_reqmgrsystem` (
  `testproject_id` int(10) UNSIGNED NOT NULL,
  `reqmgrsystem_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testsuites`
--

CREATE TABLE `testsuites` (
  `id` int(10) UNSIGNED NOT NULL,
  `details` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `testsuites`
--

INSERT INTO `testsuites` (`id`, `details`) VALUES
(3, '<p>Funcionalidades pagina principal</p>\r\n'),
(4, '<p>Funcionalidad de la lista de productos</p>\r\n'),
(5, '<p>Funcionalidad de pagina de productos</p>\r\n'),
(6, '<p>Funcionalidad del registro de usuarios</p>\r\n'),
(57, ''),
(59, ''),
(60, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `text_templates`
--

CREATE TABLE `text_templates` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `template_data` text,
  `author_id` int(10) UNSIGNED DEFAULT NULL,
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_public` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Global Project Templates';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transactions`
--

CREATE TABLE `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `entry_point` varchar(45) NOT NULL DEFAULT '',
  `start_time` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `end_time` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `session_id` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `transactions`
--

INSERT INTO `transactions` (`id`, `entry_point`, `start_time`, `end_time`, `user_id`, `session_id`) VALUES
(1, '/testlink/login.php', 1542920028, 1542920028, 0, NULL),
(2, '/testlink/login.php', 1542920034, 1542920034, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(3, '/testlink/lib/project/projectEdit.php', 1542920144, 1542920145, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(4, '/testlink/lib/usermanagement/userInfo.php', 1542920152, 1542920152, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(5, '/testlink/lib/usermanagement/userInfo.php', 1542920190, 1542920191, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(6, '/testlink/lib/usermanagement/userInfo.php', 1542920203, 1542920204, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(7, '/testlink/lib/usermanagement/userInfo.php', 1542920209, 1542920209, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(8, '/testlink/logout.php', 1542920222, 1542920222, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(9, '/testlink/login.php', 1542920223, 1542920223, 0, NULL),
(10, '/testlink/login.php', 1542920228, 1542920228, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(11, '/testlink/lib/plan/planEdit.php', 1542920486, 1542920487, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(12, '/testlink/lib/plan/buildEdit.php', 1542920701, 1542920701, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(13, '/testlink/lib/keywords/keywordsEdit.php', 1542921029, 1542921029, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(14, '/testlink/lib/keywords/keywordsEdit.php', 1542921045, 1542921045, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(15, '/testlink/lib/keywords/keywordsEdit.php', 1542921060, 1542921060, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(16, '/testlink/lib/keywords/keywordsEdit.php', 1542921075, 1542921075, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(17, '/testlink/lib/testcases/tcEdit.php', 1542922472, 1542922473, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(18, '/testlink/lib/testcases/tcEdit.php', 1542922523, 1542922523, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(19, '/testlink/lib/testcases/tcEdit.php', 1542922549, 1542922549, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(20, '/testlink/lib/testcases/tcEdit.php', 1542922584, 1542922584, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(21, '/testlink/lib/testcases/tcEdit.php', 1542922611, 1542922611, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(22, '/testlink/lib/testcases/tcEdit.php', 1542922640, 1542922641, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(23, '/testlink/lib/testcases/tcEdit.php', 1542923332, 1542923332, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(24, '/testlink/lib/testcases/tcEdit.php', 1542923367, 1542923368, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(25, '/testlink/lib/testcases/tcEdit.php', 1542923456, 1542923457, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(26, '/testlink/lib/testcases/tcEdit.php', 1542923509, 1542923509, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(27, '/testlink/lib/testcases/tcEdit.php', 1542923536, 1542923537, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(28, '/testlink/lib/testcases/tcEdit.php', 1542923766, 1542923767, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(29, '/testlink/lib/testcases/tcEdit.php', 1542923816, 1542923817, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(30, '/testlink/lib/testcases/tcEdit.php', 1542923898, 1542923899, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(31, '/testlink/lib/testcases/tcEdit.php', 1542924009, 1542924009, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(32, '/testlink/lib/testcases/tcEdit.php', 1542924060, 1542924060, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(33, '/testlink/lib/testcases/tcEdit.php', 1542924201, 1542924201, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(34, '/testlink/lib/testcases/tcEdit.php', 1542924236, 1542924236, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(35, '/testlink/lib/testcases/tcEdit.php', 1542924257, 1542924258, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(36, '/testlink/lib/testcases/tcEdit.php', 1542924283, 1542924284, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(37, '/testlink/lib/testcases/tcEdit.php', 1542924347, 1542924347, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(38, '/testlink/lib/testcases/tcEdit.php', 1542924361, 1542924361, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(39, '/testlink/lib/testcases/tcEdit.php', 1542924386, 1542924386, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(40, '/testlink/lib/testcases/tcEdit.php', 1542924410, 1542924411, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(41, '/testlink/lib/testcases/tcEdit.php', 1542926506, 1542926506, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(42, '/testlink/lib/testcases/tcEdit.php', 1542926510, 1542926510, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(43, '/testlink/lib/testcases/tcEdit.php', 1542928084, 1542928084, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(44, '/testlink/lib/testcases/tcEdit.php', 1542932499, 1542932499, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(45, '/testlink/lib/testcases/tcEdit.php', 1542935622, 1542935622, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(46, '/testlink/lib/testcases/tcEdit.php', 1542935629, 1542935629, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(47, '/testlink/lib/testcases/tcEdit.php', 1542935695, 1542935695, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(48, '/testlink/lib/testcases/tcEdit.php', 1542935914, 1542935914, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(49, '/testlink/lib/testcases/tcEdit.php', 1542935923, 1542935923, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(50, '/testlink/lib/testcases/tcEdit.php', 1542936047, 1542936047, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(51, '/testlink/lib/testcases/tcEdit.php', 1542936146, 1542936146, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(52, '/testlink/lib/testcases/tcEdit.php', 1542936163, 1542936164, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(53, '/testlink/lib/testcases/tcEdit.php', 1542938626, 1542938626, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(54, '/testlink/lib/testcases/tcEdit.php', 1542939956, 1542939956, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(55, '/testlink/lib/testcases/tcEdit.php', 1542940228, 1542940229, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(56, '/testlink/lib/testcases/tcEdit.php', 1542940558, 1542940558, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(57, '/testlink/lib/testcases/tcEdit.php', 1542941358, 1542941359, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(58, '/testlink/lib/testcases/tcEdit.php', 1542941369, 1542941370, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(59, '/testlink/lib/testcases/tcEdit.php', 1542941510, 1542941510, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(60, '/testlink/lib/testcases/tcEdit.php', 1542941567, 1542941568, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(61, '/testlink/lib/testcases/tcEdit.php', 1542941572, 1542941572, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(62, '/testlink/lib/testcases/tcEdit.php', 1542941639, 1542941639, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(63, '/testlink/lib/testcases/tcEdit.php', 1542941915, 1542941916, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(64, '/testlink/lib/testcases/tcEdit.php', 1542941974, 1542941975, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(65, '/testlink/lib/testcases/tcEdit.php', 1542943626, 1542943627, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(66, '/testlink/lib/testcases/tcEdit.php', 1542943631, 1542943631, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(67, '/testlink/lib/testcases/tcEdit.php', 1542943766, 1542943767, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(68, '/testlink/lib/testcases/tcEdit.php', 1542943838, 1542943838, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(69, '/testlink/lib/testcases/tcEdit.php', 1542944122, 1542944123, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(70, '/testlink/lib/testcases/tcEdit.php', 1542944213, 1542944214, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(71, '/testlink/lib/testcases/tcEdit.php', 1542944260, 1542944261, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(72, '/testlink/lib/testcases/tcEdit.php', 1542944266, 1542944266, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(73, '/testlink/lib/testcases/tcEdit.php', 1542945694, 1542945694, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(74, '/testlink/lib/testcases/tcEdit.php', 1542945702, 1542945702, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(75, '/testlink/lib/testcases/tcEdit.php', 1542946015, 1542946015, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(76, '/testlink/lib/testcases/tcEdit.php', 1542946031, 1542946031, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(77, '/testlink/lib/testcases/tcEdit.php', 1542946079, 1542946079, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(78, '/testlink/lib/testcases/tcEdit.php', 1542946234, 1542946234, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(79, '/testlink/lib/testcases/tcEdit.php', 1542946320, 1542946320, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(80, '/testlink/lib/testcases/tcEdit.php', 1542946333, 1542946333, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(81, '/testlink/lib/testcases/tcEdit.php', 1542946864, 1542946865, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(82, '/testlink/lib/testcases/tcEdit.php', 1542946870, 1542946871, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(83, '/testlink/lib/testcases/tcEdit.php', 1542947149, 1542947149, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(84, '/testlink/lib/testcases/tcEdit.php', 1542947378, 1542947379, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(85, '/testlink/lib/testcases/tcEdit.php', 1542947382, 1542947383, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(86, '/testlink/lib/testcases/tcEdit.php', 1542947384, 1542947385, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(87, '/testlink/lib/testcases/tcEdit.php', 1542947573, 1542947573, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(88, '/testlink/lib/testcases/tcEdit.php', 1542947577, 1542947577, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(89, '/testlink/lib/testcases/tcEdit.php', 1542947661, 1542947662, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(90, '/testlink/lib/testcases/tcEdit.php', 1542947665, 1542947665, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(91, '/testlink/lib/testcases/tcEdit.php', 1542948086, 1542948087, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(92, '/testlink/lib/testcases/tcEdit.php', 1542948307, 1542948308, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(93, '/testlink/lib/testcases/tcEdit.php', 1542948468, 1542948468, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(94, '/testlink/lib/testcases/tcEdit.php', 1542948553, 1542948553, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(95, '/testlink/lib/testcases/tcEdit.php', 1542948659, 1542948660, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(96, '/testlink/lib/testcases/tcEdit.php', 1542948793, 1542948794, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(97, '/testlink/lib/testcases/tcEdit.php', 1542948851, 1542948851, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(98, '/testlink/lib/testcases/tcEdit.php', 1542949233, 1542949234, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(99, '/testlink/lib/testcases/tcEdit.php', 1542949259, 1542949260, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(100, '/testlink/lib/testcases/tcEdit.php', 1542949343, 1542949343, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(101, '/testlink/lib/testcases/tcEdit.php', 1542949415, 1542949416, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(102, '/testlink/lib/testcases/tcEdit.php', 1542949456, 1542949456, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(103, '/testlink/lib/testcases/tcEdit.php', 1542949462, 1542949463, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(104, '/testlink/lib/testcases/tcEdit.php', 1542949468, 1542949468, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(105, '/testlink/lib/testcases/tcEdit.php', 1542949595, 1542949595, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(106, '/testlink/lib/testcases/tcEdit.php', 1542949648, 1542949648, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(107, '/testlink/lib/usermanagement/userInfo.php', 1542950394, 1542950395, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(108, '/testlink/logout.php', 1542950396, 1542950397, 1, 'ssu994jf6je288n87hv8fcvvrj'),
(109, '/testlink/login.php', 1542950397, 1542950397, 0, NULL),
(110, '/testlink/login.php', 1542996847, 1542996847, 0, NULL),
(111, '/testlink/login.php', 1542996854, 1542996855, 1, 'biil210425i0k39jcut41klsrk'),
(112, '/testlink/lib/testcases/tcEdit.php', 1542999175, 1542999175, 1, 'biil210425i0k39jcut41klsrk'),
(113, '/testlink/lib/testcases/tcEdit.php', 1542999178, 1542999178, 1, 'biil210425i0k39jcut41klsrk'),
(114, '/testlink/lib/testcases/tcEdit.php', 1542999394, 1542999394, 1, 'biil210425i0k39jcut41klsrk'),
(115, '/testlink/lib/testcases/tcEdit.php', 1542999520, 1542999521, 1, 'biil210425i0k39jcut41klsrk'),
(116, '/testlink/lib/testcases/tcEdit.php', 1542999561, 1542999562, 1, 'biil210425i0k39jcut41klsrk'),
(117, '/testlink/lib/testcases/tcEdit.php', 1542999828, 1542999829, 1, 'biil210425i0k39jcut41klsrk'),
(118, '/testlink/lib/testcases/tcEdit.php', 1543000013, 1543000013, 1, 'biil210425i0k39jcut41klsrk'),
(119, '/testlink/lib/testcases/tcEdit.php', 1543002220, 1543002221, 1, 'biil210425i0k39jcut41klsrk'),
(120, '/testlink/lib/testcases/tcEdit.php', 1543002224, 1543002224, 1, 'biil210425i0k39jcut41klsrk'),
(121, '/testlink/lib/testcases/tcEdit.php', 1543002531, 1543002531, 1, 'biil210425i0k39jcut41klsrk'),
(122, '/testlink/lib/testcases/tcEdit.php', 1543002534, 1543002535, 1, 'biil210425i0k39jcut41klsrk'),
(123, '/testlink/lib/testcases/tcEdit.php', 1543002703, 1543002703, 1, 'biil210425i0k39jcut41klsrk'),
(124, '/testlink/lib/testcases/tcEdit.php', 1543002713, 1543002713, 1, 'biil210425i0k39jcut41klsrk'),
(125, '/testlink/lib/testcases/tcEdit.php', 1543002774, 1543002774, 1, 'biil210425i0k39jcut41klsrk'),
(126, '/testlink/lib/testcases/tcEdit.php', 1543003615, 1543003615, 1, 'biil210425i0k39jcut41klsrk'),
(127, '/testlink/lib/testcases/tcEdit.php', 1543003619, 1543003620, 1, 'biil210425i0k39jcut41klsrk'),
(128, '/testlink/lib/testcases/tcEdit.php', 1543003834, 1543003834, 1, 'biil210425i0k39jcut41klsrk'),
(129, '/testlink/lib/testcases/tcEdit.php', 1543003999, 1543003999, 1, 'biil210425i0k39jcut41klsrk'),
(130, '/testlink/lib/testcases/tcEdit.php', 1543004002, 1543004003, 1, 'biil210425i0k39jcut41klsrk'),
(131, '/testlink/lib/testcases/tcEdit.php', 1543006789, 1543006789, 1, 'biil210425i0k39jcut41klsrk'),
(132, '/testlink/lib/testcases/tcEdit.php', 1543006892, 1543006892, 1, 'biil210425i0k39jcut41klsrk'),
(133, '/testlink/lib/testcases/tcEdit.php', 1543007012, 1543007012, 1, 'biil210425i0k39jcut41klsrk'),
(134, '/testlink/lib/testcases/tcEdit.php', 1543007066, 1543007066, 1, 'biil210425i0k39jcut41klsrk'),
(135, '/testlink/lib/testcases/tcEdit.php', 1543007156, 1543007156, 1, 'biil210425i0k39jcut41klsrk'),
(136, '/testlink/lib/testcases/tcEdit.php', 1543007299, 1543007299, 1, 'biil210425i0k39jcut41klsrk'),
(137, '/testlink/lib/testcases/tcEdit.php', 1543007305, 1543007305, 1, 'biil210425i0k39jcut41klsrk'),
(138, '/testlink/lib/testcases/tcEdit.php', 1543007318, 1543007318, 1, 'biil210425i0k39jcut41klsrk'),
(139, '/testlink/lib/testcases/tcEdit.php', 1543007321, 1543007321, 1, 'biil210425i0k39jcut41klsrk'),
(140, '/testlink/lib/testcases/tcEdit.php', 1543007330, 1543007330, 1, 'biil210425i0k39jcut41klsrk'),
(141, '/testlink/lib/testcases/tcEdit.php', 1543007332, 1543007332, 1, 'biil210425i0k39jcut41klsrk'),
(142, '/testlink/lib/testcases/tcEdit.php', 1543007338, 1543007339, 1, 'biil210425i0k39jcut41klsrk'),
(143, '/testlink/lib/testcases/tcEdit.php', 1543007341, 1543007341, 1, 'biil210425i0k39jcut41klsrk'),
(144, '/testlink/lib/testcases/tcEdit.php', 1543007347, 1543007347, 1, 'biil210425i0k39jcut41klsrk'),
(145, '/testlink/lib/testcases/tcEdit.php', 1543007844, 1543007844, 1, 'biil210425i0k39jcut41klsrk'),
(146, '/testlink/lib/testcases/tcEdit.php', 1543007849, 1543007849, 1, 'biil210425i0k39jcut41klsrk'),
(147, '/testlink/lib/testcases/tcEdit.php', 1543008218, 1543008218, 1, 'biil210425i0k39jcut41klsrk'),
(148, '/testlink/lib/testcases/tcEdit.php', 1543008313, 1543008313, 1, 'biil210425i0k39jcut41klsrk'),
(149, '/testlink/lib/testcases/tcEdit.php', 1543009278, 1543009279, 1, 'biil210425i0k39jcut41klsrk'),
(150, '/testlink/lib/testcases/tcEdit.php', 1543009431, 1543009431, 1, 'biil210425i0k39jcut41klsrk'),
(151, '/testlink/lib/testcases/tcEdit.php', 1543010522, 1543010523, 1, 'biil210425i0k39jcut41klsrk'),
(152, '/testlink/lib/testcases/tcEdit.php', 1543010526, 1543010526, 1, 'biil210425i0k39jcut41klsrk'),
(153, '/testlink/lib/testcases/tcEdit.php', 1543010744, 1543010744, 1, 'biil210425i0k39jcut41klsrk'),
(154, '/testlink/lib/testcases/tcEdit.php', 1543010760, 1543010760, 1, 'biil210425i0k39jcut41klsrk'),
(155, '/testlink/lib/testcases/tcEdit.php', 1543010934, 1543010934, 1, 'biil210425i0k39jcut41klsrk'),
(156, '/testlink/lib/testcases/tcEdit.php', 1543010992, 1543010992, 1, 'biil210425i0k39jcut41klsrk'),
(157, '/testlink/lib/testcases/tcEdit.php', 1543011468, 1543011468, 1, 'biil210425i0k39jcut41klsrk'),
(158, '/testlink/lib/testcases/tcEdit.php', 1543011472, 1543011472, 1, 'biil210425i0k39jcut41klsrk'),
(159, '/testlink/lib/testcases/tcEdit.php', 1543011683, 1543011683, 1, 'biil210425i0k39jcut41klsrk'),
(160, '/testlink/lib/testcases/tcEdit.php', 1543011686, 1543011686, 1, 'biil210425i0k39jcut41klsrk'),
(161, '/testlink/lib/testcases/tcEdit.php', 1543012238, 1543012238, 1, 'biil210425i0k39jcut41klsrk'),
(162, '/testlink/lib/testcases/tcEdit.php', 1543012243, 1543012243, 1, 'biil210425i0k39jcut41klsrk'),
(163, '/testlink/lib/testcases/tcEdit.php', 1543012409, 1543012409, 1, 'biil210425i0k39jcut41klsrk'),
(164, '/testlink/lib/testcases/tcEdit.php', 1543012479, 1543012480, 1, 'biil210425i0k39jcut41klsrk'),
(165, '/testlink/lib/testcases/tcEdit.php', 1543012989, 1543012990, 1, 'biil210425i0k39jcut41klsrk'),
(166, '/testlink/lib/testcases/tcEdit.php', 1543013229, 1543013229, 1, 'biil210425i0k39jcut41klsrk'),
(167, '/testlink/lib/testcases/tcEdit.php', 1543013516, 1543013516, 1, 'biil210425i0k39jcut41klsrk'),
(168, '/testlink/lib/testcases/tcEdit.php', 1543013522, 1543013522, 1, 'biil210425i0k39jcut41klsrk'),
(169, '/testlink/login.php', 1543014512, 1543014512, 0, NULL),
(170, '/testlink/login.php', 1543014518, 1543014519, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(171, '/testlink/lib/testcases/tcEdit.php', 1543014775, 1543014775, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(172, '/testlink/lib/testcases/tcEdit.php', 1543014778, 1543014778, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(173, '/testlink/lib/testcases/tcEdit.php', 1543016170, 1543016170, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(174, '/testlink/lib/testcases/tcEdit.php', 1543016320, 1543016320, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(175, '/testlink/lib/testcases/tcEdit.php', 1543016609, 1543016609, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(176, '/testlink/lib/testcases/tcEdit.php', 1543016612, 1543016612, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(177, '/testlink/lib/testcases/tcEdit.php', 1543016649, 1543016649, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(178, '/testlink/lib/testcases/tcEdit.php', 1543018236, 1543018236, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(179, '/testlink/lib/testcases/tcEdit.php', 1543018239, 1543018239, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(180, '/testlink/lib/testcases/tcEdit.php', 1543018257, 1543018258, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(181, '/testlink/lib/testcases/tcEdit.php', 1543019175, 1543019176, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(182, '/testlink/lib/testcases/tcEdit.php', 1543019178, 1543019178, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(183, '/testlink/lib/testcases/tcEdit.php', 1543019301, 1543019302, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(184, '/testlink/lib/testcases/tcEdit.php', 1543019774, 1543019774, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(185, '/testlink/lib/testcases/tcEdit.php', 1543022787, 1543022787, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(186, '/testlink/lib/testcases/tcEdit.php', 1543022797, 1543022797, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(187, '/testlink/lib/testcases/tcEdit.php', 1543023818, 1543023818, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(188, '/testlink/lib/testcases/tcEdit.php', 1543023822, 1543023822, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(189, '/testlink/lib/testcases/tcEdit.php', 1543023825, 1543023825, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(190, '/testlink/lib/testcases/tcEdit.php', 1543023933, 1543023934, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(191, '/testlink/lib/testcases/tcEdit.php', 1543023938, 1543023938, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(192, '/testlink/login.php', 1543082993, 1543082993, 1, '7k24j14j1kbpl19agbp0lf9nmr'),
(193, '/testlink/login.php', 1543200647, 1543200647, 0, NULL),
(194, '/testlink/login.php', 1543200664, 1543200664, 1, 'ra9f23gi5071gadt3561m2473v'),
(195, '/testlink/login.php', 1543202457, 1543202457, 0, NULL),
(196, '/testlink/login.php', 1543202467, 1543202467, 1, 'd4b6r2963hclr8ql40l36jdg98');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `login` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `role_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `email` varchar(100) NOT NULL DEFAULT '',
  `first` varchar(50) NOT NULL DEFAULT '',
  `last` varchar(50) NOT NULL DEFAULT '',
  `locale` varchar(10) NOT NULL DEFAULT 'en_GB',
  `default_testproject_id` int(10) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `script_key` varchar(32) DEFAULT NULL,
  `cookie_string` varchar(64) NOT NULL DEFAULT '',
  `auth_method` varchar(10) DEFAULT '',
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User information';

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `login`, `password`, `role_id`, `email`, `first`, `last`, `locale`, `default_testproject_id`, `active`, `script_key`, `cookie_string`, `auth_method`, `creation_ts`, `expiration_date`) VALUES
(1, 'admin', '7488e331b8b64e5794da3fa4eb10ad5d', 8, 'luis.mardones2017@twk.cl', 'Testlink', 'Administrator', 'en_GB', NULL, 1, '589f500bd831d1d2ae21e847c3a5efbe', '5987b1b1d6ec49e12655604127ddf9aa6bfcd17bccf8cf8d2b812ed89add9315', '', '2018-11-22 20:50:23', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_assignments`
--

CREATE TABLE `user_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `feature_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED DEFAULT '0',
  `build_id` int(10) UNSIGNED DEFAULT '0',
  `deadline_ts` datetime DEFAULT NULL,
  `assigner_id` int(10) UNSIGNED DEFAULT '0',
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(10) UNSIGNED DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_group`
--

CREATE TABLE `user_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_group_assign`
--

CREATE TABLE `user_group_assign` (
  `usergroup_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_testplan_roles`
--

CREATE TABLE `user_testplan_roles` (
  `user_id` int(10) NOT NULL DEFAULT '0',
  `testplan_id` int(10) NOT NULL DEFAULT '0',
  `role_id` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_testproject_roles`
--

CREATE TABLE `user_testproject_roles` (
  `user_id` int(10) NOT NULL DEFAULT '0',
  `testproject_id` int(10) NOT NULL DEFAULT '0',
  `role_id` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura para la vista `latest_req_version`
--
DROP TABLE IF EXISTS `latest_req_version`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `latest_req_version`  AS  select `rq`.`id` AS `req_id`,max(`rqv`.`version`) AS `version` from ((`nodes_hierarchy` `nhrqv` join `requirements` `rq` on((`rq`.`id` = `nhrqv`.`parent_id`))) join `req_versions` `rqv` on((`rqv`.`id` = `nhrqv`.`id`))) group by `rq`.`id` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `latest_req_version_id`
--
DROP TABLE IF EXISTS `latest_req_version_id`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `latest_req_version_id`  AS  select `lrqvn`.`req_id` AS `req_id`,`lrqvn`.`version` AS `version`,`reqv`.`id` AS `req_version_id` from ((`latest_req_version` `lrqvn` join `nodes_hierarchy` `nhrqv` on((`nhrqv`.`parent_id` = `lrqvn`.`req_id`))) join `req_versions` `reqv` on(((`reqv`.`id` = `nhrqv`.`id`) and (`reqv`.`version` = `lrqvn`.`version`)))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `latest_rspec_revision`
--
DROP TABLE IF EXISTS `latest_rspec_revision`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `latest_rspec_revision`  AS  select `rsr`.`parent_id` AS `req_spec_id`,`rs`.`testproject_id` AS `testproject_id`,max(`rsr`.`revision`) AS `revision` from (`req_specs_revisions` `rsr` join `req_specs` `rs` on((`rs`.`id` = `rsr`.`parent_id`))) group by `rsr`.`parent_id`,`rs`.`testproject_id` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `latest_tcase_version_id`
--
DROP TABLE IF EXISTS `latest_tcase_version_id`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `latest_tcase_version_id`  AS  select `ltcvn`.`testcase_id` AS `testcase_id`,`ltcvn`.`version` AS `version`,`tcv`.`id` AS `tcversion_id` from ((`latest_tcase_version_number` `ltcvn` join `nodes_hierarchy` `nhtcv` on((`nhtcv`.`parent_id` = `ltcvn`.`testcase_id`))) join `tcversions` `tcv` on(((`tcv`.`id` = `nhtcv`.`id`) and (`tcv`.`version` = `ltcvn`.`version`)))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `latest_tcase_version_number`
--
DROP TABLE IF EXISTS `latest_tcase_version_number`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `latest_tcase_version_number`  AS  select `nh_tc`.`id` AS `testcase_id`,max(`tcv`.`version`) AS `version` from ((`nodes_hierarchy` `nh_tc` join `nodes_hierarchy` `nh_tcv` on((`nh_tcv`.`parent_id` = `nh_tc`.`id`))) join `tcversions` `tcv` on((`nh_tcv`.`id` = `tcv`.`id`))) group by `nh_tc`.`id` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `tcversions_without_keywords`
--
DROP TABLE IF EXISTS `tcversions_without_keywords`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tcversions_without_keywords`  AS  select `nhtcv`.`parent_id` AS `testcase_id`,`nhtcv`.`id` AS `id` from `nodes_hierarchy` `nhtcv` where ((`nhtcv`.`node_type_id` = 4) and (not(exists(select 1 from `testcase_keywords` `tck` where (`tck`.`tcversion_id` = `nhtcv`.`id`))))) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `assignment_status`
--
ALTER TABLE `assignment_status`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `assignment_types`
--
ALTER TABLE `assignment_types`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attachments_idx1` (`fk_id`);

--
-- Indices de la tabla `builds`
--
ALTER TABLE `builds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`testplan_id`,`name`),
  ADD KEY `testplan_id` (`testplan_id`);

--
-- Indices de la tabla `cfield_build_design_values`
--
ALTER TABLE `cfield_build_design_values`
  ADD PRIMARY KEY (`field_id`,`node_id`),
  ADD KEY `idx_cfield_build_design_values` (`node_id`);

--
-- Indices de la tabla `cfield_design_values`
--
ALTER TABLE `cfield_design_values`
  ADD PRIMARY KEY (`field_id`,`node_id`),
  ADD KEY `idx_cfield_design_values` (`node_id`);

--
-- Indices de la tabla `cfield_execution_values`
--
ALTER TABLE `cfield_execution_values`
  ADD PRIMARY KEY (`field_id`,`execution_id`,`testplan_id`,`tcversion_id`);

--
-- Indices de la tabla `cfield_node_types`
--
ALTER TABLE `cfield_node_types`
  ADD PRIMARY KEY (`field_id`,`node_type_id`),
  ADD KEY `idx_custom_fields_assign` (`node_type_id`);

--
-- Indices de la tabla `cfield_testplan_design_values`
--
ALTER TABLE `cfield_testplan_design_values`
  ADD PRIMARY KEY (`field_id`,`link_id`),
  ADD KEY `idx_cfield_tplan_design_val` (`link_id`);

--
-- Indices de la tabla `cfield_testprojects`
--
ALTER TABLE `cfield_testprojects`
  ADD PRIMARY KEY (`field_id`,`testproject_id`);

--
-- Indices de la tabla `codetrackers`
--
ALTER TABLE `codetrackers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codetrackers_uidx1` (`name`);

--
-- Indices de la tabla `custom_fields`
--
ALTER TABLE `custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_custom_fields_name` (`name`);

--
-- Indices de la tabla `db_version`
--
ALTER TABLE `db_version`
  ADD PRIMARY KEY (`version`);

--
-- Indices de la tabla `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `fired_at` (`fired_at`);

--
-- Indices de la tabla `executions`
--
ALTER TABLE `executions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `executions_idx1` (`testplan_id`,`tcversion_id`,`platform_id`,`build_id`),
  ADD KEY `executions_idx2` (`execution_type`),
  ADD KEY `executions_idx3` (`tcversion_id`);

--
-- Indices de la tabla `execution_bugs`
--
ALTER TABLE `execution_bugs`
  ADD PRIMARY KEY (`execution_id`,`bug_id`,`tcstep_id`);

--
-- Indices de la tabla `execution_tcsteps`
--
ALTER TABLE `execution_tcsteps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `execution_tcsteps_idx1` (`execution_id`,`tcstep_id`);

--
-- Indices de la tabla `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_idx1` (`testproject_id`);

--
-- Indices de la tabla `issuetrackers`
--
ALTER TABLE `issuetrackers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `issuetrackers_uidx1` (`name`);

--
-- Indices de la tabla `keywords`
--
ALTER TABLE `keywords`
  ADD PRIMARY KEY (`id`),
  ADD KEY `testproject_id` (`testproject_id`),
  ADD KEY `keyword` (`keyword`);

--
-- Indices de la tabla `milestones`
--
ALTER TABLE `milestones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name_testplan_id` (`name`,`testplan_id`),
  ADD KEY `testplan_id` (`testplan_id`);

--
-- Indices de la tabla `nodes_hierarchy`
--
ALTER TABLE `nodes_hierarchy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid_m_nodeorder` (`parent_id`,`node_order`);

--
-- Indices de la tabla `node_types`
--
ALTER TABLE `node_types`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `object_keywords`
--
ALTER TABLE `object_keywords`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `platforms`
--
ALTER TABLE `platforms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_platforms` (`testproject_id`,`name`);

--
-- Indices de la tabla `plugins`
--
ALTER TABLE `plugins`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `plugins_configuration`
--
ALTER TABLE `plugins_configuration`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `reqmgrsystems`
--
ALTER TABLE `reqmgrsystems`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reqmgrsystems_uidx1` (`name`);

--
-- Indices de la tabla `requirements`
--
ALTER TABLE `requirements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `requirements_req_doc_id` (`srs_id`,`req_doc_id`);

--
-- Indices de la tabla `req_coverage`
--
ALTER TABLE `req_coverage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `req_coverage_full_link` (`req_id`,`req_version_id`,`testcase_id`,`tcversion_id`);

--
-- Indices de la tabla `req_monitor`
--
ALTER TABLE `req_monitor`
  ADD PRIMARY KEY (`req_id`,`user_id`,`testproject_id`);

--
-- Indices de la tabla `req_relations`
--
ALTER TABLE `req_relations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `req_revisions`
--
ALTER TABLE `req_revisions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `req_revisions_uidx1` (`parent_id`,`revision`);

--
-- Indices de la tabla `req_specs`
--
ALTER TABLE `req_specs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `req_spec_uk1` (`doc_id`,`testproject_id`),
  ADD KEY `testproject_id` (`testproject_id`);

--
-- Indices de la tabla `req_specs_revisions`
--
ALTER TABLE `req_specs_revisions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `req_specs_revisions_uidx1` (`parent_id`,`revision`);

--
-- Indices de la tabla `req_versions`
--
ALTER TABLE `req_versions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rights`
--
ALTER TABLE `rights`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rights_descr` (`description`);

--
-- Indices de la tabla `risk_assignments`
--
ALTER TABLE `risk_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `risk_assignments_tplan_node_id` (`testplan_id`,`node_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_rights_roles_descr` (`description`);

--
-- Indices de la tabla `role_rights`
--
ALTER TABLE `role_rights`
  ADD PRIMARY KEY (`role_id`,`right_id`);

--
-- Indices de la tabla `tcsteps`
--
ALTER TABLE `tcsteps`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tcversions`
--
ALTER TABLE `tcversions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `testcase_keywords`
--
ALTER TABLE `testcase_keywords`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx01_testcase_keywords` (`testcase_id`,`tcversion_id`,`keyword_id`);

--
-- Indices de la tabla `testcase_relations`
--
ALTER TABLE `testcase_relations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `testcase_script_links`
--
ALTER TABLE `testcase_script_links`
  ADD PRIMARY KEY (`tcversion_id`,`project_key`,`repository_name`,`code_path`);

--
-- Indices de la tabla `testplans`
--
ALTER TABLE `testplans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `testplans_api_key` (`api_key`),
  ADD KEY `testplans_testproject_id_active` (`testproject_id`,`active`);

--
-- Indices de la tabla `testplan_platforms`
--
ALTER TABLE `testplan_platforms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_testplan_platforms` (`testplan_id`,`platform_id`);

--
-- Indices de la tabla `testplan_tcversions`
--
ALTER TABLE `testplan_tcversions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `testplan_tcversions_tplan_tcversion` (`testplan_id`,`tcversion_id`,`platform_id`);

--
-- Indices de la tabla `testprojects`
--
ALTER TABLE `testprojects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `testprojects_prefix` (`prefix`),
  ADD UNIQUE KEY `testprojects_api_key` (`api_key`),
  ADD KEY `testprojects_id_active` (`id`,`active`);

--
-- Indices de la tabla `testproject_codetracker`
--
ALTER TABLE `testproject_codetracker`
  ADD PRIMARY KEY (`testproject_id`);

--
-- Indices de la tabla `testproject_issuetracker`
--
ALTER TABLE `testproject_issuetracker`
  ADD PRIMARY KEY (`testproject_id`);

--
-- Indices de la tabla `testproject_reqmgrsystem`
--
ALTER TABLE `testproject_reqmgrsystem`
  ADD PRIMARY KEY (`testproject_id`);

--
-- Indices de la tabla `testsuites`
--
ALTER TABLE `testsuites`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `text_templates`
--
ALTER TABLE `text_templates`
  ADD UNIQUE KEY `idx_text_templates` (`type`,`title`);

--
-- Indices de la tabla `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_login` (`login`),
  ADD UNIQUE KEY `users_cookie_string` (`cookie_string`);

--
-- Indices de la tabla `user_assignments`
--
ALTER TABLE `user_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_assignments_feature_id` (`feature_id`);

--
-- Indices de la tabla `user_group`
--
ALTER TABLE `user_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_user_group` (`title`);

--
-- Indices de la tabla `user_group_assign`
--
ALTER TABLE `user_group_assign`
  ADD UNIQUE KEY `idx_user_group_assign` (`usergroup_id`,`user_id`);

--
-- Indices de la tabla `user_testplan_roles`
--
ALTER TABLE `user_testplan_roles`
  ADD PRIMARY KEY (`user_id`,`testplan_id`);

--
-- Indices de la tabla `user_testproject_roles`
--
ALTER TABLE `user_testproject_roles`
  ADD PRIMARY KEY (`user_id`,`testproject_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `assignment_status`
--
ALTER TABLE `assignment_status`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `assignment_types`
--
ALTER TABLE `assignment_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `attachments`
--
ALTER TABLE `attachments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `builds`
--
ALTER TABLE `builds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `codetrackers`
--
ALTER TABLE `codetrackers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `custom_fields`
--
ALTER TABLE `custom_fields`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `events`
--
ALTER TABLE `events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=669;

--
-- AUTO_INCREMENT de la tabla `executions`
--
ALTER TABLE `executions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `execution_tcsteps`
--
ALTER TABLE `execution_tcsteps`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `issuetrackers`
--
ALTER TABLE `issuetrackers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `keywords`
--
ALTER TABLE `keywords`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `milestones`
--
ALTER TABLE `milestones`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `nodes_hierarchy`
--
ALTER TABLE `nodes_hierarchy`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT de la tabla `node_types`
--
ALTER TABLE `node_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `object_keywords`
--
ALTER TABLE `object_keywords`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `platforms`
--
ALTER TABLE `platforms`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plugins`
--
ALTER TABLE `plugins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plugins_configuration`
--
ALTER TABLE `plugins_configuration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reqmgrsystems`
--
ALTER TABLE `reqmgrsystems`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `req_coverage`
--
ALTER TABLE `req_coverage`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `req_relations`
--
ALTER TABLE `req_relations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rights`
--
ALTER TABLE `rights`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `risk_assignments`
--
ALTER TABLE `risk_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `testcase_keywords`
--
ALTER TABLE `testcase_keywords`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT de la tabla `testcase_relations`
--
ALTER TABLE `testcase_relations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `testplan_platforms`
--
ALTER TABLE `testplan_platforms`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `testplan_tcversions`
--
ALTER TABLE `testplan_tcversions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=197;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `user_assignments`
--
ALTER TABLE `user_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user_group`
--
ALTER TABLE `user_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
