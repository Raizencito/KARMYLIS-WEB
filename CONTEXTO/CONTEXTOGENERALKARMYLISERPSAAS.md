CONTEXTO MAESTRO DEFINITIVO — PROYECTO ERP / E-COMMERCE / FUTURO SaaS KARMYLIS
==============================================================================

INSTRUCCIONES PARA LA IA QUE RECIBA ESTE CONTEXTO
-------------------------------------------------

Este documento contiene el estado acumulado del proyecto Karmylis hasta agosto de 2026.

Debe utilizarse como contexto persistente para continuar el análisis, diseño y eventual implementación del sistema.

IMPORTANTE:

*   No asumir que todas las ideas aquí descritas están cerradas.
    
*   Diferenciar siempre entre:
    
    *   hechos actuales del negocio;
        
    *   requisitos confirmados;
        
    *   propuestas de arquitectura;
        
    *   hipótesis;
        
    *   decisiones provisionales;
        
    *   cuestiones todavía pendientes.
        
*   No diseñar tablas o código definitivo antes de comprender el proceso de negocio involucrado.
    
*   Cuando aparezca nueva información proporcionada por Karmylis, debe tener prioridad sobre supuestos anteriores.
    
*   No intentar convertir inmediatamente cada necesidad en una tabla.
    
*   No sobrearquitecturar el SaaS durante la primera implementación.
    
*   No copiar literalmente WooCommerce, PrestaShop, Odoo, Shopify u otros sistemas.
    
*   Esas plataformas se están estudiando como referencias de diseño.
    
*   Mantener explicaciones técnicas, pero comprensibles.
    
*   El usuario está aprendiendo arquitectura y modelado mientras desarrolla el proyecto, por lo que debe explicarse el razonamiento detrás de las decisiones.
    
*   Cuando exista ambigüedad del dominio, señalarla explícitamente en lugar de inventar una regla.
    
*   Si se habla de normativa boliviana, facturación electrónica, SIN, NIT, CUIS, CUFD o requisitos actuales de software externo, verificar fuentes actuales antes de afirmar detalles.
    

1\. IDENTIDAD DEL PROYECTO
==========================

El proyecto consiste inicialmente en desarrollar un sistema ERP propio para Karmylis, una empresa familiar dedicada principalmente a la comercialización de prendas de vestir.

La visión ha evolucionado considerablemente.

Lo que comenzó como una solución relativamente pequeña para mejorar el inventario de la sucursal K4 ahora forma parte de una visión mayor:

**ERP centralizado + multisucursal + multicaja + venta multicanal + tienda online propia**, utilizando Karmylis como primer entorno real de validación.

Posteriormente se pretende estudiar la generalización de los conceptos validados para convertirlos en un producto SaaS configurable para otras empresas comerciales.

Por lo tanto existen DOS proyectos/fases relacionadas pero conceptualmente distintas.

2\. FASE 1 — ERP KARMYLIS + TIENDA ONLINE PROPIA
================================================

Esta es la fase actual.

Se desarrollará una solución específicamente para Karmylis.

El sistema deberá resolver progresivamente:

*   configuración básica de la empresa;
    
*   catálogo;
    
*   categorías;
    
*   artículos/productos;
    
*   atributos;
    
*   codificación;
    
*   ingreso de mercadería;
    
*   lotes o procesos de ingreso;
    
*   distribución inicial;
    
*   inventario;
    
*   existencias físicas;
    
*   sucursales;
    
*   almacenes o ubicaciones;
    
*   movimientos;
    
*   reasignaciones;
    
*   transferencias;
    
*   controles físicos de inventario;
    
*   usuarios;
    
*   roles/permisos;
    
*   multicaja;
    
*   sesiones de caja;
    
*   ventas;
    
*   asesores;
    
*   pagos;
    
*   pagos mixtos;
    
*   gastos;
    
*   reservas;
    
*   promociones;
    
*   devoluciones;
    
*   gift cards;
    
*   tienda online;
    
*   publicación por canal;
    
*   reportes;
    
*   futura alimentación de BI/DWH.
    

K4 puede utilizarse como piloto operativo.

Sin embargo, la estructura conceptual no debería construirse como si K4 fuese la única sucursal que jamás existirá.

Actualmente existen referencias operativas a K1, K2, K3 y K4.

3\. FASE 2 — PRODUCTO SaaS
==========================

La segunda fase NO consiste simplemente en “poner el ERP de Karmylis en Internet”.

Se pretende convertir aprendizajes y capacidades generalizables en un producto comercial que pueda utilizarse por otras empresas.

Originalmente se pensaba principalmente en boutiques o cadenas de ropa.

La conversación más reciente amplió esa visión.

El sistema podría eventualmente utilizarse en otros tipos de comercio.

Ejemplos utilizados durante la discusión:

*   ropa;
    
*   supermercados;
    
*   distribuidoras;
    
*   comercio mayorista;
    
*   farmacias;
    
*   negocios que venden por unidad;
    
*   negocios que venden por caja;
    
*   productos medidos en litros;
    
*   productos con presentaciones diferentes.
    

Por tanto, el futuro SaaS no debería depender exclusivamente de conceptos como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color  Talla  Prenda  Boutique   `

Sin embargo, tampoco debe convertirse desde ahora en un ERP universal para cualquier industria.

Karmylis es el **Design Partner / laboratorio de validación**.

Principio:

> Build for one, design for many.

Es decir:

**Construir para Karmylis, pero evitar decisiones que hagan imposible generalizar posteriormente.**

4\. DISTINCIÓN CRÍTICA: SaaS MULTITENANT VS FLEXIBILIDAD FUNCIONAL
==================================================================

Estas dos cosas NO son iguales.

Multitenencia
-------------

Responde:

> ¿Cómo se mantienen separados los datos de distintas empresas?

Posibles estrategias futuras:

### A. Base compartida + esquema compartido

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   productos  empresa_id  ...   `

Todas las empresas comparten tablas y las filas se separan por tenant/empresa.

### B. Base compartida + esquema por tenant

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   karmylis.productos  empresa_b.productos   `

### C. Base de datos independiente por tenant

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   karmylis_db  farmacia_db  empresa_b_db   `

### D. Estrategia híbrida

Por ejemplo:

*   pequeños clientes en infraestructura compartida;
    
*   clientes empresariales en bases dedicadas.
    

Esta decisión NO está cerrada.

No implementar toda esta infraestructura durante Fase 1.

Flexibilidad funcional
----------------------

Responde:

> ¿Cómo puede cada empresa trabajar de forma diferente utilizando el mismo software?

Ejemplo:

Karmylis:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Atributos:  Color  Talla  Inventario:  Serializado  Pagos:  Efectivo  Tarjeta  QR  Transferencia  Reservas:  Sí   `

Otra empresa:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Atributos:  Presentación  Volumen  Inventario:  Cantidad  Pagos:  Efectivo  QR  Reservas:  No   `

Aunque cada empresa tuviera su propia BDD, NO queremos modificar manualmente el esquema cada vez que llegue un cliente.

Ideal:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Nuevo cliente  → crear empresa  → configurar atributos  → configurar módulos  → configurar políticas  → comenzar operación   `

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Nuevo cliente  → cambiar tablas  → agregar columnas  → modificar backend  → modificar frontend   `

Principio fundamental:

> La multitenencia separa empresas. La configuración hace flexible al producto.

5\. USUARIO / RESPONSABLE DEL DESARROLLO
========================================

Alan es estudiante de Ingeniería de Sistemas en Bolivia.

Está entrando aproximadamente a sexto semestre y este es su primer proyecto empresarial serio con un cliente/negocio real.

Quiere utilizar el proyecto también como una oportunidad para aprender correctamente:

*   análisis de sistemas;
    
*   arquitectura;
    
*   bases de datos;
    
*   dominio;
    
*   diseño SaaS;
    
*   backend;
    
*   frontend;
    
*   integración;
    
*   UX;
    
*   BI;
    
*   despliegue.
    

No quiere simplemente delegar todo a IA.

Quiere entender por qué se toman las decisiones.

Por tanto:

*   explicar conceptos desde fundamentos;
    
*   no asumir conocimiento profesional avanzado;
    
*   no ocultar decisiones detrás de “best practices”;
    
*   ser técnico pero claro.
    

Cuando Alan se satura con demasiada abstracción, conviene regresar a ejemplos concretos de Karmylis.

6\. STAKEHOLDERS PRINCIPALES
============================

Don Nelson
----------

Principal referente técnico/negocio con el que Alan está trabajando.

Es Ingeniero de Sistemas.

Tiene experiencia suficiente para preguntar sobre:

*   motores de base de datos;
    
*   arquitectura;
    
*   tecnologías;
    
*   escalabilidad;
    
*   frontend;
    
*   Scrum;
    
*   configurabilidad;
    
*   estructura de tablas;
    
*   multicaja;
    
*   inventario;
    
*   SaaS.
    

Tiene además conocimiento directo del sistema existente.

Está abierto a propuestas nuevas.

No espera necesariamente que el sistema nuevo copie exactamente al sistema actual.

Durante la reunión utiliza frecuentemente frases equivalentes a:

*   “hay que verlo”;
    
*   “podríamos hacerlo”;
    
*   “investiguemos cómo lo hacen otros sistemas”.
    

Por tanto hay espacio real para diseño.

Melani
------

Stakeholder operativa cercana a la realidad diaria de Karmylis.

Ha aportado información relevante sobre:

*   inventario;
    
*   reservas;
    
*   diferencias entre sucursales;
    
*   comportamiento de prendas;
    
*   traslados;
    
*   necesidades de consulta;
    
*   análisis de ventas;
    
*   lotes y compras.
    

Familia / administración Karmylis
---------------------------------

Dueños y responsables del negocio proporcionan:

*   reglas;
    
*   procesos;
    
*   criterios comerciales;
    
*   información histórica;
    
*   validación.
    

7\. EVOLUCIÓN DEL PROYECTO
==========================

Primera visión
--------------

Inicialmente se estudió K4 como una sucursal con problemas de:

*   Excel;
    
*   códigos;
    
*   falta de información de talla/color;
    
*   inventario impreciso;
    
*   ventas desconectadas;
    
*   decisiones de compra poco informadas.
    

Se planteó incluso una solución rápida basada en:

*   Google Sheets;
    
*   formularios;
    
*   inventario por variantes;
    
*   automatización de ventas.
    

Esto fue útil para descubrir el problema, pero quedó superado por nueva información.

Visión actual
-------------

El objetivo es considerablemente mayor:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP central  │  ├── K1  ├── K2  ├── K3  ├── K4  ├── almacenes  ├── múltiples cajas  └── tienda online   `

Todos consumiendo una fuente operacional central.

Posteriormente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP validado  → generalización  → SaaS  → múltiples empresas   `

8\. SISTEMA ACTUAL / LEGACY
===========================

Existe un sistema anterior desarrollado aparentemente en C#.

No todo está en producción.

En particular, el módulo de ventas existe parcialmente pero nunca llegó a utilizarse completamente como sistema operativo final.

También existe una relación fuerte con archivos Excel.

El sistema actual sirve como referencia porque contiene reglas, pantallas y conceptos que ya representan parte del funcionamiento real de Karmylis.

Alan solicitó:

*   capturas de pantalla;
    
*   menús desplegados;
    
*   flujos;
    
*   y, si es posible, una copia comprimida del proyecto.
    

Esto permitiría analizar:

*   pantallas;
    
*   nomenclatura;
    
*   formularios;
    
*   consultas;
    
*   estructura;
    
*   reglas;
    
*   UX;
    
*   base de datos.
    

No se pretende copiar automáticamente el código.

Si se recibe el proyecto se deben retirar:

*   contraseñas;
    
*   credenciales;
    
*   cadenas de conexión;
    
*   certificados;
    
*   tokens;
    
*   datos personales;
    
*   copias reales sensibles de BDD.
    

9\. PROCESO ACTUAL DE CATÁLOGO / ARTÍCULOS
==========================================

El sistema actual permite crear artículos.

Existe una referencia definida por la propia empresa.

Ejemplo conceptual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   BL  PC  etc.   `

Estos códigos son convenciones internas.

No necesariamente representan un estándar universal.

El usuario puede introducir un código/referencia que tiene significado para Karmylis.

El sistema genera además otro identificador interno para evitar duplicaciones.

Ejemplo conceptual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Código ingresado:  BL  Si ya existe:  BL2  BL3  BL4  ...   `

La lógica exacta debe revisarse directamente en el sistema.

10\. INFORMACIÓN DEL ARTÍCULO EN EL SISTEMA ACTUAL
==================================================

Se mencionaron datos como:

*   código/referencia;
    
*   nombre/descripción;
    
*   marca;
    
*   grupo;
    
*   precio de compra;
    
*   precio de venta;
    
*   precio mínimo permitido;
    
*   proveedor;
    
*   promociones;
    
*   fotografías.
    

Existe un concepto interesante:

Precio mínimo permitido
-----------------------

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Precio normal:  700 Bs  Precio mínimo:  650 Bs   `

Si alguien intenta vender por debajo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   600 Bs   `

el sistema debería:

*   bloquear;
    
*   advertir;
    
*   o requerir autorización.
    

La política definitiva todavía debe definirse.

11\. CATEGORÍAS / GRUPOS / SUBGRUPOS
====================================

El sistema actual utiliza conceptos equivalentes a grupo y subgrupo.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Pantalones  ├── Cargo  ├── Skinny  └── Baggy   `

Luego aparece la descripción concreta:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Pantalón baggy doble bolsillo jaspeado   `

También existen conceptos como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Varón  Dama  Kids  Accesorios   `

Todavía está pendiente decidir si éstos son:

*   categorías;
    
*   segmentos;
    
*   atributos;
    
*   grupos superiores;
    
*   público objetivo.
    

Profundidad
-----------

Se discutió mantener máximo aproximadamente dos niveles para evitar desorden.

Sin embargo no conviene imponer esa restricción físicamente en el modelo antes de validarla.

Propuesta técnica razonable:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   categoria  - id  - nombre  - categoria_padre_id   `

Esto permite jerarquía arbitraria.

Después:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   configuracion_empresa.max_profundidad_categoria = 2   `

si se desea.

El prototipo educativo ya utilizó una categoría autorreferenciada de este tipo.

También se detectó que deben evitarse ciclos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisas  └── Formal      └── Camisas   `

Una categoría no puede convertirse en padre de sí misma ni de uno de sus ancestros.

12\. ATRIBUTOS CONFIGURABLES
============================

Este es uno de los requisitos más importantes para el futuro SaaS.

Karmylis utiliza actualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color  Talla   `

Pero una empresa diferente podría utilizar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Presentación  Capacidad  Unidad  Peso  Caja  Litros  Forma farmacéutica  etc.   `

Por tanto NO diseñar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.color  producto.talla   `

como única solución universal.

Debe existir alguna forma de definir dinámicamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   atributo_tipo  atributo_valor   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color  ├── Negro  ├── Rojo  ├── Blanco  └── Guindo  Talla  ├── S  ├── M  ├── L  ├── XL  └── etc.   `

Otra empresa podría definir totalmente otros atributos.

13\. JSONB: DISCUSIÓN ACTUAL
============================

Alan inicialmente considera muy atractiva la idea de utilizar JSONB porque recuerda MongoDB/NoSQL como:

*   documentos;
    
*   estructuras flexibles;
    
*   propiedades variables.
    

Esto es correcto conceptualmente.

PostgreSQL podría permitir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto  - id  - nombre  - datos_adicionales JSONB   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   {    "material": "algodón",    "tipo_manga": "larga",    "temporada": "invierno"  }   `

Otro producto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   {    "capacidad": "2L",    "presentacion": "botella"  }   `

Sin modificar columnas.

Pero NO se ha decidido usar JSONB para todo
-------------------------------------------

Principio actual recomendado:

> Flexibilidad de almacenamiento no equivale a ausencia de modelo de dominio.

Datos que participan fuertemente en reglas deberían tender a ser estructurados.

Ejemplos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   empresa  producto  existencia  inventario  sucursal  movimiento  venta  detalle_venta  caja  pago  usuario   `

Datos realmente descriptivos y variables pueden utilizar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   JSONB   `

Posible combinación
-------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   RELACIONAL  +  ATRIBUTOS CONFIGURABLES  +  JSONB SELECTIVO   `

No es necesario escoger entre “PrestaShop” y “JSONB”.

Pueden coexistir.

14\. EAV / ATRIBUTOS VS JSONB
=============================

Dos mecanismos distintos pueden proporcionar flexibilidad.

Modelo relacional dinámico
--------------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   atributo_tipo  atributo_valor  producto_atributo   `

Ventajas:

*   valores reutilizables;
    
*   validación;
    
*   filtros;
    
*   generación de variantes;
    
*   integridad;
    
*   semántica.
    

JSONB
-----

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   {    "material": "algodón",    "coleccion": "2026"  }   `

Ventajas:

*   simplicidad;
    
*   flexibilidad;
    
*   menos tablas;
    
*   datos poco estructurados.
    

Regla conceptual provisional:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Si el dato participa en reglas comerciales importantes  → probablemente estructura relacional/configurable.  Si solo describe y puede variar libremente  → candidato a JSONB.   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color + Talla   `

si determinan una entidad vendible diferente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Negro / M   `

pueden justificar estructura explícita.

Mientras:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   tipo de costura  detalle decorativo  notas   `

podrían ir en JSONB.

No cerrar todavía este diseño.

15\. PRODUCTO, VARIANTE Y EXISTENCIA: PROBLEMA CENTRAL
======================================================

Inicialmente se pensó:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto  └── Variante      └── Stock   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa Slimfit  └── Negro / M      └── stock = 3   `

Esto se parece a PrestaShop, Shopify, Odoo, etc.

Sin embargo, la reunión reveló una particularidad fundamental de Karmylis.

16\. KARMYLIS IDENTIFICA CADA EXISTENCIA FÍSICA
===============================================

Karmylis puede generar un código diferente para cada prenda física.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa Slimfit Negro M  Unidad física 1  → código individual A  Unidad física 2  → código individual B  Unidad física 3  → código individual C   `

Esto es extremadamente importante.

No significa simplemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   SKU Negro/M  cantidad = 3   `

Sino potencialmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Variante Negro/M  ├── Existencia 001  ├── Existencia 002  └── Existencia 003   `

17\. ¿POR QUÉ KARMYLIS HACE ESTO?
=================================

Por el conteo físico.

Las prendas están distribuidas:

*   racks;
    
*   outfits;
    
*   escaparates;
    
*   diferentes sectores.
    

Durante un inventario se escanean:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   pi  pi  pi  pi   `

Si alguien se pierde y vuelve a escanear una prenda:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   pi   `

el sistema puede responder:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Esta prenda ya fue contabilizada.   `

Eso evita dobles conteos.

La identificación individual aporta trazabilidad.

18\. INVENTARIO SERIALIZADO VS INVENTARIO POR CANTIDAD
======================================================

Este descubrimiento produjo una idea importante para el SaaS.

Modo serializado
----------------

Karmylis:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa  ├── unidad 001  ├── unidad 002  └── unidad 003   `

Cada unidad tiene identidad.

Modo por cantidad
-----------------

Ejemplo supermercado:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Coca-Cola 2L  Código:  123456  Stock:  50   `

No interesa distinguir botella #1 de botella #2.

Futuro SaaS
-----------

Debería estudiarse algo equivalente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   modo_control_inventario   `

Valores conceptuales:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   SERIALIZADO  CANTIDAD   `

No necesariamente será literalmente una columna con ese nombre.

La idea conceptual sí debe preservarse.

19\. CÓDIGOS DE KARMYLIS
========================

Se observó una etiqueta real aproximadamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CAMISA DE TELA SLIMFIT  105879-17-335-1   `

Inicialmente se intentó interpretar este código.

La reunión permitió confirmar parcialmente su lógica.

Existen componentes relacionados con:

*   código base/referencia;
    
*   número individual de existencia;
    
*   precio;
    
*   sucursal.
    

El segmento:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   335   `

fue confirmado como relacionado con el precio en el ejemplo mostrado.

Sin embargo, NO debe asumirse todavía con total certeza qué posición exacta corresponde a cada elemento en todos los códigos.

Pendiente obtener ejemplos adicionales y capturas.

20\. REGLA IMPORTANTE SOBRE IDENTIFICADORES
===========================================

Separar conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ID interno de BDD  ≠  Código comercial  ≠  Código de barras  ≠  ID externo   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   id interno:  UUID / bigint / etc.  codigo_karmylis:  105879-17-335-1  codigo_barras:  valor realmente codificado en la etiqueta   `

No utilizar códigos comerciales como clave primaria física de todas las relaciones.

21\. REGLAS DE CODIFICACIÓN FUTURAS
===================================

Para el SaaS no debe imponerse el sistema de códigos de Karmylis.

Ejemplos:

Karmylis:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   105879-17-335-1   `

Empresa B:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CAM-NEG-M-0001   `

Empresa C:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   0000009821   `

La generación podría convertirse en una política/configuración.

Pero no construir un “motor universal de códigos” antes de conocer suficientes casos reales.

22\. INGRESO DE MERCADERÍA / LOTE
=================================

Toda llegada de mercadería debe tratarse como un hecho histórico.

Incluso:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   10 prendas   `

deberían poder formar un proceso de ingreso.

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   INGRESO  - fecha  - artículos  - cantidades  - proveedores  - costos   `

El término final puede ser:

*   ingreso;
    
*   compra;
    
*   lote;
    
*   proceso de abastecimiento.
    

Todavía debe definirse formalmente.

23\. PROVEEDORES
================

Un mismo ingreso puede contener productos de distintos proveedores.

Por eso anteriormente se propuso:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ingreso  └── DetalleIngreso      └── proveedor   `

en lugar de asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ingreso  → un único proveedor   `

Mantener histórico del proveedor/coste utilizado.

No sobrescribir costes históricos.

24\. FLUJO REAL DE INGRESO ACTUAL
=================================

Ejemplo descrito:

Llegan:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   20 prendas   `

Se crea un proceso.

Después:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   10 → K2  10 → K4   `

Se generan códigos.

Se imprimen etiquetas.

Se cortan manualmente.

Se introducen en las bolsas de las prendas.

Se envían a las sucursales.

Posteriormente puede completarse:

*   color;
    
*   talla.
    

25\. CARACTERIZACIÓN POSTERIOR
==============================

Actualmente puede ocurrir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ingreso  → codificación  → asignación  → impresión  → despacho  → sucursal completa color/talla   `

Idealmente, en un futuro:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ingreso  → área de despacho  → caracterización completa  → codificación  → etiquetado  → envío limpio a sucursal   `

Pero actualmente no necesariamente existe personal suficiente para centralizarlo.

El sistema debería soportar ambos flujos.

No imponer que toda información deba existir antes de crear una existencia.

26\. LOTE Y ANALÍTICA
=====================

Es importante conservar:

*   fecha de ingreso;
    
*   lote/proceso;
    
*   proveedor;
    
*   coste;
    
*   producto;
    
*   destino.
    

Porque después se desean responder preguntas como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Qué lote se vendió mejor?  ¿Qué prendas de este trimestre rotaron más?  ¿Qué debería volver a comprarse?  ¿Qué mercadería sigue inmovilizada?   `

Esto es relevante para BI/DWH.

27\. INVENTARIO
===============

El inventario no debe ser solamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.stock = 10   `

Debe permitir conocer:

*   qué hay;
    
*   dónde está;
    
*   cómo llegó;
    
*   qué movimientos ocurrieron;
    
*   qué se vendió;
    
*   qué se reservó;
    
*   qué se trasladó;
    
*   qué fue contado físicamente.
    

Principio:

> El histórico de movimientos importa tanto como la posición actual.

28\. UBICACIÓN VS ESTADO
========================

No confundir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Dónde está?   `

con:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿En qué estado está?   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ubicación:  K4  Estado:  Reservada   `

Otro:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ubicación:  Almacén Central  Estado:  Disponible para ecommerce   `

Esto debe modelarse separadamente.

29\. SUCURSALES
===============

Actualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1  K2  K3  K4   `

El sistema no debe tener columnas como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   stock_k1  stock_k2  stock_k3  stock_k4   `

Debe existir una entidad configurable equivalente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Sucursal / Ubicación   `

Agregar una nueva sucursal no debe requerir alterar la estructura de la BDD.

30\. DIFERENCIAS COMERCIALES ENTRE SUCURSALES
=============================================

Información previa del negocio:

K1 tiene tendencia más juvenil/colorida.

Colores como:

*   amarillo;
    
*   verde;
    
*   azul;
    

pueden funcionar mejor.

K2 tiene un perfil más elegante.

Colores como:

*   rosado;
    
*   borgoña;
    
*   marrón;
    

pueden vender mejor.

K1 y K2 están relativamente cerca y actualmente parte de la consulta de disponibilidad depende de la memoria del personal.

K3 funciona de manera algo más independiente.

K4 comparte varios modelos con otras sucursales.

Esto refuerza la necesidad de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Buscar código  → mostrar existencia por sucursal   `

31\. CONSULTA MULTISUCURSAL
===========================

Deseo funcional:

El vendedor escanea/busca:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Código X   `

y obtiene:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1: 0  K2: 1  K3: 0  K4: 2   `

Así puede decir al cliente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “Está disponible en K4.”   `

o:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “Podemos traerla.”   `

32\. MOVIMIENTOS ENTRE SUCURSALES
=================================

Las prendas se rotan frecuentemente.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1 → K4  K4 → K2   `

porque una prenda puede no vender en una sucursal y vender mejor en otra.

Esto NO debe manejarse sobrescribiendo simplemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   sucursal_id   `

sin historial.

Se requiere registrar movimiento.

33\. DOS ESCENARIOS DE MOVIMIENTO
=================================

Caso A — Movimiento temporal para concretar venta
-------------------------------------------------

Ejemplo:

Una prenda está en K2.

Un cliente está en K1.

Se lleva la prenda y se vende.

Podría conservarse el consumo del inventario de origen sin realizar una reasignación formal prolongada.

Flujo exacto pendiente de diseño.

Caso B — Reasignación real
--------------------------

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   10 prendas  K2 → K4   `

porque se pretende “probar suerte” en K4.

Aquí cambia la responsabilidad operativa.

Debe existir una reasignación formal.

34\. ORIGEN HISTÓRICO VS UBICACIÓN ACTUAL
=========================================

En conversaciones anteriores surgió la necesidad de preservar el origen inicial.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Asignada originalmente:  K4  Ubicación actual:  K1  Vendida:  K1   `

No necesariamente significa que la venta deba “pertenecer comercialmente” eternamente a K4.

Lo importante es conservar trazabilidad.

Conceptualmente pueden existir datos diferentes:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   asignacion_inicial  ubicacion_actual  sucursal_venta  historial_movimientos   `

La regla exacta de atribución comercial todavía requiere validación.

No hardcodear una regla fiscal/contable basándose únicamente en esta idea.

35\. ALMACÉN / DEPÓSITO
=======================

Este punto cambió durante la reunión y sigue abierto.

Inicialmente se pensó:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   activo = false   `

para representar prendas retiradas.

Después aparecieron necesidades adicionales:

*   enviar prendas al almacén;
    
*   recepción;
    
*   reporte de pendientes;
    
*   responsable;
    
*   inventario guardado;
    
*   venta online desde almacén;
    
*   recuperación posterior.
    

Por eso un simple booleano probablemente sea insuficiente.

36\. ALTERNATIVAS PARA ALMACÉN
==============================

A. Estado
---------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DISPONIBLE  ALMACENADA  RESERVADA  VENDIDA   `

B. Sububicación
---------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K4  ├── Piso de venta  └── Depósito   `

C. Ubicación logística
----------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1  K2  K3  K4  Almacén Central   `

D. Combinación de ubicación + estado
------------------------------------

Actualmente parece la alternativa conceptualmente más robusta.

Pero NO está formalmente cerrada.

37\. CONTROL FÍSICO DE INVENTARIO
=================================

Debe existir un proceso propio.

No es simplemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   editar stock   `

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Sesión de inventario  → escaneos  → conciliación  → diferencias  → cierre   `

38\. SESIÓN DE INVENTARIO
=========================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Control Inventario K4  Fecha:  X  Estado:  ABIERTO   `

Durante la sesión:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   escaneo  escaneo  escaneo  ...   `

Cada unidad serializada debería contarse una vez.

39\. ESCANEO DUPLICADO
======================

Si una existencia ya se registró en la sesión:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Código 000123   `

y se escanea de nuevo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Código 000123   `

advertir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ya contabilizado.   `

Esta es una de las razones principales del código individual de Karmylis.

40\. INVENTARIO DURANTE OPERACIÓN
=================================

El negocio no necesariamente puede cerrar completamente mientras se cuenta.

Puede ocurrir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Inicio conteo:  existencia está presente  Durante conteo:  se vende   `

El sistema debe poder distinguir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   esperado al inicio  escaneado  vendido durante sesión  trasladado durante sesión  diferencia real   `

No reiniciar necesariamente todo el inventario.

41\. REPORTE DE DIFERENCIAS
===========================

Objetivo:

No mostrar simplemente un listado enorme.

Mostrar principalmente anomalías.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Pantalón Baggy rojo M  Esperado: 3  Vendido durante conteo: 1  Encontrado: 1  Diferencia: 1   `

Después deben existir procesos de:

*   investigación;
    
*   ajuste;
    
*   autorización;
    
*   cierre.
    

Pendiente definir quién autoriza ajustes.

42\. MOVIMIENTO COMO HISTÓRICO
==============================

Principio provisional fuerte:

No modificar stock “porque sí”.

Las operaciones deberían generar eventos/movimientos equivalentes a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ENTRADA  VENTA  TRASLADO  RESERVA  LIBERACION_RESERVA  DEVOLUCION  AJUSTE_INVENTARIO  etc.   `

No es necesario implementar event sourcing.

Solo conservar trazabilidad suficiente.

43\. VENTAS
===========

Existe un módulo de ventas en el sistema anterior, pero no fue explotado completamente en producción.

Actualmente gran parte del proceso todavía depende de:

*   Excel;
    
*   cambios de estado;
    
*   registros históricos.
    

El sistema nuevo deberá integrar venta e inventario directamente.

44\. VENTA COMO TRANSACCIÓN
===========================

Una venta debería preservar:

*   fecha;
    
*   sucursal;
    
*   caja;
    
*   usuario/cajero;
    
*   cliente si corresponde;
    
*   asesor(es);
    
*   líneas;
    
*   código vendido;
    
*   precio histórico;
    
*   descuentos;
    
*   promociones;
    
*   pagos;
    
*   canal;
    
*   estado;
    
*   documento emitido;
    
*   auditoría.
    

45\. PRECIO HISTÓRICO
=====================

Nunca asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio actual del producto  =  precio al que se vendió hace 6 meses   `

DetalleVenta debe preservar el precio real utilizado.

Esto será importante para:

*   reportes;
    
*   márgenes;
    
*   promociones;
    
*   devoluciones;
    
*   BI.
    

46\. MULTICAJA
==============

Una sucursal puede tener N cajas.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K4  ├── Caja 1  ├── Caja 2  └── Caja 3   `

Las cajas pueden habilitarse de acuerdo con necesidad.

Ejemplo:

Si hay mucha gente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   abrir Caja 2   `

47\. CAJA ≠ USUARIO
===================

Muy importante.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Caja 1   `

es un punto operativo.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Alan  Nelson  Usuario X   `

son personas.

Durante el día:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Caja 1  09:00-15:00 → Alan  Caja 1  15:00-20:00 → Nelson   `

Sigue siendo Caja 1.

48\. SESIÓN DE CAJA
===================

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   SesionCaja  - caja  - usuario  - inicio  - fin  - fondo_inicial  - totales  - estado   `

No cerrar todavía nombres físicos de tablas.

49\. APERTURA DE CAJA
=====================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Caja 1  Usuario:  Alan  Cambio inicial:  1.000 Bs   `

El fondo inicial debe registrarse.

50\. CAMBIO DE TURNO
====================

Situación discutida:

Alan empieza:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   1.000 Bs   `

Vende:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   5.000 Bs   `

Al terminar podría entregar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   6.000 Bs   `

al siguiente cajero.

El nuevo usuario continúa en:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Caja 1   `

Se discutieron:

*   cierre parcial;
    
*   entrega;
    
*   continuidad;
    
*   cierre final.
    

Este flujo todavía requiere investigación de POS comerciales.

No cerrarlo apresuradamente.

51\. CIERRE DE CAJA
===================

Debe permitir obtener:

*   fondo inicial;
    
*   efectivo esperado;
    
*   ventas por método;
    
*   gastos;
    
*   ingresos;
    
*   diferencias;
    
*   usuario;
    
*   turno;
    
*   entrega;
    
*   saldo final.
    

Se considera posible diferenciar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Cierre de turno  Cierre final de caja  Cierre diario   `

Pendiente formalizar.

52\. MÉTODOS DE PAGO CONFIGURABLES
==================================

Ejemplos actuales:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Efectivo  Tarjeta  Transferencia  QR  Tigo Money  Gift Card   `

No hardcodearlos como enum inmutable si se espera flexibilidad.

Podría existir concepto equivalente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   metodo_pago   `

configurable por empresa.

53\. PAGOS MIXTOS
=================

Una venta puede combinar métodos.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Total:  900 Bs  Tarjeta:  400  Efectivo:  500   `

Por tanto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta  1 → N Pagos   `

conceptualmente.

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   venta.tipo_pago   `

como único valor.

54\. EFECTIVO Y CAMBIO
======================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Total:  956  Recibido:  1.000  Cambio:  44   `

La interfaz POS debe calcularlo.

55\. QR PERSONALES / CUENTAS PERSONALES
=======================================

Actualmente puede ocurrir que cajeros utilicen QR asociados a cuentas personales y luego liquiden el dinero.

Esto genera preguntas:

*   auditoría;
    
*   conciliación;
    
*   fiscalización;
    
*   responsabilidades;
    
*   cierre;
    
*   trazabilidad.
    

No hay solución cerrada.

Debe investigarse cómo formalizarlo y si el proceso debería cambiar.

56\. GASTOS
===========

Durante una sesión pueden registrarse gastos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   almuerzo  desayuno  té  refresco  Internet  etc.   `

Los tipos cambian.

Por tanto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   tipo_gasto   `

debería ser configurable.

57\. GASTO DE CAJA
==================

Información posible:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   tipo  monto  descripcion  fecha  usuario  sucursal  caja  comprobante   `

Debe afectar conciliación/cierre según política.

No todos los gastos necesariamente pertenecen a una caja específica.

Ejemplo:

Internet mensual.

Esto debe modelarse con cuidado.

58\. ASESORES / VENDEDORES
==========================

Debe conocerse quién atendió la venta.

Caso normal:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta  Asesor:  Nelson   `

59\. VARIOS ASESORES EN UNA SOLA VENTA
======================================

Caso real:

Una familia compra 5 prendas.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   3 → asesor Nelson  2 → asesor Alan   `

Pero el cliente paga todo junto.

Por tanto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta  └── líneas      ├── asesor A      ├── asesor A      ├── asesor A      ├── asesor B      └── asesor B   `

UX recomendada:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Asignar asesor general   `

y permitir override por línea.

60\. RESERVAS
=============

Funcionalidad importante.

Una cliente puede apartar una prenda.

La prenda deja de estar disponible para venta normal.

Se guarda físicamente.

Se genera voucher.

61\. INFORMACIÓN DE RESERVA
===========================

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Reserva  - ID  - cliente  - vendedor  - fecha  - fecha_recojo  - anticipo  - saldo  - estado   `

y líneas:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   prendas reservadas   `

62\. ANTICIPO
=============

Hubo información contradictoria.

En conversaciones anteriores se indicó que normalmente una reserva tenía al menos aproximadamente 50% pagado.

En la reunión más reciente se dieron ejemplos como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   20 Bs  30 Bs   `

Por tanto:

**NO hardcodear 50%.**

La política de anticipo debe validarse.

Posiblemente configurable.

63\. FECHA DE RESERVA
=====================

Se habló de un límite aproximado de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   2 semanas   `

pero la clienta puede indicar una fecha anterior.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   máximo permitido:  15 días  cliente:  retira lunes   `

El sistema puede sugerir fecha máxima y permitir fecha acordada dentro de política.

64\. ALERTAS DE RESERVA
=======================

Se necesitan avisos de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   reservas próximas a vencer  reservas vencidas   `

Para que personal contacte al cliente.

65\. HISTORIAL DE CONTACTO
==========================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   14/08 llamada  16/08 llamada  18/08 WhatsApp   `

Después de varios intentos se podría cancelar/liberar.

No borrar la historia.

66\. CANCELACIÓN DE RESERVA
===========================

Al cancelarse:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   prenda  → vuelve a disponibilidad   `

si corresponde.

Debe quedar registro de:

*   quién;
    
*   cuándo;
    
*   motivo.
    

67\. STOCK RESERVADO
====================

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   fisico = 5  reservado = 2  disponible = 3   `

La reserva reduce disponibilidad.

No necesariamente reduce inmediatamente existencia física.

Al concretar venta:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   fisico - 1  reservado - 1   `

Al cancelar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   fisico igual  reservado - 1   `

Este modelo sigue siendo conceptualmente válido.

68\. DEVOLUCIONES
=================

Se identificó diferencia entre:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ANULACION   `

y:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DEVOLUCION   `

69\. ANULACIÓN
==============

Ejemplo:

Venta realizada hace unas horas y se detecta error.

Puede revertirse como anulación.

Pero NO debería hacerse:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DELETE venta   `

Debe quedar historial.

70\. DEVOLUCIÓN POSTERIOR
=========================

Una venta de días anteriores requiere un proceso formal.

Debe:

*   conservar venta original;
    
*   registrar devolución;
    
*   regresar inventario cuando corresponda;
    
*   afectar ingresos/reportes;
    
*   registrar reembolso;
    
*   registrar motivo.
    

71\. PLAZO DE DEVOLUCIÓN
========================

Se habló como ejemplo de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   5 días   `

También se mencionaron empresas que permiten:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   15  30 días   `

No es una regla cerrada.

Debería ser política configurable.

72\. REEMBOLSO
==============

Se propuso evitar sacar dinero directamente de la caja del día.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   cliente llena formulario  → deja cuenta bancaria  → reembolso posterior   `

Esto es una propuesta operativa, no una regla definitiva.

Debe estudiarse.

73\. GIFT CARDS
===============

Se desea permitir gift cards.

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   GiftCard  - codigo  - saldo_inicial  - saldo_actual  - fecha_emision  - estado   `

Debe poder habilitarse para uso entre sucursales según política.

Los consumos requieren histórico.

74\. PROMOCIONES
================

No deben reducirse a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.descuento = 20%   `

Se habló de campañas más flexibles.

75\. TIPOS DE PROMOCIÓN MENCIONADOS
===================================

Ejemplos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   10%  15%  20%  50%   `

Aplicables a:

*   prendas seleccionadas;
    
*   grupos;
    
*   rangos de códigos;
    
*   sucursales;
    
*   campañas.
    

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   códigos <= 50000  → 50% descuento   `

76\. PROMOCIONES Y ETIQUETAS
============================

El sistema anterior contemplaba diferentes colores visuales de etiqueta según descuento.

Ejemplos mencionados:

*   amarillo;
    
*   naranja;
    
*   celeste;
    
*   rojo.
    

Esto permitiría una campaña visual similar a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   etiqueta roja  → descuento X   `

Esta idea nunca se explotó completamente.

Puede reconsiderarse.

77\. PRECIO VS PROMOCIÓN
========================

No modificar necesariamente permanentemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio_venta   `

cuando existe campaña.

Mejor conceptualmente distinguir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio base  regla/promoción  precio aplicado   `

Y preservar en venta:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio histórico final  descuento aplicado   `

78\. E-COMMERCE
===============

La tienda online será propia.

No se planea que Karmylis dependa de:

*   WooCommerce;
    
*   PrestaShop.
    

Estas plataformas se estudian como referencia.

La tienda online formará parte del ecosistema propio.

79\. INVENTARIO MULTICANAL
==========================

Principio fundamental:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   INVENTARIO CENTRAL  │  ├── POS K1  ├── POS K2  ├── POS K3  ├── POS K4  └── Ecommerce   `

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   inventario ERP  +  inventario tienda web separado  +  sincronización manual   `

80\. PUBLICACIÓN ONLINE
=======================

No todos los artículos del ERP deben aparecer automáticamente online.

Debe existir una política equivalente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   publicado_online   `

o sistema más general de canales.

A futuro sería mejor pensar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Canal:  POS  Web  Marketplace  ...   `

pero no sobrearquitecturar aún.

81\. DISPONIBILIDAD EN LA TIENDA ONLINE
=======================================

Se discutió mostrar algo parecido a farmacias:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto X  Disponible:  K1 ✓  K2 ✗  K3 ✓  K4 ✓   `

Incluso el cliente podría seleccionar una ubicación.

Esto requiere definir después:

*   reserva de stock web;
    
*   fulfillment;
    
*   retiro;
    
*   envío;
    
*   sucursal responsable;
    
*   stock online.
    

82\. POS + ECOMMERCE CONCURRENCIA
=================================

En el futuro puede ocurrir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Última unidad  Cliente A → POS  Cliente B → ecommerce   `

El sistema deberá evitar sobreventa.

Esto implica:

*   transacciones;
    
*   locking/estrategia de concurrencia;
    
*   reserva de stock;
    
*   estados de pedido.
    

Diseñar después de definir flujo de checkout.

83\. FACTURACIÓN FISCAL — CONTEXTO
==================================

Existe una preocupación real debido a que las sucursales aparentemente podrían operar bajo diferentes NIT.

Esto todavía debe confirmarse formalmente.

No asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1/K2/K3/K4 = mismo contribuyente   `

ni:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K1/K2/K3/K4 = NIT diferente cada una   `

hasta revisar información real.

84\. SUCURSAL OPERATIVA ≠ EMISOR FISCAL
=======================================

Si existen NIT diferentes, debe separarse conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Sucursal / ubicación operacional   `

de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Entidad / emisor fiscal   `

Ejemplo futuro:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta:  sucursal_operativa = K4  emisor_fiscal = NIT_X   `

La regla debe definirse con:

*   administración;
    
*   contador;
    
*   normativa SIN.
    

85\. CUIS / CUFD
================

Alan inicialmente pensó que si el ERP es un solo sistema, quizá el SIN le asignaría un único CUIS.

Corrección conceptual:

Si el ERP NO emite facturas directamente al SIN, el ERP no necesita gestionar directamente CUIS/CUFD.

Puede integrarse con otro sistema de facturación.

Escenario A
-----------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP  → registra venta  → sistema externo factura   `

ERP no implementa directamente todo SIAT.

Escenario B
-----------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP  → genera/emite factura  → SIN   `

Entonces el ERP o módulo de facturación debe manejar contexto fiscal.

Si existen diferentes contribuyentes/puntos fiscales, deben mantenerse credenciales/contextos correspondientes.

86\. FACTURACIÓN NO DEBE DOMINAR EL ERP
=======================================

Recomendación:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Núcleo ERP          │          └── Módulo/Adaptador fiscal                  │                  └── SIN / proveedor fiscal   `

No mezclar reglas fiscales profundamente con inventario/producto.

Esto permite:

*   cambios normativos;
    
*   otros países;
    
*   distintos proveedores;
    
*   futura expansión SaaS.
    

87\. NO CONFUNDIR MULTITENENCIA CON MULTIEMISOR FISCAL
======================================================

Son problemas diferentes.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   multitenant  → varias empresas clientes del SaaS   `

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   multiemisor fiscal  → distintos contextos/NIT para emisión fiscal   `

No usar “multitenencia fiscal” como término general.

88\. BI / DATA WAREHOUSE
========================

Existe interés explícito en análisis de negocio.

No se quiere únicamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   reporte ventas del día   `

Sino poder decidir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Compro blusas o chompas?  ¿Qué lote tuvo mejor rotación?  ¿Qué sucursal vende mejor X?   `

89\. DATOS IMPORTANTES PARA ANALÍTICA
=====================================

El OLTP debe conservar correctamente:

*   fechas;
    
*   productos;
    
*   variantes;
    
*   existencias;
    
*   sucursal;
    
*   ingresos;
    
*   lotes;
    
*   proveedores;
    
*   costes históricos;
    
*   precios históricos;
    
*   promociones;
    
*   vendedores;
    
*   clientes cuando corresponda;
    
*   devoluciones;
    
*   movimientos;
    
*   reservas;
    
*   canal.
    

Si esos datos se pierden en el ERP:

> el DWH no podrá inventarlos después.

90\. MÉTRICAS DESEADAS
======================

Ejemplos:

*   ventas por sucursal;
    
*   ventas por canal;
    
*   ventas por vendedor;
    
*   productos top;
    
*   productos lentos;
    
*   rotación;
    
*   stock aging;
    
*   margen;
    
*   ticket promedio;
    
*   tallas más vendidas;
    
*   colores más vendidos;
    
*   conversión reserva → venta;
    
*   rendimiento por lote;
    
*   rendimiento por proveedor;
    
*   stockouts;
    
*   promociones efectivas;
    
*   disponibilidad por sucursal.
    

91\. HISTÓRICO ACADÉMICO BI KARMYLIS
====================================

Alan ya trabajó Karmylis anteriormente como caso de Data Warehouse.

Modelo estrella conceptual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Hecho:  Ventas  Dimensiones:  Tiempo  Sucursal  Producto   `

También se trabajaron:

*   KPI mensual;
    
*   ingresos;
    
*   top prendas;
    
*   clientes VIP.
    

Este antecedente puede reutilizarse más adelante, pero el nuevo ERP debe diseñarse primero como OLTP correcto.

92\. NO CONSTRUIR DWH AHORA MISMO
=================================

Fase actual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP operacional   `

Más adelante:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ETL/ELT  → DWH  → dashboards   `

No convertir todas las consultas operativas en arquitectura analítica compleja desde el inicio.

93\. IA EN KARMYLIS — IDEA FUTURA
=================================

En conversaciones anteriores se exploró agregar IA para stakeholders/administradores.

Idea:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP  +  asistente interno   `

Que pueda responder:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Qué productos tuvieron menor rotación este mes?  ¿Qué sucursal necesita reposición?  ¿Qué tallas se están agotando?   `

La IA debería consultar datos autorizados.

No “entrenarse” permanentemente con información confidencial.

No tener memoria arbitraria del negocio.

Usar:

*   APIs;
    
*   consultas controladas;
    
*   permisos;
    
*   RAG/contexto;
    
*   herramientas.
    

La IA NO forma parte del núcleo inmediato del ERP.

No debe distraer del dominio básico.

94\. SOAA / MULTIAGENTES
========================

Alan trabajó anteriormente un prototipo académico SOAA con:

*   LangGraph;
    
*   FastAPI;
    
*   agentes;
    
*   GPT.
    

Ese sistema NO debe mezclarse automáticamente con Karmylis.

La arquitectura multiagente no es requisito actual.

95\. REFERENCIAS ESTUDIADAS — WooCommerce
=========================================

WooCommerce funciona sobre WordPress.

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   registro_principal   `

puede almacenar distintos tipos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   PUBLICACION  PAGINA  PRODUCTO  VARIANTE   `

Producto y variante históricamente utilizan la misma estructura genérica (posts) diferenciada por tipo y relación padre/hijo.

96\. WooCommerce — DATOS EXTRA
==============================

WooCommerce utiliza metadatos genéricos.

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   dato_extra_registro  registro 101  precio → 335  stock → 4  codigo → X  ...   `

Esto se parece conceptualmente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   {    "precio": 335,    "stock": 4  }   `

pero distribuido en registros clave/valor.

WooCommerce heredó esa decisión de WordPress.

No necesariamente es un diseño ideal para un ERP construido desde cero.

97\. WooCommerce — TÉRMINOS Y TAXONOMÍAS
========================================

WooCommerce/WordPress utiliza una estructura genérica de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   término  taxonomía  relación   `

Para cosas como:

*   categorías;
    
*   tags;
    
*   atributos globales.
    

Ejemplo conceptual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisas  → categoría  Negro  → atributo color  M  → atributo talla   `

Las relaciones NO crean automáticamente variantes.

La lógica de aplicación crea la variante.

98\. CONCLUSIÓN SOBRE WooCommerce
=================================

WooCommerce es valioso para estudiar:

*   flexibilidad;
    
*   plugins;
    
*   taxonomías;
    
*   producto padre/variaciones;
    
*   compromises de estructuras genéricas.
    

Pero NO es la referencia principal para diseñar Karmylis.

99\. REFERENCIA — PrestaShop
============================

PrestaShop separa conceptos de e-commerce más explícitamente.

Versión conceptual traducida:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto  categoria  producto_categoria  atributo_tipo  atributo_valor  variante  variante_atributo  caracteristica_tipo  caracteristica_valor  producto_caracteristica  inventario   `

100\. PRODUCTO PrestaShop
=========================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa de Tela Slimfit   `

Representa el modelo general.

101\. CATEGORÍA PrestaShop
==========================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ropa  └── Hombre      └── Camisas   `

La categoría:

*   clasifica;
    
*   organiza;
    
*   filtra.
    

NO genera variante.

102\. ATRIBUTOS PrestaShop
==========================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color:  Negro  Blanco  Talla:  M  L   `

Estos valores pueden formar combinaciones.

103\. COMBINACIONES / VARIANTES PrestaShop
==========================================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Negro + M  Negro + L  Blanco + M  Blanco + L   `

Cada combinación puede tener:

*   referencia;
    
*   precio;
    
*   código;
    
*   stock.
    

104\. CARACTERÍSTICAS PrestaShop
================================

PrestaShop diferencia:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ATRIBUTO  → puede generar variante   `

de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CARACTERÍSTICA  → describe   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color Negro  Talla M  → variante   `

Mientras:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Material Algodón  Corte Slimfit  → descripción   `

No necesariamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Algodón / Slimfit / Negro / M   `

como combinación.

Esta distinción es útil conceptualmente.

105\. PrestaShop VS WooCommerce
===============================

Versión simplificada:

WooCommerce:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “Muchos conceptos se representan mediante estructuras genéricas.”   `

PrestaShop:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “Los conceptos comerciales tienen estructuras más específicas.”   `

Para aprendizaje del modelo de datos, PrestaShop resultó más comprensible.

106\. HERENCIA
==============

Se preguntó si estos sistemas utilizaban herencia de BDD.

Conclusión:

No considerar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto  → subclase Variante   `

como herencia relacional formal.

Normalmente es:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto 1  → N Variantes   `

La variante reutiliza datos del producto padre conceptualmente.

WooCommerce se parece visualmente a “single-table inheritance” porque producto y variante comparten una tabla genérica, pero técnicamente es un sistema genérico de tipos de registros y relación padre/hijo.

PrestaShop utiliza tablas separadas.

107\. ODOO — REFERENCIA MUY IMPORTANTE
======================================

Odoo probablemente es una referencia más cercana al problema real de Karmylis porque no es solamente e-commerce.

Integra:

*   producto;
    
*   variantes;
    
*   inventario;
    
*   ventas;
    
*   compras;
    
*   POS;
    
*   e-commerce;
    
*   operaciones.
    

Concepto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Product Template  → Product Variant   `

Traducido:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto_modelo  → articulo_vendible   `

108\. SHOPIFY — REFERENCIA
==========================

Shopify es útil para estudiar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Product  Options  Option Values  Variants   `

Y especialmente:

*   contratos API;
    
*   UX administrativa;
    
*   canales;
    
*   productos/variantes.
    

No usarlo para adivinar su BDD interna.

109\. MEDUSA — REFERENCIA
=========================

Medusa es interesante por separación modular:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Catálogo  Inventario  Precios  Canales   `

Esto evita que:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto   `

termine conteniendo todo.

Idea relevante para Karmylis.

110\. MAGENTO / ADOBE COMMERCE
==============================

Magento utiliza extensivamente modelos dinámicos tipo EAV.

Es útil para estudiar:

*   atributos arbitrarios;
    
*   conjuntos de atributos;
    
*   flexibilidad.
    

Pero también demuestra el coste:

*   complejidad;
    
*   muchas relaciones;
    
*   indexadores;
    
*   consultas más difíciles.
    

No adoptarlo automáticamente.

111\. ORDEN ACTUAL DE REFERENCIAS
=================================

Para el dominio Karmylis:

1.  Odoo — ERP y producto/variante/operación.
    
2.  Medusa — modularidad.
    
3.  PrestaShop — claridad relacional de catálogo.
    
4.  Shopify — API/UX/canales.
    
5.  WooCommerce — flexibilidad y taxonomías.
    
6.  Magento — atributos dinámicos/EAV como caso avanzado.
    

ERPNext también puede estudiarse posteriormente como ERP open source de contraste.

112\. PROTOTIPO EDUCATIVO ANTIGRAVITY
=====================================

Se creó un prototipo para entender el modelo PrestaShop de manera visual.

Objetivo:

NO construir Karmylis final.

Objetivo:

comprender:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto  Categoría  Atributo  Valor  Variante  Inventario   `

113\. VISTAS DEL PROTOTIPO
==========================

Se solicitó:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Admin  Tienda online  Explorador de BDD   `

La idea era que cambios en Admin aparecieran en Storefront.

También un modo educativo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “¿De dónde salen estos datos?”   `

para mostrar qué relaciones producen una pantalla.

114\. PROTOTIPO DE CATEGORÍAS
=============================

Ya existe una interfaz donde:

*   se crean categorías;
    
*   se selecciona categoría padre;
    
*   se visualiza jerarquía.
    

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ropa  ├── Hombre  │   └── Camisas  └── Mujer      └── Chompas   `

Se detectó una validación necesaria:

Una categoría:

*   no puede ser padre de sí misma;
    
*   no puede elegir como padre a un descendiente.
    

115\. ESTE PROTOTIPO NO DEFINE LA BDD FINAL
===========================================

Es una herramienta de aprendizaje.

No tomar su estructura automáticamente como producción.

116\. BASE DE DATOS — MySQL VS PostgreSQL
=========================================

Don Nelson mostró cierta inclinación/interés por MySQL debido a:

*   WooCommerce;
    
*   PrestaShop;
    
*   ecosistema tradicional PHP/e-commerce.
    

Alan inicialmente defendió PostgreSQL mencionando “muchos datos”.

Corrección:

> El volumen esperado por sí solo NO justifica PostgreSQL.

Ambos motores pueden manejar perfectamente volúmenes mucho mayores.

117\. MySQL
===========

Ventajas:

*   maduro;
    
*   estable;
    
*   ampliamente utilizado;
    
*   excelente ecosistema PHP;
    
*   WooCommerce/WordPress;
    
*   PrestaShop;
    
*   InnoDB;
    
*   ACID;
    
*   MVCC;
    
*   transacciones;
    
*   foreign keys;
    
*   JSON;
    
*   replicación.
    

No tratar MySQL como tecnología inferior.

118\. PostgreSQL
================

Ventajas relevantes para este proyecto:

*   fuerte integridad relacional;
    
*   buen manejo de concurrencia;
    
*   JSONB;
    
*   índices GIN/GiST/BRIN/parciales/expresiones;
    
*   Row Level Security;
    
*   consultas avanzadas;
    
*   extensibilidad;
    
*   familiaridad previa de Alan.
    

Alan ya utilizó PostgreSQL/PostGIS en un proyecto de geocercas.

119\. JSONB Y PostgreSQL
========================

Si se utiliza el enfoque:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   relacional  +  documentos flexibles   `

PostgreSQL es especialmente atractivo.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   datos_adicionales JSONB   `

con posibilidades de:

*   consultas;
    
*   containment;
    
*   índices GIN.
    

Esto NO significa que MySQL no pueda manejar JSON.

MySQL también ofrece:

*   JSON;
    
*   funciones;
    
*   índices mediante expresiones/columnas generadas.
    

120\. RLS Y MULTITENANCY
========================

PostgreSQL permite Row Level Security.

Ejemplo shared-schema:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto  id  empresa_id  nombre   `

Aplicación:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   usuario pertenece a empresa 10   `

Política:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   solo filas empresa_id = 10   `

Esto puede actuar como segunda barrera.

Pero:

*   no reemplaza seguridad de aplicación;
    
*   no obliga a usar shared-schema;
    
*   no debe decidirse todavía.
    

121\. DECISIÓN ACTUAL SOBRE MOTOR
=================================

PostgreSQL es actualmente el candidato preferido.

Pero NO está irrevocablemente cerrado.

Argumento adecuado:

> PostgreSQL parece encajar bien por integridad, JSONB, herramientas de indexación y posible RLS para SaaS, pero si el equipo tiene mucha más experiencia operativa con MySQL y las necesidades no justifican características específicas de PostgreSQL, MySQL sigue siendo una opción perfectamente válida.

122\. WooCommerce/PrestaShop NO OBLIGAN MySQL EN EL ERP
=======================================================

Ellos utilizan MySQL/MariaDB porque su arquitectura/ecosistema fue construido así.

Karmylis está desarrollando un sistema propio.

Puede usar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP PostgreSQL   `

aunque eventualmente se integre con:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   WooCommerce MySQL   `

mediante API.

123\. STACK TECNOLÓGICO — EVOLUCIÓN
===================================

Se han considerado distintas opciones.

Versiones antiguas propusieron:

*   Node/Express;
    
*   FastAPI;
    
*   Flutter;
    
*   Google Sheets.
    

Estas fueron útiles durante exploración.

No considerarlas decisión actual.

124\. STACK ACTUAL CANDIDATO
============================

La combinación discutida más recientemente y coherente con el contexto de Don Nelson:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Backend:  Laravel  Frontend:  Vue 3 + TypeScript  BDD:  PostgreSQL  Arquitectura:  Monolito modular  Estilo:  Hexagonal / Clean boundaries   `

No está completamente congelado.

125\. ¿POR QUÉ LARAVEL?
=======================

Posibles ventajas:

*   ecosistema robusto;
    
*   autenticación;
    
*   validación;
    
*   ORM;
    
*   migrations;
    
*   jobs;
    
*   queues;
    
*   testing;
    
*   experiencia web;
    
*   comunidad;
    
*   mantenibilidad.
    

Alan tiene cierta exposición previa a Laravel.

126\. ¿POR QUÉ Vue?
===================

*   frontend moderno;
    
*   relativamente accesible;
    
*   buena integración con Laravel;
    
*   TypeScript;
    
*   UX administrativa;
    
*   SPA o híbrido.
    

Don Nelson quiere ver creatividad de frontend.

127\. ARQUITECTURA
==================

No microservicios inicialmente.

Propuesta:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   MONOLITO MODULAR   `

Módulos/bounded contexts aproximados:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Organización  Catálogo  Abastecimiento  Inventario  Ventas  Caja  Reservas  Promociones  Devoluciones  Canales  Fiscal  Reportes   `

Cada módulo con límites claros.

128\. ARQUITECTURA HEXAGONAL
============================

Objetivo:

Que la lógica principal no dependa directamente de:

*   PostgreSQL;
    
*   Laravel;
    
*   lector de códigos;
    
*   proveedor fiscal;
    
*   ecommerce.
    

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Dominio  → puertos  → adaptadores   `

Pero NO convertir cada CRUD sencillo en 15 clases por dogma.

Aplicar pragmáticamente.

129\. EVENTOS / OUTBOX / CQRS
=============================

Se discutieron como conceptos futuros.

No implementar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Event Sourcing  CQRS completo  Kafka  microservicios   `

sin necesidad real.

Eventos pueden ser útiles para:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   VentaConfirmada  → inventario  → analytics  → notificación   `

pero se pueden introducir progresivamente.

Outbox tiene sentido cuando aparezcan integraciones críticas/asíncronas.

No anticiparlo en todo.

130\. API
=========

Puede existir una API interna limpia.

OpenAPI es recomendable.

Especialmente porque:

*   admin web;
    
*   POS;
    
*   tienda online;
    
*   futuras apps;
    
*   integraciones;
    

podrían compartir backend.

131\. SEGURIDAD
===============

Principios:

*   contraseñas hasheadas;
    
*   secretos fuera del repositorio;
    
*   HTTPS;
    
*   usuarios individuales;
    
*   auditoría;
    
*   roles;
    
*   backups;
    
*   logging;
    
*   staging;
    
*   permisos.
    

No guardar:

*   tokens;
    
*   certificados;
    
*   claves fiscales;
    

en texto plano.

132\. AUDITORÍA
===============

El sistema Excel/legacy permite situaciones donde datos históricos pueden modificarse fácilmente.

El nuevo ERP debería preservar acciones importantes.

Ejemplos:

*   ingreso;
    
*   venta;
    
*   traslado;
    
*   devolución;
    
*   reserva;
    
*   ajuste.
    

No deben desaparecer mediante DELETE silencioso.

133\. ANULACIÓN / COMPENSACIÓN
==============================

En operaciones confirmadas:

Preferir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   anular  revertir  ajustar   `

con:

*   actor;
    
*   fecha;
    
*   motivo.
    

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DELETE FROM venta   `

sin registro.

134\. TRANSACCIONES
===================

Operaciones críticas deben ser atómicas.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta  +  stock  +  pago   `

No permitir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta guardada  pero stock no actualizado   `

por error parcial.

135\. IDEMPOTENCIA
==================

Operaciones como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Confirmar ingreso  Confirmar venta   `

no deberían poder ejecutarse accidentalmente dos veces.

Especialmente importante con:

*   APIs;
    
*   ecommerce;
    
*   redes inestables.
    

136\. INTERFAZ / UX
===================

Don Nelson enfatizó explícitamente:

> el frontend debe ser amigable.

No se busca únicamente diseño bonito.

Principios:

*   pocos pasos;
    
*   claridad;
    
*   responsive;
    
*   escaneo;
    
*   búsqueda rápida;
    
*   errores claros;
    
*   confirmaciones;
    
*   tareas.
    

137\. INTERFAZ BASADA EN TAREAS
===============================

No menú técnico como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Entidades  MovimientoInventario  DetalleVenta   `

Para usuario operativo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Vender  Ingresar mercadería  Consultar inventario  Reservar  Mover prendas  Abrir caja  Contar inventario   `

138\. DOS NIVELES DE REGISTRO
=============================

Puede ser útil:

Registro rápido
---------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   código  descripción  precio  cantidad   `

Completar información
---------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   foto  atributos  categoría  descripción enriquecida  publicación online   `

Esto respeta que Karmylis no siempre tiene tiempo de llenar catálogos perfectos.

139\. ESCANEO
=============

El escaneo es una capacidad central.

Debe evaluarse:

*   lector USB;
    
*   Bluetooth;
    
*   cámara móvil/tablet;
    
*   códigos actuales;
    
*   velocidad;
    
*   ergonomía.
    

No diseñar flujo que requiera teclear códigos largos continuamente.

140\. MIGRACIÓN DESDE EXCEL
===========================

Existe información histórica en Excel.

Proceso recomendado conceptualmente:

1.  conservar copia intacta;
    
2.  analizar calidad;
    
3.  detectar duplicados;
    
4.  normalizar códigos;
    
5.  cargar catálogos;
    
6.  crear existencias;
    
7.  crear stock inicial mediante movimientos;
    
8.  comparar totales;
    
9.  validar muestra física;
    
10.  congelar Excel cuando comience operación oficial.
    

No importar basura sin limpieza.

141\. NOMENCLATURA DE TABLAS
============================

Don Nelson mencionó una convención antigua del tipo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   TBL_EM_...   `

por ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   TBL  +  iniciales  +  ID   `

Esto NO está confirmado como requisito.

Debe preguntarse si:

*   es una preferencia;
    
*   una convención obligatoria;
    
*   o solo explicación del sistema anterior.
    

No imponerla automáticamente.

142\. METODOLOGÍA
=================

Alan no quiere saltar directamente a código.

Orden preferido:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   1. Comprender dominio  2. Levantamiento  3. Reglas  4. Procesos  5. Modelo conceptual  6. Modelo lógico  7. MER  8. Prototipos  9. Implementación incremental   `

143\. SCRUM / KANBAN
====================

Don Nelson preguntó por Scrum.

Para un equipo pequeño y dominio todavía cambiante:

Recomendación:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   descubrimiento  +  iteraciones cortas  +  Kanban / Scrum ligero   `

No fingir Scrum completo si no existe:

*   equipo formal;
    
*   PO;
    
*   ceremonias;
    
*   sprints estables.
    

Lo importante es:

*   backlog;
    
*   prioridades;
    
*   demos;
    
*   feedback;
    
*   iteración.
    

144\. SPRINTS / INCREMENTOS CONCEPTUALES
========================================

Una secuencia posible, NO definitiva:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Incremento 1  Configuración + usuarios + sucursales  Incremento 2  Catálogo + atributos + códigos  Incremento 3  Ingresos + existencias + inventario  Incremento 4  Control físico + movimientos  Incremento 5  Caja + ventas  Incremento 6  Reservas + promociones + devoluciones  Incremento 7  Multisucursal  Incremento 8  Ecommerce   `

Pero el orden puede cambiar según prioridades de Karmylis.

145\. NO SOBREDISEÑAR EL SaaS AHORA
===================================

Evitar implementar ya:

*   billing SaaS;
    
*   planes;
    
*   self-service signup;
    
*   tenant provisioning automático;
    
*   tenant routing avanzado;
    
*   custom domains;
    
*   enterprise SLA;
    
*   marketplace;
    
*   microservicios.
    

Primero validar el ERP.

146\. PERO DISEÑAR CON GENERALIZACIÓN
=====================================

Evitar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   stock_k1  stock_k2   `

Preferir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ubicacion  inventario   `

Evitar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.color  producto.talla   `

como única estructura.

Preferir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   atributos configurables   `

Evitar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   metodo_pago enum fijo   `

Preferir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   configuración   `

147\. QUÉ DEBE SER FLEXIBLE EN EL FUTURO SaaS
=============================================

Candidatos fuertes:

*   atributos;
    
*   valores;
    
*   categorías;
    
*   profundidad de categorías;
    
*   reglas de codificación;
    
*   modo de inventario;
    
*   tipos de ubicación;
    
*   métodos de pago;
    
*   tipos de gasto;
    
*   roles;
    
*   permisos;
    
*   política de reservas;
    
*   política de devoluciones;
    
*   precios;
    
*   promociones;
    
*   canales;
    
*   publicación online;
    
*   módulos habilitados.
    

148\. QUÉ DEBE SER MÁS ESTABLE
==============================

Conceptos nucleares:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Organización/Empresa  Usuario  Ubicación/Sucursal  Producto  Entidad vendible  Inventario  Movimiento  Venta  DetalleVenta  Caja  SesionCaja  Pago  Auditoría   `

No significa que estas tablas ya estén diseñadas.

Significa que estos conceptos parecen generalizables.

149\. CAPACIDADES OPCIONALES DEL SaaS
=====================================

Posibles módulos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Reservas  Gift Cards  Ecommerce  Control serializado  Compras  Devoluciones  Promociones  Facturación  BI   `

Una empresa podría habilitar/deshabilitar módulos.

150\. CAPAS CONCEPTUALES RECOMENDADAS
=====================================

Para razonar sin mezclar todo:

1\. Invariantes
---------------

Ejemplos:

*   una venta confirmada conserva sus valores históricos;
    
*   stock no cambia sin trazabilidad;
    
*   operaciones de un tenant no deben afectar otro;
    
*   IDs externos no deben confundirse con IDs internos.
    

2\. Capacidades núcleo
----------------------

*   catálogo;
    
*   inventario;
    
*   ventas;
    
*   usuarios;
    
*   ubicaciones.
    

3\. Capacidades opcionales
--------------------------

*   reservas;
    
*   transferencias;
    
*   gift cards;
    
*   ecommerce.
    

4\. Políticas configurables
---------------------------

*   plazos;
    
*   aprobaciones;
    
*   atributos;
    
*   métodos;
    
*   códigos.
    

5\. Extensiones específicas
---------------------------

*   SIN Bolivia;
    
*   conectores;
    
*   migraciones.
    

151\. ORGANIZATION\_ID EN TODAS LAS TABLAS
==========================================

No asumir automáticamente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   organization_id   `

en absolutamente todo.

Primero definir estrategia de ownership/tenancy.

Algunas tablas pueden ser:

*   globales;
    
*   compartidas;
    
*   tenant-owned;
    
*   derivadas.
    

La separación conceptual debe diseñarse conscientemente.

152\. UUID EN TODAS LAS TABLAS
==============================

Tampoco es requisito.

Puede utilizarse:

*   bigint;
    
*   UUID;
    
*   ULID;
    

según necesidades.

No adoptar UUID por moda.

153\. INVENTORY\_POSITION.ORIGIN\_BRANCH
========================================

Anteriormente se propuso algo como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   inventario  branch_id  origin_branch_id   `

Pero puede ser problemático si una posición agrega unidades provenientes de diferentes orígenes.

La procedencia histórica encaja mejor en:

*   unidad física;
    
*   lote;
    
*   movimiento;
    
*   asignación inicial.
    

No consolidar origen incorrectamente en un saldo agregado.

154\. FOTOS
===========

Existe necesidad de incorporar fotos.

No necesariamente cada existencia física necesita una imagen.

Posibilidad:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   foto de producto/modelo   `

y, cuando tenga sentido:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   foto de variante   `

Karmylis actualmente no registra fotos sistemáticamente porque es mucho trabajo.

UX debe facilitarlo, no convertirlo en obstáculo para registrar mercadería.

155\. PROVEEDOR Y PRODUCTO
==========================

Un mismo artículo puede provenir de proveedores distintos.

Por tanto no asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.proveedor_id   `

como única verdad histórica.

El proveedor real de una llegada pertenece mejor al ingreso/detalle/lote.

Un producto puede tener proveedores habituales como relación adicional.

156\. COSTO
===========

El costo puede variar por ingreso.

Por tanto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto.costo_actual   `

puede existir como referencia.

Pero histórico:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DetalleIngreso.costo   `

debe conservarse.

157\. PRECIO
============

Precio de venta también puede cambiar.

Guardar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio_actual   `

para operación.

Pero venta histórica:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   detalle_venta.precio_unitario   `

158\. PRECIO MÍNIMO
===================

Puede existir política:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   precio_minimo   `

o:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   descuento_maximo   `

Todavía debe definirse si vive en:

*   producto;
    
*   variante;
    
*   lista de precios;
    
*   regla comercial.
    

159\. VARIANTES EN KARMYLIS — TODAVÍA POR DEFINIR
=================================================

A pesar del aprendizaje con PrestaShop/Odoo, todavía debe determinarse exactamente:

¿Qué constituye una variante para Karmylis?

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa Slimfit  Negro  M   `

¿Es esta combinación una entidad?

¿O las existencias reciben color/talla individualmente sin un SKU compartido?

Necesita analizar datos reales.

No forzar el modelo PrestaShop.

160\. POSIBLE MODELO DE TRES NIVELES
====================================

Una hipótesis útil:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto modelo          ↓  Variante comercial          ↓  Existencia física   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa Slimfit          ↓  Negro / M          ↓  Unidad 0001  Unidad 0002  Unidad 0003   `

Para modo cantidad:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Camisa Slimfit          ↓  Negro / M          ↓  stock = 3   `

Esto podría unificar ambos mundos.

PERO sigue siendo propuesta.

161\. PRODUCTOS SIN VARIANTES
=============================

Debe poder existir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Cartera clásica   `

sin:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color x talla   `

Opciones:

*   variante única interna;
    
*   entidad vendible directamente.
    

Una variante única automática puede simplificar uniformidad interna sin exponer complejidad en UI.

Pendiente decidir.

162\. INVENTARIO Y RESERVAS
===========================

No mezclar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   físico  reservado  disponible   `

Posible fórmula:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   disponible  =  fisico - reservado - otros compromisos   `

Pero ecommerce puede introducir:

*   allocated;
    
*   committed;
    
*   picking.
    

No diseñar todos los estados hasta definir pedidos online.

163\. TIENDA ONLINE — PEDIDOS VS VENTAS
=======================================

A futuro será importante diferenciar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Pedido  Pago  Preparación  Entrega  Factura  Venta   `

No comprimir todo en:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   estado = PROCESSING   `

Las plataformas estudiadas muestran por qué separar estados puede ser útil.

164\. CANALES
=============

Conceptualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Canal  - POS  - WEB  - marketplace futuro   `

Un producto puede estar publicado en algunos canales.

No es obligatorio implementar una tabla channel en el MVP, pero mantener esta separación mental.

165\. INTEGRACIONES EXTERNAS
============================

Si en el futuro un cliente SaaS ya usa:

*   WooCommerce;
    
*   PrestaShop;
    

podrían desarrollarse conectores.

Integración correcta:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   API  webhook  cola  adaptador   `

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   INSERT directo en wp_posts   `

ni escribir directamente en tablas internas de PrestaShop.

166\. LICENCIAS
===============

Se investigó:

*   WooCommerce/WordPress: ecosistema GPL.
    
*   PrestaShop: licencias open source distintas según componente.
    

Se puede estudiar su diseño y construir un producto competidor propio.

No copiar:

*   código;
    
*   interfaz;
    
*   iconografía;
    
*   marcas;
    
*   tablas literalmente;
    

sin analizar licencias.

Los nombres WooCommerce/PrestaShop solo serían referencias de compatibilidad futura.

167\. POSIBLE TESIS
===================

Don Nelson planteó que el proyecto podría servir como:

*   tesis;
    
*   proyecto aplicado;
    
*   incluso vincularse a práctica/pasantía.
    

Posible línea:

> Diseño e implementación de un sistema ERP modular para gestión y trazabilidad de inventario multisucursal integrado con comercio electrónico aplicado al sector comercial.

El alcance académico deberá limitarse.

No intentar convertir toda la plataforma SaaS en tesis.

Métricas posibles:

*   exactitud de inventario;
    
*   tiempo de consulta;
    
*   tiempo de registro;
    
*   errores;
    
*   trazabilidad;
    
*   reducción de inconsistencias;
    
*   eficiencia del conteo;
    
*   disponibilidad de información.
    

Reglamento exacto de Univalle debe verificarse con la universidad.

168\. RIESGOS PRINCIPALES DEL PROYECTO
======================================

Riesgo 1 — Scope creep
----------------------

ERP + POS + ecommerce + SaaS + BI + fiscal + IA puede crecer indefinidamente.

Necesita fases.

Riesgo 2 — Construir antes de entender
--------------------------------------

El sistema legacy tiene reglas no documentadas.

Riesgo 3 — Sobre-generalización
-------------------------------

Diseñar para farmacias, supermercados y ropa simultáneamente puede destruir simplicidad.

Riesgo 4 — Copiar modelos externos
----------------------------------

PrestaShop no representa automáticamente el dominio Karmylis.

Riesgo 5 — Datos históricos sucios
----------------------------------

Excel y legacy pueden contener inconsistencias.

Riesgo 6 — Cambiar demasiado la operación
-----------------------------------------

Si la interfaz exige demasiado trabajo extra, personal puede evitar utilizarla.

Riesgo 7 — Facturación
----------------------

Normativa y múltiples NIT pueden complicar ecommerce.

Riesgo 8 — Concurrencia
-----------------------

POS + ecommerce + reservas pueden competir por la misma existencia.

169\. PRINCIPIO DE ADOPCIÓN
===========================

No cambiar drásticamente la forma de trabajo de Karmylis únicamente porque el modelo técnico parezca “más correcto”.

Ejemplo:

Si actualmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   registran ingreso  → imprimen códigos  → asignan  → sucursal completa detalles   `

el sistema debe poder facilitar una transición.

No obligar desde día 1:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   12 campos obligatorios  3 fotos  8 atributos  clasificación perfecta   `

antes de poder registrar una prenda.

170\. SISTEMA ACTUAL COMO FUENTE DE CONOCIMIENTO
================================================

Próximo paso importante:

Obtener:

*   capturas;
    
*   video;
    
*   proyecto comprimido;
    
*   esquema BDD;
    
*   datos anonimizados.
    

Analizar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Qué funciona?  ¿Qué no funciona?  ¿Qué regla está implícita?  ¿Qué pantalla utiliza realmente el personal?   `

No descartarlo simplemente por ser antiguo.

171\. DOCUMENTACIÓN DEL DOMINIO
===============================

Existe un documento anterior denominado:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CATÁLOGO DE DOMINIO / CATALOGO DE DATOS   `

Originalmente incluía:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto  Variante  Categoría  Proveedor  Ingreso  Inventario  Movimiento  Sucursal  Venta  DetalleVenta  Usuario  Rol   `

Este documento debe actualizarse con la nueva reunión.

Especialmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto/Variante   `

ya no puede asumirse igual que antes debido a existencias serializadas.

172\. ESPECIFICACIÓN INICIAL K4
===============================

Un documento anterior asumía:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Producto  → variantes color/talla  → stock por cantidad   `

Era útil como hipótesis temprana.

Ahora sabemos que algunas de sus suposiciones fueron incorrectas/incompletas:

*   sí existen movimientos internos;
    
*   hay traslados;
    
*   existen códigos individuales;
    
*   hay multicaja;
    
*   existen reservas;
    
*   devoluciones;
    
*   ecommerce;
    
*   lotes;
    
*   almacenes.
    

No tomar ese documento como verdad actual.

173\. CAMBIOS DE CONOCIMIENTO IMPORTANTES
=========================================

Antes
-----

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   K4 principalmente  inventario simple  producto → variante → cantidad   `

Ahora
-----

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP multisucursal  +  existencias físicas  +  movimientos  +  multicaja  +  ecommerce  +  futuro SaaS   `

174\. CONFLICTOS / PUNTOS QUE NO DEBEN PERDERSE
===============================================

Reserva
-------

Anterior:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   mínimo 50%   `

Reunión:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   20/30 Bs como ejemplo   `

→ pendiente.

Categorías
----------

Se dijo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   máximo dos niveles   `

pero se discutieron potencialmente tres conceptos.

→ pendiente.

Almacén
-------

Se discutió:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   estado   `

y después:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ubicación real   `

→ pendiente.

Traslado
--------

Antes:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   origen siempre preservado comercialmente   `

Reunión:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   reasignación real cambia responsabilidad   `

→ separar histórico/origen/ubicación.

175\. PREGUNTAS ABIERTAS PRIORITARIAS
=====================================

Catálogo
--------

*   ¿Qué es exactamente “artículo”?
    
*   ¿Qué constituye “variante”?
    
*   ¿Color/talla pertenecen a variante o existencia?
    
*   ¿Existen combinaciones repetibles?
    
*   ¿Cuál es el límite real de categorías?
    
*   ¿Sexo/público es categoría o atributo?
    

Código
------

*   ¿Cómo se construye cada segmento?
    
*   ¿Qué valor codifica realmente el barcode?
    
*   ¿Qué ocurre al cambiar precio?
    
*   ¿Qué ocurre al trasladar?
    
*   ¿Qué códigos son únicos y cuáles compartidos?
    

Inventario
----------

*   ¿Todas las prendas están serializadas?
    
*   ¿Existen excepciones?
    
*   ¿Cómo se realizan ajustes?
    
*   ¿Quién los aprueba?
    

Ingreso
-------

*   ¿Compra y lote son la misma entidad?
    
*   ¿Cuántos proveedores?
    
*   ¿Cómo se registran costes?
    
*   ¿Hay facturas de proveedor?
    

Almacén
-------

*   ¿Ubicación independiente?
    
*   ¿Sububicación?
    
*   ¿Quién recibe?
    
*   ¿Puede vender online?
    

Caja
----

*   ¿Qué significa cierre parcial?
    
*   ¿Cómo se entrega efectivo?
    
*   ¿Cuándo se reinicia?
    
*   ¿Cómo se manejan diferencias?
    

Venta
-----

*   ¿Factura/recibo?
    
*   ¿Qué ventas pueden anularse?
    
*   ¿Cómo se manejan devoluciones?
    

Reserva
-------

*   ¿Anticipo mínimo?
    
*   ¿plazo?
    
*   ¿política por empresa?
    

Fiscal
------

*   ¿Cada sucursal realmente tiene NIT distinto?
    
*   ¿Cuál sistema factura actualmente?
    
*   ¿ERP deberá emitir directamente?
    
*   ¿Qué pasa con venta online?
    

176\. PROPUESTA DE DOCUMENTACIÓN SIGUIENTE
==========================================

Antes del MER definitivo:

1.  Documento de requisitos validados.
    
2.  Mapa de procesos.
    
3.  Catálogo de términos del dominio.
    
4.  Estados y reglas.
    
5.  Mockups.
    
6.  Modelo conceptual.
    
7.  MER preliminar.
    
8.  Validación.
    
9.  Modelo lógico.
    

177\. PROCESOS QUE CONVIENE MAQUETAR
====================================

Se identificaron cuatro especialmente útiles:

A. Ingreso y codificación
-------------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ingreso  → existencias  → códigos  → asignación  → recepción  → completar atributos   `

B. Control de inventario
------------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Abrir sesión  → escanear  → movimientos durante conteo  → conciliar  → cerrar   `

C. Traslado/reasignación
------------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Seleccionar  → origen  → destino  → enviar  → recibir   `

D. Caja/venta/reserva
---------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Abrir caja  → escanear  → asignar asesor  → cobrar  → vender/reservar   `

Los mockups deben utilizarse para preguntar:

> “¿Así trabajan?”

antes de diseñar tablas.

178\. MER: NO HACERLO DEFINITIVO TODAVÍA
========================================

Ya existe suficiente información para un MER exploratorio.

Pero NO para congelar el diseño.

Especialmente faltan respuestas de:

*   código;
    
*   existencia;
    
*   variante;
    
*   almacén;
    
*   caja.
    

179\. MODELO CONCEPTUAL CANDIDATO — NO DEFINITIVO
=================================================

Una posible visión:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   EMPRESA  │  ├── CONFIGURACION  │  ├── USUARIOS  │  ├── UBICACIONES  │  │  ├── CATALOGO  │   ├── CATEGORIAS  │   ├── PRODUCTOS  │   ├── ATRIBUTOS  │   └── VARIANTES/ENTIDADES VENDIBLES  │  ├── ABASTECIMIENTO  │   ├── INGRESOS  │   ├── DETALLES  │   └── LOTES  │  ├── INVENTARIO  │   ├── EXISTENCIAS SERIALIZADAS  │   ├── SALDOS POR CANTIDAD  │   ├── MOVIMIENTOS  │   ├── TRASLADOS  │   └── CONTEOS  │  ├── VENTAS  │   ├── VENTAS  │   ├── DETALLES  │   ├── ASESORES  │   ├── RESERVAS  │   ├── DEVOLUCIONES  │   └── PROMOCIONES  │  ├── CAJA  │   ├── CAJAS  │   ├── SESIONES  │   ├── PAGOS  │   └── GASTOS  │  └── CANALES      ├── POS      └── ONLINE   `

Esto es conceptual.

180\. PRINCIPIO DE FUENTE ÚNICA
===============================

Debe existir una fuente oficial para:

*   catálogo;
    
*   inventario;
    
*   ventas.
    

No duplicar responsabilidades.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP = fuente de stock   `

La web consulta ese inventario.

181\. REPORTES NO DEBEN SER VERDAD ALTERNATIVA
==============================================

Evitar que:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Excel diga 3  ERP diga 2  Web diga 1   `

El objetivo de integración es eliminar esas inconsistencias.

182\. HISTÓRICO DE MOVIMIENTOS
==============================

El stock actual puede mantenerse como saldo optimizado.

Pero debe poder reconstruirse/explicarse mediante movimientos suficientes.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   +20 ingreso  -10 asignación K2  -10 asignación K4  -1 venta  +1 devolución  ...   `

No necesariamente implementar contabilidad de doble entrada para inventario sin necesidad, pero mantener trazabilidad.

183\. CONCURRENCIA
==================

Cuando existen:

*   varias cajas;
    
*   ecommerce;
    
*   reservas;
    

dos usuarios pueden competir por una misma existencia.

La BDD debe proteger invariantes mediante transacciones.

No depender solamente del frontend.

184\. ROLES Y PERMISOS
======================

Roles posibles:

*   administrador;
    
*   encargado;
    
*   cajero;
    
*   vendedor;
    
*   almacenero;
    
*   inventariador.
    

No cerrar una lista universal.

Separar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   rol   `

de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   permiso   `

si la complejidad lo requiere.

185\. TRANSFERENCIAS Y APROBACIONES
===================================

Anteriormente se indicó que encargados pueden aprobar movimientos.

Posible flujo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   SOLICITADO  → APROBADO  → ENVIADO  → RECIBIDO   `

También:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   RECHAZADO  CANCELADO   `

Necesita validación con el flujo actualizado.

186\. AUDITORÍA DE TRANSFERENCIA
================================

Guardar:

*   solicitante;
    
*   aprobador;
    
*   emisor;
    
*   receptor;
    
*   timestamps;
    
*   origen;
    
*   destino;
    
*   existencias.
    

187\. MULTITENANCY FUTURO — PRINCIPIO DE SEGURIDAD
==================================================

Si se utiliza shared database:

Nunca confiar solamente en:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   WHERE empresa_id = ?   `

introducido manualmente por cada desarrollador.

Evaluar:

*   scopes;
    
*   middleware;
    
*   repositorios;
    
*   RLS;
    
*   pruebas de aislamiento.
    

188\. BASE POR TENANT
=====================

Si inicialmente el SaaS usa BDD independiente por cliente, sigue necesitando un modelo lógico común.

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Karmylis DB completamente distinta  Farmacia DB completamente distinta   `

Eso sería software personalizado, no SaaS verdaderamente configurable.

189\. CONFIGURACIÓN VS CUSTOMIZACIÓN
====================================

Objetivo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CONFIGURAR   `

no:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   PROGRAMAR PARA CADA CLIENTE   `

190\. ONLINE-ONLY INVENTORY
===========================

Se mencionó posibilidad de prendas que no estén físicamente en sucursal de venta y se ofrezcan online.

No representar necesariamente ecommerce como una sucursal ficticia sin analizarlo.

Puede necesitar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ubicación física  +  canal habilitado   `

Separar ambos conceptos.

191\. CANAL VS UBICACIÓN
========================

Muy importante:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ubicación:  Almacén Central  Canal:  Online   `

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Sucursal Online   `

como única solución, salvo que el negocio realmente la trate operacionalmente así.

192\. UBICACIONES GENÉRICAS
===========================

Para SaaS puede ser útil un concepto más general que “sucursal”:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Location / Ubicación   `

Tipos:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   TIENDA  ALMACEN  DEPOSITO  CENTRO_DISTRIBUCION   `

Pero Karmylis puede seguir viendo “Sucursal” en UI.

193\. MULTI-NIT Y LOCATIONS
===========================

No asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   1 ubicación = 1 NIT   `

Puede existir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ubicación operativa   `

asociada a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   emisor fiscal   `

según política.

194\. ARQUITECTURA FISCAL
=========================

Conceptualmente futuro:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Venta  → FiscalContextResolver  → proveedor/servicio fiscal   `

No poner:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   CUFD  CUIS   `

en Sucursal únicamente por comodidad sin entender contexto SIN.

195\. MÓDULO E-COMMERCE
=======================

Debe compartir dominio con ERP pero puede tener responsabilidades separadas:

*   contenido visible;
    
*   SEO;
    
*   imágenes;
    
*   colecciones;
    
*   catálogo público;
    
*   carrito;
    
*   pedidos;
    
*   pagos online;
    
*   fulfillment.
    

No convertir el ERP entero en CMS.

196\. ADMINISTRACIÓN VS STOREFRONT
==================================

Puede existir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Backoffice/Admin   `

y:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Storefront   `

sobre la misma fuente.

Esto se exploró en el prototipo educativo.

197\. FRONTERA ENTRE PRODUCTO OPERATIVO Y PRODUCTO WEB
======================================================

No toda información del ERP es pública.

ERP puede conocer:

*   coste;
    
*   proveedor;
    
*   notas;
    
*   sucursal de origen.
    

Web solo muestra:

*   nombre;
    
*   descripción;
    
*   precio;
    
*   imágenes;
    
*   opciones;
    
*   disponibilidad según política.
    

198\. DATOS DESCRIPTIVOS PARA WEB
=================================

Posibles candidatos a flexibilidad:

*   composición;
    
*   cuidados;
    
*   fit;
    
*   temporada;
    
*   estilo;
    
*   etiquetas de marketing.
    

No todos deberían generar variantes.

199\. CARACTERÍSTICA VS ATRIBUTO DE VARIANTE
============================================

Conservar esta distinción mental:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Atributo de variante:  Color  Talla   `

si cambian entidad vendible.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Característica:  Material  Temporada  Corte   `

si solo describe.

Pero la empresa debe poder definir qué comportamiento tiene cada atributo.

200\. CONFIGURACIÓN DE ATRIBUTO
===============================

Posible concepto:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Atributo  - nombre  - tipo_dato  - requerido  - filtrable  - genera_variante   `

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color  genera_variante = true  Material  genera_variante = false   `

Esto es una IDEA, no tabla definitiva.

201\. JSONB Y CONFIGURACIÓN DE ATRIBUTOS PUEDEN COEXISTIR
=========================================================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   atributos importantes:  relacionales/configurables  detalles poco frecuentes:  JSONB   `

No obligar a escoger solo uno.

202\. DATOS QUE NO DEBEN SER JSONB SIN BUENA RAZÓN
==================================================

Evitar esconder dentro de un documento:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   stock  ventas  pagos  movimientos  reservas   `

porque participan en:

*   integridad;
    
*   concurrencia;
    
*   joins;
    
*   auditoría;
    
*   reporting.
    

203\. NO TODO LO DINÁMICO NECESITA JSONB
========================================

Ejemplo categorías.

Una tabla:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   categoria  id  empresa_id  nombre  padre_id   `

permite infinitas categorías dinámicas sin alterar columnas.

Esto ayudó a aclarar la diferencia entre:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   estructura dinámica   `

y:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   estructura sin esquema   `

204\. PRINCIPIO CENTRAL DE FLEXIBILIDAD
=======================================

> Un SaaS no necesita que cada dato sea un JSON para ser flexible.

La flexibilidad puede venir de:

*   filas;
    
*   relaciones;
    
*   configuración;
    
*   módulos;
    
*   políticas;
    
*   JSONB;
    
*   catálogos dinámicos.
    

205\. DEEP RESEARCH / INVESTIGACIÓN REALIZADA
=============================================

Se realizaron investigaciones sobre:

*   WooCommerce;
    
*   PrestaShop;
    
*   producto/variantes;
    
*   herencia;
    
*   multistore;
    
*   arquitectura;
    
*   licencias;
    
*   APIs;
    
*   Odoo;
    
*   Shopify;
    
*   Medusa;
    
*   Magento.
    

Conclusión general:

No copiar ninguno.

Tomar ideas.

206\. PRINCIPIO DE MODELO
=========================

Actualmente la combinación conceptual favorita es:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Semántica de Odoo  +  claridad de PrestaShop  +  modularidad de Medusa  +  simplicidad de Shopify  +  JSONB selectivo  +  modelo operacional propio de Karmylis   `

207\. LO MÁS IMPORTANTE DESCUBIERTO RECIENTEMENTE
=================================================

El sistema no puede diseñarse correctamente sin distinguir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto   `

de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   existencia física   `

Esta es probablemente la principal corrección respecto a los modelos iniciales.

208\. EL PROBLEMA NO ES SOLO CATÁLOGO
=====================================

Karmylis necesita principalmente un sistema operacional.

Por eso estudiar únicamente Shopify/WooCommerce sería insuficiente.

El corazón real está en:

*   inventario;
    
*   ubicaciones;
    
*   movimientos;
    
*   existencias;
    
*   caja;
    
*   ventas;
    
*   procesos.
    

209\. DONDE EL SaaS PUEDE DIFERENCIARSE
=======================================

Una posible ventaja del producto futuro:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Inventario serializado O por cantidades  +  atributos configurables  +  multisucursal  +  multicaja  +  ecommerce integrado   `

No afirmar todavía que esto sea una ventaja competitiva validada.

Necesita investigación de mercado.

210\. MERCADO / PRODUCTIZACIÓN
==============================

No se ha realizado aún validación suficiente para definir:

*   pricing;
    
*   planes;
    
*   onboarding;
    
*   nicho exacto;
    
*   competencia;
    
*   adquisición.
    

No construir esto antes de que Karmylis valide el núcleo.

211\. POSIBLE VERTICAL
======================

Aunque Don Nelson habló de comercios más generales, existe tensión estratégica:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   vertical fashion retail   `

es mucho más fácil de diseñar que:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ERP para cualquier comercio   `

No cerrar todavía cuánto se generalizará.

Puede ser mejor evolucionar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Karmylis  → retail moda  → retail configurable   `

en lugar de saltar directamente a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   farmacias + supermercados + boutiques + todo   `

212\. PRINCIPIO DE VALIDACIÓN
=============================

Cada concepto generalizable debería preguntarse:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Esto es una regla universal?  ¿Es una capacidad común?  ¿Es una política configurable?  ¿Es algo exclusivo de Karmylis?   `

213\. EJEMPLO DE CLASIFICACIÓN
==============================

Universal/invariante aproximado
-------------------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   una venta debe conservar historia   `

Capacidad común
---------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   inventario por ubicación   `

Política configurable
---------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   reserva máxima 15 días   `

Karmylis-specific
-----------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   formato actual de etiqueta   `

214\. ESTADO DEL PROYECTO EN ESTE MOMENTO
=========================================

NO se ha construido todavía la BDD definitiva.

NO se ha congelado el MER.

NO se ha elegido definitivamente toda la arquitectura.

NO se ha implementado el ERP productivo.

Actualmente se está en:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   DESCUBRIMIENTO  +  ANÁLISIS  +  VALIDACIÓN DE DOMINIO  +  PROTOTIPADO   `

215\. SIGUIENTE MATERIAL ESPERADO
=================================

Se pretende obtener del sistema anterior:

*   capturas;
    
*   posiblemente proyecto comprimido.
    

Eso debería analizarse antes del diseño final.

216\. PRÓXIMOS PASOS RECOMENDADOS
=================================

Paso 1
------

Revisar sistema legacy.

Paso 2
------

Construir documento corto de requisitos para validación.

Paso 3
------

Maquetar procesos críticos.

Paso 4
------

Validarlos.

Paso 5
------

Crear glosario del dominio.

Paso 6
------

Definir estados.

Paso 7
------

Crear modelo conceptual.

Paso 8
------

Crear MER candidato.

Paso 9
------

Probar MER contra escenarios reales.

Paso 10
-------

Elegir stack definitivamente.

Paso 11
-------

Implementar primer incremento.

217\. ESCENARIOS QUE EL FUTURO MER DEBE SOPORTAR
================================================

### Escenario 1

Llegan 20 prendas.

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   10 → K2  10 → K4   `

### Escenario 2

Cada prenda recibe código diferente.

### Escenario 3

Color/talla se completa después.

### Escenario 4

Se mueve prenda K2 → K4.

### Escenario 5

Se cuenta inventario escaneando una por una.

### Escenario 6

Se vende durante inventario.

### Escenario 7

Dos cajeros utilizan Caja 1 en turnos distintos.

### Escenario 8

Caja 1 y Caja 2 venden simultáneamente.

### Escenario 9

Venta utiliza efectivo + tarjeta.

### Escenario 10

Una venta tiene dos asesores.

### Escenario 11

Prenda queda reservada.

### Escenario 12

Reserva vence y se libera.

### Escenario 13

Venta se devuelve.

### Escenario 14

Se aplica promoción por rango de códigos.

### Escenario 15

Venta online consume el mismo inventario.

### Escenario 16

Futuro tenant controla Coca-Cola por cantidad, no por unidad serial.

Si el modelo no soporta estos escenarios razonablemente, revisarlo.

218\. ESCENARIOS DE CONCURRENCIA A PROBAR
=========================================

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Dos cajas venden última unidad.  POS y web venden última unidad.  Reserva y venta compiten.  Traslado y venta compiten.  Inventario físico y venta simultánea.   `

219\. ESCENARIOS DE AUDITORÍA A PROBAR
======================================

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Quién movió esta prenda?  ¿Quién la vendió?  ¿Quién anuló la venta?  ¿Quién cambió el precio?  ¿Quién ajustó inventario?  ¿Quién recibió traslado?   `

220\. ESCENARIOS SaaS A PROBAR
==============================

Tenant A:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Color + Talla  Serializado  Reservas   `

Tenant B:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Presentación + Volumen  Cantidad  Sin reservas   `

El modelo debe permitir ambos sin migraciones personalizadas por cliente.

221\. PRINCIPIO FINAL DE DISEÑO
===============================

No buscar:

> la base de datos más flexible posible.

Buscar:

> el dominio más claro posible con los puntos correctos de flexibilidad.

222\. PRINCIPIO FINAL SOBRE JSONB
=================================

JSONB es una herramienta.

No es una arquitectura.

Puede solucionar:

*   campos variables;
    
*   metadata;
    
*   extensiones.
    

No sustituye automáticamente:

*   relaciones;
    
*   invariantes;
    
*   procesos;
    
*   transacciones.
    

223\. PRINCIPIO FINAL SOBRE SaaS
================================

No construir una “BDD diferente para cada empresa”.

Incluso si físicamente cada tenant obtiene su propia base de datos, idealmente el software utiliza el mismo modelo lógico y comportamiento configurable.

224\. PRINCIPIO FINAL SOBRE KARMYLIS
====================================

No obligar a Karmylis a trabajar como PrestaShop.

No obligar a Karmylis a trabajar como Odoo.

No obligar a Karmylis a abandonar procesos útiles solamente porque son particulares.

Entender primero por qué existen.

Después decidir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   conservar  mejorar  generalizar  eliminar   `

225\. PRINCIPIO FINAL SOBRE EL SISTEMA LEGACY
=============================================

No asumir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   viejo = malo   `

El legacy contiene años de decisiones de negocio.

Algunas serán malas técnicamente.

Otras contienen conocimiento que aún no hemos descubierto.

Debe estudiarse como artefacto del dominio.

226\. PRINCIPIO FINAL SOBRE ARQUITECTURA
========================================

Preferencia actual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Monolito modular  +  límites de dominio  +  BDD relacional fuerte  +  flexibilidad selectiva  +  API   `

No microservicios tempranos.

227\. PRINCIPIO FINAL SOBRE TECNOLOGÍA
======================================

Candidato actual:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Laravel  Vue 3  TypeScript  PostgreSQL   `

Pero una decisión tecnológica debe justificarse por:

*   dominio;
    
*   equipo;
    
*   mantenimiento;
    
*   ecosistema;
    
*   operación.
    

No por moda.

228\. PRINCIPIO FINAL SOBRE PostgreSQL VS MySQL
===============================================

No afirmar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   PostgreSQL es mejor porque hay muchos datos.   `

Decir:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Ambos sirven.  PostgreSQL puede ser preferible por las capacidades que esperamos utilizar.   `

229\. PRINCIPIO FINAL SOBRE FRONTEND
====================================

La interfaz debe ocultar complejidad.

El usuario no debería necesitar entender:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   VariantAttributeValue  InventoryMovement  Aggregate   `

Debería entender:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Registrar prenda  Mover  Vender  Reservar  Contar   `

230\. PRINCIPIO FINAL SOBRE DOCUMENTACIÓN
=========================================

Separar siempre:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   HECHO  REQUISITO  PROPUESTA  PENDIENTE   `

Esto es esencial porque el proyecto está en descubrimiento.

231\. TONO DE TRABAJO CON ALAN
==============================

Alan puede hablar informalmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bro  xd  jajaja  orj   `

Pero para arquitectura espera respuestas serias.

Puede pedir a veces:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   más simple   `

cuando se satura.

En ese caso usar ejemplos concretos y menos jerga.

No interpretar frustración momentánea como abandono real del proyecto.

232\. CUANDO EXPLIQUES BDD
==========================

Usar nombres pedagógicos en español primero.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   producto_lista  variante_lista  atributo_tipo  atributo_valor   `

antes de mostrar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ps_product_attribute  wp_term_taxonomy   `

Esto ayudó muchísimo a Alan a comprender los modelos.

233\. CUANDO COMPARES ARQUITECTURAS
===================================

Explicar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   qué problema resuelve  qué costo introduce  por qué serviría aquí   `

No simplemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   “X es best practice.”   `

234\. CUANDO DISEÑES TABLAS
===========================

Antes preguntar mentalmente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Esta entidad existe en el negocio?   `

No:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Qué tablas tendría un ERP?   `

235\. CUANDO APAREZCA UNA NUEVA REGLA
=====================================

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   talla G = L?  GG = XL?   `

No normalizarla automáticamente.

Validar:

*   si es equivalencia real;
    
*   nomenclatura del proveedor;
    
*   error histórico;
    
*   conversión.
    

Las tallas actuales tienen inconsistencias.

236\. CALIDAD DE DATOS
======================

Se observaron valores como:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   M  L  G  GG  6  Estándar   `

Esto demuestra que la normalización de atributos necesitará:

*   alias;
    
*   equivalencias;
    
*   limpieza;
    
*   reglas.
    

No asumir dataset limpio.

237\. MIGRACIÓN: CONSERVAR ORIGINAL
===================================

Nunca destruir/normalizar el origen sin trazabilidad.

Puede ser útil conservar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   valor_original   `

durante migración.

Ejemplo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   "GG"   `

normalizado después a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   XL   `

solo cuando el negocio confirme equivalencia.

238\. DATOS EXISTENTES INCORRECTOS
==================================

El sistema actual mostró cantidades históricas improbables.

Ejemplo comentado:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   45.775 asignados  91.254 registros históricos   `

cuando físicamente podría haber alrededor de:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   2.000–3.000 prendas por sucursal   `

aproximadamente.

Esto confirma que los datos legacy no pueden migrarse ciegamente.

239\. BI NECESITA DATOS CONFIABLES
==================================

Antes de dashboards sofisticados:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   garbage in  → garbage out   `

Primero calidad operacional.

240\. DATA WAREHOUSE NO “ENCAPSULA MÁGICAMENTE”
===============================================

Durante la conversación se habló coloquialmente del DWH como sistema para combinar información.

Aclaración:

El DWH será una capa analítica construida sobre datos del ERP.

No reemplaza:

*   modelo transaccional;
    
*   limpieza;
    
*   procesos.
    

241\. RECOMENDACIÓN SOBRE MAQUETADOS
====================================

Usar mockups para descubrir requisitos.

No solamente para mostrar diseño.

Ejemplo:

Pantalla de traslado puede revelar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿quién aprueba?  ¿quién recibe?  ¿puede cancelar?   `

Antes de escribir tablas.

242\. RECOMENDACIÓN SOBRE PROTOTIPOS EDUCATIVOS
===============================================

Mantenerlos separados de producción.

El simulador de PrestaShop es para:

*   aprender relaciones;
    
*   practicar CRUD;
    
*   visualizar categorías;
    
*   entender producto/variante.
    

No convertirlo automáticamente en ERP Karmylis.

243\. RECOMENDACIÓN SOBRE INVESTIGACIÓN EXTERNA
===============================================

Sistemas que vale la pena estudiar más:

*   Odoo;
    
*   ERPNext;
    
*   Shopify;
    
*   Medusa;
    
*   Lightspeed Retail;
    
*   Square POS;
    
*   Dynamics 365 Commerce;
    
*   Oracle NetSuite;
    
*   sistemas POS retail con multicaja;
    
*   WMS simples;
    
*   plataformas que soporten serialización.
    

Objetivo:

> descubrir problemas que sistemas maduros ya resolvieron.

No copiar esquemas.

244\. INVESTIGACIONES PENDIENTES
================================

Especialmente:

*   multicaja y cierres;
    
*   POS shift management;
    
*   inventario serializado;
    
*   stocktaking durante operación;
    
*   reservations/layaway;
    
*   returns;
    
*   gift cards;
    
*   promociones;
    
*   ecommerce fulfillment;
    
*   arquitectura multitenant;
    
*   facturación Bolivia.
    

245\. NO MEZCLAR STOCKTAKING CON STOCK MOVEMENT
===============================================

Conteo:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   observación física   `

Movimiento:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   cambio real de stock   `

Si conteo descubre diferencia:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   conteo  → revisión  → ajuste   `

No convertir cada escaneo en movimiento.

246\. NO MEZCLAR RESERVA CON MÉTODO DE PAGO
===========================================

Reserva es un proceso comercial.

Puede tener pagos/anticipos.

No debería ser simplemente:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   tipo_pago = RESERVA   `

247\. NO MEZCLAR GIFT CARD CON PRODUCTO NORMAL SIN PENSARLO
===========================================================

Puede venderse como producto comercial, pero requiere:

*   emisión;
    
*   saldo;
    
*   consumo;
    
*   expiración potencial;
    
*   seguridad.
    

248\. NO MEZCLAR PROMOCIÓN CON PRECIO
=====================================

Promoción es regla/campaña.

Precio es dato comercial.

Una promoción produce precio efectivo.

249\. NO MEZCLAR CAJA CON CAJERO
================================

Ya explicado: fundamental.

250\. NO MEZCLAR SUCURSAL CON CANAL
===================================

Sucursal:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ubicación operacional   `

Canal:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   dónde se origina la venta   `

Venta online puede despacharse desde K4.

251\. NO MEZCLAR SUCURSAL CON NIT
=================================

Sucursal operacional y entidad fiscal son conceptos distintos.

252\. NO MEZCLAR EMPRESA SaaS CON EMPRESA FISCAL
================================================

Tenant:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   cliente del SaaS   `

Una empresa SaaS podría incluso administrar varios emisores fiscales.

253\. POSIBLE MODELO ORGANIZATIVO FUTURO
========================================

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Tenant/Organización  │  ├── Ubicaciones  ├── Usuarios  ├── Configuración  ├── Catálogo  └── Emisores fiscales   `

Pero todavía conceptual.

254\. REQUERIMIENTO DE TRAZABILIDAD
===================================

Debe poder responderse:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿Dónde está esta prenda?  ¿De dónde llegó?  ¿Cuándo llegó?  ¿Quién la movió?  ¿Quién la vendió?  ¿A qué precio?  ¿Fue reservada?  ¿Fue devuelta?   `

Especialmente para inventario serializado.

255\. GRAN VENTAJA DEL CÓDIGO INDIVIDUAL
========================================

Karmylis ya tiene algo similar a serialización.

Esto puede habilitar:

*   tracking;
    
*   stocktake preciso;
    
*   auditoría;
    
*   historial individual.
    

Pero también tiene costo:

*   más registros;
    
*   etiquetas;
    
*   operación.
    

El SaaS no debe obligar a otros negocios a adoptarlo.

256\. ESCALABILIDAD
===================

No preocuparse actualmente por:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   100 millones de requests/s   `

Problemas reales:

*   consultas correctas;
    
*   índices;
    
*   transacciones;
    
*   UX;
    
*   mantenibilidad;
    
*   datos.
    

PostgreSQL/MySQL manejarán fácilmente el volumen inicial.

257\. ESCALABILIDAD ORGANIZACIONAL
==================================

Más importante que performance prematura:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   ¿podemos agregar sucursal sin cambiar código?  ¿podemos agregar método de pago desde configuración?  ¿podemos agregar atributo?   `

Esto es verdadera preparación SaaS.

258\. POSIBLE ARQUITECTURA DE DEPLOY FUTURO
===========================================

No definida.

Podría evolucionar a:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   API  Admin  Storefront  Worker/Queue  PostgreSQL  Redis opcional  Object Storage   `

No introducir Redis/queues si todavía no son necesarios.

259\. FOTOS / MEDIA
===================

No guardar binarios pesados necesariamente en BDD.

Probablemente almacenar:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   URL / objeto   `

en storage.

Proveedor por decidir.

260\. OFFLINE
=============

Anteriormente se consideró Flutter porque el escaneo y conectividad podrían requerir offline.

Actualmente no está confirmado si K4 necesita operación offline.

Debe probarse calidad de internet.

Web responsive/PWA podría ser suficiente.

No elegir móvil nativo antes de validar.

261\. HARDWARE
==============

Escaneo puede usar:

*   lector de códigos;
    
*   tablet;
    
*   laptop;
    
*   cámara.
    

La UX debe adaptarse al hardware real de Karmylis.

262\. RESPONSABILIDAD HUMANA
============================

El sistema no resolverá inventario si:

*   nadie registra ingresos;
    
*   nadie recibe;
    
*   nadie confirma movimientos;
    
*   nadie hace conteos.
    

El diseño debe definir responsabilidades mínimas.

No sobrecargar personal con burocracia.

263\. REGLA UX
==============

Cada control adicional debe responder:

> ¿Qué error real evita?

Si no evita nada y solo complica, cuestionarlo.

264\. VISIÓN GENERAL FINAL
==========================

La arquitectura conceptual actual puede resumirse así:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML                    `ORGANIZACIÓN                            │                CONFIGURACIÓN / POLÍTICAS                            │          ┌─────────────────┼──────────────────┐          │                 │                  │       CATÁLOGO         INVENTARIO          VENTAS          │                 │                  │     productos          ingresos             POS     categorías         lotes                cajas     atributos          unidades             pagos     variantes          ubicaciones          reservas     códigos            movimientos          devoluciones                        conteos              promociones                            │                  │                            └────────┬─────────┘                                     │                                  CANALES                                     │                            ┌────────┴────────┐                            │                 │                           POS             ONLINE`

Y alrededor:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Usuarios  Auditoría  Fiscal  Reportes  BI  Integraciones   `

265\. OBJETIVO REAL INMEDIATO
=============================

NO:

> diseñar el SaaS completo.

NO:

> programar todo el ERP.

NO:

> decidir 80 tablas.

SÍ:

> comprender completamente los procesos de Karmylis y diseñar un núcleo que no impida la futura generalización.

266\. MANTRA DEL PROYECTO
=========================

> Primero dominio, después modelo.

> Primero Karmylis, después SaaS.

> Flexible donde importa, estructurado donde importa.

> Trazabilidad antes que comodidad de sobrescribir datos.

> Configuración antes que customización por cliente.

> La tienda online comparte el mismo corazón operacional.

> No copiar sistemas externos: aprender de ellos.

267\. SI LA IA TIENE QUE CONTINUAR DESDE AQUÍ
=============================================

Las tareas de mayor valor son:

1.  analizar el sistema legacy cuando lleguen capturas/proyecto;
    
2.  corregir el documento de requisitos;
    
3.  diseñar mockups de procesos ambiguos;
    
4.  formalizar glosario;
    
5.  resolver Producto–Variante–Existencia;
    
6.  resolver Ubicación–Almacén–Sucursal;
    
7.  estudiar Caja–Sesión–Cierre;
    
8.  resolver atributos configurables/JSONB;
    
9.  crear MER preliminar;
    
10.  probarlo contra escenarios reales;
    
11.  definir el primer incremento del ERP;
    
12.  recién entonces implementar.
    

268\. LO QUE LA IA NO DEBE HACER
================================

No debe:

*   inventar significado de códigos;
    
*   asumir que todas las tiendas usan variantes;
    
*   convertir todo a JSONB automáticamente;
    
*   imponer PrestaShop;
    
*   imponer microservicios;
    
*   implementar multitenancy completo ahora;
    
*   afirmar normativa fiscal sin verificar;
    
*   asumir que cada sucursal tiene NIT propio sin confirmarlo;
    
*   confundir reserva con venta;
    
*   confundir asesor con cajero;
    
*   confundir caja con usuario;
    
*   eliminar operaciones históricas;
    
*   hardcodear K1–K4;
    
*   hardcodear Color/Talla;
    
*   hardcodear métodos de pago;
    
*   diseñar por moda tecnológica.
    

269\. LO QUE LA IA DEBE PRIORIZAR
=================================

*   claridad;
    
*   ejemplos Karmylis;
    
*   decisiones justificadas;
    
*   validación;
    
*   trazabilidad;
    
*   flexibilidad controlada;
    
*   evolución incremental;
    
*   UX real;
    
*   seguridad;
    
*   mantenibilidad;
    
*   aprendizaje de Alan.
    

270\. ESTADO FINAL DEL CONTEXTO
===============================

Actualmente el proyecto se encuentra en una etapa de descubrimiento avanzada.

La visión del producto es considerablemente más clara que al inicio, pero todavía existen decisiones de dominio fundamentales pendientes.

La próxima gran fuente de verdad será el análisis del sistema actual mediante capturas o proyecto comprimido.

Hasta entonces, cualquier modelo de datos debe considerarse:

**candidato, no definitivo.**

El principal objetivo es construir un ERP sólido para Karmylis que pueda demostrar cuáles de sus conceptos merecen convertirse posteriormente en capacidades configurables de un SaaS comercial.

FIN DEL CONTEXTO MAESTRO.