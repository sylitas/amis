-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 15, 2020 at 03:54 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `amisClone`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_InsertClientPersonalInfo` (IN `userIdR` INT(11), IN `objectTypeR` INT(1), IN `avatarR` VARCHAR(225), IN `nameR` VARCHAR(40), IN `calledR` VARCHAR(40), IN `titleR` VARCHAR(40), IN `phoneR` VARCHAR(10), IN `companyPhoneR` VARCHAR(10), IN `companyEmailR` VARCHAR(225), IN `personalEmailR` VARCHAR(225), IN `companyR` VARCHAR(225), IN `addressR` VARCHAR(225), IN `taxPersonalR` VARCHAR(10))  BEGIN
INSERT INTO `object` (`userId`,`objectType`,`avatar`,`name`,`called`,`title`,`phone`,`companyPhone`,`companyEmail`,`personalEmail`,`company`,`address`,`taxPersonal`) VALUES (userIdR,objectTypeR,avatarR,nameR,calledR,titleR,phoneR,companyPhoneR,companyEmailR,personalEmailR,companyR,addressR,taxPersonalR);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_InsertNewUserRole` (IN `newUserId` INT(11))  BEGIN
INSERT INTO `userUserRole`(userId,userRoleId) VALUES (newUserId,2);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_InsertUserFromLDAP` (IN `accountNameP` TEXT)  BEGIN
INSERT INTO `user`(accountName) VALUES(accountNameP);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectAccountForLogin` (IN `name` TEXT, IN `pass` TEXT)  BEGIN
SELECT * FROM `user` WHERE accountName = name AND password = pass;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectIDClientPersonalInfo` (IN `userIdR` INT(11), IN `objectTypeR` INT(1), IN `nameR` VARCHAR(40))  BEGIN
SELECT objectId FROM `object` WHERE
userId = userIdR AND objectType = objectTypeR AND name = nameR;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectPersonalCustomer` (IN `idOfUser` INT(11))  BEGIN
SELECT `objectId`,`userId`,`name`,`called`,`title`,`phone`,`companyPhone`,`companyEmail`,`personalEmail`,`company`,`address`,`taxPersonal` FROM `object` WHERE `objectType` = 1 AND `userId` = idOfUser;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectRoleUser` (IN `userIdInput` INT(11))  BEGIN
SELECT 
a.userRoleName 
FROM `userRole` AS a 
JOIN `userUserRole` AS b 
ON a.`userRoleId` = b.`userRoleId` 
WHERE b.`userId` = userIdInput;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectUserInUser` (IN `accountNameP` TEXT)  BEGIN
SELECT * FROM `user` WHERE accountName = accountNameP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_UpdateClientPersonalInfo` (IN `userIdC` INT(11), IN `objectTypeC` INT(1), IN `avatarC` VARCHAR(225), IN `nameC` VARCHAR(40), IN `calledC` VARCHAR(40), IN `titleC` VARCHAR(40), IN `phoneC` VARCHAR(10), IN `companyPhoneC` VARCHAR(10), IN `companyEmailC` VARCHAR(225), IN `personalEmailC` VARCHAR(225), IN `companyC` VARCHAR(225), IN `addressC` VARCHAR(225), IN `taxPersonalC` VARCHAR(10), IN `objectIdC` INT(11))  BEGIN
UPDATE `object`
SET 
userId = userIdC,
objectType = objectTypeC,
avatar = avatarC,
name = nameC,
called = calledC,
title = titleC,
phone = phoneC,
companyPhone = companyPhoneC,
companyEmail = companyEmailC,
personalEmail = personalEmailC,
company = companyC,
address = addressC,
taxPersonal = taxPersonalC
WHERE objectId = objectIdC ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loginAttempt`
--

CREATE TABLE `loginAttempt` (
  `loginAttemptId` int(11) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `ipNumber` varchar(50) DEFAULT NULL,
  `browserType` varchar(50) DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `createDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `object`
--

CREATE TABLE `object` (
  `objectId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `objectType` int(1) NOT NULL,
  `avatar` varchar(225) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `called` varchar(40) DEFAULT NULL,
  `title` varchar(40) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `companyPhone` varchar(10) DEFAULT NULL,
  `companyEmail` varchar(225) DEFAULT NULL,
  `personalEmail` varchar(225) DEFAULT NULL,
  `company` varchar(225) DEFAULT NULL,
  `address` varchar(225) DEFAULT NULL,
  `taxPersonal` varchar(10) DEFAULT NULL,
  `taxCompany` varchar(13) DEFAULT NULL,
  `budgetCode` varchar(20) DEFAULT NULL,
  `classify` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `object`
--

INSERT INTO `object` (`objectId`, `userId`, `objectType`, `avatar`, `name`, `called`, `title`, `phone`, `companyPhone`, `companyEmail`, `personalEmail`, `company`, `address`, `taxPersonal`, `taxCompany`, `budgetCode`, `classify`) VALUES
(35, 1, 1, 'avatar-id-35.png', 'Sandra', 'velit. Pellentesque', 'consequat, lectus sit', '1712360596', '5621677939', 'Integer@ideratEtiam.net', 'sem.consequat@Inornaresagittis.net', 'Lorem', 'Millport', '6528066544', NULL, NULL, NULL),
(36, 1, 1, NULL, 'Zachary', 'Donec est', 'vel pede blandit', '3456026113', '6636930728', 'egestas@MaurismagnaDuis.net', 'lorem@ametorciUt.edu', 'Lorem ipsum', 'Fort Worth', '6125929684', NULL, NULL, NULL),
(38, 1, 1, NULL, 'Lysandra', 'fringilla. Donec', 'lectus convallis est,', '8417920140', '8464200031', 'Proin.velit@ipsum.co.uk', 'dolor@arcueuodio.co.uk', 'Lorem ipsum', 'Riksingen', '3123745656', NULL, NULL, NULL),
(39, 1, 1, NULL, 'Berk', 'tempor, est', 'mi pede, nonummy', '0962085172', '1642211429', 'magna.Praesent.interdum@faucibusidlibero.com', 'sapien@Duismienim.com', 'Lorem ipsum', 'Grumo Appula', '5165908636', NULL, NULL, NULL),
(40, 1, 1, NULL, 'Jolie', 'Nulla tincidunt,', 'Nunc quis arcu', '6727284028', '0172838296', 'non.massa@nonummy.net', 'In@vehicula.edu', 'Lorem ipsum', 'Lieferinge', '2208688780', NULL, NULL, NULL),
(41, 1, 1, NULL, 'Claudia', 'lacus. Cras', 'ut, pellentesque eget,', '3481207090', '7830547105', 'sit.amet@duiCumsociis.org', 'cursus.Integer@consectetuerrhoncusNullam.co.uk', 'Lorem', 'Darıca', '5568149248', NULL, NULL, NULL),
(42, 1, 1, NULL, 'Kay', 'Aliquam rutrum', 'Nulla tempor augue', '5077468158', '1596685046', 'et@sitametdiam.edu', 'nunc.sed.pede@nequeMorbiquis.edu', 'Lorem', 'Caccamo', '2886607743', NULL, NULL, NULL),
(43, 1, 1, NULL, 'Katelyn', 'convallis convallis', 'nunc id enim.', '9213648386', '6945261733', 'Integer.vitae.nibh@sociisnatoque.edu', 'orci@Nullamscelerisque.ca', 'Lorem', 'Karachi', '5647943423', NULL, NULL, NULL),
(44, 1, 1, NULL, 'Hu', 'urna justo', 'ligula consectetuer rhoncus.', '8379114498', '4919965600', 'neque@In.co.uk', 'eu.ultrices@liberoduinec.co.uk', 'Lorem ipsum', '100 Mile House', '6416050371', NULL, NULL, NULL),
(45, 1, 1, NULL, 'Jessamine', 'dictum eu,', 'ante ipsum primis', '3619595564', '6604490974', 'sociis.natoque.penatibus@tincidunt.net', 'Donec.sollicitudin@loremtristiquealiquet.co.uk', 'Lorem', 'Ryazan', '8376982899', NULL, NULL, NULL),
(46, 1, 1, NULL, 'Patrick', 'pellentesque massa', 'Donec consectetuer mauris', '6869984901', '1719548579', 'lacus@cursusaenim.edu', 'dui@sociisnatoquepenatibus.org', 'Lorem', 'Beerse', '9762268273', NULL, NULL, NULL),
(47, 1, 1, NULL, 'Timon', 'lacinia. Sed', 'vitae odio sagittis', '5906007005', '5397191514', 'purus.ac@nonummy.net', 'Duis@velconvallis.net', 'Lorem ipsum', 'Klin', '6527347814', NULL, NULL, NULL),
(48, 1, 1, NULL, 'Channing', 'vulputate mauris', 'viverra. Maecenas iaculis', '5803285650', '2743542938', 'Nullam.velit.dui@vitae.org', 'risus.Donec@Pellentesquehabitantmorbi.co.uk', 'Lorem ipsum', 'Machilipatnam', '0196798428', NULL, NULL, NULL),
(49, 1, 1, NULL, 'Sandra', 'nulla magna,', 'Aliquam auctor, velit', '9112823500', '5599960483', 'tortor.Nunc@convallis.edu', 'Curabitur.massa.Vestibulum@velesttempor.org', 'Lorem ipsum', 'Rangiora', '7411283751', NULL, NULL, NULL),
(50, 1, 1, NULL, 'Tashya', 'nostra, per', 'quis, pede. Praesent', '7897487063', '7798583729', 'imperdiet.non.vestibulum@elitdictum.net', 'elit.pharetra@sem.net', 'Lorem ipsum', 'Stokkem', '1929734042', NULL, NULL, NULL),
(51, 1, 1, NULL, 'Uma', 'fringilla ornare', 'ligula elit, pretium', '2371492515', '6495380370', 'montes.nascetur@mattis.org', 'lorem.auctor.quis@elit.org', 'Lorem', 'Lota', '8723915452', NULL, NULL, NULL),
(52, 1, 1, NULL, 'Wynter', 'interdum. Curabitur', 'nunc nulla vulputate', '0517586837', '3557465569', 'massa@volutpatnuncsit.org', 'Sed@Duisdignissim.org', 'Lorem', 'Taunusstein', '5724401907', NULL, NULL, NULL),
(53, 1, 1, NULL, 'Brenna', 'sed, sapien.', 'lorem, auctor quis,', '2505604881', '7092128418', 'malesuada@risus.co.uk', 'enim.diam.vel@egestasa.net', 'Lorem', 'Rodgau', '5704194075', NULL, NULL, NULL),
(54, 1, 1, NULL, 'Dai', 'tellus. Nunc', 'Sed et libero.', '9290383997', '3108744966', 'sit.amet.orci@ipsumdolorsit.com', 'mattis.Cras@Nulla.ca', 'Lorem', 'Denpasar', '8472221918', NULL, NULL, NULL),
(55, 1, 1, NULL, 'Wallace', 'Maecenas mi', 'malesuada fames ac', '6939286951', '6271973334', 'arcu@dignissimtempor.ca', 'elementum@quismassa.co.uk', 'Lorem ipsum', 'San Cristóbal de las Casas', '7338805511', NULL, NULL, NULL),
(56, 1, 1, NULL, 'Helen', 'congue turpis.', 'posuere at, velit.', '4326029057', '6836825651', 'eu.elit@leoMorbi.org', 'odio.Phasellus@quamvelsapien.ca', 'Lorem', 'Elbistan', '7526484278', NULL, NULL, NULL),
(57, 1, 1, NULL, 'Hedy', 'Mauris eu', 'ante, iaculis nec,', '6055732381', '5387630569', 'Cum@malesuada.edu', 'eu@pharetra.ca', 'Lorem', 'Jhang', '8608484857', NULL, NULL, NULL),
(58, 1, 1, NULL, 'Xavier', 'a, arcu.', 'Suspendisse aliquet molestie', '6568464021', '6084602391', 'auctor@egettinciduntdui.org', 'feugiat@dapibusquam.net', 'Lorem', 'Surbo', '5959540850', NULL, NULL, NULL),
(59, 1, 1, NULL, 'Robin', 'dictum ultricies', 'aliquam adipiscing lacus.', '7948382924', '0195438142', 'a.ultricies@enimconsequat.org', 'nascetur.ridiculus@ac.co.uk', 'Lorem ipsum', 'Sedgewick', '6328643513', NULL, NULL, NULL),
(60, 1, 1, NULL, 'Macey', 'vitae aliquam', 'luctus et ultrices', '4425606126', '0760994350', 'enim@auctor.co.uk', 'hendrerit@sollicitudin.net', 'Lorem', 'Neerrepen', '9053905586', NULL, NULL, NULL),
(61, 1, 1, NULL, 'Shea', 'venenatis a,', 'ligula. Aliquam erat', '1920814009', '8536445106', 'consequat.nec@fringilla.com', 'Vivamus.nisi.Mauris@nisl.edu', 'Lorem', 'Thorn', '4333947666', NULL, NULL, NULL),
(62, 1, 1, NULL, 'Dylan', 'Fusce aliquam,', 'nec tellus. Nunc', '8762505706', '8481294391', 'risus.Donec@eleifend.org', 'Pellentesque.tincidunt@egestaslaciniaSed.com', 'Lorem ipsum', 'Tsiigehtchic', '0824014189', NULL, NULL, NULL),
(63, 1, 1, NULL, 'Kylee', 'nibh sit', 'facilisis non, bibendum', '7972898533', '3678739588', 'primis@euismodacfermentum.org', 'nibh@consectetueradipiscing.edu', 'Lorem', 'Linares', '7603644430', NULL, NULL, NULL),
(64, 1, 1, NULL, 'Olga', 'lectus quis', 'aliquam eros turpis', '4900120438', '5722358914', 'sed.consequat@augueacipsum.net', 'sem.Pellentesque.ut@facilisislorem.com', 'Lorem', 'Rancagua', '0061988865', NULL, NULL, NULL),
(65, 1, 1, NULL, 'Hilary', 'convallis erat,', 'dui lectus rutrum', '2486538745', '5717226326', 'facilisis.magna.tellus@nisl.net', 'libero.est@tinciduntorciquis.net', 'Lorem ipsum', 'Saavedra', '9282577352', NULL, NULL, NULL),
(66, 1, 1, NULL, 'Summer', 'mauris ut', 'Aliquam ornare, libero', '7394549436', '4090384774', 'quis@iaculisodio.ca', 'adipiscing.lobortis.risus@mi.ca', 'Lorem', 'Linares', '3228356587', NULL, NULL, NULL),
(67, 1, 1, NULL, 'Penelope', 'hendrerit a,', 'vestibulum lorem, sit', '5319170809', '5263598148', 'imperdiet.ornare.In@lectus.edu', 'Aliquam.tincidunt@eulacus.co.uk', 'Lorem', 'Villar Pellice', '7146780182', NULL, NULL, NULL),
(68, 1, 1, NULL, 'Upton', 'Proin vel', 'Proin eget odio.', '6178897049', '5019330370', 'tellus.id.nunc@amet.net', 'tempus.lorem.fringilla@ridiculus.net', 'Lorem ipsum', 'Wansin', '8926908825', NULL, NULL, NULL),
(69, 1, 1, NULL, 'Griffin', 'sem molestie', 'Praesent interdum ligula', '5034563048', '4260565568', 'amet.faucibus@turpis.com', 'Aliquam.ultrices@egetipsum.net', 'Lorem', 'Quickborn', '6173212147', NULL, NULL, NULL),
(70, 1, 1, NULL, 'Ursula', 'eu, ultrices', 'Maecenas ornare egestas', '1159821368', '5688688437', 'turpis.non.enim@Sed.org', 'congue.In.scelerisque@leo.co.uk', 'Lorem', 'Township of Minden Hills', '7359675602', NULL, NULL, NULL),
(71, 1, 1, NULL, 'Ferdinand', 'sagittis semper.', 'hendrerit a, arcu.', '2875027230', '6999691962', 'eleifend.non.dapibus@cursus.co.uk', 'sapien.Cras@vehicula.ca', 'Lorem ipsum', 'Stendal', '3004362687', NULL, NULL, NULL),
(72, 1, 1, NULL, 'Rina', 'imperdiet non,', 'Nulla eu neque', '2332396663', '2326154009', 'Proin.sed.turpis@Aliquam.net', 'amet@tellus.org', 'Lorem ipsum', 'Dollard-des-Ormeaux', '0397286931', NULL, NULL, NULL),
(73, 1, 1, NULL, 'Gannon', 'primis in', 'in, cursus et,', '7699475404', '4443976616', 'ornare@mi.net', 'eu@tristiqueac.edu', 'Lorem', 'Waasmunster', '8697080244', NULL, NULL, NULL),
(74, 1, 1, NULL, 'Kerry', 'arcu. Sed', 'aliquet molestie tellus.', '2393250619', '0889576774', 'ac.arcu@gravidasagittis.edu', 'fermentum.risus.at@Suspendissealiquetsem.ca', 'Lorem', 'Nobressart', '6801671783', NULL, NULL, NULL),
(75, 1, 1, NULL, 'Trevor', 'et, commodo', 'interdum. Sed auctor', '2144639224', '6142156073', 'In.mi@auctorullamcorpernisl.net', 'Maecenas@egestas.ca', 'Lorem ipsum', 'Quintero', '5816903148', NULL, NULL, NULL),
(76, 1, 1, NULL, 'Cedric', 'Pellentesque ut', 'Cras convallis convallis', '3334557513', '5148820192', 'egestas.Aliquam@seddui.co.uk', 'ac.mattis.velit@dolortempus.ca', 'Lorem ipsum', 'Bad Vöslau', '4871461692', NULL, NULL, NULL),
(77, 1, 1, NULL, 'Carolyn', 'sociis natoque', 'id enim. Curabitur', '7432737762', '8340071246', 'enim.Curabitur.massa@acturpisegestas.com', 'adipiscing.non@necmetusfacilisis.ca', 'Lorem', 'Adrano', '1235717642', NULL, NULL, NULL),
(78, 1, 1, NULL, 'Uriel', 'adipiscing lacus.', 'mollis vitae, posuere', '7337893621', '2748522425', 'nibh@euismodenim.co.uk', 'diam.lorem.auctor@eueleifend.ca', 'Lorem', 'Maria', '2436588231', NULL, NULL, NULL),
(79, 1, 1, NULL, 'Signe', 'Fusce aliquam,', 'placerat, orci lacus', '6323118552', '5190687998', 'Sed.id.risus@accumsaninterdumlibero.ca', 'mollis@semper.co.uk', 'Lorem', 'Capannori', '6645089025', NULL, NULL, NULL),
(80, 1, 1, NULL, 'Kyra', 'sit amet', 'diam eu dolor', '2861811866', '9893238168', 'Phasellus@adipiscinglobortisrisus.net', 'consequat@Nullafacilisi.co.uk', 'Lorem ipsum', 'Diepenbeek', '8650683903', NULL, NULL, NULL),
(81, 1, 1, NULL, 'Boris', 'Donec porttitor', 'nunc, ullamcorper eu,', '3021673915', '7464731402', 'arcu@Integeraliquam.ca', 'molestie.orci@odiovelest.ca', 'Lorem ipsum', 'Castelluccio Inferiore', '4348194838', NULL, NULL, NULL),
(82, 1, 1, NULL, 'Tiger', 'ornare, libero', 'erat. Sed nunc', '1567704492', '5178485200', 'luctus@SeddictumProin.co.uk', 'eget.laoreet.posuere@conubianostra.ca', 'Lorem', 'Magangué', '7968826736', NULL, NULL, NULL),
(83, 1, 1, NULL, 'Sophia', 'eu neque', 'ornare sagittis felis.', '6242049633', '8369163230', 'sem@mauris.co.uk', 'dui.Fusce.aliquam@dictummagna.ca', 'Lorem', 'Merritt', '3870451008', NULL, NULL, NULL),
(84, 1, 1, NULL, 'Iola', 'quis, pede.', 'habitant morbi tristique', '3551666407', '0168244448', 'elit.fermentum@hendreritconsectetuercursus.org', 'ornare@tellusimperdietnon.edu', 'Lorem', 'Krasnoznamensk', '5512852363', NULL, NULL, NULL),
(85, 1, 1, NULL, 'Zeus', 'Nullam vitae', 'Suspendisse aliquet molestie', '7338190212', '3667336090', 'eget.ipsum@purusin.net', 'ligula.Donec.luctus@Maecenasmi.org', 'Lorem ipsum', 'Anápolis', '8205992451', NULL, NULL, NULL),
(86, 1, 1, NULL, 'Quyn', 'libero. Morbi', 'Vestibulum ante ipsum', '9992388565', '1575722935', 'vulputate.lacus.Cras@gravidaPraesent.ca', 'amet@tempor.edu', 'Lorem ipsum', 'Tain', '2811867401', NULL, NULL, NULL),
(87, 1, 1, NULL, 'Alvin', 'sociis natoque', 'tellus non magna.', '4747903916', '0221449585', 'Etiam@quisurna.net', 'magna@bibendumfermentummetus.net', 'Lorem', 'Cape Breton Island', '3630596822', NULL, NULL, NULL),
(88, 1, 1, NULL, 'Alika', 'ultrices. Duis', 'consectetuer, cursus et,', '3831866867', '3960648987', 'at@semNullainterdum.co.uk', 'Morbi.quis.urna@Curabitur.net', 'Lorem ipsum', 'General Escobedo', '7206161739', NULL, NULL, NULL),
(89, 1, 1, NULL, 'Amal', 'eu, accumsan', 'nascetur ridiculus mus.', '6395670882', '5123164323', 'orci@lacusvestibulumlorem.ca', 'pede.nec@turpisnec.org', 'Lorem ipsum', 'Dole', '7953966991', NULL, NULL, NULL),
(90, 1, 1, NULL, 'Ignatius', 'diam dictum', 'mi. Duis risus', '7158621209', '4512829139', 'nec.ante@euaccumsansed.edu', 'convallis.ante@luctusvulputate.ca', 'Lorem', 'Opole', '4007306696', NULL, NULL, NULL),
(91, 1, 1, NULL, 'Quintessa', 'Donec at', 'In scelerisque scelerisque', '4264124828', '7551888673', 'nibh.Aliquam.ornare@Donectemporest.com', 'congue@lacusvestibulum.co.uk', 'Lorem ipsum', 'Ganshoren', '8139273076', NULL, NULL, NULL),
(92, 1, 1, NULL, 'Zachary', 'dictum placerat,', 'tempus scelerisque, lorem', '0453664566', '1798961528', 'lectus.ante@miloremvehicula.net', 'felis@nonmassa.com', 'Lorem', 'Vlissegem', '7192094228', NULL, NULL, NULL),
(93, 1, 1, NULL, 'Brock', 'dapibus id,', 'condimentum. Donec at', '6568097318', '6711575489', 'ut.molestie.in@feugiatmetussit.com', 'sapien.Cras.dolor@FuscemollisDuis.org', 'Lorem ipsum', 'Labico', '8653362799', NULL, NULL, NULL),
(94, 1, 1, NULL, 'Beck', 'sit amet', 'ornare sagittis felis.', '9607581499', '1321075597', 'diam@a.edu', 'eleifend.nunc@ornare.com', 'Lorem', 'Kawerau', '8206760830', NULL, NULL, NULL),
(95, 1, 1, NULL, 'Chiquita', 'eget odio.', 'Nunc ac sem', '5712372259', '1240438375', 'tempor.est.ac@duiquisaccumsan.net', 'et.malesuada.fames@cursusnonegestas.co.uk', 'Lorem', 'Torgny', '5470289785', NULL, NULL, NULL),
(96, 1, 1, NULL, 'Clayton', 'in lobortis', 'ipsum primis in', '2649162639', '2199322399', 'Sed.malesuada.augue@maurissagittisplacerat.co.uk', 'accumsan.interdum@malesuada.net', 'Lorem', 'Murdochville', '8230571810', NULL, NULL, NULL),
(97, 1, 1, NULL, 'Nathaniel', 'eget odio.', 'risus a ultricies', '3405274248', '3845232111', 'pede.Suspendisse@nibhAliquamornare.edu', 'Donec.at.arcu@Etiamligulatortor.org', 'Lorem', 'Gebze', '9791121685', NULL, NULL, NULL),
(99, 1, 1, NULL, 'Kelsie', 'ultricies adipiscing,', 'fringilla est. Mauris', '1683058052', '6543594010', 'ultrices.Vivamus@pretiumaliquetmetus.ca', 'Aliquam@aliquetmetus.ca', 'Lorem ipsum', 'LouveignŽ', '7072939488', NULL, NULL, NULL),
(100, 1, 1, NULL, 'Beau', 'ornare lectus', 'morbi tristique senectus', '4778357303', '5684941989', 'tempor@Uttinciduntorci.net', 'Phasellus.ornare.Fusce@Maurisutquam.edu', 'Lorem', 'Newcastle', '3415142692', NULL, NULL, NULL),
(140, 1, 1, 'avatar-id-140.png', 'Nguyễn Tuấn Duy', 'Ông', 'CEO', '0834120699', '0834120699', 'johnluy1999@gmail.com', 'johnluy1999@gmail.com', 'ITC-HTC', 'Hanoi', '1000000000', NULL, NULL, NULL),
(142, 1, 1, 'avatar-id-142.png', 'asd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(146, 1, 1, NULL, 'asdsss', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `password`
--

CREATE TABLE `password` (
  `passwordId` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `passwordAnswer` varchar(50) DEFAULT NULL,
  `passwordQuestion` int(50) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL,
  `createByUserId` int(11) DEFAULT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userId` int(11) NOT NULL,
  `accountName` varchar(40) NOT NULL,
  `password` varchar(40) DEFAULT NULL,
  `isLocal` tinyint(1) NOT NULL DEFAULT 1,
  `fullName` varchar(40) DEFAULT NULL,
  `userNote` text DEFAULT NULL,
  `photo` varchar(225) DEFAULT NULL,
  `address1` text DEFAULT NULL,
  `address2` text DEFAULT NULL,
  `city` text DEFAULT NULL,
  `region` text DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `country` text DEFAULT NULL,
  `inactive` tinyint(1) DEFAULT NULL,
  `createByUserId` int(11) DEFAULT NULL,
  `createDate` date DEFAULT NULL,
  `modifieByUserId` int(11) DEFAULT NULL,
  `modifieDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userId`, `accountName`, `password`, `isLocal`, `fullName`, `userNote`, `photo`, `address1`, `address2`, `city`, `region`, `zip`, `country`, `inactive`, `createByUserId`, `createDate`, `modifieByUserId`, `modifieDate`) VALUES
(1, '7901514e1e30469c236058f6f371c430', '252dbbe1d7d7bfc13dcb5b71764c4d08', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'daolt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, '21232f297a57a5a743894a0e4a801fc3', '21232f297a57a5a743894a0e4a801fc3', 1, 'administrator', 'admin account', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'duynt', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userRole`
--

CREATE TABLE `userRole` (
  `userRoleId` int(11) NOT NULL,
  `userRoleName` varchar(40) NOT NULL,
  `userRoleNote` text DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL,
  `createByUserId` int(11) DEFAULT NULL,
  `modifiedDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `userRole`
--

INSERT INTO `userRole` (`userRoleId`, `userRoleName`, `userRoleNote`, `inactive`, `createByUserId`, `modifiedDate`) VALUES
(1, 'administrator', 'quản trị', 0, NULL, NULL),
(2, 'user', 'người dùng', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userUserRole`
--

CREATE TABLE `userUserRole` (
  `userId` int(11) NOT NULL,
  `userRoleId` int(11) NOT NULL,
  `beginDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `createByUserId` int(11) DEFAULT NULL,
  `createDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `userUserRole`
--

INSERT INTO `userUserRole` (`userId`, `userRoleId`, `beginDate`, `endDate`, `createByUserId`, `createDate`) VALUES
(1, 2, NULL, NULL, NULL, NULL),
(3, 1, NULL, NULL, NULL, NULL),
(4, 1, NULL, NULL, NULL, NULL),
(5, 2, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `loginAttempt`
--
ALTER TABLE `loginAttempt`
  ADD PRIMARY KEY (`loginAttemptId`);

--
-- Indexes for table `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`objectId`),
  ADD KEY `fk_userId` (`userId`);

--
-- Indexes for table `password`
--
ALTER TABLE `password`
  ADD PRIMARY KEY (`passwordId`),
  ADD KEY `fk_userId_user` (`userId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userId`);

--
-- Indexes for table `userRole`
--
ALTER TABLE `userRole`
  ADD PRIMARY KEY (`userRoleId`);

--
-- Indexes for table `userUserRole`
--
ALTER TABLE `userUserRole`
  ADD PRIMARY KEY (`userId`,`userRoleId`),
  ADD KEY `fk_userRoleId_ManyToMany` (`userRoleId`,`userId`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `loginAttempt`
--
ALTER TABLE `loginAttempt`
  MODIFY `loginAttemptId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `object`
--
ALTER TABLE `object`
  MODIFY `objectId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT for table `password`
--
ALTER TABLE `password`
  MODIFY `passwordId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `userRole`
--
ALTER TABLE `userRole`
  MODIFY `userRoleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `object`
--
ALTER TABLE `object`
  ADD CONSTRAINT `fk_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`);

--
-- Constraints for table `password`
--
ALTER TABLE `password`
  ADD CONSTRAINT `fk_userId_user` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `userUserRole`
--
ALTER TABLE `userUserRole`
  ADD CONSTRAINT `fk_userId_ManyToMany` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_userRoleId_ManyToMany` FOREIGN KEY (`userRoleId`) REFERENCES `userRole` (`userRoleId`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
