/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: spmvv_results
-- ------------------------------------------------------
-- Server version	10.11.16-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action` varchar(50) NOT NULL,
  `details` longtext NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `timestamp` datetime(6) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_logs_user_id_88267f_idx` (`user_id`,`timestamp`),
  KEY `audit_logs_action_474804_idx` (`action`,`timestamp`),
  CONSTRAINT `audit_logs_user_id_752b0e2b_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1252 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES
(1,'login','Successful login from 10.189.158.139','10.189.158.139','2026-02-10 09:09:04.365010',1),
(2,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 09:13:55.555775',1),
(3,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 09:18:22.754502',1),
(4,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 09:19:17.073812',1),
(5,'login','Successful login from 10.189.158.139','10.189.158.139','2026-02-10 09:20:00.568408',1),
(6,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 12:37:11.257248',1),
(7,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 13:06:03.845564',1),
(8,'user_registration','Student registered: test123','10.189.219.158','2026-02-10 13:11:15.794336',2),
(9,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 13:11:34.739937',2),
(10,'result_view','Viewed results: 0 records','10.189.219.158','2026-02-10 13:11:35.161738',2),
(11,'result_view','Viewed results: 0 records','10.189.219.158','2026-02-10 13:11:35.323151',2),
(12,'result_view','Viewed results: 0 records','10.189.219.158','2026-02-10 13:22:27.196148',2),
(13,'result_view','Viewed results: 0 records','10.189.219.158','2026-02-10 13:22:27.397493',2),
(14,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 13:22:51.297559',1),
(15,'result_view','Viewed results: 0 records','10.189.219.158','2026-02-10 13:23:27.828683',2),
(16,'result_upload','Uploaded results: 5 created, 0 updated, Branches: [\'eee\', \'cse\', \'mech\']','10.189.219.158','2026-02-10 13:23:34.933355',1),
(17,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:23:43.415994',2),
(18,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:23:43.588607',2),
(19,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:24:15.524533',2),
(20,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:24:15.724683',2),
(21,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:25:15.867315',2),
(22,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 13:26:15.845563',2),
(23,'result_upload','Uploaded results: 5 created, 0 updated, Branches: [\'eee\', \'cse\', \'mech\']','10.189.219.158','2026-02-10 13:26:35.200592',1),
(24,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 13:26:39.905190',2),
(25,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 13:26:40.096192',2),
(26,'result_upload','Uploaded results: 1 created, 0 updated, Branches: [\'eee\']','10.189.219.158','2026-02-10 13:27:35.445482',1),
(27,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:27:39.944498',2),
(28,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:27:41.653724',2),
(29,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:27:41.844381',2),
(30,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:28:41.826150',2),
(31,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:42:03.873145',2),
(32,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:42:04.063064',2),
(33,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:43:04.871024',2),
(34,'result_upload','Uploaded results: 1 created, 0 updated, Branches: [\'eee\']','10.189.219.158','2026-02-10 13:43:39.204177',1),
(35,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:43:59.028617',2),
(36,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:43:59.218796',2),
(37,'result_upload','Uploaded results: 1 created, 0 updated, Branches: [\'eee\']','10.189.219.158','2026-02-10 13:44:27.485464',1),
(38,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:44:41.345130',2),
(39,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:44:41.524892',2),
(40,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:45:41.363461',2),
(41,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:46:41.339968',2),
(42,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:47:41.369115',2),
(43,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:48:41.354099',2),
(44,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:49:41.343511',2),
(45,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:50:06.819682',2),
(46,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:50:07.012513',2),
(47,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:51:06.858273',2),
(48,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:52:06.848261',2),
(49,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:53:06.849367',2),
(50,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:54:06.860436',2),
(51,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:54:50.532670',2),
(52,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:54:50.698581',2),
(53,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:55:50.883386',2),
(54,'result_view','Viewed results: 3 records','10.89.0.1','2026-02-10 13:56:08.468376',2),
(55,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:56:40.864840',2),
(56,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:56:41.082864',2),
(57,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:57:41.864084',2),
(58,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:58:24.640349',2),
(59,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:58:24.828114',2),
(60,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 13:59:24.863318',2),
(61,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:00:24.863400',2),
(62,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:01:24.848470',2),
(63,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:02:24.851409',2),
(64,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:03:24.852368',2),
(65,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:04:24.862840',2),
(66,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:05:56.883909',2),
(67,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:06:56.888035',2),
(68,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:07:56.883289',2),
(69,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:08:56.883407',2),
(70,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:09:38.458435',2),
(71,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:09:41.393092',2),
(72,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:09:41.583759',2),
(73,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:10:41.409481',2),
(74,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 14:12:12.818859',2),
(75,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:12:13.052740',2),
(76,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:12:13.238375',2),
(77,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:13:13.889048',2),
(78,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:14:13.877799',2),
(79,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:15:13.868976',2),
(80,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:16:13.042166',2),
(81,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:17:58.176832',2),
(82,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:17:58.376998',2),
(83,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:18:58.877184',2),
(84,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:19:58.883332',2),
(85,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:20:58.881338',2),
(86,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:21:58.887582',2),
(87,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:22:58.881999',2),
(88,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:23:58.901418',2),
(89,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:25:30.882381',2),
(90,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:25:51.467324',2),
(91,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:25:51.662869',2),
(92,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:26:51.883806',2),
(93,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:27:51.921860',2),
(94,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:28:51.892222',2),
(95,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:29:51.887793',2),
(96,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:30:51.886587',2),
(97,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:31:51.881692',2),
(98,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:32:56.904061',2),
(99,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:33:56.881623',2),
(100,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:34:56.892152',2),
(101,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:35:56.881722',2),
(102,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:36:56.896984',2),
(103,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:37:56.901505',2),
(104,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:38:56.891348',2),
(105,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:39:56.869152',2),
(106,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:40:56.901549',2),
(107,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:41:56.881848',2),
(108,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:42:56.886771',2),
(109,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:43:56.887046',2),
(110,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:44:56.937355',2),
(111,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:45:56.990767',2),
(112,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:46:43.122314',2),
(113,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:46:43.311643',2),
(114,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:47:43.156781',2),
(115,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:48:43.886340',2),
(116,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:49:43.888531',2),
(117,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:50:43.184626',2),
(118,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:51:43.151494',2),
(119,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:52:43.146836',2),
(120,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:53:43.147578',2),
(121,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:54:43.163063',2),
(122,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:55:43.901907',2),
(123,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:56:43.176785',2),
(124,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 14:57:24.880641',1),
(125,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:57:43.900097',2),
(126,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:58:44.894561',2),
(127,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 14:59:45.890495',2),
(128,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:00:46.941666',2),
(129,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:01:47.892637',2),
(130,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:02:48.887212',2),
(131,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:03:49.896802',2),
(132,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:04:50.906968',2),
(133,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:05:51.923296',2),
(134,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:06:52.898341',2),
(135,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:07:53.892404',2),
(136,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:08:54.888391',2),
(137,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:09:55.898097',2),
(138,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:10:56.903539',2),
(139,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:11:57.082879',2),
(140,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 15:12:49.354811',2),
(141,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:12:49.596884',2),
(142,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:12:49.792420',2),
(143,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:13:49.902198',2),
(144,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:14:49.901606',2),
(145,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:15:49.942757',2),
(146,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:16:49.916125',2),
(147,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:17:49.901918',2),
(148,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:18:49.909171',2),
(149,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:19:56.901415',2),
(150,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:20:56.922647',2),
(151,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:21:49.903006',2),
(152,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:22:56.897525',2),
(153,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:23:56.907104',2),
(154,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:24:56.891547',2),
(155,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:25:56.936663',2),
(156,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:26:56.912913',2),
(157,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:27:56.902159',2),
(158,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:28:56.921497',2),
(159,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:29:56.901696',2),
(160,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:30:56.902943',2),
(161,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:31:56.902517',2),
(162,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:32:49.907206',2),
(163,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:33:56.921931',2),
(164,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:34:56.922573',2),
(165,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:35:56.922325',2),
(166,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:36:56.928297',2),
(167,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:37:56.926060',2),
(168,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:38:56.938240',2),
(169,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:39:56.931949',2),
(170,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:40:57.024479',2),
(171,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:41:56.929092',2),
(172,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:42:56.927677',2),
(173,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:43:56.942136',2),
(174,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:44:56.921328',2),
(175,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:45:56.927145',2),
(176,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:46:56.926785',2),
(177,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:47:56.922524',2),
(178,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:48:41.177344',2),
(179,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:48:41.357698',2),
(180,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:49:41.933350',2),
(181,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:50:41.919368',2),
(182,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:51:41.929488',2),
(183,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:52:41.946180',2),
(184,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:53:41.929137',2),
(185,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:54:41.919477',2),
(186,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:55:56.919599',2),
(187,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:56:56.920047',2),
(188,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:57:56.909598',2),
(189,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:58:56.934500',2),
(190,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 15:59:56.931771',2),
(191,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:00:56.966543',2),
(192,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:01:56.936427',2),
(193,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:02:56.924796',2),
(194,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:03:56.970110',2),
(195,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:04:56.945392',2),
(196,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:05:56.945268',2),
(197,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:06:56.931354',2),
(198,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 16:07:54.183231',1),
(199,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:07:56.935340',2),
(200,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:08:56.945210',2),
(201,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:09:56.930181',2),
(202,'result_view','Viewed results: 3 records','10.189.219.158','2026-02-10 16:10:56.945688',2),
(203,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 16:27:40.606230',1),
(204,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 16:38:37.657027',1),
(205,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 17:18:13.436011',1),
(206,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 17:23:13.349668',1),
(207,'DELETE_EXAM','Deleted exam: B.Tech III year I Semester Supplementary Exam Results January 2026 (1 students, 1 total records)','10.189.219.158','2026-02-10 17:40:08.544594',1),
(208,'DELETE_EXAM','Deleted exam: B.Tech I year I Semester Supplementary Exam Results February 2026 (2 students, 2 total records)','10.189.219.158','2026-02-10 17:40:12.292080',1),
(209,'DELETE_EXAM','Deleted exam: B.Tech I year II Semester Regular Exam Results January 2026 (5 students, 5 total records)','10.189.219.158','2026-02-10 17:40:15.738407',1),
(210,'DELETE_EXAM','Deleted exam: B.Tech I year I Semester Regular Exam Results February 2026 (5 students, 5 total records)','10.189.219.158','2026-02-10 17:40:19.227555',1),
(211,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:45:44.184921',1),
(212,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:46:27.038335',1),
(213,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:49:10.557437',1),
(214,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:50:29.428460',1),
(215,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:52:06.648912',1),
(216,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:55:37.494352',1),
(217,'result_upload','Uploaded results: 6 created, 0 updated, Branches: [\'it\', \'ece\', \'cse\']','10.89.0.1','2026-02-10 17:55:37.565272',1),
(218,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:56:46.775813',1),
(219,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:58:14.230418',1),
(220,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 17:58:27.725433',1),
(221,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 18:00:09.550811',1),
(222,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 18:00:21.774040',1),
(223,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 18:00:31.978461',1),
(224,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-10 18:00:41.788553',1),
(225,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 18:01:58.624402',1),
(226,'result_upload','Uploaded results: 4 created, 0 updated, Branches: [\'cse\']','10.189.219.158','2026-02-10 18:03:03.098576',1),
(227,'user_registration','Student registered: 2271010','10.189.219.158','2026-02-10 18:12:16.960209',3),
(228,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 18:12:28.834706',3),
(229,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:12:29.260298',3),
(230,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:12:29.464723',3),
(231,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:13:30.014880',3),
(232,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:14:30.024115',3),
(233,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:15:29.989666',3),
(234,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:16:29.984374',3),
(235,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:17:30.005303',3),
(236,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:18:29.986731',3),
(237,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:19:57.015320',3),
(238,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:20:57.013488',3),
(239,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:21:57.023886',3),
(240,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:22:57.006733',3),
(241,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:23:56.998835',3),
(242,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:24:57.024414',3),
(243,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:25:57.004320',3),
(244,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:28:43.914153',3),
(245,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:28:44.099136',3),
(246,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:28:46.984399',3),
(247,'result_view','Viewed results: 1 records','10.189.219.158','2026-02-10 18:28:47.174083',3),
(248,'result_upload','Uploaded results: 4 created, 0 updated, Branches: [\'cse\']','10.189.219.158','2026-02-10 18:29:27.937253',1),
(249,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:29:34.068532',3),
(250,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:29:34.263254',3),
(251,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:30:35.004481',3),
(252,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:31:34.998662',3),
(253,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:32:35.025815',3),
(254,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:33:10.424794',3),
(255,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:33:10.643733',3),
(256,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:34:11.026996',3),
(257,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:35:11.008465',3),
(258,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:36:11.019550',3),
(259,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:36:52.859783',3),
(260,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:36:53.068602',3),
(261,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:37:20.008779',3),
(262,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:37:20.203917',3),
(263,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:37:36.220417',3),
(264,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:37:36.427776',3),
(265,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:38:37.028782',3),
(266,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:39:37.043311',3),
(267,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:39:47.698013',3),
(268,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:39:47.909605',3),
(269,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:40:48.043457',3),
(270,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:41:13.612949',3),
(271,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:41:13.824863',3),
(272,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-10 18:50:14.370576',3),
(273,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:50:14.643566',3),
(274,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:50:14.836291',3),
(275,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:51:15.019924',3),
(276,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:52:15.046590',3),
(277,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:53:15.045998',3),
(278,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:53:37.194181',3),
(279,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:53:37.388080',3),
(280,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:54:03.625336',3),
(281,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-10 18:54:03.827561',3),
(282,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:17:08.723419',1),
(283,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:17:33.409140',3),
(284,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:17:33.831208',3),
(285,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:17:33.831426',3),
(286,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:30:42.878883',1),
(287,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:33:09.440731',3),
(288,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:33:09.870428',3),
(289,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:33:10.059349',3),
(290,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:34:10.113918',3),
(291,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:35:09.806389',3),
(292,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 00:42:10.391714',1),
(293,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:43:36.337971',3),
(294,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:43:36.559695',3),
(295,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:43:36.763966',3),
(296,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:44:37.146270',3),
(297,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:44:41.192964',1),
(298,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:45:37.134163',3),
(299,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:46:37.150618',3),
(300,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:47:37.128614',3),
(301,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:52:24.215221',1),
(302,'circular_created','Created circular: leave','10.189.219.158','2026-02-11 00:53:54.613931',1),
(303,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 00:54:04.436038',3),
(304,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:54:04.692371',3),
(305,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:54:04.873774',3),
(306,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:54:19.489052',3),
(307,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:54:19.688432',3),
(308,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:55:20.133264',3),
(309,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:56:20.149689',3),
(310,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:57:20.138907',3),
(311,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:58:20.138901',3),
(312,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 00:59:20.148754',3),
(313,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:00:19.478599',3),
(314,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:01:33.541510',3),
(315,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:01:33.753425',3),
(316,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:02:34.168163',3),
(317,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:06:40.540004',1),
(318,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:09:41.084800',1),
(319,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:10:00.802645',1),
(320,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:10:09.669708',1),
(321,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:10:19.140012',1),
(322,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:10:19.253557',3),
(323,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:11:38.091644',3),
(324,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:13:31.382742',3),
(325,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.89.0.1','2026-02-11 01:13:31.397369',3),
(326,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 01:18:25.998191',1),
(327,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 01:20:53.619697',3),
(328,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:20:53.849336',3),
(329,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:20:54.067628',3),
(330,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:21:54.154484',3),
(331,'result_view','Viewed results: 2 records','10.189.219.158','2026-02-11 01:22:54.144137',3),
(332,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 01:28:50.735174',3),
(333,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:28:51.138588',3),
(334,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:28:51.349903',3),
(335,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:36:05.146342',3),
(336,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:36:05.329229',3),
(337,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:37:05.177277',3),
(338,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:38:05.176404',3),
(339,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:39:05.168022',3),
(340,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:39:39.577025',3),
(341,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:39:39.764838',3),
(342,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:40:39.595043',3),
(343,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 01:54:17.975570',1),
(344,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 01:54:31.116192',3),
(345,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:54:31.344391',3),
(346,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:54:31.536024',3),
(347,'circular_created','Created circular: leave','10.189.219.158','2026-02-11 01:55:33.014102',1),
(348,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:55:37.743874',3),
(349,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:55:37.934099',3),
(350,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:55:44.034470',3),
(351,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:55:44.245441',3),
(352,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:56:44.188684',3),
(353,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 01:57:44.194649',3),
(354,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:57:48.787761',3),
(355,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 01:59:09.245745',3),
(356,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 02:01:31.459099',3),
(357,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:04:15.603960',3),
(358,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:04:15.813852',3),
(359,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:04:16.017692',3),
(360,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 02:05:51.539879',1),
(361,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:06:02.674433',1),
(362,'circular_created','Created circular: hello','10.189.219.158','2026-02-11 02:06:20.273388',1),
(363,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:06:23.897744',3),
(364,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:06:24.094349',3),
(365,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:06:30.281305',3),
(366,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:06:30.488473',3),
(367,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:07:30.296412',3),
(368,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:08:30.827193',3),
(369,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:09:31.195485',3),
(370,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:11:30.501514',3),
(371,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:11:30.696154',3),
(372,'circular_created','Created circular: hi','10.189.219.158','2026-02-11 02:11:50.062957',1),
(373,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:11:57.593523',3),
(374,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:11:57.800010',3),
(375,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:12:03.974022',3),
(376,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:12:04.194189',3),
(377,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:12:52.919158',3),
(378,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:12:53.318552',3),
(379,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:12:53.509869',3),
(380,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:13:04.193686',3),
(381,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:14:04.214810',3),
(382,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:15:04.198993',3),
(383,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:17:04.333177',3),
(384,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:17:17.951052',3),
(385,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:17:18.185733',3),
(386,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:17:55.456331',3),
(387,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:17:55.673788',3),
(388,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-11 02:18:15.280833',3),
(389,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:18:18.196069',3),
(390,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:18:22.368111',1),
(391,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:18:56.235553',3),
(392,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:19:18.184681',3),
(393,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:19:56.214435',3),
(394,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:20:18.193513',3),
(395,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:20:56.201638',3),
(396,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:21:18.194258',3),
(397,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:21:56.193631',3),
(398,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:22:18.188299',3),
(399,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:22:56.214214',3),
(400,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:23:18.213622',3),
(401,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:23:56.201256',3),
(402,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:32:12.420641',3),
(403,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:32:12.634747',3),
(404,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:33:13.194147',3),
(405,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:34:13.194224',3),
(406,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:35:13.213108',3),
(407,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:39:09.747390',3),
(408,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:39:09.965727',3),
(409,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:39:10.187182',3),
(410,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:39:35.860637',3),
(411,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:39:36.063653',3),
(412,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 02:39:54.357548',1),
(413,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:40:36.209415',3),
(414,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:41:36.219611',3),
(415,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:42:36.215604',3),
(416,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:43:36.198601',3),
(417,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:44:36.236352',3),
(418,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:45:36.213533',3),
(419,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:46:49.240066',3),
(420,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:47:49.217882',3),
(421,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:48:49.215903',3),
(422,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:49:49.214501',3),
(423,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:50:49.200339',3),
(424,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 02:51:49.214901',3),
(425,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 07:44:25.524287',3),
(426,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:44:25.974519',3),
(427,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:44:26.195597',3),
(428,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:45:12.826561',3),
(429,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:45:13.060446',3),
(430,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:45:20.722185',3),
(431,'consolidated_result_view','Viewed consolidated results: 2 year/semester groups','10.189.219.158','2026-02-11 07:45:20.939371',3),
(432,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 07:45:34.106973',1),
(433,'result_upload','Uploaded results: 4 created, 0 updated, Branches: [\'cse\']','10.189.219.158','2026-02-11 07:45:54.880855',1),
(434,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:46:04.663394',3),
(435,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:46:04.874752',3),
(436,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:46:16.581830',3),
(437,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:46:16.784971',3),
(438,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:47:16.571278',3),
(439,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 07:48:43.208910',3),
(440,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:48:43.480690',3),
(441,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 07:48:43.740359',3),
(442,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:32:14.343150',3),
(443,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:32:14.550949',3),
(444,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:33:14.431320',3),
(445,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:34:14.431819',3),
(446,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:35:14.411377',3),
(447,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:36:14.469401',3),
(448,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:37:14.423395',3),
(449,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:37:34.450517',3),
(450,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:38:32.942315',3),
(451,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:38:33.155397',3),
(452,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:39:33.431513',3),
(453,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:40:33.431919',3),
(454,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:41:33.430439',3),
(455,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:45:49.358799',3),
(456,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 08:45:49.558644',3),
(457,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 08:48:43.687347',1),
(458,'HALL_TICKETS_GENERATED','{\'exam_id\': 1, \'generated_count\': 0, \'skipped_count\': 2, \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 08:52:54.889758',1),
(459,'HALL_TICKETS_GENERATED','{\'exam_id\': 1, \'generated_count\': 0, \'skipped_count\': 2, \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 08:53:07.665490',1),
(460,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 09:04:36.251538',1),
(461,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 09:32:21.993922',3),
(462,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:32:22.226588',3),
(463,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:32:22.414616',3),
(464,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:33:22.245687',3),
(465,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:34:22.444265',3),
(466,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:35:22.446480',3),
(467,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:36:22.934905',3),
(468,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:37:22.462270',3),
(469,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:38:22.475329',3),
(470,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:39:49.441018',3),
(471,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:40:49.458690',3),
(472,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:41:29.292339',3),
(473,'circular_created','Created circular: exam','10.189.219.158','2026-02-11 09:44:34.640414',1),
(474,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:45:21.514932',3),
(475,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:45:21.705732',3),
(476,'PHOTO_UPLOADED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 09:45:33.075844',3),
(477,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 09:45:45.266472',3),
(478,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:45:56.571990',3),
(479,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:45:56.764639',3),
(480,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:46:57.448395',3),
(481,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:47:57.455463',3),
(482,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:48:57.445511',3),
(483,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:49:57.203004',3),
(484,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:50:00.708038',3),
(485,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:50:00.905928',3),
(486,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 09:50:09.656901',3),
(487,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:51:01.444737',3),
(488,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:52:01.466904',3),
(489,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:53:02.066484',3),
(490,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:54:01.452113',3),
(491,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:55:01.473465',3),
(492,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:56:01.455120',3),
(493,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 09:57:34.461583',3),
(494,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:03:01.157808',3),
(495,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:03:01.349929',3),
(496,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 10:03:09.973268',3),
(497,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:05:33.624476',3),
(498,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:05:33.809532',3),
(499,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:06:33.618765',3),
(500,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:07:33.635829',3),
(501,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:08:33.621092',3),
(502,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:09:34.467989',3),
(503,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:10:34.459101',3),
(504,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:11:33.657041',3),
(505,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:12:33.641479',3),
(506,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 10:16:45.401256',1),
(507,'circular_deleted','Deleted circular: Test Download Circular','10.189.219.158','2026-02-11 10:16:55.402512',1),
(508,'circular_deleted','Deleted circular: hello','10.189.219.158','2026-02-11 10:17:02.107144',1),
(509,'circular_deleted','Deleted circular: exam','10.189.219.158','2026-02-11 10:17:05.666073',1),
(510,'circular_deleted','Deleted circular: hi','10.189.219.158','2026-02-11 10:17:08.304683',1),
(511,'circular_deleted','Deleted circular: leave','10.189.219.158','2026-02-11 10:17:10.590569',1),
(512,'circular_deleted','Deleted circular: leave','10.189.219.158','2026-02-11 10:17:13.226540',1),
(513,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:20:41.609439',3),
(514,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:20:41.816027',3),
(515,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 10:21:37.895824',3),
(516,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 10:36:45.628993',3),
(517,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:36:46.313336',3),
(518,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:36:46.526999',3),
(519,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:37:01.387851',3),
(520,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:37:01.646603',3),
(521,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 10:37:17.952811',3),
(522,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 10:37:35.446270',3),
(523,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:37:58.452460',3),
(524,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:37:58.660918',3),
(525,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:50:42.249888',3),
(526,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:50:42.451606',3),
(527,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 10:50:57.825187',3),
(528,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:51:42.276784',3),
(529,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:52:42.237283',3),
(530,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:53:42.741958',3),
(531,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:54:42.499653',3),
(532,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:55:42.506986',3),
(533,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:56:42.926231',3),
(534,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:57:49.512039',3),
(535,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:58:49.490544',3),
(536,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 10:59:49.510952',3),
(537,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:00:49.487820',3),
(538,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:01:49.482685',3),
(539,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:02:49.499866',3),
(540,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:03:49.512826',3),
(541,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:04:26.388171',3),
(542,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:04:26.580320',3),
(543,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:04:37.285191',3),
(544,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:04:37.503639',3),
(545,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 11:04:50.777233',3),
(546,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:05:37.510201',3),
(547,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:07:18.209771',3),
(548,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:07:18.409206',3),
(549,'logout','Logout from 10.189.219.158','10.189.219.158','2026-02-11 11:07:19.430037',3),
(550,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 11:16:11.183265',3),
(551,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:16:11.449224',3),
(552,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:16:11.651962',3),
(553,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 11:16:17.611239',3),
(554,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:17:11.610234',3),
(555,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 11:17:25.465278',3),
(556,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 11:18:02.611966',3),
(557,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:18:11.471957',3),
(558,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:19:11.510307',3),
(559,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:20:11.531047',3),
(560,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:20:46.532433',3),
(561,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:20:46.749015',3),
(562,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:21:46.530452',3),
(563,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:22:47.526886',3),
(564,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:23:47.530907',3),
(565,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:24:48.047091',3),
(566,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:25:48.041208',3),
(567,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:26:48.071890',3),
(568,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:27:48.554680',3),
(569,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.219.158','2026-02-11 11:28:49.513916',3),
(570,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 12:38:59.849242',1),
(571,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 12:43:04.097155',1),
(572,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 12:43:12.461600',1),
(573,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 12:43:20.393234',1),
(574,'PROFILE_UPDATE','Student None updated profile',NULL,'2026-02-11 12:43:20.406165',1),
(575,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 12:43:27.992991',1),
(576,'login','Successful login from 10.189.219.158','10.189.219.158','2026-02-11 16:06:46.273087',1),
(577,'EXAM_CREATED','{\'exam_id\': 2, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:35:40.558752',1),
(578,'EXAM_CREATED','{\'exam_id\': 3, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:35:45.829152',1),
(579,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:36:22.330764',1),
(580,'EXAM_CREATED','{\'exam_id\': 4, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations February 2026\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:36:31.924202',1),
(581,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:39:27.663946',1),
(582,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:41:53.497050',1),
(583,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:42:01.919873',1),
(584,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:42:58.250950',1),
(585,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:43:54.050096',1),
(586,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:44:53.361917',1),
(587,'SUBJECT_ADDED','{\'exam_id\': 4, \'subject_id\': 5, \'subject_code\': \'CS101\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:44:53.381796',1),
(588,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:45:02.356460',1),
(589,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:45:12.615439',1),
(590,'SUBJECT_ADDED','{\'exam_id\': 4, \'subject_id\': 6, \'subject_code\': \'CS102\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:45:12.672190',1),
(591,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:45:20.817442',1),
(592,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:46:05.407071',1),
(593,'SUBJECT_ADDED','{\'exam_id\': 4, \'subject_id\': 7, \'subject_code\': \'CS103\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:46:05.822290',1),
(594,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:46:13.998715',1),
(595,'EXAM_CREATED','{\'exam_id\': 5, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:49:19.081331',1),
(596,'EXAM_CREATED','{\'exam_id\': 6, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:49:21.630301',1),
(597,'EXAM_CREATED','{\'exam_id\': 7, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:51:24.931819',1),
(598,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:52:04.675962',1),
(599,'EXAM_CREATED','{\'exam_id\': 8, \'exam_name\': \'Test Exam\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:52:04.692031',1),
(600,'EXAM_CREATED','{\'exam_id\': 9, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:56:57.930278',1),
(601,'SUBJECT_ADDED','{\'exam_id\': 9, \'subject_id\': 8, \'subject_code\': \'c101\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 16:56:58.332419',1),
(602,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 16:59:22.583767',1),
(603,'EXAM_CREATED','{\'exam_id\': 10, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations March 2026\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:59:22.615884',1),
(604,'SUBJECT_ADDED','{\'exam_id\': 10, \'subject_id\': 9, \'subject_code\': \'CS101\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:59:22.682541',1),
(605,'SUBJECT_ADDED','{\'exam_id\': 10, \'subject_id\': 10, \'subject_code\': \'CS102\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:59:22.726958',1),
(606,'SUBJECT_ADDED','{\'exam_id\': 10, \'subject_id\': 11, \'subject_code\': \'CS103\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 16:59:22.769072',1),
(607,'EXAM_CREATED','{\'exam_id\': 11, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 17:00:36.887463',1),
(608,'SUBJECT_ADDED','{\'exam_id\': 11, \'subject_id\': 12, \'subject_code\': \'c101\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 17:00:37.249042',1),
(609,'EXAM_CREATED','{\'exam_id\': 12, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 17:01:16.615154',1),
(610,'SUBJECT_ADDED','{\'exam_id\': 12, \'subject_id\': 13, \'subject_code\': \'c101\', \'ip\': \'10.189.219.158\'}','10.189.219.158','2026-02-11 17:01:16.944440',1),
(611,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 17:02:53.239116',1),
(612,'SUBJECT_ADDED','{\'exam_id\': 10, \'subject_id\': 14, \'subject_code\': \'CS104\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 17:02:53.259267',1),
(613,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 17:03:27.473909',1),
(614,'EXAM_CREATED','{\'exam_id\': 13, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations April 2026\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 17:03:27.491816',1),
(615,'SUBJECT_ADDED','{\'exam_id\': 13, \'subject_id\': 15, \'subject_code\': \'CS201\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 17:03:27.564653',1),
(616,'SUBJECT_ADDED','{\'exam_id\': 13, \'subject_id\': 16, \'subject_code\': \'CS202\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-11 17:03:27.613732',1),
(617,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-11 17:03:36.951070',1),
(618,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:05:21.745274',1),
(619,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:05:31.314857',1),
(620,'EXAM_CREATED','{\'exam_id\': 14, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations May 2026\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-11 17:05:31.334393',1),
(621,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:05:40.741488',1),
(622,'SUBJECT_ADDED','{\'exam_id\': 14, \'subject_id\': 17, \'subject_code\': \'CS101\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-11 17:05:40.772546',1),
(623,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:08:36.039861',1),
(624,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:08:45.095108',1),
(625,'EXAM_CREATED','{\'exam_id\': 15, \'exam_name\': \'Verification Test\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-11 17:08:45.110481',1),
(626,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:08:53.880059',1),
(627,'SUBJECT_ADDED','{\'exam_id\': 15, \'subject_id\': 18, \'subject_code\': \'CS101\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-11 17:08:53.893950',1),
(628,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-11 17:09:02.622445',1),
(629,'login','Successful login from 10.189.145.57','10.189.145.57','2026-02-12 01:18:20.944253',1),
(630,'EXAM_CREATED','{\'exam_id\': 16, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:50.512029',1),
(631,'SUBJECT_ADDED','{\'exam_id\': 16, \'subject_id\': 19, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:50.885634',1),
(632,'EXAM_CREATED','{\'exam_id\': 17, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:53.191472',1),
(633,'SUBJECT_ADDED','{\'exam_id\': 17, \'subject_id\': 20, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:53.591266',1),
(634,'EXAM_CREATED','{\'exam_id\': 18, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:55.231250',1),
(635,'SUBJECT_ADDED','{\'exam_id\': 18, \'subject_id\': 21, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:18:55.611011',1),
(636,'EXAM_CREATED','{\'exam_id\': 19, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:19:09.690758',1),
(637,'SUBJECT_ADDED','{\'exam_id\': 19, \'subject_id\': 22, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:19:10.051967',1),
(638,'EXAM_CREATED','{\'exam_id\': 20, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:22:40.811170',1),
(639,'SUBJECT_ADDED','{\'exam_id\': 20, \'subject_id\': 23, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:22:41.186248',1),
(640,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 01:24:04.756418',1),
(641,'EXAM_CREATED','{\'exam_id\': 21, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:39.653065',1),
(642,'SUBJECT_ADDED','{\'exam_id\': 21, \'subject_id\': 24, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:40.031139',1),
(643,'EXAM_CREATED','{\'exam_id\': 22, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:43.950913',1),
(644,'SUBJECT_ADDED','{\'exam_id\': 22, \'subject_id\': 25, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:44.350715',1),
(645,'EXAM_CREATED','{\'exam_id\': 23, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:49.197272',1),
(646,'SUBJECT_ADDED','{\'exam_id\': 23, \'subject_id\': 26, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:26:49.592834',1),
(647,'EXAM_CREATED','{\'exam_id\': 24, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:27:55.647679',1),
(648,'SUBJECT_ADDED','{\'exam_id\': 24, \'subject_id\': 27, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:27:56.010471',1),
(649,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 01:27:56.251136',1),
(650,'EXAM_CREATED','{\'exam_id\': 25, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:29:38.033953',1),
(651,'SUBJECT_ADDED','{\'exam_id\': 25, \'subject_id\': 28, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:29:38.451803',1),
(652,'EXAM_CREATED','{\'exam_id\': 26, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:33:28.367240',1),
(653,'SUBJECT_ADDED','{\'exam_id\': 26, \'subject_id\': 29, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:33:28.758101',1),
(654,'EXAM_CREATED','{\'exam_id\': 27, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:34:11.625642',1),
(655,'SUBJECT_ADDED','{\'exam_id\': 27, \'subject_id\': 30, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:34:11.993639',1),
(656,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 01:36:40.742400',1),
(657,'EXAM_CREATED','{\'exam_id\': 28, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:01.552490',1),
(658,'SUBJECT_ADDED','{\'exam_id\': 28, \'subject_id\': 31, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:01.971282',1),
(659,'STUDENT_LIST_UPLOADED','{\'exam_id\': 28, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:02.380758',1),
(660,'EXAM_CREATED','{\'exam_id\': 29, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:34.711943',1),
(661,'SUBJECT_ADDED','{\'exam_id\': 29, \'subject_id\': 32, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:35.111863',1),
(662,'STUDENT_LIST_UPLOADED','{\'exam_id\': 29, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:53:35.532674',1),
(663,'EXAM_CREATED','{\'exam_id\': 30, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:58:50.173639',1),
(664,'SUBJECT_ADDED','{\'exam_id\': 30, \'subject_id\': 33, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:58:50.553246',1),
(665,'STUDENT_LIST_UPLOADED','{\'exam_id\': 30, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 01:58:50.965176',1),
(666,'EXAM_CREATED','{\'exam_id\': 31, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:02:55.112798',1),
(667,'SUBJECT_ADDED','{\'exam_id\': 31, \'subject_id\': 34, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:02:55.512162',1),
(668,'STUDENT_LIST_UPLOADED','{\'exam_id\': 31, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:02:55.905149',1),
(669,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:03:48.941953',1),
(670,'login','Successful login from 10.189.145.57','10.189.145.57','2026-02-12 02:05:13.469683',1),
(671,'EXAM_CREATED','{\'exam_id\': 32, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:05:33.072282',1),
(672,'SUBJECT_ADDED','{\'exam_id\': 32, \'subject_id\': 35, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:05:33.470573',1),
(673,'STUDENT_LIST_UPLOADED','{\'exam_id\': 32, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:05:33.866929',1),
(674,'EXAM_CREATED','{\'exam_id\': 33, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:12:42.835058',1),
(675,'SUBJECT_ADDED','{\'exam_id\': 33, \'subject_id\': 36, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:12:43.218541',1),
(676,'STUDENT_LIST_UPLOADED','{\'exam_id\': 33, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:12:43.654603',1),
(677,'HALL_TICKETS_GENERATED','{\'exam_id\': 33, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:23:46.970756',1),
(678,'EXAM_CREATED','{\'exam_id\': 34, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:24:36.751459',1),
(679,'SUBJECT_ADDED','{\'exam_id\': 34, \'subject_id\': 37, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:24:37.132118',1),
(680,'STUDENT_LIST_UPLOADED','{\'exam_id\': 34, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:24:37.525785',1),
(681,'EXAM_CREATED','{\'exam_id\': 35, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:25:04.477827',1),
(682,'SUBJECT_ADDED','{\'exam_id\': 35, \'subject_id\': 38, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:25:04.893909',1),
(683,'STUDENT_LIST_UPLOADED','{\'exam_id\': 35, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:25:05.627579',1),
(684,'EXAM_CREATED','{\'exam_id\': 36, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:40:57.359327',1),
(685,'SUBJECT_ADDED','{\'exam_id\': 36, \'subject_id\': 39, \'subject_code\': \'c101\', \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:40:57.772640',1),
(686,'STUDENT_LIST_UPLOADED','{\'exam_id\': 36, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.145.57\'}','10.189.145.57','2026-02-12 02:40:58.495732',1),
(687,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:53:07.420318',1),
(688,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:53:16.859275',1),
(689,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:54:21.287115',1),
(690,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:54:29.593683',1),
(691,'HALL_TICKETS_GENERATED','{\'exam_id\': 36, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:54:29.612605',1),
(692,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:54:38.036026',1),
(693,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:54:48.037393',1),
(694,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:55:30.568064',1),
(695,'EXAM_CREATED','{\'exam_id\': 37, \'exam_name\': \'Test ZIP Download Exam\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:55:31.042375',1),
(696,'SUBJECT_ADDED','{\'exam_id\': 37, \'subject_id\': 40, \'subject_code\': \'CS101\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:55:31.083519',1),
(697,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:56:15.397871',1),
(698,'STUDENT_LIST_UPLOADED','{\'exam_id\': 37, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:56:15.429296',1),
(699,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:56:15.450149',1),
(700,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:57:40.424898',1),
(701,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:57:40.864575',1),
(702,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 02:58:58.136485',1),
(703,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 02:58:58.573624',1),
(704,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:35:34.526636',1),
(705,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:35:34.545410',1),
(706,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:36:41.584613',1),
(707,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 0, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:36:41.613700',1),
(708,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:38:28.736595',1),
(709,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:39:38.384068',1),
(710,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:41:18.710770',1),
(711,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:42:16.017502',1),
(712,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:43:14.967687',1),
(713,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:48:35.660536',1),
(714,'HALL_TICKETS_GENERATED','{\'exam_id\': 37, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:48:36.126879',1),
(715,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 37, \'exam_name\': \'Test ZIP Download Exam\', \'ticket_count\': 3, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:48:36.204142',1),
(716,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:50:49.831109',1),
(717,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 37, \'exam_name\': \'Test ZIP Download Exam\', \'ticket_count\': 3, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:50:49.871754',1),
(718,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-12 04:55:40.067456',1),
(719,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 37, \'exam_name\': \'Test ZIP Download Exam\', \'ticket_count\': 3, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-12 04:55:40.537063',1),
(720,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 01:50:36.878960',1),
(721,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:02:40.568680',1),
(722,'login','Successful login from 10.189.194.125','10.189.194.125','2026-02-13 02:03:16.850810',1),
(723,'EXAM_CREATED','{\'exam_id\': 38, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:03:51.456452',1),
(724,'SUBJECT_ADDED','{\'exam_id\': 38, \'subject_id\': 41, \'subject_code\': \'c101\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:03:51.876056',1),
(725,'STUDENT_LIST_UPLOADED','{\'exam_id\': 38, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:03:52.357502',1),
(726,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:06:01.846487',1),
(727,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:12:21.026331',1),
(728,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:12:29.698597',1),
(729,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:17:14.047174',1),
(730,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:18:05.787793',1),
(731,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:22:02.250291',1),
(732,'HALL_TICKETS_GENERATED','{\'exam_id\': 38, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 02:22:02.300775',1),
(733,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 02:22:24.265971',1),
(734,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 38, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 02:22:24.749513',1),
(735,'HALL_TICKETS_GENERATED','{\'exam_id\': 38, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:24:23.449528',1),
(736,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 38, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:24:23.696065',1),
(737,'EXAM_DELETED','{\'exam_id\': 38, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:03.984684',1),
(738,'EXAM_DELETED','{\'exam_id\': 37, \'exam_name\': \'Test ZIP Download Exam\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:08.440626',1),
(739,'EXAM_DELETED','{\'exam_id\': 36, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:12.945792',1),
(740,'EXAM_DELETED','{\'exam_id\': 35, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:25.333629',1),
(741,'EXAM_DELETED','{\'exam_id\': 33, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:30.900724',1),
(742,'EXAM_DELETED','{\'exam_id\': 4, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations February 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:36.759745',1),
(743,'EXAM_DELETED','{\'exam_id\': 30, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:42.645907',1),
(744,'HALL_TICKETS_GENERATED','{\'exam_id\': 29, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:44.499297',1),
(745,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 29, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:44.931808',1),
(746,'EXAM_DELETED','{\'exam_id\': 34, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:52.570215',1),
(747,'EXAM_DELETED','{\'exam_id\': 31, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:38:56.286625',1),
(748,'EXAM_DELETED','{\'exam_id\': 29, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:00.776440',1),
(749,'EXAM_DELETED','{\'exam_id\': 32, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:04.689481',1),
(750,'EXAM_DELETED','{\'exam_id\': 28, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:08.777281',1),
(751,'EXAM_DELETED','{\'exam_id\': 27, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:12.063212',1),
(752,'EXAM_DELETED','{\'exam_id\': 26, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:16.254739',1),
(753,'EXAM_DELETED','{\'exam_id\': 25, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:19.298074',1),
(754,'EXAM_DELETED','{\'exam_id\': 24, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:22.514728',1),
(755,'EXAM_DELETED','{\'exam_id\': 23, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:25.720495',1),
(756,'EXAM_DELETED','{\'exam_id\': 22, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:28.955308',1),
(757,'EXAM_DELETED','{\'exam_id\': 21, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:32.535799',1),
(758,'EXAM_DELETED','{\'exam_id\': 20, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:35.755830',1),
(759,'EXAM_DELETED','{\'exam_id\': 19, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:38.794408',1),
(760,'EXAM_DELETED','{\'exam_id\': 18, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:41.894174',1),
(761,'EXAM_DELETED','{\'exam_id\': 17, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:45.093996',1),
(762,'EXAM_DELETED','{\'exam_id\': 16, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:48.311999',1),
(763,'EXAM_DELETED','{\'exam_id\': 15, \'exam_name\': \'Verification Test\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:51.994295',1),
(764,'EXAM_DELETED','{\'exam_id\': 14, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations May 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:39:59.909993',1),
(765,'EXAM_DELETED','{\'exam_id\': 13, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations April 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:03.376016',1),
(766,'EXAM_DELETED','{\'exam_id\': 12, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:06.820606',1),
(767,'EXAM_DELETED','{\'exam_id\': 11, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:09.586465',1),
(768,'EXAM_DELETED','{\'exam_id\': 10, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations March 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:12.634996',1),
(769,'EXAM_DELETED','{\'exam_id\': 9, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:15.614653',1),
(770,'EXAM_DELETED','{\'exam_id\': 8, \'exam_name\': \'Test Exam\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:18.834095',1),
(771,'EXAM_DELETED','{\'exam_id\': 7, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:21.795304',1),
(772,'EXAM_DELETED','{\'exam_id\': 6, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:35.907882',1),
(773,'EXAM_DELETED','{\'exam_id\': 5, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:39.255596',1),
(774,'EXAM_DELETED','{\'exam_id\': 3, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:42.375450',1),
(775,'EXAM_DELETED','{\'exam_id\': 2, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:45.775089',1),
(776,'EXAM_DELETED','{\'exam_id\': 1, \'exam_name\': \'Test Mid-Term Exam February 2024\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:40:49.224048',1),
(777,'login','Successful login from 10.189.194.125','10.189.194.125','2026-02-13 02:52:01.381028',1),
(778,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-13 02:52:11.896461',1),
(779,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-13 02:52:21.995544',1),
(780,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-13 02:53:04.436168',1),
(781,'EXAM_CREATED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:55:38.659395',1),
(782,'SUBJECT_ADDED','{\'exam_id\': 39, \'subject_id\': 42, \'subject_code\': \'c101\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:55:39.084621',1),
(783,'STUDENT_LIST_UPLOADED','{\'exam_id\': 39, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:55:39.513584',1),
(784,'HALL_TICKETS_GENERATED','{\'exam_id\': 39, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:55:42.181059',1),
(785,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 02:55:42.618392',1),
(786,'login','Successful login from 10.189.194.125','10.189.194.125','2026-02-13 03:10:39.824407',1),
(787,'HALL_TICKETS_GENERATED','{\'exam_id\': 39, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:10:50.941970',1),
(788,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:10:51.236073',1),
(789,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-13 03:27:19.281913',1),
(790,'EXAM_CREATED','{\'exam_id\': 40, \'exam_name\': \'Test\', \'ip\': \'10.88.0.1\'}','10.88.0.1','2026-02-13 03:27:19.299457',1),
(791,'login','Successful login from 10.88.0.1','10.88.0.1','2026-02-13 03:38:02.626149',1),
(792,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-13 03:42:38.364214',1),
(793,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-13 03:42:49.271437',1),
(794,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-13 03:42:59.670610',1),
(795,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-13 03:48:48.408296',1),
(796,'EXAM_CREATED','{\'exam_id\': 41, \'exam_name\': \'Test Exam IT\', \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-13 03:49:06.334977',1),
(797,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-13 03:49:23.655991',1),
(798,'HALL_TICKETS_GENERATED','{\'exam_id\': 39, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:52:33.732620',1),
(799,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:52:33.940298',1),
(800,'EXAM_DELETED','{\'exam_id\': 41, \'exam_name\': \'Test Exam IT\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:57:52.981355',1),
(801,'EXAM_DELETED','{\'exam_id\': 40, \'exam_name\': \'Test\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:58:19.798934',1),
(802,'EXAM_DELETED','{\'exam_id\': 39, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.194.125\'}','10.189.194.125','2026-02-13 03:58:23.764260',1),
(803,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 15:11:04.125112',1),
(804,'EXAM_CREATED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:13:05.069791',1),
(805,'SUBJECT_ADDED','{\'exam_id\': 42, \'subject_id\': 43, \'subject_code\': \'CS101\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:13:20.478766',1),
(806,'SUBJECT_ADDED','{\'exam_id\': 42, \'subject_id\': 44, \'subject_code\': \'MA101\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:13:29.688269',1),
(807,'STUDENT_LIST_UPLOADED','{\'exam_id\': 42, \'created_count\': 2, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:13:55.978230',1),
(808,'HALL_TICKETS_GENERATED','{\'exam_id\': 42, \'generated_count\': 2, \'skipped_count\': 0, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:14:09.484456',1),
(809,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:14:27.210678',1),
(810,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:19:20.456523',1),
(811,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:19:42.017543',1),
(812,'login','Successful login from 10.189.160.47','10.189.160.47','2026-02-13 15:25:56.505467',1),
(813,'HALL_TICKETS_GENERATED','{\'exam_id\': 42, \'generated_count\': 0, \'skipped_count\': 2, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:26:27.668293',1),
(814,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:26:28.151544',1),
(815,'EXAM_CREATED','{\'exam_id\': 43, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:36.298330',1),
(816,'SUBJECT_ADDED','{\'exam_id\': 43, \'subject_id\': 45, \'subject_code\': \'C1\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:36.673768',1),
(817,'SUBJECT_ADDED','{\'exam_id\': 43, \'subject_id\': 46, \'subject_code\': \'C2\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:37.302425',1),
(818,'SUBJECT_ADDED','{\'exam_id\': 43, \'subject_id\': 47, \'subject_code\': \'C3\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:37.615980',1),
(819,'SUBJECT_ADDED','{\'exam_id\': 43, \'subject_id\': 48, \'subject_code\': \'C4\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:37.814237',1),
(820,'STUDENT_LIST_UPLOADED','{\'exam_id\': 43, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:38.262594',1),
(821,'HALL_TICKETS_GENERATED','{\'exam_id\': 43, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:50.637050',1),
(822,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 43, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:31:51.164860',1),
(823,'SUBJECT_ADDED','{\'exam_id\': 42, \'subject_id\': 49, \'subject_code\': \'CS102\', \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:42:27.587050',1),
(824,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:42:38.022683',1),
(825,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 2, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 15:46:14.327329',1),
(826,'EXAM_DELETED','{\'exam_id\': 43, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:49:24.537962',1),
(827,'EXAM_DELETED','{\'exam_id\': 42, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:49:28.123904',1),
(828,'EXAM_CREATED','{\'exam_id\': 44, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:41.306749',1),
(829,'SUBJECT_ADDED','{\'exam_id\': 44, \'subject_id\': 50, \'subject_code\': \'c1\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:41.721893',1),
(830,'SUBJECT_ADDED','{\'exam_id\': 44, \'subject_id\': 51, \'subject_code\': \'c2\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:43.008484',1),
(831,'STUDENT_LIST_UPLOADED','{\'exam_id\': 44, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:43.600535',1),
(832,'HALL_TICKETS_GENERATED','{\'exam_id\': 44, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:46.139508',1),
(833,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 44, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 15:50:46.664759',1),
(834,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-13 16:01:47.290161',1),
(835,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 44, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.127.248.83\'}','10.127.248.83','2026-02-13 16:02:07.244309',1),
(836,'EXAM_DELETED','{\'exam_id\': 44, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:04:40.210853',1),
(837,'EXAM_CREATED','{\'exam_id\': 45, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:31.832098',1),
(838,'SUBJECT_ADDED','{\'exam_id\': 45, \'subject_id\': 52, \'subject_code\': \'c1\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:33.058072',1),
(839,'SUBJECT_ADDED','{\'exam_id\': 45, \'subject_id\': 53, \'subject_code\': \'c2\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:33.280069',1),
(840,'STUDENT_LIST_UPLOADED','{\'exam_id\': 45, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:33.742179',1),
(841,'HALL_TICKETS_GENERATED','{\'exam_id\': 45, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:36.377775',1),
(842,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 45, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:05:36.842168',1),
(843,'EXAM_DELETED','{\'exam_id\': 45, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:06:17.225965',1),
(844,'EXAM_CREATED','{\'exam_id\': 46, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:04.041619',1),
(845,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 54, \'subject_code\': \'c1\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:04.565722',1),
(846,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 55, \'subject_code\': \'c2\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:04.824918',1),
(847,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 56, \'subject_code\': \'c3\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:05.042412',1),
(848,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 57, \'subject_code\': \'c4\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:05.260972',1),
(849,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 58, \'subject_code\': \'c5\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:05.478386',1),
(850,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 59, \'subject_code\': \'c6\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:05.770677',1),
(851,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 60, \'subject_code\': \'c7\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:05.979826',1),
(852,'SUBJECT_ADDED','{\'exam_id\': 46, \'subject_id\': 61, \'subject_code\': \'c8\', \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:06.239763',1),
(853,'STUDENT_LIST_UPLOADED','{\'exam_id\': 46, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:06.667281',1),
(854,'HALL_TICKETS_GENERATED','{\'exam_id\': 46, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:09.344244',1),
(855,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 46, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.160.47\'}','10.189.160.47','2026-02-13 16:08:09.788909',1),
(856,'login','Successful login from 10.189.136.151','10.189.136.151','2026-02-14 02:08:32.529763',1),
(857,'EXAM_DELETED','{\'exam_id\': 46, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:08:39.669752',1),
(858,'EXAM_CREATED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:25.374139',1),
(859,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 62, \'subject_code\': \'c1\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:25.834632',1),
(860,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 63, \'subject_code\': \'c2\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:26.013106',1),
(861,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 64, \'subject_code\': \'c3\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:26.288391',1),
(862,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 65, \'subject_code\': \'c4\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:26.467391',1),
(863,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 66, \'subject_code\': \'c5\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:26.674819',1),
(864,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 67, \'subject_code\': \'c6\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:26.941088',1),
(865,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 68, \'subject_code\': \'c7\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:27.111056',1),
(866,'SUBJECT_ADDED','{\'exam_id\': 47, \'subject_id\': 69, \'subject_code\': \'c8\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:27.310914',1),
(867,'STUDENT_LIST_UPLOADED','{\'exam_id\': 47, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:27.750063',1),
(868,'HALL_TICKETS_GENERATED','{\'exam_id\': 47, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:31.594637',1),
(869,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:11:31.977905',1),
(870,'EXAM_CREATED','{\'exam_id\': 48, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:26:25.952236',1),
(871,'SUBJECT_ADDED','{\'exam_id\': 48, \'subject_id\': 70, \'subject_code\': \'c1\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:26:27.366385',1),
(872,'SUBJECT_ADDED','{\'exam_id\': 48, \'subject_id\': 71, \'subject_code\': \'c2\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:26:27.575311',1),
(873,'STUDENT_LIST_UPLOADED','{\'exam_id\': 48, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:26:28.004159',1),
(874,'HALL_TICKETS_GENERATED','{\'exam_id\': 47, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:34:51.718734',1),
(875,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:34:51.940022',1),
(876,'EXAM_CREATED','{\'exam_id\': 49, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations January 2026\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:44:31.930961',1),
(877,'SUBJECT_ADDED','{\'exam_id\': 49, \'subject_id\': 72, \'subject_code\': \'123456\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:44:32.616359',1),
(878,'STUDENT_LIST_UPLOADED','{\'exam_id\': 49, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:44:34.139972',1),
(879,'HALL_TICKETS_GENERATED','{\'exam_id\': 47, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:58:09.034192',1),
(880,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:58:09.315306',1),
(881,'EXAM_CREATED','{\'exam_id\': 50, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:59:28.095511',1),
(882,'SUBJECT_ADDED','{\'exam_id\': 50, \'subject_id\': 73, \'subject_code\': \'c1\', \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:59:28.557188',1),
(883,'STUDENT_LIST_UPLOADED','{\'exam_id\': 50, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.136.151\'}','10.189.136.151','2026-02-14 02:59:29.029424',1),
(884,'login','Successful login from 10.189.137.194','10.189.137.194','2026-02-14 03:12:40.792705',1),
(885,'EXAM_CREATED','{\'exam_id\': 51, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:27:01.303795',1),
(886,'SUBJECT_ADDED','{\'exam_id\': 51, \'subject_id\': 74, \'subject_code\': \'10000000\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:27:01.754484',1),
(887,'STUDENT_LIST_UPLOADED','{\'exam_id\': 51, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:27:03.156019',1),
(888,'EXAM_DELETED','{\'exam_id\': 51, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:48:45.687102',1),
(889,'EXAM_DELETED','{\'exam_id\': 50, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:48:50.104423',1),
(890,'EXAM_DELETED','{\'exam_id\': 49, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:48:53.936455',1),
(891,'EXAM_DELETED','{\'exam_id\': 48, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:48:57.585715',1),
(892,'HALL_TICKETS_GENERATED','{\'exam_id\': 47, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:49:00.261650',1),
(893,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:49:00.718316',1),
(894,'EXAM_CREATED','{\'exam_id\': 52, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:49:59.179398',1),
(895,'SUBJECT_ADDED','{\'exam_id\': 52, \'subject_id\': 75, \'subject_code\': \'c1\', \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:49:59.596034',1),
(896,'STUDENT_LIST_UPLOADED','{\'exam_id\': 52, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.137.194\'}','10.189.137.194','2026-02-14 03:50:00.430443',1),
(897,'login','Successful login from 10.189.139.207','10.189.139.207','2026-02-14 04:45:34.686596',1),
(898,'EXAM_DELETED','{\'exam_id\': 52, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:45:53.755870',1),
(899,'EXAM_DELETED','{\'exam_id\': 47, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:46:37.737882',1),
(900,'EXAM_CREATED','{\'exam_id\': 53, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:47:16.802933',1),
(901,'SUBJECT_ADDED','{\'exam_id\': 53, \'subject_id\': 76, \'subject_code\': \'c1\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:47:17.250596',1),
(902,'STUDENT_LIST_UPLOADED','{\'exam_id\': 53, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:47:17.762544',1),
(903,'HALL_TICKETS_GENERATED','{\'exam_id\': 53, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:47:20.086693',1),
(904,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 53, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:47:20.632682',1),
(905,'EXAM_CREATED','{\'exam_id\': 54, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:13.608016',1),
(906,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 77, \'subject_code\': \'c1\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:14.292216',1),
(907,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 78, \'subject_code\': \'c2\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:14.707381',1),
(908,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 79, \'subject_code\': \'c3\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:15.112444',1),
(909,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 80, \'subject_code\': \'c4\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:15.432361',1),
(910,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 81, \'subject_code\': \'c5\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:15.830586',1),
(911,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 82, \'subject_code\': \'c6\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:16.139792',1),
(912,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 83, \'subject_code\': \'c7\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:16.463292',1),
(913,'SUBJECT_ADDED','{\'exam_id\': 54, \'subject_id\': 84, \'subject_code\': \'c8\', \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:16.692683',1),
(914,'STUDENT_LIST_UPLOADED','{\'exam_id\': 54, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 04:51:17.156859',1),
(915,'HALL_TICKETS_GENERATED','{\'exam_id\': 54, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 05:00:47.489457',1),
(916,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 54, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.139.207\'}','10.189.139.207','2026-02-14 05:00:48.817473',1),
(917,'login','Successful login from 10.189.135.215','10.189.135.215','2026-02-14 16:24:50.001337',1),
(918,'EXAM_DELETED','{\'exam_id\': 54, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:24:56.372392',1),
(919,'EXAM_DELETED','{\'exam_id\': 53, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:24:59.574247',1),
(920,'EXAM_CREATED','{\'exam_id\': 55, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:25:52.712549',1),
(921,'SUBJECT_ADDED','{\'exam_id\': 55, \'subject_id\': 85, \'subject_code\': \'c1\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:25:53.139067',1),
(922,'STUDENT_LIST_UPLOADED','{\'exam_id\': 55, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:25:53.604733',1),
(923,'HALL_TICKETS_GENERATED','{\'exam_id\': 55, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:25:56.065733',1),
(924,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 55, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:25:56.507739',1),
(925,'HALL_TICKETS_GENERATED','{\'exam_id\': 55, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:37:03.925743',1),
(926,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 55, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:37:05.147242',1),
(927,'EXAM_CREATED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:36.860495',1),
(928,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 86, \'subject_code\': \'c1\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:37.264958',1),
(929,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 87, \'subject_code\': \'C2\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:38.487072',1),
(930,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 88, \'subject_code\': \'c3\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:39.514669',1),
(931,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 89, \'subject_code\': \'c4\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:39.813265',1),
(932,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 90, \'subject_code\': \'c5\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:40.038686',1),
(933,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 91, \'subject_code\': \'c6\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:40.252100',1),
(934,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 92, \'subject_code\': \'c7\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:40.437874',1),
(935,'SUBJECT_ADDED','{\'exam_id\': 56, \'subject_id\': 93, \'subject_code\': \'c8\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:40.639140',1),
(936,'STUDENT_LIST_UPLOADED','{\'exam_id\': 56, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:41.156694',1),
(937,'HALL_TICKETS_GENERATED','{\'exam_id\': 56, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:43.539724',1),
(938,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:39:44.074149',1),
(939,'HALL_TICKETS_GENERATED','{\'exam_id\': 56, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:51:51.813688',1),
(940,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 16:51:52.133895',1),
(941,'HALL_TICKETS_GENERATED','{\'exam_id\': 56, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:00:21.107923',1),
(942,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:00:22.426003',1),
(943,'EXAM_CREATED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:39.830165',1),
(944,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 94, \'subject_code\': \'s1\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:40.252172',1),
(945,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 95, \'subject_code\': \'c2\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:41.489593',1),
(946,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 96, \'subject_code\': \'c3\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:42.649672',1),
(947,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 97, \'subject_code\': \'c4\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:43.008571',1),
(948,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 98, \'subject_code\': \'c5\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:43.232578',1),
(949,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 99, \'subject_code\': \'c6\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:43.460093',1),
(950,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 100, \'subject_code\': \'c7\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:43.664579',1),
(951,'SUBJECT_ADDED','{\'exam_id\': 57, \'subject_id\': 101, \'subject_code\': \'c8\', \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:43.874554',1),
(952,'STUDENT_LIST_UPLOADED','{\'exam_id\': 57, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:44.268772',1),
(953,'HALL_TICKETS_GENERATED','{\'exam_id\': 57, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:47.535473',1),
(954,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:02:47.990579',1),
(955,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:11:17.588786',1),
(956,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:11:28.348816',1),
(957,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:11:41.909078',1),
(958,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-14 17:11:41.974083',1),
(959,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:12:24.250398',1),
(960,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:12:34.356564',1),
(961,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-14 17:12:34.430444',1),
(962,'HALL_TICKETS_GENERATED','{\'exam_id\': 57, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:15:29.136492',1),
(963,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:15:29.471564',1),
(964,'HALL_TICKETS_GENERATED','{\'exam_id\': 57, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:23:46.869010',1),
(965,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:23:48.188750',1),
(966,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:33:01.616441',1),
(967,'login','Successful login from 10.189.135.215','10.189.135.215','2026-02-14 17:33:52.645812',1),
(968,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:34:15.820592',1),
(969,'login','Successful login from 10.189.135.215','10.189.135.215','2026-02-14 17:34:24.499229',1),
(970,'HALL_TICKETS_GENERATED','{\'exam_id\': 57, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:34:32.699352',1),
(971,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ticket_count\': 3, \'ip\': \'10.189.135.215\'}','10.189.135.215','2026-02-14 17:34:32.951067',1),
(972,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-14 17:35:12.227390',1),
(973,'login','Successful login from 10.189.135.215','10.189.135.215','2026-02-14 17:56:09.466589',1),
(974,'login','Successful login from 10.189.137.196','10.189.137.196','2026-02-16 01:49:40.054606',1),
(975,'login','Successful login from 10.189.137.196','10.189.137.196','2026-02-16 02:10:51.651407',1),
(976,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-16 02:16:04.575344',1),
(977,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-16 02:17:20.638035',1),
(978,'login','Successful login from 127.0.0.1','127.0.0.1','2026-02-16 02:18:49.738351',1),
(979,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 02:27:56.428575',1),
(980,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 02:49:17.184977',1),
(981,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 02:53:03.858842',1),
(982,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 02:57:49.261699',1),
(983,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 03:21:28.322812',1),
(984,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 03:21:42.647935',1),
(985,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 03:23:31.849881',1),
(986,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 03:37:10.455334',1),
(987,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-16 03:39:19.342256',1),
(988,'login','Successful login from 10.127.248.83','10.127.248.83','2026-02-16 03:47:52.760525',1),
(989,'login','Successful login from 10.189.137.196','10.189.137.196','2026-02-16 03:54:13.971639',1),
(990,'login','Successful login from 10.189.137.196','10.189.137.196','2026-02-16 03:58:33.465183',1),
(991,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 12:39:51.818756',1),
(992,'EXAM_CREATED','{\'exam_id\': 58, \'exam_name\': \'IV Year B.Tech II Semester Regular/Supplementary Examinations March 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:41:28.919600',1),
(993,'SUBJECT_ADDED','{\'exam_id\': 58, \'subject_id\': 102, \'subject_code\': \'123\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:41:29.324792',1),
(994,'STUDENT_LIST_UPLOADED','{\'exam_id\': 58, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:41:29.761045',1),
(995,'HALL_TICKETS_GENERATED','{\'exam_id\': 58, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:41:32.782375',1),
(996,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 58, \'exam_name\': \'IV Year B.Tech II Semester Regular/Supplementary Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:41:33.236964',1),
(997,'HALL_TICKETS_GENERATED','{\'exam_id\': 58, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:43:02.652381',1),
(998,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 58, \'exam_name\': \'IV Year B.Tech II Semester Regular/Supplementary Examinations March 2026\', \'ticket_count\': 3, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:43:02.884966',1),
(999,'HALL_TICKETS_GENERATED','{\'exam_id\': 58, \'generated_count\': 0, \'skipped_count\': 3, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:43:06.963540',1),
(1000,'EXAM_DELETED','{\'exam_id\': 57, \'exam_name\': \'III Year B.Tech II Semester Regular Examinations October 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 12:43:49.449256',1),
(1001,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 14:11:11.259055',1),
(1002,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 14:51:52.676587',1),
(1003,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 14:52:20.117282',3),
(1004,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:52:20.548195',3),
(1005,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:52:20.756358',3),
(1006,'circular_created','Created circular: leave','10.189.174.185','2026-02-23 14:53:15.063324',1),
(1007,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:53:20.380702',3),
(1008,'circular_deleted','Deleted circular: leave','10.189.174.185','2026-02-23 14:53:30.741636',1),
(1009,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-23 14:58:29.888928',1),
(1010,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-23 14:58:48.975609',1),
(1011,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:58:53.390359',3),
(1012,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:58:53.632504',3),
(1013,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-23 14:58:57.131200',1),
(1014,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:59:12.851546',3),
(1015,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 14:59:13.113528',3),
(1016,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:00:12.900133',3),
(1017,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:01:12.885702',3),
(1018,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:02:12.987806',3),
(1019,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:03:12.987729',3),
(1020,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:03:51.484768',3),
(1021,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:03:51.763990',3),
(1022,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:04:51.895773',3),
(1023,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:05:51.955058',3),
(1024,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:06:51.968783',3),
(1025,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:07:51.963015',3),
(1026,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:08:51.896942',3),
(1027,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-23 15:13:46.840785',1),
(1028,'HALL_TICKET_DOWNLOADED','{\'ticket_id\': 64, \'hall_ticket_number\': \'55-20211A0101\', \'ip\': \'10.89.0.1\'}','10.89.0.1','2026-02-23 15:13:46.948348',1),
(1029,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:19:17.160678',1),
(1030,'EXAM_DELETED','{\'exam_id\': 58, \'exam_name\': \'IV Year B.Tech II Semester Regular/Supplementary Examinations March 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 15:20:00.416556',1),
(1031,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-23 15:20:54.543260',1),
(1032,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:28:34.281091',3),
(1033,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:28:35.749445',3),
(1034,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:28:35.993653',3),
(1035,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:29:34.591445',3),
(1036,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:30:27.375161',3),
(1037,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:30:27.653798',3),
(1038,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:31:26.926199',3),
(1039,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:32:26.916251',3),
(1040,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:36:15.328577',1),
(1041,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:36:49.484977',3),
(1042,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:36:49.747301',3),
(1043,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:36:49.999447',3),
(1044,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:37:49.947355',3),
(1045,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:38:49.905565',3),
(1046,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:39:49.936609',3),
(1047,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:40:49.898888',3),
(1048,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:41:49.915067',3),
(1049,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:42:49.912487',3),
(1050,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:51:52.127378',1),
(1051,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 15:52:03.426720',3),
(1052,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:52:03.666215',3),
(1053,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:52:03.871188',3),
(1054,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:53:03.941707',3),
(1055,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:54:03.930341',3),
(1056,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:55:03.920954',3),
(1057,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:56:04.064239',3),
(1058,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:57:03.945806',3),
(1059,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:58:03.931038',3),
(1060,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:59:30.916101',3),
(1061,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:59:57.302068',3),
(1062,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 15:59:57.544168',3),
(1063,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:00:13.133909',3),
(1064,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:00:13.625773',3),
(1065,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:00:13.860853',3),
(1066,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:00:57.962059',3),
(1067,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:01:13.926272',3),
(1068,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:01:57.966603',3),
(1069,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:02:13.926782',3),
(1070,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:02:57.936283',3),
(1071,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:03:13.917282',3),
(1072,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:03:57.934501',3),
(1073,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:04:13.916749',3),
(1074,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:04:58.036359',3),
(1075,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:05:57.963877',3),
(1076,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:07:30.946091',3),
(1077,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:08:31.924967',3),
(1078,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:09:32.914710',3),
(1079,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:10:33.944773',3),
(1080,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:11:34.923483',3),
(1081,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:12:35.957264',3),
(1082,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:13:24.744357',3),
(1083,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:13:25.030085',3),
(1084,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:13:36.946442',3),
(1085,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:14:24.959886',3),
(1086,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:14:38.138977',3),
(1087,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:15:18.564325',3),
(1088,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:15:18.775004',3),
(1089,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:15:38.936033',3),
(1090,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:16:18.926089',3),
(1091,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:16:40.009361',3),
(1092,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:17:18.944758',3),
(1093,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:17:40.967266',3),
(1094,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:18:18.912672',3),
(1095,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:18:41.923988',3),
(1096,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:19:18.925401',3),
(1097,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:19:35.199861',3),
(1098,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:29:34.822977',3),
(1099,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:29:35.024164',3),
(1100,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:30:25.820272',3),
(1101,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:30:26.102584',3),
(1102,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:30:42.068480',3),
(1103,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:30:47.288985',3),
(1104,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:30:47.519444',3),
(1105,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:30:52.325134',3),
(1106,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 16:31:05.827168',3),
(1107,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:31:08.505435',3),
(1108,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:31:47.277751',3),
(1109,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:32:47.957129',3),
(1110,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:33:47.933951',3),
(1111,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:34:47.965149',3),
(1112,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:35:47.938905',3),
(1113,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:36:47.938338',3),
(1114,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:36:52.412696',3),
(1115,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:36:52.628228',3),
(1116,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:36:58.915259',3),
(1117,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:37:17.501171',3),
(1118,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:18.004799',3),
(1119,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:18.209501',3),
(1120,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 16:37:27.985541',3),
(1121,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:37:30.540288',3),
(1122,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:37.431370',3),
(1123,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:37.646447',3),
(1124,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:37:46.387358',3),
(1125,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:51.707155',3),
(1126,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:51.904586',3),
(1127,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:52.946813',3),
(1128,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:54.770598',3),
(1129,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:37:54.965371',3),
(1130,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:38:00.555506',3),
(1131,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:09.048228',3),
(1132,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:09.258977',3),
(1133,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:38:23.949137',3),
(1134,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:24.206752',3),
(1135,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:24.481429',3),
(1136,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:30.983849',3),
(1137,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:31.225790',3),
(1138,'logout','Logout from 10.189.174.185','10.189.174.185','2026-02-23 16:38:40.087343',3),
(1139,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:38:47.758249',3),
(1140,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:47.983680',3),
(1141,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:38:48.195323',3),
(1142,'logout','Logout from 10.189.174.185','10.189.174.185','2026-02-23 16:38:54.665155',3),
(1143,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:39:00.193904',3),
(1144,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:39:00.446050',3),
(1145,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:39:00.665048',3),
(1146,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:39:47.995651',3),
(1147,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 16:39:53.240851',3),
(1148,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 16:39:57.280510',3),
(1149,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:01.005754',3),
(1150,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:29.465581',3),
(1151,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:29.666945',3),
(1152,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:35.804258',3),
(1153,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:36.026144',3),
(1154,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:39.561114',3),
(1155,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:40:39.785855',3),
(1156,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:41:00.948051',3),
(1157,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:41:40.012980',3),
(1158,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:42:00.996291',3),
(1159,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:42:39.946185',3),
(1160,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:43:00.936922',3),
(1161,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:48:01.263064',3),
(1162,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:48:01.522462',3),
(1163,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:48:01.771395',3),
(1164,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 16:48:15.515361',3),
(1165,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:48:15.825065',3),
(1166,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:48:16.070852',3),
(1167,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:49:02.003546',3),
(1168,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:49:16.020041',3),
(1169,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:50:02.080684',3),
(1170,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:50:15.982562',3),
(1171,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:51:01.978915',3),
(1172,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:51:16.058935',3),
(1173,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:52:02.004840',3),
(1174,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:52:08.979503',3),
(1175,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:52:09.232038',3),
(1176,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:02.276912',3),
(1177,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:09.106301',3),
(1178,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:30.027503',3),
(1179,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:30.202456',3),
(1180,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:30.341190',3),
(1181,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:30.488816',3),
(1182,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:31.071953',3),
(1183,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:31.072638',3),
(1184,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:31.375176',3),
(1185,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:38.048747',3),
(1186,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:38.390416',3),
(1187,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:38.982569',3),
(1188,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:39.205170',3),
(1189,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:53:46.565504',3),
(1190,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:54:40.031862',3),
(1191,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:54:40.031948',3),
(1192,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:55:39.940304',3),
(1193,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 16:55:39.949003',3),
(1194,'profile_updated','Student updated profile: test123','10.89.0.1','2026-02-23 17:04:07.087166',2),
(1195,'PHOTO_UPLOADED','{\'roll_number\': \'test123\', \'ip\': \'10.89.0.1\'}','10.89.0.1','2026-02-23 17:04:42.744548',2),
(1196,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 17:06:33.017583',3),
(1197,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:06:33.293940',3),
(1198,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:06:33.510697',3),
(1199,'PHOTO_UPDATED','{\'roll_number\': \'2271010\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:06:45.723663',3),
(1200,'profile_updated','Student updated profile: 2271010','10.189.174.185','2026-02-23 17:07:02.347279',3),
(1201,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:07:34.010196',3),
(1202,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 17:07:35.507428',1),
(1203,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:08:34.019573',3),
(1204,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:09:33.966269',3),
(1205,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:10:33.999664',3),
(1206,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:11:33.998955',3),
(1207,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:12:33.950274',3),
(1208,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:13:33.964456',3),
(1209,'EXAM_CREATED','{\'exam_id\': 59, \'exam_name\': \'II Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:13:44.341004',1),
(1210,'SUBJECT_ADDED','{\'exam_id\': 59, \'subject_id\': 103, \'subject_code\': \'101\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:13:44.779291',1),
(1211,'STUDENT_LIST_UPLOADED','{\'exam_id\': 59, \'created_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:13:45.262691',1),
(1212,'HALL_TICKETS_GENERATED','{\'exam_id\': 59, \'generated_count\': 3, \'skipped_count\': 0, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:13:48.865141',1),
(1213,'BULK_HALL_TICKETS_DOWNLOADED','{\'exam_id\': 59, \'exam_name\': \'II Year B.Tech I Semester Regular Examinations January 2026\', \'ticket_count\': 3, \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:13:49.428494',1),
(1214,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:14:46.019836',3),
(1215,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:15:47.089573',3),
(1216,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:16:48.056452',3),
(1217,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:17:49.030253',3),
(1218,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:18:49.981089',3),
(1219,'EXAM_DELETED','{\'exam_id\': 59, \'exam_name\': \'II Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:20:27.522533',1),
(1220,'EXAM_DELETED','{\'exam_id\': 56, \'exam_name\': \'I Year B.Tech II Semester Regular Examinations March 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:20:30.844766',1),
(1221,'EXAM_DELETED','{\'exam_id\': 55, \'exam_name\': \'I Year B.Tech I Semester Regular Examinations January 2026\', \'ip\': \'10.189.174.185\'}','10.189.174.185','2026-02-23 17:20:33.822369',1),
(1222,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:20:33.966451',3),
(1223,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:21:51.161055',3),
(1224,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:22:50.990292',3),
(1225,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:23:51.006066',3),
(1226,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:24:50.964340',3),
(1227,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:25:50.966509',3),
(1228,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:26:50.965969',3),
(1229,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:27:50.977717',3),
(1230,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:28:51.016978',3),
(1231,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:29:51.126397',3),
(1232,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:30:51.067944',3),
(1233,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:31:51.131613',3),
(1234,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:32:51.089031',3),
(1235,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:33:52.103766',3),
(1236,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:34:52.228834',3),
(1237,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:35:51.091150',3),
(1238,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:36:51.036530',3),
(1239,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:37:51.036676',3),
(1240,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:38:51.085459',3),
(1241,'consolidated_result_view','Viewed consolidated results: 3 year/semester groups','10.189.174.185','2026-02-23 17:39:51.029311',3),
(1242,'login','Successful login from 10.189.174.185','10.189.174.185','2026-02-23 17:47:07.177009',1),
(1243,'login','Successful login from 10.189.153.61','10.189.153.61','2026-02-24 01:57:11.924957',1),
(1244,'login','Successful login from 10.189.173.79','10.189.173.79','2026-02-24 15:10:45.278166',1),
(1245,'HALL_TICKETS_GENERATED','test','127.0.0.1','2026-02-24 15:41:15.111416',1),
(1246,'HALL_TICKETS_GENERATED','{\'exam_id\': 60, \'generated_count\': 0, \'ip\': \'127.0.0.1\'}','127.0.0.1','2026-02-24 15:41:51.613214',1),
(1247,'result_upload','Uploaded results: 1 created, 0 updated, Branches: [\'cse\']','10.189.173.79','2026-02-24 15:47:38.172008',1),
(1248,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-24 15:54:02.548265',1),
(1249,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-24 15:54:18.284492',1),
(1250,'login','Successful login from 10.89.0.1','10.89.0.1','2026-02-24 15:54:31.384617',1),
(1251,'result_upload','Uploaded results: 1 created, 0 updated, Branches: [\'cse\']','10.89.0.1','2026-02-24 15:54:31.488175',1);
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',2,'add_permission'),
(6,'Can change permission',2,'change_permission'),
(7,'Can delete permission',2,'delete_permission'),
(8,'Can view permission',2,'view_permission'),
(9,'Can add group',3,'add_group'),
(10,'Can change group',3,'change_group'),
(11,'Can delete group',3,'delete_group'),
(12,'Can view group',3,'view_group'),
(13,'Can add content type',4,'add_contenttype'),
(14,'Can change content type',4,'change_contenttype'),
(15,'Can delete content type',4,'delete_contenttype'),
(16,'Can view content type',4,'view_contenttype'),
(17,'Can add session',5,'add_session'),
(18,'Can change session',5,'change_session'),
(19,'Can delete session',5,'delete_session'),
(20,'Can view session',5,'view_session'),
(21,'Can add blacklisted token',6,'add_blacklistedtoken'),
(22,'Can change blacklisted token',6,'change_blacklistedtoken'),
(23,'Can delete blacklisted token',6,'delete_blacklistedtoken'),
(24,'Can view blacklisted token',6,'view_blacklistedtoken'),
(25,'Can add outstanding token',7,'add_outstandingtoken'),
(26,'Can change outstanding token',7,'change_outstandingtoken'),
(27,'Can delete outstanding token',7,'delete_outstandingtoken'),
(28,'Can view outstanding token',7,'view_outstandingtoken'),
(29,'Can add user',8,'add_user'),
(30,'Can change user',8,'change_user'),
(31,'Can delete user',8,'delete_user'),
(32,'Can view user',8,'view_user'),
(33,'Can add result',9,'add_result'),
(34,'Can change result',9,'change_result'),
(35,'Can delete result',9,'delete_result'),
(36,'Can view result',9,'view_result'),
(37,'Can add notification',10,'add_notification'),
(38,'Can change notification',10,'change_notification'),
(39,'Can delete notification',10,'delete_notification'),
(40,'Can view notification',10,'view_notification'),
(41,'Can add login attempt',11,'add_loginattempt'),
(42,'Can change login attempt',11,'change_loginattempt'),
(43,'Can delete login attempt',11,'delete_loginattempt'),
(44,'Can view login attempt',11,'view_loginattempt'),
(45,'Can add audit log',12,'add_auditlog'),
(46,'Can change audit log',12,'change_auditlog'),
(47,'Can delete audit log',12,'delete_auditlog'),
(48,'Can view audit log',12,'view_auditlog'),
(49,'Can add subject',13,'add_subject'),
(50,'Can change subject',13,'change_subject'),
(51,'Can delete subject',13,'delete_subject'),
(52,'Can view subject',13,'view_subject'),
(53,'Can add blacklisted token',14,'add_blacklistedtoken'),
(54,'Can change blacklisted token',14,'change_blacklistedtoken'),
(55,'Can delete blacklisted token',14,'delete_blacklistedtoken'),
(56,'Can view blacklisted token',14,'view_blacklistedtoken'),
(57,'Can add circular',15,'add_circular'),
(58,'Can change circular',15,'change_circular'),
(59,'Can delete circular',15,'delete_circular'),
(60,'Can view circular',15,'view_circular'),
(61,'Can add exam',16,'add_exam'),
(62,'Can change exam',16,'change_exam'),
(63,'Can delete exam',16,'delete_exam'),
(64,'Can view exam',16,'view_exam'),
(65,'Can add exam enrollment',17,'add_examenrollment'),
(66,'Can change exam enrollment',17,'change_examenrollment'),
(67,'Can delete exam enrollment',17,'delete_examenrollment'),
(68,'Can view exam enrollment',17,'view_examenrollment'),
(69,'Can add student photo',18,'add_studentphoto'),
(70,'Can change student photo',18,'change_studentphoto'),
(71,'Can delete student photo',18,'delete_studentphoto'),
(72,'Can view student photo',18,'view_studentphoto'),
(73,'Can add hall ticket',19,'add_hallticket'),
(74,'Can change hall ticket',19,'change_hallticket'),
(75,'Can delete hall ticket',19,'delete_hallticket'),
(76,'Can view hall ticket',19,'view_hallticket'),
(77,'Can add exam subject',20,'add_examsubject'),
(78,'Can change exam subject',20,'change_examsubject'),
(79,'Can delete exam subject',20,'delete_examsubject'),
(80,'Can view exam subject',20,'view_examsubject');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blacklisted_tokens`
--

DROP TABLE IF EXISTS `blacklisted_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blacklisted_tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `blacklisted_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`) USING HASH,
  KEY `blacklisted_tokens_user_id_ed5237da_fk_users_id` (`user_id`),
  KEY `blacklisted_token_d070ae_idx` (`token`(768)),
  KEY `blacklisted_blackli_bd04a9_idx` (`blacklisted_at`),
  CONSTRAINT `blacklisted_tokens_user_id_ed5237da_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blacklisted_tokens`
--

LOCK TABLES `blacklisted_tokens` WRITE;
/*!40000 ALTER TABLE `blacklisted_tokens` DISABLE KEYS */;
INSERT INTO `blacklisted_tokens` VALUES
(1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg5MjYwNSwiaWF0IjoxNzcwODA2MjA1LCJqdGkiOiIzOTI4YjZkMjc2NjQ0N2M5OTExMjc5NzkzOTRkY2JhZSIsInVzZXJfaWQiOjN9.QNa0GtWPG9q_oE88Pe4yqW1bVqpMD4JRT9juMFj4EY8','2026-02-11 11:07:19.426817',3),
(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcwODA5ODA1LCJpYXQiOjE3NzA4MDYyMDUsImp0aSI6Ijg3YjFmODQ2N2FhNzRhNDRiYTlhNjJjODU1MGVlN2VhIiwidXNlcl9pZCI6M30.f6dkxRuVTNBlT2IwuAEUstVXfGNTRhY9hq8FkUuV7V0','2026-02-11 11:07:19.429117',3),
(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTEwMywiaWF0IjoxNzcxODY0NzAzLCJqdGkiOiI4MzBlZjk5NTNiOTU0ODkwOGZjNmRmYzFmZmE5MDY0MiIsInVzZXJfaWQiOjN9.bexoBZGPTr5CwZijfXDRIAcMJgC_JeZHOh3ibCFqaHo','2026-02-23 16:38:40.083742',3),
(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcxODY4MzAzLCJpYXQiOjE3NzE4NjQ3MDMsImp0aSI6ImUwOGFhNTBiNWE2NDRjOWVhZGI0MTM4MzVlOWFjYTYxIiwidXNlcl9pZCI6M30.jSz3bD6VG9JGx975r-6hJZKQSxrACWT2ZeMGaXLQNIQ','2026-02-23 16:38:40.085912',3),
(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTAzNywiaWF0IjoxNzcxODY0NjM3LCJqdGkiOiJjYmRiMTBiOTAzNzE0Y2E5YjliMzFhMzQ0MWI0Njg0MiIsInVzZXJfaWQiOjN9.x82OGCTnC6QLAoMWwd3CWQHt9aMfYWmRAdH29ZFUihw','2026-02-23 16:38:54.661524',3),
(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcxODY4MjM3LCJpYXQiOjE3NzE4NjQ2MzcsImp0aSI6Ijk3NDRjNTBhZWM4NjQ0NjM4MjBkZDlmNDE1ZDI4MjZmIiwidXNlcl9pZCI6M30.07DjG6zD5TnWk36YMsL59AqWqYUwfUjoRaV2akVo5IQ','2026-02-23 16:38:54.663548',3);
/*!40000 ALTER TABLE `blacklisted_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circulars`
--

DROP TABLE IF EXISTS `circulars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `circulars` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(300) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `attachment_name` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `target_year` int(11) DEFAULT NULL,
  `target_branch` varchar(50) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `circulars_created_by_id_aeb43ac6_fk_users_id` (`created_by_id`),
  KEY `circulars_created_3f7483_idx` (`created_at` DESC,`is_active`),
  KEY `circulars_categor_25fad8_idx` (`category`,`is_active`),
  CONSTRAINT `circulars_created_by_id_aeb43ac6_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circulars`
--

LOCK TABLES `circulars` WRITE;
/*!40000 ALTER TABLE `circulars` DISABLE KEYS */;
/*!40000 ALTER TABLE `circulars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES
(1,'admin','logentry'),
(3,'auth','group'),
(2,'auth','permission'),
(4,'contenttypes','contenttype'),
(12,'results','auditlog'),
(14,'results','blacklistedtoken'),
(15,'results','circular'),
(16,'results','exam'),
(17,'results','examenrollment'),
(20,'results','examsubject'),
(19,'results','hallticket'),
(11,'results','loginattempt'),
(10,'results','notification'),
(9,'results','result'),
(18,'results','studentphoto'),
(13,'results','subject'),
(8,'results','user'),
(5,'sessions','session'),
(6,'token_blacklist','blacklistedtoken'),
(7,'token_blacklist','outstandingtoken');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES
(1,'contenttypes','0001_initial','2026-02-10 09:00:15.736943'),
(2,'contenttypes','0002_remove_content_type_name','2026-02-10 09:00:16.042041'),
(3,'auth','0001_initial','2026-02-10 09:00:17.316354'),
(4,'auth','0002_alter_permission_name_max_length','2026-02-10 09:00:17.497563'),
(5,'auth','0003_alter_user_email_max_length','2026-02-10 09:00:17.503875'),
(6,'auth','0004_alter_user_username_opts','2026-02-10 09:00:17.511718'),
(7,'auth','0005_alter_user_last_login_null','2026-02-10 09:00:17.515705'),
(8,'auth','0006_require_contenttypes_0002','2026-02-10 09:00:17.518537'),
(9,'auth','0007_alter_validators_add_error_messages','2026-02-10 09:00:17.523300'),
(10,'auth','0008_alter_user_username_max_length','2026-02-10 09:00:17.528465'),
(11,'auth','0009_alter_user_last_name_max_length','2026-02-10 09:00:17.533245'),
(12,'auth','0010_alter_group_name_max_length','2026-02-10 09:00:17.601465'),
(13,'auth','0011_update_proxy_permissions','2026-02-10 09:00:17.608069'),
(14,'auth','0012_alter_user_first_name_max_length','2026-02-10 09:00:17.624443'),
(15,'results','0001_initial','2026-02-10 09:00:20.125452'),
(16,'admin','0001_initial','2026-02-10 09:00:20.341591'),
(17,'admin','0002_logentry_remove_auto_add','2026-02-10 09:00:20.353177'),
(18,'admin','0003_logentry_add_action_flag_choices','2026-02-10 09:00:20.368615'),
(19,'results','0002_remove_result_results_roll_nu_3f83e5_idx_and_more','2026-02-10 09:00:20.994876'),
(20,'results','0003_user_failed_login_attempts_user_locked_until_and_more','2026-02-10 09:00:21.836326'),
(21,'results','0004_notification_exam_name_notification_result_and_more','2026-02-10 09:00:22.235514'),
(22,'results','0005_result_course','2026-02-10 09:00:22.418861'),
(23,'results','0006_result_branch','2026-02-10 09:00:22.573340'),
(24,'results','0007_subject_attempts','2026-02-10 09:00:22.684005'),
(25,'results','0008_result_percentage','2026-02-10 09:00:22.763155'),
(26,'results','0009_user_branch_user_can_manage_users_and_more','2026-02-10 09:00:23.291396'),
(27,'results','0010_user_can_delete_results_user_can_upload_results_and_more','2026-02-10 09:00:23.673320'),
(28,'results','0011_fix_student_null_constraint','2026-02-10 09:00:23.964903'),
(29,'results','0012_result_completion_date','2026-02-10 09:00:24.028040'),
(30,'results','0013_alter_result_unique_together_and_more','2026-02-10 09:00:24.227957'),
(31,'sessions','0001_initial','2026-02-10 09:00:24.329882'),
(32,'token_blacklist','0001_initial','2026-02-10 09:00:24.602078'),
(33,'token_blacklist','0002_outstandingtoken_jti_hex','2026-02-10 09:00:24.673231'),
(34,'token_blacklist','0003_auto_20171017_2007','2026-02-10 09:00:24.694240'),
(35,'token_blacklist','0004_auto_20171017_2013','2026-02-10 09:00:24.841951'),
(36,'token_blacklist','0005_remove_outstandingtoken_jti','2026-02-10 09:00:24.903261'),
(37,'token_blacklist','0006_auto_20171017_2113','2026-02-10 09:00:24.947624'),
(38,'token_blacklist','0007_auto_20171017_2214','2026-02-10 09:00:25.229255'),
(39,'token_blacklist','0008_migrate_to_bigautofield','2026-02-10 09:00:25.708303'),
(40,'token_blacklist','0010_fix_migrate_to_bigautofield','2026-02-10 09:00:25.725169'),
(41,'token_blacklist','0011_linearizes_history','2026-02-10 09:00:25.726972'),
(42,'token_blacklist','0012_alter_outstandingtoken_user','2026-02-10 09:00:25.755486'),
(43,'results','0014_update_for_credits_and_sgpa','2026-02-10 17:15:41.309917'),
(44,'results','0015_circular','2026-02-11 00:41:43.897069'),
(45,'results','0015_exam_examenrollment_studentphoto_circular_hallticket_and_more','2026-02-11 07:36:47.807901'),
(46,'results','0016_alter_examsubject_exam_date','2026-02-11 16:18:58.909979'),
(47,'results','0017_alter_examsubject_options_alter_hallticket_options_and_more','2026-02-16 02:54:17.986681');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall_ticket_enrollments`
--

DROP TABLE IF EXISTS `hall_ticket_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hall_ticket_enrollments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `roll_number` varchar(50) NOT NULL,
  `student_name` varchar(200) NOT NULL,
  `branch` varchar(100) DEFAULT '',
  `enrolled_at` datetime(6) NOT NULL,
  `enrolled_by_id` bigint(20) DEFAULT NULL,
  `exam_id` bigint(20) NOT NULL,
  `student_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hall_ticket_enrollments_exam_id_b0d2520b` (`exam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_enrollments`
--

LOCK TABLES `hall_ticket_enrollments` WRITE;
/*!40000 ALTER TABLE `hall_ticket_enrollments` DISABLE KEYS */;
INSERT INTO `hall_ticket_enrollments` VALUES
(92,'TEST001','Test Student','','2026-02-24 15:41:39.176539',NULL,60,NULL);
/*!40000 ALTER TABLE `hall_ticket_enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall_ticket_exam_subjects`
--

DROP TABLE IF EXISTS `hall_ticket_exam_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hall_ticket_exam_subjects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(50) NOT NULL,
  `subject_name` varchar(200) NOT NULL,
  `subject_type` varchar(20) DEFAULT 'Theory',
  `exam_date` date DEFAULT NULL,
  `exam_time` time(6) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `order` int(11) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `hall_ticket_exam_subjects_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `hall_ticket_exams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_exam_subjects`
--

LOCK TABLES `hall_ticket_exam_subjects` WRITE;
/*!40000 ALTER TABLE `hall_ticket_exam_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `hall_ticket_exam_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall_ticket_exams`
--

DROP TABLE IF EXISTS `hall_ticket_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hall_ticket_exams` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `exam_name` varchar(300) NOT NULL,
  `year` varchar(10) NOT NULL,
  `semester` varchar(10) NOT NULL,
  `course` varchar(50) NOT NULL DEFAULT 'B.Tech',
  `branch` varchar(100) DEFAULT '',
  `exam_center` varchar(200) NOT NULL,
  `exam_start_time` time DEFAULT '09:00:00' COMMENT 'Exam start time',
  `exam_end_time` time DEFAULT '12:00:00' COMMENT 'Exam end time',
  `instructions` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_exams`
--

LOCK TABLES `hall_ticket_exams` WRITE;
/*!40000 ALTER TABLE `hall_ticket_exams` DISABLE KEYS */;
INSERT INTO `hall_ticket_exams` VALUES
(60,'Test Exam 2026','I','I','B.Tech','CSE','Main Campus','09:00:00','12:00:00','',1,'2026-02-24 15:41:27.023420','2026-02-24 15:41:27.023447',1),
(61,'Test Exam No Time','I','I','B.Tech','CSE','Main Campus',NULL,NULL,'',1,'2026-02-24 15:42:50.972734','2026-02-24 15:42:50.972766',1);
/*!40000 ALTER TABLE `hall_ticket_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall_ticket_student_photos`
--

DROP TABLE IF EXISTS `hall_ticket_student_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hall_ticket_student_photos` (
  `student_id` bigint(20) NOT NULL,
  `roll_number` varchar(50) NOT NULL,
  `photo` varchar(100) NOT NULL,
  `consent_given` tinyint(1) NOT NULL,
  `consent_text` longtext NOT NULL,
  `consent_date` datetime(6) DEFAULT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `roll_number` (`roll_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_student_photos`
--

LOCK TABLES `hall_ticket_student_photos` WRITE;
/*!40000 ALTER TABLE `hall_ticket_student_photos` DISABLE KEYS */;
INSERT INTO `hall_ticket_student_photos` VALUES
(2,'test123','hall_ticket_photos/test.png',1,'I hereby give consent to use my photograph for hall ticket generation.','2026-02-23 17:04:42.736313','2026-02-23 17:04:42.743272','2026-02-23 17:04:42.743285'),
(3,'2271010','hall_ticket_photos/iCE-bot.png',1,'I hereby give consent to use my photograph for hall ticket generation.','2026-02-23 17:06:45.719269','2026-02-11 09:45:33.074046','2026-02-23 17:06:45.721523');
/*!40000 ALTER TABLE `hall_ticket_student_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall_tickets`
--

DROP TABLE IF EXISTS `hall_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hall_tickets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hall_ticket_number` varchar(50) NOT NULL,
  `pdf_file` varchar(100) DEFAULT NULL,
  `qr_code_data` varchar(500) NOT NULL,
  `status` varchar(20) NOT NULL,
  `download_count` int(11) NOT NULL,
  `generated_at` datetime(6) NOT NULL,
  `downloaded_at` datetime(6) DEFAULT NULL,
  `enrollment_id` bigint(20) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  `generated_by_id` bigint(20) DEFAULT NULL,
  `student_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hall_ticket_number` (`hall_ticket_number`),
  KEY `enrollment_id` (`enrollment_id`),
  KEY `exam_id` (`exam_id`),
  KEY `generated_by_id` (`generated_by_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `hall_tickets_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `hall_ticket_enrollments` (`id`),
  CONSTRAINT `hall_tickets_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `hall_ticket_exams` (`id`),
  CONSTRAINT `hall_tickets_ibfk_3` FOREIGN KEY (`generated_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `hall_tickets_ibfk_4` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_tickets`
--

LOCK TABLES `hall_tickets` WRITE;
/*!40000 ALTER TABLE `hall_tickets` DISABLE KEYS */;
INSERT INTO `hall_tickets` VALUES
(79,'60-TEST001','','SPVMM:HT:60-TEST001:TEST001:Test Exam 2026','generated',0,'2026-02-24 15:41:39.180922',NULL,92,60,1,NULL);
/*!40000 ALTER TABLE `hall_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `ip_address` char(39) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_attem_usernam_ece61f_idx` (`username`,`timestamp`),
  KEY `login_attem_ip_addr_340a7c_idx` (`ip_address`,`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES
(5,'admin','10.189.158.139','2026-02-10 09:20:00.564276',1),
(6,'admin','10.189.219.158','2026-02-10 12:37:11.239186',1),
(7,'admin','10.189.219.158','2026-02-10 13:06:03.827022',1),
(8,'test123','10.189.219.158','2026-02-10 13:11:34.736671',1),
(9,'admin','10.189.219.158','2026-02-10 13:22:51.294848',1),
(10,'test123','10.189.219.158','2026-02-10 14:12:12.816652',1),
(11,'admin','10.189.219.158','2026-02-10 14:57:24.876985',1),
(12,'test123','10.189.219.158','2026-02-10 15:12:49.351706',1),
(13,'admin','10.189.219.158','2026-02-10 16:07:54.179987',1),
(14,'admin','10.189.219.158','2026-02-10 16:27:40.604014',1),
(15,'admin','10.189.219.158','2026-02-10 16:38:37.639543',1),
(17,'admin','10.189.219.158','2026-02-10 17:23:13.346520',1),
(31,'admin','10.189.219.158','2026-02-10 18:01:58.584941',1),
(32,'2271010','10.189.219.158','2026-02-10 18:12:28.831875',1),
(33,'2271010','10.189.219.158','2026-02-10 18:50:14.354119',1),
(35,'admin','10.189.219.158','2026-02-11 00:17:08.720149',1),
(36,'2271010','10.189.219.158','2026-02-11 00:17:33.404942',1),
(38,'admin','10.189.219.158','2026-02-11 00:30:42.876114',1),
(39,'2271010','10.189.219.158','2026-02-11 00:33:09.437187',1),
(41,'2271010','10.189.219.158','2026-02-11 00:43:36.335219',1),
(42,'admin','10.189.219.158','2026-02-11 00:44:41.190440',1),
(43,'admin','10.189.219.158','2026-02-11 00:52:24.212829',1),
(44,'2271010','10.189.219.158','2026-02-11 00:54:04.431706',1),
(45,'TEST001','10.89.0.1','2026-02-11 01:01:22.107336',0),
(46,'TEST001','10.89.0.1','2026-02-11 01:01:31.533608',0),
(47,'TEST001','10.89.0.1','2026-02-11 01:02:25.304136',0),
(48,'TEST001','10.89.0.1','2026-02-11 01:05:04.950834',0),
(49,'TEST001','10.89.0.1','2026-02-11 01:06:20.026407',0),
(57,'admin','10.89.0.1','2026-02-11 01:10:19.133353',1),
(60,'2271010','10.89.0.1','2026-02-11 01:13:31.362934',1),
(61,'admin','10.189.219.158','2026-02-11 01:18:25.980637',1),
(66,'2271010','10.189.219.158','2026-02-11 01:20:53.616699',1),
(67,'2271010','10.189.219.158','2026-02-11 01:28:50.731798',1),
(68,'admin','10.189.219.158','2026-02-11 01:54:17.955439',1),
(74,'2271010','10.189.219.158','2026-02-11 02:04:15.584358',1),
(76,'admin','10.189.219.158','2026-02-11 02:06:02.670227',1),
(77,'2271010','10.189.219.158','2026-02-11 02:12:52.911243',1),
(78,'2271010','10.89.0.1','2026-02-11 02:18:15.278172',1),
(79,'admin','10.189.219.158','2026-02-11 02:18:22.362793',1),
(80,'2271010','10.189.219.158','2026-02-11 02:39:09.743752',1),
(81,'admin','10.189.219.158','2026-02-11 02:39:54.355214',1),
(83,'admin','10.189.219.158','2026-02-11 07:45:34.104631',1),
(84,'2271010','10.189.219.158','2026-02-11 07:48:43.205709',1),
(85,'admin','10.189.219.158','2026-02-11 08:48:43.684363',1),
(86,'admin','10.189.219.158','2026-02-11 09:04:35.341559',1),
(87,'test','10.89.0.1','2026-02-11 09:04:44.155777',0),
(88,'2271010','10.189.219.158','2026-02-11 09:32:21.895684',1),
(89,'admin','10.189.219.158','2026-02-11 10:16:45.397070',1),
(90,'2271010','10.189.219.158','2026-02-11 10:36:45.624574',1),
(91,'2271010','10.189.219.158','2026-02-11 11:16:11.179789',1),
(92,'test123','10.127.248.83','2026-02-11 11:48:38.132278',0),
(94,'test123','10.88.0.1','2026-02-11 12:39:21.087860',0),
(95,'test123','10.88.0.1','2026-02-11 12:39:31.071176',0),
(96,'2271010','10.88.0.1','2026-02-11 12:40:02.791711',0),
(100,'admin','10.127.248.83','2026-02-11 12:43:27.990062',1),
(102,'admin','10.189.219.158','2026-02-11 16:06:46.257960',1),
(114,'admin','10.88.0.1','2026-02-11 16:46:13.995798',1),
(115,'admin','10.88.0.1','2026-02-11 16:52:04.673911',1),
(126,'admin','10.127.248.83','2026-02-11 17:09:02.619301',1),
(127,'admin','10.189.145.57','2026-02-12 01:18:20.939533',1),
(129,'admin','10.127.248.83','2026-02-12 01:27:56.249457',1),
(130,'admin','10.127.248.83','2026-02-12 01:36:40.723838',1),
(132,'admin','10.189.145.57','2026-02-12 02:05:13.464483',1),
(142,'admin','10.127.248.83','2026-02-12 02:58:58.118729',1),
(149,'admin','10.127.248.83','2026-02-12 04:43:14.951254',1),
(152,'admin','10.127.248.83','2026-02-12 04:55:40.049328',1),
(153,'admin','10.127.248.83','2026-02-13 01:50:36.874929',1),
(156,'admin','10.127.248.83','2026-02-13 02:06:01.834501',1),
(162,'admin','10.127.248.83','2026-02-13 02:22:24.236714',1),
(166,'admin','10.88.0.1','2026-02-13 02:53:04.416401',1),
(167,'admin','10.189.194.125','2026-02-13 03:10:39.791282',1),
(168,'admin','10.88.0.1','2026-02-13 03:27:19.269416',1),
(170,'admin','127.0.0.1','2026-02-13 03:42:59.664070',1),
(171,'admin','127.0.0.1','2026-02-13 03:48:48.397195',1),
(172,'admin','10.127.248.83','2026-02-13 15:11:04.090050',1),
(173,'admin','10.189.160.47','2026-02-13 15:25:56.491584',1),
(174,'admin','10.127.248.83','2026-02-13 16:01:47.182163',1),
(175,'admin','10.189.136.151','2026-02-14 02:08:32.507579',1),
(176,'admin','10.189.137.194','2026-02-14 03:12:40.649785',1),
(177,'admin','10.189.139.207','2026-02-14 04:45:34.629683',1),
(178,'admin','10.189.135.215','2026-02-14 16:24:49.992957',1),
(184,'admin','127.0.0.1','2026-02-14 17:12:34.336109',1),
(191,'admin','127.0.0.1','2026-02-14 17:35:12.214143',1),
(192,'admin','10.189.135.215','2026-02-14 17:56:09.462753',1),
(193,'admin','10.189.137.196','2026-02-16 01:49:39.966971',1),
(194,'admin','10.189.137.196','2026-02-16 02:10:51.606582',1),
(197,'admin','127.0.0.1','2026-02-16 02:18:49.720268',1),
(198,'admin','10.89.0.1','2026-02-16 02:27:56.401564',1),
(201,'admin','10.89.0.1','2026-02-16 02:57:49.259569',1),
(204,'admin','10.89.0.1','2026-02-16 03:23:31.848034',1),
(206,'admin','10.89.0.1','2026-02-16 03:39:19.315520',1),
(207,'admin','10.127.248.83','2026-02-16 03:47:52.748749',1),
(209,'admin','10.189.137.196','2026-02-16 03:58:33.397615',1),
(210,'admin','10.189.174.185','2026-02-23 12:39:51.803455',1),
(211,'admin','10.189.174.185','2026-02-23 14:11:11.255510',1),
(212,'admin','10.189.174.185','2026-02-23 14:51:52.671670',1),
(213,'2271010','10.189.174.185','2026-02-23 14:52:20.065605',1),
(216,'admin','10.89.0.1','2026-02-23 14:58:57.125778',1),
(217,'admin','10.89.0.1','2026-02-23 15:13:46.824104',1),
(219,'admin','10.89.0.1','2026-02-23 15:20:54.531894',1),
(220,'2271010','10.189.174.185','2026-02-23 15:28:34.183152',1),
(221,'admin','10.189.174.185','2026-02-23 15:36:15.323440',1),
(222,'2271010','10.189.174.185','2026-02-23 15:36:49.481841',1),
(223,'admin','10.189.174.185','2026-02-23 15:51:52.123910',1),
(224,'2271010','10.189.174.185','2026-02-23 15:52:03.419825',1),
(225,'2271010','10.189.174.185','2026-02-23 16:00:13.124429',1),
(226,'2271010','10.89.0.1','2026-02-23 16:15:26.309771',0),
(230,'2271010','10.189.174.185','2026-02-23 16:39:00.192183',1),
(233,'2271010','10.189.174.185','2026-02-23 16:48:15.513608',1),
(234,'test123','10.89.0.1','2026-02-23 17:03:42.560565',0),
(235,'test123','10.89.0.1','2026-02-23 17:03:49.785621',0),
(236,'2271010','10.189.174.185','2026-02-23 17:06:33.014940',1),
(238,'admin','10.189.174.185','2026-02-23 17:07:35.500050',1),
(239,'admin','10.189.174.185','2026-02-23 17:47:07.160399',1),
(240,'admin','10.189.153.61','2026-02-24 01:57:11.921609',1),
(241,'admin','10.189.173.79','2026-02-24 15:10:45.242559',1),
(244,'admin','10.89.0.1','2026-02-24 15:54:31.382174',1);
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `student_id` bigint(20) NOT NULL,
  `exam_name` varchar(300) NOT NULL,
  `result_id` bigint(20) DEFAULT NULL,
  `results_published_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notificatio_student_c24e79_idx` (`student_id`,`is_read`,`created_at`),
  KEY `notifications_result_id_a327b8a3_fk_results_id` (`result_id`),
  CONSTRAINT `notifications_result_id_a327b8a3_fk_results_id` FOREIGN KEY (`result_id`) REFERENCES `results` (`id`),
  CONSTRAINT `notifications_student_id_b0783b27_fk_users_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES
(4,'B.Tech I year II Semester Regular Exam Results December 2022',0,'2026-02-10 18:29:27.917770',3,'B.Tech I year II Semester Regular Exam Results December 2022',30,'2026-02-10'),
(5,'B.Tech II year I Semester Regular Exam Results May 2024',0,'2026-02-11 07:45:54.856537',3,'B.Tech II year I Semester Regular Exam Results May 2024',34,'2026-02-11');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `roll_number` varchar(50) NOT NULL,
  `student_name` varchar(200) NOT NULL,
  `semester` int(11) NOT NULL,
  `result_type` varchar(20) NOT NULL,
  `overall_result` varchar(50) NOT NULL,
  `overall_grade` varchar(10) NOT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `student_id` bigint(20) DEFAULT NULL,
  `uploaded_by_id` bigint(20) DEFAULT NULL,
  `exam_name` varchar(300) NOT NULL,
  `year` int(11) NOT NULL,
  `exam_held_date` date DEFAULT NULL,
  `course` varchar(10) NOT NULL,
  `branch` varchar(50) NOT NULL,
  `completion_date` date DEFAULT NULL,
  `total_marks` int(11) DEFAULT NULL,
  `sgpa` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `results_roll_number_exam_name_ec547c53_uniq` (`roll_number`,`exam_name`),
  KEY `results_uploade_02ae38_idx` (`uploaded_at`),
  KEY `results_uploaded_by_id_754a31c6_fk_users_id` (`uploaded_by_id`),
  KEY `results_roll_number_a5653931` (`roll_number`),
  KEY `results_roll_nu_81cd94_idx` (`roll_number`,`year`,`semester`),
  KEY `results_student_id_d573a18f_fk_users_id` (`student_id`),
  KEY `results_exam_na_181198_idx` (`exam_name`),
  CONSTRAINT `results_student_id_d573a18f_fk_users_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `results_uploaded_by_id_754a31c6_fk_users_id` FOREIGN KEY (`uploaded_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
INSERT INTO `results` VALUES
(20,'TEST001','Test Student One',1,'regular','Pass','','2026-02-10 17:55:37.526879','2026-02-10 17:55:37.533855',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','cse','2026-02-10',440,9.06),
(21,'TEST002','Test Student Two',1,'regular','Fail','','2026-02-10 17:55:37.535981','2026-02-10 17:55:37.538334',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','cse',NULL,390,7.89),
(22,'TEST003','Test Student Three',1,'regular','Pass','','2026-02-10 17:55:37.540833','2026-02-10 17:55:37.544830',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','cse','2026-02-10',300,6.00),
(23,'TEST004','Test Student Four',1,'supplementary','Fail','','2026-02-10 17:55:37.546529','2026-02-10 17:55:37.548848',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','ece',NULL,300,4.39),
(24,'TEST005','Test Student Five',1,'regular','Pass','','2026-02-10 17:55:37.551454','2026-02-10 17:55:37.556570',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','it','2026-02-10',500,10.00),
(25,'TEST006','Test Student Six',1,'regular','Pass','','2026-02-10 17:55:37.558743','2026-02-10 17:55:37.564639',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','cse','2026-02-10',300,6.00),
(26,'2271010','Gowtham',1,'regular','Fail','','2026-02-10 18:03:02.851413','2026-02-10 18:03:02.854471',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results July 2024',1,'2024-07-01','btech','cse',NULL,301,6.75),
(27,'2271011','Mahesh',1,'supplementary','Fail','','2026-02-10 18:03:02.857163','2026-02-10 18:03:03.084947',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results July 2024',1,'2024-07-01','btech','cse',NULL,185,4.75),
(28,'2271012','Mani',1,'regular','Pass','','2026-02-10 18:03:03.087954','2026-02-10 18:03:03.092067',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results July 2024',1,'2024-07-01','btech','cse','2026-02-10',273,7.58),
(29,'2271013','Vendi',1,'regular','Pass','','2026-02-10 18:03:03.094229','2026-02-10 18:03:03.098059',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results July 2024',1,'2024-07-01','btech','cse','2026-02-10',400,10.00),
(30,'2271010','Gowtham',2,'regular','Fail','','2026-02-10 18:29:27.913965','2026-02-10 18:29:27.916490',3,1,'B.Tech I year II Semester Regular Exam Results December 2022',1,'2022-12-01','btech','cse',NULL,301,6.75),
(31,'2271011','Mahesh',2,'supplementary','Fail','','2026-02-10 18:29:27.919417','2026-02-10 18:29:27.924199',NULL,1,'B.Tech I year II Semester Regular Exam Results December 2022',1,'2022-12-01','btech','cse',NULL,185,4.75),
(32,'2271012','Mani',2,'regular','Pass','','2026-02-10 18:29:27.926539','2026-02-10 18:29:27.930534',NULL,1,'B.Tech I year II Semester Regular Exam Results December 2022',1,'2022-12-01','btech','cse','2026-02-10',273,7.58),
(33,'2271013','Vendi',2,'regular','Pass','','2026-02-10 18:29:27.932195','2026-02-10 18:29:27.936770',NULL,1,'B.Tech I year II Semester Regular Exam Results December 2022',1,'2022-12-01','btech','cse','2026-02-10',400,10.00),
(34,'2271010','Seetha',1,'regular','Fail','','2026-02-11 07:45:54.853060','2026-02-11 07:45:54.855444',3,1,'B.Tech II year I Semester Regular Exam Results May 2024',2,'2024-05-01','btech','cse',NULL,301,6.75),
(35,'2271011','Ashika',1,'supplementary','Fail','','2026-02-11 07:45:54.857909','2026-02-11 07:45:54.865883',NULL,1,'B.Tech II year I Semester Regular Exam Results May 2024',2,'2024-05-01','btech','cse',NULL,185,4.75),
(36,'2271012','Srutha Keerthi',1,'regular','Pass','','2026-02-11 07:45:54.868041','2026-02-11 07:45:54.875420',NULL,1,'B.Tech II year I Semester Regular Exam Results May 2024',2,'2024-05-01','btech','cse','2026-02-11',273,7.58),
(37,'2271013','Mythili',1,'regular','Pass','','2026-02-11 07:45:54.876996','2026-02-11 07:45:54.880324',NULL,1,'B.Tech II year I Semester Regular Exam Results May 2024',2,'2024-05-01','btech','cse','2026-02-11',400,10.00),
(38,'2021001','Sample Student',1,'regular','Pass','','2026-02-24 15:47:38.165108','2026-02-24 15:47:38.171418',NULL,1,'B.Tech I year I Semester Regular Exam Results October 2025',1,'2025-10-01','btech','cse','2026-02-24',404,9.06),
(39,'20211A0101','Test Student',1,'regular','Pass','','2026-02-24 15:53:17.732732','2026-02-24 15:53:17.732763',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,NULL,'btech','cse',NULL,90,9.00),
(40,'20211A0199','Test Upload Student',1,'regular','Pass','','2026-02-24 15:54:31.403956','2026-02-24 15:54:31.487436',NULL,1,'B.Tech I year I Semester Regular Exam Results February 2026',1,'2026-02-01','btech','cse','2026-02-24',90,9.00);
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(50) NOT NULL,
  `subject_name` varchar(200) NOT NULL,
  `subject_type` varchar(20) DEFAULT 'Theory',
  `internal_marks` int(11) DEFAULT NULL,
  `external_marks` int(11) DEFAULT NULL,
  `total_marks` int(11) DEFAULT NULL,
  `grade` varchar(10) NOT NULL,
  `result_id` bigint(20) NOT NULL,
  `attempts` int(11) NOT NULL,
  `credits` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subjects_result_id_56492fb3_fk_results_id` (`result_id`),
  KEY `subjects_subject_e16b01_idx` (`subject_code`),
  CONSTRAINT `subjects_result_id_56492fb3_fk_results_id` FOREIGN KEY (`result_id`) REFERENCES `results` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES
(72,'CS101','Data Structures','Theory',19,71,90,'O',20,1,4),
(73,'CS102','Algorithms','Theory',18,72,90,'A',20,1,4),
(74,'CS103','Databases','Theory',17,63,80,'B',20,1,3),
(75,'CS104','OS','Theory',19,71,90,'A',20,1,4),
(76,'CS105','Networks','Theory',18,72,90,'A',20,1,3),
(77,'CS101','Data Structures','Theory',20,70,90,'O',21,1,4),
(78,'CS102','Algorithms','Theory',18,72,90,'A',21,1,4),
(79,'CS103','Databases','Theory',8,22,30,'F',21,1,3),
(80,'CS104','OS','Theory',19,71,90,'A',21,1,4),
(81,'CS105','Networks','Theory',19,71,90,'O',21,1,3),
(82,'CS101','Data Structures','Theory',12,48,60,'D',22,1,4),
(83,'CS102','Algorithms','Theory',13,47,60,'D',22,1,4),
(84,'CS103','Databases','Theory',12,48,60,'D',22,1,3),
(85,'CS104','OS','Theory',12,48,60,'D',22,1,4),
(86,'CS105','Networks','Theory',12,48,60,'D',22,1,3),
(87,'EC101','Signals','Theory',8,22,30,'F',23,1,4),
(88,'EC102','Systems','Theory',9,21,30,'F',23,1,4),
(89,'EC103','Networks','Theory',16,64,80,'B',23,1,3),
(90,'EC104','Microwaves','Theory',14,56,70,'C',23,1,4),
(91,'EC105','Antennas','Theory',18,72,90,'A',23,1,3),
(92,'IT101','Programming','Theory',20,80,100,'O',24,1,4),
(93,'IT102','Web Tech','Theory',20,80,100,'O',24,1,4),
(94,'IT103','DBMS','Theory',20,80,100,'O',24,1,3),
(95,'IT104','Software Eng','Theory',20,80,100,'O',24,1,4),
(96,'IT105','Cloud','Theory',20,80,100,'O',24,1,3),
(97,'CS101','Subject1','Theory',12,48,60,'D',25,1,4),
(98,'CS102','Subject2','Theory',12,48,60,'D',25,1,4),
(99,'CS103','Subject3','Theory',12,48,60,'D',25,1,3),
(100,'CS104','Subject4','Theory',12,48,60,'D',25,1,4),
(101,'CS105','Subject5','Theory',12,48,60,'D',25,1,3),
(102,'C101','C-Language','Theory',20,60,80,'B',26,1,3),
(103,'C102','Data Structures','Theory',15,45,60,'C',26,1,3),
(104,'C103','Python','Theory',25,66,91,'A',26,1,4),
(105,'C103','HTML','Theory',23,47,70,'F',26,1,2),
(106,'C101','C-Language','Theory',10,34,44,'C',27,1,3),
(107,'C102','Data Structures','Theory',20,25,45,'F',27,1,3),
(108,'C103','Python','Theory',14,45,59,'D',27,1,4),
(109,'C103','HTML','Theory',12,25,37,'D',27,1,2),
(110,'C101','C-Language','Theory',11,74,85,'A',28,1,3),
(111,'C102','Data Structures','Theory',23,54,77,'B',28,1,3),
(112,'C103','Python','Theory',25,39,64,'C',28,1,4),
(113,'C103','HTML','Theory',20,27,47,'D',28,1,2),
(114,'C101','C-Language','Theory',30,70,100,'O',29,1,3),
(115,'C102','Data Structures','Theory',30,70,100,'O',29,1,3),
(116,'C103','Python','Theory',30,70,100,'O',29,1,4),
(117,'C103','HTML','Theory',30,70,100,'O',29,1,2),
(118,'C101','C-Language','Theory',20,60,80,'B',30,1,3),
(119,'C102','Data Structures','Theory',15,45,60,'C',30,1,3),
(120,'C103','Python','Theory',25,66,91,'A',30,1,4),
(121,'C104','HTML','Theory',23,47,70,'F',30,1,2),
(122,'C101','C-Language','Theory',10,34,44,'C',31,1,3),
(123,'C102','Data Structures','Theory',20,25,45,'F',31,1,3),
(124,'C103','Python','Theory',14,45,59,'D',31,1,4),
(125,'C104','HTML','Theory',12,25,37,'D',31,1,2),
(126,'C101','C-Language','Theory',11,74,85,'A',32,1,3),
(127,'C102','Data Structures','Theory',23,54,77,'B',32,1,3),
(128,'C103','Python','Theory',25,39,64,'C',32,1,4),
(129,'C104','HTML','Theory',20,27,47,'D',32,1,2),
(130,'C101','C-Language','Theory',30,70,100,'O',33,1,3),
(131,'C102','Data Structures','Theory',30,70,100,'O',33,1,3),
(132,'C103','Python','Theory',30,70,100,'O',33,1,4),
(133,'C104','HTML','Theory',30,70,100,'O',33,1,2),
(134,'C101','C-Language','Theory',20,60,80,'B',34,1,3),
(135,'C102','Data Structures','Theory',15,45,60,'C',34,1,3),
(136,'C103','Python','Theory',25,66,91,'A',34,1,4),
(137,'C104','HTML','Theory',23,47,70,'F',34,1,2),
(138,'C101','C-Language','Theory',10,34,44,'C',35,1,3),
(139,'C102','Data Structures','Theory',20,25,45,'F',35,1,3),
(140,'C103','Python','Theory',14,45,59,'D',35,1,4),
(141,'C104','HTML','Theory',12,25,37,'D',35,1,2),
(142,'C101','C-Language','Theory',11,74,85,'A',36,1,3),
(143,'C102','Data Structures','Theory',23,54,77,'B',36,1,3),
(144,'C103','Python','Theory',25,39,64,'C',36,1,4),
(145,'C104','HTML','Theory',20,27,47,'D',36,1,2),
(146,'C101','C-Language','Theory',30,70,100,'O',37,1,3),
(147,'C102','Data Structures','Theory',30,70,100,'O',37,1,3),
(148,'C103','Python','Theory',30,70,100,'O',37,1,4),
(149,'C104','HTML','Theory',30,70,100,'O',37,1,2),
(150,'CS101','Data Structures','Theory',18,65,83,'A',38,1,4),
(151,'CS102','Algorithms','Theory',20,70,90,'O',38,1,4),
(152,'CS103','Databases','Theory',15,50,65,'B',38,1,3),
(153,'CS104','Operating Systems','Theory',19,68,87,'A',38,1,4),
(154,'CS105','Computer Networks','Theory',17,62,79,'A',38,1,3),
(155,'CS101','Data Structures','Theory',25,65,90,'A',39,1,4),
(156,'CS101','Data Structures','Theory',25,65,90,'A',40,1,4);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

LOCK TABLES `token_blacklist_blacklistedtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `jti` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` (`user_id`),
  CONSTRAINT `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES
(1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgwMDk0NCwiaWF0IjoxNzcwNzE0NTQ0LCJqdGkiOiIxNzk2ZjU5NzVjY2M0NDhhYWMxODhmNjg4ODY3NDI3NiIsInVzZXJfaWQiOjF9._Sp5pw9CV6mu99l3McQKWwkM1-WGdtzAdHf-ehZwKQo','2026-02-10 09:09:04.347341','2026-02-11 09:09:04.000000',1,'1796f5975ccc448aac188f6888674276'),
(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgwMTIzNSwiaWF0IjoxNzcwNzE0ODM1LCJqdGkiOiI0Mzg2ZjI2NjVkZTk0ZTQ2OTg3MTNlNzY1ODM0ZTI3NyIsInVzZXJfaWQiOjF9.AEwfpZMetHHdbK3qXuDFAr1pTJfLcE5PGd4nA33BgW8','2026-02-10 09:13:55.553894','2026-02-11 09:13:55.000000',1,'4386f2665de94e4698713e765834e277'),
(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgwMTUwMiwiaWF0IjoxNzcwNzE1MTAyLCJqdGkiOiJlYmM0ZjdiOTE4NDM0MDFhYTY4NGY3MDgzNmU5NjZlMyIsInVzZXJfaWQiOjF9.h_W4m96cE1Q6zULlLqYEIaI9nC_vE17BEpsz6fIMpH0','2026-02-10 09:18:22.752083','2026-02-11 09:18:22.000000',1,'ebc4f7b91843401aa684f70836e966e3'),
(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgwMTU1NywiaWF0IjoxNzcwNzE1MTU3LCJqdGkiOiIzMzMxYTgzMmNhM2U0OWRjYmMxMzVhZjZiZWZjNzk4ZSIsInVzZXJfaWQiOjF9.fH62e4c3y1s1ogemTwbcTde0Ndqo2Xta3_5ANhcwdqM','2026-02-10 09:19:17.072142','2026-02-11 09:19:17.000000',1,'3331a832ca3e49dcbc135af6befc798e'),
(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgwMTYwMCwiaWF0IjoxNzcwNzE1MjAwLCJqdGkiOiI3N2VhZTQyZWNjZDY0NDhmOTUzOWMxYTI1NDUzMzdhYyIsInVzZXJfaWQiOjF9.IUdwinU1ivoryTM37vaP417I8-ANl5evP-_5lV_8AGM','2026-02-10 09:20:00.566869','2026-02-11 09:20:00.000000',1,'77eae42eccd6448f9539c1a2545337ac'),
(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxMzQzMSwiaWF0IjoxNzcwNzI3MDMxLCJqdGkiOiI3Y2ExNTk4Y2E4OGY0YjcwOGRlNDVhN2I1ZjcxOTIzYyIsInVzZXJfaWQiOjF9.n6RlxcjFQj3i-2Vl7bmIm-gfRS6mSP3xLGB9BYtLclk','2026-02-10 12:37:11.240520','2026-02-11 12:37:11.000000',1,'7ca1598ca88f4b708de45a7b5f71923c'),
(7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxNTE2MywiaWF0IjoxNzcwNzI4NzYzLCJqdGkiOiIzMDUyNDUxMTk3NzA0OGUzOTU4NWJiODliZGIzOGJjZiIsInVzZXJfaWQiOjF9.nAYsqIT3iEaHbnqmfQdIYDTzwUUNo2VSI4bppF09MZk','2026-02-10 13:06:03.828726','2026-02-11 13:06:03.000000',1,'30524511977048e39585bb89bdb38bcf'),
(8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxNTQ5NCwiaWF0IjoxNzcwNzI5MDk0LCJqdGkiOiJhYzVjZjM0ODQ2NjQ0YjEyODhhZjc4NzgyMGIxZWVlZiIsInVzZXJfaWQiOjJ9.IETtR6BZTS6LyX6UDZrR1RRVGEUFPoJaQ1R1nOs3yjw','2026-02-10 13:11:34.737621','2026-02-11 13:11:34.000000',2,'ac5cf34846644b1288af787820b1eeef'),
(9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxNjE3MSwiaWF0IjoxNzcwNzI5NzcxLCJqdGkiOiIyNDM1YTE1OGFhMzM0YTE0ODBmOGE3OWRjMTM5NWNhZCIsInVzZXJfaWQiOjF9.ej0u2cIlCTC4ru39qvZuDLb4CjtJnjFg1JwTv2Jr23A','2026-02-10 13:22:51.296091','2026-02-11 13:22:51.000000',1,'2435a158aa334a1480f8a79dc1395cad'),
(10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxODE2OCwiaWF0IjoxNzcwNzMxNzY4LCJqdGkiOiI5MGM5ZWZiNGU2ODc0NWE4ODhiNGRjNjFkNjk1ZWIwYiIsInVzZXJfaWQiOjJ9.Ch3290aY76_D8Y2ouUTbMWt-JSiAl5YUy_gzgAmASb8','2026-02-10 13:56:08.375363','2026-02-11 13:56:08.000000',2,'90c9efb4e68745a888b4dc61d695eb0b'),
(11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgxOTEzMiwiaWF0IjoxNzcwNzMyNzMyLCJqdGkiOiIxYjI1YmMwZWUyZTA0YzM3YmY4MjFkYTVmNjFhYmNjNyIsInVzZXJfaWQiOjJ9.pHpUTXbQ3YxnqzEJUKlRdusHZdGJTIk7NgW_3mxYxZU','2026-02-10 14:12:12.817686','2026-02-11 14:12:12.000000',2,'1b25bc0ee2e04c37bf821da5f61abcc7'),
(12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgyMTg0NCwiaWF0IjoxNzcwNzM1NDQ0LCJqdGkiOiJlYmEwOGJkMGYxODQ0YzE2OWE3ZWNmZDE1NmRjMTQzNSIsInVzZXJfaWQiOjF9.nc_RWu6_0mtUkY_-5Ylt2wDYHNqs39vOMhfW92UaESI','2026-02-10 14:57:24.877798','2026-02-11 14:57:24.000000',1,'eba08bd0f1844c169a7ecfd156dc1435'),
(13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgyMjc2OSwiaWF0IjoxNzcwNzM2MzY5LCJqdGkiOiIzZjM1YTVhZDUxMzk0NTE5OWFlOTg4NDkzYmY2MzRjOSIsInVzZXJfaWQiOjJ9.uJT8a_Q1h10Of1AfeEfHRMbps_0n1lhAjKW2QXRN3Lc','2026-02-10 15:12:49.353544','2026-02-11 15:12:49.000000',2,'3f35a5ad513945199ae988493bf634c9'),
(14,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgyNjA3NCwiaWF0IjoxNzcwNzM5Njc0LCJqdGkiOiI5ZjhhYTRkNjgxOWU0OGJmYmJlYWE2NGVhZGNmZWY2OSIsInVzZXJfaWQiOjF9.IeEv0Bw2TLnBD8vY9icdsNBSOjc4TzW_n8RfDHcCezw','2026-02-10 16:07:54.181040','2026-02-11 16:07:54.000000',1,'9f8aa4d6819e48bfbbeaa64eadcfef69'),
(15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgyNzI2MCwiaWF0IjoxNzcwNzQwODYwLCJqdGkiOiJiNTA4OTk3ZWUxZDI0YjY5OWQ0ZTkwZDNkZDZkMTA1MSIsInVzZXJfaWQiOjF9.1hNZDiEJUPggsbbqICnfZ2jA8CWhgCmVIqZCNebhqcw','2026-02-10 16:27:40.605006','2026-02-11 16:27:40.000000',1,'b508997ee1d24b699d4e90d3dd6d1051'),
(16,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgyNzkxNywiaWF0IjoxNzcwNzQxNTE3LCJqdGkiOiI3MjIyMDhjOGM5Yjk0ZTA5YjAxYjI3MTk4NzcwNzdhZCIsInVzZXJfaWQiOjF9.PPMbzXncIZf2_gD86LwngUXWveagNYR4ZtuxTwMAK4E','2026-02-10 16:38:37.641021','2026-02-11 16:38:37.000000',1,'722208c8c9b94e09b01b2719877077ad'),
(17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMDI5MywiaWF0IjoxNzcwNzQzODkzLCJqdGkiOiIwY2YxZDU0MjlhODY0NzY0OGUyMDk3ZmQ3MDIzMmFiOCIsInVzZXJfaWQiOjF9.-4HrDhTUOMto0oBdrfMfPOOs4UHQy0cndxUYDZjMNMk','2026-02-10 17:18:13.434254','2026-02-11 17:18:13.000000',1,'0cf1d5429a8647648e2097fd70232ab8'),
(18,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMDU5MywiaWF0IjoxNzcwNzQ0MTkzLCJqdGkiOiI3YjU4YjYwMTdhMDQ0MmE1OWJlMzNmMGZlYjQ1YzU4ZSIsInVzZXJfaWQiOjF9.4qHi45ekyvANR_NzJVfwbF3P6jraQ4NWi8YOza4qmF8','2026-02-10 17:23:13.347897','2026-02-11 17:23:13.000000',1,'7b58b6017a0442a59be33f0feb45c58e'),
(19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMTk0NCwiaWF0IjoxNzcwNzQ1NTQ0LCJqdGkiOiJkNWZhNTlmYzkyMmY0ZGRlYWY4N2MxYzExMTgyZmY2MyIsInVzZXJfaWQiOjF9.2ewF65mQJLsS-k1XPHyRYp_8RNTT_2TGQTgTTPXT4LY','2026-02-10 17:45:44.168626','2026-02-11 17:45:44.000000',1,'d5fa59fc922f4ddeaf87c1c11182ff63'),
(20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMTk4NywiaWF0IjoxNzcwNzQ1NTg3LCJqdGkiOiIwZjExMGM3ZmM3ZmU0MmVhODE2MDg1OTRlMTJjNWZhOCIsInVzZXJfaWQiOjF9.Oybo8D9U3o0mNCEhYlp3IKdo-ocCl7hl55DlJ8tfTUI','2026-02-10 17:46:27.022017','2026-02-11 17:46:27.000000',1,'0f110c7fc7fe42ea81608594e12c5fa8'),
(21,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjE1MCwiaWF0IjoxNzcwNzQ1NzUwLCJqdGkiOiJjYjZhNGYxYzRkMzg0MzMxODM2YTEwZDVmYTZiMmI4NCIsInVzZXJfaWQiOjF9.6TFFpY5UbhsrA-biujHZgQIgk9DK4FIaG_fTObh9weU','2026-02-10 17:49:10.542496','2026-02-11 17:49:10.000000',1,'cb6a4f1c4d384331836a10d5fa6b2b84'),
(22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjIyOSwiaWF0IjoxNzcwNzQ1ODI5LCJqdGkiOiI4OGRiYzFmZDQ2N2Q0MTg3OWU4M2Q0ZTYwNzMxNTAzNCIsInVzZXJfaWQiOjF9.nMPJLjZzfBE6a-WgeBAjf2hsUeNRscbySYe8H32PLPg','2026-02-10 17:50:29.411886','2026-02-11 17:50:29.000000',1,'88dbc1fd467d41879e83d4e607315034'),
(23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjMyNiwiaWF0IjoxNzcwNzQ1OTI2LCJqdGkiOiI0N2RhNGU5YjBlYWI0YjIxODMxOTdhNzVhZDg3NDBkNiIsInVzZXJfaWQiOjF9.QE74ymiqOtfcLhvjCxAoOw--BO7Pf3yGiSGBICYysRM','2026-02-10 17:52:06.631461','2026-02-11 17:52:06.000000',1,'47da4e9b0eab4b2183197a75ad8740d6'),
(24,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjUzNywiaWF0IjoxNzcwNzQ2MTM3LCJqdGkiOiJiZWY4ZjY4MzY2ZTA0N2FiYTEwNGY3NTQxM2Y3MjJiMyIsInVzZXJfaWQiOjF9.6fX5usP0xocagW9JSQVbrHY8Hdg3Q8zEZzLVeCx7x50','2026-02-10 17:55:37.472133','2026-02-11 17:55:37.000000',1,'bef8f68366e047aba104f75413f722b3'),
(25,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjYwNiwiaWF0IjoxNzcwNzQ2MjA2LCJqdGkiOiI4ZjE0ZDVlYTNlNjY0OTAxODVjYjgwZTRjMTdmM2M4YiIsInVzZXJfaWQiOjF9.NSsdfCBQvXXKY1pvYbWfODA41Mh-fgsWCEHMgIUrmtM','2026-02-10 17:56:46.774065','2026-02-11 17:56:46.000000',1,'8f14d5ea3e66490185cb80e4c17f3c8b'),
(26,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjY5NCwiaWF0IjoxNzcwNzQ2Mjk0LCJqdGkiOiIyNjIwNmVmM2MzMTI0ZmUyOWY1OWQzNWE2ODgxMjYzYSIsInVzZXJfaWQiOjF9.BeGHi-cHSYrkX5jfkGJfp4xraKLa6HllB9lV_bBGiG0','2026-02-10 17:58:14.212979','2026-02-11 17:58:14.000000',1,'26206ef3c3124fe29f59d35a6881263a'),
(27,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjcwNywiaWF0IjoxNzcwNzQ2MzA3LCJqdGkiOiIyOGM1ZTEwZWU1MjU0NDE3YThkMjEzOWYyOTlmNDhiMiIsInVzZXJfaWQiOjF9.q62lLXsrzGQhsMhn-WMM2VcNSAuVCpkgDKRMgLKRCLI','2026-02-10 17:58:27.723352','2026-02-11 17:58:27.000000',1,'28c5e10ee5254417a8d2139f299f48b2'),
(28,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjgwOSwiaWF0IjoxNzcwNzQ2NDA5LCJqdGkiOiIyYWM2YTQ1MWJlNTc0YjhjOGZhZjE4MDVmN2UxZGEzOSIsInVzZXJfaWQiOjF9.ci0lDs6huODYBP8dnE2y05NjWT8TJUcJC20NVeNrWMk','2026-02-10 18:00:09.547676','2026-02-11 18:00:09.000000',1,'2ac6a451be574b8c8faf1805f7e1da39'),
(29,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjgyMSwiaWF0IjoxNzcwNzQ2NDIxLCJqdGkiOiJhMGNlZWFjMWU4NzQ0NGRlOTk2ZGYyMGEwZTJkOGE2ZSIsInVzZXJfaWQiOjF9.pLo3VHHs9-MhIuPwylLXJbNfxqNPjJWjeSUsMENAvF4','2026-02-10 18:00:21.752724','2026-02-11 18:00:21.000000',1,'a0ceeac1e87444de996df20a0e2d8a6e'),
(30,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjgzMSwiaWF0IjoxNzcwNzQ2NDMxLCJqdGkiOiI4NTgzYjlkZmNjYmM0M2U5OGViYTc0ZjRmOGVjYTNhNiIsInVzZXJfaWQiOjF9.vkqoWWsygj3khLMmXMBlkH9vaJmUYKLltOl4mDJAQwI','2026-02-10 18:00:31.959240','2026-02-11 18:00:31.000000',1,'8583b9dfccbc43e98eba74f4f8eca3a6'),
(31,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjg0MSwiaWF0IjoxNzcwNzQ2NDQxLCJqdGkiOiIyYmRmNjkzZWM5NjY0MWIwYjMzMzZhMWRlOTkyMzIwYSIsInVzZXJfaWQiOjF9.bSLUxoUjDrVz-JkI1153IV3mWVKxN3BRSEx0_-FZQDY','2026-02-10 18:00:41.784763','2026-02-11 18:00:41.000000',1,'2bdf693ec96641b0b3336a1de992320a'),
(32,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMjkxOCwiaWF0IjoxNzcwNzQ2NTE4LCJqdGkiOiIyMGEwMzNjNzhkMDY0MjZkODQyMDAzZTgxZmVlNmUzNCIsInVzZXJfaWQiOjF9.aXQFhTu0c4T-_5J3a_PWnNmWcVR5lA453xs5w7pwXq8','2026-02-10 18:01:58.593528','2026-02-11 18:01:58.000000',1,'20a033c78d06426d842003e81fee6e34'),
(33,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzMzU0OCwiaWF0IjoxNzcwNzQ3MTQ4LCJqdGkiOiJiMmY1ZWU0OGFhZWI0OTI3YTU2ZTA0ZjZjNjc5OTMzYyIsInVzZXJfaWQiOjN9.GHNplxUj0wfHPQzgLkhqvKqWHg90IXx8GqGlm6d8-OE','2026-02-10 18:12:28.833799','2026-02-11 18:12:28.000000',3,'b2f5ee48aaeb4927a56e04f6c679933c'),
(34,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDgzNTgxNCwiaWF0IjoxNzcwNzQ5NDE0LCJqdGkiOiI0YmI5YmY2M2Y1ZDQ0OTRiYjFiZWNjOTNhZmQxNzJhMyIsInVzZXJfaWQiOjN9.N3TObMFdUm-mFu-LPcUoubd_3EOlWRd8HMCnBfqgFS8','2026-02-10 18:50:14.363096','2026-02-11 18:50:14.000000',3,'4bb9bf63f5d4494bb1becc93afd172a3'),
(35,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NTQyOCwiaWF0IjoxNzcwNzY5MDI4LCJqdGkiOiI2NjY2ZGY0YjM0NzE0NTc5ODRiOTJhY2E5ZGRhYTlmOSIsInVzZXJfaWQiOjF9.x2eAB6FN_i5qwtLlmGcGF01QdIl0jc6avCs6ATNjyC0','2026-02-11 00:17:08.720839','2026-02-12 00:17:08.000000',1,'6666df4b3471457984b92aca9ddaa9f9'),
(36,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NTQ1MywiaWF0IjoxNzcwNzY5MDUzLCJqdGkiOiJlNTMwODJiYzJiZjQ0MDBiYTdkNzgyZjNlNjRhYjFjNCIsInVzZXJfaWQiOjN9.tGcl2_wYBPKiNFd5OhBxfD37M-4FQX4pZUvw9XcRpEc','2026-02-11 00:17:33.406599','2026-02-12 00:17:33.000000',3,'e53082bc2bf4400ba7d782f3e64ab1c4'),
(37,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NjI0MiwiaWF0IjoxNzcwNzY5ODQyLCJqdGkiOiI4OTU4NzliY2FmZGI0MjgxYTgyNDJjOGQ5ZDAzMjA1NSIsInVzZXJfaWQiOjF9.YEVMEuQyb7_06Dr6GjixToi-eEweKflXLmrld2H8T9s','2026-02-11 00:30:42.877137','2026-02-12 00:30:42.000000',1,'895879bcafdb4281a8242c8d9d032055'),
(38,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NjM4OSwiaWF0IjoxNzcwNzY5OTg5LCJqdGkiOiJmYzMyMGZlNGU0NzU0YThhOGE0YjI2MmUxMmEzMTNlYyIsInVzZXJfaWQiOjN9.1vQg1kXKKnXeRn8A_mh2qwbG9joeXrQ2KDocKoT3CFw','2026-02-11 00:33:09.438508','2026-02-12 00:33:09.000000',3,'fc320fe4e4754a8a8a4b262e12a313ec'),
(39,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NjkzMCwiaWF0IjoxNzcwNzcwNTMwLCJqdGkiOiIwNTlmOGY4ZmU5YmE0NmE2YjlkNjlhNTE4Y2ViYmU0YiIsInVzZXJfaWQiOjF9.VDPejvXw41AM58-MCzKKih8mgcJzB-dUTvI1BNEVpcU','2026-02-11 00:42:10.373972','2026-02-12 00:42:10.000000',1,'059f8f8fe9ba46a6b9d69a518cebbe4b'),
(40,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NzAxNiwiaWF0IjoxNzcwNzcwNjE2LCJqdGkiOiI3NmMzNGFkM2E5MTM0OTBmYTM2YzZhMmM5NWM3NTY0MCIsInVzZXJfaWQiOjN9.1Q5c2mK-MlUf-ppt2qGsrIQKaY7cnuA7HUztyahjBC8','2026-02-11 00:43:36.336467','2026-02-12 00:43:36.000000',3,'76c34ad3a913490fa36c6a2c95c75640'),
(41,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NzA4MSwiaWF0IjoxNzcwNzcwNjgxLCJqdGkiOiJiYjhlZTQzN2JmNjI0YTZiYWU4Nzg3YTM5NzQ2ZmM5YSIsInVzZXJfaWQiOjF9.CFl6O0Lzdi2XpYy9L21JXKhFK4YSWVIZxg_S8Q165HY','2026-02-11 00:44:41.191239','2026-02-12 00:44:41.000000',1,'bb8ee437bf624a6bae8787a39746fc9a'),
(42,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NzU0NCwiaWF0IjoxNzcwNzcxMTQ0LCJqdGkiOiJmMGRlOTA3NmMxYzY0M2NkOTU2NDVjNzQxNDUyYWFjMyIsInVzZXJfaWQiOjF9.iskFpehTa4oWB-y-29zfNywAJmKZ-6UglqZBTiNFEJo','2026-02-11 00:52:24.213814','2026-02-12 00:52:24.000000',1,'f0de9076c1c643cd95645c741452aac3'),
(43,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1NzY0NCwiaWF0IjoxNzcwNzcxMjQ0LCJqdGkiOiIyYTZiMmNkZGU3YWU0OTZhODAwYzkwNGQzODg1NmY0YyIsInVzZXJfaWQiOjN9.1ZCJl3TBv9ph-AMZmCfFub0Tt9B51nHhUiCV6wN7IYk','2026-02-11 00:54:04.433219','2026-02-12 00:54:04.000000',3,'2a6b2cdde7ae496a800c904d38856f4c'),
(44,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODQwMCwiaWF0IjoxNzcwNzcyMDAwLCJqdGkiOiI3YjZiMDc5NGQ4MTQ0ODAxYTk4MTZiMzNlZjg0ZDE0MiIsInVzZXJfaWQiOjF9.B57tiP6RdqxfdckgXLZzKhU4je-a8Y0rZ0xPbFA05DI','2026-02-11 01:06:40.523811','2026-02-12 01:06:40.000000',1,'7b6b0794d8144801a9816b33ef84d142'),
(45,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODU4MSwiaWF0IjoxNzcwNzcyMTgxLCJqdGkiOiI2Y2QzNjJjOGYyOGY0NmMzODQxNDEwY2JlYzc5NWQzOSIsInVzZXJfaWQiOjF9.4WbPOWBQkL9ifzNSrb4rCnWTdCVZy9cQlhbQbASMFHY','2026-02-11 01:09:41.083743','2026-02-12 01:09:41.000000',1,'6cd362c8f28f46c3841410cbec795d39'),
(46,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODYwMCwiaWF0IjoxNzcwNzcyMjAwLCJqdGkiOiJjOWQ0NTBiZDMwZTI0YjY3ODU0MTRjMmEzNGYxYWE4MiIsInVzZXJfaWQiOjF9.-Yo-KKL_yNiC92lHWEbvz6tab8y7OsYyFiw7_GP7DMQ','2026-02-11 01:10:00.784236','2026-02-12 01:10:00.000000',1,'c9d450bd30e24b6785414c2a34f1aa82'),
(47,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODYwOSwiaWF0IjoxNzcwNzcyMjA5LCJqdGkiOiJjMWJlMjRiMzBlNzQ0NzU3OTI3MzJmZjA0NTEyMGYyNCIsInVzZXJfaWQiOjF9.n71Gid8kyMF9YkE4NLPTySK7a02QQsGOBYQP5e4nIuQ','2026-02-11 01:10:09.660311','2026-02-12 01:10:09.000000',1,'c1be24b30e74475792732ff045120f24'),
(48,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODYxOSwiaWF0IjoxNzcwNzcyMjE5LCJqdGkiOiI2MWIwNWUyN2Q1MjU0NzEyOThhMTlmM2Q1NDllYzhjMCIsInVzZXJfaWQiOjF9.NxTSZArOuhMVVQYTQOl9b5YYGeIN8B6eUDJE2frnNgY','2026-02-11 01:10:19.134727','2026-02-12 01:10:19.000000',1,'61b05e27d525471298a19f3d549ec8c0'),
(49,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODYxOSwiaWF0IjoxNzcwNzcyMjE5LCJqdGkiOiI3M2YxZWZjMGEwMzQ0NWE4YTNkMjFmZDVlMDc5ODc2NSIsInVzZXJfaWQiOjN9.UT1Iurq6fwztOST2QzbGP4lvNTgw6ptI2hP0E-yhdiE','2026-02-11 01:10:19.250326','2026-02-12 01:10:19.000000',3,'73f1efc0a03445a8a3d21fd5e0798765'),
(50,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODY5OCwiaWF0IjoxNzcwNzcyMjk4LCJqdGkiOiJhMjEzYmI5MjVlODg0NGU1YWI0M2M5NmIyNjExZWZmNCIsInVzZXJfaWQiOjN9.tSh5d-7B2Ta16cL8nl0n9XJMjZzdv79J9fVc80wEMdA','2026-02-11 01:11:38.073889','2026-02-12 01:11:38.000000',3,'a213bb925e8844e5ab43c96b2611eff4'),
(51,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1ODgxMSwiaWF0IjoxNzcwNzcyNDExLCJqdGkiOiI4MTVmMjBiMGM5NDI0ODY4OGVhNGE1YWE4MWQ4MjVmZCIsInVzZXJfaWQiOjN9.PQyao5JxbKQs1jJgOvr-XNmHVgQ6pVyO7e469pJeIJw','2026-02-11 01:13:31.363784','2026-02-12 01:13:31.000000',3,'815f20b0c94248688ea4a5aa81d825fd'),
(52,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1OTEwNSwiaWF0IjoxNzcwNzcyNzA1LCJqdGkiOiJkM2ViYjY5ZDY4ZGM0MjM5YmY3OWY3MDhmMTYxM2RkZSIsInVzZXJfaWQiOjF9.e7R9rPwJ7tUvJODqMWMUNyrkdmNS9AxdHOzEuiAObbw','2026-02-11 01:18:25.981935','2026-02-12 01:18:25.000000',1,'d3ebb69d68dc4239bf79f708f1613dde'),
(53,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1OTI1MywiaWF0IjoxNzcwNzcyODUzLCJqdGkiOiI2MjIxOGU5ZmI0YTM0YjZiYjA0Mjc5OTc0YTgwZGVlMCIsInVzZXJfaWQiOjN9.6Cp1u2BeEKV4PDRsFNolxFqCvZdzaBUwRT7cA8-gMP4','2026-02-11 01:20:53.618003','2026-02-12 01:20:53.000000',3,'62218e9fb4a34b6bb04279974a80dee0'),
(54,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg1OTczMCwiaWF0IjoxNzcwNzczMzMwLCJqdGkiOiI0YzI4NTI2ODExMjY0NDM4ODI2Njk4Y2YxOGYwZjJmNiIsInVzZXJfaWQiOjN9.Y0GGYErxQ3ijYVfsYbguEq9pJZMfPMq3FqHAuzNA22Q','2026-02-11 01:28:50.733299','2026-02-12 01:28:50.000000',3,'4c28526811264438826698cf18f0f2f6'),
(55,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTI1NywiaWF0IjoxNzcwNzc0ODU3LCJqdGkiOiI5MTNlOWFmYjNlYmQ0MjhjOWJlYmM2YTNmNTVlY2NhYSIsInVzZXJfaWQiOjF9.2eNDxbD_yePJy5YCpAMvU5fjioO97a-Tc9iBQlgKnBw','2026-02-11 01:54:17.956923','2026-02-12 01:54:17.000000',1,'913e9afb3ebd428c9bebc6a3f55eccaa'),
(56,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTI3MSwiaWF0IjoxNzcwNzc0ODcxLCJqdGkiOiIyMzMzMzNmY2IwNmU0ZTg3OWUxYzhlNDA5ODk4NTRhMyIsInVzZXJfaWQiOjN9.3rg2MWUwW0OUuxFwofPfahxORumOSEMuDlcp-YYRPEE','2026-02-11 01:54:31.100056','2026-02-12 01:54:31.000000',3,'233333fcb06e4e879e1c8e40989854a3'),
(57,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTQ2OCwiaWF0IjoxNzcwNzc1MDY4LCJqdGkiOiI5NWEwMDEzOTk1MzE0Y2RjOGQ4NzMzMDA5MjdhNjY4ZiIsInVzZXJfaWQiOjN9.1qq5QIXFARy_wBshDcMO0o0hAE6AUlrqglH6eepjIW4','2026-02-11 01:57:48.786364','2026-02-12 01:57:48.000000',3,'95a0013995314cdc8d873300927a668f'),
(58,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTU0OSwiaWF0IjoxNzcwNzc1MTQ5LCJqdGkiOiI3ZGJhZDk3YmJjMTQ0NjEwODVkNmQ4YjUxZmY5ZWI5ZCIsInVzZXJfaWQiOjN9.3vwXifXdLTnB5VG793Dscx610it0rF2P6dkHRIHF4Uo','2026-02-11 01:59:09.228031','2026-02-12 01:59:09.000000',3,'7dbad97bbc14461085d6d8b51ff9eb9d'),
(59,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTY5MSwiaWF0IjoxNzcwNzc1MjkxLCJqdGkiOiI1NzIzNjEwMGJhMGM0ZTBkYTI2ZTM2ZjM1NmI1MjEzMyIsInVzZXJfaWQiOjN9.5pZhy81_pf6r7BJjRKKIuGUufxejaJ6vpYkOpBpV3ro','2026-02-11 02:01:31.441216','2026-02-12 02:01:31.000000',3,'57236100ba0c4e0da26e36f356b52133'),
(60,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTg1NSwiaWF0IjoxNzcwNzc1NDU1LCJqdGkiOiI5MGM0NmFkMjU2ZjI0NzIzOGFiZTc2ODUzODhhNDU3YSIsInVzZXJfaWQiOjN9.e_hj7B4xwqbwQUiDCYdZfd6xgj2dHz5qYiSR52CvQGw','2026-02-11 02:04:15.585120','2026-02-12 02:04:15.000000',3,'90c46ad256f247238abe7685388a457a'),
(61,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTk1MSwiaWF0IjoxNzcwNzc1NTUxLCJqdGkiOiJjMmE5NzI1NmRkN2U0MjVlODJhZTBkM2RjZmVhNzM1OSIsInVzZXJfaWQiOjF9.NKs9p7wtekzVXUssR1yx3v7oUvinnQ9nPgOmHnv3lco','2026-02-11 02:05:51.536224','2026-02-12 02:05:51.000000',1,'c2a97256dd7e425e82ae0d3dcfea7359'),
(62,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MTk2MiwiaWF0IjoxNzcwNzc1NTYyLCJqdGkiOiJiMzExNzA2ZjQ1ZWU0MGNiOTRlMDQ3MjUxMDJhZjJjZiIsInVzZXJfaWQiOjF9.P6BiqG2AtdWfIk6nBfSw_3QofNYAnBnv4koPUO9XN2I','2026-02-11 02:06:02.671495','2026-02-12 02:06:02.000000',1,'b311706f45ee40cb94e04725102af2cf'),
(63,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MjM3MiwiaWF0IjoxNzcwNzc1OTcyLCJqdGkiOiI5M2U2N2ZkZTgwZDM0MjFiOTljNGJkNzk4MTBhZTAyNiIsInVzZXJfaWQiOjN9.N2ZTsE3Fw7GkFzlI65vD4C3QRcje5rG6kcUvodWHAz8','2026-02-11 02:12:52.914004','2026-02-12 02:12:52.000000',3,'93e67fde80d3421b99c4bd79810ae026'),
(64,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MjY5NSwiaWF0IjoxNzcwNzc2Mjk1LCJqdGkiOiJjYTZlZmM5MGQ2MWQ0NGNhOGMyOGY0MDc5Y2Y4ZDlhZiIsInVzZXJfaWQiOjN9.Vq5I4YpDw_TZaU0aGpkIvO4gloi5mNA6EdHLUqJMQqg','2026-02-11 02:18:15.279289','2026-02-12 02:18:15.000000',3,'ca6efc90d61d44ca8c28f4079cf8d9af'),
(65,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2MjcwMiwiaWF0IjoxNzcwNzc2MzAyLCJqdGkiOiI5YWQxZTJkNmY4NWY0OGYwYmExOTMzOTAyYTkzNDcyNSIsInVzZXJfaWQiOjF9.tGxv5EHTf8f3oQugYHGUA6aLr5TXyAoBd1qP5YNGjqA','2026-02-11 02:18:22.364592','2026-02-12 02:18:22.000000',1,'9ad1e2d6f85f48f0ba1933902a934725'),
(66,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2Mzk0OSwiaWF0IjoxNzcwNzc3NTQ5LCJqdGkiOiIwZTViMzI5ZWFhYWI0YjYyOWMwNGQ2NGE3NmJkNzA3YiIsInVzZXJfaWQiOjN9.eLozPzmkpZP6kktA4xh0Mliu_mHU1Eyj36PAaGmjPbU','2026-02-11 02:39:09.745627','2026-02-12 02:39:09.000000',3,'0e5b329eaaab4b629c04d64a76bd707b'),
(67,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg2Mzk5NCwiaWF0IjoxNzcwNzc3NTk0LCJqdGkiOiI2NmFiN2I3ZTNlNzk0YzlhYTFmNTA1YzhjOTA1OTNlMiIsInVzZXJfaWQiOjF9.tufZ_sh8vF29LP9swTtlHTOw3MaaYJVQCjYwza2fWzI','2026-02-11 02:39:54.356146','2026-02-12 02:39:54.000000',1,'66ab7b7e3e794c9aa1f505c8c90593e2'),
(68,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4MjI2NSwiaWF0IjoxNzcwNzk1ODY1LCJqdGkiOiI1ZTk5Mzg0MzY0MzI0M2Q0YjU4NTI1NmRhZWQxMzdmOSIsInVzZXJfaWQiOjN9.QFztW09vPw-51bD-ZvoL-XOpRiGyty-5uhHvsBlf76E','2026-02-11 07:44:25.522573','2026-02-12 07:44:25.000000',3,'5e993843643243d4b585256daed137f9'),
(69,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4MjMzNCwiaWF0IjoxNzcwNzk1OTM0LCJqdGkiOiJjYjA4MzZlM2RjOGI0MDMwYjlhYTU2NDhiMGUyNTc0NiIsInVzZXJfaWQiOjF9.cavjyKDhVWb2WcyTgrOBLygDlEJL4FcZmjVdCCtx-Fw','2026-02-11 07:45:34.105447','2026-02-12 07:45:34.000000',1,'cb0836e3dc8b4030b9aa5648b0e25746'),
(70,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4MjUyMywiaWF0IjoxNzcwNzk2MTIzLCJqdGkiOiI3NWFhNGY4ZWNiNGE0Mzg0ODE2YjExMzJkYmRlNzc0YSIsInVzZXJfaWQiOjN9.ElSDXv7LYc7PoCtLdyGfEkfcU8u8D5FIjptrUd15i3M','2026-02-11 07:48:43.206301','2026-02-12 07:48:43.000000',3,'75aa4f8ecb4a4384816b1132dbde774a'),
(71,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4NjEyMywiaWF0IjoxNzcwNzk5NzIzLCJqdGkiOiI2ZmNmZTE5MzA1ZDY0YThmOGIxNTkyMmMzYTE4OTc3YSIsInVzZXJfaWQiOjF9.N-trE5ToN6PcPwOROdt9sJ1o90a0FU71UbjDvgndMaQ','2026-02-11 08:48:43.685703','2026-02-12 08:48:43.000000',1,'6fcfe19305d64a8f8b15922c3a18977a'),
(72,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4NzA3NiwiaWF0IjoxNzcwODAwNjc2LCJqdGkiOiIzZDc4NTk4NTJhZGY0ODAwYjg1MWZlZWRlYzBjMTYyYiIsInVzZXJfaWQiOjF9.nxeXlUU2a0Klm1Qf0lcBDNW8upViGZZaWBZGHOCdHqI','2026-02-11 09:04:36.239056','2026-02-12 09:04:36.000000',1,'3d7859852adf4800b851feedec0c162b'),
(73,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg4ODc0MSwiaWF0IjoxNzcwODAyMzQxLCJqdGkiOiIyYzc0OWY2ODRiYTM0YmM0YjJmZGI1YTUyYjliNzA4MiIsInVzZXJfaWQiOjN9.AzZ0lgVcCwLZmUYRUHO_14Htgj4W96AjX1k2oK4RRF8','2026-02-11 09:32:21.975486','2026-02-12 09:32:21.000000',3,'2c749f684ba34bc4b2fdb5a52b9b7082'),
(74,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg5MTQwNSwiaWF0IjoxNzcwODA1MDA1LCJqdGkiOiJkYzEyNTU5YmIxOWU0ZmZiYTJmODg3MGY1Y2FkODU2NyIsInVzZXJfaWQiOjF9.mt4zp3cSre24q6DB3UOWpmVjfuH7q3T1x825j6LYTlc','2026-02-11 10:16:45.399529','2026-02-12 10:16:45.000000',1,'dc12559bb19e4ffba2f8870f5cad8567'),
(75,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg5MjYwNSwiaWF0IjoxNzcwODA2MjA1LCJqdGkiOiIzOTI4YjZkMjc2NjQ0N2M5OTExMjc5NzkzOTRkY2JhZSIsInVzZXJfaWQiOjN9.QNa0GtWPG9q_oE88Pe4yqW1bVqpMD4JRT9juMFj4EY8','2026-02-11 10:36:45.626785','2026-02-12 10:36:45.000000',3,'3928b6d2766447c991127979394dcbae'),
(76,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg5NDk3MSwiaWF0IjoxNzcwODA4NTcxLCJqdGkiOiJjODY4MDA5OTBjNTc0ZjBjYmViMDQyZWNiZTIxOWVkMyIsInVzZXJfaWQiOjN9.boS15t5NAP-eWVP1GdmBbH5oEY2fIMJesyUkHG16vr0','2026-02-11 11:16:11.181735','2026-02-12 11:16:11.000000',3,'c86800990c574f0cbeb042ecbe219ed3'),
(77,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDg5OTkzOSwiaWF0IjoxNzcwODEzNTM5LCJqdGkiOiI5NjE1MjQyYzc3Mzg0ZjgzYTAxMThhYTBmOGNjMGIxZiIsInVzZXJfaWQiOjF9.dkm58YqQgxitPATojmvb67_KptxzBfBfzAMnO0zdDMg','2026-02-11 12:38:59.830277','2026-02-12 12:38:59.000000',1,'9615242c77384f83a0118aa0f8cc0b1f'),
(78,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkwMDE4NCwiaWF0IjoxNzcwODEzNzg0LCJqdGkiOiJkYzUzOGQyYjEwNDU0MzdkOGVkYWIwNzIwMTNkZGNhYiIsInVzZXJfaWQiOjF9.MJCBRr3v2FIvaBmcAJcUkNgTtLfN6HS4V6io7KW-q-8','2026-02-11 12:43:04.096107','2026-02-12 12:43:04.000000',1,'dc538d2b1045437d8edab072013ddcab'),
(79,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkwMDE5MiwiaWF0IjoxNzcwODEzNzkyLCJqdGkiOiJlZGEyMzAyMGEwNDI0N2RlYjBiZWI1Y2I5ZWU5MmRiMiIsInVzZXJfaWQiOjF9.08CQNp3l2yP7ZeULqwP092wBoCzxaNNHP4TNnzTkAWk','2026-02-11 12:43:12.444141','2026-02-12 12:43:12.000000',1,'eda23020a04247deb0beb5cb9ee92db2'),
(80,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkwMDIwMCwiaWF0IjoxNzcwODEzODAwLCJqdGkiOiI4NmJlY2NhNTA3ODY0NjA5OWQzMzkxNWQzNmI5OWE0MyIsInVzZXJfaWQiOjF9.Nq81LXGmsauaoxym_WYQyN1zGfOibrVHky8ij6Lt6gg','2026-02-11 12:43:20.391167','2026-02-12 12:43:20.000000',1,'86becca5078646099d33915d36b99a43'),
(81,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkwMDIwNywiaWF0IjoxNzcwODEzODA3LCJqdGkiOiIwMDkyYWY3YTRmOWQ0ODI2YjA3MTY3YzkxYjM5MTQyYyIsInVzZXJfaWQiOjF9.YtpQqO_1lPt9y3GSQHhNaN1y57CqqGJUf6Wr_Kc8ACQ','2026-02-11 12:43:27.990760','2026-02-12 12:43:27.000000',1,'0092af7a4f9d4826b07167c91b39142c'),
(82,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxMjQwNiwiaWF0IjoxNzcwODI2MDA2LCJqdGkiOiI3NTBkMTgzN2MyNjE0MDRlYjk1NmY1MGNmMjQ4Y2ViYyIsInVzZXJfaWQiOjF9.0AkgAEPT6_KTkphYPZalIbIP7CjrjUl7mjB6TQR6JJA','2026-02-11 16:06:46.258624','2026-02-12 16:06:46.000000',1,'750d1837c261404eb956f50cf248cebc'),
(83,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDE4MiwiaWF0IjoxNzcwODI3NzgyLCJqdGkiOiJiMjE5MDk1N2E3Njc0OGVhYTA0MTIwZmUzMDRjOWE4YiIsInVzZXJfaWQiOjF9.51ag51c6_LRgdRTXLBWasUnLfvmpvzi6jDjg84qZbH8','2026-02-11 16:36:22.312067','2026-02-12 16:36:22.000000',1,'b2190957a76748eaa04120fe304c9a8b'),
(84,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDM2NywiaWF0IjoxNzcwODI3OTY3LCJqdGkiOiJjMzZlYTZlMGRlNjU0NmVmOTExNWNiODI1MmM2NjRlNyIsInVzZXJfaWQiOjF9.yB-nJu5sdiiWiHld6lPLrUfguJVkRWDIT_dCoB4xWWs','2026-02-11 16:39:27.647295','2026-02-12 16:39:27.000000',1,'c36ea6e0de6546ef9115cb8252c664e7'),
(85,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDUxMywiaWF0IjoxNzcwODI4MTEzLCJqdGkiOiIwMzJkNzkwNDBlNGI0ZjAzYTUzNGQ4Zjk1ZWUzYTQzMSIsInVzZXJfaWQiOjF9.IuX-tq3yo1L3OkRxOkh2H7NNwXuVu6bZR9PITQdfcN0','2026-02-11 16:41:53.481548','2026-02-12 16:41:53.000000',1,'032d79040e4b4f03a534d8f95ee3a431'),
(86,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDUyMSwiaWF0IjoxNzcwODI4MTIxLCJqdGkiOiIwOTlmNmI3MDI0ZTA0ODIxOThmMjFhOWRiMDhiNTE3ZiIsInVzZXJfaWQiOjF9.yssp6Sq2MNWu-PCjl5zYu-6E_PiKRbhLhdYw1ygz5CE','2026-02-11 16:42:01.903215','2026-02-12 16:42:01.000000',1,'099f6b7024e0482198f21a9db08b517f'),
(87,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDU3OCwiaWF0IjoxNzcwODI4MTc4LCJqdGkiOiJkYWM0OTI5M2Y2M2Y0YzMyOTQzMmJlMjM4ZjI3ZTMxMyIsInVzZXJfaWQiOjF9.UOPVsXuJVs1oY5wyKWXh046bRsQ_dtXiY4wNLe9oRd8','2026-02-11 16:42:58.235204','2026-02-12 16:42:58.000000',1,'dac49293f63f4c329432be238f27e313'),
(88,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDYzNCwiaWF0IjoxNzcwODI4MjM0LCJqdGkiOiI0MDNjYWJiNzUzMDU0MjRlODFhYzEzODgzMzkzMDA0YyIsInVzZXJfaWQiOjF9.ePmw8f-4ciCAEHS5B51rVmD95vcJUfpHTUh5LmMs3ko','2026-02-11 16:43:54.033932','2026-02-12 16:43:54.000000',1,'403cabb75305424e81ac13883393004c'),
(89,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDY5MywiaWF0IjoxNzcwODI4MjkzLCJqdGkiOiIzNjM1ZWJhMDE4NzE0ZWJlYWU4MWZjYWZjNjgwZjg5MyIsInVzZXJfaWQiOjF9.ZI23k-Ic4FFB_Eioi8zrokjbT7-aMHw_ivjFiJ_zRFI','2026-02-11 16:44:53.345327','2026-02-12 16:44:53.000000',1,'3635eba018714ebeae81fcafc680f893'),
(90,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDcwMiwiaWF0IjoxNzcwODI4MzAyLCJqdGkiOiIzODBhNTVkZTYwMDY0NGM0Yjg0ODkxMmFhMGNkYWZiMiIsInVzZXJfaWQiOjF9.Cu1If_VKWLtay8v5nqozIIU9_gcxq9Uqf0KV53IStBU','2026-02-11 16:45:02.339366','2026-02-12 16:45:02.000000',1,'380a55de600644c4b848912aa0cdafb2'),
(91,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDcxMiwiaWF0IjoxNzcwODI4MzEyLCJqdGkiOiJkNGQxZTVjMmNjMDM0ZTA0OTExODExYWM0MTRkMGQ5ZCIsInVzZXJfaWQiOjF9.rgANz9TJykZPsi30WhI0ZJNxikhnDdsl42_iEjPoWZU','2026-02-11 16:45:12.600488','2026-02-12 16:45:12.000000',1,'d4d1e5c2cc034e04911811ac414d0d9d'),
(92,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDcyMCwiaWF0IjoxNzcwODI4MzIwLCJqdGkiOiI3OTgyYWIxODY4NjI0ZTI2OGEwZDNjZjM4NzA0M2M0YSIsInVzZXJfaWQiOjF9.8G3Lf1P-78dEVHvj45Af_M6J5KxJgTibGeHsVB0ifXM','2026-02-11 16:45:20.816178','2026-02-12 16:45:20.000000',1,'7982ab1868624e268a0d3cf387043c4a'),
(93,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDc2NSwiaWF0IjoxNzcwODI4MzY1LCJqdGkiOiI5OWVkZGM3N2Q2OGE0OTczOTY4ZTdhYjNhNmViNzIxNSIsInVzZXJfaWQiOjF9.VKR7K__pYCTRufGGX-jqlM9HJP4AvrdTSrwG5PXBV6Y','2026-02-11 16:46:05.391224','2026-02-12 16:46:05.000000',1,'99eddc77d68a4973968e7ab3a6eb7215'),
(94,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNDc3MywiaWF0IjoxNzcwODI4MzczLCJqdGkiOiIzM2JmZDQyZTdmMjM0N2MxOTcwOGY5YWU0YjBkMmRiMiIsInVzZXJfaWQiOjF9._KY0eWnkSqkKCoNYw3O8zMj1JH_mw101KR8cbUDTUIM','2026-02-11 16:46:13.997028','2026-02-12 16:46:13.000000',1,'33bfd42e7f2347c19708f9ae4b0d2db2'),
(95,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTEyNCwiaWF0IjoxNzcwODI4NzI0LCJqdGkiOiI2MTkyOTc3MjMzMzU0Y2NkODAyZmExMTM4ZWQ3NjAyZSIsInVzZXJfaWQiOjF9.V0EAbq8z4B2Pw5WOOCYa08k1H8GrVIptAQWeujptQUY','2026-02-11 16:52:04.674641','2026-02-12 16:52:04.000000',1,'6192977233354ccd802fa1138ed7602e'),
(96,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTU2MiwiaWF0IjoxNzcwODI5MTYyLCJqdGkiOiI4MDk1OTE5NGFkYjQ0ZTIxYWQ1NzdjZmNmYzI3NTJiMyIsInVzZXJfaWQiOjF9.o3Qre4dvX-jaElHyR_umxK6eGeZ3wcZKOnWwQmWScL0','2026-02-11 16:59:22.579974','2026-02-12 16:59:22.000000',1,'80959194adb44e21ad577cfcfc2752b3'),
(97,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTc3MywiaWF0IjoxNzcwODI5MzczLCJqdGkiOiI3YjIzNDc0NzQ3NGU0MWRmOWQzOTRhNGYwMzE1YTcwMCIsInVzZXJfaWQiOjF9.3mx5aNTqu1wn8IX1klSVzoMae4uOmmzRLec5z8wMGDA','2026-02-11 17:02:53.221696','2026-02-12 17:02:53.000000',1,'7b234747474e41df9d394a4f0315a700'),
(98,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTgwNywiaWF0IjoxNzcwODI5NDA3LCJqdGkiOiJmMTA0NWVlZjViNjM0NzEyOWU1MmMzMjVmNGMwN2EwMiIsInVzZXJfaWQiOjF9.XOQfNkDNUOVk6h2k4P-xMdwR8N5G8BFkwM-04F8E0MM','2026-02-11 17:03:27.472423','2026-02-12 17:03:27.000000',1,'f1045eef5b6347129e52c325f4c07a02'),
(99,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTgxNiwiaWF0IjoxNzcwODI5NDE2LCJqdGkiOiJjYWQ5NjU4OTA4MTk0NWFmOThhNzgyYmVlZGYzZDZmZiIsInVzZXJfaWQiOjF9._EtkYBtDtOlSnZuL0az9xtFStQhtVm1BeO46qXGMcHc','2026-02-11 17:03:36.946944','2026-02-12 17:03:36.000000',1,'cad96589081945af98a782beedf3d6ff'),
(100,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTkyMSwiaWF0IjoxNzcwODI5NTIxLCJqdGkiOiIzMzRlYjkyMTM0OTc0YTAwYmEzNWZlM2M0YWJlYTg5OCIsInVzZXJfaWQiOjF9.RL9fDON9xJ2wIc0MEsh7dfihYj1djDHi0BkcZnktCug','2026-02-11 17:05:21.743100','2026-02-12 17:05:21.000000',1,'334eb92134974a00ba35fe3c4abea898'),
(101,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTkzMSwiaWF0IjoxNzcwODI5NTMxLCJqdGkiOiJlZWJkZDJmN2QyYjQ0ZDBhODJhMWJmMThmNTZjZjZlMiIsInVzZXJfaWQiOjF9.LuUOPADL1RhrxAIUdn8-Xngi8GZY4rmGqXTk5ArM40U','2026-02-11 17:05:31.300329','2026-02-12 17:05:31.000000',1,'eebdd2f7d2b44d0a82a1bf18f56cf6e2'),
(102,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNTk0MCwiaWF0IjoxNzcwODI5NTQwLCJqdGkiOiIwODE3ODg0MzYwODY0NWI5YjVkZjQ5ZGEzMzk3MWY2NSIsInVzZXJfaWQiOjF9.l0fRHNRmhmOwS5JQuBrwPOXQm8Nq7cYI5MsLZVd1qpQ','2026-02-11 17:05:40.740449','2026-02-12 17:05:40.000000',1,'08178843608645b9b5df49da33971f65'),
(103,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNjExNiwiaWF0IjoxNzcwODI5NzE2LCJqdGkiOiI0NjI0MzQ4MGYzOTU0NjQzYTBjODAwNTA4M2ViYWY0MyIsInVzZXJfaWQiOjF9.wIVc6bjpSURouVbHW8wbCoFaP5ah2hZXfhWxiITb4bA','2026-02-11 17:08:36.037720','2026-02-12 17:08:36.000000',1,'46243480f3954643a0c8005083ebaf43'),
(104,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNjEyNSwiaWF0IjoxNzcwODI5NzI1LCJqdGkiOiJjYjA3OTAxM2Y2Yjg0MWM1YjE5ZTMwOWI5MDVmMTdlZiIsInVzZXJfaWQiOjF9.fFb3BSCngM2qaPMWBBHZRycH0z2wXa2MyBSPMYH1xZw','2026-02-11 17:08:45.093783','2026-02-12 17:08:45.000000',1,'cb079013f6b841c5b19e309b905f17ef'),
(105,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNjEzMywiaWF0IjoxNzcwODI5NzMzLCJqdGkiOiJmMDJkZTlhYzNiNjk0YWM2YmUyZmNmYzE4ZGZjNDllNyIsInVzZXJfaWQiOjF9.nPrWrMEpshJRL32KrRN-Mur4NKgWzuG_gprdG4ew_JE','2026-02-11 17:08:53.877916','2026-02-12 17:08:53.000000',1,'f02de9ac3b694ac6be2fcfc18dfc49e7'),
(106,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDkxNjE0MiwiaWF0IjoxNzcwODI5NzQyLCJqdGkiOiI2NjY1ZDNhMmNmZjI0YzRhOWM5Zjk3NTJiMDc1ZTNiOCIsInVzZXJfaWQiOjF9.K5o1L2mHFCUt-DK4NmPDUV8EjXkrXeuoJYISfsrlbMs','2026-02-11 17:09:02.620839','2026-02-12 17:09:02.000000',1,'6665d3a2cff24c4a9c9f9752b075e3b8'),
(107,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0NTUwMCwiaWF0IjoxNzcwODU5MTAwLCJqdGkiOiJhNzc3N2M3ZGUwZmM0MmM5YWE4NjI5MDIzNjU5M2YzZCIsInVzZXJfaWQiOjF9.JHcZDB7GMtXBt8k0YmRu4YIUTyELjq1GKyh5Tf0Tq8A','2026-02-12 01:18:20.941138','2026-02-13 01:18:20.000000',1,'a7777c7de0fc42c9aa86290236593f3d'),
(108,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0NTg0NCwiaWF0IjoxNzcwODU5NDQ0LCJqdGkiOiI5NjNiYmFlNWNiYTU0Yzg1ODZmNDcwM2RkYWJkZGYzNCIsInVzZXJfaWQiOjF9.UgntRldVxlH2trYio5fgHvigt2exUMIp3ui4OcCy_Rc','2026-02-12 01:24:04.754638','2026-02-13 01:24:04.000000',1,'963bbae5cba54c8586f4703ddabddf34'),
(109,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0NjA3NiwiaWF0IjoxNzcwODU5Njc2LCJqdGkiOiI4NjNkNzA4NDNmOTg0ODRhOWEwODZmMDNhNDNiNTQ5NiIsInVzZXJfaWQiOjF9.4dPTAwm52CPL5b55VpK4RNpuy8sCGK7A3G8VsImdxyU','2026-02-12 01:27:56.250069','2026-02-13 01:27:56.000000',1,'863d70843f98484a9a086f03a43b5496'),
(110,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0NjYwMCwiaWF0IjoxNzcwODYwMjAwLCJqdGkiOiIyZGFlYjU1OGUwYzQ0ZmQ1YmU4NDViMzllOGNjYWM2NSIsInVzZXJfaWQiOjF9.RsgqnjTdaqPvzrJc9RSuAkeXa-_3vrG9Ug8OCO50Qdk','2026-02-12 01:36:40.725736','2026-02-13 01:36:40.000000',1,'2daeb558e0c44fd5be845b39e8ccac65'),
(111,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0ODIyOCwiaWF0IjoxNzcwODYxODI4LCJqdGkiOiJkZmUzODE3MTUwNWE0ZTc4OTQ2NzhiYzBjODIwN2FhMSIsInVzZXJfaWQiOjF9.dZ1Tk9HQx2Nq4QpHl0hyH6hfkaUMssHy6XF8HJVeqo4','2026-02-12 02:03:48.940683','2026-02-13 02:03:48.000000',1,'dfe38171505a4e7894678bc0c8207aa1'),
(112,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk0ODMxMywiaWF0IjoxNzcwODYxOTEzLCJqdGkiOiIyZmVmZjlkZWJiNGE0NzBjODBlMTUzMDJhYjZjMzVhNyIsInVzZXJfaWQiOjF9.HjVajsNHEe58DKc2gDzEUKHWOOAQUMyvUb2e4nrqp1E','2026-02-12 02:05:13.465565','2026-02-13 02:05:13.000000',1,'2feff9debb4a470c80e15302ab6c35a7'),
(113,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTE4NywiaWF0IjoxNzcwODY0Nzg3LCJqdGkiOiI1ZTc0YmI5MWZjMGQ0NjM5OGZmMzhkNDNiZGRlMmJmYiIsInVzZXJfaWQiOjF9.ywzyyY57iBnRViyVgV9zBMwGd5u2Vx2AnYumtm7LlyI','2026-02-12 02:53:07.403998','2026-02-13 02:53:07.000000',1,'5e74bb91fc0d46398ff38d43bdde2bfb'),
(114,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTE5NiwiaWF0IjoxNzcwODY0Nzk2LCJqdGkiOiIwMDhhMzkzMTMzOGY0NmE0OTgzZDA1ZWE1NGM3ZmVhNSIsInVzZXJfaWQiOjF9.JnD_QEn9Eq7nWEzCaOY3b3uWffNzlqz6ZQr3WS3mxjU','2026-02-12 02:53:16.857794','2026-02-13 02:53:16.000000',1,'008a3931338f46a4983d05ea54c7fea5'),
(115,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTI2MSwiaWF0IjoxNzcwODY0ODYxLCJqdGkiOiJmM2MyMTJjMzRmY2M0OTkyOGYzOWE4ZDA0NmMxZDQ0OCIsInVzZXJfaWQiOjF9.pLQai5dl4KlZbt7tElEvqhlw4irBolRBuBGyXlnc7L8','2026-02-12 02:54:21.271032','2026-02-13 02:54:21.000000',1,'f3c212c34fcc49928f39a8d046c1d448'),
(116,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTI2OSwiaWF0IjoxNzcwODY0ODY5LCJqdGkiOiJlNjMzMTMxZDkzZmQ0NjA2YWVlYWJjZWYzZTI3MzlmMSIsInVzZXJfaWQiOjF9.rUFJSDcCYsFyXQTvYsHhH29kiesM84LTbq1Z8TY2clA','2026-02-12 02:54:29.592017','2026-02-13 02:54:29.000000',1,'e633131d93fd4606aeeabcef3e2739f1'),
(117,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTI3OCwiaWF0IjoxNzcwODY0ODc4LCJqdGkiOiIyMjJmN2YwNjBiZWU0ZTFmOTdkYWViOGZkYTBjMzc2NSIsInVzZXJfaWQiOjF9.pOTphzdgHo_P-P2CCsdDmUf5qtTRJIuQ9h1OpF25G7o','2026-02-12 02:54:38.019960','2026-02-13 02:54:38.000000',1,'222f7f060bee4e1f97daeb8fda0c3765'),
(118,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTI4OCwiaWF0IjoxNzcwODY0ODg4LCJqdGkiOiJjMzBiNmY5ZmM5MTM0NWEzOGIxYzZiOWI2Zjc3ZGI2OSIsInVzZXJfaWQiOjF9.OKVM_PXeC7FW-FFY5O89GAUJg2nnCPUxZ2cX8mOp3qQ','2026-02-12 02:54:48.036352','2026-02-13 02:54:48.000000',1,'c30b6f9fc91345a38b1c6b9b6f77db69'),
(119,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTMzMCwiaWF0IjoxNzcwODY0OTMwLCJqdGkiOiIwMGExMTg2Y2VlMDM0ZTYzOTg1MzExMmUwZGIwYWJkMyIsInVzZXJfaWQiOjF9.73BY7lv8b5Br0PxBRU-V_a_akvRJYsutpW6KPK7Jg3w','2026-02-12 02:55:30.565010','2026-02-13 02:55:30.000000',1,'00a1186cee034e639853112e0db0abd3'),
(120,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTM3NSwiaWF0IjoxNzcwODY0OTc1LCJqdGkiOiJhZWFlZGU0ZTE5YTk0NTZiODczZmVjZGNlNjRkNmY3ZiIsInVzZXJfaWQiOjF9.IlC9rsH-NJJGjZ4lGr-jEXK65lMvVYUnT3nMaRBk_QY','2026-02-12 02:56:15.396598','2026-02-13 02:56:15.000000',1,'aeaede4e19a9456b873fecdce64d6f7f'),
(121,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTQ2MCwiaWF0IjoxNzcwODY1MDYwLCJqdGkiOiJhYTQ3NzJmYzhmYTk0OTlmOGQ4NzQxYTE5ZmQ4Zjc0YyIsInVzZXJfaWQiOjF9.5uO0GAhiY0DuwQiOlITOs_f3eolKiBf9K0ejxl0NrUM','2026-02-12 02:57:40.408036','2026-02-13 02:57:40.000000',1,'aa4772fc8fa9499f8d8741a19fd8f74c'),
(122,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1MTUzOCwiaWF0IjoxNzcwODY1MTM4LCJqdGkiOiIyYTM1NDA4MDQxNDQ0ZWNiODQyMjAwZTY5MzJjYTkwOSIsInVzZXJfaWQiOjF9.rYuRSlOeD3jOVVt-UJ8aDRVXZoWO8m4gJGajAyfIEx0','2026-02-12 02:58:58.119537','2026-02-13 02:58:58.000000',1,'2a35408041444ecb842200e6932ca909'),
(123,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzMzNCwiaWF0IjoxNzcwODcwOTM0LCJqdGkiOiJmNmNkMWM4ZGM1ZWQ0ZDEyYWI5YmQyODcyNTkyNjA0NiIsInVzZXJfaWQiOjF9.uaonQGiWNwygATfSImQle_g8J3vLKy4EL6gPWsfIiPM','2026-02-12 04:35:34.509701','2026-02-13 04:35:34.000000',1,'f6cd1c8dc5ed4d12ab9bd28725926046'),
(124,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzQwMSwiaWF0IjoxNzcwODcxMDAxLCJqdGkiOiI3ZDJmZjAwZmI2Zjc0YzgwYTRlMDk3MWM3NGIyYzdiZSIsInVzZXJfaWQiOjF9.K247M5WPOaGabkcS4h5wC7JmZxCmu4Ma9pC85LRlTts','2026-02-12 04:36:41.569228','2026-02-13 04:36:41.000000',1,'7d2ff00fb6f74c80a4e0971c74b2c7be'),
(125,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzUwOCwiaWF0IjoxNzcwODcxMTA4LCJqdGkiOiJmODEyNGExNzRhYjY0NzQzODhlNGQ3Yjc1NGIwOGU3YSIsInVzZXJfaWQiOjF9.CoQIDhAhg89JCNGRtVrdvpa_4DpQfcdOuic01Krjt8w','2026-02-12 04:38:28.721775','2026-02-13 04:38:28.000000',1,'f8124a174ab6474388e4d7b754b08e7a'),
(126,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzU3OCwiaWF0IjoxNzcwODcxMTc4LCJqdGkiOiI3OGNkNzk1N2FjODc0MDEwYjk3NjFjZWVkYWVlMGU1MyIsInVzZXJfaWQiOjF9.vJHA2GFhwkVm1YV4S8laBsevAEg4mCVQtpXUpQ5YGrE','2026-02-12 04:39:38.368596','2026-02-13 04:39:38.000000',1,'78cd7957ac874010b9761ceedaee0e53'),
(127,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzY3OCwiaWF0IjoxNzcwODcxMjc4LCJqdGkiOiJhOGE0NTYwZTNmZWM0ZjEyYWViOTJmMjZmYjJhMDhhNyIsInVzZXJfaWQiOjF9.9pkhvvUwtXkN9u55rRRkrEp0sIgaiV_xSC7Q068iC5E','2026-02-12 04:41:18.695610','2026-02-13 04:41:18.000000',1,'a8a4560e3fec4f12aeb92f26fb2a08a7'),
(128,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1NzczNiwiaWF0IjoxNzcwODcxMzM2LCJqdGkiOiJhODNjN2ZlMDc0ZTg0MmFhOGU0YTIwZjM1MDRmZGJjMiIsInVzZXJfaWQiOjF9.XENvHhV2NdBQgwaK3C4lqTzH57uTsKkPhiSdAwsuupo','2026-02-12 04:42:16.002543','2026-02-13 04:42:16.000000',1,'a83c7fe074e842aa8e4a20f3504fdbc2'),
(129,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1Nzc5NCwiaWF0IjoxNzcwODcxMzk0LCJqdGkiOiI4Nzk4NmNlNzNjY2E0YjY4YmYzMTlkMGNlNGE3ZWFlNiIsInVzZXJfaWQiOjF9.etEaSwofuE1BJPwdrnbIuCrspnl8RfW_G_74d1tAJ8M','2026-02-12 04:43:14.952229','2026-02-13 04:43:14.000000',1,'87986ce73cca4b68bf319d0ce4a7eae6'),
(130,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1ODExNSwiaWF0IjoxNzcwODcxNzE1LCJqdGkiOiJmZDFmYWFhNjU3Njk0ODkwODg0NzJiNDE0NmRmN2EwZSIsInVzZXJfaWQiOjF9.aVy7s-v4EEwTYl8x6MVUY0EwLShhKqdo9KZztREjDGg','2026-02-12 04:48:35.643458','2026-02-13 04:48:35.000000',1,'fd1faaa65769489088472b4146df7a0e'),
(131,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1ODI0OSwiaWF0IjoxNzcwODcxODQ5LCJqdGkiOiIyMzUwYmY3ZDA4ZGQ0ODcwYjFkMzBiMmM0NTY2NjFmMCIsInVzZXJfaWQiOjF9.BG-ogacnDBMQcILjQQArFd_8qjKxLTWOrf4LVBquTOc','2026-02-12 04:50:49.816510','2026-02-13 04:50:49.000000',1,'2350bf7d08dd4870b1d30b2c456661f0'),
(132,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MDk1ODU0MCwiaWF0IjoxNzcwODcyMTQwLCJqdGkiOiI0OGNlMTI3ZTAzNzc0ZDZhYTUzM2VlYWMyZGY2NTJjNyIsInVzZXJfaWQiOjF9.bBLuUJnfVCkutXcGTyfDtCrgXfeEXeMN7l4pbNTna98','2026-02-12 04:55:40.050451','2026-02-13 04:55:40.000000',1,'48ce127e03774d6aa533eeac2df652c7'),
(133,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzMzgzNiwiaWF0IjoxNzcwOTQ3NDM2LCJqdGkiOiJiMDNiM2JjMzlhZmI0YzI2OTIyODJmMDM1NTExYmQyZCIsInVzZXJfaWQiOjF9.9cVvHJTujsvYRwVwReMsv6RJqPKDGNhpE7n0YYRUyFQ','2026-02-13 01:50:36.876812','2026-02-14 01:50:36.000000',1,'b03b3bc39afb4c2692282f035511bd2d'),
(134,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNDU2MCwiaWF0IjoxNzcwOTQ4MTYwLCJqdGkiOiI2ZmQwZmEyOGMwNjM0ZGMzOTA2YWViZTU3NjdmZDdiZSIsInVzZXJfaWQiOjF9.8XmT38MyI7UYq2cAPd-8UQepT4ZKENlfTkss_H3ZoM8','2026-02-13 02:02:40.551291','2026-02-14 02:02:40.000000',1,'6fd0fa28c0634dc3906aebe5767fd7be'),
(135,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNDU5NiwiaWF0IjoxNzcwOTQ4MTk2LCJqdGkiOiJmYWI2NTI2YjkyMGU0MTU1YjhmODJiMTVjMTk5NWJkZSIsInVzZXJfaWQiOjF9.gP5w95bVtaWJuUPOUt0VLBJRZk7o7-WRkMoVyx-oDBo','2026-02-13 02:03:16.836022','2026-02-14 02:03:16.000000',1,'fab6526b920e4155b8f82b15c1995bde'),
(136,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNDc2MSwiaWF0IjoxNzcwOTQ4MzYxLCJqdGkiOiJhZWMxODFiODgzYjA0MjRjYWQ3ZTZlODZlYTk2MDU1MiIsInVzZXJfaWQiOjF9.iMEGB79kAb1a1-qoKlYxMiB33JLIQflX5yQe5RPEvy8','2026-02-13 02:06:01.835935','2026-02-14 02:06:01.000000',1,'aec181b883b0424cad7e6e86ea960552'),
(137,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTE0MSwiaWF0IjoxNzcwOTQ4NzQxLCJqdGkiOiJjNzAxNTI0NDQwODU0NTkwYjQyMjNmMjY0NGRmNjQ2MiIsInVzZXJfaWQiOjF9.Ifcb8qX1nf9poxjFvc1NRFxw9Vtk9QkBA9QURncdPTk','2026-02-13 02:12:21.025085','2026-02-14 02:12:21.000000',1,'c701524440854590b4223f2644df6462'),
(138,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTE0OSwiaWF0IjoxNzcwOTQ4NzQ5LCJqdGkiOiJiNmFiOWVjN2YyMDQ0NDEwOTRiODU4YjkxMWZjMzI0OSIsInVzZXJfaWQiOjF9.cTy4kZblQ3PG_nCMVmLDHvSzuC-XO9njWSFqpTjpKK4','2026-02-13 02:12:29.697157','2026-02-14 02:12:29.000000',1,'b6ab9ec7f204441094b858b911fc3249'),
(139,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTQzNCwiaWF0IjoxNzcwOTQ5MDM0LCJqdGkiOiI0Yzk2OTc0Nzk4MDk0YWFmOGQ1ZTM5YTUzMzU5NmEzMSIsInVzZXJfaWQiOjF9.2w0ukmEoxiPcs8kiAA7y9BU6JYm5fnp0355vSFLGrWQ','2026-02-13 02:17:14.045618','2026-02-14 02:17:14.000000',1,'4c96974798094aaf8d5e39a533596a31'),
(140,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTQ4NSwiaWF0IjoxNzcwOTQ5MDg1LCJqdGkiOiJjMjQ0YmFjMjdkNDg0YjM3OWRkZWI0MTMzMDk5NDIxMyIsInVzZXJfaWQiOjF9.Wtdrn6Tm_vl_gdV7f8dDmhlL3FzV8jRp900DBcnT4VA','2026-02-13 02:18:05.780935','2026-02-14 02:18:05.000000',1,'c244bac27d484b379ddeb41330994213'),
(141,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTcyMiwiaWF0IjoxNzcwOTQ5MzIyLCJqdGkiOiI4OTFlYTU2OTk1MmM0N2FiOTk5ZDFiNWViZWFjYzk3NSIsInVzZXJfaWQiOjF9.wmj5vLvDRiHl6koIGbG7A3eUrnrYsGB2iY5o95Tn0II','2026-02-13 02:22:02.234315','2026-02-14 02:22:02.000000',1,'891ea569952c47ab999d1b5ebeacc975'),
(142,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNTc0NCwiaWF0IjoxNzcwOTQ5MzQ0LCJqdGkiOiI3OWY1ODQyNzQzODY0Yzc2ODE1NjM0MjM5YzAyNGZlNSIsInVzZXJfaWQiOjF9.UClqBGc9_kMdI_a5bzAmVnLvvGzEcP0VBA1iV40Pc10','2026-02-13 02:22:24.243880','2026-02-14 02:22:24.000000',1,'79f5842743864c76815634239c024fe5'),
(143,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNzUyMSwiaWF0IjoxNzcwOTUxMTIxLCJqdGkiOiI2YTEwMjQ3YjY0OWU0YTk2OWI0Y2M3MjY5NTNhYWQxMyIsInVzZXJfaWQiOjF9.-fmOKe2fEJJfni8aaD37_ef3hx7-8AAljA2WHPXFTNc','2026-02-13 02:52:01.361623','2026-02-14 02:52:01.000000',1,'6a10247b649e4a969b4cc726953aad13'),
(144,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNzUzMSwiaWF0IjoxNzcwOTUxMTMxLCJqdGkiOiI5ZTU4N2ViOTc2NzA0ZTIzYmZkNTMxYTkyYmQ0NGNjNSIsInVzZXJfaWQiOjF9.Q63dVlNGUyjX2GwzsSUeHJFgT7n7wO_uR8kMAgJRaVA','2026-02-13 02:52:11.880403','2026-02-14 02:52:11.000000',1,'9e587eb976704e23bfd531a92bd44cc5'),
(145,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNzU0MSwiaWF0IjoxNzcwOTUxMTQxLCJqdGkiOiIyZGU3MmQ5YmU1MGU0ZWM4OTUyODNmODBiNTQ3ODM2NiIsInVzZXJfaWQiOjF9.m7Wjsoaz2W0wL74oDqB2JLSbZP7Hj54rYIT6UV9Miug','2026-02-13 02:52:21.992528','2026-02-14 02:52:21.000000',1,'2de72d9be50e4ec895283f80b5478366'),
(146,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzNzU4NCwiaWF0IjoxNzcwOTUxMTg0LCJqdGkiOiJmNTZmY2IwZmUzY2U0Njk4OTZiMmQyZGQ3OGIyMTVkOCIsInVzZXJfaWQiOjF9.v-wml2sObx27GNIGBqNF_EXC7dTrv0jpN8YOebCbubw','2026-02-13 02:53:04.417689','2026-02-14 02:53:04.000000',1,'f56fcb0fe3ce469896b2d2dd78b215d8'),
(147,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzODYzOSwiaWF0IjoxNzcwOTUyMjM5LCJqdGkiOiJiMDcwYTgzMWQwZTQ0NWRhOGI2Mjk5OWU1OTk2NDk5MSIsInVzZXJfaWQiOjF9.28b5eV6N18SDwIGDYkMR4-3Bg8A-L8jH68PO39PEheY','2026-02-13 03:10:39.805595','2026-02-14 03:10:39.000000',1,'b070a831d0e445da8b62999e59964991'),
(148,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTAzOTYzOSwiaWF0IjoxNzcwOTUzMjM5LCJqdGkiOiJkYWNlMjM3NWVmYmI0NWQxOGM1NjYxMTg2M2U5YmEzNSIsInVzZXJfaWQiOjF9.zc6QGin8hGoRoutVFVNhi46fQtk9mWlLHk4i4AUtKIc','2026-02-13 03:27:19.276498','2026-02-14 03:27:19.000000',1,'dace2375efbb45d18c56611863e9ba35'),
(149,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA0MDI4MiwiaWF0IjoxNzcwOTUzODgyLCJqdGkiOiJhZDExY2FhMjE1Yzg0NWQzODlmMzgxMjE4N2FiNzFkYyIsInVzZXJfaWQiOjF9.cztNRaKGVevYAioWLXavaQ7ZabYCdBDKZBI6AbF2w6w','2026-02-13 03:38:02.624263','2026-02-14 03:38:02.000000',1,'ad11caa215c845d389f3812187ab71dc'),
(150,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA0MDU3OSwiaWF0IjoxNzcwOTU0MTc5LCJqdGkiOiIzNjM5Zjc2OTczMWU0ZTJlYjRiNzFhZTMwYzY5MjVkMyIsInVzZXJfaWQiOjF9.Akj5016d-FVaFS4O1QABaBIjR6yO9mjPfOTCbfn53LA','2026-02-13 03:42:59.667144','2026-02-14 03:42:59.000000',1,'3639f769731e4e2eb4b71ae30c6925d3'),
(151,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA0MDkyOCwiaWF0IjoxNzcwOTU0NTI4LCJqdGkiOiI5YTk4ZWExYzc5NGU0NjE1YmI5NmJhYTY1NzcyMGNlMCIsInVzZXJfaWQiOjF9.0lmJfHFDDpmebXc7DOoZ-CNbgZ3Q6SOGorh3tANdzkU','2026-02-13 03:48:48.403800','2026-02-14 03:48:48.000000',1,'9a98ea1c794e4615bb96baa657720ce0'),
(152,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA4MTg2NCwiaWF0IjoxNzcwOTk1NDY0LCJqdGkiOiIxYzRhMmRjYjkwMjc0ZDYxYjYyNzU1ZThlMjIxZjUxMSIsInVzZXJfaWQiOjF9.Jwo9Nx5m_18oUD1fjSEPSyn9hTB6032iW__O5oWkgbc','2026-02-13 15:11:04.105606','2026-02-14 15:11:04.000000',1,'1c4a2dcb90274d61b62755e8e221f511'),
(153,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA4Mjc1NiwiaWF0IjoxNzcwOTk2MzU2LCJqdGkiOiIwZmFiZmRlNDMwNDU0YmU0YmExYjQ1ZjJmMWI3YTExMCIsInVzZXJfaWQiOjF9.ljJh4zLTai7EnKUsixdFy8SE4I-7lP4yQhLGkIgrDE0','2026-02-13 15:25:56.502205','2026-02-14 15:25:56.000000',1,'0fabfde430454be4ba1b45f2f1b7a110'),
(154,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTA4NDkwNywiaWF0IjoxNzcwOTk4NTA3LCJqdGkiOiJhYjJhNmNmYmU4NzU0ZGVjODA5NTlhNjVlNjc4NzQ4ZSIsInVzZXJfaWQiOjF9.qH9ORlEedU-4s9fSO28gJr6iUUF5NOwoTAMBHVbWHfw','2026-02-13 16:01:47.199823','2026-02-14 16:01:47.000000',1,'ab2a6cfbe8754dec80959a65e678748e'),
(155,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTEyMTMxMiwiaWF0IjoxNzcxMDM0OTEyLCJqdGkiOiJlZGM3ZDg1ZTA2ZmE0MTM1OWZkMDQ1MTVlMjRkMWQ3ZSIsInVzZXJfaWQiOjF9.tCE5uUN70RKvnmLNzMdgsupapubsEupDJF3n4mE_VaU','2026-02-14 02:08:32.512720','2026-02-15 02:08:32.000000',1,'edc7d85e06fa41359fd04515e24d1d7e'),
(156,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTEyNTE2MCwiaWF0IjoxNzcxMDM4NzYwLCJqdGkiOiI2MWY4MTEwMWY5MjQ0NjQ0YmY1YWM4MDg3NWI5MjI4ZiIsInVzZXJfaWQiOjF9.PM_5ucCRp-hP4R8Jcu_k-8lo0qCdVl5MBJ0O0xHdrfQ','2026-02-14 03:12:40.722733','2026-02-15 03:12:40.000000',1,'61f81101f9244644bf5ac80875b9228f'),
(157,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTEzMDczNCwiaWF0IjoxNzcxMDQ0MzM0LCJqdGkiOiJjMTY3ODY5Yjc1MmY0ZTAxYTE3ODg2MmE3MmMwNGNjMSIsInVzZXJfaWQiOjF9.TXTnnUlKcoDDkCR_XAUvkv9eVZXuvfAYcB0de_xUUZA','2026-02-14 04:45:34.679513','2026-02-15 04:45:34.000000',1,'c167869b752f4e01a178862a72c04cc1'),
(158,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3MjY4OSwiaWF0IjoxNzcxMDg2Mjg5LCJqdGkiOiJmYjBiYzhlY2Q2MTU0YWU1ODI1YTBjYTZkYmFkZmMzYyIsInVzZXJfaWQiOjF9.CsZ1O6B-ZZagYVUdMuVkclt3_lZe9RMxZgfB-idAopI','2026-02-14 16:24:49.996557','2026-02-15 16:24:49.000000',1,'fb0bc8ecd6154ae5825a0ca6dbadfc3c'),
(159,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NTQ3NywiaWF0IjoxNzcxMDg5MDc3LCJqdGkiOiJiMTU1NmQzMTRlNTA0MjQzYmIyOGQ4ODA4ZjJlYTFlNiIsInVzZXJfaWQiOjF9.K0ETCHcaWzlX3Hw26zDnQwxGJmMGL454KCcj1tC5_eo','2026-02-14 17:11:17.567411','2026-02-15 17:11:17.000000',1,'b1556d314e504243bb28d8808f2ea1e6'),
(160,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NTQ4OCwiaWF0IjoxNzcxMDg5MDg4LCJqdGkiOiJhZGFmMTgxYWIzZWU0NjBmOGY1NmZiOWFiNmRmNGJkMiIsInVzZXJfaWQiOjF9.7OJWvBLWioTZU8pGj11eBPkzkjnqIVV-5zX1C7AfesY','2026-02-14 17:11:28.333287','2026-02-15 17:11:28.000000',1,'adaf181ab3ee460f8f56fb9ab6df4bd2'),
(161,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NTUwMSwiaWF0IjoxNzcxMDg5MTAxLCJqdGkiOiJmZTcyOGIzMjg0MGM0Mzk3YjY0ODBjOWJjMzc4NjEwOSIsInVzZXJfaWQiOjF9.GXLsEjelIWJERFYqG5auKt-J8L9ddEDaF1bt1BNajmk','2026-02-14 17:11:41.905732','2026-02-15 17:11:41.000000',1,'fe728b32840c4397b6480c9bc3786109'),
(162,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NTU0NCwiaWF0IjoxNzcxMDg5MTQ0LCJqdGkiOiIyZDRkOTYzMzc1MTQ0Y2IzYTEzMzYwNTAxY2UwZDQ2MiIsInVzZXJfaWQiOjF9.cjhVrPTE7CY5PTlte2RQBODNuXkA5ovjDE1GnuatX8M','2026-02-14 17:12:24.248930','2026-02-15 17:12:24.000000',1,'2d4d963375144cb3a13360501ce0d462'),
(163,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NTU1NCwiaWF0IjoxNzcxMDg5MTU0LCJqdGkiOiJiMTM4MjYxNDAyNjc0Nzc4OTE5OGY1NzdiMWNlN2Y2ZCIsInVzZXJfaWQiOjF9.l-Wsqim5qAtsfW67RFtG9rKrPBlwGm_Zot1eq9AoguU','2026-02-14 17:12:34.338234','2026-02-15 17:12:34.000000',1,'b1382614026747789198f577b1ce7f6d'),
(164,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3Njc4MSwiaWF0IjoxNzcxMDkwMzgxLCJqdGkiOiIyNjQ3MWU1MTA4MGQ0MzI5YjQ2YjBkZjYxNzYzMWQzOSIsInVzZXJfaWQiOjF9.LpsmZq7WyvVQlmbrKFMJie1RdtOLeAobMmD1nwgYFlc','2026-02-14 17:33:01.598588','2026-02-15 17:33:01.000000',1,'26471e51080d4329b46b0df617631d39'),
(165,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NjgzMiwiaWF0IjoxNzcxMDkwNDMyLCJqdGkiOiIzZGIxMWZkOGEzMTU0NThmYWU5ZjdlZGQ3NjYxMzE3MSIsInVzZXJfaWQiOjF9.OwD5WkxZqjud7_dKIvohZZ2vGunJLd-bTDMz9MZWv-o','2026-02-14 17:33:52.644057','2026-02-15 17:33:52.000000',1,'3db11fd8a315458fae9f7edd76613171'),
(166,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3Njg1NSwiaWF0IjoxNzcxMDkwNDU1LCJqdGkiOiJhNmY4MzA0ZWQwZTk0NTczYWM1ZTAwMWQ0ZGJmMzg0NSIsInVzZXJfaWQiOjF9.0a6sjlGdnA4jciZcanhdCoJu4cEI4iGitI4zPS1vxz0','2026-02-14 17:34:15.817591','2026-02-15 17:34:15.000000',1,'a6f8304ed0e94573ac5e001d4dbf3845'),
(167,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3Njg2NCwiaWF0IjoxNzcxMDkwNDY0LCJqdGkiOiI3Y2RiYWFiNWEwOTY0MDMxOTg5MWQ2MmMzYzI3NmZmNyIsInVzZXJfaWQiOjF9.fL56hbUEmBglZizZGQ0qzgM6kBVy3MNKTw935g697Y4','2026-02-14 17:34:24.496607','2026-02-15 17:34:24.000000',1,'7cdbaab5a09640319891d62c3c276ff7'),
(168,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3NjkxMiwiaWF0IjoxNzcxMDkwNTEyLCJqdGkiOiJmMDU3MWU0N2QxNjE0NTNlYjRmNjYyOWM3ZjlmMjYyMCIsInVzZXJfaWQiOjF9.ZFaHoH-eBOgcNlGeygy4LTouCfrfyso8ipVM2mJLg74','2026-02-14 17:35:12.216942','2026-02-15 17:35:12.000000',1,'f0571e47d161453eb4f6629c7f9f2620'),
(169,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTE3ODE2OSwiaWF0IjoxNzcxMDkxNzY5LCJqdGkiOiJkMmEzNjJlMTJlZTI0NmEzOTMwYTA1MTY5MzJhNDUzMSIsInVzZXJfaWQiOjF9.dH9GKF-hztJmI2cpDu16l3WmxAaLFbO6kCcaMzXGy3I','2026-02-14 17:56:09.464425','2026-02-15 17:56:09.000000',1,'d2a362e12ee246a3930a0516932a4531'),
(170,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5Mjk4MCwiaWF0IjoxNzcxMjA2NTgwLCJqdGkiOiIyOTM5YzEyZWExMTI0NzU1OGM4MWM1ZmMzODcxMjk5YyIsInVzZXJfaWQiOjF9.bVSjqYEQhvmhk_7qhEulFRSr6yl88JS2temSMszz3s8','2026-02-16 01:49:40.035652','2026-02-17 01:49:40.000000',1,'2939c12ea11247558c81c5fc3871299c'),
(171,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NDI1MSwiaWF0IjoxNzcxMjA3ODUxLCJqdGkiOiJmYWUzZmM5MmMzMmU0MGIwOWQyYjUwMzI0ZGVhM2NlNCIsInVzZXJfaWQiOjF9.1mreUGkrgEX09TVIMPwtvdKK62dg9Fo62indEA0kOOc','2026-02-16 02:10:51.631873','2026-02-17 02:10:51.000000',1,'fae3fc92c32e40b09d2b50324dea3ce4'),
(172,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NDU2NCwiaWF0IjoxNzcxMjA4MTY0LCJqdGkiOiI2YmU3ZjI4NzgyM2Q0ZWM4ODhhNWUzN2EwMTAxM2U0NCIsInVzZXJfaWQiOjF9.nO7CXx64kmqRwSK9-31B5w8VcimnKkFPHpEY80TYZ7A','2026-02-16 02:16:04.559258','2026-02-17 02:16:04.000000',1,'6be7f287823d4ec888a5e37a01013e44'),
(173,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NDY0MCwiaWF0IjoxNzcxMjA4MjQwLCJqdGkiOiJmMWZkNjA3N2M5MDM0NzM5ODIxZjNjZDMwMDkyMzg2NSIsInVzZXJfaWQiOjF9.p_BNZWIl-X_Ro16DfG1ZRF1HEFm4q-5UrWOceZoE_Ag','2026-02-16 02:17:20.622196','2026-02-17 02:17:20.000000',1,'f1fd6077c9034739821f3cd300923865'),
(174,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NDcyOSwiaWF0IjoxNzcxMjA4MzI5LCJqdGkiOiJiOGUxMWUzNWIzOTc0MWZmYTkyNTUwMDRlMzE1OTk4NSIsInVzZXJfaWQiOjF9.RjnhwcEfPkerdI3lWS7GeHZvQf9MRryCmgX2_XajLk0','2026-02-16 02:18:49.721023','2026-02-17 02:18:49.000000',1,'b8e11e35b39741ffa9255004e3159985'),
(175,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NTI3NiwiaWF0IjoxNzcxMjA4ODc2LCJqdGkiOiI2ODAxYmRiYWYxZWM0MGZkOTY2NzM5ZDNhMTlhMWZlMiIsInVzZXJfaWQiOjF9.c-bSxQuXI_Z9ydHgNFbvwkdvVP-pz0Z8Q6eXfgneY6M','2026-02-16 02:27:56.408679','2026-02-17 02:27:56.000000',1,'6801bdbaf1ec40fd966739d3a19a1fe2'),
(176,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NjU1NywiaWF0IjoxNzcxMjEwMTU3LCJqdGkiOiI0YTIwYjk1ZTMxZjE0YzY3YmQ0ZTdlYTgxOWQ2MDZmZiIsInVzZXJfaWQiOjF9.SxHAN9zGMkDXXm_eKEhJ3GrMx-WNaphIaSIiiUcsRuc','2026-02-16 02:49:17.181891','2026-02-17 02:49:17.000000',1,'4a20b95e31f14c67bd4e7ea819d606ff'),
(177,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5Njc4MywiaWF0IjoxNzcxMjEwMzgzLCJqdGkiOiJmYzgzZDk1M2FjZTg0MDQyYjc0MGE1NTJkMGQ3OTgxYyIsInVzZXJfaWQiOjF9.sUZ0GPYMd6uRBDv1Rk2bhJ_4BSUWhg2c_Hc2SR2pLiQ','2026-02-16 02:53:03.857156','2026-02-17 02:53:03.000000',1,'fc83d953ace84042b740a552d0d7981c'),
(178,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5NzA2OSwiaWF0IjoxNzcxMjEwNjY5LCJqdGkiOiJhNzg5NWRkYjFlMjA0NzIzYmU2ZmQ5N2JjODY5MjMwMSIsInVzZXJfaWQiOjF9.ALeWIAyAj3JlxaI5y7FMZ3psmcFYJEA9UinEHyHEArI','2026-02-16 02:57:49.260249','2026-02-17 02:57:49.000000',1,'a7895ddb1e204723be6fd97bc8692301'),
(179,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5ODQ4OCwiaWF0IjoxNzcxMjEyMDg4LCJqdGkiOiJhYzY1OTkyYzY2ZjE0YjFjOGMwZGY3NDY3MDAyYzZlNCIsInVzZXJfaWQiOjF9.Mpxh7vtcP7BDKbDPllzqL2uFr4ei6V4Vmw13hVi6vN0','2026-02-16 03:21:28.304048','2026-02-17 03:21:28.000000',1,'ac65992c66f14b1c8c0df7467002c6e4'),
(180,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5ODUwMiwiaWF0IjoxNzcxMjEyMTAyLCJqdGkiOiJjOTViMDM0OTc4N2Y0NTQ2YmQ3MjRhZTZlOGVmYTAzOSIsInVzZXJfaWQiOjF9.ufYC0x-_JjXzq80d-70gEhWW8-kcsHgK7CN5bYxvq9A','2026-02-16 03:21:42.632170','2026-02-17 03:21:42.000000',1,'c95b0349787f4546bd724ae6e8efa039'),
(181,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5ODYxMSwiaWF0IjoxNzcxMjEyMjExLCJqdGkiOiJiYWM1NzkzMjE1M2Q0NGExYTk4YTY0OWM4NDA2NmEyNCIsInVzZXJfaWQiOjF9.e9J4NfY7VaWEyjxX1re5g-QG_FzSf6U4IxUOc04jTmM','2026-02-16 03:23:31.848635','2026-02-17 03:23:31.000000',1,'bac57932153d44a1a98a649c84066a24'),
(182,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5OTQzMCwiaWF0IjoxNzcxMjEzMDMwLCJqdGkiOiIyMDc2ZmY3N2QwNGI0ZTQyOWVhOTRlZTRhZDU0NWQzYyIsInVzZXJfaWQiOjF9.VS2logXniRRQ1URjhKVHI8-zWW2uscj_avE3Kbv0J9I','2026-02-16 03:37:10.435842','2026-02-17 03:37:10.000000',1,'2076ff77d04b4e429ea94ee4ad545d3c'),
(183,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTI5OTU1OSwiaWF0IjoxNzcxMjEzMTU5LCJqdGkiOiIzZWEwNWI3NmM0YTg0NDcwODBiOTA1YjQ1MjYxNTcyYiIsInVzZXJfaWQiOjF9.MbkBIvFOlpwfyrj0m7q3HduzRpaxDdhcZ-JFq9Ol7do','2026-02-16 03:39:19.318302','2026-02-17 03:39:19.000000',1,'3ea05b76c4a8447080b905b45261572b'),
(184,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTMwMDA3MiwiaWF0IjoxNzcxMjEzNjcyLCJqdGkiOiIxMDc1ZjgzN2ZhOWQ0MDM4YTcxYWRhNDMzOTA5Mjc3MCIsInVzZXJfaWQiOjF9.hS4QHFW5982ybsWhs6DDih0Z5YMSlr-um8It-UWgqmw','2026-02-16 03:47:52.758021','2026-02-17 03:47:52.000000',1,'1075f837fa9d4038a71ada4339092770'),
(185,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTMwMDQ1MywiaWF0IjoxNzcxMjE0MDUzLCJqdGkiOiJhYmEwM2U2YzQ4ZWI0Y2RlOGFlZDYzNmY3NjE3Y2M5ZSIsInVzZXJfaWQiOjF9.AKxhqTtb_zu8W8T5AyMD-c33H31wFVDhIrvapoEimkY','2026-02-16 03:54:13.953948','2026-02-17 03:54:13.000000',1,'aba03e6c48eb4cde8aed636f7617cc9e'),
(186,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTMwMDcxMywiaWF0IjoxNzcxMjE0MzEzLCJqdGkiOiJkNmE4OWEwYjczODk0YjM4ODhhMmI1MmQzZTI3NjFkMSIsInVzZXJfaWQiOjF9.lxDDH2E6VGXtoFnhYWm8ZxYsit5xnMx26C2-zRQT_Xw','2026-02-16 03:58:33.398397','2026-02-17 03:58:33.000000',1,'d6a89a0b73894b3888a2b52d3e2761d1'),
(187,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTkzNjc5MSwiaWF0IjoxNzcxODUwMzkxLCJqdGkiOiJhZWJiYmQ2ZjJhM2E0MjBlODhjMDZhY2U1ZWUyYWRkMyIsInVzZXJfaWQiOjF9.psQujAg8wXVKqGgDbaYaIadKAt4OzpFqvxnmFAqO_f0','2026-02-23 12:39:51.815164','2026-02-24 12:39:51.000000',1,'aebbbd6f2a3a420e88c06ace5ee2add3'),
(188,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0MjI3MSwiaWF0IjoxNzcxODU1ODcxLCJqdGkiOiI5ZjhlOTA3ZGFiNjE0N2EyOTRiODViOGQ1OGQ4YmFlZCIsInVzZXJfaWQiOjF9.-GabhJLMCR1_hcOnH_sE1danOCVApWBfpJvVc3AfmvY','2026-02-23 14:11:11.257222','2026-02-24 14:11:11.000000',1,'9f8e907dab6147a294b85b8d58d8baed'),
(189,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NDcxMiwiaWF0IjoxNzcxODU4MzEyLCJqdGkiOiJlMjFjNTFhZjdhZWM0MDM1YmI0MmU4NjY3MjI1Y2E1MiIsInVzZXJfaWQiOjF9.jNx6FetUYMWYlwyZ6756moocu2tS2crtU9x-Db6byC4','2026-02-23 14:51:52.674276','2026-02-24 14:51:52.000000',1,'e21c51af7aec4035bb42e8667225ca52'),
(190,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NDc0MCwiaWF0IjoxNzcxODU4MzQwLCJqdGkiOiJhZTcwNGE5MDQzYWQ0Zjc2OTRmMDljYTY4MWIwOGFmYSIsInVzZXJfaWQiOjN9.Bh6gtPuA1AixCuFOZ9tVmY3Uw5OVjYhBySLgiw0hFqI','2026-02-23 14:52:20.115113','2026-02-24 14:52:20.000000',3,'ae704a9043ad4f7694f09ca681b08afa'),
(191,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NTEwOSwiaWF0IjoxNzcxODU4NzA5LCJqdGkiOiI0NTc0N2ZiM2IwMjM0MThhYTc0ZjBkN2RmNTE0MDdkNyIsInVzZXJfaWQiOjF9.fkZdO7YGlVcRMeWsTMxHgXqu4P7rBvV76z87h9qBAlo','2026-02-23 14:58:29.887362','2026-02-24 14:58:29.000000',1,'45747fb3b023418aa74f0d7df51407d7'),
(192,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NTEyOCwiaWF0IjoxNzcxODU4NzI4LCJqdGkiOiI2OWEwNTk5OGQxMWM0YjY4YjExNDJjZmM4MGE5ZmNkNiIsInVzZXJfaWQiOjF9.8aymDcmmWRRd71AkRB_BmbmTq6z4aCRHL7a-1jvpBUI','2026-02-23 14:58:48.974225','2026-02-24 14:58:48.000000',1,'69a05998d11c4b68b1142cfc80a9fcd6'),
(193,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NTEzNywiaWF0IjoxNzcxODU4NzM3LCJqdGkiOiIyOGFjMjg4NjJkNmY0ZWQzODViZmY1MDI1NGJkNzRkMSIsInVzZXJfaWQiOjF9.5e6GwKdwAE_LjSnUWbrw9zCedWDpJ3zNy8pazyw5cLI','2026-02-23 14:58:57.126959','2026-02-24 14:58:57.000000',1,'28ac28862d6f4ed385bff50254bd74d1'),
(194,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NjAyNiwiaWF0IjoxNzcxODU5NjI2LCJqdGkiOiJiMDUzYzg1NmNkYzY0YmQ1YTRiN2JkMmY5ZDk1YTg1MiIsInVzZXJfaWQiOjF9.g5xi9vCfPWHozo8db8ru8aM-ZOot2sBn9LVgibivPcs','2026-02-23 15:13:46.825857','2026-02-24 15:13:46.000000',1,'b053c856cdc64bd5a4b7bd2f9d95a852'),
(195,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NjM1NywiaWF0IjoxNzcxODU5OTU3LCJqdGkiOiIyNzEzN2Y3M2FjNGI0MjFlYjkzZDc3OWYyNGExYjVhOCIsInVzZXJfaWQiOjF9.QfKbbHta3F1PAMxJzy1PN6BkZJj0rBlCRBluGyt46E8','2026-02-23 15:19:17.144380','2026-02-24 15:19:17.000000',1,'27137f73ac4b421eb93d779f24a1b5a8'),
(196,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NjQ1NCwiaWF0IjoxNzcxODYwMDU0LCJqdGkiOiJjYzQyMjllNWM1N2Q0MzY5OGUzMWMwODg3MTlmZDJhNSIsInVzZXJfaWQiOjF9.2fGbKxdgZ5YPz_Rv9VMTcN60e7KYUzqdEEI26jXQXEc','2026-02-23 15:20:54.541359','2026-02-24 15:20:54.000000',1,'cc4229e5c57d43698e31c088719fd2a5'),
(197,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NjkxNCwiaWF0IjoxNzcxODYwNTE0LCJqdGkiOiIzYTJiMmY0ZDY1OTk0ZWJmYjFiOGI0YzdlYjBmOWU1YyIsInVzZXJfaWQiOjN9.Ps5n5HDfz8U3YfB-bOZE-Ws1aoW4NBG3_kYYr22XUfc','2026-02-23 15:28:34.184980','2026-02-24 15:28:34.000000',3,'3a2b2f4d65994ebfb1b8b4c7eb0f9e5c'),
(198,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NzM3NSwiaWF0IjoxNzcxODYwOTc1LCJqdGkiOiI3MDAyMmY1ZTAyZjc0NDI5OTRjMWFmNzQwNTc2ZjUzNiIsInVzZXJfaWQiOjF9.IPcH1gBTXLYCxvJkWrsKqfc7NvBbTAbtLY6eK7r3n1s','2026-02-23 15:36:15.325721','2026-02-24 15:36:15.000000',1,'70022f5e02f7442994c1af740576f536'),
(199,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0NzQwOSwiaWF0IjoxNzcxODYxMDA5LCJqdGkiOiJjMDI3ZDZlNDEzZjA0MTQxYTY3ZDM5YmE5MzI4ZmZhYyIsInVzZXJfaWQiOjN9.kV2JYkGUZWFczNiEGWXKUFXEaaoldkRBNJAg7DTKHxA','2026-02-23 15:36:49.483364','2026-02-24 15:36:49.000000',3,'c027d6e413f04141a67d39ba9328ffac'),
(200,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0ODMxMiwiaWF0IjoxNzcxODYxOTEyLCJqdGkiOiJmODEzMzFlZmNhZDE0ZjljYjJjZTdhMjk1ODQ2ZDJjMCIsInVzZXJfaWQiOjF9.UYOYnr69ZrmVFZoPoN55vgyPtLidM9Ha3N-RRLgHqrc','2026-02-23 15:51:52.125684','2026-02-24 15:51:52.000000',1,'f81331efcad14f9cb2ce7a295846d2c0'),
(201,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0ODMyMywiaWF0IjoxNzcxODYxOTIzLCJqdGkiOiJlNWQ3OGU0Y2ZkYmE0MDgzYjYyZTkwMTBhOWYzMzQ0ZSIsInVzZXJfaWQiOjN9.NaD6cKY0Wn4sIhRAg6-khBga3UMum-NMeP18E-mmNcY','2026-02-23 15:52:03.421246','2026-02-24 15:52:03.000000',3,'e5d78e4cfdba4083b62e9010a9f3344e'),
(202,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk0ODgxMywiaWF0IjoxNzcxODYyNDEzLCJqdGkiOiI0ZmFkYmJkMjI1ZmU0NDNjYjRkMWQwZmRlOTgwMjcxOCIsInVzZXJfaWQiOjN9.GwnBHk2mxtXBKCW2OmC1ZuoU9GkMVKAlyJI4c2mV3ZI','2026-02-23 16:00:13.127726','2026-02-24 16:00:13.000000',3,'4fadbbd225fe443cb4d1d0fde9802718'),
(203,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTAzNywiaWF0IjoxNzcxODY0NjM3LCJqdGkiOiJjYmRiMTBiOTAzNzE0Y2E5YjliMzFhMzQ0MWI0Njg0MiIsInVzZXJfaWQiOjN9.x82OGCTnC6QLAoMWwd3CWQHt9aMfYWmRAdH29ZFUihw','2026-02-23 16:37:17.499714','2026-02-24 16:37:17.000000',3,'cbdb10b903714ca9b9b31a3441b46842'),
(204,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTEwMywiaWF0IjoxNzcxODY0NzAzLCJqdGkiOiI4MzBlZjk5NTNiOTU0ODkwOGZjNmRmYzFmZmE5MDY0MiIsInVzZXJfaWQiOjN9.bexoBZGPTr5CwZijfXDRIAcMJgC_JeZHOh3ibCFqaHo','2026-02-23 16:38:23.948036','2026-02-24 16:38:23.000000',3,'830ef9953b9548908fc6dfc1ffa90642'),
(205,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTEyNywiaWF0IjoxNzcxODY0NzI3LCJqdGkiOiJkNTA5YTM0YjY0OTE0Yjk1OGFjZWQxYWUzNmZjYmZhMyIsInVzZXJfaWQiOjN9.mu9su-s7Bn7vPJesqwDfjnA5nb_frl7hHFNMSA5LuXQ','2026-02-23 16:38:47.756921','2026-02-24 16:38:47.000000',3,'d509a34b64914b958aced1ae36fcbfa3'),
(206,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTE0MCwiaWF0IjoxNzcxODY0NzQwLCJqdGkiOiI1MWQ4NmNmNjEwMzk0ZmMwODJkOTVkNGVkOTQ2NzI1NCIsInVzZXJfaWQiOjN9.BR9YmBpPv11mlg39j-9UbkAE62MIIGfiJsCVFSoKYoc','2026-02-23 16:39:00.192912','2026-02-24 16:39:00.000000',3,'51d86cf610394fc082d95d4ed9467254'),
(207,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTY4MSwiaWF0IjoxNzcxODY1MjgxLCJqdGkiOiI2ZGE4MDZlMTIxODc0ZWFjYTEzZTVjY2RjMjAyM2EwNiIsInVzZXJfaWQiOjN9.D4kaT5gYZq6TLuTd6DIdgG66KuJhGVz-3ydcR6CQVxs','2026-02-23 16:48:01.261691','2026-02-24 16:48:01.000000',3,'6da806e121874eaca13e5ccdc2023a06'),
(208,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MTY5NSwiaWF0IjoxNzcxODY1Mjk1LCJqdGkiOiI5NzU4NTgyMjQzMmU0NTc4OWUwYzgwMTMzZDU2YzUwOCIsInVzZXJfaWQiOjN9.ZF2SRRkAZ0ZEFo0By11a6fwKXsPnGWJQ6s_fVVq8pYA','2026-02-23 16:48:15.514364','2026-02-24 16:48:15.000000',3,'97585822432e45789e0c80133d56c508'),
(209,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MjYzOCwiaWF0IjoxNzcxODY2MjM4LCJqdGkiOiJiOWZiYjE1NGMxOGY0ZTIxOGRjOTc2ZjkwNjIyOTA2ZCIsInVzZXJfaWQiOjJ9.OWpHZkMnx16X9Ozvy-z8Zw88Gd1US_iUgkLKINzrfFE','2026-02-23 17:03:58.846365','2026-02-24 17:03:58.000000',2,'b9fbb154c18f4e218dc976f90622906d'),
(210,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1Mjc5MywiaWF0IjoxNzcxODY2MzkzLCJqdGkiOiIyYjg4ZTY0M2MzNTE0MGMyYjJiMDRlNjNjMjdmOTVhMCIsInVzZXJfaWQiOjN9.Kd746Fu7HY6_VJjlV7MkHmcE0gfL-Iy05vGsd8Zbics','2026-02-23 17:06:33.016158','2026-02-24 17:06:33.000000',3,'2b88e643c35140c2b2b04e63c27f95a0'),
(211,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1Mjg1NSwiaWF0IjoxNzcxODY2NDU1LCJqdGkiOiJhMDU4MTIwNjMyMGI0NzRhYmI4NGQxNTdiMmM2ZjE0NyIsInVzZXJfaWQiOjF9.dgpMWc1J-2bEp-iCY1qfixGxlw43O2pfNqJWLJJ2cdQ','2026-02-23 17:07:35.501151','2026-02-24 17:07:35.000000',1,'a0581206320b474abb84d157b2c6f147'),
(212,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1NTIyNywiaWF0IjoxNzcxODY4ODI3LCJqdGkiOiJmYzZlMjcxMTMxNjI0OWE0YjM2Mjc4ZTE0MWMxYjUyMCIsInVzZXJfaWQiOjF9.08LFzUAGQON7T7iUvQLmob2C4oEsObptHkimJZrHjsw','2026-02-23 17:47:07.161811','2026-02-24 17:47:07.000000',1,'fc6e2711316249a4b36278e141c1b520'),
(213,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk4NDYzMSwiaWF0IjoxNzcxODk4MjMxLCJqdGkiOiJiOTViM2U3NzQ4YTI0MGQxYjFhNWRiZTdiYTg4NWU0ZiIsInVzZXJfaWQiOjF9.UUPGss9vRPQrjlgPu6cCY2nuv6wsJsvka223TmrHcPk','2026-02-24 01:57:11.923436','2026-02-25 01:57:11.000000',1,'b95b3e7748a240d1b1a5dbe7ba885e4f'),
(214,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjAzMjI0NSwiaWF0IjoxNzcxOTQ1ODQ1LCJqdGkiOiJlYzM0YjkwZDYwNmI0ZTc0OTZhYmJkY2QzOWI3N2Q5NyIsInVzZXJfaWQiOjF9.RnWvfvKJIQph0Nf6hk4hfMp8a27gVRJyrN_h8UDLxsQ','2026-02-24 15:10:45.266877','2026-02-25 15:10:45.000000',1,'ec34b90d606b4e7496abbdcd39b77d97'),
(215,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjAzNDg0MiwiaWF0IjoxNzcxOTQ4NDQyLCJqdGkiOiI4YTMwMTA4ZWYzMzE0MmQ2OTA1MmJiOGE2ZmQxOTM4NSIsInVzZXJfaWQiOjF9.7SNthV6_mkP7MakpPwYYoN8yQKl_FEAJSsWcCZiMGxw','2026-02-24 15:54:02.537722','2026-02-25 15:54:02.000000',1,'8a30108ef33142d69052bb8a6fd19385'),
(216,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjAzNDg1OCwiaWF0IjoxNzcxOTQ4NDU4LCJqdGkiOiI0NzcyNmViODBjNmY0ZjcwYWE1ZTNmODEwY2QxMmVkZiIsInVzZXJfaWQiOjF9.vUYDTPERTVF6xgz_q_x47xJRnlCHsKHSPoNW7Pu9kpw','2026-02-24 15:54:18.282174','2026-02-25 15:54:18.000000',1,'47726eb80c6f4f70aa5e3f810cd12edf'),
(217,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjAzNDg3MSwiaWF0IjoxNzcxOTQ4NDcxLCJqdGkiOiJiYmQyNzA2MDQyODU0ZDkxODk2NDA2NGE5MDJjZTM1ZiIsInVzZXJfaWQiOjF9.yDEQp-TvmPHzjJKh_yn8LPFTW5-Cr9YqdndCUKgkXzA','2026-02-24 15:54:31.383401','2026-02-25 15:54:31.000000',1,'bbd2706042854d918964064a902ce35f');
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `role` varchar(30) NOT NULL,
  `roll_number` varchar(50) DEFAULT NULL,
  `failed_login_attempts` int(11) NOT NULL,
  `locked_until` datetime(6) DEFAULT NULL,
  `branch` varchar(50) DEFAULT NULL,
  `can_manage_users` tinyint(1) NOT NULL,
  `can_view_all_branches` tinyint(1) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `is_active_user` tinyint(1) NOT NULL,
  `can_delete_results` tinyint(1) NOT NULL,
  `can_upload_results` tinyint(1) NOT NULL,
  `can_view_statistics` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `roll_number` (`roll_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'argon2$argon2id$v=19$m=102400,t=2,p=8$TjQ5MjFKSEhpdFAwWTdVZElSb2hNZA$5yXF5ypfzhpObNvbNPBJ74MbV3xVyc53cE6RZK8KkR8',NULL,1,'admin','Admin','User','admin@spmvv.edu',1,1,'2026-02-10 09:02:08.441627','admin',NULL,0,NULL,'',1,1,'',1,1,1,1),
(2,'argon2$argon2id$v=19$m=102400,t=2,p=8$dmZxQ3dVbks2NkNBSFh2UDBsQ2I4Zg$Nx6ZZm8hpLD9BM7Dgop90tyrAQ6ddRrcFnKAzR5ARCo',NULL,0,'test123','Gowtham','Chendra','gowtham@test.com',0,1,'2026-02-10 13:11:15.734824','student','test123',5,'2026-02-23 17:33:49.789977',NULL,0,0,NULL,1,0,0,0),
(3,'argon2$argon2id$v=19$m=102400,t=2,p=8$S0haZENDV1BFbXd5NjJVMmlTbktlSA$01le+k0ZwgYXtppQezzcyUaVsfBiAg8Dx9yhfN9Dop0',NULL,0,'2271010','Gowtham','Sushma','go@gmail.com',0,1,'2026-02-10 18:12:16.909799','student','2271010',0,NULL,'ECE',0,0,'',1,0,0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_groups_user_id_group_id_fc7788e8_uniq` (`user_id`,`group_id`),
  KEY `users_groups_group_id_2f3517aa_fk_auth_group_id` (`group_id`),
  CONSTRAINT `users_groups_group_id_2f3517aa_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `users_groups_user_id_f500bee5_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_permissions`
--

DROP TABLE IF EXISTS `users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_permissions_user_id_permission_id_3b86cbdf_uniq` (`user_id`,`permission_id`),
  KEY `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` (`permission_id`),
  CONSTRAINT `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `users_user_permissions_user_id_92473840_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_permissions`
--

LOCK TABLES `users_user_permissions` WRITE;
/*!40000 ALTER TABLE `users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-24 16:10:11
