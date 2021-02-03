-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th2 03, 2021 lúc 01:27 AM
-- Phiên bản máy phục vụ: 10.4.11-MariaDB
-- Phiên bản PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `amisclone`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_InsertNewUserRole` (IN `newUserId` INT(11))  BEGIN
INSERT INTO `userUserRole`(userId,userRoleId) VALUES (newUserId,2);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectAccountForLogin` (IN `name` TEXT, IN `pass` TEXT)  BEGIN
SELECT * FROM `user` WHERE accountName = name AND password = pass;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectActionAndPermission` (IN `idOfFunction` INT, IN `idOfUserRole` INT)  BEGIN
SELECT a.`actionId`,a.`actionName`,p.`isPermission`
FROM `action` AS a
JOIN `permission` AS p ON p.`actionId` = a.`actionId` 
WHERE p.`functionId` = idOfFunction
AND p.`userRoleId` = idOfUserRole;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectAllActionByFunctionId` (IN `idOfFunction` INT, IN `idOfUserRole` INT)  BEGIN
SELECT a.`actionId`,a.`actionName`
FROM `action` AS a
JOIN `functionaction` AS f ON f.`actionId` = a.`actionId`
WHERE f.`functionId` = idOfFunction 
AND f.`userRoleId` = idOfUserRole;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_SelectAllObjectAndLocation` (IN `IdOfUser` INT)  BEGIN
SELECT o.*, CONCAT (c.`cityName`,", ",d.`districtName`,", ",l.`address`) AS adress
FROM `object` AS o 
JOIN `location` AS l ON o.`objectId` = l.`objectId`
JOIN `city` AS c ON c.`cityId` = l.`cityId`
JOIN `district` AS d ON d.`districtId` = l.`districtId`
WHERE o.`userId` = IdOfUser;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectAllUserRole` ()  BEGIN
SELECT * FROM `userrole`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectCityOfObjectFromLocation` (IN `idOfLocation` INT)  BEGIN
SELECT c.`cityName`,l.`address`,l.`districtId`
FROM `location` AS l
JOIN `city` AS c ON l.`cityId` = c.`cityId`
WHERE l.`locationId` = idOfLocation;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectIDClientPersonalInfo` (IN `userIdR` INT(11), IN `objectTypeR` INT(1), IN `nameR` VARCHAR(40))  BEGIN
SELECT objectId FROM `object` WHERE
userId = userIdR AND objectType = objectTypeR AND name = nameR;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectPermissionByUserRoleName` (IN `idOfUserRole` INT, IN `idOfFunction` INT)  BEGIN
SELECT `actionId` FROM `permission` WHERE `userRoleId` = idOfUserRole AND `isPermission` = 1 AND `functionId` = idOfFunction;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectPersonalCustomer` (IN `idOfUser` INT(11))  BEGIN
SELECT `objectId`,`userId`,`name`,`called`,`title`,`phone`,`companyPhone`,`companyEmail`,`personalEmail`,`company`,`address`,`taxPersonal` FROM `object` WHERE `objectType` = 1 AND `userId` = idOfUser;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectRoleByRoleId` (IN `idOfRole` INT)  BEGIN
SELECT * FROM `userrole` WHERE `userRoleId` = idOfRole;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectRoleUser` (IN `userIdInput` INT(11))  BEGIN
SELECT 
a.userRoleName,a.userRoleId
FROM `userRole` AS a 
JOIN `userUserRole` AS b 
ON a.`userRoleId` = b.`userRoleId` 
WHERE b.`userId` = userIdInput;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectUserbyUserRoleId` (IN `idOfUserRole` INT)  BEGIN
SELECT u.* 
FROM `user` AS u 
JOIN `useruserrole` AS uur ON u.`userId` = uur.`userId`
WHERE uur.`userRoleId` = idOfUserRole;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectUserInUser` (IN `name` TEXT)  BEGIN
SELECT * FROM `user` WHERE `accountName` = name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectUserInUserByUserId` (IN `IdOfUser` TEXT)  BEGIN
SELECT * FROM `user` WHERE userId = IdOfUser;
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
-- Cấu trúc bảng cho bảng `action`
--

CREATE TABLE `action` (
  `actionId` int(11) NOT NULL,
  `actionName` text DEFAULT NULL,
  `actionNote` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `action`
--

INSERT INTO `action` (`actionId`, `actionName`, `actionNote`) VALUES
(1, 'GRANT', NULL),
(2, 'ADD', NULL),
(3, 'EDIT', NULL),
(4, 'DELETE', NULL),
(5, 'EXPORT', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `city`
--

CREATE TABLE `city` (
  `cityId` int(11) NOT NULL,
  `cityName` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `district`
--

CREATE TABLE `district` (
  `districtId` int(11) NOT NULL,
  `cityId` int(11) NOT NULL,
  `districtName` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `function`
--

CREATE TABLE `function` (
  `functionId` int(11) NOT NULL,
  `functionName` text DEFAULT NULL,
  `functionNote` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `function`
--

INSERT INTO `function` (`functionId`, `functionName`, `functionNote`) VALUES
(1, 'Grant Permission', NULL),
(2, 'Contact', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `functionaction`
--

CREATE TABLE `functionaction` (
  `functionActionId` int(11) NOT NULL,
  `functionId` int(11) NOT NULL,
  `actionId` int(11) NOT NULL,
  `userRoleId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `functionaction`
--

INSERT INTO `functionaction` (`functionActionId`, `functionId`, `actionId`, `userRoleId`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 1, 3, 1),
(4, 1, 4, 1),
(5, 1, 5, 1),
(6, 2, 2, 1),
(7, 2, 3, 1),
(8, 2, 4, 1),
(9, 2, 5, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `location`
--

CREATE TABLE `location` (
  `locationId` int(11) NOT NULL,
  `objectId` int(11) NOT NULL,
  `districtId` int(11) DEFAULT NULL,
  `cityId` int(11) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `object`
--

CREATE TABLE `object` (
  `objectId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `objectCode` text NOT NULL,
  `objectType` int(1) NOT NULL,
  `objectName` text DEFAULT NULL,
  `objectBirthday` date DEFAULT NULL,
  `objectSwiftCode` text DEFAULT NULL,
  `objectIdCard_Number` text DEFAULT NULL,
  `objectIDCard_Date` date DEFAULT NULL,
  `objectIDCard_Place` text DEFAULT NULL,
  `objectContact_Phone` varchar(10) DEFAULT NULL,
  `objectContact_Fax` text DEFAULT NULL,
  `objectContact_PostalCode` text DEFAULT NULL,
  `objectContact_Email` text DEFAULT NULL,
  `objectLocation_TradePlace` text DEFAULT NULL,
  `objectTaxation_Tax` text DEFAULT NULL,
  `objectTaxation_BudgetCode` text DEFAULT NULL,
  `objectBank_AccountNumber` text DEFAULT NULL,
  `objectBank_Branch` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `object`
--

INSERT INTO `object` (`objectId`, `userId`, `objectCode`, `objectType`, `objectName`, `objectBirthday`, `objectSwiftCode`, `objectIdCard_Number`, `objectIDCard_Date`, `objectIDCard_Place`, `objectContact_Phone`, `objectContact_Fax`, `objectContact_PostalCode`, `objectContact_Email`, `objectLocation_TradePlace`, `objectTaxation_Tax`, `objectTaxation_BudgetCode`, `objectBank_AccountNumber`, `objectBank_Branch`) VALUES
(1, 1, '100', 1, 'Alec', '2020-07-22', 'quam. Pellentesque', '887417654', '2021-03-16', 'Wanaka', '0475849723', '06 09 61 22 81', '99-809', 'at.fringilla.purus@natoque.com', 'San Zenone degli Ezzelini', '7330725443331', 'nisl sem,', '5334', 'Yellowknife'),
(2, 1, '101', 1, 'Hunter', '2020-10-21', 'aliquet odio.', '504403741', '2021-05-31', 'Maintal', '0462418845', '09 68 75 27 47', '162037', 'leo@Ut.org', 'Loverval', '4378725993872', 'cursus. Nunc', '3353', 'Gibsons'),
(3, 1, '102', 1, 'Driscoll', '2020-11-28', 'lectus. Nullam', '699640047', '2021-12-15', 'Muzzafarabad', '0908984129', '01 32 98 87 85', '13334', 'lorem@ut.net', 'Stockport', '4808266680994', 'mauris ipsum', '2089', 'Oderzo'),
(4, 1, '103', 2, 'Jermaine', '2020-10-21', 'cursus in,', '583779764', '2021-12-15', 'Görlitz', '0694117963', '04 74 07 62 77', '481127', 'eu@arcu.org', 'Yellowhead County', '7791753327042', 'pharetra. Quisque', '6851', 'Gujranwala'),
(5, 1, '104', 2, 'Carlos', '2020-08-26', 'mattis ornare,', '744596956', '2020-09-16', 'Abeokuta', '0410811338', '02 59 27 07 63', '2289', 'sit.amet@tortordictumeu.com', 'Mansfield-et-Pontefract', '6577050612154', 'sollicitudin orci', '2125', 'Ortonovo'),
(6, 1, '105', 2, 'Phelan', '2021-01-01', 'suscipit, est', '383151809', '2021-03-15', 'Vishakhapatnam', '0861218190', '08 43 55 34 42', '117690', 'ante@liberoDonecconsectetuer.com', 'Braies/Prags', '8957080118063', 'scelerisque, lorem', '4616', 'Roxburgh'),
(7, 1, '106', 2, 'Dale', '2021-01-07', 'Vivamus sit', '305003278', '2021-02-03', 'Roccasicura', '0714413618', '01 13 29 02 08', '69850', 'turpis.vitae@montesnascetur.com', 'Bedollo', '1546468839524', 'accumsan neque', '6036', 'Kavaratti'),
(8, 1, '107', 1, 'Gage', '2020-06-01', 'Etiam imperdiet', '712398499', '2020-06-09', 'Kirkland', '0388712803', '02 17 96 57 97', '3640', 'tincidunt@Fuscefeugiat.net', 'Pettineo', '9917620428705', 'sociis natoque', '2286', 'Anantapur'),
(9, 1, '108', 1, 'Nasim', '2021-04-18', 'magna a', '504329025', '2021-01-22', 'Hangu', '0280786385', '01 75 74 89 49', '726999', 'sit.amet@pedePraesent.net', 'Quinte West', '6970032418854', 'arcu eu', '7781', 'Blieskastel'),
(10, 1, '109', 1, 'Beau', '2020-04-15', 'commodo tincidunt', '713515816', '2020-04-28', 'Qualicum Beach', '0720097023', '06 71 87 00 46', '4113', 'fames.ac@mollisnoncursus.ca', 'Pirna', '2630678886841', 'dis parturient', '9901', 'Vitacura'),
(11, 1, '110', 2, 'Hector', '2020-11-20', 'vel turpis.', '807902097', '2020-11-23', 'Kalat', '0049283267', '05 10 55 87 30', '42997', 'magna.nec@Mauriseu.com', 'Horsham', '2874276332244', 'sociis natoque', '3286', 'Lowestoft'),
(12, 1, '111', 2, 'Ashton', '2020-04-08', 'tortor. Nunc', '444385128', '2021-10-06', 'Villers-la-Tour', '0964116613', '08 12 48 41 34', 'Z1331', 'Donec@dolorFuscemi.co.uk', 'Coassolo Torinese', '4139716602869', 'natoque penatibus', '4037', 'Tufara'),
(13, 1, '112', 1, 'Murphy', '2020-07-14', 'velit egestas', '879975723', '2020-02-22', 'Sainte-Flavie', '0401005596', '02 60 29 17 88', '986789', 'lobortis@Mauriseuturpis.org', 'Tourcoing', '9781737368870', 'risus quis', '4926', 'Bhakkar'),
(14, 1, '113', 1, 'Salvador', '2020-12-06', 'luctus aliquet', '308337730', '2020-04-23', 'Armidale', '0375540485', '04 36 43 66 97', 'Z0198', 'Aenean.sed.pede@pedeet.com', 'Kooigem', '1762577445904', 'augue, eu', '1617', 'Hualaihué'),
(15, 1, '114', 2, 'Silas', '2020-06-24', 'non, lobortis', '141877086', '2020-05-06', 'Cerrillos', '0394992593', '06 37 00 61 69', '3689 MJ', 'dui@ipsum.edu', 'Zeist', '1972679367352', 'euismod et,', '3900', 'Tourinnes-Saint-Lambert'),
(16, 1, '115', 1, 'Alan', '2020-06-13', 'eros non', '374678541', '2021-01-15', 'Culiacán', '0858036125', '06 52 30 76 22', '29226', 'nulla@convallis.org', 'Bukittinggi', '1342009844291', 'egestas. Sed', '6052', 'North Vancouver'),
(17, 1, '116', 2, 'Xanthus', '2021-11-16', 'imperdiet ornare.', '166751456', '2021-08-19', 'Aiello Calabro', '0541088920', '02 53 71 88 92', '6532', 'ac.ipsum.Phasellus@eu.net', 'Great Falls', '6318482223635', 'arcu imperdiet', '3543', 'Pereira'),
(18, 1, '117', 1, 'Bruno', '2020-02-20', 'Mauris non', '805063908', '2020-04-02', 'Southaven', '0695153990', '01 50 84 07 94', '546325', 'in.faucibus.orci@sapiengravida.net', 'Łódź', '3243719388296', 'amet metus.', '5677', 'Comano'),
(19, 1, '118', 2, 'Hedley', '2020-02-13', 'diam vel', '274400839', '2021-08-01', 'Frauenkirchen', '0376584633', '04 54 23 78 01', 'RO2W 5OY', 'nisl.elementum@vitaemaurissit.co.uk', 'Antofagasta', '7221391188329', 'malesuada fames', '5521', 'Williams Lake'),
(20, 1, '119', 1, 'Gregory', '2020-07-06', 'tristique pellentesque,', '585281051', '2021-06-14', 'Melle', '0125690546', '06 38 46 07 80', '161831', 'magna.a@risus.co.uk', 'Bierk Bierghes', '5319339019974', 'egestas. Aliquam', '3521', 'Newbury'),
(21, 1, '120', 1, 'Jin', '2021-05-24', 'Sed malesuada', '410383166', '2020-04-10', 'Trier', '0861236113', '03 89 70 50 41', '62210', 'non@elementumpurus.co.uk', 'Oyen', '6802037710884', 'ac mattis', '5103', 'Zeveneken'),
(22, 1, '121', 2, 'Hamish', '2020-08-23', 'nunc. In', '791035311', '2021-07-24', 'Ilbono', '0831151951', '06 97 83 38 33', '26-066', 'at.auctor@Etiambibendumfermentum.ca', 'Broxburn', '3887423427356', 'vel, mauris.', '9860', 'Villar Pellice'),
(23, 1, '122', 2, 'Silas', '2021-10-30', 'interdum ligula', '139452425', '2021-05-20', 'Limoges', '0789080058', '01 05 81 26 96', '1416 MR', 'Lorem.ipsum@idblandit.com', 'Halle', '9290970637443', 'arcu. Vivamus', '9602', 'Ipatinga'),
(24, 1, '123', 1, 'Timon', '2020-11-16', 'Donec at', '672860715', '2021-11-12', 'San Diego', '0446947406', '04 94 15 07 88', '1996', 'enim@velitjustonec.net', 'Caloundra', '5785947738923', 'dui, in', '7497', 'Hohen Neuendorf'),
(25, 1, '124', 2, 'Silas', '2021-09-29', 'a, arcu.', '610152924', '2020-02-11', 'San Mauro Cilento', '0855501345', '09 43 93 49 48', '5650', 'consequat@netuset.co.uk', 'Wardin', '8179114030558', 'vulputate, lacus.', '7613', 'Devon'),
(26, 1, '125', 2, 'Dexter', '2020-09-30', 'egestas, urna', '350913900', '2021-11-30', 'Dewas', '0132986856', '08 87 83 47 91', '9649', 'non.massa@interdum.org', 'Laakdal', '4501117559229', 'faucibus id,', '9291', 'Petit-Thier'),
(27, 1, '126', 2, 'Herrod', '2021-10-01', 'Duis dignissim', '485557017', '2021-05-08', 'Kanchrapara', '0001017164', '03 21 11 21 94', '88738-98436', 'eu.enim@rutrum.edu', 'Tarnów', '8952581008646', 'congue a,', '3537', 'Nanded'),
(28, 1, '127', 1, 'Zachery', '2020-08-15', 'Curabitur dictum.', '545257195', '2021-02-25', 'Mjölby', '0640388080', '08 90 40 91 98', '511652', 'ullamcorper.eu@Proin.net', 'Coevorden', '8993633141587', 'sodales at,', '6150', '100 Mile House'),
(29, 1, '128', 1, 'Bernard', '2020-07-03', 'dignissim magna', '429494801', '2020-09-04', 'Ozherelye', '0004005576', '04 64 98 55 08', '1238', 'rhoncus@mattisvelit.org', 'Bellevue', '7122282972643', 'consectetuer rhoncus.', '5021', 'Cumnock'),
(30, 1, '129', 1, 'Cedric', '2020-07-21', 'convallis in,', '391879080', '2021-02-13', 'Bassiano', '0950707262', '07 04 27 69 48', '5589 NQ', 'nec.mauris.blandit@et.net', 'Narbonne', '3959892474001', 'vestibulum lorem,', '5856', 'Cranbrook'),
(31, 1, '130', 1, 'Hop', '2021-03-13', 'eu, ligula.', '364667198', '2020-09-13', 'Montpelier', '0599918237', '05 32 42 70 21', '159550', 'Nunc@tincidunt.com', 'Banbury', '2668502779787', 'Vestibulum ante', '4150', 'Castelbuono'),
(32, 1, '131', 1, 'Slade', '2020-02-12', 'augue ac', '143298151', '2020-09-30', 'Brusson', '0850585752', '05 75 31 23 44', '66167', 'magna.et.ipsum@nec.net', 'LaSalle', '8718551041770', 'Phasellus dolor', '7918', 'Cavasso Nuovo'),
(33, 1, '132', 1, 'Hiram', '2020-05-26', 'Proin vel', '584780141', '2020-09-14', 'Ravenstein', '0639392568', '05 30 46 25 84', '6291', 'sagittis@atsemmolestie.edu', 'Fermont', '9721695148771', 'dolor. Nulla', '5986', 'Marneffe'),
(34, 1, '133', 1, 'Gavin', '2020-05-18', 'vitae, orci.', '299778564', '2021-02-26', 'Lahore', '0744705221', '05 58 72 12 79', '233408', 'aliquam.arcu.Aliquam@commodoipsum.ca', 'Gwangju', '1507019304283', 'vulputate, risus', '2348', 'Girifalco'),
(35, 1, '134', 2, 'Geoffrey', '2022-01-09', 'pharetra, felis', '784566325', '2020-11-19', 'Shatura', '0349610747', '03 44 81 94 56', '11803', 'ipsum.Suspendisse@fames.co.uk', 'Fort Saskatchewan', '8239112212585', 'lectus pede', '9176', 'Biloxi'),
(36, 1, '135', 1, 'Lester', '2020-05-15', 'massa. Quisque', '339650755', '2021-12-26', 'Mesa', '0600376531', '05 43 86 57 32', '5191 IQ', 'arcu.Vestibulum.ante@Sedegetlacus.com', 'Stene', '4476641154840', 'senectus et', '2574', 'Vegreville'),
(37, 1, '136', 2, 'Zeph', '2021-09-08', 'facilisis facilisis,', '493353517', '2020-10-22', 'Lakewood', '0110233370', '08 93 58 05 80', '1950', 'mauris@lacusQuisque.edu', 'Soledad de Graciano Sánchez', '6081625471731', 'erat, in', '6584', 'Rapagnano'),
(38, 1, '137', 1, 'Camden', '2020-08-24', 'Nunc ut', '990291647', '2021-03-20', 'Bellegem', '0142193779', '09 47 69 67 33', '79663', 'Nunc.mauris.sapien@Nuncsed.ca', 'Morrovalle', '3175315921232', 'sed tortor.', '7082', 'Jennersdorf'),
(39, 1, '138', 1, 'Dominic', '2021-11-21', 'pharetra. Nam', '351210918', '2020-10-11', 'Laja', '0710458362', '07 37 09 76 59', '28221', 'nec@metusIn.net', 'Kinross', '2138150208924', 'Aenean euismod', '7540', 'Villa Agnedo'),
(40, 1, '139', 1, 'Ulric', '2021-10-21', 'Nullam suscipit,', '515129693', '2021-12-06', 'Omal', '0893372479', '09 72 58 84 58', '359068', 'eu@Mauris.org', 'Spiere', '7019283872755', 'Proin dolor.', '1885', 'Susegana'),
(41, 1, '140', 2, 'Fuller', '2021-10-28', 'hendrerit a,', '466526859', '2020-02-24', 'Malgesso', '0743576491', '06 24 33 04 25', '685205', 'dictum@nisisemsemper.co.uk', 'Gasp�', '2483954273023', 'metus sit', '5483', 'Milton Keynes'),
(42, 1, '141', 2, 'Oliver', '2020-12-30', 'lacus pede', '570195525', '2021-12-06', 'Sant\'Egidio alla Vibrata', '0847828850', '07 31 32 17 59', '89111-88296', 'posuere.vulputate.lacus@sollicitudin.net', 'Sainte-Flavie', '8283313685182', 'in, dolor.', '1259', 'Desteldonk'),
(43, 1, '142', 1, 'Oren', '2020-05-11', 'rutrum eu,', '356795065', '2020-05-14', 'Sitapur', '0812227391', '03 96 49 47 91', '290629', 'et.ipsum.cursus@augueidante.edu', 'Montegranaro', '9416339186842', 'at augue', '7872', 'Cherepovets'),
(44, 1, '143', 1, 'Fitzgerald', '2020-11-06', 'risus varius', '788710541', '2020-08-27', 'Pinneberg', '0542369423', '01 34 08 55 34', '625745', 'sit.amet@egestasligulaNullam.co.uk', 'Etobicoke', '1310434170776', 'sagittis semper.', '5839', 'Embourg'),
(45, 1, '144', 2, 'Orlando', '2020-12-24', 'vulputate velit', '711397050', '2021-03-05', 'Baracaldo', '0652895226', '02 11 14 57 46', '7352', 'in@duiCraspellentesque.edu', 'Mandurah', '6491918522928', 'Integer vulputate,', '3261', 'Thatta'),
(46, 1, '145', 1, 'Brady', '2021-02-23', 'posuere cubilia', '250749919', '2020-03-28', 'Vierzon', '0212203729', '04 43 58 51 94', 'Z0516', 'habitant.morbi.tristique@CurabiturmassaVestibulum.net', 'Kaaskerke', '5475423906381', 'ut, sem.', '7473', 'Rutland'),
(47, 1, '146', 2, 'Blake', '2021-06-11', 'lacus, varius', '332811585', '2022-01-06', 'Orciano Pisano', '0764614308', '08 14 81 15 54', '8131', 'vehicula@nulla.co.uk', 'Roermond', '4438107929474', 'est. Nunc', '6418', 'Beaumont'),
(48, 1, '147', 2, 'Kasimir', '2020-09-04', 'arcu. Vestibulum', '693768995', '2020-12-31', 'Bathurst', '0962303576', '02 57 63 41 13', '4565 WS', 'magna.nec.quam@lectusasollicitudin.net', 'Cache Creek', '7121218731708', 'netus et', '7940', 'Diego de Almagro'),
(49, 1, '148', 1, 'Tobias', '2020-09-21', 'Cum sociis', '247906958', '2020-05-25', 'Cabildo', '0780501268', '01 39 75 17 21', '95067', 'a.odio@condimentumDonec.ca', 'Pereira', '6878790511043', 'sodales at,', '6210', 'Los Muermos'),
(50, 1, '149', 1, 'Christian', '2020-11-29', 'non, egestas', '968285476', '2020-11-18', 'Hoeilaart', '0866750469', '01 04 19 72 49', '747964', 'in.magna@suscipitestac.edu', 'Calmar', '3714109950064', 'semper rutrum.', '7603', 'Cabo de Hornos'),
(51, 1, '150', 2, 'Chandler', '2020-04-11', 'Phasellus elit', '637712956', '2020-02-23', 'Evansville', '0787147010', '08 00 09 41 15', '619076', 'et.ultrices@nunc.net', 'Gagliano del Capo', '8901407132638', 'Pellentesque tincidunt', '3134', 'Drogenbos'),
(52, 1, '151', 1, 'Hiram', '2021-02-13', 'elit. Curabitur', '962536649', '2020-09-17', 'Jamioulx', '0415406008', '04 76 24 46 99', '70607', 'cursus.et@Ut.edu', 'Santiago', '9638346564295', 'eu enim.', '3318', 'Salon-de-Provence'),
(53, 1, '152', 2, 'Gabriel', '2021-09-09', 'non, dapibus', '718665124', '2020-09-01', 'Sinaai-Waas', '0207603054', '04 52 79 71 33', '67254-336', 'massa.lobortis@urnasuscipit.com', 'Lewiston', '9374907712386', 'et nunc.', '5390', 'Bègles'),
(54, 1, '153', 1, 'Omar', '2021-10-22', 'vitae velit', '320222808', '2020-07-08', 'Finkenstein am Faaker See', '0036447745', '08 37 26 42 11', '8198', 'ac@nequeMorbiquis.co.uk', 'Völklingen', '9842520744063', 'Sed auctor', '7199', 'Reinbek'),
(55, 1, '154', 1, 'Neil', '2021-05-06', 'Integer mollis.', '270591054', '2022-01-07', 'Malvern', '0112308650', '04 31 04 84 16', '70113', 'tellus.lorem.eu@molestiein.co.uk', 'Ville-en-Hesbaye', '8508605155808', 'a, aliquet', '3092', 'Guysborough'),
(56, 1, '155', 2, 'Fuller', '2022-01-04', 'lorem, vehicula', '649847015', '2021-03-01', 'Killa Abdullah', '0095284037', '05 57 24 04 17', '17634', 'sodales.elit@Nulla.com', 'San Martino in Pensilis', '4720008236664', 'commodo auctor', '6504', 'Bath'),
(57, 1, '156', 2, 'Brett', '2020-07-24', 'non, dapibus', '116693068', '2020-03-31', 'Marystown', '0558120873', '06 16 46 97 01', '478550', 'luctus.et@luctus.edu', 'College', '1473262174815', 'tincidunt, nunc', '5131', 'Kaneohe'),
(58, 1, '157', 2, 'Fritz', '2020-03-10', 'odio, auctor', '205941340', '2020-11-24', 'Belcarra', '0430740827', '06 28 99 60 22', '74714-25515', 'sodales.at@ornareplacerat.com', 'Shrewsbury', '9764365751772', 'risus quis', '7120', 'Torreón'),
(59, 1, '158', 1, 'Akeem', '2020-11-03', 'Cum sociis', '754650520', '2021-01-23', 'Plainevaux', '0453460346', '08 15 57 40 02', '621450', 'nisl.arcu@hendrerit.org', 'Piancastagnaio', '7394790761109', 'dui. Cras', '1724', 'Ancaster Town'),
(60, 1, '159', 1, 'Quamar', '2021-03-29', 'Phasellus fermentum', '103229116', '2021-05-22', 'Cerrillos', '0767086153', '03 65 39 81 85', 'A07 7OB', 'faucibus.Morbi.vehicula@molestie.org', 'Nelson', '2506009219095', 'massa non', '5888', 'Pedace'),
(61, 1, '160', 1, 'Keaton', '2020-03-27', 'nisl. Nulla', '618878043', '2021-10-24', 'Elsene', '0050826133', '03 80 51 82 72', '6766', 'facilisis.facilisis.magna@lorem.net', 'Sint-Amandsberg', '9623343964103', 'at, libero.', '4907', 'Meduno'),
(62, 1, '161', 1, 'Zephania', '2020-04-29', 'Cum sociis', '109073278', '2021-04-12', 'Milena', '0180383225', '02 00 12 00 99', '5102', 'euismod.mauris.eu@mattisvelitjusto.com', 'Ajax', '7692804613527', 'ultrices a,', '5195', 'BiercŽe'),
(63, 1, '162', 2, 'Yuli', '2020-02-11', 'lectus. Cum', '167476381', '2021-10-12', 'La Plata', '0661228554', '06 55 84 44 14', '61500-904', 'auctor.ullamcorper@urna.edu', 'Melbourne', '8600700178040', 'gravida molestie', '7672', 'Bhakkar'),
(64, 1, '163', 2, 'Dieter', '2020-10-21', 'placerat, orci', '452381841', '2021-09-16', 'Nakusp', '0762024016', '06 42 42 96 76', '802330', 'hendrerit.Donec.porttitor@lacusvestibulumlorem.com', 'Burgos', '8368539872646', 'felis eget', '7463', 'WagnelŽe'),
(65, 1, '164', 2, 'Walter', '2020-10-10', 'eu nibh', '504018188', '2020-07-28', 'Ladispoli', '0988713826', '07 98 53 38 48', '59419', 'Cras.convallis@consequatnecmollis.ca', 'Giarratana', '5410022586385', 'pede. Cras', '8830', 'Suxy'),
(66, 1, '165', 2, 'James', '2020-05-03', 'arcu. Sed', '983495330', '2021-02-18', 'Jhansi', '0680562449', '09 60 92 44 21', 'KR86 8UX', 'Quisque@NullainterdumCurabitur.org', 'Milford Haven', '5192253963985', 'facilisi. Sed', '9026', 'Mora'),
(67, 1, '166', 1, 'Rashad', '2020-02-11', 'nibh dolor,', '660502057', '2022-01-25', 'Sigillo', '0512731214', '06 96 34 70 91', '38-450', 'porttitor.interdum.Sed@eget.net', 'Rattray', '5539829627714', 'Integer sem', '6412', 'Limoges'),
(68, 1, '167', 2, 'Josiah', '2020-05-08', 'in lobortis', '793108068', '2020-03-04', 'Hollange', '0957204949', '08 32 02 15 97', '36959', 'eu.nulla@lectusNullamsuscipit.co.uk', 'Sambalpur', '7803083360422', 'Morbi vehicula.', '7912', 'Tsiigehtchic'),
(69, 1, '168', 1, 'Brenden', '2020-05-08', 'lorem, auctor', '499578872', '2021-03-21', 'Sivry', '0155138330', '03 85 99 65 93', '12-133', 'non.dui@pedeblanditcongue.edu', 'Westmount', '9891542797219', 'Vestibulum ante', '1487', 'Spokane'),
(70, 1, '169', 2, 'Vaughan', '2021-04-14', 'lacus. Mauris', '471541276', '2020-12-14', 'Nuragus', '0677460455', '08 82 45 63 45', '14-506', 'facilisis@non.com', 'Mielec', '4186628868498', 'fringilla cursus', '2391', 'Fraser Lake'),
(71, 1, '170', 1, 'Tiger', '2021-02-18', 'nisi sem', '770285090', '2021-01-10', 'Yorkton', '0473965176', '03 96 21 78 89', '1628', 'vehicula@magnaPraesentinterdum.com', 'Sint-Pauwels', '2001028885981', 'tincidunt congue', '7818', 'Skegness'),
(72, 1, '171', 1, 'Lucian', '2021-11-29', 'aliquet magna', '263807635', '2021-11-25', 'Barddhaman', '0601967666', '06 42 45 45 18', '36544', 'semper.Nam@sitamet.edu', 'CŽroux-Mousty', '7131346018534', 'rhoncus id,', '1113', 'Sainte-Ode'),
(73, 1, '172', 2, 'Drake', '2021-02-13', 'velit eget', '742441946', '2021-02-04', 'Sambuca Pistoiese', '0790123968', '01 75 05 57 60', '12044', 'semper.pretium.neque@a.co.uk', 'Crescentino', '5611369452900', 'amet, consectetuer', '7235', 'Vijayawada'),
(74, 1, '173', 1, 'Todd', '2021-02-15', 'in, hendrerit', '744485305', '2021-12-21', 'Coaldale', '0294743583', '05 44 16 84 25', 'AD01 5BA', 'arcu.eu@egestasrhoncus.org', 'Yegoryevsk', '9317212599537', 'Duis dignissim', '7327', 'Toronto'),
(75, 1, '174', 2, 'Erasmus', '2021-11-08', 'Nunc mauris', '100542179', '2021-05-13', 'Jasper', '0065932139', '08 49 08 66 06', '96877', 'eu.euismod@tinciduntadipiscing.co.uk', 'Tiegem', '2392785471419', 'nulla ante,', '5038', 'Forchies-la-Marche'),
(76, 1, '175', 1, 'Raja', '2021-07-27', 'dictum eu,', '897859169', '2021-11-11', 'Zolder', '0815465892', '04 02 60 81 55', '24260', 'a.sollicitudin@Nunc.edu', 'Hamburg', '6601410405157', 'feugiat tellus', '3853', 'Bouffioulx'),
(77, 1, '176', 2, 'Justin', '2020-02-21', 'habitant morbi', '737043950', '2020-07-30', 'Prestatyn', '0526094648', '01 65 24 95 27', '35777', 'tellus.justo@Proinvel.net', 'Uruapan', '1581510140496', 'Pellentesque ut', '4471', 'Uijeongbu'),
(78, 1, '177', 1, 'Ferdinand', '2020-06-10', 'pretium et,', '783516403', '2020-07-15', 'Auldearn', '0735236943', '08 13 35 34 03', '20194', 'eget@lobortis.co.uk', 'Bloomington', '3079531288237', 'sagittis. Duis', '5943', 'Laino Castello'),
(79, 1, '178', 1, 'Hector', '2020-09-27', 'nonummy ultricies', '206317443', '2021-03-31', 'Florianópolis', '0999144365', '04 62 28 75 98', '362636', 'neque.In@odiovel.co.uk', 'Winterswijk', '6763373516099', 'tincidunt adipiscing.', '4918', 'Villa Santo Stefano'),
(80, 1, '179', 2, 'Chancellor', '2020-12-08', 'magna et', '121308483', '2020-10-17', 'Falun', '0660851334', '09 09 91 68 11', 'ZK7X 9XT', 'adipiscing@atauctor.org', 'Castellana Sicula', '4547159459429', 'placerat velit.', '2675', 'Königs Wusterhausen'),
(81, 1, '180', 1, 'Vladimir', '2020-10-31', 'dictum mi,', '254749111', '2021-04-07', 'Cariboo Regional District', '0769881243', '01 96 67 05 45', '805051', 'vel.sapien@semperrutrum.edu', 'Hay River', '3921418239794', 'sed, est.', '2583', 'Nanton'),
(82, 1, '181', 1, 'Hayes', '2021-06-12', 'urna, nec', '658290520', '2021-05-03', 'Cappelle sul Tavo', '0339940143', '02 92 97 06 46', '455125', 'convallis.convallis.dolor@Proin.co.uk', 'Castellina in Chianti', '1925140115415', 'faucibus orci', '3820', 'Ongole'),
(83, 1, '182', 2, 'Warren', '2021-01-03', 'ac, eleifend', '841623927', '2021-08-07', 'San Martino in Badia/St. Martin in Thurn', '0501683368', '08 13 40 56 42', '58848-955', 'Proin.velit@iaculis.net', 'Mersin', '9954505989445', 'a, facilisis', '3363', 'Monclova'),
(84, 1, '183', 2, 'Linus', '2021-04-17', 'consectetuer adipiscing', '817908953', '2021-05-11', 'Saint-Eug�ne-de-Ladri�re', '0539176275', '03 50 48 04 91', '2138', 'vitae.velit@elit.org', 'Shipshaw', '2989725126881', 'tristique senectus', '9445', 'Sylvan Lake'),
(85, 1, '184', 1, 'Ian', '2021-04-28', 'vehicula risus.', '325371298', '2020-03-05', 'Gifhorn', '0040933094', '06 31 10 03 63', '8597', 'lacus.Ut@rutrum.net', 'Pickering', '5054771762383', 'nec luctus', '8419', 'Ranchi'),
(86, 1, '185', 2, 'Boris', '2021-02-17', 'Nunc quis', '104139508', '2020-11-27', 'Casacalenda', '0921434510', '05 08 24 95 77', '71547-33091', 'Curae@molestietortornibh.com', 'Ibadan', '9043014876065', 'Mauris quis', '2053', 'Strathcona County'),
(87, 1, '186', 1, 'Hammett', '2020-05-18', 'enim nec', '223316261', '2020-07-05', 'Villers-la-Tour', '0519360002', '07 57 13 87 96', '4874', 'risus.Quisque@lacusUt.co.uk', 'Sindelfingen', '4320831237032', 'Suspendisse dui.', '6314', 'Bala'),
(88, 1, '187', 1, 'Benjamin', '2021-11-12', 'ullamcorper. Duis', '228564836', '2021-03-25', 'Recklinghausen', '0077980993', '03 55 21 97 53', '42893', 'hymenaeos.Mauris@Curabitursed.ca', 'Wolverhampton', '2934583024942', 'non lorem', '1118', 'Huntsville'),
(89, 1, '188', 2, 'Oren', '2021-06-10', 'a, magna.', '284229825', '2021-05-18', 'Gianico', '0989477762', '05 47 97 27 70', '84501', 'ornare.libero@ornare.org', 'Pollein', '5042227893575', 'nisi dictum', '8259', 'Falerone'),
(90, 1, '189', 2, 'Zachery', '2021-02-22', 'facilisis vitae,', '728410292', '2020-07-07', 'Saltillo', '0708151424', '02 77 28 57 15', '71448', 'tempor.augue.ac@porttitor.edu', 'Rio Marina', '5455173387157', 'faucibus orci', '3313', 'Frankenthal'),
(91, 1, '190', 2, 'Jasper', '2021-05-24', 'enim nisl', '291398577', '2021-05-29', 'Forio', '0287012345', '07 95 47 67 03', '96392', 'et.libero.Proin@eu.com', 'Santomenna', '3951336921549', 'tortor. Nunc', '4009', 'Parla'),
(92, 1, '191', 1, 'Stone', '2020-07-15', 'at, nisi.', '548330831', '2020-05-19', 'Enschede', '0845384234', '08 77 80 32 96', '9192', 'et@amet.com', 'Mumbai', '6201664662091', 'Ut sagittis', '8566', 'Firenze'),
(93, 1, '192', 1, 'Keith', '2020-05-11', 'sit amet', '534554703', '2021-12-02', 'Murray Bridge', '0488729283', '09 02 46 32 37', '8957', 'dictum.placerat.augue@metusVivamus.co.uk', 'Springdale', '2014281123335', 'amet nulla.', '3043', 'Lapscheure'),
(94, 1, '193', 1, 'Orlando', '2021-06-22', 'eu, accumsan', '799445809', '2020-11-08', 'Castelvecchio di Rocca Barbena', '0611476644', '05 09 99 31 00', 'HK4T 0VR', 'rutrum.Fusce.dolor@molestiearcuSed.edu', 'Andong', '4086293065937', 'sagittis semper.', '7494', 'Korocha'),
(95, 1, '194', 1, 'Laith', '2021-01-10', 'sem, vitae', '648187637', '2020-09-05', 'Liévin', '0228993116', '05 28 18 69 16', '575926', 'condimentum@ipsumsodales.org', 'Brora', '5641191279860', 'Etiam imperdiet', '8151', 'Limburg a.d. Lahn'),
(96, 1, '195', 1, 'Derek', '2021-05-11', 'hymenaeos. Mauris', '565020535', '2021-05-05', 'Ajax', '0870813420', '09 40 51 84 25', '5350 OZ', 'Fusce@atpedeCras.com', 'Collines-de-l\'Outaouais', '6022027980853', 'vehicula aliquet', '2030', 'Stokkem'),
(97, 1, '196', 2, 'Galvin', '2020-03-20', 'euismod in,', '446149100', '2020-11-13', 'Modinagar', '0654989237', '01 67 70 68 09', '499773', 'rhoncus.Donec.est@idsapien.org', 'Southaven', '6687978429492', 'nulla. Integer', '1550', 'Monteu Roero'),
(98, 1, '197', 1, 'Samson', '2021-08-09', 'nec enim.', '682734810', '2021-03-16', 'Miass', '0088105417', '01 66 60 71 74', '7533', 'Nullam.lobortis@ipsum.co.uk', 'Torrevieja', '2119099178346', 'viverra. Maecenas', '6234', 'Basingstoke'),
(99, 1, '198', 1, 'Colt', '2020-06-19', 'egestas a,', '903426546', '2020-09-01', 'Nothomb', '0254648269', '03 31 05 42 61', '3243', 'aliquet@consectetuer.ca', 'Haripur', '7483796710000', 'vitae purus', '6925', 'Juazeiro'),
(100, 1, '199', 2, 'Luke', '2021-05-15', 'lorem, eget', '606206503', '2020-12-23', 'Illkirch-Graffenstaden', '0055345794', '01 30 30 81 00', 'Z4092', 'sapien.gravida@Proin.org', 'Belo Horizonte', '2887478503229', 'a mi', '7734', 'San Pietro al Tanagro');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permission`
--

CREATE TABLE `permission` (
  `permissionId` int(11) NOT NULL,
  `functionId` int(11) NOT NULL,
  `actionId` int(11) NOT NULL,
  `userRoleId` int(11) NOT NULL,
  `isPermission` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `permission`
--

INSERT INTO `permission` (`permissionId`, `functionId`, `actionId`, `userRoleId`, `isPermission`) VALUES
(1, 1, 1, 1, 1),
(2, 1, 2, 1, 1),
(3, 1, 3, 1, 1),
(4, 1, 4, 1, 1),
(5, 1, 5, 1, 1),
(6, 2, 2, 1, 1),
(7, 2, 3, 1, 1),
(8, 2, 4, 1, 1),
(9, 2, 5, 1, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `userId` int(11) NOT NULL,
  `objectSid` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `accountName` varchar(40) NOT NULL,
  `email` text DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `isLocal` tinyint(1) NOT NULL DEFAULT 1,
  `fullName` varchar(40) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `workplace` text DEFAULT NULL,
  `userNote` text DEFAULT NULL,
  `avatar` text DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`userId`, `objectSid`, `accountName`, `email`, `password`, `isLocal`, `fullName`, `title`, `workplace`, `userNote`, `avatar`, `inactive`) VALUES
(1, NULL, 'ad', NULL, '523af537946b79c4f8369ed39ba78605', 1, 'administrator', NULL, NULL, NULL, NULL, 0),
(2, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,232,3,0,0]}', 'daolt', NULL, NULL, 2, 'DAO LE TIEN', NULL, NULL, NULL, NULL, 0),
(3, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,81,4,0,0]}', 'hienvv', NULL, NULL, 2, 'HIEN VU VAN', NULL, NULL, NULL, NULL, 0),
(4, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,169,4,0,0]}', 'hungbt', NULL, NULL, 2, 'BUI THANH HUNG', NULL, NULL, 'Pho Phong tai chinh ke toan', NULL, 0),
(5, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,170,4,0,0]}', 'phuongdtl', NULL, NULL, 2, 'DANG THI LAN PHUONG', NULL, NULL, NULL, NULL, 0),
(6, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,171,4,0,0]}', 'anht', NULL, NULL, 2, 'HOANG THUY AN', NULL, NULL, NULL, NULL, 0),
(7, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,172,4,0,0]}', 'tuanna2', NULL, NULL, 2, 'NGUYEN ANH TUAN', NULL, NULL, NULL, NULL, 0),
(8, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,173,4,0,0]}', 'thomnt', NULL, NULL, 2, 'NGUYEN THI THOM', NULL, NULL, 'Ke toan van phong Mien Nam', NULL, 0),
(9, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,174,4,0,0]}', 'anhnp', NULL, NULL, 2, 'NGUYEN PHUONG ANH', NULL, NULL, NULL, NULL, 0),
(10, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,175,4,0,0]}', 'hoavn', NULL, NULL, 2, 'VU NGOC HOA', NULL, NULL, NULL, NULL, 0),
(11, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,176,4,0,0]}', 'tunght', NULL, NULL, 2, 'HOANG THANH TUNG', NULL, NULL, 'Truong Phong tai chinh ke toan', NULL, 0),
(12, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,177,4,0,0]}', 'xuanntn', NULL, NULL, 2, 'NGUYEN THI NGOC XUAN', NULL, NULL, 'Ke toan van phong Mien Nam', NULL, 0),
(13, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,178,4,0,0]}', 'phuonglm', NULL, NULL, 2, 'LE MAI PHUONG', NULL, NULL, NULL, NULL, 0),
(14, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,179,4,0,0]}', 'nhungpth', NULL, NULL, 2, 'PHAM THI HONG NHUNG', NULL, NULL, NULL, NULL, 0),
(15, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,180,4,0,0]}', 'annt', NULL, NULL, 2, 'NGUYEN THI AN', NULL, NULL, NULL, NULL, 0),
(16, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,181,4,0,0]}', 'mync', NULL, NULL, 2, 'NGUYEN CAM MY', NULL, NULL, NULL, NULL, 0),
(17, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,182,4,0,0]}', 'phuongvt1', NULL, NULL, 2, 'VU THU PHUONG', NULL, NULL, 'Truong ban nhan su', NULL, 0),
(18, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,183,4,0,0]}', 'kienpt', NULL, NULL, 2, 'PHAM THANH KIEN', NULL, NULL, NULL, NULL, 0),
(19, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,184,4,0,0]}', 'thangnd', NULL, NULL, 2, 'NGUYEN DINH THANG', NULL, NULL, NULL, NULL, 0),
(20, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,185,4,0,0]}', 'nhanth', NULL, NULL, 2, 'TA HOANG NHAN', NULL, NULL, NULL, NULL, 0),
(21, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,187,4,0,0]}', 'toaitt', NULL, NULL, 2, 'TRAN THANH TOAI', NULL, NULL, NULL, NULL, 0),
(22, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,189,4,0,0]}', 'trangmtt', NULL, NULL, 2, 'MAI THI THUYEN TRANG', NULL, NULL, NULL, NULL, 0),
(23, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,190,4,0,0]}', 'nguyenntd', NULL, NULL, 2, 'NGUYEN THI DON NGUYEN', NULL, NULL, NULL, NULL, 0),
(24, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,191,4,0,0]}', 'huongnt', NULL, NULL, 2, 'NGUYEN THI HUONG', NULL, NULL, NULL, NULL, 0),
(25, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,192,4,0,0]}', 'thuynp', NULL, NULL, 2, 'NGUYEN PHUONG THUY', NULL, NULL, NULL, NULL, 0),
(26, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,193,4,0,0]}', 'tondt', NULL, NULL, 2, 'DUONG THANH TON', NULL, NULL, NULL, NULL, 1),
(27, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,196,4,0,0]}', 'ngocdv', NULL, NULL, 2, 'DUONG VAN NGOC', NULL, NULL, NULL, NULL, 1),
(28, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,197,4,0,0]}', 'anptt', NULL, NULL, 2, 'PHAM THI THUY AN', NULL, NULL, NULL, NULL, 0),
(29, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,198,4,0,0]}', 'minhnt', NULL, NULL, 2, 'NGUYEN THI MINH', NULL, NULL, NULL, NULL, 0),
(30, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,200,4,0,0]}', 'chautm', NULL, NULL, 2, 'TRINH MINH CHAU', NULL, NULL, NULL, NULL, 0),
(31, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,201,4,0,0]}', 'duongnh', NULL, NULL, 2, 'NGUYEN HOANG DUONG', NULL, NULL, NULL, NULL, 0),
(32, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,202,4,0,0]}', 'minhnb', NULL, NULL, 2, 'NGUYEN BINH MINH', NULL, NULL, NULL, NULL, 0),
(33, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,203,4,0,0]}', 'hungdt', NULL, NULL, 2, 'DANG THANH HUNG', NULL, NULL, NULL, NULL, 0),
(34, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,204,4,0,0]}', 'tuannta', NULL, NULL, 2, 'NGUYEN TIEN ANH TUAN', NULL, NULL, NULL, NULL, 0),
(35, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,205,4,0,0]}', 'nhondh', NULL, NULL, 2, 'DANG HIEU NHON', NULL, NULL, NULL, NULL, 0),
(36, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,206,4,0,0]}', 'phuongnh', NULL, NULL, 2, 'NGUYEN HIEN PHUONG', NULL, NULL, NULL, NULL, 0),
(37, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,207,4,0,0]}', 'maihp', NULL, NULL, 2, 'HOANG PHUONG MAI', NULL, NULL, NULL, NULL, 0),
(38, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,209,4,0,0]}', 'linhdt', NULL, NULL, 2, 'DO THUY LINH', NULL, NULL, NULL, NULL, 0),
(39, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,210,4,0,0]}', 'linhnt', NULL, NULL, 2, 'NGUYEN THUY LINH', NULL, NULL, NULL, NULL, 0),
(40, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,211,4,0,0]}', 'phuongph', NULL, NULL, 2, 'PHAM HONG PHUONG', NULL, NULL, NULL, NULL, 0),
(41, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,212,4,0,0]}', 'dungnt', NULL, NULL, 2, 'NGUYEN THUY DUNG', NULL, NULL, NULL, NULL, 0),
(42, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,213,4,0,0]}', 'thuyntt', NULL, NULL, 2, 'NGUYEN THI THU THUY', NULL, NULL, NULL, NULL, 0),
(43, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,214,4,0,0]}', 'loantt', NULL, NULL, 2, 'TRAN THI LOAN', NULL, NULL, NULL, NULL, 0),
(44, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,215,4,0,0]}', 'senvth', NULL, NULL, 2, 'VO THI HUONG SEN', NULL, NULL, NULL, NULL, 0),
(45, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,216,4,0,0]}', 'linhntd', NULL, NULL, 2, 'NGUYEN THI DINH LINH', NULL, NULL, NULL, NULL, 0),
(46, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,217,4,0,0]}', 'lamnth', NULL, NULL, 2, 'NGUYEN THI HONG LAM', NULL, NULL, NULL, NULL, 0),
(47, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,218,4,0,0]}', 'ngalt', NULL, NULL, 2, 'LE THUY NGA', NULL, NULL, NULL, NULL, 0),
(48, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,219,4,0,0]}', 'salv', NULL, NULL, 2, 'LE VI SA', NULL, NULL, NULL, NULL, 0),
(49, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,220,4,0,0]}', 'hiendtt', NULL, NULL, 2, 'DOAN THI THU HIEN', NULL, NULL, NULL, NULL, 0),
(50, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,221,4,0,0]}', 'diemntm', NULL, NULL, 2, 'NGUYEN THI MONG DIEM', NULL, NULL, 'Ke toan van phong Mien Trung', NULL, 0),
(51, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,223,4,0,0]}', 'thaonv', NULL, NULL, 2, 'NGUYEN VAN THAO', NULL, NULL, NULL, NULL, 0),
(52, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,224,4,0,0]}', 'nhungnt', NULL, NULL, 2, 'NGUYEN THI NHUNG', NULL, NULL, NULL, NULL, 0),
(53, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,225,4,0,0]}', 'trangdh', NULL, NULL, 2, 'DAO HUYEN TRANG', NULL, NULL, NULL, NULL, 0),
(54, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,227,4,0,0]}', 'thaoptt', NULL, NULL, 2, 'PHAN THI THU THAO', NULL, NULL, NULL, NULL, 0),
(55, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,229,4,0,0]}', 'thaobt', NULL, NULL, 2, 'BUI THI THAO', NULL, NULL, NULL, NULL, 0),
(56, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,230,4,0,0]}', 'thuyvtt', NULL, NULL, 2, 'VU THI THUY THUY', NULL, NULL, NULL, NULL, 0),
(57, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,231,4,0,0]}', 'myntt', NULL, NULL, 2, 'NGUYEN THI TRA MY', NULL, NULL, NULL, NULL, 0),
(58, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,232,4,0,0]}', 'anhdv', NULL, NULL, 2, 'DOAN VAN ANH', NULL, NULL, NULL, NULL, 0),
(59, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,233,4,0,0]}', 'maibt', NULL, NULL, 2, 'BUI THI MAI', NULL, NULL, NULL, NULL, 0),
(60, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,234,4,0,0]}', 'khoilh', NULL, NULL, 2, 'LE HUY KHOI', NULL, NULL, NULL, NULL, 0),
(61, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,235,4,0,0]}', 'tuanna', NULL, NULL, 2, 'NGUYEN ANH TUAN', NULL, NULL, NULL, NULL, 0),
(62, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,236,4,0,0]}', 'quanght', NULL, NULL, 2, 'HOANG TA QUANG', NULL, NULL, NULL, NULL, 0),
(63, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,237,4,0,0]}', 'hungnp', NULL, NULL, 2, 'NGUYEN PHU HUNG', NULL, NULL, NULL, NULL, 0),
(64, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,238,4,0,0]}', 'truongpn', NULL, NULL, 2, 'PHAM NGOC TRUONG', NULL, NULL, NULL, NULL, 0),
(65, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,239,4,0,0]}', 'tungnht', NULL, NULL, 2, 'NGUYEN HUU THANH TUNG', NULL, NULL, NULL, NULL, 0),
(66, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,240,4,0,0]}', 'quyetth', NULL, NULL, 2, 'TRAN HUNG QUYET', NULL, NULL, NULL, NULL, 0),
(67, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,242,4,0,0]}', 'hoanlk', NULL, NULL, 2, 'LE KHAC HOAN', NULL, NULL, NULL, NULL, 0),
(68, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,244,4,0,0]}', 'kiemvv', NULL, NULL, 2, 'VUONG VAN KIEM', NULL, NULL, NULL, NULL, 0),
(69, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,245,4,0,0]}', 'ngocnt', NULL, NULL, 2, 'NGUYEN TUAN NGOC', NULL, NULL, NULL, NULL, 0),
(70, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,246,4,0,0]}', 'cuongpd', NULL, NULL, 2, 'PHAM DUC CUONG', NULL, NULL, NULL, NULL, 0),
(71, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,247,4,0,0]}', 'suunv', NULL, NULL, 2, 'NGUYEN VAN SUU', NULL, NULL, NULL, NULL, 0),
(72, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,249,4,0,0]}', 'hoanq', NULL, NULL, 2, 'NGUYEN QUANG HOA', NULL, NULL, NULL, NULL, 0),
(73, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,250,4,0,0]}', 'thunv', NULL, NULL, 2, 'NGUYEN VAN THU', NULL, NULL, NULL, NULL, 0),
(74, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,251,4,0,0]}', 'longnm', NULL, NULL, 2, 'NGUYEN MAI LONG', NULL, NULL, NULL, NULL, 0),
(75, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,253,4,0,0]}', 'namlh', NULL, NULL, 2, 'LE HOAI NAM', NULL, NULL, NULL, NULL, 0),
(76, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,254,4,0,0]}', 'loitx', NULL, NULL, 2, 'TRAN XUAN LOI', NULL, NULL, NULL, NULL, 0),
(77, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,255,4,0,0]}', 'datdt', NULL, NULL, 2, 'DAM THANH DAT', NULL, NULL, NULL, NULL, 0),
(78, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,0,5,0,0]}', 'huydt', NULL, NULL, 2, 'DAO TANG HUY', NULL, NULL, NULL, NULL, 0),
(79, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,1,5,0,0]}', 'hunghv', NULL, NULL, 2, 'HOANG VIET HUNG', NULL, NULL, NULL, NULL, 0),
(80, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,3,5,0,0]}', 'tamhv', NULL, NULL, 2, 'HA VAN TAM', NULL, NULL, NULL, NULL, 0),
(81, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,4,5,0,0]}', 'ducnb', NULL, NULL, 2, 'NGUYEN BA DUC', NULL, NULL, NULL, NULL, 0),
(82, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,5,5,0,0]}', 'locbd', NULL, NULL, 2, 'BUI DUY LOC', NULL, NULL, NULL, NULL, 0),
(83, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,7,5,0,0]}', 'thanhtc', NULL, NULL, 2, 'TRAN CHI THANH', NULL, NULL, NULL, NULL, 0),
(84, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,9,5,0,0]}', 'huylq', NULL, NULL, 2, 'LE QUANG HUY', NULL, NULL, NULL, NULL, 0),
(85, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,10,5,0,0]}', 'duongbn', NULL, NULL, 2, 'BUI NGOC DUONG', NULL, NULL, NULL, NULL, 0),
(86, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,36,5,0,0]}', 'chautt', NULL, NULL, 2, 'TRAN THAI CHAU', NULL, NULL, NULL, NULL, 0),
(87, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,37,5,0,0]}', 'hungtt', NULL, NULL, 2, 'TRAN THANH HUNG', NULL, NULL, NULL, NULL, 0),
(88, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,45,5,0,0]}', 'trungpt', NULL, NULL, 2, 'PHAM TAN TRUNG', NULL, NULL, NULL, NULL, 0),
(89, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,60,5,0,0]}', 'thuanlv', NULL, NULL, 2, 'LUONG VAN THUAN', NULL, NULL, NULL, NULL, 0),
(90, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,61,5,0,0]}', 'manhhd', NULL, NULL, 2, 'HO DUC MANH', NULL, NULL, NULL, NULL, 0),
(91, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,67,5,0,0]}', 'cath', NULL, NULL, 2, 'TRAN HOANG CA', NULL, NULL, NULL, NULL, 0),
(92, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,69,5,0,0]}', 'landt', NULL, NULL, 2, 'DAO TRONG LAN', NULL, NULL, NULL, NULL, 0),
(93, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,76,5,0,0]}', 'duydv', NULL, NULL, 2, 'DUONG VAN DUY', NULL, NULL, NULL, NULL, 0),
(94, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,82,5,0,0]}', 'thangnv', NULL, NULL, 2, 'NGUYEN VIET THANG', NULL, NULL, NULL, NULL, 0),
(95, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,83,5,0,0]}', 'longvv', NULL, NULL, 2, 'VU VAN LONG', NULL, NULL, NULL, NULL, 0),
(96, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,84,5,0,0]}', 'trungdt1', NULL, NULL, 2, 'DUONG THANH TRUNG', NULL, NULL, NULL, NULL, 0),
(97, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,86,5,0,0]}', 'laiht', NULL, NULL, 2, 'HUYNH TAN LAI', NULL, NULL, NULL, NULL, 0),
(98, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,87,5,0,0]}', 'hongnv', NULL, NULL, 2, 'NGUYEN VAN HONG', NULL, NULL, NULL, NULL, 0),
(99, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,88,5,0,0]}', 'thiennb', NULL, NULL, 2, 'NGUYEN BA THIEN', NULL, NULL, NULL, NULL, 0),
(100, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,89,5,0,0]}', 'tult', NULL, NULL, 2, 'LE THANH TU', NULL, NULL, NULL, NULL, 0),
(101, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,90,5,0,0]}', 'haudp', NULL, NULL, 2, 'DANG PHUOC HAU', NULL, NULL, NULL, NULL, 0),
(102, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,93,5,0,0]}', 'dungnh', NULL, NULL, 2, 'NGUYEN HUU DUNG', NULL, NULL, NULL, NULL, 0),
(103, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,94,5,0,0]}', 'vuht', NULL, NULL, 2, 'HONG TUAN VU', NULL, NULL, NULL, NULL, 0),
(104, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,96,5,0,0]}', 'phovp', NULL, NULL, 2, 'VO PHUC PHO', NULL, NULL, NULL, NULL, 0),
(105, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,97,5,0,0]}', 'manhtx', NULL, NULL, 2, 'TRINH XUAN MANH', NULL, NULL, NULL, NULL, 0),
(106, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,111,5,0,0]}', 'khanhnhq', NULL, NULL, 2, 'NGUYEN HOANG QUOC KHANH', NULL, NULL, NULL, NULL, 0),
(107, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,112,5,0,0]}', 'thinhpc', NULL, NULL, 2, 'PHAN CONG THINH', NULL, NULL, NULL, NULL, 0),
(108, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,113,5,0,0]}', 'hungnh', NULL, NULL, 2, 'NGO HONG HUNG', NULL, NULL, NULL, NULL, 0),
(109, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,114,5,0,0]}', 'duylh', NULL, NULL, 2, 'LE HA DUY', NULL, NULL, NULL, NULL, 0),
(110, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,115,5,0,0]}', 'ylt', NULL, NULL, 2, 'LE THIEN Y', NULL, NULL, NULL, NULL, 0),
(111, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,120,5,0,0]}', 'vuongnq', NULL, NULL, 2, 'NGUYEN QUOC VUONG', NULL, NULL, '', NULL, 0),
(112, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,121,5,0,0]}', 'tantv', NULL, NULL, 2, 'TRAN VIET TAN', NULL, NULL, NULL, NULL, 0),
(113, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,122,5,0,0]}', 'duongdv', NULL, NULL, 2, 'DAM VAN DUONG', NULL, NULL, NULL, NULL, 0),
(114, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,124,5,0,0]}', 'hainn', NULL, NULL, 2, 'NGO NHU HAI', NULL, NULL, NULL, NULL, 0),
(115, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,127,5,0,0]}', 'ducn', NULL, NULL, 2, 'NGUYEN DUC', NULL, NULL, NULL, NULL, 0),
(116, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,132,5,0,0]}', 'hientm', NULL, NULL, 2, 'TRAN MINH HIEN', NULL, NULL, NULL, NULL, 0),
(117, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,133,5,0,0]}', 'trungpd', NULL, NULL, 2, 'PHAM DUC TRUNG', NULL, NULL, NULL, NULL, 0),
(118, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,134,5,0,0]}', 'phuongtt', NULL, NULL, 2, 'TRAN THI PHUONG', NULL, NULL, NULL, NULL, 0),
(119, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,135,5,0,0]}', 'kienbt', NULL, NULL, 2, 'BUI TRUNG KIEN', NULL, NULL, NULL, NULL, 0),
(120, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,136,5,0,0]}', 'hungnt', NULL, NULL, 2, 'NGUYEN THE HUNG', NULL, NULL, NULL, NULL, 0),
(121, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,140,5,0,0]}', 'nghiacx', NULL, NULL, 2, 'CHU XUAN NGHIA', NULL, NULL, NULL, NULL, 0),
(122, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,144,5,0,0]}', 'truongdx', NULL, NULL, 2, 'DAO XUAN TRUONG', NULL, NULL, NULL, NULL, 0),
(123, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,146,5,0,0]}', 'chinhnd', NULL, NULL, 2, 'NGUYEN DO CHINH', NULL, NULL, NULL, NULL, 0),
(124, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,150,5,0,0]}', 'ledm', NULL, NULL, 2, 'DO MINH LE', NULL, NULL, NULL, NULL, 0),
(125, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,155,5,0,0]}', 'hungpq', NULL, NULL, 2, 'PHAM QUANG HUNG', NULL, NULL, NULL, NULL, 0),
(126, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,159,5,0,0]}', 'chiendq', NULL, NULL, 2, 'DUONG QUANG CHIEN', NULL, NULL, NULL, NULL, 0),
(127, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,161,5,0,0]}', 'suvq', NULL, NULL, 2, 'VAN QUOC SU', NULL, NULL, NULL, NULL, 0),
(128, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,163,5,0,0]}', 'khant', NULL, NULL, 2, 'NGUYEN TRUONG KHA', NULL, NULL, NULL, NULL, 0),
(129, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,164,5,0,0]}', 'huanlm', NULL, NULL, 2, 'LUU MANH HUAN', NULL, NULL, NULL, NULL, 0),
(130, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,166,5,0,0]}', 'huytn', NULL, NULL, 2, 'TRAN NGOC HUY', NULL, NULL, NULL, NULL, 0),
(131, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,167,5,0,0]}', 'dongtv', NULL, NULL, 2, 'TRUONG VAN DONG', NULL, NULL, NULL, NULL, 0),
(132, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,170,5,0,0]}', 'phihn', NULL, NULL, 2, 'HOANG NAM PHI', NULL, NULL, NULL, NULL, 0),
(133, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,173,5,0,0]}', 'thonn', NULL, NULL, 2, 'NGUYEN NGOC THO', NULL, NULL, NULL, NULL, 0),
(134, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,174,5,0,0]}', 'anhht', NULL, NULL, 2, 'HA TU ANH', NULL, NULL, NULL, NULL, 0),
(135, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,177,5,0,0]}', 'tuhn', NULL, NULL, 2, 'HO NGOC TU', NULL, NULL, NULL, NULL, 0),
(136, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,180,5,0,0]}', 'binhnc', NULL, NULL, 2, 'NGUYEN CHI BINH', NULL, NULL, NULL, NULL, 0),
(137, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,182,5,0,0]}', 'tupa', NULL, NULL, 2, 'PHAM ANH TU', NULL, NULL, NULL, NULL, 0),
(138, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,183,5,0,0]}', 'taitvc', NULL, NULL, 2, 'TRAN VU CONG TAI', NULL, NULL, NULL, NULL, 0),
(139, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,184,5,0,0]}', 'thenbc', NULL, NULL, 2, 'NGUYEN BAO THE', NULL, NULL, NULL, NULL, 0),
(140, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,186,5,0,0]}', 'nhunh', NULL, NULL, 2, 'NGO HOANG NHU', NULL, NULL, '', NULL, 0),
(141, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,187,5,0,0]}', 'conv', NULL, NULL, 2, 'NGUYEN VAN CO', NULL, NULL, '', NULL, 0),
(142, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,191,5,0,0]}', 'tritn', NULL, NULL, 2, 'TRINH NGOC TRI', NULL, NULL, NULL, NULL, 0),
(143, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,192,5,0,0]}', 'danhtc', NULL, NULL, 2, 'TRAN CONG DANH', NULL, NULL, NULL, NULL, 0),
(144, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,193,5,0,0]}', 'nghiata', NULL, NULL, 2, 'TRAN AI NGHIA', NULL, NULL, '', NULL, 0),
(145, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,194,5,0,0]}', 'thuannn', NULL, NULL, 2, 'NGUYEN NGOC THUAN', NULL, NULL, '', NULL, 0),
(146, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,195,5,0,0]}', 'namth', NULL, NULL, 2, 'TRUONG HOAI NAM', NULL, NULL, NULL, NULL, 0),
(147, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,201,5,0,0]}', 'oanhv', NULL, NULL, 2, 'VU OANH', NULL, NULL, NULL, NULL, 0),
(148, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,202,5,0,0]}', 'trungdq', NULL, NULL, 2, 'DOAN QUANG TRUNG', NULL, NULL, NULL, NULL, 0),
(149, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,203,5,0,0]}', 'vedd', NULL, NULL, 2, 'DUONG DAI VE', NULL, NULL, NULL, NULL, 0),
(150, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,204,5,0,0]}', 'datpt', NULL, NULL, 2, 'PHAM TIEN DAT', NULL, NULL, NULL, NULL, 0),
(151, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,206,5,0,0]}', 'quanbt', NULL, NULL, 2, 'BUI THE QUAN', NULL, NULL, NULL, NULL, 0),
(152, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,207,5,0,0]}', 'trungnx', NULL, NULL, 2, 'NGUYEN XUAN TRUNG', NULL, NULL, NULL, NULL, 0),
(153, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,208,5,0,0]}', 'tungtx', NULL, NULL, 2, 'TO XUAN TUNG', NULL, NULL, NULL, NULL, 0),
(154, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,210,5,0,0]}', 'dopt', NULL, NULL, 2, 'PHAM THANH DO', NULL, NULL, NULL, NULL, 0),
(155, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,211,5,0,0]}', 'thaitm', NULL, NULL, 2, 'TRUONG MINH THAI', NULL, NULL, NULL, NULL, 0),
(156, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,212,5,0,0]}', 'haunt', NULL, NULL, 2, 'NGUYEN TIEN HAU', NULL, NULL, NULL, NULL, 0),
(157, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,214,5,0,0]}', 'nangtv', NULL, NULL, 2, 'TRAN VAN NANG', NULL, NULL, NULL, NULL, 0),
(158, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,215,5,0,0]}', 'huynhnv', NULL, NULL, 2, 'NGUYEN VAN HUYNH', NULL, NULL, NULL, NULL, 0),
(159, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,216,5,0,0]}', 'anhtq', NULL, NULL, 2, 'TRAN QUANG ANH', NULL, NULL, NULL, NULL, 0),
(160, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,217,5,0,0]}', 'vandh', NULL, NULL, 2, 'DO HUU VAN', NULL, NULL, NULL, NULL, 0),
(161, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,218,5,0,0]}', 'tuda', NULL, NULL, 2, 'DO ANH TU', NULL, NULL, NULL, NULL, 0),
(162, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,219,5,0,0]}', 'duyvd', NULL, NULL, 2, 'VU DUC DUY', NULL, NULL, NULL, NULL, 0),
(163, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,221,5,0,0]}', 'datgt', NULL, NULL, 2, 'GIANG THANH DAT', NULL, NULL, NULL, NULL, 0),
(164, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,222,5,0,0]}', 'hiepnt1', NULL, NULL, 2, 'NGUYEN TIEN HIEP', NULL, NULL, NULL, NULL, 0),
(165, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,223,5,0,0]}', 'dungtv', NULL, NULL, 2, 'TRAN VIET DUNG', NULL, NULL, NULL, NULL, 0),
(166, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,224,5,0,0]}', 'tamnd', NULL, NULL, 2, 'NGUYEN DINH TAM', NULL, NULL, NULL, NULL, 0),
(167, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,225,5,0,0]}', 'hoangph', NULL, NULL, 2, 'PHAM HUY HOANG', NULL, NULL, NULL, NULL, 0),
(168, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,226,5,0,0]}', 'quandt', NULL, NULL, 2, 'DO TIEN QUAN', NULL, NULL, NULL, NULL, 0),
(169, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,227,5,0,0]}', 'ducdv', NULL, NULL, 2, 'DOAN VAN DUC', NULL, NULL, NULL, NULL, 0),
(170, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,228,5,0,0]}', 'luannv', NULL, NULL, 2, 'NGUYEN VAN LUAN', NULL, NULL, NULL, NULL, 0),
(171, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,229,5,0,0]}', 'quanpd', NULL, NULL, 2, 'PHUNG DUY QUAN', NULL, NULL, NULL, NULL, 0),
(172, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,230,5,0,0]}', 'thangmc', NULL, NULL, 2, 'MAI CHIEN THANG', NULL, NULL, NULL, NULL, 0),
(173, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,231,5,0,0]}', 'cuonglm', NULL, NULL, 2, 'LA MANH CUONG', NULL, NULL, NULL, NULL, 0),
(174, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,232,5,0,0]}', 'tinhvv', NULL, NULL, 2, 'VU VAN TINH', NULL, NULL, NULL, NULL, 0),
(175, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,233,5,0,0]}', 'haova', NULL, NULL, 2, 'VU ANH HAO', NULL, NULL, NULL, NULL, 0),
(176, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,234,5,0,0]}', 'khanhtq', NULL, NULL, 2, 'TRAN QUOC KHANH', NULL, NULL, NULL, NULL, 0),
(177, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,235,5,0,0]}', 'thaonx', NULL, NULL, 2, 'NGAN XUAN THAO', NULL, NULL, NULL, NULL, 0),
(178, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,237,5,0,0]}', 'landn', NULL, NULL, 2, 'DAO NGOC LAN', NULL, NULL, NULL, NULL, 0),
(179, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,238,5,0,0]}', 'thanhpt', NULL, NULL, 2, 'PHAM TIEN THANH', NULL, NULL, NULL, NULL, 0),
(180, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,239,5,0,0]}', 'tuanla', NULL, NULL, 2, 'LE ANH TUAN', NULL, NULL, NULL, NULL, 0),
(181, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,240,5,0,0]}', 'vuna', NULL, NULL, 2, 'NGUYEN ANH VU', NULL, NULL, NULL, NULL, 0),
(182, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,241,5,0,0]}', 'phuongnt', NULL, NULL, 2, 'NGUYEN THI PHUONG', NULL, NULL, NULL, NULL, 0),
(183, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,242,5,0,0]}', 'trinhdv', NULL, NULL, 2, 'DO VAN TRINH', NULL, NULL, NULL, NULL, 0),
(184, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,243,5,0,0]}', 'binhnm', NULL, NULL, 2, 'NGUYEN MAU BINH', NULL, NULL, NULL, NULL, 0),
(185, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,244,5,0,0]}', 'phucvv', NULL, NULL, 2, 'VUONG VAN PHUC', NULL, NULL, NULL, NULL, 0),
(186, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,245,5,0,0]}', 'loanht', NULL, NULL, 2, 'HOANG THI LOAN', NULL, NULL, NULL, NULL, 0),
(187, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,246,5,0,0]}', 'trunglq', NULL, NULL, 2, 'LE QUANG TRUNG', NULL, NULL, NULL, NULL, 0),
(188, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,247,5,0,0]}', 'tuenh', NULL, NULL, 2, 'NGUYEN HUU TUE', NULL, NULL, NULL, NULL, 0),
(189, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,248,5,0,0]}', 'phonghm', NULL, NULL, 2, 'HOANG MINH PHONG', NULL, NULL, NULL, NULL, 0),
(190, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,249,5,0,0]}', 'linhttd', NULL, NULL, 2, 'TRAN THI DIEU LINH', NULL, NULL, NULL, NULL, 0),
(191, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,251,5,0,0]}', 'truongvv', NULL, NULL, 2, 'VUONG VAN TRUONG', NULL, NULL, NULL, NULL, 0),
(192, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,252,5,0,0]}', 'chucpv', NULL, NULL, 2, 'PHAM VAN CHUC', NULL, NULL, NULL, NULL, 0),
(193, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,253,5,0,0]}', 'kongnh', NULL, NULL, 2, 'NGUYEN HONG KONG', NULL, NULL, NULL, NULL, 0),
(194, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,255,5,0,0]}', 'tiengs', NULL, NULL, 2, 'GIANG SON TIEN', NULL, NULL, NULL, NULL, 0),
(195, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,0,6,0,0]}', 'phatpn', NULL, NULL, 2, 'PHAM NGOC PHAT', NULL, NULL, NULL, NULL, 0),
(196, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,1,6,0,0]}', 'tanhb', NULL, NULL, 2, 'HUYNH BAO TAN', NULL, NULL, NULL, NULL, 0),
(197, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,2,6,0,0]}', 'hoangns', NULL, NULL, 2, 'NGUYEN SY HOANG', NULL, NULL, NULL, NULL, 0),
(198, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,3,6,0,0]}', 'hungvm', NULL, NULL, 2, 'VU MANH HUNG', NULL, NULL, NULL, NULL, 0),
(199, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,5,6,0,0]}', 'quanvh', NULL, NULL, 2, 'VO HONG QUAN', NULL, NULL, NULL, NULL, 0),
(200, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,6,6,0,0]}', 'duylt', NULL, NULL, 2, 'LE TRONG DUY', NULL, NULL, NULL, NULL, 0),
(201, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,7,6,0,0]}', 'chienbd', NULL, NULL, 2, 'BUI DUC CHIEN', NULL, NULL, NULL, NULL, 0),
(202, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,9,6,0,0]}', 'hoanglm', NULL, NULL, 2, 'LUONG MINH HOANG', NULL, NULL, NULL, NULL, 0),
(203, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,10,6,0,0]}', 'tienhm', NULL, NULL, 2, 'HOANG MINH TIEN', NULL, NULL, NULL, NULL, 0),
(204, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,11,6,0,0]}', 'hainv', NULL, NULL, 2, 'NGUYEN VAN HAI ', NULL, NULL, NULL, NULL, 0),
(205, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,12,6,0,0]}', 'vannh', NULL, NULL, 2, 'NGUYEN HONG VAN', NULL, NULL, NULL, NULL, 0),
(206, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,13,6,0,0]}', 'hiepbx', NULL, NULL, 2, 'BUI XUAN HIEP', NULL, NULL, NULL, NULL, 0),
(207, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,14,6,0,0]}', 'ducpx', NULL, NULL, 2, 'PHAM XUAN DUC', NULL, NULL, NULL, NULL, 0),
(208, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,15,6,0,0]}', 'quangnd1', NULL, NULL, 2, 'NGUYEN DUY QUANG', NULL, NULL, NULL, NULL, 0),
(209, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,16,6,0,0]}', 'typv', NULL, NULL, 2, 'PHAM VAN TY', NULL, NULL, NULL, NULL, 0),
(210, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,18,6,0,0]}', 'toannd', NULL, NULL, 2, 'NGUYEN DUC TOAN', NULL, NULL, NULL, NULL, 0),
(211, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,20,6,0,0]}', 'nguyennl', NULL, NULL, 2, 'NGUYEN LE NGUYEN', NULL, NULL, NULL, NULL, 0),
(212, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,22,6,0,0]}', 'quyentd', NULL, NULL, 2, 'TRUONG DUC QUYEN', NULL, NULL, NULL, NULL, 0),
(213, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,24,6,0,0]}', 'linhnh', NULL, NULL, 2, 'NGUYEN HOANG LINH', NULL, NULL, NULL, NULL, 0),
(214, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,26,6,0,0]}', 'hieutt', NULL, NULL, 2, 'TRAN TRUNG HIEU', NULL, NULL, NULL, NULL, 0),
(215, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,27,6,0,0]}', 'truongln', NULL, NULL, 2, 'LE NGOC TRUONG', NULL, NULL, NULL, NULL, 0),
(216, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,28,6,0,0]}', 'hungnd', NULL, NULL, 2, 'NGUYEN DUY HUNG', NULL, NULL, NULL, NULL, 0),
(217, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,29,6,0,0]}', 'anhpn', NULL, NULL, 2, 'PHUNG NGOC ANH', NULL, NULL, NULL, NULL, 0),
(218, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,30,6,0,0]}', 'cuongtx', NULL, NULL, 2, 'TRINH XUAN CUONG', NULL, NULL, NULL, NULL, 0),
(219, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,31,6,0,0]}', 'longdd', NULL, NULL, 2, 'DANG DINH LONG', NULL, NULL, NULL, NULL, 0),
(220, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,32,6,0,0]}', 'hanv', NULL, NULL, 2, 'NGUYEN VAN HA', NULL, NULL, NULL, NULL, 0),
(221, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,33,6,0,0]}', 'quannh', NULL, NULL, 2, 'NGUYEN HAI QUAN', NULL, NULL, NULL, NULL, 0),
(222, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,34,6,0,0]}', 'maictp', NULL, NULL, 2, 'CAO THI PHUONG MAI', NULL, NULL, NULL, NULL, 0),
(223, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,35,6,0,0]}', 'tiennv', NULL, NULL, 2, 'NGUYEN VAN TIEN', NULL, NULL, NULL, NULL, 0),
(224, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,36,6,0,0]}', 'tuandx', NULL, NULL, 2, 'DANG XUAN TUAN', NULL, NULL, '', NULL, 0),
(225, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,37,6,0,0]}', 'longtd', NULL, NULL, 2, 'TRAN DINH LONG', NULL, NULL, NULL, NULL, 0),
(226, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,38,6,0,0]}', 'truongbq', NULL, NULL, 2, 'BUI QUOC TRUONG', NULL, NULL, NULL, NULL, 0),
(227, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,39,6,0,0]}', 'duongpd', NULL, NULL, 2, 'PHAN DINH DUONG', NULL, NULL, NULL, NULL, 0),
(228, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,40,6,0,0]}', 'vietcv', NULL, NULL, 2, 'CHU VAN VIET', NULL, NULL, NULL, NULL, 0),
(229, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,41,6,0,0]}', 'dungbt', NULL, NULL, 2, 'BUI THI DUNG', NULL, NULL, NULL, NULL, 0),
(230, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,42,6,0,0]}', 'thanhnh', NULL, NULL, 2, 'NGUYEN HUU THANH', NULL, NULL, NULL, NULL, 0),
(231, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,43,6,0,0]}', 'muint', NULL, NULL, 2, 'NGUYEN THI MUI', NULL, NULL, NULL, NULL, 0),
(232, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,44,6,0,0]}', 'huynq', NULL, NULL, 2, 'NGUYEN QUOC HUY', NULL, NULL, NULL, NULL, 0),
(233, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,45,6,0,0]}', 'diepnt', NULL, NULL, 2, 'NGUYEN THI DIEP', NULL, NULL, NULL, NULL, 0),
(234, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,46,6,0,0]}', 'anhpt', NULL, NULL, 2, 'PHAM THE ANH', NULL, NULL, NULL, NULL, 0),
(235, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,47,6,0,0]}', 'phuongvt', NULL, NULL, 2, 'VU THI PHUONG', NULL, NULL, NULL, NULL, 0),
(236, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,48,6,0,0]}', 'hungpm', NULL, NULL, 2, 'PHUNG MANH HUNG', NULL, NULL, NULL, NULL, 0),
(237, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,49,6,0,0]}', 'hanh', NULL, NULL, 2, 'NGUYEN HUU HA', NULL, NULL, NULL, NULL, 0),
(238, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,50,6,0,0]}', 'quocvva', NULL, NULL, 2, 'VO VAN ANH QUOC', NULL, NULL, NULL, NULL, 0),
(239, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,51,6,0,0]}', 'longnp', NULL, NULL, 2, 'NGUYEN PHI LONG', NULL, NULL, NULL, NULL, 0),
(240, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,52,6,0,0]}', 'tainn', NULL, NULL, 2, 'NGUYEN NGOC TAI', NULL, NULL, NULL, NULL, 0),
(241, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,53,6,0,0]}', 'mynt', NULL, NULL, 2, 'NGUYEN TRA MY', NULL, NULL, NULL, NULL, 0),
(242, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,55,6,0,0]}', 'huytl', NULL, NULL, 2, 'TRAN LUU HUY', NULL, NULL, NULL, NULL, 0),
(243, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,56,6,0,0]}', 'thuynm', NULL, NULL, 2, 'NGUYEN MINH THUY', NULL, NULL, NULL, NULL, 0),
(244, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,59,6,0,0]}', 'thanhnd', NULL, NULL, 2, 'NGUYEN DUC THANH', NULL, NULL, NULL, NULL, 0),
(245, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,60,6,0,0]}', 'thaott', NULL, NULL, 2, 'TRAN THI THU THAO', NULL, NULL, NULL, NULL, 0),
(246, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,62,6,0,0]}', 'tamdtt', NULL, NULL, 2, 'DAO THI THANH TAM', NULL, NULL, NULL, NULL, 0),
(247, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,63,6,0,0]}', 'ngadt', NULL, NULL, 2, 'DANG THI NGA', NULL, NULL, NULL, NULL, 0),
(248, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,65,6,0,0]}', 'trungnv', NULL, NULL, 2, 'NGUYEN VIET TRUNG', NULL, NULL, NULL, NULL, 0),
(249, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,66,6,0,0]}', 'trangmt', NULL, NULL, 2, 'MAI THU TRANG', NULL, NULL, NULL, NULL, 0),
(250, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,67,6,0,0]}', 'lienltq', NULL, NULL, 2, 'LE THI QUYNH LIEN', NULL, NULL, NULL, NULL, 0),
(251, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,68,6,0,0]}', 'anhtd', NULL, NULL, 2, 'TRAN DUC ANH', NULL, NULL, NULL, NULL, 0),
(252, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,69,6,0,0]}', 'longth', NULL, NULL, 2, 'TRUONG HUU LONG', NULL, NULL, NULL, NULL, 0),
(253, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,70,6,0,0]}', 'quanhv', NULL, NULL, 2, 'HA VAN QUAN', NULL, NULL, NULL, NULL, 0),
(254, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,71,6,0,0]}', 'anhptv', NULL, NULL, 2, 'PHAM THI VAN ANH', NULL, NULL, NULL, NULL, 0),
(255, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,72,6,0,0]}', 'duongnv', NULL, NULL, 2, 'NGUYEN VAN DUONG', NULL, NULL, NULL, NULL, 0),
(256, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,73,6,0,0]}', 'thuongnt', NULL, NULL, 2, 'NGUYEN THI THUONG', NULL, NULL, NULL, NULL, 0),
(257, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,76,6,0,0]}', 'gianghth', NULL, NULL, 2, 'HO THI HOAI GIANG', NULL, NULL, NULL, NULL, 0),
(258, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,77,6,0,0]}', 'anhltp', NULL, NULL, 2, 'LE THI PHUONG ANH', NULL, NULL, NULL, NULL, 0),
(259, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,80,6,0,0]}', 'huybt', NULL, NULL, 2, 'BUI TRAN HUY', NULL, NULL, NULL, NULL, 0),
(260, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,81,6,0,0]}', 'thunt', NULL, NULL, 2, 'NGUYEN THI THU', NULL, NULL, NULL, NULL, 0),
(261, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,84,6,0,0]}', 'ngamt', NULL, NULL, 2, 'MAI THI NGA', NULL, NULL, NULL, NULL, 0),
(262, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,86,6,0,0]}', 'vuonghq', NULL, NULL, 2, 'HUYNH QUOC VUONG', NULL, NULL, NULL, NULL, 0),
(263, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,90,6,0,0]}', 'ngatnth', NULL, NULL, 2, 'NGUYEN THI HONG NGAT', NULL, NULL, NULL, NULL, 0),
(264, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,91,6,0,0]}', 'diephh', NULL, NULL, 2, 'HUA HAI DIEP', NULL, NULL, NULL, NULL, 0);
INSERT INTO `user` (`userId`, `objectSid`, `accountName`, `email`, `password`, `isLocal`, `fullName`, `title`, `workplace`, `userNote`, `avatar`, `inactive`) VALUES
(265, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,95,6,0,0]}', 'kiennv', NULL, NULL, 2, 'NGUYEN VAN KIEN', NULL, NULL, NULL, NULL, 0),
(266, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,98,6,0,0]}', 'nhitt', NULL, NULL, 2, 'TRAN THI NHI', NULL, NULL, NULL, NULL, 0),
(267, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,100,6,0,0]}', 'huylq1', NULL, NULL, 2, 'LE QUOC HUY', NULL, NULL, NULL, NULL, 0),
(268, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,101,6,0,0]}', 'hungdt1', NULL, NULL, 2, 'DAO TANG HUNG', NULL, NULL, NULL, NULL, 0),
(269, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,106,6,0,0]}', 'sonnh1', NULL, NULL, 2, 'NGUYEN HUNG SON', NULL, NULL, NULL, NULL, 0),
(270, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,107,6,0,0]}', 'anhnt', NULL, NULL, 2, 'NGUYEN TUAN ANH', NULL, NULL, NULL, NULL, 0),
(271, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,108,6,0,0]}', 'hieunt1', NULL, NULL, 2, 'NGUY THI HIEU', NULL, NULL, NULL, NULL, 0),
(272, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,109,6,0,0]}', 'hungnh1', NULL, NULL, 2, 'NGUYEN HUU HUNG', NULL, NULL, NULL, NULL, 0),
(273, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,111,6,0,0]}', 'anhtt1', NULL, NULL, 2, 'TRAN TIEN ANH', NULL, NULL, NULL, NULL, 0),
(274, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,112,6,0,0]}', 'quangnd', NULL, NULL, 2, 'NGUYEN DUY QUANG', NULL, NULL, NULL, NULL, 0),
(275, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,113,6,0,0]}', 'tuannv', NULL, NULL, 2, 'NGO VAN TUAN', NULL, NULL, NULL, NULL, 0),
(276, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,114,6,0,0]}', 'hiepnt', NULL, NULL, 2, 'NGUYEN TRONG HIEP', NULL, NULL, NULL, NULL, 0),
(277, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,115,6,0,0]}', 'anhnt1', NULL, NULL, 2, 'NGUYEN TUAN ANH', NULL, NULL, NULL, NULL, 0),
(278, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,116,6,0,0]}', 'dungtv1', NULL, NULL, 2, 'TRAN VIET DUNG', NULL, NULL, NULL, NULL, 0),
(279, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,173,6,0,0]}', 'tranglt', NULL, NULL, 2, 'LE THU TRANG', NULL, NULL, NULL, NULL, 0),
(280, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,191,6,0,0]}', 'hienltt', NULL, NULL, 2, 'LE THI THU HIEN', NULL, NULL, 'Chuyen vien Nhan su', NULL, 0),
(281, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,10,7,0,0]}', 'anhntl', NULL, NULL, 2, 'NGUYEN THI LAN ANH', NULL, NULL, NULL, NULL, 0),
(282, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,11,7,0,0]}', 'chungdv', NULL, NULL, 2, 'DO VAN CHUNG', NULL, NULL, NULL, NULL, 0),
(283, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,13,7,0,0]}', 'khuyenpv', NULL, NULL, 2, 'PHAM VAN KHUYEN', NULL, NULL, NULL, NULL, 0),
(284, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,14,7,0,0]}', 'hieuvq', NULL, NULL, 2, 'VU QUANG HIEU', NULL, NULL, NULL, NULL, 0),
(285, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,15,7,0,0]}', 'hoannv', NULL, NULL, 2, 'NGUYEN VAN HOAN', NULL, NULL, NULL, NULL, 0),
(286, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,16,7,0,0]}', 'dungntm', NULL, NULL, 2, 'DUNG NGUYEN THI MY', NULL, NULL, 'Admin khoi ky thuat VP Mien Nam', NULL, 0),
(287, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,20,7,0,0]}', 'jira', NULL, NULL, 2, 'JIRA', NULL, NULL, NULL, NULL, 0),
(288, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,22,7,0,0]}', 'cuongnv', NULL, NULL, 2, 'CUONG NGUYEN VAN', NULL, NULL, NULL, NULL, 0),
(289, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,23,7,0,0]}', 'thaonp', NULL, NULL, 2, 'NGUYEN PHUONG THAO', NULL, NULL, NULL, NULL, 1),
(290, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,36,7,0,0]}', 'tuandv', NULL, NULL, 2, 'TUAN DINH VU', NULL, NULL, NULL, NULL, 0),
(291, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,37,7,0,0]}', 'samlt', NULL, NULL, 2, 'SAM LUONG THI', NULL, NULL, NULL, NULL, 0),
(292, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,48,7,0,0]}', 'linhht1', NULL, NULL, 2, 'LINH HA THUY', NULL, NULL, NULL, NULL, 0),
(293, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,49,7,0,0]}', 'haltn', NULL, NULL, 2, 'HA LE THI NGOC', NULL, NULL, NULL, NULL, 0),
(294, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,66,7,0,0]}', 'dungnv1', NULL, NULL, 2, 'NGUYEN VIET DUNG', NULL, NULL, NULL, NULL, 0),
(295, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,70,7,0,0]}', 'hoangnd', NULL, NULL, 2, 'HOANG NGUYEN DO', NULL, NULL, NULL, NULL, 0),
(296, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,71,7,0,0]}', 'duongdv1', NULL, NULL, 2, 'DUONG DO VAN', NULL, NULL, NULL, NULL, 0),
(297, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,75,7,0,0]}', 'congpc', NULL, NULL, 2, 'CONG PHAM CHI', NULL, NULL, NULL, NULL, 0),
(298, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,87,7,0,0]}', 'sontn', NULL, NULL, 2, 'TRAN NGOC SON', NULL, NULL, NULL, NULL, 0),
(299, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,98,7,0,0]}', 'toannv', NULL, NULL, 2, 'NGUYEN VAN TOAN', NULL, NULL, NULL, NULL, 0),
(300, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,99,7,0,0]}', 'nhidh', NULL, NULL, 2, 'DO HA NHI', NULL, NULL, NULL, NULL, 0),
(301, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,102,7,0,0]}', 'anhtth', NULL, NULL, 2, 'TRUONG THI HIEN ANH', NULL, NULL, NULL, NULL, 0),
(302, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,103,7,0,0]}', 'maint', NULL, NULL, 2, 'NGO THI MAI', NULL, NULL, NULL, NULL, 0),
(303, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,108,7,0,0]}', 'hienvv1', NULL, NULL, 2, 'VU VAN HIEN', NULL, NULL, NULL, NULL, 0),
(304, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,109,7,0,0]}', 'tuanha', NULL, NULL, 2, 'HOANG ANH TUAN', NULL, NULL, NULL, NULL, 0),
(305, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,110,7,0,0]}', 'hoangdh', NULL, NULL, 2, 'DAM HUY HOANG', NULL, NULL, NULL, NULL, 0),
(306, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,113,7,0,0]}', 'nghiadv', NULL, NULL, 2, 'DO VAN NGHIA', NULL, NULL, NULL, NULL, 0),
(307, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,115,7,0,0]}', 'phongld', NULL, NULL, 2, 'LUONG DUONG PHONG', NULL, NULL, NULL, NULL, 0),
(308, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,116,7,0,0]}', 'taicc', NULL, NULL, 2, 'CAO CO TAI', NULL, NULL, NULL, NULL, 0),
(309, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,117,7,0,0]}', 'tamtm', NULL, NULL, 2, 'THAI MINH TAM', NULL, NULL, NULL, NULL, 0),
(310, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,120,7,0,0]}', 'quynhnt', NULL, NULL, 2, 'NGUYEN THI QUYNH', NULL, NULL, NULL, NULL, 0),
(311, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,124,7,0,0]}', 'trinhdv1', NULL, NULL, 2, 'DUONG VIET TRINH', NULL, NULL, NULL, NULL, 0),
(312, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,125,7,0,0]}', 'tuyetvtn', NULL, NULL, 2, 'VU THI NGOC TUYET', NULL, NULL, NULL, NULL, 0),
(313, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,126,7,0,0]}', 'tuta', NULL, NULL, 2, 'TRAN ANH TU', NULL, NULL, NULL, NULL, 0),
(314, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,128,7,0,0]}', 'huyenttt', NULL, NULL, 2, 'TRINH THI THANH HUYEN', NULL, NULL, NULL, NULL, 0),
(315, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,131,7,0,0]}', 'tungnv', NULL, NULL, 2, 'NGUYEN VAN TUNG', NULL, NULL, NULL, NULL, 0),
(316, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,132,7,0,0]}', 'duynv', NULL, NULL, 2, 'NGUYEN VAN DUY', NULL, NULL, NULL, NULL, 0),
(317, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,133,7,0,0]}', 'quyendb', NULL, NULL, 2, 'DOAN BA QUYEN', NULL, NULL, NULL, NULL, 0),
(318, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,136,7,0,0]}', 'duongdlt', NULL, NULL, 2, 'DUONG DO LE THUY', NULL, NULL, NULL, NULL, 0),
(319, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,139,7,0,0]}', 'phatnh', NULL, NULL, 2, 'NGUYEN HUU PHAT', NULL, NULL, NULL, NULL, 0),
(320, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,140,7,0,0]}', 'minhtc', NULL, NULL, 2, 'TRAN CONG MINH', NULL, NULL, NULL, NULL, 0),
(321, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,141,7,0,0]}', 'quyns', NULL, NULL, 2, 'NGUYEN SY QUY', NULL, NULL, NULL, NULL, 0),
(322, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,147,7,0,0]}', 'hunglv', NULL, NULL, 2, 'LE VU HUNG', NULL, NULL, NULL, NULL, 0),
(323, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,149,7,0,0]}', 'trungvt', NULL, NULL, 2, 'VU THANH TRUNG', NULL, NULL, NULL, NULL, 0),
(324, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,150,7,0,0]}', 'namph', NULL, NULL, 2, 'PHAN HAI NAM', NULL, NULL, NULL, NULL, 0),
(325, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,151,7,0,0]}', 'nhungnt1', NULL, NULL, 2, 'NGUYEN THI NHUNG', NULL, NULL, NULL, NULL, 0),
(326, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,152,7,0,0]}', 'phupd', NULL, NULL, 2, 'PHAM DUONG PHU', NULL, NULL, NULL, NULL, 0),
(327, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,154,7,0,0]}', 'haild', NULL, NULL, 2, 'LUONG DONG HAI', NULL, NULL, NULL, NULL, 0),
(328, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,155,7,0,0]}', 'namdh', NULL, NULL, 2, 'DO HOANG NAM', NULL, NULL, NULL, NULL, 0),
(329, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,156,7,0,0]}', 'tuanna1', NULL, NULL, 2, 'NGUYEN ANH TUAN', NULL, NULL, NULL, NULL, 0),
(330, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,157,7,0,0]}', 'thont', NULL, NULL, 2, 'NGUYEN THI THO', NULL, NULL, NULL, NULL, 0),
(331, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,160,7,0,0]}', 'khanhtn', NULL, NULL, 2, 'TRAN NGOC KHANH', NULL, NULL, NULL, NULL, 0),
(332, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,161,7,0,0]}', 'sangnt', NULL, NULL, 2, 'NGUYEN THANH SANG', NULL, NULL, NULL, NULL, 0),
(333, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,168,7,0,0]}', 'hieupm', NULL, NULL, 2, 'PHAN MINH HIEU', NULL, NULL, NULL, NULL, 0),
(334, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,169,7,0,0]}', 'nguyenntt', NULL, NULL, 2, 'NGUYEN THI THAI NGUYEN', NULL, NULL, NULL, NULL, 0),
(335, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,171,7,0,0]}', 'anhttl', NULL, NULL, 2, 'TRAN THI LAN ANH', NULL, NULL, NULL, NULL, 0),
(336, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,172,7,0,0]}', 'tuqn', NULL, NULL, 2, 'QUAN NGOC TU', NULL, NULL, NULL, NULL, 0),
(337, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,173,7,0,0]}', 'cuonglm1', NULL, NULL, 2, 'LE MINH CUONG', NULL, NULL, NULL, NULL, 0),
(338, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,174,7,0,0]}', 'tynv', NULL, NULL, 2, 'NGUYEN VAN TY', NULL, NULL, 'Dieu hanh DC', NULL, 0),
(339, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,175,7,0,0]}', 'huongnv', NULL, NULL, 2, 'NGUYEN VIET HUONG', NULL, NULL, NULL, NULL, 0),
(340, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,176,7,0,0]}', 'tanlm', NULL, NULL, 2, 'LE MINH TAN', NULL, NULL, NULL, NULL, 0),
(341, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,177,7,0,0]}', 'nghint', NULL, NULL, 2, 'NGUYEN TIEN NGHI', NULL, NULL, NULL, NULL, 0),
(342, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,179,7,0,0]}', 'longdt', NULL, NULL, 2, 'DO THANG LONG', NULL, NULL, NULL, NULL, 0),
(343, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,181,7,0,0]}', 'quanlm', NULL, NULL, 2, 'LE MINH QUAN', NULL, NULL, NULL, NULL, 0),
(344, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,182,7,0,0]}', 'huyenntn', NULL, NULL, 2, 'NGO THI NGOC HUYEN', NULL, NULL, NULL, NULL, 0),
(345, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,183,7,0,0]}', 'nguyenp', NULL, NULL, 2, 'PHAM NGUYEN', NULL, NULL, 'Giam Doc TTKD DV Du lieu', NULL, 0),
(346, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,184,7,0,0]}', 'vinhtq', NULL, NULL, 2, 'TRAN QUANG VINH', NULL, NULL, NULL, NULL, 0),
(347, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,185,7,0,0]}', 'quantd', NULL, NULL, 2, 'TRAN DUC QUAN', NULL, NULL, NULL, NULL, 0),
(348, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,186,7,0,0]}', 'hanhtth', NULL, NULL, 2, 'THAI THI HONG HANH', NULL, NULL, NULL, NULL, 0),
(349, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,188,7,0,0]}', 'nhictt', NULL, NULL, 2, 'CAO THI THAO NHI', NULL, NULL, NULL, NULL, 0),
(350, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,189,7,0,0]}', 'duongpt', NULL, NULL, 2, 'PHAM THUY DUONG', NULL, NULL, NULL, NULL, 0),
(351, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,190,7,0,0]}', 'khanhvk', NULL, NULL, 2, 'VO KIEU KHANH', NULL, NULL, NULL, NULL, 0),
(352, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,191,7,0,0]}', 'hoanntn', NULL, NULL, 2, 'NGUYEN THI NGOC HOAN', NULL, NULL, NULL, NULL, 0),
(353, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,202,7,0,0]}', 'hanhbt', NULL, NULL, 2, 'BUI THI HANH', NULL, NULL, 'Chuyen vien ISO', NULL, 0),
(354, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,217,7,0,0]}', 'manhtv', NULL, NULL, 2, 'TRUONG VAN MANH', NULL, NULL, 'Truong Ban Van hanh DC', NULL, 0),
(355, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,218,7,0,0]}', 'santt', NULL, NULL, 2, 'TRAN THI SAN', NULL, NULL, 'Trung tam KD dich vu du lieu', NULL, 0),
(356, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,219,7,0,0]}', 'ninhpt', NULL, NULL, 2, 'PHAM THI NINH', NULL, NULL, 'Trung tam KD dich vu du lieu', NULL, 0),
(357, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,221,7,0,0]}', 'linhvn', NULL, NULL, 2, 'VU NHAT LINH', NULL, NULL, 'Admin TT Dao tao', NULL, 0),
(358, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,222,7,0,0]}', 'trangntt', NULL, NULL, 2, 'NGUYEN THI THU TRANG', NULL, NULL, 'TT Dao tao', NULL, 0),
(359, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,224,7,0,0]}', 'dungnd', NULL, NULL, 2, 'NGUYEN DANH DUNG', NULL, NULL, NULL, NULL, 0),
(360, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,228,7,0,0]}', 'dieuth', NULL, NULL, 2, 'TRINH HONG DIEU', NULL, NULL, NULL, NULL, 0),
(361, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,229,7,0,0]}', 'quanna', NULL, NULL, 2, 'NGO ANH QUAN', NULL, NULL, NULL, NULL, 0),
(362, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,230,7,0,0]}', 'tinhnh', NULL, NULL, 2, 'NGUYEN HUU TINH', NULL, NULL, NULL, NULL, 0),
(363, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,234,7,0,0]}', 'phuongtl', NULL, NULL, 2, 'TO LAN PHUONG', NULL, NULL, NULL, NULL, 0),
(364, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,235,7,0,0]}', 'andm', NULL, NULL, 2, 'DOAN MINH AN', NULL, NULL, NULL, NULL, 0),
(365, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,236,7,0,0]}', 'anhnt2', NULL, NULL, 2, 'NGUYEN TRONG ANH', NULL, NULL, NULL, NULL, 0),
(366, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,238,7,0,0]}', 'truongnq', NULL, NULL, 2, 'NGUYEN QUANG TRUONG', NULL, NULL, NULL, NULL, 0),
(367, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,239,7,0,0]}', 'luannc', NULL, NULL, 2, 'NGUYEN CONG LUAN', NULL, NULL, NULL, NULL, 0),
(368, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,240,7,0,0]}', 'tungbd', NULL, NULL, 2, 'BUI DUY TUNG', NULL, NULL, NULL, NULL, 0),
(369, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,241,7,0,0]}', 'anhndv', NULL, NULL, 2, 'NGUYEN DUC VIET ANH', NULL, NULL, NULL, NULL, 0),
(370, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,249,7,0,0]}', 'tungnc', NULL, NULL, 2, 'NGUYEN CANH TUNG', NULL, NULL, NULL, NULL, 0),
(371, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,251,7,0,0]}', 'dungha', NULL, NULL, 2, 'HOANG ANH DUNG', NULL, NULL, NULL, NULL, 0),
(372, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,252,7,0,0]}', 'hieunv', NULL, NULL, 2, 'NGHIEM VAN HIEU', NULL, NULL, 'Quan tri Khach hang - Trung tam IDC', NULL, 0),
(373, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,253,7,0,0]}', 'duynt', NULL, NULL, 2, 'NGUYEN TUAN DUY', NULL, NULL, NULL, NULL, 0),
(374, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,255,7,0,0]}', 'huebt', NULL, NULL, 2, 'BUI THI HUE', NULL, NULL, NULL, NULL, 0),
(375, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,0,8,0,0]}', 'hungtt1', NULL, NULL, 2, 'TRINH TUAN HUNG', NULL, NULL, NULL, NULL, 0),
(376, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,1,8,0,0]}', 'huongnt1', NULL, NULL, 2, 'NGUYEN THI HUONG', NULL, NULL, NULL, NULL, 0),
(377, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,2,8,0,0]}', 'tunght1', NULL, NULL, 2, 'HOANG THANH TUNG', NULL, NULL, NULL, NULL, 0),
(378, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,3,8,0,0]}', 'hienntt', NULL, NULL, 2, 'NGO THI THU HIEN', NULL, NULL, NULL, NULL, 0),
(379, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,4,8,0,0]}', 'hangpt', NULL, NULL, 2, 'PHAM THANH HANG', NULL, NULL, NULL, NULL, 0),
(380, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,5,8,0,0]}', 'quanna1', NULL, NULL, 2, 'NGO ANH QUAN', NULL, NULL, NULL, NULL, 0),
(381, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,6,8,0,0]}', 'quanght1', NULL, NULL, 2, 'HOANG TA QUANG', NULL, NULL, NULL, NULL, 0),
(382, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,7,8,0,0]}', 'anhltn', NULL, NULL, 2, 'LE THI NGOC ANH', NULL, NULL, NULL, NULL, 0),
(383, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,8,8,0,0]}', 'thanhnx', NULL, NULL, 2, 'NGUYEN XUAN THANH', NULL, NULL, NULL, NULL, 0),
(384, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,9,8,0,0]}', 'huongltt', NULL, NULL, 2, 'LE THI THU HUONG', NULL, NULL, NULL, NULL, 0),
(385, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,10,8,0,0]}', 'dungka', NULL, NULL, 2, 'KIEU ANH DUNG', NULL, NULL, NULL, NULL, 0),
(386, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,11,8,0,0]}', 'minhhv', NULL, NULL, 2, 'HOANG VAN MINH', NULL, NULL, NULL, NULL, 0),
(387, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,17,8,0,0]}', 'thuphm', NULL, NULL, 2, 'PHAM HOANG MINH THU', NULL, NULL, NULL, NULL, 0),
(388, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,18,8,0,0]}', 'thangnk', NULL, NULL, 2, 'NGUYEN KIM THANG', NULL, NULL, 'Quan tri Khach hang - Trung tam IDC', NULL, 0),
(389, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,19,8,0,0]}', 'thanhpt1', NULL, NULL, 2, 'PHAN TRI THANH', NULL, NULL, NULL, NULL, 0),
(390, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,21,8,0,0]}', 'ninhnk', NULL, NULL, 2, 'NINH NGUYEN KHAC', NULL, NULL, NULL, NULL, 0),
(391, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,23,8,0,0]}', 'quangnd2', NULL, NULL, 2, 'NGUYEN DANG QUANG', NULL, NULL, NULL, NULL, 0),
(392, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,24,8,0,0]}', 'toanld', NULL, NULL, 2, 'LUU DUC TOAN', NULL, NULL, '', NULL, 0),
(393, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,25,8,0,0]}', 'hieutt1', NULL, NULL, 2, 'TRINH THI HIEU', NULL, NULL, NULL, NULL, 0),
(394, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,33,8,0,0]}', 'phuhm', NULL, NULL, 2, 'HOANG MINH PHU', NULL, NULL, NULL, NULL, 0),
(395, '{\"type\":\"Buffer\",\"data\":[1,5,0,0,0,0,0,5,21,0,0,0,171,72,218,25,157,246,162,152,13,83,178,96,34,8,0,0]}', 'thanhnd1', NULL, NULL, 2, 'NGUYEN DANG THANH', NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `userrole`
--

CREATE TABLE `userrole` (
  `userRoleId` int(11) NOT NULL,
  `userRoleName` varchar(40) NOT NULL,
  `userRoleNote` text DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `userrole`
--

INSERT INTO `userrole` (`userRoleId`, `userRoleName`, `userRoleNote`, `inactive`) VALUES
(1, 'administrator', 'quản trị', 0),
(2, 'user', 'người dùng', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `useruserrole`
--

CREATE TABLE `useruserrole` (
  `userId` int(11) NOT NULL,
  `userRoleId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `useruserrole`
--

INSERT INTO `useruserrole` (`userId`, `userRoleId`) VALUES
(1, 1),
(1, 2);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `action`
--
ALTER TABLE `action`
  ADD PRIMARY KEY (`actionId`);

--
-- Chỉ mục cho bảng `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`cityId`);

--
-- Chỉ mục cho bảng `district`
--
ALTER TABLE `district`
  ADD PRIMARY KEY (`districtId`);

--
-- Chỉ mục cho bảng `function`
--
ALTER TABLE `function`
  ADD PRIMARY KEY (`functionId`);

--
-- Chỉ mục cho bảng `functionaction`
--
ALTER TABLE `functionaction`
  ADD PRIMARY KEY (`functionActionId`),
  ADD KEY `fk_functionAction_to_function` (`functionId`),
  ADD KEY `fk_functionAction_to_action` (`actionId`),
  ADD KEY `fk_functionAction_to_userRole` (`userRoleId`);

--
-- Chỉ mục cho bảng `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`locationId`),
  ADD UNIQUE KEY `objectId` (`objectId`);

--
-- Chỉ mục cho bảng `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`objectId`),
  ADD UNIQUE KEY `objectCode` (`objectCode`) USING HASH,
  ADD KEY `fk_userId` (`userId`);

--
-- Chỉ mục cho bảng `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`permissionId`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userId`);

--
-- Chỉ mục cho bảng `userrole`
--
ALTER TABLE `userrole`
  ADD PRIMARY KEY (`userRoleId`);

--
-- Chỉ mục cho bảng `useruserrole`
--
ALTER TABLE `useruserrole`
  ADD PRIMARY KEY (`userId`,`userRoleId`),
  ADD KEY `fk_userRoleId_ManyToMany` (`userRoleId`,`userId`) USING BTREE;

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `action`
--
ALTER TABLE `action`
  MODIFY `actionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `city`
--
ALTER TABLE `city`
  MODIFY `cityId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `district`
--
ALTER TABLE `district`
  MODIFY `districtId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `function`
--
ALTER TABLE `function`
  MODIFY `functionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `functionaction`
--
ALTER TABLE `functionaction`
  MODIFY `functionActionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `location`
--
ALTER TABLE `location`
  MODIFY `locationId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `object`
--
ALTER TABLE `object`
  MODIFY `objectId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT cho bảng `permission`
--
ALTER TABLE `permission`
  MODIFY `permissionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=396;

--
-- AUTO_INCREMENT cho bảng `userrole`
--
ALTER TABLE `userrole`
  MODIFY `userRoleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `functionaction`
--
ALTER TABLE `functionaction`
  ADD CONSTRAINT `fk_functionAction_to_action` FOREIGN KEY (`actionId`) REFERENCES `action` (`actionId`),
  ADD CONSTRAINT `fk_functionAction_to_function` FOREIGN KEY (`functionId`) REFERENCES `function` (`functionId`),
  ADD CONSTRAINT `fk_functionAction_to_userRole` FOREIGN KEY (`userRoleId`) REFERENCES `userrole` (`userRoleId`);

--
-- Các ràng buộc cho bảng `object`
--
ALTER TABLE `object`
  ADD CONSTRAINT `fk_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`);

--
-- Các ràng buộc cho bảng `useruserrole`
--
ALTER TABLE `useruserrole`
  ADD CONSTRAINT `fk_userId_ManyToMany` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_userRoleId_ManyToMany` FOREIGN KEY (`userRoleId`) REFERENCES `userrole` (`userRoleId`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
