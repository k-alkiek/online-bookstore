use LIBRARY_MANAGER;



# DROP TRIGGER IF EXISTS check_new_book_criteria;
# DROP TRIGGER IF EXISTS update_amount;


INSERT into PUBLISHER values ('Valley Independent Publishing', '7597 Ridgewood St.Omaha, NE 68107', '0125389545');
INSERT into PUBLISHER values ('Kanchan Bhowmik', '87 Bellevue Rd. Vicksburg, MS 39180', '5686538656');
INSERT into PUBLISHER values ('Cool Stuff Marketing Llc', '9606 Indian Summer Drive Lutherville Timonium, MD 21093', '365353655');
INSERT into PUBLISHER values ('Dragon Spirits', '270 Woodsman Street Santa Monica, CA 90403', '666330069989868');
INSERT into PUBLISHER values ('Cooperative Exchange Network', '568 Bridgeton Street New Milford, CT 06776', '6535666533');
INSERT into PUBLISHER values ('Journal Of Commerce Group', '90 Dan Street, CA 556', '0123655599');


INSERT into AUTHOR (Author_name) values ('Gloria Sloan');
INSERT into AUTHOR (Author_name) values ('Joan Cole');
INSERT into AUTHOR (Author_name) values ('Ken Sallings');
INSERT into AUTHOR (Author_name) values ('Susan Tathom');
INSERT into AUTHOR (Author_name) values ('Jazziz Omnimedia');
INSERT into AUTHOR values (9,'Jess Crable');


INSERT into BOOK values ('a-1', 'The very interesting book1', 'Science', 0.5, 5, 4, 'Valley Independent Publishing', '2019-05-4');
INSERT into BOOK values ('a-2', 'The very interesting book2', 'Science', 0.88, 5, 10, 'Valley Independent Publishing', '2019-05-5');
INSERT into BOOK values ('a-3', 'The very interesting book3', 'Science', -5, 5, 8, 'Valley Independent Publishing', '2019-05-4');
INSERT into BOOK values ('a-4', 'The very interesting book4', 'Science', 0.75, 0, -4, 'Valley Independent Publishing', '2019-05-4');
INSERT into BOOK values ('a-5', 'The very interesting book5', 'Bla', 0.75, 0, 4, 'Valley Independent Publishing', '2019-05-4');
INSERT into BOOK values ('a-6', 'The very interesting book6', 'Science', 5.4, 2, 10, 'Valley Independent Publishing', '2015-05-4');
INSERT into BOOK values ('a-7', 'The very interesting book7', 'History', 5.4, 1, 5, 'Valley Independent Publishing', '2015-06-4');
INSERT into BOOK_AUTHOR values ('a-6', 1);
INSERT into BOOK_AUTHOR values ('a-6', 2);
INSERT into BOOK_AUTHOR values ('a-7', 1);
INSERT into BOOK_AUTHOR values ('a-7', 9);

UPDATE BOOK set category = 'Art', Minimum_threshold = -4 where ISBN = 'a-6';
UPDATE BOOK set Available_copies_count = 9 where ISBN = 'a-6';
select * from `ORDER`;
SELECT * from BOOK where ISBN = 'a-6';
UPDATE BOOK set Available_copies_count = 1 where ISBN = 'a-6';
SELECT * from BOOK where ISBN = 'a-6';
select * from `ORDER`;
delete FROM `ORDER` where BOOK_ISBN = 'a-6';
UPDATE `ORDER` SET confirmed = true where BOOK_ISBN = 'a-6';
SELECT * from BOOK where ISBN = 'a-6';
delete FROM `ORDER` where BOOK_ISBN = 'a-6';
SELECT * from BOOK where ISBN = 'a-6';


INSERT INTO User VALUES (1, 'khaled@khaled.com', 'password', '7atem', 'al7atem', '+231', '123123', 1, CURDATE());
INSERT into PURCHASE values (2, 1, 'a-7', 4, 21.6, curdate());
SELECT * from BOOK where ISBN = 'a-7';

INSERT into PURCHASE values (3, 1, 'a-7', 1, 5.4, curdate());

SELECT * from BOOK;
SELECT * from PURCHASE;
SELECT * from `ORDER`;