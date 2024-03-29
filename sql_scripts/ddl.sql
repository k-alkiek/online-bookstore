-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------


  DROP schema LIBRARY_MANAGER;
-- Schema LIBRARY_MANAGER
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LIBRARY_MANAGER
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LIBRARY_MANAGER` DEFAULT CHARACTER SET utf8 ;
USE `LIBRARY_MANAGER` ;

-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`PUBLISHER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`PUBLISHER` (
  `Name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(150) NOT NULL,
  `telephone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`BOOK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`BOOK` (
  `ISBN` VARCHAR(17) NOT NULL,
  `title` VARCHAR(120) NOT NULL,
  `category` ENUM('Science', 'Art', 'Religion', 'History', 'Geography') NOT NULL,
  `selling_price` DECIMAL(10,2) NOT NULL,
  `Minimum_threshold` INT NOT NULL,
  `Available_copies_count` INT NOT NULL,
  `PUBLISHER_Name` VARCHAR(45) NOT NULL,
  `publish_year` DATE NOT NULL,
  INDEX `fk_BOOK_PUBLISHER1_idx` USING BTREE (`PUBLISHER_Name` ASC),
  INDEX `title_index` (`title` ASC),
  PRIMARY KEY (`ISBN`),
  CONSTRAINT `fk_BOOK_PUBLISHER1`
    FOREIGN KEY (`PUBLISHER_Name`)
    REFERENCES `LIBRARY_MANAGER`.`PUBLISHER` (`Name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`ORDER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`ORDER` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_submitted` DATE NOT NULL,
  `estimated_arrival_date` DATE NULL,
  `confirmed` TINYINT(1) NOT NULL DEFAULT 0,
  `BOOK_ISBN` VARCHAR(17) NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ORDER_BOOK_idx` (`BOOK_ISBN` ASC),
  CONSTRAINT `fk_ORDER_BOOK`
    FOREIGN KEY (`BOOK_ISBN`)
    REFERENCES `LIBRARY_MANAGER`.`BOOK` (`ISBN`)
    ON DELETE RESTRICT ON UPDATE CASCADE )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`User` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(120) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `address` VARCHAR(120) NOT NULL,
  `isManager` TINYINT(1) NOT NULL DEFAULT 0,
  `date_joined` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`PURCHASE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`PURCHASE` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `User_id` INT NOT NULL,
  `BOOK_ISBN` VARCHAR(17) NOT NULL,
  `No_of_copies` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `date_of_purchase` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_User_has_BOOK_BOOK1_idx` (`BOOK_ISBN` ASC),
  INDEX `fk_User_has_BOOK_User1_idx` (`User_id` ASC),
  CONSTRAINT `fk_User_has_BOOK_User1`
    FOREIGN KEY (`User_id`)
    REFERENCES `LIBRARY_MANAGER`.`User` (`id`)
    ON DELETE RESTRICT
ON UPDATE CASCADE ,
  CONSTRAINT `fk_User_has_BOOK_BOOK1`
    FOREIGN KEY (`BOOK_ISBN`)
    REFERENCES `LIBRARY_MANAGER`.`BOOK` (`ISBN`)
    ON DELETE RESTRICT
ON UPDATE CASCADE )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`AUTHOR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`AUTHOR` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Author_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LIBRARY_MANAGER`.`BOOK_AUTHOR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LIBRARY_MANAGER`.`BOOK_AUTHOR` (
  `BOOK_ISBN` VARCHAR(17) NOT NULL,
  `AUTHOR_id` INT NOT NULL,
  PRIMARY KEY (`BOOK_ISBN`, `AUTHOR_id`),
  INDEX `fk_BOOK_has_AUTHOR_AUTHOR1_idx` (`AUTHOR_id` ASC),
  INDEX `fk_BOOK_has_AUTHOR_BOOK1_idx` (`BOOK_ISBN` ASC),
  CONSTRAINT `fk_BOOK_has_AUTHOR_BOOK1`
    FOREIGN KEY (`BOOK_ISBN`)
    REFERENCES `LIBRARY_MANAGER`.`BOOK` (`ISBN`)
    ON DELETE CASCADE
    ON UPDATE CASCADE ,
  CONSTRAINT `fk_BOOK_has_AUTHOR_AUTHOR1`
    FOREIGN KEY (`AUTHOR_id`)
    REFERENCES `LIBRARY_MANAGER`.`AUTHOR` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE )
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
