#Member Procedure 1 Sign up
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sign_up` (
IN inEmail varchar(50),
IN inPass varchar(50)
)
Begin
IF (NOT EXISTS (Select * FROM member WHERE email = inEmail)) THEN
	INSERT INTO member(email, password) VALUES (inEmail, inPass);
ELSE
	SELECT '';
END IF;
END $$
DELIMITER ;

#Member Procedure 2: Provide personal data
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `input_personal_data` (
IN inEmail varchar(50),
IN inFname varchar(50),
IN inLname varchar(50),
IN inNationality varchar(50),
IN inAddress varchar(200)
)
BEGIN
UPDATE member
Set firstname = inFname,
	lastname = inLname,
    address = inAddress,
    nationality = inNationality
WHERE email = inEmail;
END $$
DELIMITER ;

#Member Procedure 2: Provide phone number
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `input_phone_number`(
IN inEmail varchar(50),
IN inPhoneNumber varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM phone_number WHERE phone_numbers = inPhoneNumber)) THEN
INSERT INTO phone_number (email, phone_numbers) VALUES (inEmail, inPhoneNumber);
END IF;
END $$
DELIMITER ;

#Member Procedure 3: Send friendship request
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_friendship_request`(
IN inEmail varchar(50),
IN inEmail2 varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM add_friend WHERE sender_email = inEmail and reciever_email = inEmail2 or sender_email = inEmail2 and reciever_email = inEmail)) THEN
Insert Into add_friend (sender_email, reciever_email)  Values (inEmail, inEmail2);
END IF;
END $$
DELIMITER ;

#Member Procedure 4: Search the members of the network
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_members_by_name`(
In inputString varchar(100)
)
Begin
Select firstname, lastname, email, nationality, address
From member
Where (CONCAT(firstname,' ',lastname)) like (CONCAT('%',inputString,'%'));
End $$
DELIMITER ;

#Member Procedure 4: Search the members of the network
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_members_by_email`(
In inputString varchar(50)
)
Begin
Select firstname, lastname, email, nationality, address
From member
Where email like (CONCAT('%',inputString,'%'));
End $$
DELIMITER ;

#Member Procedure 5: Search for different place pages
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_place_by_name`(
IN inputString varchar(50)
)
Begin
Select name, building_date, longitude, latitude
From place
Where name like (CONCAT('%',inputString,'%'));
End $$
DELIMITER ;

#Member Procedure 6: View information of a page
DELIMITER $$
CREATE PROCEDURE `view_information` (
IN inPID int
)
BEGIN
IF (EXISTS (SELECT * FROM hotel WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Hotel' as type, I.text
From place P inner join Information I on P.pid = I.pid
inner join hotel H on P.pid = H.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM museum WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Museum' as type, M.openinghours, M.closinghours, M.ticketprice, I.text
From place P inner join Information I on P.pid = I.pid
inner join museum M on P.pid = M.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM monument WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Monument' as type, M.description, I.text
From place P inner join Information I on P.pid = I.pid
inner join monument M on P.pid = M.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM city WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'City' as type, C.location, C.coastalcity, I.text
From place P inner join Information I on P.pid = I.pid
inner join city C on P.pid = C.pid
WHERE P.pid = inPID;
ELSE
Select P.name, P.building_date, P.longitude, P.latitude, 'Other' as type, I.text
From place P inner join Information I on P.pid = I.pid
WHERE P.pid = inPID;
END IF;
END $$
DELIMITER ;

#Member Procedure 6: View the rating criterias of a page and who added them
DELIMITER $$
CREATE PROCEDURE `view_rating_criterias_of_a_page` (
IN inPID int
)
BEGIN
Select RC.criteria_name, M.firstname, M.lastname, M.email
From rating_criteria RC inner join member M on RC.member_email = M.email
WHERE RC.pid = inPID
Group by RC.criteria_name;
END $$
DELIMITER ;

#Member Procedure 6: View the values of rating criterias of a page
DELIMITER $$
CREATE PROCEDURE `view_rate_value_of_rating_criterias` (
IN inPID int
)
BEGIN
Select criteria_name, AVG(rate_value) as average_rating
From rate
WHERE pid = inPID
Group by criteria_name;
END $$
DELIMITER ;

#Member Procedure 6: View the comments of a page
DELIMITER $$
CREATE PROCEDURE `view_comments` (
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, MC.text
From member_comment MC
inner join member M on MC.email = M.email
WHERE MC.pid = inPID and MC.type = 0;
END $$
DELIMITER ;

#Member Procedure 6: View the hashtags of a page
DELIMITER $$
CREATE PROCEDURE `view_hashtags` (
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, MC.text
From member_comment MC
inner join member M on MC.email = M.email
WHERE MC.pid = inPID and MC.type = 1;
END $$
DELIMITER ;

#Member Procedure 6: View the questions of a page
DELIMITER $$
CREATE PROCEDURE `view_questions` (
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, Q.text
From question Q
inner join member M on Q.email = M.email
WHERE Q.pid = inPID;
END $$
DELIMITER ;

#Member Procedure 6: View the answers of a question
DELIMITER $$
CREATE PROCEDURE `view_answers_of_a_question` (
IN inPID int,
inQuestionNumber int
)
BEGIN
Select M.firstname, M.lastname, M.email, A.text
From answer A
inner join member M on A.email = M.email
WHERE A.pid = inPID and A.question_number = inQuestionNumber;
END $$
DELIMITER ;

#Member Procedure 7: View pending incoming friendship requests
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_pending_incoming_requests`(
IN inEmail varchar(50)
)
BEGIN
	SELECT sender_email
    FROM add_friend
    Where reciever_email = inEmail and accept = 0;
END $$
DELIMITER ;

#Member Procedure 7: View pending outgoing friendship requests
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_pending_outgoing_requests`(
IN inEmail varchar(50)
)
BEGIN
	SELECT reciever_email
    FROM add_friend
    Where sender_email = inEmail and accept = 0;
END $$
DELIMITER ;

#Member Procedure 8: View friend list
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_friends`(
IN inEmail varchar(50)
)
BEGIN
	SELECT M1.firstname as firstname, M1.lastname as lastname, AF1.reciever_email as email
    FROM add_friend AF1
    inner join member M1 on AF1.reciever_email = M1.email
    WHERE sender_email = inEmail and accept = 1
    UNION
	SELECT M2.firstname as firstname, M2.lastname as lastname, AF2.sender_email as email
    FROM add_friend AF2
    inner join member M2 on AF2.sender_email = M2.email
    WHERE reciever_email = inEmail and accept = 1;
END $$
DELIMITER ;

#Member Procedure 9: Accept friendship request
DELIMITER $$
CREATE PROCEDURE `accept_friend_request` (
	IN email1 varchar(50),
    IN email2 varchar(50)
)
BEGIN
UPDATE add_friend
SET accept = 1
WHERE sender_email = email1 and reciever_email = email2;
END $$
DELIMITER ;

#Member Procedure 9: Reject friendship request
DELIMITER $$
CREATE PROCEDURE `reject_friend_request` (
	IN email1 varchar(50),
    IN email2 varchar(50)
)
BEGIN
DELETE FROM add_friend
WHERE sender_email = email1 and reciever_email = email2 and accept = 0;
END $$
DELIMITER ;

#Member Procedure 10: View the list of invitations to be an admin to a place
DELIMITER $$
CREATE PROCEDURE `view_invites` (
IN inEmail varchar(50)
)
BEGIN
SELECT I.admin1, P.pid, P.name
FROM invite I
inner join place P on I.pid = P.pid
WHERE I.admin2 = inEmail;
END $$
DELIMITER ;

#Member Procedure 11: Accept invitation to be an admin to a place
DELIMITER $$
CREATE PROCEDURE `accept_invitation` (
IN inRecieverEmail varchar(50),
IN inPid int
)
BEGIN
DELETE FROM invite
WHERE admin2 = inRecieverEmail and pid = inPid;
INSERT INTO manage_place VALUES (inPID, inRecieverEmail);
IF (NOT EXISTS (SELECT * FROM administrator where email = inRecieverEmail)) THEN
INSERT INTO admin (email) VALUES (inRecieverEmail);
END IF;
END $$
DELIMITER ;

#Member Procedure 11: Reject invitation to be an admin to a place
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `reject_invitation`(
IN inSenderEmail varchar(50),
IN inRecieverEmail varchar(50),
IN inPid int
)
BEGIN
DELETE FROM invite
WHERE admin1 = inSenderEmail and admin2 = inRecieverEmail and pid = inPid;
END $$
DELIMITER ;

#Member Procedure 12: View places my friends have been to
DELIMITER $$
CREATE PROCEDURE `view_places_visited_by_friends` (
IN inEmail varchar(50)
)
BEGIN
SELECT DISTINCT P.pid, P.name
FROM place P
inner join visited V on P.pid = V.pid
inner join add_friend AF on V.member_email = AF.sender_email or V.member_email = AF.reciever_email
WHERE V.member_email <> inEmail and AF.accept = 1 and (AF.sender_email = inEmail or AF.reciever_email = inEmail);
END $$
DELIMITER ;

#Member Procedure 13: Send message to a friend (The thread is defined by the pair of members)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_message`(
	IN inText varchar (1000),
    IN inEmail1 varchar(50),
    IN inEmail2 varchar(50)
)
BEGIN
IF (EXISTS (SELECT * FROM message WHERE inEmail1 = sender_email and inEmail2 = reciever_email
or inEmail1 = reciever_email and inEmail2 = sender_email)) THEN
SELECT @x := MAX(message_number) + 1 FROM message WHERE inEmail1 = sender_email and inEmail2 = reciever_email
or inEmail1 = reciever_email and inEmail2 = sender_email;
INSERT INTO message (sender_email, reciever_email, message_number, message) VALUES (inEmail1, inEmail2, @x, inText);
ELSE
INSERT INTO message (sender_email, reciever_email, message_number, message) VALUES (inEmail1, inEmail2, 1, inText);
END IF;
END $$
DELIMITER ;

#Member Procedure 14: View the thread
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_thread`(
    IN inEmail1 varchar(50),
    IN inEmail2 varchar(50)
)
BEGIN
SELECT sender_email, M1.firstname, M1.lastname, reciever_email, M2.firstname, M2.lastname, message FROM message M
inner join member M1 on sender_email = M1.email
inner join member M2 on reciever_email = M2.email
WHERE inEmail1 = sender_email and inEmail2 = reciever_email
or inEmail1 = reciever_email and inEmail2 = sender_email
ORDER BY message_number;
END $$
DELIMITER ;

#Member Procedure 15: Like a place that was visited by the user
DELIMITER $$
CREATE PROCEDURE `like_a_place` (
IN inEmail varchar(50),
IN inPID int
)
BEGIN
IF (EXISTS (Select * FROM visited WHERE member_email = inEmail and pid = inPID)) THEN
INSERT INTO member_liked VALUES (inEmail, inPID);
END IF;
END $$
DELIMITER ;

#Member Procedure 16: Check my profile or my friends profiles (Information)
DELIMITER $$
CREATE PROCEDURE `check_information_of_profile` (
IN inEmail varchar(50)
)
BEGIN
SELECT firstname, lastname, email, nationality, address
FROM member
WHERE email = inEmail;
END $$
DELIMITER ;

#Member Procedure 16: Check my profile or my friends profiles (Phone numbers)
DELIMITER $$
CREATE PROCEDURE `check_phone_numbers_of_profile` (
IN inEmail varchar(50)
)
BEGIN
SELECT phone_numbers
FROM phone_number
WHERE email = inEmail;
END $$
DELIMITER ;

#Member Procedure 16: Check my profile or my friends profiles (Images uploaded)
DELIMITER $$
CREATE PROCEDURE `open_images_uploaded_by` (
IN inEmail varchar(50)
)
BEGIN
SELECT image_file
FROM image
WHERE email = inEmail;
END $$
DELIMITER ;

#Member Procedure 17: View visited places
DELIMITER $$
CREATE PROCEDURE `view_visited_places` (
	IN inEmail varchar(50)
)
BEGIN
SELECT P.pid, P.name
FROM visited V
inner join place P on V.pid = P.pid
WHERE V.member_email = inEmail;
END $$
DELIMITER ;

#Member Procedure 18: Upload images for places liked or rated by the user
DELIMITER $$
CREATE PROCEDURE `upload_image` (
IN inEmail varchar(50),
IN inImageFile varchar(200),
IN inPID int
)
BEGIN
IF (EXISTS (Select * FROM member_liked WHERE member_email = inEmail and pid = inPID)
or EXISTS (Select * FROM rate WHERE member_email = inEmail and pid = inPID)) THEN
INSERT INTO image (email, image_file, pid) VALUES (inEmail, inImageFile, inPID);
END IF;
END $$
DELIMITER ;

#Member Procedure 19: Leave question on a page
DELIMITER $$
CREATE PROCEDURE `leave_question` (
IN inEmail varchar(50),
IN inText varchar(1000),
IN inPid int
)
BEGIN
INSERT INTO question (email, pid, text) VALUES (inEmail, inPid, inText);
END $$
DELIMITER ;

#Member Procedure 20: Add a rating criteria for a place
DELIMITER $$
CREATE PROCEDURE `add_rating_criteria` (
In inEmail varchar(50),
IN inCriteriaName varchar(50),
IN inPid int
)
BEGIN
IF (NOT EXISTS (SELECT * FROM rating_criteria WHERE pid = inPid and criteria_name = inCriteriaName)) THEN  
INSERT iNTO rating_criteria VALUES (inPid, inCriteriaName, inEmail);
END IF;
END $$
DELIMITER ;

#Member Procedure 21: Rate a specific criteria for a place
DELIMITER $$
CREATE PROCEDURE `rate_a_criteria` (
IN inEmail varchar(50),
IN inCriteriaName varchar(50),
IN inPid int,
IN inValue int
)
BEGIN
IF (NOT EXISTS (SELECT * FROM rating_criteria WHERE pid = inPid and criteria_name = inCriteriaName and member_email = inEmail)) THEN  
INSERT INTO rate VALUES (inEmail, inPid, inCriteriaName, inValue);
ELSE
UPDATE rate
SET rate_value = inValue
WHERE member_email = inEmail and pid = inPid and criteria_name = inCriteriaName;
END IF; 
END $$
DELIMITER ;

#Member Procedure 22: Add a comment for a page
DELIMITER $$
CREATE PROCEDURE `add_a_comment` (
IN inEmail varchar(50),
IN inPID int,
IN inText varchar(100)
)
BEGIN
INSERT INTO member_comment (pid, text, email, type) VALUES (inPID, inText, inEmail, 0);
END $$
DELIMITER ;

#Member Procedure 23: Add a hashtag for a page
DELIMITER $$
CREATE PROCEDURE `add_a_hashtag` (
IN inEmail varchar(50),
IN inPID int,
IN inText varchar(50)
)
BEGIN
INSERT INTO member_comment (pid, text, email, type) VALUES (inPID, inText, inEmail, 1);
END $$
DELIMITER ;

#Member Procedure 24: get the hotels with most number of likes
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_with_most_likes`()
BEGIN
SELECT H.pid, P.name as PID
FROM hotel H
inner join member_liked ML on H.pid = ML.pid
inner join Place P on H.pid = P.pid
Group by H.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select H2.pid, count(*) as count
				    From hotel H2 
				    inner join member_liked ML2 on H2.pid = ML2.pid
				    Group by H2.pid) maximum);
END $$
DELIMITER ;

#Member Procedure 24: get the cities with most number of likes
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_city_with_most_likes`()
BEGIN
SELECT C.pid, P.name as PID
FROM city C
inner join member_liked ML on C.pid = ML.pid
inner join Place P on C.pid = P.pid
Group by C.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select C2.pid, count(*) as count
				    From city C2 
				    inner join member_liked ML2 on C2.pid = ML2.pid
				    Group by C2.pid) maximum);
END $$
DELIMITER ;

#Member Procedure 24: get the museums with most number of likes
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_museum_with_most_likes`()
BEGIN
SELECT M.pid, P.name as PID
FROM museum M
inner join member_liked ML on M.pid = ML.pid
inner join Place P on M.pid = P.pid
Group by M.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select M2.pid, count(*) as count
				    From museum M2 
				    inner join member_liked ML2 on M2.pid = ML2.pid
				    Group by M2.pid) maximum);
END $$
DELIMITER ;

#Member Procedure 24: get the monuments with most number of likes
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monument_with_most_likes`()
BEGIN
SELECT M.pid, P.name as PID
FROM monument M
inner join member_liked ML on M.pid = ML.pid
inner join Place P on M.pid = P.pid
Group by M.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select M2.pid, count(*) as count
				    From monument M2 
				    inner join member_liked ML2 on M2.pid = ML2.pid
				    Group by M2.pid) maximum);
END $$
DELIMITER ;

#Member Procedure 24: get the restaurants with most number of likes
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_restaurant_with_most_likes`()
BEGIN
SELECT R.pid, P.name as PID
FROM restaurant R
inner join member_liked ML on R.pid = ML.pid
inner join Place P on R.pid = P.pid
Group by R.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select R2.pid, count(*) as count
				    From restaurant R2 
				    inner join member_liked ML2 on R2.pid = ML2.pid
				    Group by R2.pid) maximum);
END $$
DELIMITER ;

#Member Procedure 25: View museums sorted by ticket price
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_museums_sort_by_ticket_price`()
BEGIN
SELECT M.pid as PID, P.name , ticketprice as Price
FROM museum M
inner join Place P on M.pid = P.pid
Order by ticketprice asc;
END $$
DELIMITER ;

#Member Procedure 25: View hotels sorted by avg room price
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_sort_by_avg_room_price`()
BEGIN
Select H.pid as PID, P.name, AVG(R.price) as Price
From hotel H
inner join room R on H.pid = R.pid
inner join Place P on H.pid = P.pid
Group by  H.pid
Order by Price asc;
END $$
DELIMITER ;

#Member Procedure 26: View hotels sorted according the rating of a certain criteria
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_hotels_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT H.pid, P.name, AVG(R.rate_value) as Rating
FROM hotel H inner join rate R on H.pid = R.pid
inner join place P on H.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By H.pid
ORDER BY Rating DESC;
END $$
DELIMITER ;

#Member Procedure 26: View cities sorted according the rating of a certain criteria
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_cities_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT C.pid, P.name, AVG(R.rate_value) as Rating
FROM city C inner join rate R on C.pid = R.pid
inner join place P on C.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By C.pid
ORDER BY Rating DESC;
END $$
DELIMITER ;

#Member Procedure 26: View museums sorted according the rating of a certain criteria
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_museums_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT M.pid, P.name, AVG(R.rate_value) as Rating
FROM museum M inner join rate R on M.pid = R.pid
inner join place P on M.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By M.pid
ORDER BY Rating DESC;
END $$
DELIMITER ;

#Member Procedure 26: View monuments sorted according the rating of a certain criteria
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_monuments_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT M.pid, P.name, AVG(R.rate_value) as Rating
FROM monument M inner join rate R on M.pid = R.pid
inner join place P on M.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By M.pid
ORDER BY Rating DESC;
END $$
DELIMITER ;

#Member Procedure 26: View restaurants sorted according the rating of a certain criteria
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_restaurants_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT R.pid, P.name, AVG(R2.rate_value) as Rating
FROM restaurant R inner join rate R2 on C.pid = R2.pid
inner join place P on R.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By R.pid
ORDER BY Rating DESC;
END $$
DELIMITER ;

#Member Procedure 27: View top 10 users according to common likes with me
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_10_common`(
IN inEmail varchar(50)
)
BEGIN
Select M2.member_email, count(*) as likes
From (Select *
From member_liked
Where member_email = inEmail) M1
Inner join member_liked M2
On M1.pid = M2.pid and M1.member_email <> M2.member_email
Group By M2.member_email
Order By likes desc
Limit 10;
END $$
DELIMITER ;

#Member Procedure 28: Show the overall rating of a place
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_the_overall_rating_of_a_place` (
IN inPID int
)
BEGIN
SELECT AVG(Rating) as 'Overall Rating' FROM (
SELECT R.criteria_name, AVG(R.rate_value) as Rating
FROM place P inner join rate R on P.pid = R.pid
WHERE P.pid = inPID
GROUP BY R.criteria_name
) JustATableName;
END $$
DELIMITER ;

#Member Procedure 29: Show the possible recommended places to the user
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recommended_places` (
IN inEmail varchar(50)
)
BEGIN
SELECT M3.pid, PLACE.name, AVG(Rating) as 'Overall Rating'
FROM (SELECT M2.member_email, count(*) as likes
FROM (SELECT * FROM member_liked WHERE member_email = inEmail) M1
inner join member_liked M2 on M1.pid = M2.pid and inEmail <> M2.member_email
GROUP BY M2.member_email
ORDER BY likes DESC
LIMIT 10) T1
inner join member_liked M3 on T1.member_email = M3.member_email
inner join place PLACE on PLACE.pid = M3.pid
inner join (SELECT R.criteria_name, R.pid as PID,AVG(R.rate_value) as Rating
FROM place P inner join rate R on P.pid = R.pid
GROUP BY R.criteria_name
) T2 on T2.PID = M3.pid
WHERE NOT EXISTS(SELECT * FROM visited V2 WHERE V2.pid = M3.pid and V2.member_email = inEmail)
ORDER BY 'Overall Rating' DESC
LIMIT 5;
END $$
DELIMITER ;

#Admin Procedure 1: Send email to the system admin to be invited to be admin of a place
DELIMITER $$
CREATE PROCEDURE `send_email_to_be_admin_of_a_place` (
IN inEmail varchar(50),
IN inPid int,
IN sysAdminEmail varchar(50),
IN inText varchar(1000)
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO contact_to_add_place (email1, pid, email2, message) VALUES (inEmail, inPid, sysAdminEmail, inText);
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a place managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_place` (
IN inPID int,
IN inName varchar(50),
IN inDate datetime,
IN inLongitude Decimal (7,2),
IN inLatitude Decimal (7,2),
IN inInfo varchar(1000)
)
BEGIN
UPDATE place
SET name = inName, building_date = inDate, longitude = inLongitude, latitude = inLatitude
WHERE pid = inPID;
IF(NOT EXISTS (SELECT * FROM information WHERE pid = inPID)) THEN
INSERT INTO information (text) VALUES (inInfo);
ELSE
UPDATE information
SET text = inInfo
WHERE pid = inPID;
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a city managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_city` (
IN inPID int,
IN inCoastalCity bit,
IN inLocation varchar (50)
)
BEGIN
IF (EXISTS (SELECT * FROM city WHERE pid = inPID)) THEN
UPDATE city
SET coastalcity = inCoastalCity , location = inLocation
WHERE pid = inPID;
ELSE
INSERT INTO city (location, coastalcity) VALUES (inLocation, inCoastalCity);
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a restaurant managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_restaurant` (
IN inPID int,
IN inCuisine varchar (50),
IN inStyle varchar (50)
)
BEGIN
IF (EXISTS (SELECT * FROM restaurant WHERE pid = inPID)) THEN
UPDATE restaurant
SET cuisine = inCuisine , style = inStyle
WHERE pid = inPID;
ELSE
INSERT INTO restaurant (cuisine, style) VALUES (inCuisine, inStyle);
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a room managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_room` (
IN inPID int,
IN inType varchar(50),
IN inPrice decimal (9,2)
)
BEGIN
IF (EXISTS (SELECT * FROM room WHERE pid = inPID and type = inType)) THEN
UPDATE room
SET price = inPrice
WHERE pid = inPID and type = inType;
ELSE
INSERT INTO room (pid, type, price) VALUES (inPID, inType, inPrice);
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a facility managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_facility` (
IN inPID int,
IN inDescription varchar (1000)
)
BEGIN
INSERT INTO facility (pid, description) VALUES (inPID, inDescription);
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a museum managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_museum` (
IN inPID int,
IN inOpeninghours varchar (500),
IN inClosingHours varchar (500),
IN inTicketPrice decimal (9, 2)
)
BEGIN
IF (EXISTS (SELECT * FROM museum WHERE pid = inPID)) THEN
UPDATE museum
SET openinghours = inOpeninghours , closinghours = inClosingHours, ticketprice = inTicketPrice
WHERE pid = inPID;
ELSE
INSERT INTO museum (openinghours, closinghours, ticketprice) VALUES (inOpeninghours, inClosingHours, inTicketPrice);
END IF;
END $$
DELIMITER ;

#Admin Procedure 2: Enter information of a monument managed by the admin
DELIMITER $$
CREATE PROCEDURE `Enter_info_of_monument` (
IN inPID int,
IN inDescription varchar (1000)
)
BEGIN
IF (EXISTS (SELECT * FROM monument WHERE pid = inPID)) THEN
UPDATE monument
SET description = inDescription
WHERE pid = inPID;
ELSE
INSERT INTO monument (description) VALUES (inDescription);
END IF;
END $$
DELIMITER ;

#Admin Procedure 3: Upload professional photo
DELIMITER $$
CREATE PROCEDURE `upload_professional_photo` (
IN inEmail varchar(50),
IN inImageFile varchar(200),
IN inPid int
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO professional_picture (email, image_file, pid) VALUES (inEmail, inImageFile, inPid);
END IF;
END $$
DELIMITER ;

#Admin Procedure 4: Upload professional photo
DELIMITER $$
CREATE PROCEDURE `view_questions_in_my_places` (
IN inEmail varchar(50)
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
SELECT P.pid, P.name, M.firstname, M.lastname, M.email, Q.text
FROM manage_place MP
inner join place P on MP.pid = P.pid
inner join question Q on MP.pid = Q.pid
inner join member M on Q.email = M.email
WHERE MP.email = inEmail;
END IF;
END $$
DELIMITER ;

#Admin Procedure 5: Answer Question
DELIMITER $$
CREATE PROCEDURE `answer_question` (
IN inEmail varchar(50),
IN inQuestionNumber int,
IN inPid int,
IN inText varchar(1000)
)
BEGIN
IF (EXISTS (SELECT * FROM manage_place where email = inEmail and pid = inPid)) THEN
INSERT INTO answer (pid, question_number, text, email) VALUES (inPid, inQuestionNumber, inText, inEmail);
END IF;
END $$
DELIMITER ;

#Admin Procedure 6: Invite members to manage place
DELIMITER $$
CREATE PROCEDURE `invite_to_manage_my_place` (
IN inEmail1 varchar(50),
IN inEmail2 varchar(50),
IN inPid int
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail1)) THEN
INSERT INTO invite VALUES (inEmail1, inEmail2, inPid);
END IF;
END $$
DELIMITER ;

#Admin Procedure 7: View places managed by the admin
DELIMITER $$
CREATE PROCEDURE `view_places_managed_by_member` (
IN inEmail varchar(50)
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
SELECT P.pid, P.name
FROM manage_place MP
inner join place P on MP.pid = P.pid
WHERE MP.email = inEmail;
END IF;
END $$
DELIMITER ;

#Admin Procedure 8: Remove a comment from a page
DELIMITER $$
CREATE PROCEDURE `remove_comment` (
IN inPid int,
IN inCommentNumber int
)
BEGIN
DELETE FROM member_comment
WHERE pid = inPid and comment_number = inCommentNumber;
END $$
DELIMITER ;

#Admin Procedure 9: Remove a rating criteria
DELIMITER $$
CREATE PROCEDURE `remove_rating_criteria` (
IN inPid int,
IN inCriteriaName varchar(50)
)
BEGIN
DELETE FROM rating_criteria
WHERE pid = inPid and criteria_name = inCriteriaName;
DELETE FROM rate
WHERE pid = inPid and criteria_name = inCriteriaName;
END $$
DELIMITER ;

#Admin Procedure 10: Delete a page managed by the admin
DELIMITER $$
CREATE PROCEDURE `delete_page` (
IN inPid int
)
BEGIN
DELETE FROM place
WHERE pid = inPid;
END $$
DELIMITER ;

#System Admin Procedure 1: Add an admin of a place to the system
DELIMITER $$
CREATE PROCEDURE `add_admin_of_a_place` (
IN inEmail varchar(50),
IN inNameOfPlace varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO administrator (email) VALUES (inEmail);
END IF;
INSERT INTO place (name) VALUES (inNameOfPlace);
SET @last_id = LAST_INSERT_ID();
INSERT INTO manage_place (email, pid) VALUES (inEmail, @last_id);
END $$
DELIMITER ;