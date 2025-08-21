-- -------------------------------------------------------------
-- TablePlus 6.2.1(578)
--
-- https://tableplus.com/
--
-- Database: cashier
-- Generation Time: 2025-08-20 17:01:44.7120
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `app_access`;
CREATE TABLE `app_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(60) DEFAULT NULL,
  `name` varchar(225) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `feature_id` int NOT NULL,
  `path_api` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`),
  CONSTRAINT `app_access_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `app_features` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `app_access_roles`;
CREATE TABLE `app_access_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `access_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `access_id` (`access_id`),
  CONSTRAINT `app_access_roles_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `app_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_access_roles_ibfk_2` FOREIGN KEY (`access_id`) REFERENCES `app_access` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `app_features`;
CREATE TABLE `app_features` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `parent_feature_id` int DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `app_menus`;
CREATE TABLE `app_menus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `feature_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `app_menus_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `app_features` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_menus_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `app_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `app_roles`;
CREATE TABLE `app_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `app_users`;
CREATE TABLE `app_users` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `passkey` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `failed_login_attempts` tinyint DEFAULT '0',
  `lock_until` timestamp NULL DEFAULT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `app_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `app_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `hst_product_store`;
CREATE TABLE `hst_product_store` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `product_id` binary(16) NOT NULL,
  `warehouse_id` int NOT NULL,
  `stock` int DEFAULT '0',
  `product_category_id` int NOT NULL,
  `status` enum('masuk','keluar') DEFAULT 'masuk',
  `description` text,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`),
  KEY `product_category_id` (`product_category_id`),
  CONSTRAINT `hst_product_store_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `ref_products` (`id`),
  CONSTRAINT `hst_product_store_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `ref_warehouses` (`id`),
  CONSTRAINT `hst_product_store_ibfk_3` FOREIGN KEY (`product_category_id`) REFERENCES `ref_product_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `hst_product_warehouse`;
CREATE TABLE `hst_product_warehouse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `product_id` binary(16) NOT NULL,
  `supplier_id` binary(16) NOT NULL,
  `stock` int NOT NULL,
  `product_category_id` int NOT NULL,
  `status` enum('in','out','return_to_supplier') DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `product_category_id` (`product_category_id`),
  KEY `product_id` (`product_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `hst_product_warehouse_ibfk_2` FOREIGN KEY (`product_category_id`) REFERENCES `ref_product_categories` (`id`),
  CONSTRAINT `hst_product_warehouse_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `ref_products` (`id`),
  CONSTRAINT `hst_product_warehouse_ibfk_4` FOREIGN KEY (`supplier_id`) REFERENCES `ref_suppliers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_customers`;
CREATE TABLE `ref_customers` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  `msisdn` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `identity_number` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_map_reason`;
CREATE TABLE `ref_map_reason` (
  `id` int NOT NULL,
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_payment_type`;
CREATE TABLE `ref_payment_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_product_brands`;
CREATE TABLE `ref_product_brands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_product_categories`;
CREATE TABLE `ref_product_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_product_stock_store`;
CREATE TABLE `ref_product_stock_store` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `product_id` binary(16) NOT NULL,
  `store_id` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL,
  `real_price_of_discount` decimal(10,2) DEFAULT NULL,
  `stock` int NOT NULL,
  `product_category_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `store_id` (`store_id`),
  KEY `product_category_id` (`product_category_id`),
  CONSTRAINT `ref_product_stock_store_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `ref_products` (`id`),
  CONSTRAINT `ref_product_stock_store_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `ref_stores` (`id`),
  CONSTRAINT `ref_product_stock_store_ibfk_3` FOREIGN KEY (`product_category_id`) REFERENCES `ref_product_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_product_stock_warehouse`;
CREATE TABLE `ref_product_stock_warehouse` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `product_id` binary(16) NOT NULL,
  `warehouse_id` int NOT NULL,
  `stock` int NOT NULL,
  `stock_volume` int DEFAULT '0',
  `product_category_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `warehouse_id` (`warehouse_id`),
  KEY `product_category_id` (`product_category_id`),
  CONSTRAINT `ref_product_stock_warehouse_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `ref_products` (`id`),
  CONSTRAINT `ref_product_stock_warehouse_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `ref_warehouses` (`id`),
  CONSTRAINT `ref_product_stock_warehouse_ibfk_3` FOREIGN KEY (`product_category_id`) REFERENCES `ref_product_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_product_types`;
CREATE TABLE `ref_product_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(225) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_products`;
CREATE TABLE `ref_products` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `sku_code` varchar(50) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `type_of_product` varchar(50) DEFAULT NULL,
  `brand_of_product` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_stores`;
CREATE TABLE `ref_stores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_suppliers`;
CREATE TABLE `ref_suppliers` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `address` text,
  `npwp` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `bank_account` varchar(50) DEFAULT NULL,
  `bank_account_number` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `ref_warehouses`;
CREATE TABLE `ref_warehouses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `trx_product_detail`;
CREATE TABLE `trx_product_detail` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `product_stock_store_id` binary(16) NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `store_id` int NOT NULL,
  `is_return` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_stock_store_id` (`product_stock_store_id`),
  KEY `store_id` (`store_id`),
  CONSTRAINT `trx_product_detail_ibfk_1` FOREIGN KEY (`product_stock_store_id`) REFERENCES `ref_product_stock_store` (`id`),
  CONSTRAINT `trx_product_detail_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `ref_stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `trx_products`;
CREATE TABLE `trx_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `trx_code` varchar(50) DEFAULT NULL,
  `customer_id` binary(16) DEFAULT NULL,
  `sub_total` decimal(10,2) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `payment_type_id` int NOT NULL,
  `status` enum('pesanan_awal','selesai','dikembalikan','dibatalkan') DEFAULT 'pesanan_awal',
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `payment_type_id` (`payment_type_id`),
  CONSTRAINT `trx_products_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `ref_customers` (`id`),
  CONSTRAINT `trx_products_ibfk_2` FOREIGN KEY (`payment_type_id`) REFERENCES `ref_payment_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `trx_shopping_carts`;
CREATE TABLE `trx_shopping_carts` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `product_stock_store_id` binary(16) NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `customer_id` binary(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_stock_store_id` (`product_stock_store_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `trx_shopping_carts_ibfk_1` FOREIGN KEY (`product_stock_store_id`) REFERENCES `ref_product_stock_store` (`id`),
  CONSTRAINT `trx_shopping_carts_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `ref_customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `trx_supplier_product`;
CREATE TABLE `trx_supplier_product` (
  `id` binary(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(255) DEFAULT NULL,
  `supplier_id` binary(16) NOT NULL,
  `trx_code` varchar(20) DEFAULT NULL,
  `sub_total` decimal(10,2) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `status` enum('pesanan','disetujui_oleh_supplier','pelunasan') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `trx_supplier_product_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `ref_suppliers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `trx_supplier_product_detail`;
CREATE TABLE `trx_supplier_product_detail` (
  `id` binary(16) NOT NULL,
  `created_by` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` varchar(255) DEFAULT NULL,
  `updated_by` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` varchar(255) DEFAULT NULL,
  `trx_suppliers_product_id` binary(16) NOT NULL,
  `quantity_order` int DEFAULT '0',
  `price` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `warehouse_id` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trx_suppliers_product_id` (`trx_suppliers_product_id`),
  CONSTRAINT `trx_supplier_product_detail_ibfk_1` FOREIGN KEY (`trx_suppliers_product_id`) REFERENCES `trx_supplier_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `app_access` (`id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `name`, `is_active`, `feature_id`, `path_api`) VALUES
(1, '2025-08-01 16:29:37', 'SYSTEM', '2025-08-01 16:29:37', 'SYSTEM', 'paging list', 1, 2, '/user/paging');

INSERT INTO `app_access_roles` (`id`, `role_id`, `access_id`) VALUES
(1, 1, 1);

INSERT INTO `app_features` (`id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `name`, `path`, `parent_feature_id`, `icon`, `is_active`) VALUES
(1, '2025-07-31 20:13:17', 'SYSTEM', '2025-07-31 20:13:17', 'SYSTEM', 'App Setting', NULL, NULL, NULL, 1),
(2, '2025-07-31 20:14:26', 'SYSTEM ', '2025-07-31 20:14:26', 'SYSTEM', 'User', '/app-setting/users', 1, 'user', 1);

INSERT INTO `app_menus` (`id`, `feature_id`, `role_id`) VALUES
(1, 1, 1),
(2, 2, 1);

INSERT INTO `app_roles` (`id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `name`, `description`) VALUES
(1, '2025-07-31 20:12:14', 'SYSTEM', '2025-07-31 20:12:14', 'SYSTEM', 'Admin', 'For administrator');

INSERT INTO `ref_map_reason` (`id`, `reason`) VALUES
(1, 'Return product karena product sudah kadaluarsa');

INSERT INTO `ref_payment_type` (`id`, `name`) VALUES
(1, 'Cash'),
(2, 'Transfer'),
(3, 'QIRIS');

INSERT INTO `ref_product_categories` (`id`, `name`, `description`) VALUES
(1, 'PCS', 'PCS adalah satuan barang'),
(2, '1/KG', '1/KG adalah product di jual dalam per KG'),
(3, 'BOX', 'Satuan barang dalam Box');

INSERT INTO `ref_product_types` (`id`, `name`) VALUES
(1, 'BARANG'),
(2, 'JASA'),
(3, 'RAKITAN');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;