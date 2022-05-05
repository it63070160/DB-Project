CREATE DATABASE  IF NOT EXISTS `db_project_web` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_project_web`;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: db_project_web
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
  `user_id` int NOT NULL,
  `emp_id` int NOT NULL,
  PRIMARY KEY (`account_number`),
  KEY `account_user_id_fk_idx` (`user_id`),
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
INSERT INTO `account` VALUES ('0000000001',2025,1,1),('0000000002',87304,1,2),('0000000003',49500,2,3),('0000000004',50000,2,4),('0000000005',50000,35,5),('0000000006',50000,35,6),('0000000007',50000,1,7),('0000000008',50000,2,8),('0000000009',50000,35,17),('0000000010',50000,35,1),('0000000011',0,2,10),('0000000012',50000,2,10),('0000000013',50000,2,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
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
  `interest` float NOT NULL DEFAULT '0',
  `issue_date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL,
  `account_number` char(16) NOT NULL,
  `emp_id` int NOT NULL,
  PRIMARY KEY (`card_number`),
  KEY `credit_card_account_number_fk_idx` (`account_number`),
  KEY `credit_card_emp_id_fk_idx` (`emp_id`),
  CONSTRAINT `credit_card_account_number_fk` FOREIGN KEY (`account_number`) REFERENCES `account` (`account_number`),
  CONSTRAINT `credit_card_emp_id_fk` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_card`
--

LOCK TABLES `credit_card` WRITE;
/*!40000 ALTER TABLE `credit_card` DISABLE KEYS */;
INSERT INTO `credit_card` VALUES ('0152006583210001',500,10.58,'Active',0.8,'2022-05-02','2024-05-08','0000000001',31),('0152006583210002',35000,500,'Active',1.8,'2022-04-05','2024-04-05','0000000002',30),('0152006583210003',500,0,'Active',1.8,'2022-05-03','2024-05-03','0000000001',31),('0152006583210004',454,0,'Reject',0.5,'2022-05-03','2024-05-02','0000000002',31),('0152006583210005',500,1000,'Active',1.9,'2022-05-07','2024-05-04','0000000001',0),('0152006583210006',600,0,'Reject',5,'2022-05-05','2024-05-04','0000000010',1),('0152006583210007',500,0,'Active',5,'2022-05-05','2024-05-04','0000000003',3),('0152006583210008',100,0,'Active',0,'2022-05-05','2024-05-05','0000000003',3),('0152006583210009',50000,0,'Active',0,'2022-05-05','2024-05-05','0000000010',3),('0152006583210010',1000,50,'Active',0,'2022-05-05','2024-05-03','0000000011',10);
/*!40000 ALTER TABLE `credit_card` ENABLE KEYS */;
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
  `user_id` int NOT NULL,
  PRIMARY KEY (`emp_id`),
  KEY `employee_branch_id_fk_idx` (`branch_id`),
  KEY `employee_user_fk_idx` (`user_id`),
  CONSTRAINT `employee_branch_id_fk` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`),
  CONSTRAINT `employee_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Somchai','Naja',1,3),(2,'Somsri','Meena',2,4),(3,'Oliver','Walsh',3,5),(4,'John','Brown',4,6),(5,'Robert','Smith',5,7),(6,'Michael','Johnson',6,8),(7,'Sophia','White',7,9),(8,'Emily','Garcia',8,10),(9,'Isabella','Singh',9,11),(10,'Lily','Byrne',10,12),(11,'Samantha','Taylor',11,13),(12,'Olivia','Gelbero',12,14),(13,'David','Jones',13,15),(14,'Jacob','Martin',14,16),(15,'Poppy','Lam',15,17),(16,'Nicolao','Heard',16,18),(17,'Maxime','Shan',17,36),(31,'Veera','wat',10,1);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) DEFAULT NULL,
  `product_image` longtext,
  `product_price` float DEFAULT NULL,
  `store_id` int NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_store_id_fk_idx` (`store_id`),
  CONSTRAINT `product_store_id_fk` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Shoes','/uploads/miumiu_shoes.jpg',250,1),(2,'Shirt','/uploads/H&M_shirt.jpg',125,2),(3,'Coffee','/uploads/StarbucksCoffee_coffee.jpg',100,3),(4,'Short','/uploads/H&M_short.jpg',75,2),(5,'Rose Flower Dangle Charm','/uploads/pandora_Rose Flower Dangle Charm.jpg',19990,7),(6,'Sand wich','/uploads/subway_sandwich.jpg',139,4),(7,'Clear Men Deep Cleanse','/uploads/watson_clearMenDeepCleanse.jpg',109,8),(8,'Senka Perfect Whip','/uploads/watson_senkaPerfectWhip.jpg',149,8),(9,'Hat','/uploads/H&M_hat.jpg',259,2);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
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
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,'Miu Miu'),(2,'H&M'),(3,'Starbucks Coffee'),(4,'Subway'),(5,'Fuji'),(6,'Moshi Moshi'),(7,'Pandora'),(8,'Watsons'),(9,'Banana Shop'),(10,'Prada');
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`token_id`),
  KEY `token_user_id_fk_idx` (`user_id`),
  CONSTRAINT `token_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (1,1,'fDr5RLk460@oWf4iZCpTtklK#phtvJVjuftrkGqz2MZWx^eMmwq!#XRPltb&XJ5k7/LF4FfmU#HZ2YAfs*qa@SPV!MVrR8H58@Lq'),(2,2,'pnaKnmZUAZiVscawofYYPxXX6iJhqxjk*n*Q1Svm*E!45egDBXdvL9w6L$#3VNs=0hJGTuj-^fh9X3fUQe=Kj$=0OAI9Y8^egbZO'),(3,36,'r/Z401zwqtoywZ-g=tjN1AA7r-m3hRDXkeA24#tL@dD*EL=PNkHEp/c71463Fz*UxdbR8R!VsnOVr0BjO39QNGYo^PzFjCnN-RNy'),(4,18,'erDmstu=t*k2Noj!lZ2xypZnxA9F1Z&Pb#XNg733!PSufCiF#YMHW72SJ2uXj4E-QxrPSy6Cpe5C*#RWYe15DAY8Isx4f&iK@-gC'),(5,5,'/=&27VPdMCG4QVgUzNqxiNXbMC5GN=vcxe*e#GMq!z7S0TvNYPS@oxot1h&ngci95RPPPr-EGFDV@7D@Hli#hXV3np8IX&36OXUw'),(6,3,'!Jh#2fsZ4UbMm5r/LZ5*R1BLxIo&fYz9!FmJg7ZYJMcU5oz=oYaGnAt!o2ER7eQKDMAB2VC^s6/xQNE1U&ZQht/EGP9*@KYl2kLR'),(7,4,'H4x&bZ62YKO#8tWbz5RX7yp8wJxSxFExGnWLo67R5lx#R6o=M27!vK&uLi#aS5*lx8Ukt8u7N*zpPNMRok1riBx4AW6nJIDTqo9&'),(8,7,'O#Rj7*BOdKYdhXU81Fi5Mey#$w7PJwWIu&#s=&YI7YuaixC9DUmKgfgNpzu2m$z-GV1DJF-*3oEZpaEZ^iMQ#ir*pkSymOQqlYQ5'),(9,35,'s0zATDXtMXZVWXr$yj&mwRbPkQwxarX=p3nt^n@6AoaULbN==Z*mm5fbQ#aPCNR6*kyOVrhVCDXwLdj4J^0Za8GUoveE0oH^-Jzd'),(10,12,'IlqsE2ptyBZY^l4i-R52i8y16hj9Qw8yPH@OXHt&RmX2X87vSgzyLxHii##7juXrU*v!smXlV2sAEBQ8Ru8FQ3PKP0&kvxjXw=&!'),(11,37,'TL4^kn9tv5qhAWQm/=N5JD4sv6X2V&kPInHrAGB/tRLfAOgIcJkK9@q&*IA=sXrinbC!8s7Snhsi8GBG&mVvgTm/1TO7qHnGklS*');
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `card_number` char(16) NOT NULL,
  `store_id` int NOT NULL,
  `amount` float DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `transaction_card_number_fk_idx` (`card_number`),
  KEY `transaction_store_id_idx` (`store_id`),
  CONSTRAINT `transaction_card_number_fk` FOREIGN KEY (`card_number`) REFERENCES `credit_card` (`card_number`),
  CONSTRAINT `transaction_store_id` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` VALUES (1,'0152006583210001',1,500,'2022-05-05 03:47:14'),(2,'0152006583210003',1,250,'2022-05-05 03:47:40'),(3,'0152006583210003',2,125,'2022-05-05 04:12:11'),(4,'0152006583210005',3,100,'2022-05-05 05:04:13'),(5,'0152006583210002',2,75,'2022-05-05 05:13:08'),(6,'0152006583210002',1,250,'2022-05-05 16:27:17'),(7,'0152006583210007',1,250,'2022-05-05 16:51:53'),(8,'0152006583210007',1,250,'2022-05-05 16:52:27'),(9,'0152006583210010',2,875,'2022-05-05 22:22:12'),(10,'0152006583210010',2,125,'2022-05-05 22:23:50');
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `fname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('customer','employee') NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'VeerawatK','Veera','wat','$2b$05$sYMPET8LF4cHkbOj15FW6O.YoBqUukunp2EZ5Q5ONi.6kDbSxVQi.','customer'),(2,'PawitP','pawit','prem','$2b$05$ek2wZbL6gMwxsIYxOdYHYOFk8Kmf3VXIgTACxK5nJRtV71ypk5JiO','customer'),(3,'Testemp1','Somchai','Naja','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(4,'Testemp2','Somsri','Meena','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(5,'Testemp3','Oliver','Walsh','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(6,'Testemp4','John','Brown','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(7,'Testemp5','Robert','Smith','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(8,'Testemp6','Michael','Johnson','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(9,'Testemp7','Sophia','White','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(10,'Testemp8','Emily','Garcia','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(11,'Testemp9','Isabella','Singh','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(12,'Testemp10','Lily','Byrne','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(13,'Testemp11','Samantha','Taylor','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(14,'Testemp12','Olivia','Gelbero','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(15,'Testemp13','David','Jones','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(16,'Testemp14','Jacob','Martin','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(17,'Testemp15','Poppy','Lam','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(18,'Testemp16','Nicolao','Heard','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(35,'PasutaC','Pasuta','Chan','$2b$05$YjKMw67m0gP2UWKnAagTq.7m.Ve9cEsn9tjo3nQ5c.NIOQxwszwvS','customer'),(36,'Testemp17','Maxime','Shan','$2b$05$BknOmvlDIO7j4EDfaMFCMOILWkJCMnqYp6SE5wF2KPSPsJQAzzeku','employee'),(37,'TestC','Ninja','haha','$2b$05$kOFg7mDVQFwOCXbPI28O6e4a4W2L/0f7l/61I0q0BgI2R3KjgqPky','customer');
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

-- Dump completed on 2022-05-06  0:06:33
