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
  `session_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_logs_user_id_88267f_idx` (`user_id`,`timestamp`),
  KEY `audit_logs_action_474804_idx` (`action`,`timestamp`),
  KEY `audit_logs_session_id_ceb3955b` (`session_id`),
  CONSTRAINT `audit_logs_user_id_752b0e2b_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES
(1,'login','Successful login from 10.189.129.61','10.189.129.61','2026-03-21 03:30:24.982618',1,NULL),
(2,'login','Successful login from 10.189.129.61','10.189.129.61','2026-03-21 03:32:32.962266',1,NULL),
(3,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:03:48.362081',1,'5314a43543c249c2b90b57a014c435d8'),
(4,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:03:57.081290',1,'5ccafc78c7e5405f9fef66bc3bddc276'),
(5,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:04:39.857245',1,'3a950958ca3a4d0885e70e9733704dca'),
(6,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:13:38.425828',1,'ef1ce6e190504a4c9b362b28c41f8b22'),
(7,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:14:48.216714',1,'5d1008f0c6154e709f309b3ec74c64e4'),
(8,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 04:15:11.077001',1,'a2498bedbed14d7f897bf3eb01884f3a'),
(9,'login','Successful login from 10.189.129.61','10.189.129.61','2026-03-21 04:36:09.403828',1,'f0ffc45ab7f84343898171cce4f68960'),
(10,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 05:31:44.358529',1,NULL),
(11,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 05:31:56.579533',1,NULL),
(12,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 06:04:36.998099',1,'fe9d0c19615b436bb0b423c406f5b6d4'),
(13,'result_upload','Uploaded results: 12 created, 0 updated, Branches: [\'eee\', \'cse\']','172.18.0.4','2026-03-21 06:15:07.007208',1,'fe9d0c19615b436bb0b423c406f5b6d4'),
(14,'user_registration','Student registered: 2271010','172.18.0.4','2026-03-21 06:17:26.094587',2,NULL),
(15,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 06:17:34.859776',2,'dd7eaa95585649598b23941a6e0b4629'),
(16,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:17:35.136100',2,'dd7eaa95585649598b23941a6e0b4629'),
(17,'circular_created','Created circular: Holidays','172.18.0.4','2026-03-21 06:18:07.917694',1,'fe9d0c19615b436bb0b423c406f5b6d4'),
(18,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:18:13.637948',2,'dd7eaa95585649598b23941a6e0b4629'),
(19,'photo_uploaded','{\"roll_number\": \"2271010\", \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:34.991079',2,NULL),
(20,'profile_updated','Student updated profile: 2271010','172.18.0.4','2026-03-21 06:23:37.616107',2,'dd7eaa95585649598b23941a6e0b4629'),
(21,'exam_created','{\"exam_id\": 1, \"exam_name\": \"I Year B.Tech I Semester Regular Examinations January 2026\", \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:51.332007',1,NULL),
(22,'subject_added','{\"exam_id\": 1, \"subject_id\": 1, \"subject_code\": \"c101\", \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:51.556182',1,NULL),
(23,'student_list_uploaded','{\"exam_id\": 1, \"created_count\": 3, \"skipped_count\": 0, \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:51.813121',1,NULL),
(24,'hall_tickets_generated','{\"exam_id\": 1, \"generated_count\": 3, \"skipped_count\": 0, \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:58.313331',1,NULL),
(25,'bulk_hall_tickets_downloaded','{\"exam_id\": 1, \"exam_name\": \"I Year B.Tech I Semester Regular Examinations January 2026\", \"ticket_count\": 3, \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:23:58.832616',1,NULL),
(26,'result_view','Detained students: up_to=Y1S1, exam_month_year=all, branch=all, credits lt 20.0 -> 12 students','172.18.0.4','2026-03-21 06:25:20.050967',1,'fe9d0c19615b436bb0b423c406f5b6d4'),
(27,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 06:32:59.361065',2,'b8b12aee687f493f94c81393ab19766f'),
(28,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:32:59.651289',2,'b8b12aee687f493f94c81393ab19766f'),
(29,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:33:07.046204',2,'b8b12aee687f493f94c81393ab19766f'),
(30,'hall_tickets_generated','{\"exam_id\": 1, \"generated_count\": 0, \"skipped_count\": 3, \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:33:17.361784',1,NULL),
(31,'bulk_hall_tickets_downloaded','{\"exam_id\": 1, \"exam_name\": \"I Year B.Tech I Semester Regular Examinations January 2026\", \"ticket_count\": 3, \"ip\": \"172.18.0.4\"}','172.18.0.4','2026-03-21 06:33:17.662683',1,NULL),
(32,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:34:07.449789',2,'b8b12aee687f493f94c81393ab19766f'),
(33,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:48:31.977505',2,'b8b12aee687f493f94c81393ab19766f'),
(34,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:53:08.543380',2,'b8b12aee687f493f94c81393ab19766f'),
(35,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:53:14.786327',2,'b8b12aee687f493f94c81393ab19766f'),
(36,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:54:15.449308',2,'b8b12aee687f493f94c81393ab19766f'),
(37,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:55:15.476591',2,'b8b12aee687f493f94c81393ab19766f'),
(38,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:56:16.060924',2,'b8b12aee687f493f94c81393ab19766f'),
(39,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:57:15.468064',2,'b8b12aee687f493f94c81393ab19766f'),
(40,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:58:15.477570',2,'b8b12aee687f493f94c81393ab19766f'),
(41,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 06:58:47.838904',3,'6fe44a72905246189cfba0ea061675b2'),
(42,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:59:15.477012',2,'b8b12aee687f493f94c81393ab19766f'),
(43,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 06:59:57.311690',2,'b8b12aee687f493f94c81393ab19766f'),
(44,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:00:57.457060',2,'b8b12aee687f493f94c81393ab19766f'),
(45,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:01:57.457253',2,'b8b12aee687f493f94c81393ab19766f'),
(46,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:02:57.462364',2,'b8b12aee687f493f94c81393ab19766f'),
(47,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:03:57.476373',2,'b8b12aee687f493f94c81393ab19766f'),
(48,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:04:57.361062',2,'b8b12aee687f493f94c81393ab19766f'),
(49,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 07:05:02.401659',1,'e616744f121e46bc80533506584afdf7'),
(50,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:05:57.474502',2,'b8b12aee687f493f94c81393ab19766f'),
(51,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:06:57.472332',2,'b8b12aee687f493f94c81393ab19766f'),
(52,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:07:58.490688',2,'b8b12aee687f493f94c81393ab19766f'),
(53,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:08:59.456733',2,'b8b12aee687f493f94c81393ab19766f'),
(54,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:10:00.497819',2,'b8b12aee687f493f94c81393ab19766f'),
(55,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:11:01.495957',2,'b8b12aee687f493f94c81393ab19766f'),
(56,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:12:02.483848',2,'b8b12aee687f493f94c81393ab19766f'),
(57,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:13:03.472007',2,'b8b12aee687f493f94c81393ab19766f'),
(58,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:13:14.971066',2,'b8b12aee687f493f94c81393ab19766f'),
(59,'circular_created','Created circular: hi','172.18.0.4','2026-03-21 07:34:27.653527',1,'e616744f121e46bc80533506584afdf7'),
(60,'login','Successful login from 172.18.0.4','172.18.0.4','2026-03-21 07:34:48.151542',2,'fb4c25003ced4aac9ac29c03156eeab6'),
(61,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','172.18.0.4','2026-03-21 07:34:48.392834',2,'fb4c25003ced4aac9ac29c03156eeab6'),
(62,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 07:38:18.972401',1,'844c8c36164b4882ae4ac01f8147833a'),
(63,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 07:41:08.445094',1,'3a885513669048638a5a9aac408114df'),
(64,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 08:19:55.269230',1,'88a7c631e39f49b2955386e1a9330e42'),
(65,'login','Successful login from 172.18.0.1','172.18.0.1','2026-03-21 08:32:58.346132',1,'a04b107fa7df40988bd6b73526d3430c'),
(66,'login','Successful login from 10.189.129.238','10.189.129.238','2026-03-22 01:41:16.221601',1,'44384d78ed3542d3b3d6673e61ce10e7'),
(67,'hall_tickets_generated','{\"exam_id\": 1, \"generated_count\": 0, \"skipped_count\": 3, \"ip\": \"172.18.0.5\"}','172.18.0.5','2026-03-22 01:41:21.568663',1,NULL),
(68,'bulk_hall_tickets_downloaded','{\"exam_id\": 1, \"exam_name\": \"I Year B.Tech I Semester Regular Examinations January 2026\", \"ticket_count\": 3, \"ip\": \"172.18.0.5\"}','172.18.0.5','2026-03-22 01:41:22.510952',1,NULL),
(69,'login','Successful login from 10.189.129.238','10.189.129.238','2026-03-22 01:42:05.632888',2,'70a1d2e3376d4676892780a628ed2b50'),
(70,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:42:05.808095',2,'70a1d2e3376d4676892780a628ed2b50'),
(71,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:43:07.047330',2,'70a1d2e3376d4676892780a628ed2b50'),
(72,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:44:06.419617',2,'70a1d2e3376d4676892780a628ed2b50'),
(73,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:45:07.047286',2,'70a1d2e3376d4676892780a628ed2b50'),
(74,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:46:07.197507',2,'70a1d2e3376d4676892780a628ed2b50'),
(75,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:47:06.445463',2,'70a1d2e3376d4676892780a628ed2b50'),
(76,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 01:48:27.631196',2,'70a1d2e3376d4676892780a628ed2b50'),
(77,'consolidated_result_view','Viewed consolidated results: 1 year/semester groups','10.189.129.238','2026-03-22 02:11:19.794295',2,'70a1d2e3376d4676892780a628ed2b50');
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
(57,'Can add exam',15,'add_exam'),
(58,'Can change exam',15,'change_exam'),
(59,'Can delete exam',15,'delete_exam'),
(60,'Can view exam',15,'view_exam'),
(61,'Can add exam enrollment',16,'add_examenrollment'),
(62,'Can change exam enrollment',16,'change_examenrollment'),
(63,'Can delete exam enrollment',16,'delete_examenrollment'),
(64,'Can view exam enrollment',16,'view_examenrollment'),
(65,'Can add student photo',17,'add_studentphoto'),
(66,'Can change student photo',17,'change_studentphoto'),
(67,'Can delete student photo',17,'delete_studentphoto'),
(68,'Can view student photo',17,'view_studentphoto'),
(69,'Can add circular',18,'add_circular'),
(70,'Can change circular',18,'change_circular'),
(71,'Can delete circular',18,'delete_circular'),
(72,'Can view circular',18,'view_circular'),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blacklisted_tokens`
--

LOCK TABLES `blacklisted_tokens` WRITE;
/*!40000 ALTER TABLE `blacklisted_tokens` DISABLE KEYS */;
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
  `target_audience` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `circulars_created_3f7483_idx` (`created_at` DESC,`is_active`),
  KEY `circulars_categor_25fad8_idx` (`category`,`is_active`),
  KEY `circulars_created_by_id_aeb43ac6_fk_users_id` (`created_by_id`),
  CONSTRAINT `circulars_created_by_id_aeb43ac6_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circulars`
--

LOCK TABLES `circulars` WRITE;
/*!40000 ALTER TABLE `circulars` DISABLE KEYS */;
INSERT INTO `circulars` VALUES
(1,'Holidays','general','holidays','circulars/2026/03/I_Year_B.Tech_I_Semester_Regular_Examinations_January_2026_Halltickets-1.pdf','I_Year_B.Tech_I_Semester_Regular_Examinations_January_2026_Halltickets-1.pdf',1,NULL,NULL,'2026-03-21 06:18:07.912951','2026-03-21 06:18:07.915090',1,'all'),
(4,'hi','general','hello','circulars/2026/03/I_Year_B.Tech_I_Semester_Regular_Examinations_January_2026_Halltickets_5AYQxvF.pdf','I_Year_B.Tech_I_Semester_Regular_Examinations_January_2026_Halltickets (2).pdf',1,NULL,NULL,'2026-03-21 07:34:27.636804','2026-03-21 07:34:27.650416',1,'staff');
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
(18,'results','circular'),
(15,'results','exam'),
(16,'results','examenrollment'),
(20,'results','examsubject'),
(19,'results','hallticket'),
(11,'results','loginattempt'),
(10,'results','notification'),
(9,'results','result'),
(17,'results','studentphoto'),
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES
(1,'contenttypes','0001_initial','2026-03-21 03:28:33.831319'),
(2,'contenttypes','0002_remove_content_type_name','2026-03-21 03:28:34.783169'),
(3,'auth','0001_initial','2026-03-21 03:28:36.132117'),
(4,'auth','0002_alter_permission_name_max_length','2026-03-21 03:28:36.388205'),
(5,'auth','0003_alter_user_email_max_length','2026-03-21 03:28:36.397705'),
(6,'auth','0004_alter_user_username_opts','2026-03-21 03:28:36.407777'),
(7,'auth','0005_alter_user_last_login_null','2026-03-21 03:28:36.418253'),
(8,'auth','0006_require_contenttypes_0002','2026-03-21 03:28:36.426411'),
(9,'auth','0007_alter_validators_add_error_messages','2026-03-21 03:28:36.435585'),
(10,'auth','0008_alter_user_username_max_length','2026-03-21 03:28:36.443560'),
(11,'auth','0009_alter_user_last_name_max_length','2026-03-21 03:28:36.449141'),
(12,'auth','0010_alter_group_name_max_length','2026-03-21 03:28:36.537056'),
(13,'auth','0011_update_proxy_permissions','2026-03-21 03:28:36.558932'),
(14,'auth','0012_alter_user_first_name_max_length','2026-03-21 03:28:36.567365'),
(15,'results','0001_initial','2026-03-21 03:28:47.930229'),
(16,'admin','0001_initial','2026-03-21 03:28:49.821331'),
(17,'admin','0002_logentry_remove_auto_add','2026-03-21 03:28:49.834140'),
(18,'admin','0003_logentry_add_action_flag_choices','2026-03-21 03:28:49.843260'),
(19,'results','0002_remove_result_results_roll_nu_3f83e5_idx_and_more','2026-03-21 03:28:51.784837'),
(20,'results','0003_user_failed_login_attempts_user_locked_until_and_more','2026-03-21 03:28:55.044430'),
(21,'results','0004_notification_exam_name_notification_result_and_more','2026-03-21 03:28:56.332803'),
(22,'results','0005_result_course','2026-03-21 03:28:56.918170'),
(23,'results','0006_result_branch','2026-03-21 03:28:57.246680'),
(24,'results','0007_subject_attempts','2026-03-21 03:28:57.649590'),
(25,'results','0008_result_percentage','2026-03-21 03:28:57.799079'),
(26,'results','0009_user_branch_user_can_manage_users_and_more','2026-03-21 03:28:58.642249'),
(27,'results','0010_user_can_delete_results_user_can_upload_results_and_more','2026-03-21 03:28:59.290520'),
(28,'results','0011_fix_student_null_constraint','2026-03-21 03:29:00.282816'),
(29,'results','0012_result_completion_date','2026-03-21 03:29:00.867349'),
(30,'results','0013_alter_result_unique_together_and_more','2026-03-21 03:29:01.618544'),
(31,'results','0014_update_for_credits_and_sgpa','2026-03-21 03:29:02.233177'),
(32,'results','0015_exam_examenrollment_studentphoto_circular_hallticket_and_more','2026-03-21 03:29:09.231231'),
(33,'results','0016_alter_examsubject_exam_date','2026-03-21 03:29:09.235737'),
(34,'results','0017_fix_schema_gaps','2026-03-21 03:29:09.998366'),
(35,'results','0018_alter_auditlog_action_alter_exam_exam_center','2026-03-21 03:29:10.027992'),
(36,'sessions','0001_initial','2026-03-21 03:29:10.296271'),
(37,'token_blacklist','0001_initial','2026-03-21 03:29:10.830005'),
(38,'token_blacklist','0002_outstandingtoken_jti_hex','2026-03-21 03:29:10.990172'),
(39,'token_blacklist','0003_auto_20171017_2007','2026-03-21 03:29:11.012245'),
(40,'token_blacklist','0004_auto_20171017_2013','2026-03-21 03:29:11.474025'),
(41,'token_blacklist','0005_remove_outstandingtoken_jti','2026-03-21 03:29:11.722813'),
(42,'token_blacklist','0006_auto_20171017_2113','2026-03-21 03:29:11.820248'),
(43,'token_blacklist','0007_auto_20171017_2214','2026-03-21 03:29:12.574082'),
(44,'token_blacklist','0008_migrate_to_bigautofield','2026-03-21 03:29:13.456555'),
(45,'token_blacklist','0010_fix_migrate_to_bigautofield','2026-03-21 03:29:13.474484'),
(46,'token_blacklist','0011_linearizes_history','2026-03-21 03:29:13.486390'),
(47,'token_blacklist','0012_alter_outstandingtoken_user','2026-03-21 03:29:13.512031'),
(48,'results','0019_auditlog_session_id','2026-03-21 03:57:32.396723'),
(49,'results','0020_user_granular_permissions','2026-03-21 05:50:58.309034'),
(50,'results','0021_circular_target_audience','2026-03-21 07:10:24.726079');
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
  `branch` varchar(100) NOT NULL,
  `enrolled_at` datetime(6) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  `student_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hall_ticket_enrollments_exam_id_roll_number_a2f34e25_uniq` (`exam_id`,`roll_number`),
  KEY `hall_ticket_enrollments_student_id_2aa09e6e_fk_users_id` (`student_id`),
  KEY `hall_ticket_enrollments_roll_number_2384638a` (`roll_number`),
  CONSTRAINT `hall_ticket_enrollments_exam_id_b0d2520b_fk_hall_ticket_exams_id` FOREIGN KEY (`exam_id`) REFERENCES `hall_ticket_exams` (`id`),
  CONSTRAINT `hall_ticket_enrollments_student_id_2aa09e6e_fk_users_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_enrollments`
--

LOCK TABLES `hall_ticket_enrollments` WRITE;
/*!40000 ALTER TABLE `hall_ticket_enrollments` DISABLE KEYS */;
INSERT INTO `hall_ticket_enrollments` VALUES
(1,'2271010','a','','2026-03-21 06:23:51.807363',1,2),
(2,'2271011','b','','2026-03-21 06:23:51.809893',1,NULL),
(3,'2271012','c','','2026-03-21 06:23:51.811364',1,NULL);
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
  `subject_type` varchar(20) NOT NULL,
  `exam_date` date DEFAULT NULL,
  `exam_time` time(6) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `order` int(11) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hall_ticket_exam_subjects_exam_id_subject_code_22c2294b_uniq` (`exam_id`,`subject_code`),
  CONSTRAINT `hall_ticket_exam_sub_exam_id_3c296380_fk_hall_tick` FOREIGN KEY (`exam_id`) REFERENCES `hall_ticket_exams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_exam_subjects`
--

LOCK TABLES `hall_ticket_exam_subjects` WRITE;
/*!40000 ALTER TABLE `hall_ticket_exam_subjects` DISABLE KEYS */;
INSERT INTO `hall_ticket_exam_subjects` VALUES
(1,'c101','qwerty','Theory','2026-03-21','10:00:00.000000','3 hours',1,1);
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
  `course` varchar(50) NOT NULL,
  `branch` varchar(100) NOT NULL,
  `exam_center` varchar(200) NOT NULL,
  `exam_start_time` time(6) NOT NULL,
  `exam_end_time` time(6) NOT NULL,
  `instructions` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hall_ticket_exams_created_by_id_593c611a_fk_users_id` (`created_by_id`),
  CONSTRAINT `hall_ticket_exams_created_by_id_593c611a_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_exams`
--

LOCK TABLES `hall_ticket_exams` WRITE;
/*!40000 ALTER TABLE `hall_ticket_exams` DISABLE KEYS */;
INSERT INTO `hall_ticket_exams` VALUES
(1,'I Year B.Tech I Semester Regular Examinations January 2026','I','I','B.Tech','EEE','SPMVV, Tirupati','09:00:00.000000','12:00:00.000000','',1,'2026-03-21 06:23:51.328963','2026-03-21 06:23:51.328995',NULL);
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
  UNIQUE KEY `roll_number` (`roll_number`),
  CONSTRAINT `hall_ticket_student_photos_student_id_7ac1d49a_fk_users_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_ticket_student_photos`
--

LOCK TABLES `hall_ticket_student_photos` WRITE;
/*!40000 ALTER TABLE `hall_ticket_student_photos` DISABLE KEYS */;
INSERT INTO `hall_ticket_student_photos` VALUES
(2,'2271010','hall_ticket_photos/chip.png',1,'I hereby give consent to use my photograph for hall ticket generation.','2026-03-21 06:23:34.983588','2026-03-21 06:23:34.988175','2026-03-21 06:23:34.988210');
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
  UNIQUE KEY `enrollment_id` (`enrollment_id`),
  KEY `hall_tickets_exam_id_4bb832c5_fk_hall_ticket_exams_id` (`exam_id`),
  KEY `hall_tickets_generated_by_id_98793f87_fk_users_id` (`generated_by_id`),
  KEY `hall_tickets_student_id_fe100c74_fk_users_id` (`student_id`),
  CONSTRAINT `hall_tickets_enrollment_id_e62c73f9_fk_hall_tick` FOREIGN KEY (`enrollment_id`) REFERENCES `hall_ticket_enrollments` (`id`),
  CONSTRAINT `hall_tickets_exam_id_4bb832c5_fk_hall_ticket_exams_id` FOREIGN KEY (`exam_id`) REFERENCES `hall_ticket_exams` (`id`),
  CONSTRAINT `hall_tickets_generated_by_id_98793f87_fk_users_id` FOREIGN KEY (`generated_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `hall_tickets_student_id_fe100c74_fk_users_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall_tickets`
--

LOCK TABLES `hall_tickets` WRITE;
/*!40000 ALTER TABLE `hall_tickets` DISABLE KEYS */;
INSERT INTO `hall_tickets` VALUES
(1,'1-2271010','','SPVMM:HT:1-2271010:2271010:I Year B.Tech I Semester Regular Examinations January 2026','generated',0,'2026-03-21 06:23:58.308332',NULL,1,1,1,2),
(2,'1-2271011','','SPVMM:HT:1-2271011:2271011:I Year B.Tech I Semester Regular Examinations January 2026','generated',0,'2026-03-21 06:23:58.309517',NULL,2,1,1,NULL),
(3,'1-2271012','','SPVMM:HT:1-2271012:2271012:I Year B.Tech I Semester Regular Examinations January 2026','generated',0,'2026-03-21 06:23:58.310427',NULL,3,1,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES
(2,'admin','10.189.129.61','2026-03-21 03:32:32.929651',1),
(7,'admin','172.18.0.1','2026-03-21 04:04:39.835697',1),
(10,'admin','172.18.0.1','2026-03-21 04:15:11.019183',1),
(11,'admin','10.189.129.61','2026-03-21 04:36:09.378980',1),
(13,'admin','172.18.0.4','2026-03-21 05:31:56.563038',1),
(14,'admin','172.18.0.1','2026-03-21 05:56:15.759798',0),
(15,'admin','172.18.0.1','2026-03-21 05:56:26.025135',0),
(16,'admin','172.18.0.1','2026-03-21 05:56:41.418696',0),
(17,'admin','172.18.0.4','2026-03-21 06:04:36.954262',1),
(19,'2271010','172.18.0.4','2026-03-21 06:17:34.856080',1),
(20,'2271010','172.18.0.4','2026-03-21 06:32:59.289625',1),
(21,'hod-eee','172.18.0.4','2026-03-21 06:58:47.834519',1),
(22,'admin','172.18.0.4','2026-03-21 07:05:02.397241',1),
(23,'2271010','172.18.0.4','2026-03-21 07:34:48.133701',1),
(27,'admin','172.18.0.1','2026-03-21 07:41:08.427215',1),
(33,'admin','172.18.0.1','2026-03-21 08:19:55.251334',1),
(34,'admin','172.18.0.1','2026-03-21 08:32:58.325565',1),
(35,'admin','10.189.129.238','2026-03-22 01:41:16.216216',1),
(37,'2271010','10.189.129.238','2026-03-22 01:42:05.628587',1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
INSERT INTO `results` VALUES
(1,'2271010','a',1,'regular','Pass','','2026-03-21 06:15:06.880080','2026-03-21 06:15:06.940567',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse','2026-03-21',404,9.06),
(2,'2271011','b',1,'regular','Fail','','2026-03-21 06:15:06.943484','2026-03-21 06:15:06.946207',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse',NULL,384,7.06),
(3,'2271012','c',1,'regular','Pass','','2026-03-21 06:15:06.948827','2026-03-21 06:15:06.952715',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse','2026-03-21',404,9.06),
(4,'2271013','d',1,'regular','Fail','','2026-03-21 06:15:06.954633','2026-03-21 06:15:06.957066',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse',NULL,394,6.83),
(5,'2271014','e',1,'regular','Fail','','2026-03-21 06:15:06.959606','2026-03-21 06:15:06.964708',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse',NULL,394,7.72),
(6,'2271015','f',1,'regular','Pass','','2026-03-21 06:15:06.967147','2026-03-21 06:15:06.971655',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','cse','2026-03-21',404,9.06),
(7,'2271016','g',1,'regular','Pass','','2026-03-21 06:15:06.973667','2026-03-21 06:15:06.977784',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee','2026-03-21',404,9.06),
(8,'2271017','h',1,'regular','Pass','','2026-03-21 06:15:06.979903','2026-03-21 06:15:06.984052',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee','2026-03-21',404,9.06),
(9,'2271018','i',1,'regular','Fail','','2026-03-21 06:15:06.985729','2026-03-21 06:15:06.988038',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee',NULL,374,7.56),
(10,'2271019','j',1,'regular','Pass','','2026-03-21 06:15:06.990256','2026-03-21 06:15:06.994422',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee','2026-03-21',404,9.06),
(11,'2271020','k',1,'regular','Pass','','2026-03-21 06:15:06.996881','2026-03-21 06:15:07.000798',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee','2026-03-21',404,9.06),
(12,'2271021','l',1,'supplementary','Pass','','2026-03-21 06:15:07.002494','2026-03-21 06:15:07.006442',NULL,1,'B.Tech I year I Semester Regular and Supplementary Exam Results March 2024',1,'2024-03-01','btech','eee','2026-03-21',404,9.06);
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
  `internal_marks` int(11) DEFAULT NULL,
  `external_marks` int(11) DEFAULT NULL,
  `total_marks` int(11) DEFAULT NULL,
  `grade` varchar(10) NOT NULL,
  `result_id` bigint(20) NOT NULL,
  `attempts` int(11) NOT NULL,
  `credits` int(11) DEFAULT NULL,
  `subject_type` varchar(20) NOT NULL DEFAULT 'Theory',
  PRIMARY KEY (`id`),
  KEY `subjects_result_id_56492fb3_fk_results_id` (`result_id`),
  KEY `subjects_subject_e16b01_idx` (`subject_code`),
  CONSTRAINT `subjects_result_id_56492fb3_fk_results_id` FOREIGN KEY (`result_id`) REFERENCES `results` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES
(1,'CS101','Data Structures',18,65,83,'A',1,1,4,'Theory'),
(2,'CS102','Algorithms',20,70,90,'O',1,1,4,'Theory'),
(3,'CS103','Databases',15,50,65,'B',1,1,3,'Theory'),
(4,'CS104','Operating Systems',19,68,87,'A',1,1,4,'Theory'),
(5,'CS105','Computer Networks',17,62,79,'A',1,1,3,'Theory'),
(6,'CS101','Data Structures',18,45,63,'F',2,1,4,'Theory'),
(7,'CS102','Algorithms',20,70,90,'O',2,1,4,'Theory'),
(8,'CS103','Databases',15,50,65,'B',2,1,3,'Theory'),
(9,'CS104','Operating Systems',19,68,87,'A',2,1,4,'Theory'),
(10,'CS105','Computer Networks',17,62,79,'A',2,1,3,'Theory'),
(11,'CS101','Data Structures',18,65,83,'A',3,1,4,'Theory'),
(12,'CS102','Algorithms',20,70,90,'O',3,1,4,'Theory'),
(13,'CS103','Databases',15,50,65,'B',3,1,3,'Theory'),
(14,'CS104','Operating Systems',19,68,87,'A',3,1,4,'Theory'),
(15,'CS105','Computer Networks',17,62,79,'A',3,1,3,'Theory'),
(16,'CS101','Data Structures',18,65,83,'A',4,1,4,'Theory'),
(17,'CS102','Algorithms',20,60,80,'F',4,1,4,'Theory'),
(18,'CS103','Databases',15,50,65,'B',4,1,3,'Theory'),
(19,'CS104','Operating Systems',19,68,87,'A',4,1,4,'Theory'),
(20,'CS105','Computer Networks',17,62,79,'A',4,1,3,'Theory'),
(21,'CS101','Data Structures',18,65,83,'A',5,1,4,'Theory'),
(22,'CS102','Algorithms',20,70,90,'O',5,1,4,'Theory'),
(23,'CS103','Databases',15,40,55,'F',5,1,3,'Theory'),
(24,'CS104','Operating Systems',19,68,87,'A',5,1,4,'Theory'),
(25,'CS105','Computer Networks',17,62,79,'A',5,1,3,'Theory'),
(26,'CS101','Data Structures',18,65,83,'A',6,1,4,'Theory'),
(27,'CS102','Algorithms',20,70,90,'O',6,1,4,'Theory'),
(28,'CS103','Databases',15,50,65,'B',6,1,3,'Theory'),
(29,'CS104','Operating Systems',19,68,87,'A',6,1,4,'Theory'),
(30,'CS105','Computer Networks',17,62,79,'A',6,1,3,'Theory'),
(31,'CS101','Data Structures',18,65,83,'A',7,1,4,'Theory'),
(32,'CS102','Algorithms',20,70,90,'O',7,1,4,'Theory'),
(33,'CS103','Databases',15,50,65,'B',7,1,3,'Theory'),
(34,'CS104','Operating Systems',19,68,87,'A',7,1,4,'Theory'),
(35,'CS105','Computer Networks',17,62,79,'A',7,1,3,'Theory'),
(36,'CS101','Data Structures',18,65,83,'A',8,1,4,'Theory'),
(37,'CS102','Algorithms',20,70,90,'O',8,1,4,'Theory'),
(38,'CS103','Databases',15,50,65,'B',8,1,3,'Theory'),
(39,'CS104','Operating Systems',19,68,87,'A',8,1,4,'Theory'),
(40,'CS105','Computer Networks',17,62,79,'A',8,1,3,'Theory'),
(41,'CS101','Data Structures',18,65,83,'A',9,1,4,'Theory'),
(42,'CS102','Algorithms',20,70,90,'O',9,1,4,'Theory'),
(43,'CS103','Databases',15,50,65,'B',9,1,3,'Theory'),
(44,'CS104','Operating Systems',19,68,87,'A',9,1,4,'Theory'),
(45,'CS105','Computer Networks',17,32,49,'F',9,1,3,'Theory'),
(46,'CS101','Data Structures',18,65,83,'A',10,1,4,'Theory'),
(47,'CS102','Algorithms',20,70,90,'O',10,1,4,'Theory'),
(48,'CS103','Databases',15,50,65,'B',10,1,3,'Theory'),
(49,'CS104','Operating Systems',19,68,87,'A',10,1,4,'Theory'),
(50,'CS105','Computer Networks',17,62,79,'A',10,1,3,'Theory'),
(51,'CS101','Data Structures',18,65,83,'A',11,1,4,'Theory'),
(52,'CS102','Algorithms',20,70,90,'O',11,1,4,'Theory'),
(53,'CS103','Databases',15,50,65,'B',11,1,3,'Theory'),
(54,'CS104','Operating Systems',19,68,87,'A',11,1,4,'Theory'),
(55,'CS105','Computer Networks',17,62,79,'A',11,1,3,'Theory'),
(56,'CS101','Data Structures',18,65,83,'A',12,1,4,'Theory'),
(57,'CS102','Algorithms',20,70,90,'O',12,1,4,'Theory'),
(58,'CS103','Databases',15,50,65,'B',12,1,3,'Theory'),
(59,'CS104','Operating Systems',19,68,87,'A',12,1,4,'Theory'),
(60,'CS105','Computer Networks',17,62,79,'A',12,1,3,'Theory');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES
(1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MDIyNCwiaWF0IjoxNzc0MDYzODI0LCJqdGkiOiI5MWY3NTM1NjU0ZjQ0MzA3OWQ1OGY5ZDU0OTQ0Y2NkYiIsInVzZXJfaWQiOjF9.pXhaLlNKRwZkvfRqdi3P5NLmoR3qynJe5XVp9k8fDlw','2026-03-21 03:30:24.957006','2026-03-22 03:30:24.000000',1,'91f7535654f443079d58f9d54944ccdb'),
(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MDM1MiwiaWF0IjoxNzc0MDYzOTUyLCJqdGkiOiJiZDk4ZTcyMzc1Y2E0MzQyODRkOTBjNzhjMzE4OGRjMSIsInVzZXJfaWQiOjF9.Zm4l8ZMi5Cmc29YkfkS5gce_c4gyiXKw1L-BHTW7q7A','2026-03-21 03:32:32.940772','2026-03-22 03:32:32.000000',1,'bd98e72375ca434284d90c78c3188dc1'),
(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MjIyOCwiaWF0IjoxNzc0MDY1ODI4LCJqdGkiOiI2ZjA5MDkwYmNhYjY0NTU3OTBkNTRlOTQwOGY5ZjFlZCIsInVzZXJfaWQiOjF9.Xy0u2rJcz-C94UqnGLmdVPz5fp3yVvnUULlrp6xJtBg','2026-03-21 04:03:48.340334','2026-03-22 04:03:48.000000',1,'6f09090bcab6455790d54e9408f9f1ed'),
(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MjIzNywiaWF0IjoxNzc0MDY1ODM3LCJqdGkiOiI5MDU1ZDdhNGM0NDA0OTgxOWNkZDk4Nzc5OGY4M2M3NyIsInVzZXJfaWQiOjF9.nVQ1Esu2p5Dkb9t7WfeDZ6xoXqoMHHvH4bb9flbMSLE','2026-03-21 04:03:57.078459','2026-03-22 04:03:57.000000',1,'9055d7a4c44049819cdd987798f83c77'),
(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MjI3OSwiaWF0IjoxNzc0MDY1ODc5LCJqdGkiOiJjNTczOWUwMDA3ZjI0Y2VmYTkzZDliZjM3YjEyOWJhNiIsInVzZXJfaWQiOjF9.o6enr0Ob6m6H-kC4XKZdqoeXQyDy6wRDedPFTZunXGA','2026-03-21 04:04:39.837218','2026-03-22 04:04:39.000000',1,'c5739e0007f24cefa93d9bf37b129ba6'),
(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MjgxOCwiaWF0IjoxNzc0MDY2NDE4LCJqdGkiOiI3ZTQ4Yjg5NDk1M2M0NzZlYmU0ZDZhNjM3NWZjMDczZCIsInVzZXJfaWQiOjF9.YJQXKBCHdBDveTISa169eoUL-hzuMwr9iDwLUZyajNY','2026-03-21 04:13:38.418532','2026-03-22 04:13:38.000000',1,'7e48b894953c476ebe4d6a6375fc073d'),
(7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1Mjg4OCwiaWF0IjoxNzc0MDY2NDg4LCJqdGkiOiIzMmEwZTk2MWZiYmQ0MGRmYmI4MTJlMzEwOWMyYWZhNSIsInVzZXJfaWQiOjF9.SgMFW9VwAn4uFgiD20JSEjA2Rc2qoxyMPO82fz2Zyao','2026-03-21 04:14:48.213584','2026-03-22 04:14:48.000000',1,'32a0e961fbbd40dfbb812e3109c2afa5'),
(8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1MjkxMSwiaWF0IjoxNzc0MDY2NTExLCJqdGkiOiIxOGFlM2ZiZWQxOTE0NjQxYmEzMDJjMjZlOTBiZmFkYyIsInVzZXJfaWQiOjF9.o989RsolTJpE9OvYxLrXbqhFVo2CD3vULYS64Bg0flw','2026-03-21 04:15:11.028178','2026-03-22 04:15:11.000000',1,'18ae3fbed1914641ba302c26e90bfadc'),
(9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1NDE2OSwiaWF0IjoxNzc0MDY3NzY5LCJqdGkiOiI3N2FlODc4MmFmZmY0YWM0OWJmYjYyYWYwOWE5ODY1YyIsInVzZXJfaWQiOjF9.b0-Qli6mYgXqRQe9eT0wQxSVmH0QXNde7D1TOqgNkRw','2026-03-21 04:36:09.394453','2026-03-22 04:36:09.000000',1,'77ae8782afff4ac49bfb62af09a9865c'),
(10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1NzUwNCwiaWF0IjoxNzc0MDcxMTA0LCJqdGkiOiIxMjg4Mzk4YTc4Yjk0OWJkOTMyNjkzNzU1ZWEwMTJhZCIsInVzZXJfaWQiOjF9.97I3F5W4yAbiRw-EwVNA96p5qSvXAhZ7mot6Bdfbe50','2026-03-21 05:31:44.338523','2026-03-22 05:31:44.000000',1,'1288398a78b949bd932693755ea012ad'),
(11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1NzUxNiwiaWF0IjoxNzc0MDcxMTE2LCJqdGkiOiJjYTY3ZmExMmNmNmM0NGNmYjVhYjhjNjY3NjI5NjhkNyIsInVzZXJfaWQiOjF9.TqasHtaUYKCnI0o_Y92HXb-Ved9Zmj0houb_VwPT6BE','2026-03-21 05:31:56.570663','2026-03-22 05:31:56.000000',1,'ca67fa12cf6c44cfb5ab8c66762968d7'),
(12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE1OTQ3NiwiaWF0IjoxNzc0MDczMDc2LCJqdGkiOiI5MWI4MGExODMyOTc0YzU2YTFkNTlkZGI2M2U2ZjJhMiIsInVzZXJfaWQiOjF9.yzzwilpaNmSiGnsGZxeWGEq5GtPDAkQ8h_tbd9LpvEY','2026-03-21 06:04:36.956395','2026-03-22 06:04:36.000000',1,'91b80a1832974c56a1d59ddb63e6f2a2'),
(13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2MDI1NCwiaWF0IjoxNzc0MDczODU0LCJqdGkiOiJhMzAwYzFkNDEwYTA0ZGE1ODg1ZjdkNzIyY2VlYzM4MCIsInVzZXJfaWQiOjJ9.dEj1nw3d3KgtPzoFFQhcfYB6PgR_aM5VsiGleAQAfl0','2026-03-21 06:17:34.857773','2026-03-22 06:17:34.000000',2,'a300c1d410a04da5885f7d722ceec380'),
(14,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2MTE3OSwiaWF0IjoxNzc0MDc0Nzc5LCJqdGkiOiI2ZDM4YjNiNGJkYzE0ODgxODJjZTc2Y2M2ZDFkYTllZiIsInVzZXJfaWQiOjJ9.hOyqeruzwbIbl2j170JVuW5vYiMiLPZg8WrHeZDp35U','2026-03-21 06:32:59.354961','2026-03-22 06:32:59.000000',2,'6d38b3b4bdc1488182ce76cc6d1da9ef'),
(15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2MjcyNywiaWF0IjoxNzc0MDc2MzI3LCJqdGkiOiIwM2I2NTI0NDVhOTI0MTMxYmE4OWFhOTg5OTgzNTE5YiIsInVzZXJfaWQiOjN9.pkI_3FU0PVX0wI56go5nG9r01nGsIffDCFTPj47aQHc','2026-03-21 06:58:47.836009','2026-03-22 06:58:47.000000',3,'03b652445a924131ba89aa989983519b'),
(16,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2MzEwMiwiaWF0IjoxNzc0MDc2NzAyLCJqdGkiOiI3YjQzMzU1OTQ1MjY0N2ViYTgyNjJlOTNhM2I2YjkyMSIsInVzZXJfaWQiOjF9.X5eDYnoC4l65qXELpvTQcjmHtwxnrFXtRFZjHWHXCUM','2026-03-21 07:05:02.399807','2026-03-22 07:05:02.000000',1,'7b433559452647eba8262e93a3b6b921'),
(17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2NDg4OCwiaWF0IjoxNzc0MDc4NDg4LCJqdGkiOiI4MGY1YTAwN2QwYTY0ZmVjOGQ4YmFmYTgzOTcxY2NlZiIsInVzZXJfaWQiOjJ9.auFiS4vHBdSGO3FngrGRyHW_gIXH-gzHB3laPZAdq8k','2026-03-21 07:34:48.134803','2026-03-22 07:34:48.000000',2,'80f5a007d0a64fec8d8bafa83971ccef'),
(18,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2NTA5OCwiaWF0IjoxNzc0MDc4Njk4LCJqdGkiOiJiNzhmYmYxYTYwMTE0MzY3YjQ5Nzk2YjVjM2Q5ZDg0NyIsInVzZXJfaWQiOjF9.1XIwU9Wq3oBUktadWCTkQUzjvZ-eTB5bN5e50Z_t1LY','2026-03-21 07:38:18.970194','2026-03-22 07:38:18.000000',1,'b78fbf1a60114367b49796b5c3d9d847'),
(19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2NTI2OCwiaWF0IjoxNzc0MDc4ODY4LCJqdGkiOiJkN2Q5YjUwYTE2OGY0MDkzODE4NmMxM2I3YmNlYmVjNSIsInVzZXJfaWQiOjF9.868tuB8G6Sl03xP9M1ako6XCcUz9RrgfsxSH1stN96U','2026-03-21 07:41:08.428864','2026-03-22 07:41:08.000000',1,'d7d9b50a168f40938186c13b7bcebec5'),
(20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2NzU5NSwiaWF0IjoxNzc0MDgxMTk1LCJqdGkiOiI4NTdjZjk2Njk3Njk0MjExOGM4ZWFjNmUyNjFhMDFlMyIsInVzZXJfaWQiOjF9.tkA2LuObn928xOeqn_ZrcgO0gb1A3j40IfRNem7SBus','2026-03-21 08:19:55.252775','2026-03-22 08:19:55.000000',1,'857cf966976942118c8eac6e261a01e3'),
(21,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDE2ODM3OCwiaWF0IjoxNzc0MDgxOTc4LCJqdGkiOiIxMmE1Y2JiMGMwZDQ0YTFmOTM2YTcxYzA1YjI1NzdkZCIsInVzZXJfaWQiOjF9.j_YuoJ7Ylim5cwdIM_Itjq7zz0oIkvAn7tTU5eJPgHI','2026-03-21 08:32:58.327216','2026-03-22 08:32:58.000000',1,'12a5cbb0c0d44a1f936a71c05b2577dd'),
(22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDIzMDA3NiwiaWF0IjoxNzc0MTQzNjc2LCJqdGkiOiI0YTljNmY5NDI4YzY0M2Q0YTYyY2FmZmZhYzIwNTFlNCIsInVzZXJfaWQiOjF9._DmQo2UuiWimUJEra_q6_y1teArzdTIhJPqhHmgvUFM','2026-03-22 01:41:16.219201','2026-03-23 01:41:16.000000',1,'4a9c6f9428c643d4a62cafffac2051e4'),
(23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3NDIzMDEyNSwiaWF0IjoxNzc0MTQzNzI1LCJqdGkiOiJkYzk2MjBkZGYxNGY0MTY1YjViNTM2YzEyOTBhYWQxNCIsInVzZXJfaWQiOjJ9.XeaXe1iUgsxDgWXrhPIcDlyRZHp6sqBuFtL5TqAxQhY','2026-03-22 01:42:05.629788','2026-03-23 01:42:05.000000',2,'dc9620ddf14f4165b5b536c1290aad14');
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
  `department` varchar(100) DEFAULT NULL,
  `is_active_user` tinyint(1) NOT NULL,
  `results_upload` tinyint(1) NOT NULL,
  `results_edit` tinyint(1) NOT NULL,
  `results_delete` tinyint(1) NOT NULL,
  `results_download` tinyint(1) NOT NULL,
  `students_view` tinyint(1) NOT NULL,
  `students_detained_report` tinyint(1) NOT NULL,
  `circulars_view` tinyint(1) NOT NULL,
  `circulars_create` tinyint(1) NOT NULL,
  `circulars_edit` tinyint(1) NOT NULL,
  `circulars_delete` tinyint(1) NOT NULL,
  `timetable_view` tinyint(1) NOT NULL,
  `timetable_create` tinyint(1) NOT NULL,
  `halltickets_view` tinyint(1) NOT NULL,
  `halltickets_create` tinyint(1) NOT NULL,
  `halltickets_generate` tinyint(1) NOT NULL,
  `halltickets_download` tinyint(1) NOT NULL,
  `statistics_view` tinyint(1) NOT NULL,
  `auditlogs_view` tinyint(1) NOT NULL,
  `users_view` tinyint(1) NOT NULL,
  `users_create` tinyint(1) NOT NULL,
  `users_edit` tinyint(1) NOT NULL,
  `users_delete` tinyint(1) NOT NULL,
  `access_all_branches` tinyint(1) NOT NULL,
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
(1,'argon2$argon2id$v=19$m=102400,t=2,p=8$dm9jUEVkVm9PeldwOWdsS2dROG8xWg$JTDqOkDE7vuBqhxY///VpVY1X5x5D4BGLM9OjKh8fK4',NULL,1,'admin','','','admin@spmvv.edu',1,1,'2026-03-21 03:29:15.210261','admin',NULL,0,NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(2,'argon2$argon2id$v=19$m=102400,t=2,p=8$UEo4MGIzckFpVVV6QU1NUmhlTXhXRQ$oRfytu15RxHiPCCqz2qCyEcyTNbropaFn/PAVndBNbM',NULL,0,'2271010','Gowtham','Chendra','go@gmail.com',0,1,'2026-03-21 06:17:26.044254','student','2271010',0,NULL,'EEE',NULL,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(3,'argon2$argon2id$v=19$m=102400,t=2,p=8$aFNVR1BFV2pLSng3QjB2YUJuanVtOA$qKb6uI70RNPWTIuofDKEW3w8qzw2UZFD5NpagiKc9Mo',NULL,0,'HOD-EEE','','','',0,1,'2026-03-21 06:58:18.697024','hod',NULL,0,NULL,'EEE','',1,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,1,0,0,0,1);
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

-- Dump completed on 2026-03-22  2:53:54
