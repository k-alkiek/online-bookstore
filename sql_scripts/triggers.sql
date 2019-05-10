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


###################################################################################################################

# prevent malformed users
CREATE TRIGGER user_create_sanity_check
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email is not well formatted';
  END IF;

  IF (NOT ( NEW.first_name REGEXP '^([A-Za-z])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name is not well formatted';
  END IF;

  IF (NOT ( NEW.last_name REGEXP '^([A-Za-z])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Last name is not well formatted';
  END IF;
END;

# updated user values
CREATE TRIGGER user_update_sanity_check
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email is not well formatted';
  END IF;

  IF (NOT ( NEW.first_name REGEXP '^([A-Za-z])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name is not well formatted';
  END IF;

  IF (NOT ( NEW.last_name REGEXP '^([A-Za-z])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Last name is not well formatted';
  END IF;
END;




# prevent create malformed author
CREATE TRIGGER author_create_sanity_check
BEFORE INSERT ON AUTHOR
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.Author_name REGEXP '^([A-Za-z]|[[:space:]]|[.]|[-]|[\'])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Author name is not well formatted';
  END IF;
END;


# prevent update to malformed author
CREATE TRIGGER author_update_sanity_check
BEFORE UPDATE ON AUTHOR
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.Author_name REGEXP '^([A-Za-z]|[[:space:]]|[.]|[-]|[\'])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Author name is not well formatted';
  END IF;
END;

# prevent create malformed publisher
CREATE TRIGGER publisher_create_sanity_check
BEFORE INSERT ON PUBLISHER
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.Name REGEXP '^([A-Za-z]|[[:space:]]|[-]|[,]|[\'])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Publisher name is not well formatted';
  END IF;
END;



# prevent update malformed publisher
CREATE TRIGGER publisher_update_sanity_check
BEFORE UPDATE ON PUBLISHER
FOR EACH ROW
BEGIN
  IF (NOT ( NEW.Name REGEXP '^([A-Za-z]|[[:space:]]|[-]|[,]|[\'])+$'))then
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Publisher name is not well formatted';
  END IF;
END;


# negative quantity order
CREATE TRIGGER order_creation_sanity_check
BEFORE INSERT ON `ORDER`
FOR EACH ROW
BEGIN
  IF New.quantity <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'the quantity in the order must be positive';
  END IF;
END;

#update an order is legal
CREATE TRIGGER check_update_order
BEFORE UPDATE ON `ORDER`
  FOR EACH ROW
BEGIN
  DECLARE number_of_ordered_copies, number_available_in_stock, threshold INTEGER;

  IF New.quantity <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'the quantity in the order must be positive';
  END IF;

  SELECT SUM(quantity)
  INTO number_of_ordered_copies
  FROM `ORDER` as current_orders
  WHERE current_orders.BOOK_ISBN = New.BOOK_ISBN AND New.id != current_orders.id ;

  SELECT Available_copies_count, Minimum_threshold
  INTO number_available_in_stock, threshold
  FROM BOOK
  WHERE ISBN = New.BOOK_ISBN ;

  IF ( (number_of_ordered_copies is NULL AND number_available_in_stock + New.quantity < threshold) OR
    (number_available_in_stock + number_of_ordered_copies + New.quantity< threshold)) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updating this order will not satisfy the book threshold';
  end if;

END;


#prevent any update on purchase
CREATE TRIGGER purchase_update_forbid
BEFORE UPDATE ON PURCHASE
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updating a purchase is not allowed';
END;




###################################################################################################################


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

# UPDATED ############################################################################################################

# checks that the amount left is more that the threshold
# if not it places an order of a proportional amount of the threshold
CREATE TRIGGER order_if_below_threshold
AFTER UPDATE ON BOOK
  FOR EACH ROW
BEGIN

  DECLARE number_of_ordered_copies INTEGER;

  IF New.Available_copies_count < New.Minimum_threshold THEN

    SELECT SUM(quantity)
    INTO number_of_ordered_copies
    FROM `ORDER` as current_orders
    WHERE current_orders.BOOK_ISBN = New.ISBN ;




    IF ( (number_of_ordered_copies is NULL AND  New.Available_copies_count < NEW.Minimum_threshold) OR
    (NEW.Available_copies_count + number_of_ordered_copies < NEW.Minimum_threshold)) then
      IF number_of_ordered_copies is NULL then
        CALL Make_order(New.ISBN, (New.Minimum_threshold - NEW.Available_copies_count ) * 2);
      else
        CALL Make_order(New.ISBN, (New.Minimum_threshold - number_of_ordered_copies - NEW.Available_copies_count ) * 2);
      end if;
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
