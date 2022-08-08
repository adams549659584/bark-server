-- create devices table
CREATE TABLE IF NOT EXISTS `devices` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `key` VARCHAR(255) NOT NULL,    
    `token` VARCHAR(255) NOT NULL,
    `create_time` DATETIME(3) NOT NULL,
    PRIMARY KEY (`id`),          
    UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert devices
INSERT INTO `devices` (`key`,`token`,`create_time`) VALUES ('your key','your token', current_timestamp(3));


-- create markdown table
CREATE TABLE IF NOT EXISTS `markdown` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `key` VARCHAR(255) NOT NULL,    
    `content` VARCHAR(255) NOT NULL,
    `create_time` DATETIME(3) NOT NULL,
    PRIMARY KEY (`id`),          
    UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;     

-- insert markdown
INSERT INTO `markdown` (`key`,`content`,`create_time`) VALUES ('test','# Title \n > Text', current_timestamp(3));

-- query markdown by create_time
SELECT * FROM markdown WHERE create_time <= '2022-08-08 13:16:10.927';
-- DELETE markdown by create_time
DELETE FROM markdown WHERE create_time <= '2022-08-08 13:16:10.927';