use classicmodels;



DELIMITER //
CREATE PROCEDURE registrarPagosPendientes(IN p_amount DECIMAL(10,2))
BEGIN
    
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El monto debe ser un valor positivo';
    END IF;
    
    INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
    SELECT DISTINCT o.customerNumber, 
           CONCAT('AUTO-', o.orderNumber) AS checkNumber,
           CURRENT_DATE AS paymentDate,
           p_amount AS amount
    FROM orders o
    WHERE o.status = 'Shipped'
      AND DATEDIFF(CURRENT_DATE, o.shippedDate) >= 30
      AND NOT EXISTS (
          SELECT 1 
          FROM payments p 
          WHERE p.customerNumber = o.customerNumber 
            AND p.paymentDate = CURRENT_DATE
      );
    
  
    SELECT ROW_COUNT() AS payments_processed;
END //

DELIMITER ;

CALL registrarPagosPendientes(100.00);