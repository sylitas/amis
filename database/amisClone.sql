-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th1 29, 2021 lúc 02:59 AM
-- Phiên bản máy phục vụ: 10.4.17-MariaDB
-- Phiên bản PHP: 8.0.1

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
(2, 1, '88B59F11-EDA1-0124-9D75-C19C9C0B0546', 1, 'Blossom Hyde', '2020-08-10', '88A78B62-3F52-0DDA-D04A-EAFD98F5D67B', '579736722533', '2020-10-17', 'Ap #796-6126 Arcu. Road', '16260910 4', '(675) 243-8059', '32546-217', 'felis.purus.ac@sedleoCras.org', '8607 Enim Rd.', '7520640671191', 'EDD065D4-336D-DB60-B227-62E770EA6A85', '3284861768', 'Non Consulting'),
(3, 1, '92F672B5-CDD4-48D6-97FA-B11B7B28169B', 2, 'Kennedy X. Avila', '2021-04-21', '82DF8FF6-B1E8-0ED0-47A2-0ED4AD977B14', '468510461117', '2021-12-10', 'Ap #924-7557 Mus. Ave', '16000525 5', '(825) 565-2987', '48131-36307', 'amet.ante.Vivamus@at.net', '649-6879 Feugiat St.', '9803737840682', '2C2A7461-F59F-3544-A647-ECA36076A48F', '4734560502', 'Diam Institute'),
(4, 1, '2BCCCF8A-8933-5C4D-6699-B8F3269C1A85', 1, 'Bree Farmer', '2021-01-27', 'DDA435B1-F753-F777-DCA1-BE4596F83F72', NULL, '2021-10-12', '136-7266 Ullamcorper, St.', '16160313 7', '(653) 408-6601', '07349', 'nisi@inaliquetlobortis.co.uk', '469-3383 Vulputate Road', 'EA759A63-A5E9-7D54-4CC4-06615E8E5046', NULL, '4770668335', NULL),
(5, 1, '2D43E22E-3C1F-B3FE-22DE-0C3DA5E25C1C', 2, 'Dalton Cruz', '2021-08-18', 'EA58C999-E675-E535-921D-61EE2C02F22B', '169805500595', '2021-09-17', '516-7029 Tristique Ave', '16860808 4', '(941) 502-3292', '90-740', 'leo.Morbi.neque@Quisque.net', 'Ap #980-8100 Vel, Ave', '4094068386690', 'AE3287FA-F88D-6EA5-2908-FBD9A89A08EB', '7483357860', 'Ipsum Leo Corporation'),
(6, 1, 'BF83018D-1D49-1611-8694-4FCF4F38796C', 1, 'Kareem Ochoa', '2020-07-27', '03960BE7-01CF-4532-BE95-39293B388896', NULL, NULL, 'Ap #776-4906 Nunc St.', '16310229 0', '(979) 196-9920', '44031', 'amet.orci@eros.edu', '149-2290 Penatibus Rd.', '5CDA34D5-9336-3BDE-1498-9704B0E4C524', NULL, '6842928679', NULL),
(7, 1, 'FA8B1D42-2243-79C3-9F61-8A7BCADCB26D', 2, 'Jane H. Shields', '2020-05-04', 'DBCEDF97-805C-FE2B-0676-CC59CAE6367F', '864152293092', '2021-08-17', '8444 Aenean Road', '16151107 3', '(619) 935-5450', '74018-70326', 'elit.fermentum.risus@Phasellus.org', 'Ap #444-6824 Eu Street', '6624604857006', '5C1EB8F9-C5F5-576C-66B0-106C49DADD51', '6865145311', 'A Limited'),
(8, 1, 'FD90B0F3-BA1B-0937-F809-7E263FB444AF', 1, 'Declan Ewing', '2021-03-20', 'A99A3AE7-D3F1-D4E0-4B59-F65AEF97A0F6', '141065950111', '2021-03-09', 'Ap #979-7443 Natoque Rd.', '16720816 6', '(834) 141-3814', '00933', 'mauris@aliquetmagna.edu', '447-8251 Auctor Ave', '2508702064093', '2F3C4BAD-8CAA-56AF-AD5A-16EEAFB030D5', '6449875625', 'Pede Nec Ante LLC'),
(9, 1, '102ACE3F-8164-8459-4138-C1A3933C7748', 2, 'Ashely P. Haley', '2020-01-29', '436546BA-112E-6D08-AB9B-B74B392588F6', '216321170284', '2021-10-22', 'Ap #148-8342 Eget Rd.', '16980406 6', '(225) 357-5835', 'L6T 1Z1', 'fermentum.metus.Aenean@aliquameros.com', '495 Curabitur St.', '2794581000734', '33CB76BD-A7B6-75AD-45E8-3DDF38AF3121', '9081546060', 'Felis Purus Ac Associates'),
(10, 1, '6B1913F8-24CE-847A-2331-2C9FD5B17B34', 1, 'Brady Carver', '2022-01-22', 'DFF07901-E901-E1F2-53FD-9F4A299A58F5', '556164462505', '2020-10-27', 'P.O. Box 619, 6929 Ornare, Rd.', '16280520 4', '(155) 103-0415', '92959', 'ac@mus.co.uk', '963-3762 Placerat, St.', '4846469087724', '878C7D9E-8C30-D7A0-59DC-0307AE9DB742', '2928565805', 'Magnis Dis Parturient Inc.'),
(11, 1, 'D1EA24FD-E990-082D-C57D-43B4E80843DF', 1, 'Magee L. Rollins', '2021-10-14', 'E489E40E-417B-2390-F6F9-1AC377B913CD', NULL, '2021-03-29', '8454 Enim Rd.', '16080714 2', '(618) 848-8172', 'MK3W 1RE', 'felis.purus.ac@tortor.ca', 'Ap #175-7115 Penatibus Rd.', '2FD8F023-0E43-670B-F3A6-6BD338127E17', NULL, '2976235345', NULL),
(12, 1, '84CECB7B-891B-E404-53CA-E11106818611', 2, 'Gil Manning', '2021-09-24', '370A8614-B5AA-D47D-CE32-91A9AF302379', '654934651759', '2021-09-06', 'P.O. Box 522, 4229 Hendrerit Av.', '16470221 0', '(227) 949-8558', '93888', 'Suspendisse@elementumategestas.org', '695-7354 Nulla Road', '1987635415607', '37BEF9ED-29F6-97AC-1BCE-BDE25C291EBD', '3919000962', 'Nunc Sed Orci LLC'),
(13, 1, 'D1E9C5F1-6206-BCC2-3B5D-F4811EA109D7', 2, 'Shafira A. Mccall', '2021-01-22', 'EEFE6400-0F37-DF25-03BF-69B5874E7B1D', '407474469081', '2021-04-18', 'Ap #379-7171 Suspendisse Road', '16770222 5', '(550) 505-9344', '2476', 'in@nunc.ca', '622-8769 Eu Ave', '5153133786434', 'AF0E4C15-6FB4-C3CF-D1D7-B789AE9F3E4C', '2677392463', 'Ullamcorper Limited'),
(14, 1, '14B9176F-CA6C-807F-1B6A-35DF127B40E5', 1, 'Geoffrey P. Cantrell', '2020-11-27', 'E544B74D-391E-3B5E-4553-EDD92F6438CF', '809143740142', '2020-08-14', 'Ap #984-1906 Vestibulum Road', '16080629 9', '(798) 812-5447', '5236', 'sed.orci.lobortis@temporlorem.org', '618-3039 Et St.', '3815735045257', '259DB4D8-A727-A0E3-627C-70341DDA22DF', '9806013431', 'Posuere At Velit LLC'),
(15, 1, 'BE82630D-2DF7-B18D-7272-18AEFC4DBDC4', 2, 'Judah Coleman', '2020-10-14', '2C8ADF19-E956-2D54-4C69-91CA75A4B17D', '189542886207', '2020-12-13', 'P.O. Box 207, 6523 Mattis. Ave', '16201124 9', '(182) 746-5500', '68995-050', 'non@Nullaeuneque.net', 'Ap #800-7974 Ornare, Av.', '2762947989571', 'BE544911-2C37-D5EE-2A89-333671C96C85', '7143917719', 'Lectus Ante Corporation'),
(16, 1, '9114335A-2B6B-C028-AA59-4E064F02CBE3', 1, 'Odette Rosa', '2022-01-04', 'BCAB54DD-4867-D2BC-CC11-C40C2F3CEB6E', '182846108617', '2021-01-30', 'P.O. Box 823, 3152 Sed, St.', '16661006 4', '(831) 165-6802', '54594', 'lorem@fringillaporttitor.ca', 'P.O. Box 960, 6247 Quam St.', '8771476936738', '82128443-9D9C-0381-5CAC-461EDBEC360B', '7797214755', 'Sagittis Incorporated'),
(17, 1, 'FA423112-0AC8-973C-BE7E-E96120D92C78', 2, 'Elizabeth E. Jennings', '2021-04-28', '3CA76CA0-EEF7-768D-98DE-61B02EE88E46', '452584102079', '2020-12-20', '392-1249 Bibendum St.', '16920230 3', '(556) 820-6930', 'Z1342', 'pulvinar.arcu@mauris.com', '7728 Eget St.', '9659853793177', '0DF398C8-D7E5-C052-1584-E6E592B05F5C', '1845544369', 'Eget Ipsum LLP'),
(18, 1, '2FAE9728-7186-298C-18EF-AF4265C7B013', 1, 'Scarlett Hansen', '2021-09-14', 'CE1D8518-AB3D-7C49-28A6-E69BEB8A2897', '452729224569', '2021-01-13', 'P.O. Box 380, 2371 Non Street', '16710606 3', '(867) 940-7092', '36032-47253', 'mus@faucibusMorbivehicula.edu', '341-4787 Convallis, Avenue', '2551814177311', 'E030969F-7445-3EF6-87EB-D637FCBC2C0E', '7473073525', 'Leo Corp.'),
(19, 1, 'DEAFCBF1-157E-1E17-8C81-C9CF4078B9E9', 2, 'Keaton Rice', '2020-02-15', '4FBB1641-4FC7-2DAF-DB59-0B43FBAFC656', '132486329705', '2020-10-07', 'P.O. Box 978, 2148 Curabitur Rd.', '16490526 9', '(333) 233-8527', '678280', 'odio.Etiam.ligula@dui.com', 'Ap #871-8208 Facilisi. Street', '8721087033889', '6ED2EE98-FDC6-B0E1-FC08-E2DEDA9D426A', '7764587539', 'Ipsum Dolor Foundation'),
(20, 1, '37F2476A-0916-0D4D-8EC8-1708DCE51A0E', 2, 'Alexandra Harper', '2020-02-28', '0848DC3F-990A-A885-E90B-3FEB79481E58', '856664606758', '2020-08-10', '2137 Dictum Av.', '16680719 1', '(766) 215-2029', '13545-084', 'Donec.fringilla@bibendumsed.edu', 'Ap #743-8806 Adipiscing, Street', '7771352681901', '9CA0E6DD-5ACF-BA1C-3E54-504FDE5D6914', '7890711553', 'Ornare Facilisis Eget LLC'),
(21, 1, '92669C0E-0B92-A81D-45AF-7B365823BFA1', 2, 'Raphael U. Navarro', '2021-05-18', '9C06C9A9-8F9F-1E6C-02B4-077EAD5F2A3F', '675051726750', '2020-05-02', 'P.O. Box 456, 3545 Augue Ave', '16180203 0', '(500) 734-5335', '78631', 'senectus.et@fermentumarcu.net', '4358 Porttitor Ave', '6798508710851', 'FD03D9D7-285F-E828-C51A-18DB94A6B038', '4155969248', 'A Incorporated'),
(22, 1, '365DD160-FC61-2D90-ED00-4B5E2A0A3277', 2, 'Medge T. Rose', '2020-04-05', '2FD95029-D235-AF3B-2742-C5AACEA87FC1', '929681786298', '2021-02-24', '9239 Maecenas Av.', '16830518 4', '(843) 997-4454', '45457', 'sagittis.felis.Donec@faucibusleo.com', '838-7076 Mauris Avenue', '8357397318471', 'A2056448-E4ED-15C2-DCC4-2D25D491C487', '2205662491', 'Magna Corporation'),
(23, 1, '832CB3C5-8B03-546A-EF85-AFF24D1273B2', 1, 'Kenneth U. Townsend', '2021-09-22', 'CCCBB304-258A-4439-0A74-37006798FBB5', '435843447090', '2021-04-27', 'Ap #370-4618 Nunc Avenue', '16000620 0', '(472) 393-2740', '5513', 'et@est.net', '613-9539 Et St.', '7228687296698', '7D1B0906-941D-8A1E-D6CD-6FF0123CE766', '4278702770', 'Eget LLP'),
(24, 1, 'ED727974-A854-F06E-EC39-5C9A774283C8', 1, 'Zia Hess', '2020-05-14', 'D4B3EE3C-0D27-F189-55F0-BCD8A2D36AF8', '634862407917', '2021-08-04', '5877 Euismod Rd.', '16671021 1', '(363) 461-9774', '08840-581', 'torquent.per.conubia@massaInteger.co.uk', '2681 Urna, St.', '8393665970391', '3CFDB09F-56BB-EC91-022A-2D54B9220E0F', '7338748792', 'Volutpat Corp.'),
(25, 1, '3DC78AE7-66CB-FC91-8C0F-D80D9BCA0C5F', 1, 'Emily I. Huber', '2020-11-21', '356CD9B4-51E8-F21E-25FD-EB0B4693E9EA', '305712970265', '2020-11-20', '426-1348 Mollis. Rd.', '16230221 4', '(816) 369-0907', '64891', 'erat.neque@aliquet.org', '5462 Eu Ave', '7791458220208', '988E9484-CD7E-02D6-D794-E54841E60AA2', '6690711692', 'Phasellus Limited'),
(26, 1, '7CC05FE5-3CAE-4EC7-D648-6208CEEFB0F8', 2, 'Astra Curry', '2020-08-22', '5AC9C7AE-2963-1F86-A1C9-E87AEBA94DFA', '880183111177', '2021-02-09', 'P.O. Box 989, 5858 Feugiat Rd.', '16510621 8', '(606) 241-1742', '91792', 'euismod.mauris@est.edu', '3751 Non Ave', '7942264349982', 'E171FAEF-43E4-4B15-EF33-2A9CEFF6D83C', '3052025159', 'Vitae Foundation'),
(27, 1, 'B6A6DF8E-129A-BD1D-D1BD-BA5EBEB97F96', 2, 'Allistair Thompson', '2020-07-20', 'D5E1100E-BFCF-D1DA-A617-60B90D851FBE', '949399336266', '2021-01-16', '485-9304 Interdum St.', '16540905 2', '(712) 755-7552', '472918', 'at.velit@interdum.co.uk', '850-311 Tellus Road', '3405836361716', '209F625C-F289-A04C-BD05-E50DC5CE4815', '3303860622', 'Donec At Arcu Corp.'),
(28, 1, 'F0D3D24C-1E51-25FD-1ED2-EAA33877EDD5', 1, 'Heidi U. Weiss', '2020-02-11', 'F69E412C-9C70-1C3F-F56A-F548044AF654', '802628253122', '2020-05-04', '7253 Purus. Rd.', '16060628 6', '(542) 597-5349', '96936', 'ultricies.ornare.elit@molestie.net', 'Ap #948-2021 Orci St.', '9108418354025', 'B755121B-5B01-3B16-3835-A1F4B5F69C59', '7054539008', 'Ac Eleifend Vitae Ltd'),
(29, 1, '20E00B4F-6DEF-6327-BC4F-705917DB84FA', 2, 'Keane U. Faulkner', '2020-04-24', '5172012A-7433-AD46-393C-F5173618D791', '456482640507', '2021-05-03', 'P.O. Box 162, 8815 Ipsum. Ave', '16080609 4', '(120) 447-2819', '6377 MR', 'gravida@dolor.net', 'P.O. Box 114, 7264 Porttitor Rd.', '1921603214386', 'B6D7166D-1C0B-38CA-53CA-2335CFD52A2B', '9500657154', 'Lectus Ante LLC'),
(30, 1, '39FA77EA-5A3E-BAEF-3B76-B48B7FCA918F', 1, 'Shoshana Lawson', '2021-12-31', '1FF9C54F-E6F4-024A-AB53-1F04CEC186AF', '738617460407', '2021-04-10', '240-8331 Habitant Av.', '16310908 7', '(279) 874-6013', 'D4 9HQ', 'Phasellus.vitae.mauris@velitQuisque.ca', 'Ap #226-4305 Fermentum Ave', '3514684497695', 'FB40698A-FB88-DD5D-2D18-8A25D1A57BB4', '7045257823', 'Faucibus Id Libero Company'),
(31, 1, 'A71D78C6-0FE4-375C-F3F4-743C6A7A9F13', 2, 'Prescott Allison', '2020-05-17', '3E73B9FE-5563-0A62-FC8C-C010860196BB', '594627098017', '2020-02-10', 'P.O. Box 121, 2866 Vel Avenue', '16880427 3', '(324) 604-1269', '72942', 'libero.mauris.aliquam@dolorFusce.edu', '8424 Odio. St.', '9225133867282', 'D7496E41-D28C-2182-B368-EB2094363F5F', '9249324337', 'Mus PC'),
(32, 1, '02E8094C-C47A-43B7-6200-FDAA4AD8A636', 2, 'Avram F. Dickson', '2021-08-22', '399C5474-00C0-2240-31BD-57094EB37505', '740244857321', '2020-10-22', '2775 Ante Av.', '16351230 3', '(954) 244-6153', '5876', 'Sed@nulla.org', 'P.O. Box 508, 9886 Orci. Ave', '4413193333621', 'D0DB02A4-D63F-E5E4-2D6D-6C949889680C', '8627166656', 'Fermentum Metus Aenean Ltd'),
(33, 1, '04143D9F-963E-258C-49CB-56FDCBD92DFC', 2, 'Colorado Webster', '2021-09-03', '29606C99-DC91-E24D-0CA6-32AAE0636902', '506967899639', '2021-05-14', '822-9896 Nunc. Rd.', '16780219 0', '(324) 977-7850', '5400', 'non.lacinia.at@rhoncusDonec.co.uk', '501-6528 Magna Av.', '6891825278391', 'DC6FD929-96AB-A401-483F-44AA12CA2125', '9704609554', 'Class Aptent Taciti Foundation'),
(34, 1, 'C770D0FF-3A4B-B5D5-FA0C-3E762C777E35', 2, 'Kasimir R. Blevins', '2022-01-25', 'D46896E7-03DE-5B3D-D636-02CDD0626F38', '128049460137', '2021-06-28', '4853 Ullamcorper Road', '16780924 7', '(620) 602-6559', '947020', 'magna@liberomauris.com', 'Ap #140-4961 Nec Road', '2972264171492', '6D1C96E9-E1B1-1434-433D-5E6841D50143', '6941903962', 'Dictum Sapien PC'),
(35, 1, '138CD071-7981-DA9F-FC60-C3C29CFC4280', 1, 'Karly T. Jacobs', '2020-07-13', '35F85E1E-1072-5740-47EA-0594D78D3940', '806915185114', '2021-05-21', 'P.O. Box 445, 1669 Sollicitudin St.', '16820718 9', '(375) 319-9807', '1016', 'ultrices.sit.amet@viverraDonec.edu', 'P.O. Box 701, 3028 Diam Av.', '7177644494230', '941E1435-D556-2E87-CA75-470248967778', '3911906455', 'Vel Arcu Corp.'),
(36, 1, '7D8AAF27-4B92-C334-A40D-C20112C606F9', 2, 'Judith W. Lawrence', '2021-03-06', '63B9D556-05E2-FAFA-D7EC-959B0FB613B2', '389152276755', '2020-05-15', 'Ap #149-5401 Placerat, Ave', '16700605 2', '(347) 633-4727', '5037', 'non@etrutrum.co.uk', 'Ap #120-2821 Orci. St.', '3248356127386', '5AFAC5DF-9B0C-5BF5-2133-08D515D08333', '9494461414', 'Per Conubia Corporation'),
(37, 1, '103125B2-5CEF-126E-F0D3-8E8F6ECC1B7E', 2, 'Reuben D. Burch', '2021-10-22', '2E64E0E8-9A1F-747A-8EF0-C74A0A482F23', '852574874154', '2020-02-06', 'P.O. Box 320, 2306 Suspendisse Avenue', '16840826 1', '(797) 777-3201', '39-529', 'commodo.at@ultricies.co.uk', '3351 Et St.', '8600203925121', '4318F4C4-EE01-015F-6010-C561378D8D8C', '1234999174', 'Condimentum Donec Ltd'),
(38, 1, '4FBA3739-4D15-F33E-00B6-C4DF69F2199B', 2, 'Noelle T. Turner', '2021-01-12', 'CCBF74E5-E65C-5F69-A6A0-3B21427C6AAF', '887761131391', '2021-04-13', 'P.O. Box 438, 138 Cras Ave', '16770318 4', '(678) 947-4013', '36455', 'ante@volutpat.org', 'Ap #796-3454 Tellus Ave', '8218629409283', 'F0BC909E-3757-0558-EB64-D7D7CBF3B23D', '8074857512', 'Placerat Augue Inc.'),
(39, 1, '8E24B67A-D013-F5D3-C725-B34D14115900', 1, 'Jonah Welch', '2021-09-19', '9313891E-354C-BFDD-74FB-6FBAD7A4F982', '537089568558', '2021-08-22', '2555 Diam. St.', '16920115 2', '(648) 499-8727', 'AM04 7GT', 'bibendum@eget.edu', '6944 Tempor Ave', '3120888256852', '00B189A4-9FDE-CAD6-AE6F-2C2285828A0D', '5926485359', 'Vel Nisl Quisque Industries'),
(40, 1, '50633845-A5B4-31E4-F051-194BFCDA2494', 1, 'Conan Callahan', '2021-04-17', '2CFDAD14-49DA-59AC-1900-33D72D6617DF', '115754584195', '2021-04-27', '3700 Mauris Road', '16340323 5', '(285) 555-8165', '881183', 'tellus@tristiquepellentesque.com', 'Ap #917-9636 Libero. St.', '9280529028354', '1B1BEAF8-2C24-C98E-7C3D-1DD4DDF12169', '1808428314', 'Diam Incorporated'),
(41, 1, '00DA7469-D426-963E-3F49-A116491D49E8', 2, 'Margaret Webb', '2020-07-17', '8DA1137E-CE07-FCB5-8B86-B601586C4C41', '820611441404', '2020-08-12', '1431 Donec Road', '16420619 1', '(316) 526-7338', '412449', 'ac.ipsum@malesuadaaugue.com', '970-9294 Euismod St.', '1697921546488', '9E90CF64-CDE6-33D8-EDFD-76AD48C2E4CC', '5304226545', 'Massa Incorporated'),
(42, 1, '443524BF-5A37-E1CE-9ED1-2B53C5933DCA', 1, 'Gregory R. Cantrell', '2020-05-02', 'E9EDEE55-C8D9-4486-8D87-417103810592', '685534845658', '2020-12-03', 'Ap #880-2715 Pellentesque. Av.', '16650728 0', '(743) 141-8506', '7283', 'tellus@auctorvitae.org', 'Ap #418-133 Nunc Rd.', '5929456928555', '891D1593-99E5-12BE-3576-5DBD402A1A9E', '3993546156', 'Mi Ac Industries'),
(43, 1, '3672B341-A840-AEC2-458B-625B492FA780', 2, 'Sopoline Y. Gibbs', '2021-12-24', 'BE4841A6-9B8A-4F51-3272-C69617E692D9', '479844944559', '2020-02-18', 'Ap #820-352 Eros Road', '16770907 0', '(151) 219-7108', '304014', 'eu.nibh@quistristiqueac.org', '163-6795 Neque. Ave', '9497352225032', 'BD1E60BC-8281-5DDF-A7CD-13AFDB2EC6EE', '4271769717', 'Donec At Arcu Limited'),
(44, 1, '1164DC94-AD4C-8D0B-7D29-5D17C8084BA6', 1, 'Tatum Montoya', '2021-08-09', 'FA329CBE-72C6-2A44-D67F-3607E5A1036B', '236626427451', '2021-11-04', 'Ap #890-3306 Ad Avenue', '16330708 8', '(800) 240-6355', '327942', 'a.auctor.non@torquent.ca', 'P.O. Box 273, 6243 Aliquam Rd.', '8450418611719', 'BA90693F-0690-6246-6FFB-4E8474BB28DE', '3676378309', 'Magna Malesuada Vel Institute'),
(45, 1, '667A94BE-B8F8-F688-913D-099851E4D037', 2, 'Cullen U. Koch', '2020-04-17', 'CC173142-6143-6F81-7EF3-5B425BA1E516', '664514206199', '2021-03-11', '7586 Sed St.', '16560421 7', '(672) 176-7016', '4585', 'diam.Duis.mi@magnaSedeu.net', '387 Malesuada St.', '4843698071541', '04123374-35EE-26D1-B1C7-7DE699343617', '9940150932', 'Etiam Vestibulum Limited'),
(46, 1, '46EA0938-37DC-B112-B657-411DA639A9B0', 1, 'Rose Buckley', '2021-07-01', '7CDC8850-0CCE-1C58-EA7C-159A13432CC5', '402752318201', '2020-08-24', '345-5423 Nisi Ave', '16820230 2', '(226) 485-2131', '97885', 'nisl.elementum@nascetur.co.uk', 'Ap #413-5616 Velit Rd.', '2370350292399', '0D6974CF-FF53-3FB4-7DF1-2919BAC20C53', '1929187694', 'Vivamus Foundation'),
(47, 1, 'E1B3D98B-15AC-3693-C3DE-C4DAA0BDEBCE', 2, 'Salvador U. Frank', '2021-07-12', '473C35A4-2718-7189-9F34-B2DBFC355E51', '823419501500', '2021-10-17', '4683 Pellentesque Street', '16380901 3', '(829) 347-5341', '114541', 'mauris@sitamet.edu', '3047 Gravida Av.', '1555993873102', '6BBDC195-E1EE-16E3-E801-DC3568129DCC', '5024523026', 'Fusce Limited'),
(48, 1, 'DA5F7DFB-EA92-5E28-E35F-71D11FC98532', 1, 'Kirk Rocha', '2021-02-19', '146618E7-AF74-F566-940C-F43FC22AC4E3', '846809910977', '2020-06-03', '2501 Magna. Avenue', '16720525 9', '(722) 325-2387', '13687', 'non.dui@Ut.com', 'P.O. Box 306, 2021 Augue Ave', '1357384913705', '3824A46C-4C49-4808-4D60-483249E3DD9F', '6430651124', 'Et Magna Praesent Institute'),
(49, 1, '5E9B10DB-C073-5789-6E07-B2E2E49778D4', 2, 'Desirae Taylor', '2021-01-16', '93C1A656-B5C6-FBF5-7B41-037212012E42', '322114076253', '2021-02-08', 'Ap #433-2181 Rutrum Rd.', '16620702 0', '(316) 490-0653', '41606', 'ultrices@ac.co.uk', '7467 At Rd.', '4586497812294', '39AD57DA-C2CA-C938-2003-6C722BA4646A', '2498621439', 'Sed Nec LLC'),
(50, 1, '5647810F-1A30-8F4F-C44D-82FA980E7D23', 1, 'Adele Cross', '2021-02-25', '9A733377-137E-1CEB-AAB2-765F06A1B56B', '580942325736', '2021-05-05', 'Ap #432-9124 Auctor. Ave', '16380216 7', '(475) 978-0813', 'R0Z 6S3', 'at@faucibusleo.net', '502-8470 Tellus Road', '1477981079025', '2270E1D1-1806-04A7-06C3-4E9ABFC41A8F', '5962553996', 'Sem Incorporated'),
(51, 1, '8D0570B2-4036-E1C3-78C9-431909B3FF00', 1, 'Kiara Bridges', '2021-10-21', 'CA7E9714-B3F3-65FA-363B-AC29B061E375', '113868893836', '2021-06-02', '141-6206 Pede. Road', '16090530 6', '(510) 453-2592', '35734', 'interdum.Sed.auctor@interdumfeugiat.edu', '437-6307 Tempor Av.', '3012110464361', '64D5FF70-D9FA-D2A1-662A-0F90298630AC', '4192206941', 'Sit Amet Lorem Corp.'),
(52, 1, 'C820785D-76B2-3F6C-91DA-36929FA7A5A1', 2, 'Cally Wilkins', '2021-10-28', '93CF65BA-8325-C801-5586-EA0858B0A01E', '320609282584', '2021-08-16', '149 Ante Av.', '16830606 8', '(882) 484-1855', '539556', 'senectus.et@inconsectetueripsum.com', '7071 Massa. Ave', '1974433759437', '5F1C2E10-0ECE-BF5A-1AA5-33F80FD032C6', '1937202706', 'Quam Quis Diam Associates'),
(53, 1, '3EE85BBE-C672-3963-46FE-FACC53A0DC97', 2, 'Kiara W. Hooper', '2020-03-03', 'DC0A3B03-6984-D6D1-172B-989932D2F5D6', '258849637782', '2020-06-25', '5909 Interdum Rd.', '16750421 8', '(159) 557-9923', '618722', 'posuere.enim.nisl@elementumdui.ca', '178-990 Scelerisque Road', '9006233429240', 'D3638D26-4190-0B59-B08C-DFA62906A198', '3820950729', 'Quam Pellentesque Industries'),
(54, 1, '45E18FD1-B4EA-E691-B4C9-1240BE431800', 1, 'Bree I. Maddox', '2020-09-08', 'C4EF30D3-7B74-F00D-53FD-042E5361AAD4', '565106819361', '2021-09-02', '162-9898 Maecenas Ave', '16891119 4', '(340) 684-6273', '59621-17424', 'Nullam.feugiat.placerat@non.edu', 'P.O. Box 755, 9749 Posuere Street', '1786603958317', '775A9352-A293-1D5B-8211-70B2339BA478', '8489855525', 'Dolor Tempus Non Incorporated'),
(55, 1, 'A3721C7B-4772-4BC8-0667-36F15D9538A0', 1, 'Salvador Roman', '2020-10-23', '9F665187-E513-9D46-0AD3-597ED7AA7CD9', '762726748313', '2021-08-07', '4544 Nec Road', '16220822 7', '(101) 539-9518', '20702', 'enim.nisl@loremegetmollis.ca', 'P.O. Box 755, 2770 Urna Rd.', '4920346814775', 'A9E33096-5262-9F2F-96C8-DCF6FBA3597F', '8913527174', 'Elementum Purus Accumsan Corporation'),
(56, 1, '3C5A4261-BB52-EDB1-CC64-D4AA5446A69D', 2, 'Nomlanga W. Lester', '2020-03-06', 'B08F91B4-9908-ED96-2D61-8E005292B83E', '593101989335', '2021-07-15', 'P.O. Box 184, 1384 Curabitur Ave', '16380118 5', '(309) 500-7837', '6944', 'eu.tempor@lectussitamet.org', '7838 Et, Rd.', '3831707965934', '9C826AA9-A3B0-4AD3-F225-59DEE272164C', '8454652864', 'Non Nisi Aenean Corp.'),
(57, 1, '437FCF73-6557-DEEF-56F6-284F73407FC1', 2, 'Dahlia Mccall', '2021-07-09', '93318644-589A-ADF1-732A-4E85C29D64D1', '257745260749', '2020-04-01', 'Ap #476-5374 Adipiscing Rd.', '16860718 5', '(432) 345-0560', '72639-72528', 'amet.nulla.Donec@sed.org', 'Ap #652-8875 Libero Rd.', '5609858544206', '6DBBB8E5-0F7A-5D61-2828-FAE71ED4F0CD', '8037514550', 'Nunc Laoreet Consulting'),
(58, 1, 'A8FCDB93-F9D7-C8CB-90BE-0264CC064E72', 1, 'Noelle Kerr', '2020-08-23', '7D752C0F-100D-29AA-443C-FD197E7D6CC3', '910196219140', '2021-06-08', '1622 A St.', '16111105 2', '(868) 265-1216', '9438', 'a.ultricies@ornare.edu', '5612 Nibh. St.', '5680828595069', '683957B8-3121-D150-0B51-728FA95CC76A', '8760370421', 'Commodo Corporation'),
(59, 1, 'AD4BB220-60E4-6DD2-EDC2-409A0A69F721', 2, 'Heather Durham', '2020-05-19', '9D8C7FE4-7AB8-F414-63A3-35630B1A8E10', '212253096319', '2020-03-05', '474-8847 Nec, Avenue', '16530616 8', '(625) 125-3340', '30104', 'diam@elit.com', 'P.O. Box 676, 2467 Enim, Rd.', '2724446213108', '51613474-3E4C-B418-DB4C-8EDDF51737E2', '3843548636', 'Velit Ltd'),
(60, 1, 'D0D24889-48E3-0EC0-0420-9CA3E4D7D343', 2, 'Kaye Cleveland', '2020-07-04', '2874A3E8-8CFB-915C-5D0F-BD07D4851636', '984588595310', '2020-01-25', 'Ap #155-7512 Duis St.', '16761004 1', '(249) 978-7789', '51713', 'in.magna.Phasellus@velit.com', '1971 Dignissim. Street', '7233123950933', '86421C9F-2988-C645-1C65-FD485F410FA9', '7262455264', 'Taciti Sociosqu Associates'),
(61, 1, '8E5E852E-AC23-AA1A-F49A-888A8DE9B31E', 2, 'Idola O. Ferguson', '2021-06-24', 'D7074568-61E6-5801-C4E4-92196D67A799', '134194654462', '2020-04-17', '3105 Iaculis Rd.', '16480230 5', '(411) 735-5533', '1497', 'arcu.Curabitur@gravida.co.uk', 'P.O. Box 270, 2302 Et Avenue', '5434461598944', '19F322D1-A28F-FCD5-99B7-C89A99FA8A17', '3100044463', 'Sociis Natoque Penatibus Industries'),
(62, 1, '9C6A9B12-F640-7EFF-2316-5F42549F222E', 2, 'Jaime I. Dunn', '2021-12-06', 'C86A5721-4EB2-031F-DFA3-0766EF51F53A', '242825297677', '2020-11-22', 'Ap #336-4116 Cursus, Street', '16950218 2', '(821) 572-8445', '025730', 'Nunc.mauris@nec.com', '3643 Mauris Rd.', '8338524076959', '0CC82254-86A8-0811-8122-44F34CE42CAE', '3678452651', 'Duis Sit Limited'),
(63, 1, '93A428E9-FD81-5954-282E-05BDBC8473CF', 1, 'Lev F. Weeks', '2021-04-23', '6EC3727D-AB9E-4DEB-9DED-84A053279CE0', '826071369377', '2020-02-19', 'Ap #408-2802 Viverra. Street', '16910223 7', '(236) 406-2829', '940299', 'Pellentesque.ultricies.dignissim@eget.org', '9389 Sem Avenue', '4785910292188', '19B39A79-A5E2-496C-248D-33115B322B3D', '8450434426', 'Tristique PC'),
(64, 1, '4C2D6267-669C-F48C-2CFB-6D6C5F0EB2B9', 1, 'Dara W. Stuart', '2021-05-06', '5D0D3208-D732-892B-7C8F-D9947BD5B458', '178848151683', '2020-06-01', '9217 Mus. Avenue', '16850905 9', '(460) 948-0033', '6319', 'ut.nisi@urnaconvalliserat.net', '350-1909 Felis Ave', '7414038361037', '5378684C-5698-88B9-3147-9C05DA73D6EA', '6620664285', 'Sagittis PC'),
(65, 1, '111FB603-0E38-4B01-433C-F42C910B8662', 1, 'Ignatius U. Emerson', '2021-01-14', '83848B30-2155-004A-36FA-51D697A06B71', '722652822579', '2020-08-04', '174-4884 Cum Rd.', '16201027 7', '(706) 611-7227', '967386', 'vestibulum@gravidanon.com', '957-7862 Dolor Avenue', '4795253894908', 'C97112F6-F222-4591-07E6-DC967FAC2519', '1054905558', 'Ipsum Primis Associates'),
(66, 1, '3D2AABE9-46BA-99A4-F1CA-2860366580E6', 1, 'Tanya O. Pruitt', '2021-09-27', '0CA2CE92-F80F-2042-9296-684BACA95C1B', '347329484084', '2020-12-14', 'P.O. Box 657, 2668 Pellentesque, St.', '16050330 0', '(780) 947-1712', '2440', 'vitae@ametnullaDonec.co.uk', '774-5826 Mauris Road', '4922220881677', '9B68DA37-01A8-FF30-372A-6D7610BA666C', '3341410851', 'Egestas Urna PC'),
(67, 1, '65A69243-AD9C-F9F3-8217-C14E9E7BC482', 2, 'David H. Donaldson', '2020-11-10', '90B22C38-28AB-A387-E033-9D0EF2612EA0', '664252924441', '2021-07-18', 'Ap #975-710 Pede. Ave', '16510409 3', '(622) 137-6535', '37118', 'enim.commodo.hendrerit@Quisqueliberolacus.org', '3531 Id, Ave', '7154918172361', '67AEDD75-E962-1FBA-76E0-A50CB447A94C', '4821089955', 'Rutrum Urna Company'),
(68, 1, 'C3236B15-C928-28D8-9DFD-CD30A5737871', 2, 'Judah Hudson', '2020-05-14', '1DC962E8-5A58-3DEC-B508-E57FE3789F59', '410050463034', '2021-05-21', 'Ap #998-509 A, Ave', '16071106 4', '(798) 944-0796', '267018', 'bibendum.ullamcorper.Duis@aliquetmagna.org', '2062 Quisque Ave', '1779427463835', '313C8B9B-2B20-941F-23FF-051AC879C37E', '7754404752', 'Euismod Est Arcu LLP'),
(69, 1, '792F3D5F-F791-37C8-7834-74A1695CC66C', 2, 'Mia V. Guy', '2020-09-08', 'FA6D89BD-64A4-76FE-98E4-1F50CD175070', '808741496057', '2020-08-31', '3302 In, Ave', '16621216 2', '(496) 973-7276', '68951', 'massa.Vestibulum.accumsan@tinciduntduiaugue.co.uk', 'Ap #805-3866 Aliquam Rd.', '1362559088133', 'AFEFA36E-0E9B-B331-772B-127CA3CBC42A', '6857713477', 'Ultrices Iaculis Odio LLP'),
(70, 1, '964E2975-3BC0-EBFA-EAB6-CE1235FEAE3A', 1, 'Francis Harvey', '2021-06-07', '3F4D9C9A-6BCC-832F-A8D2-49905284CF85', '983238242392', '2021-08-17', '197-1356 Bibendum. St.', '16561125 3', '(254) 832-0124', '40911', 'pretium.neque.Morbi@laciniaSedcongue.com', '175-3904 Sed Rd.', '2129142738119', '556DE487-276E-FD09-086E-A7EC0987A5E7', '2285626243', 'Dolor Dapibus Gravida Corp.'),
(71, 1, '81E98579-FB26-5E40-9912-2976B0F392A7', 2, 'Leo Barrett', '2021-08-15', 'FF422692-795A-046B-85C9-518F00BBBECF', '981112860500', '2021-02-14', '3709 Nullam St.', '16301201 3', '(598) 117-5603', '483388', 'dignissim.Maecenas.ornare@interdum.com', 'P.O. Box 201, 1673 Non, Road', '7837002843121', '3F44B553-FF25-33C9-04CC-4DCC3CF68947', '6706332929', 'Sed Hendrerit PC'),
(72, 1, 'BB0DA4E7-5FAB-77F1-E854-708FC4231836', 2, 'Xavier Hoover', '2021-05-17', '32E14ADE-FF0D-365C-4040-1E1BA63CA06A', '766692671556', '2020-10-08', '779-3305 Vel, Av.', '16050214 5', '(722) 558-0406', '84513', 'erat@adipiscing.ca', 'P.O. Box 683, 2467 Ipsum. Ave', '3660294189862', 'D429C101-360D-B2FB-C95F-EA7DF41353DA', '6396375169', 'Fusce Diam Nunc PC'),
(73, 1, '0CEE74F3-2DB4-712E-FAB5-F131BAEA7216', 1, 'Adele English', '2020-08-07', '98A5B7FA-7E9B-DF5C-9C47-27634D153890', '418649389701', '2022-01-06', '1957 Tellus Rd.', '16500620 3', '(437) 659-5573', '408440', 'Morbi.vehicula.Pellentesque@nislMaecenasmalesuada.org', 'Ap #801-4005 Nulla Ave', '9153364263717', '3C5C6413-49D6-BE58-1D1A-FC105C8AC6EF', '8004000967', 'Natoque Inc.'),
(74, 1, '9955296D-A7C9-C11E-DD39-12442C77F0E3', 2, 'Brody F. Byrd', '2021-09-22', '858AE948-63DC-CCFE-806F-9E5A7C3F6526', '629474049179', '2021-02-21', '888-7759 Semper Avenue', '16890502 9', '(178) 852-4538', '37058', 'ipsum@ascelerisque.edu', '2391 Donec Rd.', '7681818368723', '8B305E98-AFDF-B122-D4DE-D48DEDDB3989', '9155905865', 'Libero Limited'),
(75, 1, '4EFB59D9-9AB8-D1C3-4739-E2A39C2A6CB0', 1, 'Allegra M. Valentine', '2021-05-01', '3A8874D2-70D9-AC8C-CEE2-036073A1D8F9', '673325843294', '2021-02-24', '423-8084 Sed Road', '16160925 6', '(645) 537-1390', '001070', 'eu@mauris.net', '8881 Proin Ave', '3376634909289', '335F0276-DC7C-2EC2-5C81-A3BE47836BAF', '8580565946', 'Sit Amet Limited'),
(76, 1, '01221D60-AFCA-A22B-5270-0A7B973F372E', 2, 'Melyssa Christensen', '2021-12-16', '39FFA7EB-8BFD-EAB8-10D6-E79F10D8F6C2', '127008815075', '2020-03-22', 'Ap #110-1681 Augue Street', '16100524 8', '(768) 565-4261', '8652', 'et.libero@feugiatmetussit.ca', 'P.O. Box 235, 5552 A Rd.', '3206828746210', 'C1A8478E-A4C2-C47A-DDA3-F043BBDBB19C', '2102581190', 'Magna Cras Associates'),
(77, 1, 'FDFA338C-5665-848C-6B52-0B9F39F6E9DC', 1, 'Arden H. Hudson', '2021-06-25', 'A2446C32-A915-FEAA-B341-EF96739C660A', '648207015892', '2021-02-12', 'Ap #596-6913 Ligula St.', '16161026 7', '(550) 242-0730', '585536', 'eget.tincidunt@gravida.org', '6336 Turpis. Rd.', '2647627286190', 'D38079F7-E19D-749F-59B8-4FEBB537F3F5', '2574395834', 'Sed Sapien Corporation'),
(78, 1, 'E50D19FE-08C6-F512-D5D5-98A97027C28B', 1, 'Gary O. Franco', '2021-08-10', 'BB821791-142B-5C32-FE16-BAC43FF28460', '784423220432', '2020-04-11', '534-2436 Hymenaeos. Rd.', '16960410 4', '(412) 192-5509', '60839', 'porttitor.vulputate@auctorveliteget.net', 'P.O. Box 461, 2879 Proin Road', '9977622431213', 'FB6F26D5-EB94-52C9-7E3F-465ADFE89553', '1944453778', 'Ornare Industries'),
(79, 1, '54EFFEC0-5D80-083F-2C54-68FEF75A7888', 2, 'Fallon V. Henderson', '2020-08-24', '349BC4EC-2AC5-04B6-089F-FA837BE17DE8', '500362958306', '2020-07-17', 'Ap #805-5447 Erat Ave', '16991008 8', '(523) 288-5888', '640039', 'elit.Aliquam.auctor@in.edu', 'Ap #616-5452 Odio. St.', '9067911662426', '2A09D08D-FD53-B180-01A9-B4DB90F2D3CD', '5529126668', 'Purus Accumsan Interdum PC'),
(80, 1, '91D3A3FD-0EF5-AE69-00BB-3532F3D92536', 2, 'Naomi Willis', '2020-07-08', '3B2ECAD2-8D37-471D-BF96-927D0EF30F96', '167708992510', '2020-06-21', 'P.O. Box 828, 8721 Penatibus Ave', '16220106 0', '(314) 439-2808', '36378', 'Maecenas.mi@lectus.net', 'P.O. Box 349, 8630 Risus. Avenue', '3894322352238', '07B38867-CF6E-15D9-847D-CE979C69794F', '1781097303', 'Erat Vitae Ltd'),
(81, 1, '08CB9DEB-5AE6-7192-5E88-6B2C510C8C07', 2, 'Jacob Stewart', '2020-06-23', '2E2FD406-379E-0126-CA78-BF25DBC8502B', '123477226302', '2021-09-15', '4973 Condimentum Rd.', '16970713 9', '(587) 134-8947', '051728', 'nisi@dictumultricies.ca', '9478 At, Rd.', '2511167342133', 'F793C9D3-BAA3-6E20-787F-7DA7B806CA48', '9031713316', 'Nascetur Ridiculus Corp.'),
(82, 1, 'B3A4156B-A2D6-247E-41CC-EC1D4798EAB2', 1, 'Wilma Sullivan', '2021-06-18', '1DCFC59C-9458-6938-43FA-E4A3B337DB4F', '420662069350', '2020-03-01', 'Ap #312-2580 Dui Ave', '16390824 8', '(992) 194-4670', 'Z9524', 'fringilla.purus.mauris@Etiambibendum.net', 'Ap #814-839 Nunc St.', '4098517176676', '73E38755-6F22-AE8C-C33E-90E579D3E029', '1367723624', 'Nunc Corporation'),
(83, 1, 'E7EF6304-7C43-D98C-AF35-37A3592ACB68', 2, 'Wing Z. Griffin', '2020-11-24', 'AD009DE9-324E-8675-2E30-3A6B7BBE5288', '680764998420', '2021-07-01', 'P.O. Box 982, 7031 Phasellus St.', '16710601 0', '(950) 856-9013', 'A5S 5Z5', 'eget.dictum.placerat@NullainterdumCurabitur.com', 'P.O. Box 371, 4204 Eu Road', '4713594583104', 'EB8F5382-FCC9-971A-E2A7-570A2C822BAD', '8475801000', 'Turpis Incorporated'),
(84, 1, 'C49B5DA9-20E6-847B-5AB5-EDB9FE30F593', 2, 'Allen Lewis', '2021-01-06', 'B073376F-B1CC-3148-52B4-3307991D0E00', '767941443107', '2022-01-11', 'P.O. Box 997, 3143 Aliquam Av.', '16250720 4', '(486) 839-2180', '21317', 'dictum.augue.malesuada@Sed.co.uk', 'P.O. Box 940, 3204 Varius St.', '5978605013335', '568F5B7E-33FB-AFCE-1B14-593CE199D326', '5168338050', 'Scelerisque Lorem PC'),
(85, 1, '0749AE8F-565C-68F9-334B-C47EE4E33A4A', 2, 'Kaye Davidson', '2020-07-30', '17064FE9-E0D0-2F88-FBC8-BADB2F4AD12F', '756206570153', '2021-10-27', 'Ap #805-842 Nullam St.', '16450707 6', '(422) 721-1537', '11676', 'quis@quamvelsapien.com', '3456 Risus. Ave', '1129260839558', 'DB6D90B9-4F43-1697-038B-44788B512AA3', '6641455070', 'Arcu Morbi Limited'),
(86, 1, '884E72D8-252B-FA89-04C1-5A7EB96E31CF', 2, 'Rooney Z. Maldonado', '2020-10-05', '83C643BD-9A1D-B0CC-E73F-3C20023DCA27', '116331379167', '2020-10-06', '9943 Hendrerit Av.', '16250315 3', '(312) 314-8889', '69-496', 'auctor.nunc@erosnon.net', '8998 Laoreet St.', '6570540523530', '6E60F841-5595-404E-12F4-5FF471D34A47', '6251642106', 'Proin Vel Arcu Associates'),
(87, 1, '5583ED66-70F4-E6FC-6AF0-57662BBECA96', 1, 'Bevis Gentry', '2022-01-16', '997DD890-947F-D062-5A71-1F01946EDC8F', '946245439471', '2020-11-12', '8010 Lorem, Ave', '16791006 8', '(378) 963-2280', '228773', 'per@necquam.edu', 'Ap #313-5688 Mi Rd.', '7990117899553', '5044C9FC-7B2E-0176-84FA-176940104D8E', '5119753605', 'Diam At Pretium PC'),
(88, 1, '32201DBD-5468-949C-1BC8-E8D946A5395F', 2, 'Shana Vance', '2020-06-11', '255B5B84-F742-ABFE-96BF-FFFA737ED11D', '334829815294', '2021-12-21', 'P.O. Box 768, 2651 Pede Rd.', '16300422 5', '(662) 809-2647', '94-191', 'egestas.Duis@Donecat.ca', 'P.O. Box 251, 9690 Gravida Rd.', '8609748848772', '850A0053-CD07-9E6A-E882-2ACA7F2C590E', '6887087913', 'Dignissim Magna A PC'),
(89, 1, '452D386E-4FAF-DF55-663B-E80F4B5AD3B7', 1, 'Amela Rhodes', '2022-01-24', '1365C596-34CB-B55C-7913-632A47ACBF11', '421704931889', '2020-07-05', '4152 Mauris Ave', '16560629 3', '(998) 295-6937', '45463', 'ipsum@Nulla.co.uk', 'Ap #816-4302 Vitae Road', '8048218714214', '78AAE12E-8FB2-F045-E0B8-B45BFF588899', '5095265636', 'Sodales Foundation'),
(90, 1, '61DA4283-1B77-DDAD-84B4-385E70036F86', 2, 'Branden G. Roberts', '2020-02-28', 'F24CCCAE-371E-1BF6-A625-A0EA7D465D33', '764727456805', '2020-09-03', 'P.O. Box 563, 405 Risus. Rd.', '16240123 4', '(775) 612-1837', '0579 ZC', 'lectus.convallis@ametloremsemper.co.uk', 'P.O. Box 579, 6615 Tincidunt, St.', '7871108758251', '4BCD26C0-AA8D-F93B-0529-CB90B847EC9F', '5592416981', 'Tincidunt Congue Industries'),
(91, 1, 'E306CED2-D348-92E6-4F4A-47C04E448154', 1, 'April Wallace', '2020-12-07', '59127252-975B-E602-C024-81C67CB5C5FA', '640039009037', '2021-09-23', 'Ap #338-6803 Ornare, Av.', '16400503 0', '(436) 358-9199', '83765', 'molestie.dapibus.ligula@ametfaucibusut.org', 'Ap #525-4734 Faucibus Ave', '1706061872150', '52EEE8B2-FE58-0F04-85FE-933314F7599B', '8789675259', 'Felis Purus Limited'),
(92, 1, 'C9A05E37-0BA4-4729-A9AD-ADCC5D273043', 1, 'September Carney', '2020-03-03', 'B233BDD5-C93D-343F-AF10-1C6C23782AF7', '953670097646', '2020-03-23', 'P.O. Box 439, 3637 Leo Ave', '16361128 6', '(517) 310-5777', '613909', 'amet.luctus.vulputate@ipsumdolorsit.org', '4282 Tempus Rd.', '3884913774987', '6C0D77DD-7E00-569B-632F-4F2655AF4154', '4097918494', 'Convallis Est Vitae LLC'),
(93, 1, '94C9EEBD-259B-4FDF-18BB-BF94F0320CAD', 2, 'Elijah Q. Clay', '2020-03-30', '529478FD-F53E-AEE8-5621-28B55125F0A3', '616318033534', '2021-10-24', '4282 Dignissim Rd.', '16200217 9', '(783) 299-1506', '641426', 'mollis.Duis@egestasascelerisque.edu', '767-723 Risus St.', '2472271503300', 'B994063F-A64E-29AA-A3E8-62175AA7FAA0', '6243326225', 'Enim Etiam LLC'),
(94, 1, 'CFC396A2-F299-1F33-571E-8AE4C791E943', 1, 'Gretchen X. Heath', '2021-07-14', 'B97C9725-3B95-73BD-01BB-68200E8684FC', '227796649128', '2022-01-16', '432-7613 Sit Ave', '16810524 6', '(878) 880-0588', '52876', 'dui.augue.eu@ipsumnonarcu.co.uk', '3528 Et Rd.', '5018076745063', '55A509A3-1D09-F63C-105E-6A99358ADEC1', '8849035272', 'Ullamcorper Corporation'),
(95, 1, 'D7B159D1-DB60-0F33-54DF-13CDD527A264', 1, 'Zelenia J. Boyle', '2021-08-18', '858530DE-C67F-A85B-2782-7C828CC0C5CA', '719071922548', '2021-08-30', 'Ap #880-5363 Auctor Ave', '16930319 9', '(576) 337-3399', '53563', 'et.commodo@mauris.net', 'Ap #764-8683 Est. Road', '1151382000889', '8A2B6AC6-391B-6D38-3068-3BC88989380A', '5881008541', 'Lorem Vitae Limited'),
(96, 1, '3B11B896-EF27-F4D3-0294-2BE199ED1E41', 1, 'Orlando R. Hopkins', '2021-04-30', 'F47A93D8-244A-9006-6CE4-1E07E37553E1', '321767751391', '2021-04-08', 'Ap #817-4165 Ac Avenue', '16381101 6', '(466) 852-4271', '739307', 'Vivamus.nibh@aptent.co.uk', '885-8324 Posuere Avenue', '6117516208782', 'B6A3CD4E-91B4-3001-0DC6-4F3EFAE87122', '1767331104', 'Luctus Lobortis Class LLC'),
(97, 1, 'BDB323F4-01A6-EDF0-B851-EAD93239344D', 2, 'Melissa Y. Cunningham', '2020-10-03', '7808E28F-5119-67BF-C67D-2FFB00F511F7', '984741049035', '2021-03-20', '9711 Convallis, St.', '16971027 1', '(159) 531-3243', '419819', 'id.enim@quispede.co.uk', 'Ap #253-1575 Aliquet Rd.', '9473759742597', '24BCFE41-35AC-6290-F02F-295535BF33BC', '2455842363', 'Egestas Duis Company'),
(98, 1, '920DC137-0623-34E2-8C9D-B4112C2DF495', 1, 'Yasir Mccarthy', '2020-07-11', 'BCBBF5BD-B16C-BE0D-E731-62737D09704D', '719921194753', '2020-12-02', '5935 Mauris Rd.', '16350724 8', '(759) 840-1549', '27531', 'egestas@magnis.org', 'Ap #192-1253 Elit. St.', '6382401776143', 'DD3EC23A-214F-F6D3-576D-F4E5B5E613F8', '6261940764', 'Neque Non Quam Consulting'),
(99, 1, '5FC1C18B-341F-975E-55C3-005A641F5A25', 1, 'Amy M. Buck', '2021-11-14', 'FE603AC9-18DB-9F44-D61E-4359C060BDB6', '370872655483', '2021-01-31', '650-305 Et, Road', '16870405 2', '(830) 432-5802', '13676', 'rutrum.urna@quamPellentesque.co.uk', 'Ap #844-900 Semper Rd.', '3151213810978', 'D7D93BDF-906E-6236-5464-AE9C25F0635C', '2966093057', 'Duis Ac Limited'),
(100, 1, '7404E4F9-A601-81B9-CADB-A9B92F65D03D', 1, 'Dylan O. Welch', '2020-07-14', '91C68A11-3F79-AD73-FE18-6423B7A2247D', '364732105826', '2021-07-16', '6175 Justo Street', '16570815 5', '(531) 402-3100', '5644 UG', 'ut.eros.non@quisturpis.com', 'P.O. Box 810, 7873 Suspendisse Rd.', '3978334482234', '6A56584D-2867-88C9-1EAD-F1549E24B427', '2925947791', 'Turpis Aliquam Limited');

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
(373, 1);

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
  ADD PRIMARY KEY (`locationId`);

--
-- Chỉ mục cho bảng `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`objectId`),
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
  MODIFY `objectId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

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
