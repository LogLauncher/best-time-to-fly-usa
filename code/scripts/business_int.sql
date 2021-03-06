-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 18, 2018 at 06:20 PM
-- Server version: 5.7.19
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `business_int`
--
CREATE DATABASE IF NOT EXISTS `business_int` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `business_int`;

-- --------------------------------------------------------

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
CREATE TABLE IF NOT EXISTS `airports` (
  `iata` varchar(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state_abbr` varchar(5) NOT NULL,
  `country` varchar(100) NOT NULL,
  `lat` decimal(15,10) NOT NULL,
  `longitude` decimal(15,10) NOT NULL,
  PRIMARY KEY (`iata`),
  KEY `iata` (`iata`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `date_state`
--

DROP TABLE IF EXISTS `date_state`;
CREATE TABLE IF NOT EXISTS `date_state` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `state_abbr` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `state_abbr` (`state_abbr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
CREATE TABLE IF NOT EXISTS `flights` (
  `departure_date` date NOT NULL,
  `arr_delay` int(11) NOT NULL,
  `dep_delay` int(11) NOT NULL,
  `origin` varchar(10) NOT NULL,
  `dest` varchar(10) NOT NULL,
  `weather_delay` int(11) NOT NULL,
  KEY `departure_date` (`departure_date`),
  KEY `dest` (`dest`),
  KEY `origin` (`origin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `flights_only_delay`
--

DROP TABLE IF EXISTS `flights_only_delay`;
CREATE TABLE IF NOT EXISTS `flights_only_delay` (
  `fk_date_state` int(11) DEFAULT NULL,
  `arr_delay` int(11) DEFAULT NULL,
  `dep_delay` int(11) DEFAULT NULL,
  `origin` varchar(5) DEFAULT NULL,
  `dest` varchar(5) DEFAULT NULL,
  `weather_delay` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
CREATE TABLE IF NOT EXISTS `states` (
  `name` varchar(100) NOT NULL,
  `abbr` varchar(5) NOT NULL,
  KEY `abbr` (`abbr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `storms`
--

DROP TABLE IF EXISTS `storms`;
CREATE TABLE IF NOT EXISTS `storms` (
  `state` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `state_abbr` varchar(50) NOT NULL,
  KEY `start_date` (`start_date`),
  KEY `end_date` (`end_date`),
  KEY `state_abbr` (`state_abbr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
