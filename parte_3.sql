USE classicmodels;


CREATE TABLE IF NOT EXISTS employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL,
    INDEX idx_employee (employeeNumber)
);


DELIMITER //
CREATE TRIGGER TG_AF_INSERT_EMPLOYEES
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (employeeNumber, lastname, changedat, action)
    VALUES (NEW.employeeNumber, NEW.lastName, NOW(), 'INSERT');
END//


CREATE TRIGGER TG_AF_UPDATE_EMPLOYEES
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.lastName != NEW.lastName THEN
        INSERT INTO employees_audit (employeeNumber, lastname, changedat, action)
        VALUES (NEW.employeeNumber, NEW.lastName, NOW(), 'UPDATE');
    END IF;
END//


CREATE TRIGGER TG_AF_DELETE_EMPLOYEES
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (employeeNumber, lastname, changedat, action)
    VALUES (OLD.employeeNumber, OLD.lastName, NOW(), 'DELETE');
END//

DELIMITER ;


SELECT * FROM employees_audit ORDER BY changedat DESC;


UPDATE employees 
SET lastName = 'Phan'
WHERE employeeNumber = 1056;


SELECT * FROM employees_audit ORDER BY changedat DESC;