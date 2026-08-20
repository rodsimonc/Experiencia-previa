-- =============================================================================
-- Consultas SQL analíticas — ejemplos
-- -----------------------------------------------------------------------------
-- Patrones de consulta que uso para responder preguntas de negocio/análisis a
-- partir de datos en una base relacional: agregaciones, JOINs, subconsultas y
-- window functions. Esquema de ejemplo: clientes, pedidos, items.
-- =============================================================================

-- 1) Agregación con filtro: ingresos por mes (últimos 12 meses)
SELECT strftime('%Y-%m', fecha)      AS mes,
       COUNT(*)                       AS n_pedidos,
       ROUND(SUM(monto), 2)           AS ingresos
FROM   pedidos
WHERE  fecha >= date('now', '-12 months')
GROUP  BY mes
ORDER  BY mes;

-- 2) JOIN + agregación: top 10 clientes por gasto total
SELECT c.id, c.nombre,
       COUNT(p.id)            AS pedidos,
       ROUND(SUM(p.monto), 2) AS gasto_total
FROM   clientes c
JOIN   pedidos  p ON p.cliente_id = c.id
GROUP  BY c.id, c.nombre
ORDER  BY gasto_total DESC
LIMIT  10;

-- 3) Subconsulta: clientes que gastaron por encima del promedio general
SELECT nombre, gasto_total
FROM (
    SELECT c.nombre, SUM(p.monto) AS gasto_total
    FROM   clientes c
    JOIN   pedidos  p ON p.cliente_id = c.id
    GROUP  BY c.id
)
WHERE gasto_total > (SELECT AVG(monto) FROM pedidos);

-- 4) Window functions: ranking de productos por ingresos dentro de cada categoría
SELECT categoria, producto, ingresos,
       RANK() OVER (PARTITION BY categoria ORDER BY ingresos DESC) AS ranking
FROM (
    SELECT i.categoria, i.producto, SUM(i.cantidad * i.precio) AS ingresos
    FROM   items i
    GROUP  BY i.categoria, i.producto
);

-- 5) Window function acumulada: ingreso acumulado mes a mes (running total)
SELECT mes, ingresos,
       SUM(ingresos) OVER (ORDER BY mes) AS ingreso_acumulado
FROM (
    SELECT strftime('%Y-%m', fecha) AS mes, SUM(monto) AS ingresos
    FROM   pedidos
    GROUP  BY mes
);

-- 6) Cohortes simples: retención por mes de primera compra
WITH primera AS (
    SELECT cliente_id, MIN(strftime('%Y-%m', fecha)) AS cohorte
    FROM   pedidos GROUP BY cliente_id
)
SELECT pr.cohorte,
       strftime('%Y-%m', p.fecha) AS mes_actividad,
       COUNT(DISTINCT p.cliente_id) AS clientes_activos
FROM   pedidos p
JOIN   primera pr ON pr.cliente_id = p.cliente_id
GROUP  BY pr.cohorte, mes_actividad
ORDER  BY pr.cohorte, mes_actividad;
