use classicmodels;

-- DROP PROCEDURE aumentarCreditoClientes;

DELIMITER //

CREATE PROCEDURE aumentarCreditoClientes(in pais VARCHAR(50))
BEGIN
    UPDATE customers c
    JOIN (
        SELECT DISTINCT c.customerNumber
        FROM customers c
        JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
        JOIN offices o USING(officeCode)
        WHERE o.country = pais
        AND c.salesRepEmployeeNumber IS NOT NULL
    ) AS target_customers USING (customerNumber)
    SET c.creditLimit = c.creditLimit * 1.10;
    
   
    SELECT ROW_COUNT() AS clientes_actualizados;
END //

DELIMITER ;


CALL aumentarCreditoClientes('USA');