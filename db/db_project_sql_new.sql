CREATE DATABASE  IF NOT EXISTS `db_project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_project`;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: db_project
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `account_number` char(10) NOT NULL,
  `balance` float DEFAULT NULL,
  `type` enum('CREDIT_ACCOUNT','DEPOSIT_ACCOUNT') NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `emp_id` int NOT NULL,
  PRIMARY KEY (`account_number`),
  KEY `user_id_idx` (`user_id`) /*!80000 INVISIBLE */,
  KEY `account_emp_id_fk_idx` (`emp_id`),
  CONSTRAINT `account_emp_id_fk` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `account_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES ('0000000001',500.52,'CREDIT_ACCOUNT','VeerawatK',1),('0000000002',1000,'DEPOSIT_ACCOUNT','2',1),('0000000003',1520.78,'DEPOSIT_ACCOUNT','VeerawatK',2),('0000000004',18050,'CREDIT_ACCOUNT','2',6),('0000000005',89000,'DEPOSIT_ACCOUNT','3',2),('0000000006',1700.54,'DEPOSIT_ACCOUNT','4',4),('0000000007',5078.45,'CREDIT_ACCOUNT','7',5),('0000000008',900.12,'DEPOSIT_ACCOUNT','6',7),('0000000009',48005.9,'DEPOSIT_ACCOUNT','5',9),('0000000010',6182.68,'CREDIT_ACCOUNT','8',8),('0000000011',6894.5,'DEPOSIT_ACCOUNT','9',10),('0000000012',9900,'CREDIT_ACCOUNT','10',11),('0000000013',1245.6,'CREDIT_ACCOUNT','VeerawatK',12),('0000000014',100000,'CREDIT_ACCOUNT','4',13),('0000000015',500000,'DEPOSIT_ACCOUNT','4',13),('0000000016',5805,'CREDIT_ACCOUNT','10',8),('0000000017',20000,'CREDIT_ACCOUNT','VeerawatK',9),('0000000018',11000,'CREDIT_ACCOUNT','2',7),('0000000019',15000,'DEPOSIT_ACCOUNT','6',6),('0000000020',25000,'DEPOSIT_ACCOUNT','8',5);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank`
--

DROP TABLE IF EXISTS `bank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank` (
  `bank_id` int NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`bank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank`
--

LOCK TABLES `bank` WRITE;
/*!40000 ALTER TABLE `bank` DISABLE KEYS */;
INSERT INTO `bank` VALUES (1,'Kasikorn Bank'),(2,'Krungthai Bank'),(3,'Bangkok Bank'),(4,'TMBThanachart Bank'),(5,'The Siam Commercial Bank'),(6,'Bank of Ayudhya'),(7,'Kiatnakin Phatra Bank'),(8,'CIMB Thai Bank'),(9,'TISCO Bank'),(10,'United Overseas Bank'),(11,'Government Savings Bank');
/*!40000 ALTER TABLE `bank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `branch_id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(255) DEFAULT NULL,
  `branch_location` varchar(255) DEFAULT NULL,
  `emp_id` int NOT NULL,
  `bank_id` int NOT NULL,
  PRIMARY KEY (`branch_id`),
  KEY `branch_bank_id_fk_idx` (`bank_id`),
  KEY `branch_emp_id_fk_idx` (`emp_id`),
  CONSTRAINT `branch_bank_id_fk` FOREIGN KEY (`bank_id`) REFERENCES `bank` (`bank_id`),
  CONSTRAINT `branch_emp_id_fk` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'Rama 2','Rama 2, Bangkok',1,1),(2,'Rama 3','Rama 3, Bangkok',2,2),(3,'Lat Krabang','Lat Krabang, Bangkok',3,1),(4,'Mueang Chiang Mai ','Mueang Chiang Mai, Chiang Mai',4,3),(5,'Chiang Dao','Chiang Dao, Chiang Mai',5,5),(6,'Mueang Chon Buri','Mueang Chon Buri, Chon Buri',6,5),(7,'Bang Lamung','Bang Lamung, Chon Buri',7,3),(8,'Sawi ','Sawi, Chumphon',8,8),(9,'Pom Prap Sattru Phai ','Pom Prap Sattru Phai, Bangkok',9,7),(10,'Khao Kho','Khao Kho, Phetchabun',10,7),(11,'Mueang Phuket','Mueang Phuket, Phuket',11,2),(12,'Mueang Trang','Mueang Trang, Trang',12,4),(13,'Ko Chang','Ko Chang, Trat',13,6),(14,'Kaeng Krachan','Kaeng Krachan, Phetchaburi',14,4),(15,'Pak Chong','Pak Chong, Nakhon Ratchasima',15,6),(16,'Mueang Nakhon Ratchasima','Mueang Nakhon Ratchasima, Nakhon Ratchasima',16,9),(17,'Sai Yok','Sai Yok, Kanchanaburi',17,2);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_account`
--

DROP TABLE IF EXISTS `credit_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_account` (
  `account_number` char(10) NOT NULL,
  PRIMARY KEY (`account_number`),
  CONSTRAINT `credit_account_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `account` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_account`
--

LOCK TABLES `credit_account` WRITE;
/*!40000 ALTER TABLE `credit_account` DISABLE KEYS */;
INSERT INTO `credit_account` VALUES ('0000000001'),('0000000004'),('0000000007'),('0000000010'),('0000000012'),('0000000013'),('0000000014'),('0000000016'),('0000000017'),('0000000018');
/*!40000 ALTER TABLE `credit_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_card`
--

DROP TABLE IF EXISTS `credit_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_card` (
  `card_number` char(16) NOT NULL,
  `limit` int DEFAULT NULL,
  `outstanding_balance` float DEFAULT NULL,
  `status` enum('Active','Closed','Reject') NOT NULL,
  `interest` float DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL,
  `account_number` char(10) NOT NULL,
  PRIMARY KEY (`card_number`),
  KEY `creidt_card_account_number_fk_idx` (`account_number`),
  CONSTRAINT `creidt_card_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `credit_account` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card`
--

LOCK TABLES `credit_card` WRITE;
/*!40000 ALTER TABLE `credit_card` DISABLE KEYS */;
INSERT INTO `credit_card` VALUES ('0152006583210001',10000,6500,'Active',1.8,'2022-02-20','2024-02-20','0000000001'),('0152006583210002',20000,0,'Closed',1.8,'2020-02-16','2022-02-16','0000000004'),('0152006583210003',25000,0,'Closed',1.3,'2018-01-02','2020-01-02','0000000007'),('0152006583210004',30000,0,'Active',1.5,'2021-08-10','2023-08-10','0000000010'),('0152006583210005',10000,500,'Active',2.5,'2021-10-16','2023-10-16','0000000012'),('0152006583210006',12000,1250,'Active',2.5,'2021-02-20','2023-02-20','0000000013'),('0152006583210007',15000,0,'Closed',1.8,'2019-12-25','2021-12-25','0000000014'),('0152006583210008',20000,5900,'Active',1.9,'2021-11-10','2023-11-10','0000000016'),('0152006583210009',18000,0,'Active',1.2,'2020-12-15','2022-12-15','0000000017'),('0152006583210010',27000,129000,'Reject',1.7,'2020-08-25','2022-08-25','0000000018');
/*!40000 ALTER TABLE `credit_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_card_store`
--

DROP TABLE IF EXISTS `credit_card_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_card_store` (
  `card_number` char(16) NOT NULL,
  `store_id` int NOT NULL,
  `amount` float DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`card_number`,`store_id`),
  KEY `credit_card_store_store_id_fk_idx` (`store_id`),
  CONSTRAINT `credit_card_store_card_number_fk` FOREIGN KEY (`card_number`) REFERENCES `credit_card` (`card_number`),
  CONSTRAINT `credit_card_store_store_id_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card_store`
--

LOCK TABLES `credit_card_store` WRITE;
/*!40000 ALTER TABLE `credit_card_store` DISABLE KEYS */;
INSERT INTO `credit_card_store` VALUES ('0152006583210001',1,1220,'2022-07-14 20:47:52'),('0152006583210001',5,1890,'2022-09-24 20:31:12'),('0152006583210004',1,2520,'2022-10-11 18:14:19'),('0152006583210005',2,800,'2022-08-03 18:51:13'),('0152006583210005',7,1250.5,'2022-10-08 13:25:20'),('0152006583210006',5,250,'2022-06-24 12:33:43'),('0152006583210006',8,550,'2022-04-13 19:40:59'),('0152006583210008',6,2200,'2022-08-22 14:42:42'),('0152006583210008',9,890,'2022-05-18 19:22:00'),('0152006583210009',10,990,'2022-08-26 18:02:49');
/*!40000 ALTER TABLE `credit_card_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `debit_card`
--

DROP TABLE IF EXISTS `debit_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `debit_card` (
  `card_number` char(16) NOT NULL,
  `limit_per_day` float DEFAULT NULL,
  `status` enum('Active','Closed','Reject') NOT NULL,
  `issue_date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL,
  `emp_id` int NOT NULL,
  `account_number` char(10) NOT NULL,
  PRIMARY KEY (`card_number`),
  KEY `debit_card_account_number_fk_idx` (`account_number`),
  KEY `debit_card_emp_id_fk_idx` (`emp_id`),
  CONSTRAINT `debit_card_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `deposit_account` (`account_number`),
  CONSTRAINT `debit_card_emp_id_fk` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `debit_card`
--

LOCK TABLES `debit_card` WRITE;
/*!40000 ALTER TABLE `debit_card` DISABLE KEYS */;
INSERT INTO `debit_card` VALUES ('0150010073210001',20000,'Active','2022-04-16','2024-04-16',1,'0000000002'),('0150010073210002',15000,'Reject','2020-09-20','2022-09-20',5,'0000000003'),('0150010073210003',5000,'Closed','2015-08-20','2017-08-20',6,'0000000005'),('0150010073210004',8000,'Active','2020-06-28','2022-06-28',7,'0000000006'),('0150010073210005',9000,'Closed','2018-02-15','2020-02-15',2,'0000000008'),('0150010073210006',18000,'Active','2022-03-20','2024-03-20',8,'0000000009'),('0150010073210007',12000,'Active','2022-01-30','2024-01-30',1,'0000000011'),('0150010073210008',20000,'Active','2021-10-15','2023-10-15',4,'0000000019'),('0150010073210009',7000,'Active','2021-05-09','2023-05-09',8,'0000000020'),('0150010073210010',9000,'Closed','2020-01-10','2022-01-10',9,'0000000015');
/*!40000 ALTER TABLE `debit_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `debit_card_store`
--

DROP TABLE IF EXISTS `debit_card_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `debit_card_store` (
  `card_number` char(16) NOT NULL,
  `store_id` int NOT NULL,
  `amount` float DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`card_number`,`store_id`),
  KEY `debit_card_store_store_id_fk_idx` (`store_id`),
  CONSTRAINT `debit_card_store_card_number_fk` FOREIGN KEY (`card_number`) REFERENCES `debit_card` (`card_number`),
  CONSTRAINT `debit_card_store_store_id_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `debit_card_store`
--

LOCK TABLES `debit_card_store` WRITE;
/*!40000 ALTER TABLE `debit_card_store` DISABLE KEYS */;
INSERT INTO `debit_card_store` VALUES ('0150010073210001',1,1250,'2023-04-25 13:45:47'),('0150010073210001',4,550,'2023-10-24 12:48:39'),('0150010073210004',2,578,'2022-06-07 18:49:12'),('0150010073210004',9,4000,'2022-06-09 14:18:30'),('0150010073210006',1,1099,'2023-04-21 10:09:01'),('0150010073210006',8,2520,'2022-08-28 15:30:28'),('0150010073210007',2,1200,'2022-08-08 16:15:33'),('0150010073210007',7,1190,'2023-08-04 20:10:03'),('0150010073210008',8,990,'2023-10-10 20:16:55'),('0150010073210009',5,890,'2023-03-20 12:30:10');
/*!40000 ALTER TABLE `debit_card_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit_account`
--

DROP TABLE IF EXISTS `deposit_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deposit_account` (
  `account_number` char(10) NOT NULL,
  PRIMARY KEY (`account_number`),
  CONSTRAINT `deposit_account_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `account` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit_account`
--

LOCK TABLES `deposit_account` WRITE;
/*!40000 ALTER TABLE `deposit_account` DISABLE KEYS */;
INSERT INTO `deposit_account` VALUES ('0000000002'),('0000000003'),('0000000005'),('0000000006'),('0000000008'),('0000000009'),('0000000011'),('0000000015'),('0000000019'),('0000000020');
/*!40000 ALTER TABLE `deposit_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `emp_id` int NOT NULL AUTO_INCREMENT,
  `emp_fname` varchar(255) DEFAULT NULL,
  `emp_lname` varchar(255) DEFAULT NULL,
  `branch_id` int NOT NULL,
  PRIMARY KEY (`emp_id`),
  KEY `employee_branch_id_fk_idx` (`branch_id`),
  CONSTRAINT `employee_branch_id_fk` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Somchai','Naja',1),(2,'Somsri','Meena',2),(3,'Oliver','Walsh',3),(4,'John','Brown',4),(5,'Robert','Smith',5),(6,'Michael','Johnson',6),(7,'Sophia','White',7),(8,'Emily','Garcia',8),(9,'Isabella','Singh',9),(10,'Lily','Byrne',10),(11,'Samantha','Taylor',11),(12,'Olivia','Gelbero',12),(13,'David','Jones',13),(14,'Jacob','Martin',14),(15,'Poppy','Lam',15),(16,'Nicolao','Heard',16),(17,'Maxime','Shan',17),(18,'Schuyler','Chrysanthos',8),(19,'Simone','Pradeep',6),(20,'Darshan','Evgenios',5),(21,'Sonja','Ismet',7),(22,'Cesare','Dana',9),(23,'Mouna','Reiner',10),(24,'Tendai','Kajsa',15),(25,'Bora','Yasin',11),(26,'Georg','Urd',14),(27,'Irene','Deepti',13),(28,'Julia','Kendal',5),(29,'Hasan','Aristophanes',2),(30,'Raghu','Marilynn',2);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `store_name` varchar(255) DEFAULT NULL,
  `store_location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,'H&M','991 Rama I Rd, Pathum Wan, Bangkok 10330'),(2,'STARBUCKS COFFEE','991 Rama I Rd, Pathum Wan, Bangkok 10330'),(3,'Fuji','71 Lat Krabang Rd, Khwaeng Lat Krabang, Khet Lat Krabang, Bangkok 10520'),(4,'Subway','71 Lat Krabang Rd, Khwaeng Lat Krabang, Khet Lat Krabang, Bangkok 10520'),(5,'Siam Music','94 ศูนย์การค้าฟิวเจอร์พาร์ครังสิต Phahonyothin Rd, Thanyaburi District, Pathum Thani 12130'),(6,'Moshi Moshi','94 ศูนย์การค้าฟิวเจอร์พาร์ครังสิต Phahonyothin Rd, Thanyaburi District, Pathum Thani 12130'),(7,'Pandora','Fashion Island, 587 589 587 Ram Inthra Rd, Khan Na Yao, Bangkok 10230'),(8,'Watsons','Fashion Island, 587 589 587 Ram Inthra Rd, Khan Na Yao, Bangkok 10230'),(9,'Banana Shop','Shop 0115 (Basement Floor Near Escalator), City Complex Soi 21 Petchaburi Road, Bangkok 10400'),(10,'Prada','ไอคอนสยาม 299 Charoen Nakhon Rd, Khlong Ton Sai, Khlong San, Bangkok 10600'),(11,'Miu Miu','1031 Phloen Chit Rd, Khwaeng Lumphini, Khet Pathum Wan, Bangkok 10330');
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `token` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_UNIQUE` (`token`),
  KEY `user_id_idx` (`user_id`) /*!80000 INVISIBLE */,
  CONSTRAINT `tokens_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
INSERT INTO `tokens` VALUES (1,'VeerawatK','G^$brC=!i2qQBVnR5p1FFjkogtHIsQ04Z7rbQWcm*#GSz6Rz0GP*5/mTa5G&Z4XzcJVvCfmRER24fbvHgmb@tWl!AlB6jeor6R!^');
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `transaction_id` int NOT NULL,
  `amount` float DEFAULT NULL,
  `type` enum('Deposit','Withdrawn','Transfer') NOT NULL,
  `account_number` char(10) NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `transaction_account_number_fk` (`account_number`),
  CONSTRAINT `transaction_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `account` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` VALUES (1,1000,'Deposit','0000000002'),(2,1000,'Withdrawn','0000000001'),(3,2000,'Deposit','0000000001'),(4,1000,'Withdrawn','0000000002'),(5,1000,'Withdrawn','0000000002'),(6,500,'Transfer','0000000003'),(7,100,'Withdrawn','0000000003'),(8,200,'Transfer','0000000004'),(9,450,'Transfer','0000000004'),(10,670.5,'Withdrawn','0000000005'),(11,1500,'Transfer','0000000006'),(12,890.45,'Withdrawn','0000000006'),(13,4443,'Deposit','0000000005'),(14,114,'Withdrawn','0000000007'),(15,1939.91,'Deposit','0000000007'),(16,831.42,'Transfer','0000000008'),(17,2651.9,'Deposit','0000000008'),(18,1438,'Withdrawn','0000000009'),(19,88.35,'Deposit','0000000008'),(20,157.78,'Withdrawn','0000000010');
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` varchar(20) NOT NULL,
  `fname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'normal',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('2','pawi','prem','555555','normal'),('3','peera','don','111111','normal'),('4','ram','makon','654321','normal'),('5','pasu','tachan','789456','normal'),('6','sarun','ched','852741','normal'),('7','chana','yut','951489','normal'),('8','alex','chano','548962','normal'),('9','john','olala','324561','normal'),('Jwick111','jame','wick','614587','normal'),('VeerawatK','Veera','Kamol','$2b$05$sYMPET8LF4cHkbOj15FW6O.YoBqUukunp2EZ5Q5ONi.6kDbSxVQi.','admin');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-28 15:22:21
