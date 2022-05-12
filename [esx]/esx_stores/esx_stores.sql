		CREATE TABLE IF NOT EXISTS `store_business` (
			`market_id` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
			`user_id` VARCHAR(50) NOT NULL,
			`stock` VARCHAR(50) NOT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
			`stock_upgrade` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
			`truck_upgrade` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
			`relationship_upgrade` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
			`money` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`total_money_earned` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`total_money_spent` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`goods_bought` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`distance_traveled` DOUBLE UNSIGNED NOT NULL DEFAULT '0',
			`total_visits` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`customers` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			PRIMARY KEY (`market_id`) USING BTREE
		)
		COLLATE='utf8mb4_general_ci'
		ENGINE=InnoDB
		;
		CREATE TABLE IF NOT EXISTS `store_balance` (
			`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
			`market_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
			`income` BIT(1) NOT NULL,
			`title` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
			`amount` INT(10) UNSIGNED NOT NULL,
			`date` INT(10) UNSIGNED NOT NULL,
			PRIMARY KEY (`id`) USING BTREE
		)
		COLLATE='utf8mb4_general_ci'
		ENGINE=InnoDB
		;
		CREATE TABLE IF NOT EXISTS `store_jobs` (
			`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
			`market_id` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
			`name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
			`reward` INT(10) UNSIGNED NOT NULL DEFAULT '0',
			`product` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
			`amount` INT(11) NOT NULL DEFAULT '0',
			`progress` BIT(1) NOT NULL DEFAULT b'0',
			PRIMARY KEY (`id`) USING BTREE
		)
		COLLATE='utf8mb4_general_ci'
		ENGINE=InnoDB
		;