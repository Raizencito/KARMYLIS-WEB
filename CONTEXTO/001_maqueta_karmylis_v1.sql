-- Maqueta exploratoria de base de datos para Karmylis ERP / futuro SaaS.
-- Objetivo: MySQL 8.4 LTS, InnoDB, utf8mb4, timestamps UTC.
-- Estado: V1 para revisión del dominio; no es todavía una migración de producción.

CREATE DATABASE IF NOT EXISTS karmylis_erp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE karmylis_erp;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- -----------------------------------------------------------------------------
-- 1. Organización, configuración y acceso
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS empresas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(32) NOT NULL,
  razon_social VARCHAR(180) NOT NULL,
  nombre_comercial VARCHAR(180) NOT NULL,
  nit VARCHAR(32) NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  zona_horaria VARCHAR(64) NOT NULL DEFAULT 'America/La_Paz',
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_empresas_codigo (codigo),
  CONSTRAINT ck_empresas_estado CHECK (estado IN ('ACTIVA', 'SUSPENDIDA', 'INACTIVA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS empresa_configuraciones (
  empresa_id BIGINT UNSIGNED NOT NULL,
  clave VARCHAR(100) NOT NULL,
  valor JSON NOT NULL,
  descripcion VARCHAR(255) NULL,
  updated_by BIGINT UNSIGNED NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (empresa_id, clave),
  CONSTRAINT fk_empconf_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ubicaciones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  ubicacion_padre_id BIGINT UNSIGNED NULL,
  codigo VARCHAR(32) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  direccion VARCHAR(255) NULL,
  es_stockeable TINYINT(1) NOT NULL DEFAULT 1,
  es_punto_venta TINYINT(1) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_ubicaciones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_ubicaciones_codigo (empresa_id, codigo),
  KEY ix_ubicaciones_padre (empresa_id, ubicacion_padre_id),
  CONSTRAINT fk_ubicaciones_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_ubicaciones_padre
    FOREIGN KEY (empresa_id, ubicacion_padre_id)
    REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT ck_ubicaciones_tipo CHECK (
    tipo IN ('SUCURSAL', 'ALMACEN', 'PISO_VENTA', 'DEPOSITO', 'DESPACHO')
  ),
  CONSTRAINT ck_ubicaciones_estado CHECK (estado IN ('ACTIVA', 'INACTIVA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS canales_venta (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_canales_empresa_id (empresa_id, id),
  UNIQUE KEY uq_canales_codigo (empresa_id, codigo),
  CONSTRAINT fk_canales_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT ck_canales_tipo CHECK (tipo IN ('POS', 'WEB', 'MARKETPLACE', 'OTRO')),
  CONSTRAINT ck_canales_estado CHECK (estado IN ('ACTIVO', 'INACTIVO'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  username VARCHAR(80) NOT NULL,
  email VARCHAR(190) NULL,
  password_hash VARCHAR(255) NOT NULL,
  nombres VARCHAR(120) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  ultimo_acceso_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_empresa_id (empresa_id, id),
  UNIQUE KEY uq_usuarios_username (empresa_id, username),
  UNIQUE KEY uq_usuarios_email (empresa_id, email),
  CONSTRAINT fk_usuarios_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT ck_usuarios_estado CHECK (estado IN ('ACTIVO', 'BLOQUEADO', 'INACTIVO'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS roles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  PRIMARY KEY (id),
  UNIQUE KEY uq_roles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_roles_codigo (empresa_id, codigo),
  CONSTRAINT fk_roles_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS permisos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_permisos_codigo (codigo)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS usuario_roles (
  empresa_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NOT NULL,
  rol_id BIGINT UNSIGNED NOT NULL,
  asignado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (empresa_id, usuario_id, rol_id),
  CONSTRAINT fk_usuario_roles_usuario
    FOREIGN KEY (empresa_id, usuario_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_usuario_roles_rol
    FOREIGN KEY (empresa_id, rol_id) REFERENCES roles (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS rol_permisos (
  empresa_id BIGINT UNSIGNED NOT NULL,
  rol_id BIGINT UNSIGNED NOT NULL,
  permiso_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, rol_id, permiso_id),
  CONSTRAINT fk_rol_permisos_rol
    FOREIGN KEY (empresa_id, rol_id) REFERENCES roles (empresa_id, id),
  CONSTRAINT fk_rol_permisos_permiso
    FOREIGN KEY (permiso_id) REFERENCES permisos (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS usuario_ubicaciones (
  empresa_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  es_principal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (empresa_id, usuario_id, ubicacion_id),
  CONSTRAINT fk_usuario_ubicaciones_usuario
    FOREIGN KEY (empresa_id, usuario_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_usuario_ubicaciones_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS clientes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NULL,
  nombre_completo VARCHAR(180) NOT NULL,
  documento VARCHAR(40) NULL,
  telefono VARCHAR(40) NULL,
  email VARCHAR(190) NULL,
  notas TEXT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_clientes_empresa_id (empresa_id, id),
  UNIQUE KEY uq_clientes_codigo (empresa_id, codigo),
  KEY ix_clientes_telefono (empresa_id, telefono),
  CONSTRAINT fk_clientes_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 2. Catálogo configurable: producto, variante, atributos y publicación
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS marcas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  UNIQUE KEY uq_marcas_empresa_id (empresa_id, id),
  UNIQUE KEY uq_marcas_nombre (empresa_id, nombre),
  CONSTRAINT fk_marcas_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS proveedores (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NULL,
  nombre VARCHAR(180) NOT NULL,
  nit_documento VARCHAR(40) NULL,
  telefono VARCHAR(40) NULL,
  email VARCHAR(190) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_proveedores_empresa_id (empresa_id, id),
  UNIQUE KEY uq_proveedores_codigo (empresa_id, codigo),
  CONSTRAINT fk_proveedores_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categorias (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  categoria_padre_id BIGINT UNSIGNED NULL,
  codigo VARCHAR(40) NULL,
  nombre VARCHAR(120) NOT NULL,
  descripcion VARCHAR(255) NULL,
  orden SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_categorias_empresa_id (empresa_id, id),
  UNIQUE KEY uq_categorias_codigo (empresa_id, codigo),
  KEY ix_categorias_padre (empresa_id, categoria_padre_id),
  CONSTRAINT fk_categorias_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_categorias_padre
    FOREIGN KEY (empresa_id, categoria_padre_id)
    REFERENCES categorias (empresa_id, id),
  CONSTRAINT ck_categorias_estado CHECK (estado IN ('ACTIVA', 'INACTIVA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  marca_id BIGINT UNSIGNED NULL,
  codigo_referencia VARCHAR(80) NOT NULL,
  codigo_interno VARCHAR(80) NOT NULL,
  nombre VARCHAR(180) NOT NULL,
  descripcion TEXT NULL,
  modo_inventario VARCHAR(20) NOT NULL DEFAULT 'SERIALIZADO',
  unidad_medida VARCHAR(20) NOT NULL DEFAULT 'UNIDAD',
  datos_adicionales JSON NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  created_by BIGINT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_productos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_productos_codigo_interno (empresa_id, codigo_interno),
  KEY ix_productos_referencia (empresa_id, codigo_referencia),
  KEY ix_productos_nombre (empresa_id, nombre),
  CONSTRAINT fk_productos_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_productos_marca
    FOREIGN KEY (empresa_id, marca_id) REFERENCES marcas (empresa_id, id),
  CONSTRAINT fk_productos_creador
    FOREIGN KEY (empresa_id, created_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_productos_modo CHECK (modo_inventario IN ('SERIALIZADO', 'CANTIDAD')),
  CONSTRAINT ck_productos_estado CHECK (estado IN ('BORRADOR', 'ACTIVO', 'INACTIVO'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_categorias (
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  categoria_id BIGINT UNSIGNED NOT NULL,
  es_principal TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (empresa_id, producto_id, categoria_id),
  CONSTRAINT fk_producto_categorias_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_producto_categorias_categoria
    FOREIGN KEY (empresa_id, categoria_id) REFERENCES categorias (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS atributos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  tipo_dato VARCHAR(20) NOT NULL,
  genera_variante TINYINT(1) NOT NULL DEFAULT 1,
  es_filtrable TINYINT(1) NOT NULL DEFAULT 1,
  es_requerido TINYINT(1) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  PRIMARY KEY (id),
  UNIQUE KEY uq_atributos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_atributos_codigo (empresa_id, codigo),
  CONSTRAINT fk_atributos_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT ck_atributos_tipo CHECK (
    tipo_dato IN ('OPCION', 'TEXTO', 'NUMERO', 'BOOLEANO', 'FECHA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS atributo_opciones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  atributo_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  valor VARCHAR(120) NOT NULL,
  orden SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  UNIQUE KEY uq_atributo_opciones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_atributo_opciones_codigo (empresa_id, atributo_id, codigo),
  CONSTRAINT fk_atributo_opciones_atributo
    FOREIGN KEY (empresa_id, atributo_id) REFERENCES atributos (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_atributos (
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  atributo_id BIGINT UNSIGNED NOT NULL,
  es_requerido TINYINT(1) NOT NULL DEFAULT 0,
  orden SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (empresa_id, producto_id, atributo_id),
  CONSTRAINT fk_producto_atributos_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_producto_atributos_atributo
    FOREIGN KEY (empresa_id, atributo_id) REFERENCES atributos (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS variantes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  sku VARCHAR(100) NOT NULL,
  codigo_barras VARCHAR(128) NULL,
  nombre_variante VARCHAR(180) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_variantes_empresa_id (empresa_id, id),
  UNIQUE KEY uq_variantes_sku (empresa_id, sku),
  UNIQUE KEY uq_variantes_barcode (empresa_id, codigo_barras),
  KEY ix_variantes_producto (empresa_id, producto_id),
  CONSTRAINT fk_variantes_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT ck_variantes_estado CHECK (estado IN ('ACTIVA', 'INACTIVA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS variante_atributos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NOT NULL,
  atributo_id BIGINT UNSIGNED NOT NULL,
  opcion_id BIGINT UNSIGNED NULL,
  valor_texto VARCHAR(255) NULL,
  valor_numero DECIMAL(18,4) NULL,
  valor_booleano TINYINT(1) NULL,
  valor_fecha DATE NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_variante_atributos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_variante_atributos_atributo (empresa_id, variante_id, atributo_id),
  CONSTRAINT fk_variante_atributos_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_variante_atributos_atributo
    FOREIGN KEY (empresa_id, atributo_id) REFERENCES atributos (empresa_id, id),
  CONSTRAINT fk_variante_atributos_opcion
    FOREIGN KEY (empresa_id, opcion_id) REFERENCES atributo_opciones (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_imagenes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  url VARCHAR(500) NOT NULL,
  texto_alternativo VARCHAR(255) NULL,
  orden SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  es_principal TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_producto_imagenes_empresa_id (empresa_id, id),
  KEY ix_producto_imagenes_producto (empresa_id, producto_id, orden),
  CONSTRAINT fk_producto_imagenes_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_producto_imagenes_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_canales (
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  canal_id BIGINT UNSIGNED NOT NULL,
  publicado TINYINT(1) NOT NULL DEFAULT 0,
  titulo_publico VARCHAR(180) NULL,
  descripcion_publica TEXT NULL,
  publicado_at DATETIME(6) NULL,
  PRIMARY KEY (empresa_id, producto_id, canal_id),
  CONSTRAINT fk_producto_canales_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_producto_canales_canal
    FOREIGN KEY (empresa_id, canal_id) REFERENCES canales_venta (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto_precios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  ubicacion_id BIGINT UNSIGNED NULL,
  canal_id BIGINT UNSIGNED NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  precio_venta DECIMAL(19,4) NOT NULL,
  precio_minimo DECIMAL(19,4) NULL,
  vigente_desde DATETIME(6) NOT NULL,
  vigente_hasta DATETIME(6) NULL,
  motivo VARCHAR(255) NULL,
  created_by BIGINT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_producto_precios_empresa_id (empresa_id, id),
  KEY ix_producto_precios_vigencia
    (empresa_id, producto_id, variante_id, vigente_desde, vigente_hasta),
  CONSTRAINT fk_producto_precios_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_producto_precios_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_producto_precios_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_producto_precios_canal
    FOREIGN KEY (empresa_id, canal_id) REFERENCES canales_venta (empresa_id, id),
  CONSTRAINT fk_producto_precios_creador
    FOREIGN KEY (empresa_id, created_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_producto_precios_venta CHECK (precio_venta >= 0),
  CONSTRAINT ck_producto_precios_minimo CHECK (
    precio_minimo IS NULL OR (precio_minimo >= 0 AND precio_minimo <= precio_venta)
  ),
  CONSTRAINT ck_producto_precios_vigencia CHECK (
    vigente_hasta IS NULL OR vigente_hasta > vigente_desde
  )
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. Abastecimiento, inventario híbrido, traslados y conteos físicos
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ingresos_mercaderia (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NOT NULL,
  fecha_recepcion DATETIME(6) NOT NULL,
  ubicacion_recepcion_id BIGINT UNSIGNED NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  observaciones TEXT NULL,
  created_by BIGINT UNSIGNED NOT NULL,
  cerrado_by BIGINT UNSIGNED NULL,
  cerrado_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_ingresos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_ingresos_codigo (empresa_id, codigo),
  KEY ix_ingresos_fecha (empresa_id, fecha_recepcion),
  CONSTRAINT fk_ingresos_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_ingresos_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_recepcion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_ingresos_creador
    FOREIGN KEY (empresa_id, created_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_ingresos_cerrador
    FOREIGN KEY (empresa_id, cerrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_ingresos_estado CHECK (
    estado IN ('BORRADOR', 'EN_PROCESO', 'CERRADO', 'CANCELADO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ingreso_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  ingreso_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  proveedor_id BIGINT UNSIGNED NULL,
  cantidad DECIMAL(18,4) NOT NULL,
  costo_unitario DECIMAL(19,4) NOT NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  referencia_proveedor VARCHAR(100) NULL,
  notas VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ingreso_detalles_empresa_id (empresa_id, id),
  KEY ix_ingreso_detalles_ingreso (empresa_id, ingreso_id),
  CONSTRAINT fk_ingreso_detalles_ingreso
    FOREIGN KEY (empresa_id, ingreso_id) REFERENCES ingresos_mercaderia (empresa_id, id),
  CONSTRAINT fk_ingreso_detalles_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_ingreso_detalles_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_ingreso_detalles_proveedor
    FOREIGN KEY (empresa_id, proveedor_id) REFERENCES proveedores (empresa_id, id),
  CONSTRAINT ck_ingreso_detalles_cantidad CHECK (cantidad > 0),
  CONSTRAINT ck_ingreso_detalles_costo CHECK (costo_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ingreso_distribuciones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  ingreso_detalle_id BIGINT UNSIGNED NOT NULL,
  ubicacion_destino_id BIGINT UNSIGNED NOT NULL,
  cantidad_planificada DECIMAL(18,4) NOT NULL,
  cantidad_recibida DECIMAL(18,4) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
  recibido_by BIGINT UNSIGNED NULL,
  recibido_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ingreso_distribuciones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_ingreso_distribuciones_destino
    (empresa_id, ingreso_detalle_id, ubicacion_destino_id),
  CONSTRAINT fk_ingreso_distribuciones_detalle
    FOREIGN KEY (empresa_id, ingreso_detalle_id) REFERENCES ingreso_detalles (empresa_id, id),
  CONSTRAINT fk_ingreso_distribuciones_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_destino_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_ingreso_distribuciones_receptor
    FOREIGN KEY (empresa_id, recibido_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_ingreso_distribuciones_plan CHECK (cantidad_planificada > 0),
  CONSTRAINT ck_ingreso_distribuciones_recibida CHECK (cantidad_recibida >= 0),
  CONSTRAINT ck_ingreso_distribuciones_estado CHECK (
    estado IN ('PENDIENTE', 'ENVIADA', 'PARCIAL', 'RECIBIDA', 'CANCELADA')
  )
) ENGINE=InnoDB;

-- Sólo se crean filas aquí para productos serializados. La variante puede quedar
-- temporalmente NULL hasta que la sucursal/despacho complete color, talla, etc.
CREATE TABLE IF NOT EXISTS unidades_inventario (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  ingreso_detalle_id BIGINT UNSIGNED NULL,
  ubicacion_actual_id BIGINT UNSIGNED NULL,
  codigo_serial VARCHAR(120) NOT NULL,
  codigo_barras VARCHAR(128) NOT NULL,
  estado VARCHAR(30) NOT NULL DEFAULT 'BORRADOR',
  costo_origen DECIMAL(19,4) NULL,
  caracterizada_at DATETIME(6) NULL,
  version_lock BIGINT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_unidades_empresa_id (empresa_id, id),
  UNIQUE KEY uq_unidades_serial (empresa_id, codigo_serial),
  UNIQUE KEY uq_unidades_barcode (empresa_id, codigo_barras),
  KEY ix_unidades_disponibilidad
    (empresa_id, ubicacion_actual_id, estado, variante_id),
  KEY ix_unidades_producto (empresa_id, producto_id),
  CONSTRAINT fk_unidades_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_unidades_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_unidades_ingreso
    FOREIGN KEY (empresa_id, ingreso_detalle_id) REFERENCES ingreso_detalles (empresa_id, id),
  CONSTRAINT fk_unidades_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_actual_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT ck_unidades_estado CHECK (
    estado IN (
      'BORRADOR', 'DISPONIBLE', 'RESERVADA', 'EN_TRANSITO', 'VENDIDA',
      'DEVUELTA_INSPECCION', 'DANADA', 'BAJA'
    )
  ),
  CONSTRAINT ck_unidades_costo CHECK (costo_origen IS NULL OR costo_origen >= 0)
) ENGINE=InnoDB;

-- Fuente autoritativa sólo para productos controlados por cantidad.
CREATE TABLE IF NOT EXISTS inventario_saldos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NOT NULL,
  cantidad_fisica DECIMAL(18,4) NOT NULL DEFAULT 0,
  cantidad_reservada DECIMAL(18,4) NOT NULL DEFAULT 0,
  cantidad_comprometida DECIMAL(18,4) NOT NULL DEFAULT 0,
  cantidad_disponible DECIMAL(18,4)
    GENERATED ALWAYS AS (
      cantidad_fisica - cantidad_reservada - cantidad_comprometida
    ) STORED,
  version_lock BIGINT UNSIGNED NOT NULL DEFAULT 0,
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_inventario_saldos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_inventario_saldos_posicion (empresa_id, ubicacion_id, variante_id),
  KEY ix_inventario_saldos_disponible
    (empresa_id, ubicacion_id, cantidad_disponible),
  CONSTRAINT fk_inventario_saldos_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_inventario_saldos_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT ck_inventario_saldos_fisica CHECK (cantidad_fisica >= 0),
  CONSTRAINT ck_inventario_saldos_reservada CHECK (cantidad_reservada >= 0),
  CONSTRAINT ck_inventario_saldos_comprometida CHECK (cantidad_comprometida >= 0),
  CONSTRAINT ck_inventario_saldos_disponible CHECK (cantidad_disponible >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS movimientos_inventario (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  ubicacion_origen_id BIGINT UNSIGNED NULL,
  ubicacion_destino_id BIGINT UNSIGNED NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  motivo VARCHAR(500) NULL,
  origen_entidad VARCHAR(50) NULL,
  origen_id BIGINT UNSIGNED NULL,
  solicitado_by BIGINT UNSIGNED NOT NULL,
  aprobado_by BIGINT UNSIGNED NULL,
  ocurrido_at DATETIME(6) NOT NULL,
  aplicado_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_movimientos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_movimientos_codigo (empresa_id, codigo),
  KEY ix_movimientos_fecha (empresa_id, ocurrido_at, tipo),
  KEY ix_movimientos_origen (empresa_id, origen_entidad, origen_id),
  CONSTRAINT fk_movimientos_origen_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_origen_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_movimientos_destino_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_destino_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_movimientos_solicitante
    FOREIGN KEY (empresa_id, solicitado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_movimientos_aprobador
    FOREIGN KEY (empresa_id, aprobado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_movimientos_tipo CHECK (
    tipo IN (
      'INGRESO', 'ASIGNACION', 'TRASLADO_SALIDA', 'TRASLADO_ENTRADA',
      'RESERVA', 'LIBERACION_RESERVA', 'VENTA', 'ANULACION',
      'DEVOLUCION', 'AJUSTE_POSITIVO', 'AJUSTE_NEGATIVO', 'BAJA'
    )
  ),
  CONSTRAINT ck_movimientos_estado CHECK (
    estado IN ('BORRADOR', 'APROBADO', 'APLICADO', 'CANCELADO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS movimiento_inventario_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  movimiento_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  unidad_id BIGINT UNSIGNED NULL,
  cantidad DECIMAL(18,4) NOT NULL,
  costo_unitario_snapshot DECIMAL(19,4) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_mov_detalles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_mov_detalles_unidad (empresa_id, movimiento_id, unidad_id),
  KEY ix_mov_detalles_variante (empresa_id, variante_id),
  CONSTRAINT fk_mov_detalles_movimiento
    FOREIGN KEY (empresa_id, movimiento_id) REFERENCES movimientos_inventario (empresa_id, id),
  CONSTRAINT fk_mov_detalles_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_mov_detalles_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_mov_detalles_unidad
    FOREIGN KEY (empresa_id, unidad_id) REFERENCES unidades_inventario (empresa_id, id),
  CONSTRAINT ck_mov_detalles_cantidad CHECK (cantidad > 0),
  CONSTRAINT ck_mov_detalles_costo CHECK (
    costo_unitario_snapshot IS NULL OR costo_unitario_snapshot >= 0
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS traslados (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  ubicacion_origen_id BIGINT UNSIGNED NOT NULL,
  ubicacion_destino_id BIGINT UNSIGNED NOT NULL,
  tipo VARCHAR(25) NOT NULL DEFAULT 'REASIGNACION',
  estado VARCHAR(20) NOT NULL DEFAULT 'SOLICITADO',
  motivo VARCHAR(500) NULL,
  solicitado_by BIGINT UNSIGNED NOT NULL,
  aprobado_by BIGINT UNSIGNED NULL,
  enviado_by BIGINT UNSIGNED NULL,
  recibido_by BIGINT UNSIGNED NULL,
  solicitado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  aprobado_at DATETIME(6) NULL,
  enviado_at DATETIME(6) NULL,
  recibido_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_traslados_empresa_id (empresa_id, id),
  UNIQUE KEY uq_traslados_codigo (empresa_id, codigo),
  KEY ix_traslados_estado (empresa_id, estado, solicitado_at),
  CONSTRAINT fk_traslados_origen
    FOREIGN KEY (empresa_id, ubicacion_origen_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_traslados_destino
    FOREIGN KEY (empresa_id, ubicacion_destino_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_traslados_solicitante
    FOREIGN KEY (empresa_id, solicitado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_traslados_aprobador
    FOREIGN KEY (empresa_id, aprobado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_traslados_emisor
    FOREIGN KEY (empresa_id, enviado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_traslados_receptor
    FOREIGN KEY (empresa_id, recibido_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_traslados_tipo CHECK (tipo IN ('VENTA_EXCEPCIONAL', 'REASIGNACION')),
  CONSTRAINT ck_traslados_estado CHECK (
    estado IN ('SOLICITADO', 'APROBADO', 'ENVIADO', 'RECIBIDO', 'RECHAZADO', 'CANCELADO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS traslado_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  traslado_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NULL,
  unidad_id BIGINT UNSIGNED NULL,
  cantidad DECIMAL(18,4) NOT NULL,
  cantidad_recibida DECIMAL(18,4) NOT NULL DEFAULT 0,
  observacion_recepcion VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_traslado_detalles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_traslado_detalles_unidad (empresa_id, traslado_id, unidad_id),
  CONSTRAINT fk_traslado_detalles_traslado
    FOREIGN KEY (empresa_id, traslado_id) REFERENCES traslados (empresa_id, id),
  CONSTRAINT fk_traslado_detalles_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_traslado_detalles_unidad
    FOREIGN KEY (empresa_id, unidad_id) REFERENCES unidades_inventario (empresa_id, id),
  CONSTRAINT ck_traslado_detalles_cantidad CHECK (cantidad > 0),
  CONSTRAINT ck_traslado_detalles_recibida CHECK (cantidad_recibida >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS conteos_inventario (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTO',
  iniciado_by BIGINT UNSIGNED NOT NULL,
  cerrado_by BIGINT UNSIGNED NULL,
  iniciado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  cerrado_at DATETIME(6) NULL,
  notas TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_conteos_empresa_id (empresa_id, id),
  UNIQUE KEY uq_conteos_codigo (empresa_id, codigo),
  KEY ix_conteos_abiertos (empresa_id, ubicacion_id, estado),
  CONSTRAINT fk_conteos_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_conteos_iniciador
    FOREIGN KEY (empresa_id, iniciado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_conteos_cerrador
    FOREIGN KEY (empresa_id, cerrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_conteos_estado CHECK (
    estado IN ('ABIERTO', 'CONCILIANDO', 'CERRADO', 'CANCELADO')
  )
) ENGINE=InnoDB;

-- Una fila por unidad esperada o encontrada. La restricción única es la que
-- permite rechazar inmediatamente un segundo escaneo de la misma prenda.
CREATE TABLE IF NOT EXISTS conteo_unidades (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  conteo_id BIGINT UNSIGNED NOT NULL,
  unidad_id BIGINT UNSIGNED NOT NULL,
  esperada_inicialmente TINYINT(1) NOT NULL DEFAULT 1,
  escaneada TINYINT(1) NOT NULL DEFAULT 0,
  escaneada_by BIGINT UNSIGNED NULL,
  escaneada_at DATETIME(6) NULL,
  resultado VARCHAR(25) NOT NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (id),
  UNIQUE KEY uq_conteo_unidades_empresa_id (empresa_id, id),
  UNIQUE KEY uq_conteo_unidades_unidad (empresa_id, conteo_id, unidad_id),
  CONSTRAINT fk_conteo_unidades_conteo
    FOREIGN KEY (empresa_id, conteo_id) REFERENCES conteos_inventario (empresa_id, id),
  CONSTRAINT fk_conteo_unidades_unidad
    FOREIGN KEY (empresa_id, unidad_id) REFERENCES unidades_inventario (empresa_id, id),
  CONSTRAINT fk_conteo_unidades_usuario
    FOREIGN KEY (empresa_id, escaneada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_conteo_unidades_resultado CHECK (
    resultado IN ('PENDIENTE', 'ENCONTRADA', 'FALTANTE', 'SOBRANTE', 'MOVIDA_DURANTE_CONTEO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS conteo_cantidades (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  conteo_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NOT NULL,
  cantidad_esperada_inicial DECIMAL(18,4) NOT NULL,
  cantidad_contada DECIMAL(18,4) NOT NULL DEFAULT 0,
  cantidad_movida_durante DECIMAL(18,4) NOT NULL DEFAULT 0,
  diferencia DECIMAL(18,4)
    GENERATED ALWAYS AS (
      cantidad_contada + cantidad_movida_durante - cantidad_esperada_inicial
    ) STORED,
  contado_by BIGINT UNSIGNED NULL,
  contado_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_conteo_cantidades_empresa_id (empresa_id, id),
  UNIQUE KEY uq_conteo_cantidades_variante (empresa_id, conteo_id, variante_id),
  CONSTRAINT fk_conteo_cantidades_conteo
    FOREIGN KEY (empresa_id, conteo_id) REFERENCES conteos_inventario (empresa_id, id),
  CONSTRAINT fk_conteo_cantidades_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_conteo_cantidades_usuario
    FOREIGN KEY (empresa_id, contado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_conteo_cantidades_esperada CHECK (cantidad_esperada_inicial >= 0),
  CONSTRAINT ck_conteo_cantidades_contada CHECK (cantidad_contada >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 4. Caja, ventas, reservas con cuotas, devoluciones y promociones
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS metodos_pago (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  tipo VARCHAR(25) NOT NULL,
  afecta_efectivo TINYINT(1) NOT NULL DEFAULT 0,
  permite_cambio TINYINT(1) NOT NULL DEFAULT 0,
  requiere_referencia TINYINT(1) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  PRIMARY KEY (id),
  UNIQUE KEY uq_metodos_pago_empresa_id (empresa_id, id),
  UNIQUE KEY uq_metodos_pago_codigo (empresa_id, codigo),
  CONSTRAINT fk_metodos_pago_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT ck_metodos_pago_tipo CHECK (
    tipo IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'QR', 'GIFT_CARD', 'OTRO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cuentas_cobro (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  metodo_pago_id BIGINT UNSIGNED NOT NULL,
  usuario_responsable_id BIGINT UNSIGNED NULL,
  nombre VARCHAR(120) NOT NULL,
  entidad_financiera VARCHAR(120) NULL,
  identificador_enmascarado VARCHAR(120) NULL,
  es_cuenta_empresa TINYINT(1) NOT NULL DEFAULT 1,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (id),
  UNIQUE KEY uq_cuentas_cobro_empresa_id (empresa_id, id),
  CONSTRAINT fk_cuentas_cobro_metodo
    FOREIGN KEY (empresa_id, metodo_pago_id) REFERENCES metodos_pago (empresa_id, id),
  CONSTRAINT fk_cuentas_cobro_usuario
    FOREIGN KEY (empresa_id, usuario_responsable_id) REFERENCES usuarios (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tipos_gasto (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  requiere_comprobante TINYINT(1) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  PRIMARY KEY (id),
  UNIQUE KEY uq_tipos_gasto_empresa_id (empresa_id, id),
  UNIQUE KEY uq_tipos_gasto_codigo (empresa_id, codigo),
  CONSTRAINT fk_tipos_gasto_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cajas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(40) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_cajas_empresa_id (empresa_id, id),
  UNIQUE KEY uq_cajas_codigo (empresa_id, ubicacion_id, codigo),
  CONSTRAINT fk_cajas_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT ck_cajas_estado CHECK (estado IN ('ACTIVA', 'INACTIVA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sesiones_caja (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  caja_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NOT NULL,
  fondo_inicial DECIMAL(19,4) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTA',
  caja_abierta_id BIGINT UNSIGNED
    GENERATED ALWAYS AS (IF(estado = 'ABIERTA', caja_id, NULL)) STORED,
  abierta_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  cerrada_at DATETIME(6) NULL,
  observaciones VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sesiones_caja_empresa_id (empresa_id, id),
  UNIQUE KEY uq_sesiones_caja_una_abierta (empresa_id, caja_abierta_id),
  KEY ix_sesiones_caja_usuario (empresa_id, usuario_id, abierta_at),
  CONSTRAINT fk_sesiones_caja_caja
    FOREIGN KEY (empresa_id, caja_id) REFERENCES cajas (empresa_id, id),
  CONSTRAINT fk_sesiones_caja_usuario
    FOREIGN KEY (empresa_id, usuario_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_sesiones_caja_fondo CHECK (fondo_inicial >= 0),
  CONSTRAINT ck_sesiones_caja_estado CHECK (estado IN ('ABIERTA', 'EN_CIERRE', 'CERRADA', 'ANULADA'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cierres_caja (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  sesion_caja_id BIGINT UNSIGNED NOT NULL,
  tipo VARCHAR(20) NOT NULL DEFAULT 'TURNO',
  efectivo_esperado DECIMAL(19,4) NOT NULL,
  efectivo_declarado DECIMAL(19,4) NOT NULL,
  diferencia_efectivo DECIMAL(19,4)
    GENERATED ALWAYS AS (efectivo_declarado - efectivo_esperado) STORED,
  fondo_que_permanece DECIMAL(19,4) NOT NULL DEFAULT 0,
  efectivo_retirado DECIMAL(19,4) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  cerrado_by BIGINT UNSIGNED NOT NULL,
  revisado_by BIGINT UNSIGNED NULL,
  cerrado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  observaciones VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_cierres_caja_empresa_id (empresa_id, id),
  UNIQUE KEY uq_cierres_caja_sesion (empresa_id, sesion_caja_id),
  CONSTRAINT fk_cierres_caja_sesion
    FOREIGN KEY (empresa_id, sesion_caja_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_cierres_caja_usuario
    FOREIGN KEY (empresa_id, cerrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_cierres_caja_revisor
    FOREIGN KEY (empresa_id, revisado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_cierres_caja_tipo CHECK (tipo IN ('TURNO', 'FINAL', 'DIARIO')),
  CONSTRAINT ck_cierres_caja_montos CHECK (
    efectivo_esperado >= 0 AND efectivo_declarado >= 0
    AND fondo_que_permanece >= 0 AND efectivo_retirado >= 0
  ),
  CONSTRAINT ck_cierres_caja_estado CHECK (
    estado IN ('BORRADOR', 'PENDIENTE_REVISION', 'APROBADO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cierre_caja_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  cierre_caja_id BIGINT UNSIGNED NOT NULL,
  metodo_pago_id BIGINT UNSIGNED NOT NULL,
  monto_sistema DECIMAL(19,4) NOT NULL,
  monto_declarado DECIMAL(19,4) NOT NULL,
  diferencia DECIMAL(19,4)
    GENERATED ALWAYS AS (monto_declarado - monto_sistema) STORED,
  PRIMARY KEY (id),
  UNIQUE KEY uq_cierre_detalles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_cierre_detalles_metodo (empresa_id, cierre_caja_id, metodo_pago_id),
  CONSTRAINT fk_cierre_detalles_cierre
    FOREIGN KEY (empresa_id, cierre_caja_id) REFERENCES cierres_caja (empresa_id, id),
  CONSTRAINT fk_cierre_detalles_metodo
    FOREIGN KEY (empresa_id, metodo_pago_id) REFERENCES metodos_pago (empresa_id, id),
  CONSTRAINT ck_cierre_detalles_montos CHECK (monto_sistema >= 0 AND monto_declarado >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS entregas_turno (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  sesion_origen_id BIGINT UNSIGNED NOT NULL,
  sesion_destino_id BIGINT UNSIGNED NULL,
  fondo_entregado DECIMAL(19,4) NOT NULL,
  monto_retirado DECIMAL(19,4) NOT NULL DEFAULT 0,
  estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
  entregado_by BIGINT UNSIGNED NOT NULL,
  recibido_by BIGINT UNSIGNED NULL,
  entregado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  recibido_at DATETIME(6) NULL,
  observaciones VARCHAR(500) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_entregas_turno_empresa_id (empresa_id, id),
  UNIQUE KEY uq_entregas_turno_origen (empresa_id, sesion_origen_id),
  CONSTRAINT fk_entregas_turno_origen
    FOREIGN KEY (empresa_id, sesion_origen_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_entregas_turno_destino
    FOREIGN KEY (empresa_id, sesion_destino_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_entregas_turno_entrega
    FOREIGN KEY (empresa_id, entregado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_entregas_turno_recibe
    FOREIGN KEY (empresa_id, recibido_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_entregas_turno_montos CHECK (fondo_entregado >= 0 AND monto_retirado >= 0),
  CONSTRAINT ck_entregas_turno_estado CHECK (
    estado IN ('PENDIENTE', 'RECIBIDA', 'OBSERVADA', 'CANCELADA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS gastos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  tipo_gasto_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  sesion_caja_id BIGINT UNSIGNED NULL,
  metodo_pago_id BIGINT UNSIGNED NULL,
  monto DECIMAL(19,4) NOT NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  descripcion VARCHAR(500) NOT NULL,
  comprobante_url VARCHAR(500) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'REGISTRADO',
  registrado_by BIGINT UNSIGNED NOT NULL,
  aprobado_by BIGINT UNSIGNED NULL,
  ocurrido_at DATETIME(6) NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_gastos_empresa_id (empresa_id, id),
  KEY ix_gastos_fecha (empresa_id, ubicacion_id, ocurrido_at),
  CONSTRAINT fk_gastos_tipo
    FOREIGN KEY (empresa_id, tipo_gasto_id) REFERENCES tipos_gasto (empresa_id, id),
  CONSTRAINT fk_gastos_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_gastos_sesion
    FOREIGN KEY (empresa_id, sesion_caja_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_gastos_metodo
    FOREIGN KEY (empresa_id, metodo_pago_id) REFERENCES metodos_pago (empresa_id, id),
  CONSTRAINT fk_gastos_registrador
    FOREIGN KEY (empresa_id, registrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_gastos_aprobador
    FOREIGN KEY (empresa_id, aprobado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_gastos_monto CHECK (monto > 0),
  CONSTRAINT ck_gastos_estado CHECK (estado IN ('REGISTRADO', 'APROBADO', 'ANULADO'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promociones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  descripcion VARCHAR(500) NULL,
  tipo_descuento VARCHAR(20) NOT NULL,
  valor_descuento DECIMAL(19,4) NOT NULL,
  prioridad SMALLINT NOT NULL DEFAULT 0,
  acumulable TINYINT(1) NOT NULL DEFAULT 0,
  etiqueta_color VARCHAR(20) NULL,
  vigente_desde DATETIME(6) NOT NULL,
  vigente_hasta DATETIME(6) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR',
  created_by BIGINT UNSIGNED NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_promociones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_promociones_codigo (empresa_id, codigo),
  KEY ix_promociones_vigencia (empresa_id, estado, vigente_desde, vigente_hasta),
  CONSTRAINT fk_promociones_creador
    FOREIGN KEY (empresa_id, created_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_promociones_tipo CHECK (tipo_descuento IN ('PORCENTAJE', 'MONTO_FIJO')),
  CONSTRAINT ck_promociones_valor CHECK (valor_descuento > 0),
  CONSTRAINT ck_promociones_vigencia CHECK (vigente_hasta > vigente_desde),
  CONSTRAINT ck_promociones_estado CHECK (
    estado IN ('BORRADOR', 'ACTIVA', 'PAUSADA', 'FINALIZADA', 'CANCELADA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_ubicaciones (
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, promocion_id, ubicacion_id),
  CONSTRAINT fk_promocion_ubicaciones_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT fk_promocion_ubicaciones_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_canales (
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  canal_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, promocion_id, canal_id),
  CONSTRAINT fk_promocion_canales_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT fk_promocion_canales_canal
    FOREIGN KEY (empresa_id, canal_id) REFERENCES canales_venta (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_categorias (
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  categoria_id BIGINT UNSIGNED NOT NULL,
  incluye_descendientes TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (empresa_id, promocion_id, categoria_id),
  CONSTRAINT fk_promocion_categorias_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT fk_promocion_categorias_categoria
    FOREIGN KEY (empresa_id, categoria_id) REFERENCES categorias (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_productos (
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, promocion_id, producto_id),
  CONSTRAINT fk_promocion_productos_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT fk_promocion_productos_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_variantes (
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (empresa_id, promocion_id, variante_id),
  CONSTRAINT fk_promocion_variantes_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT fk_promocion_variantes_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promocion_rangos_codigo (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  promocion_id BIGINT UNSIGNED NOT NULL,
  campo VARCHAR(30) NOT NULL,
  desde_numero BIGINT UNSIGNED NOT NULL,
  hasta_numero BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_promocion_rangos_empresa_id (empresa_id, id),
  CONSTRAINT fk_promocion_rangos_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT ck_promocion_rangos_campo CHECK (
    campo IN ('CODIGO_INTERNO', 'CODIGO_SERIAL')
  ),
  CONSTRAINT ck_promocion_rangos_orden CHECK (hasta_numero >= desde_numero)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tarjetas_regalo (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(100) NOT NULL,
  cliente_id BIGINT UNSIGNED NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  saldo_inicial DECIMAL(19,4) NOT NULL,
  saldo_actual DECIMAL(19,4) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  emitida_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  vence_at DATETIME(6) NULL,
  created_by BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tarjetas_regalo_empresa_id (empresa_id, id),
  UNIQUE KEY uq_tarjetas_regalo_codigo (empresa_id, codigo),
  CONSTRAINT fk_tarjetas_regalo_cliente
    FOREIGN KEY (empresa_id, cliente_id) REFERENCES clientes (empresa_id, id),
  CONSTRAINT fk_tarjetas_regalo_usuario
    FOREIGN KEY (empresa_id, created_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_tarjetas_regalo_saldos CHECK (
    saldo_inicial >= 0 AND saldo_actual >= 0
  ),
  CONSTRAINT ck_tarjetas_regalo_estado CHECK (
    estado IN ('ACTIVA', 'AGOTADA', 'VENCIDA', 'BLOQUEADA', 'ANULADA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tarjeta_regalo_movimientos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  tarjeta_regalo_id BIGINT UNSIGNED NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  monto DECIMAL(19,4) NOT NULL,
  saldo_resultante DECIMAL(19,4) NOT NULL,
  referencia_entidad VARCHAR(50) NULL,
  referencia_id BIGINT UNSIGNED NULL,
  registrado_by BIGINT UNSIGNED NOT NULL,
  ocurrido_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_tarjeta_movs_empresa_id (empresa_id, id),
  KEY ix_tarjeta_movs_tarjeta (empresa_id, tarjeta_regalo_id, ocurrido_at),
  CONSTRAINT fk_tarjeta_movs_tarjeta
    FOREIGN KEY (empresa_id, tarjeta_regalo_id) REFERENCES tarjetas_regalo (empresa_id, id),
  CONSTRAINT fk_tarjeta_movs_usuario
    FOREIGN KEY (empresa_id, registrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_tarjeta_movs_tipo CHECK (
    tipo IN ('EMISION', 'CONSUMO', 'RECARGA', 'REEMBOLSO', 'AJUSTE', 'VENCIMIENTO')
  ),
  CONSTRAINT ck_tarjeta_movs_monto CHECK (monto > 0),
  CONSTRAINT ck_tarjeta_movs_saldo CHECK (saldo_resultante >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ventas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  tipo_operacion VARCHAR(20) NOT NULL DEFAULT 'VENTA',
  canal_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  sesion_caja_inicial_id BIGINT UNSIGNED NULL,
  cliente_id BIGINT UNSIGNED NULL,
  cajero_id BIGINT UNSIGNED NOT NULL,
  asesor_predeterminado_id BIGINT UNSIGNED NULL,
  moneda CHAR(3) NOT NULL DEFAULT 'BOB',
  subtotal DECIMAL(19,4) NOT NULL,
  descuento_total DECIMAL(19,4) NOT NULL DEFAULT 0,
  impuesto_total DECIMAL(19,4) NOT NULL DEFAULT 0,
  total DECIMAL(19,4) NOT NULL,
  estado VARCHAR(25) NOT NULL DEFAULT 'BORRADOR',
  realizada_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  anulada_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_ventas_empresa_id (empresa_id, id),
  UNIQUE KEY uq_ventas_codigo (empresa_id, codigo),
  KEY ix_ventas_fecha (empresa_id, ubicacion_id, realizada_at),
  KEY ix_ventas_cliente (empresa_id, cliente_id, realizada_at),
  KEY ix_ventas_estado (empresa_id, tipo_operacion, estado),
  CONSTRAINT fk_ventas_canal
    FOREIGN KEY (empresa_id, canal_id) REFERENCES canales_venta (empresa_id, id),
  CONSTRAINT fk_ventas_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_ventas_sesion
    FOREIGN KEY (empresa_id, sesion_caja_inicial_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_ventas_cliente
    FOREIGN KEY (empresa_id, cliente_id) REFERENCES clientes (empresa_id, id),
  CONSTRAINT fk_ventas_cajero
    FOREIGN KEY (empresa_id, cajero_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_ventas_asesor
    FOREIGN KEY (empresa_id, asesor_predeterminado_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_ventas_tipo CHECK (tipo_operacion IN ('VENTA', 'RESERVA')),
  CONSTRAINT ck_ventas_montos CHECK (
    subtotal >= 0 AND descuento_total >= 0 AND impuesto_total >= 0 AND total >= 0
  ),
  CONSTRAINT ck_ventas_estado CHECK (
    estado IN (
      'BORRADOR', 'PENDIENTE_PAGO', 'CONFIRMADA', 'COMPLETADA',
      'ANULADA', 'DEVUELTA_PARCIAL', 'DEVUELTA_TOTAL', 'CANCELADA'
    )
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS venta_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  producto_id BIGINT UNSIGNED NOT NULL,
  variante_id BIGINT UNSIGNED NOT NULL,
  unidad_id BIGINT UNSIGNED NULL,
  asesor_id BIGINT UNSIGNED NULL,
  promocion_id BIGINT UNSIGNED NULL,
  cantidad DECIMAL(18,4) NOT NULL,
  costo_unitario_snapshot DECIMAL(19,4) NULL,
  precio_lista_unitario DECIMAL(19,4) NOT NULL,
  descuento_unitario DECIMAL(19,4) NOT NULL DEFAULT 0,
  precio_final_unitario DECIMAL(19,4) NOT NULL,
  total_linea DECIMAL(19,4) NOT NULL,
  descripcion_snapshot VARCHAR(255) NOT NULL,
  codigo_snapshot VARCHAR(128) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_venta_detalles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_venta_detalles_unidad (empresa_id, venta_id, unidad_id),
  KEY ix_venta_detalles_variante (empresa_id, variante_id),
  CONSTRAINT fk_venta_detalles_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT fk_venta_detalles_producto
    FOREIGN KEY (empresa_id, producto_id) REFERENCES productos (empresa_id, id),
  CONSTRAINT fk_venta_detalles_variante
    FOREIGN KEY (empresa_id, variante_id) REFERENCES variantes (empresa_id, id),
  CONSTRAINT fk_venta_detalles_unidad
    FOREIGN KEY (empresa_id, unidad_id) REFERENCES unidades_inventario (empresa_id, id),
  CONSTRAINT fk_venta_detalles_asesor
    FOREIGN KEY (empresa_id, asesor_id) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_venta_detalles_promocion
    FOREIGN KEY (empresa_id, promocion_id) REFERENCES promociones (empresa_id, id),
  CONSTRAINT ck_venta_detalles_cantidad CHECK (cantidad > 0),
  CONSTRAINT ck_venta_detalles_montos CHECK (
    precio_lista_unitario >= 0 AND descuento_unitario >= 0
    AND precio_final_unitario >= 0 AND total_linea >= 0
  )
) ENGINE=InnoDB;

-- Cada abono de una reserva es una fila independiente, con fecha, caja, usuario
-- y método. Esto también permite pagos mixtos en ventas normales.
CREATE TABLE IF NOT EXISTS pagos_venta (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  metodo_pago_id BIGINT UNSIGNED NOT NULL,
  cuenta_cobro_id BIGINT UNSIGNED NULL,
  tarjeta_regalo_id BIGINT UNSIGNED NULL,
  sesion_caja_id BIGINT UNSIGNED NULL,
  registrado_by BIGINT UNSIGNED NOT NULL,
  monto DECIMAL(19,4) NOT NULL,
  monto_recibido DECIMAL(19,4) NULL,
  cambio_entregado DECIMAL(19,4) NOT NULL DEFAULT 0,
  referencia_externa VARCHAR(150) NULL,
  numero_cuota INT UNSIGNED NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'CONFIRMADO',
  pagado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  anulado_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_pagos_venta_empresa_id (empresa_id, id),
  UNIQUE KEY uq_pagos_venta_cuota (empresa_id, venta_id, numero_cuota),
  KEY ix_pagos_venta_fecha (empresa_id, sesion_caja_id, pagado_at),
  CONSTRAINT fk_pagos_venta_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT fk_pagos_venta_metodo
    FOREIGN KEY (empresa_id, metodo_pago_id) REFERENCES metodos_pago (empresa_id, id),
  CONSTRAINT fk_pagos_venta_cuenta
    FOREIGN KEY (empresa_id, cuenta_cobro_id) REFERENCES cuentas_cobro (empresa_id, id),
  CONSTRAINT fk_pagos_venta_tarjeta_regalo
    FOREIGN KEY (empresa_id, tarjeta_regalo_id) REFERENCES tarjetas_regalo (empresa_id, id),
  CONSTRAINT fk_pagos_venta_sesion
    FOREIGN KEY (empresa_id, sesion_caja_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_pagos_venta_usuario
    FOREIGN KEY (empresa_id, registrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_pagos_venta_monto CHECK (monto > 0),
  CONSTRAINT ck_pagos_venta_recibido CHECK (monto_recibido IS NULL OR monto_recibido >= monto),
  CONSTRAINT ck_pagos_venta_cambio CHECK (cambio_entregado >= 0),
  CONSTRAINT ck_pagos_venta_estado CHECK (estado IN ('PENDIENTE', 'CONFIRMADO', 'ANULADO', 'REEMBOLSADO'))
) ENGINE=InnoDB;

-- Registro neutro frente al proveedor fiscal. Permite recibo ahora e integración
-- SIAT/proveedor externo después, sin contaminar el núcleo de inventario.
CREATE TABLE IF NOT EXISTS documentos_venta (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  numero VARCHAR(80) NOT NULL,
  proveedor_fiscal VARCHAR(100) NULL,
  id_externo VARCHAR(150) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'EMITIDO',
  datos_fiscales_snapshot JSON NULL,
  url_documento VARCHAR(500) NULL,
  emitido_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  anulado_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_documentos_venta_empresa_id (empresa_id, id),
  UNIQUE KEY uq_documentos_venta_numero (empresa_id, tipo, numero),
  KEY ix_documentos_venta_venta (empresa_id, venta_id),
  CONSTRAINT fk_documentos_venta_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT ck_documentos_venta_tipo CHECK (tipo IN ('RECIBO', 'FACTURA', 'NOTA_CREDITO')),
  CONSTRAINT ck_documentos_venta_estado CHECK (
    estado IN ('PENDIENTE', 'EMITIDO', 'RECHAZADO', 'ANULADO')
  )
) ENGINE=InnoDB;

-- Extensión 1:1 de ventas cuando tipo_operacion = RESERVA.
CREATE TABLE IF NOT EXISTS reservas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  estado VARCHAR(25) NOT NULL DEFAULT 'ACTIVA',
  entregada_by BIGINT UNSIGNED NULL,
  entregada_at DATETIME(6) NULL,
  cancelada_by BIGINT UNSIGNED NULL,
  cancelada_at DATETIME(6) NULL,
  motivo_cancelacion VARCHAR(500) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
    ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_reservas_empresa_id (empresa_id, id),
  UNIQUE KEY uq_reservas_venta (empresa_id, venta_id),
  KEY ix_reservas_vencimiento (empresa_id, estado, fecha_vencimiento),
  CONSTRAINT fk_reservas_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT fk_reservas_entregador
    FOREIGN KEY (empresa_id, entregada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_reservas_cancelador
    FOREIGN KEY (empresa_id, cancelada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_reservas_estado CHECK (
    estado IN ('ACTIVA', 'VENCIDA', 'COMPLETADA', 'CANCELADA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reserva_vencimientos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  reserva_id BIGINT UNSIGNED NOT NULL,
  fecha_anterior DATE NOT NULL,
  fecha_nueva DATE NOT NULL,
  motivo VARCHAR(500) NOT NULL,
  cambiado_by BIGINT UNSIGNED NOT NULL,
  cambiado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_reserva_vencimientos_empresa_id (empresa_id, id),
  KEY ix_reserva_vencimientos_reserva (empresa_id, reserva_id, cambiado_at),
  CONSTRAINT fk_reserva_vencimientos_reserva
    FOREIGN KEY (empresa_id, reserva_id) REFERENCES reservas (empresa_id, id),
  CONSTRAINT fk_reserva_vencimientos_usuario
    FOREIGN KEY (empresa_id, cambiado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_reserva_vencimientos_cambio CHECK (fecha_nueva <> fecha_anterior)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reserva_seguimientos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  reserva_id BIGINT UNSIGNED NOT NULL,
  tipo_contacto VARCHAR(20) NOT NULL,
  resultado VARCHAR(30) NOT NULL,
  nota VARCHAR(500) NULL,
  siguiente_contacto_at DATETIME(6) NULL,
  registrado_by BIGINT UNSIGNED NOT NULL,
  registrado_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_reserva_seguimientos_empresa_id (empresa_id, id),
  KEY ix_reserva_seguimientos_reserva (empresa_id, reserva_id, registrado_at),
  CONSTRAINT fk_reserva_seguimientos_reserva
    FOREIGN KEY (empresa_id, reserva_id) REFERENCES reservas (empresa_id, id),
  CONSTRAINT fk_reserva_seguimientos_usuario
    FOREIGN KEY (empresa_id, registrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_reserva_seguimientos_tipo CHECK (
    tipo_contacto IN ('LLAMADA', 'WHATSAPP', 'SMS', 'EMAIL', 'PRESENCIAL', 'OTRO')
  ),
  CONSTRAINT ck_reserva_seguimientos_resultado CHECK (
    resultado IN ('CONTACTADO', 'SIN_RESPUESTA', 'REPROGRAMADO', 'PROMESA_PAGO', 'OTRO')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS anulaciones_venta (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  motivo VARCHAR(500) NOT NULL,
  solicitada_by BIGINT UNSIGNED NOT NULL,
  autorizada_by BIGINT UNSIGNED NULL,
  anulada_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_anulaciones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_anulaciones_venta (empresa_id, venta_id),
  CONSTRAINT fk_anulaciones_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT fk_anulaciones_solicitante
    FOREIGN KEY (empresa_id, solicitada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_anulaciones_autorizador
    FOREIGN KEY (empresa_id, autorizada_by) REFERENCES usuarios (empresa_id, id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS devoluciones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  venta_id BIGINT UNSIGNED NOT NULL,
  ubicacion_id BIGINT UNSIGNED NOT NULL,
  motivo VARCHAR(500) NOT NULL,
  estado VARCHAR(25) NOT NULL DEFAULT 'SOLICITADA',
  solicitada_by BIGINT UNSIGNED NOT NULL,
  verificada_by BIGINT UNSIGNED NULL,
  solicitada_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  resuelta_at DATETIME(6) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_devoluciones_empresa_id (empresa_id, id),
  UNIQUE KEY uq_devoluciones_codigo (empresa_id, codigo),
  KEY ix_devoluciones_venta (empresa_id, venta_id),
  CONSTRAINT fk_devoluciones_venta
    FOREIGN KEY (empresa_id, venta_id) REFERENCES ventas (empresa_id, id),
  CONSTRAINT fk_devoluciones_ubicacion
    FOREIGN KEY (empresa_id, ubicacion_id) REFERENCES ubicaciones (empresa_id, id),
  CONSTRAINT fk_devoluciones_solicitante
    FOREIGN KEY (empresa_id, solicitada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT fk_devoluciones_verificador
    FOREIGN KEY (empresa_id, verificada_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_devoluciones_estado CHECK (
    estado IN ('SOLICITADA', 'EN_REVISION', 'APROBADA', 'RECHAZADA', 'REEMBOLSADA', 'CERRADA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS devolucion_detalles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  devolucion_id BIGINT UNSIGNED NOT NULL,
  venta_detalle_id BIGINT UNSIGNED NOT NULL,
  unidad_id BIGINT UNSIGNED NULL,
  cantidad DECIMAL(18,4) NOT NULL,
  condicion VARCHAR(25) NOT NULL,
  reintegra_stock TINYINT(1) NOT NULL DEFAULT 0,
  monto_reembolso DECIMAL(19,4) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_devolucion_detalles_empresa_id (empresa_id, id),
  UNIQUE KEY uq_devolucion_detalles_linea
    (empresa_id, devolucion_id, venta_detalle_id, unidad_id),
  CONSTRAINT fk_devolucion_detalles_devolucion
    FOREIGN KEY (empresa_id, devolucion_id) REFERENCES devoluciones (empresa_id, id),
  CONSTRAINT fk_devolucion_detalles_venta
    FOREIGN KEY (empresa_id, venta_detalle_id) REFERENCES venta_detalles (empresa_id, id),
  CONSTRAINT fk_devolucion_detalles_unidad
    FOREIGN KEY (empresa_id, unidad_id) REFERENCES unidades_inventario (empresa_id, id),
  CONSTRAINT ck_devolucion_detalles_cantidad CHECK (cantidad > 0),
  CONSTRAINT ck_devolucion_detalles_monto CHECK (monto_reembolso >= 0),
  CONSTRAINT ck_devolucion_detalles_condicion CHECK (
    condicion IN ('APTA_VENTA', 'REQUIERE_REVISION', 'DANADA', 'NO_RETORNA')
  )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reembolsos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  devolucion_id BIGINT UNSIGNED NOT NULL,
  metodo_pago_id BIGINT UNSIGNED NOT NULL,
  sesion_caja_id BIGINT UNSIGNED NULL,
  monto DECIMAL(19,4) NOT NULL,
  referencia_externa VARCHAR(150) NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
  registrado_by BIGINT UNSIGNED NOT NULL,
  pagado_at DATETIME(6) NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_reembolsos_empresa_id (empresa_id, id),
  CONSTRAINT fk_reembolsos_devolucion
    FOREIGN KEY (empresa_id, devolucion_id) REFERENCES devoluciones (empresa_id, id),
  CONSTRAINT fk_reembolsos_metodo
    FOREIGN KEY (empresa_id, metodo_pago_id) REFERENCES metodos_pago (empresa_id, id),
  CONSTRAINT fk_reembolsos_sesion
    FOREIGN KEY (empresa_id, sesion_caja_id) REFERENCES sesiones_caja (empresa_id, id),
  CONSTRAINT fk_reembolsos_usuario
    FOREIGN KEY (empresa_id, registrado_by) REFERENCES usuarios (empresa_id, id),
  CONSTRAINT ck_reembolsos_monto CHECK (monto > 0),
  CONSTRAINT ck_reembolsos_estado CHECK (
    estado IN ('PENDIENTE', 'PROCESANDO', 'PAGADO', 'FALLIDO', 'CANCELADO')
  )
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 5. Auditoría y vistas operativas
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS auditoria_eventos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  empresa_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NULL,
  accion VARCHAR(60) NOT NULL,
  entidad VARCHAR(80) NOT NULL,
  entidad_id VARCHAR(80) NOT NULL,
  datos_antes JSON NULL,
  datos_despues JSON NULL,
  ip VARCHAR(45) NULL,
  user_agent VARCHAR(500) NULL,
  correlacion_id CHAR(36) NULL,
  ocurrido_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  KEY ix_auditoria_entidad (empresa_id, entidad, entidad_id, ocurrido_at),
  KEY ix_auditoria_usuario (empresa_id, usuario_id, ocurrido_at),
  CONSTRAINT fk_auditoria_empresa
    FOREIGN KEY (empresa_id) REFERENCES empresas (id),
  CONSTRAINT fk_auditoria_usuario
    FOREIGN KEY (empresa_id, usuario_id) REFERENCES usuarios (empresa_id, id)
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW vw_cuentas_por_cobrar_reservas AS
SELECT
  v.empresa_id,
  r.id AS reserva_id,
  v.id AS venta_id,
  v.codigo,
  v.cliente_id,
  v.ubicacion_id,
  v.total,
  COALESCE(p.total_pagado, 0) AS total_pagado,
  GREATEST(v.total - COALESCE(p.total_pagado, 0), 0) AS saldo_pendiente,
  r.fecha_vencimiento,
  DATEDIFF(r.fecha_vencimiento, CURRENT_DATE) AS dias_hasta_vencimiento,
  CASE
    WHEN COALESCE(p.total_pagado, 0) >= v.total THEN 'PAGADA'
    WHEN r.estado = 'CANCELADA' THEN 'CANCELADA'
    WHEN r.fecha_vencimiento < CURRENT_DATE THEN 'VENCIDA'
    ELSE 'ACTIVA'
  END AS clasificacion,
  r.estado
FROM reservas r
JOIN ventas v
  ON v.empresa_id = r.empresa_id AND v.id = r.venta_id
LEFT JOIN (
  SELECT empresa_id, venta_id, SUM(monto) AS total_pagado
  FROM pagos_venta
  WHERE estado = 'CONFIRMADO'
  GROUP BY empresa_id, venta_id
) p
  ON p.empresa_id = v.empresa_id AND p.venta_id = v.id;

CREATE OR REPLACE VIEW vw_stock_disponible AS
SELECT
  u.empresa_id,
  u.ubicacion_actual_id AS ubicacion_id,
  u.producto_id,
  u.variante_id,
  'SERIALIZADO' AS modo_inventario,
  CAST(COUNT(*) AS DECIMAL(18,4)) AS cantidad_fisica,
  CAST(SUM(u.estado = 'RESERVADA') AS DECIMAL(18,4)) AS cantidad_reservada,
  CAST(SUM(u.estado = 'DISPONIBLE') AS DECIMAL(18,4)) AS cantidad_disponible
FROM unidades_inventario u
WHERE u.ubicacion_actual_id IS NOT NULL
  AND u.estado NOT IN ('VENDIDA', 'BAJA')
GROUP BY u.empresa_id, u.ubicacion_actual_id, u.producto_id, u.variante_id

UNION ALL

SELECT
  s.empresa_id,
  s.ubicacion_id,
  v.producto_id,
  s.variante_id,
  'CANTIDAD' AS modo_inventario,
  s.cantidad_fisica,
  s.cantidad_reservada,
  s.cantidad_disponible
FROM inventario_saldos s
JOIN variantes v
  ON v.empresa_id = s.empresa_id AND v.id = s.variante_id;

-- Fin de la maqueta V1.
