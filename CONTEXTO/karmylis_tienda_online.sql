-- karmylis_tienda_online.sql
-- Subconjunto de la base de datos para la tienda online de Karmylis.

CREATE DATABASE IF NOT EXISTS karmylis_tienda_online
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE karmylis_tienda_online;

-- 1. Base (Empresas y Clientes)
CREATE TABLE IF NOT EXISTS empresas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(32) NOT NULL,
  nombre_comercial VARCHAR(180) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS clientes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  nombre_completo VARCHAR(180) NOT NULL,
  email VARCHAR(190) NULL,
  telefono VARCHAR(40) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  CONSTRAINT fk_clientes_empresa FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

-- 2. Catálogo Básico
CREATE TABLE IF NOT EXISTS marcas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  CONSTRAINT fk_marcas_empresa FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categorias (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  categoria_padre_id BIGINT UNSIGNED NULL,
  nombre VARCHAR(120) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  CONSTRAINT fk_categorias_empresa FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_categorias_padre FOREIGN KEY (empresa_id, categoria_padre_id) REFERENCES categorias (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  marca_id BIGINT UNSIGNED NULL,
  codigo_referencia VARCHAR(80) NOT NULL,
  nombre VARCHAR(180) NOT NULL,
  descripcion TEXT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  CONSTRAINT fk_productos_empresa FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_productos_marca FOREIGN KEY (empresa_id, marca_id) REFERENCES marcas (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_categorias (
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  categoria_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, producto_id, categoria_id),
  CONSTRAINT fk_prodcat_producto FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_prodcat_categoria FOREIGN KEY (empresa_id, categoria_id) REFERENCES categorias (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS variantes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  sku VARCHAR(100) NOT NULL,
  nombre_variante VARCHAR(180) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  CONSTRAINT fk_variantes_producto FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_imagenes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  url VARCHAR(500) NOT NULL,
  es_principal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT fk_imagenes_producto FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_imagenes_variante FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_precios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  precio_venta DECIMAL(19,4) NOT NULL,
  vigente_desde DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  CONSTRAINT fk_precios_producto FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_precios_variante FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id)
) ENGINE=InnoDB;
