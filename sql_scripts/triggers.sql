use LIBRARY_MANAGER;

# procedure to submit an unconfirmed order gor a book from its publisher
DELIMITER //
CREATE PROCEDURE Make_order(
IN ISBN varchar(17),
IN amount int
)
BEGIN
  INSERT INTO `ORDER` ( date_submitted, estimated_arrival_date, confirmed, BOOK_ISBN, quantity)
  VALUES ( curdate(), NULL, FALSE, ISBN, amount);
END //
DELIMITER ;



# DELIMITER //
# CREATE PROCEDURE Make_order_if_doesnt_exist(
# IN ISBN int,
# IN amount int
# )
# BEGIN
#
#   IF (NOT EXISTS (SELECT * From `ORDER` where ISBN = BOOK_ISBN) ) THEN
#
#     CALL Make_order(New.BOOK_ISBN,New.No_of_copies);
#
#   ELSE
#
#
#   end if;
#
#   INSERT INTO `ORDER` VALUES ( curdate(), NULL, FALSE, ISBN, amount);
# END //
# DELIMITER ;

# check that there is enough amount to proceed with the purchase
CREATE TRIGGER purchase_check
BEFORE INSERT ON PURCHASE
FOR EACH ROW
BEGIN

  DECLARE number_of_available_copies INTEGER;
  DECLARE price_ REAL;

  IF  New.No_of_copies < 1 THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not acceptable quantity "can\'t be negative" ';
  END IF;


  SELECT Available_copies_count,selling_price
  INTO number_of_available_copies,price_
  FROM BOOK
  WHERE ISBN = NEW.BOOK_ISBN;

  SET NEW.price = price_*NEW.No_of_copies;


#
#   IF price_ * NEW.No_of_copies != NEW.price THEN
#     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The price is not right';
#   end if;

  IF number_of_available_copies < New.No_of_copies THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The amount in stock is not sufficient and submitted order';
  END IF;

END;


# update the number of book copies for a purchased book
CREATE TRIGGER update_amount
AFTER INSERT ON PURCHASE
FOR EACH ROW
BEGIN


  UPDATE BOOK SET Available_copies_count =
                Available_copies_count - New.No_of_copies
    where ISBN = NEW.BOOK_ISBN;
END;




CREATE TRIGGER available_amount_check
BEFORE UPDATE ON BOOK
  FOR EACH ROW
BEGIN

  IF New.Minimum_Threshold < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The amount in stock can\'t be negative';
  END IF;

  IF New.selling_price <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The price must be positive';
  END IF;


  IF New.Available_copies_count < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Number of available copies should not be a negative value';
  END IF;


END;



CREATE TRIGGER check_new_book_criteria
BEFORE INSERT ON BOOK
  FOR EACH ROW
BEGIN

  IF New.Minimum_Threshold > New.Available_copies_count THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The amount is not consistent with the threshold';
  END IF;

  IF New.Minimum_Threshold < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The threshold in stock can\'t be negative';
  END IF;

  IF New.selling_price <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The price must be positive';
  END IF;


  IF New.Available_copies_count < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Number of available copies should not be a negative value';
  END IF;


END;




# checks that the amount left is more that the threshold
# if not it places an order of a proportional amount of the threshold
CREATE TRIGGER order_if_below_threshold
AFTER UPDATE ON BOOK
  FOR EACH ROW
BEGIN


  IF New.Available_copies_count < New.Minimum_threshold THEN
    IF NOT (EXISTS(select * from `ORDER` where `ORDER`.BOOK_ISBN = New.ISBN)) then
       CALL Make_order(New.ISBN, New.Minimum_threshold * 2);
    END IF;
  END IF;

END;



# after deleting a confirmed order its amount is added to the current book copies
# successful order
CREATE TRIGGER check_delete_unconfirmed_orders
BEFORE DELETE ON `ORDER`
  FOR EACH ROW
BEGIN

  DECLARE number_of_ordered_copies, number_available_in_stock, threshold INTEGER;

  IF (NOT Old.confirmed) then

    SELECT SUM(quantity)
    INTO number_of_ordered_copies
    FROM `ORDER` as current_orders
    WHERE current_orders.BOOK_ISBN = Old.BOOK_ISBN AND Old.id != current_orders.id ;

    SELECT Available_copies_count, Minimum_threshold
    INTO number_available_in_stock, threshold
    FROM BOOK
    WHERE ISBN = Old.BOOK_ISBN ;

    IF ( (number_of_ordered_copies is NULL AND number_available_in_stock < threshold) OR
      (number_available_in_stock + number_of_ordered_copies < threshold)) THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deleting this order will not satisfy the book threshold';
    end if;

  END IF;

END;

# after deleting a confirmed order its amount is added to the current book copies
# successful order
CREATE TRIGGER receive_order
AFTER DELETE ON `ORDER`
  FOR EACH ROW
BEGIN

  IF Old.confirmed then

    UPDATE BOOK SET
           Available_copies_count
             = Available_copies_count + Old.quantity
      where ISBN = Old.BOOK_ISBN;


  END IF;
END;

DELIMITER //
CREATE PROCEDURE `make_purchase`(IN sql_text TEXT)

BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
    START TRANSACTION;
    prepare stmt from sql_text;
    execute stmt;
    deallocate prepare stmt;
    IF `_rollback` THEN
        SELECT concat('There are no enough available copies of the books ordered.\nCould not complete purchase.');
        ROLLBACK;
    ELSE
        SELECT 'Purchase completed successfully.';
        COMMIT;
    END IF;
END //
DELIMITER ;


##############################################################################################
# sales last month
SELECT SUM(price) as sales FROM PURCHASE
WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);



# The top 5 customers who purchase the most purchase amount in descending order for the last three months
SELECT first_name,last_name, SUM(price) as buyings FROM
        PURCHASE inner join `User` on User.id = User_id
WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 3 MONTH)
AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 3 MONTH)
GROUP BY User.id ORDER BY buyings DESC LIMIT 5;



# The top 10 selling books for the last three months
SELECT title, SUM(price) as sales FROM
        PURCHASE inner join BOOK on ISBN = BOOK_ISBN
WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 3 MONTH)
AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 3 MONTH)
GROUP BY BOOK_ISBN ORDER BY sales DESC LIMIT 10;








# queries to be used
INSERT INTO BOOK VALUES ();
UPDATE BOOK SET  WHERE ISBN = ;
INSERT INTO `ORDER` () VALUES ();
UPDATE `ORDER`SET confirmed = true where ISBN = ;
UPDATE User SET isManager = true where id = ;







#sql = "Select * from ... your sql query here"
#records_array = ActiveRecord::Base.connection.execute(sql)

