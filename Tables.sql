#create database tourism;

Create Table member (
    email varchar (50) Primary KEY,
	password varchar (50) NOT NULL,
    firstname varchar (50),
    lastname varchar (50),
    address varchar (200),
    nationality varchar (50)
);

Create Table phone_number (
    email varchar (50),
    phone_numbers varchar (50),
    Primary Key (email, phone_numbers),
    Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade
);

Create Table administrator (
    email varchar(50) Primary Key,
    Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade
);

Create Table sys_admin (
    email varchar(50) Primary Key,
    Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade
);

Create Table place (
    pid int Primary Key Auto_Increment,
    next_table_id int unsigned not null default 0,
    next_table_id2 int unsigned not null default 0,
    next_table_id3 int unsigned not null default 0,
    next_table_id4 int unsigned not null default 0,
    name varchar(50),
    building_date datetime,
    longitude Decimal (7,2),
    latitude Decimal (7,2)
)engine=innodb;

Create Table hotel (
    pid int Primary Key,
    next_table_id int unsigned not null default 0,
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
)engine=innodb;

Create Table room (
    pid int,
    type varchar(50),
    Primary Key(pid, type),
    price Decimal(9,2),
    Foreign Key (pid) References hotel(pid) on Delete Cascade
											on Update Cascade
);

Create Table facility (
    pid int,
    fid int,
    description varchar(1000),
    Primary Key(pid, fid),
    Foreign Key (pid) References hotel(pid) on Delete Cascade
											on Update Cascade
)engine=innodb;

delimiter $$
create trigger facility_before_ins_trig before insert on facility
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from hotel where pid = new.pid;
  set new.fid = v_id;
  update hotel set next_table_id = v_id where pid = new.pid;
end $$
delimiter ;

Create Table museum (
    pid int Primary Key,
    openinghours varchar(500),
    closinghours varchar(500),
    ticketprice Decimal(9,2),
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
);

Create Table restaurant (
    pid int Primary Key,
    style varchar(50),
    cuisine varchar(50),
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
);

Create Table monument (
    pid int Primary Key,
    description varchar(1000),
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
);

Create Table city (
    pid int Primary Key,
    location varchar(50),
    coastalcity bit,
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
);

Create Table image (
    email varchar(50),
    pid int,
    number int,
    image_file varchar(200),
    Primary Key(pid, number),
    Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade,
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
)engine=innodb;

delimiter $$
create trigger image_before_ins_trig before insert on image
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id3 + 1 into v_id from place where pid = new.pid;
  set new.number = v_id;
  update place set next_table_id3 = v_id where pid = new.pid;
end $$
delimiter ;

Create Table professional_picture (
    email varchar(50),
    pid int,
    number int,
    image_file varchar(200),
    Primary Key(pid, number),
    Foreign Key (email) References administrator(email) on Delete Cascade
														on Update Cascade,
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
)engine=innodb;

delimiter $$
create trigger professional_picture_before_ins_trig before insert on professional_picture
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id4 + 1 into v_id from place where pid = new.pid;
  set new.number = v_id;
  update place set next_table_id4 = v_id where pid = new.pid;
end $$
delimiter ;

Create Table rating_criteria (
    pid int,
    criteria_name varchar(50),
    member_email varchar(50),
    Primary Key(pid, criteria_name),
    Foreign Key (member_email) References member(email) on Delete Cascade
														on Update Cascade,
    Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade
);

Create Table rate (
	member_email varchar(50),
	pid int,
	criteria_name varchar(50),
	rate_value int,
	Primary Key (member_email, pid, criteria_name),
	Foreign Key (member_email) References member(email) on Delete Cascade
							    on Update Cascade,
	Foreign Key (pid, criteria_name) References rating_criteria(pid, criteria_name) on Delete Cascade
																					on Update Cascade
);

Create Table information (
	pid int Primary Key,
	text varchar(1000),
	admin_email varchar(50),
	Foreign Key (pid) References place(pid) on Delete Cascade
											 on Update Cascade,
	Foreign Key (admin_email) References administrator(email) on Delete Cascade
															  on Update Cascade
);

Create Table member_comment (
	pid int,
	comment_number int,
    type bit,
	Primary Key(pid, comment_number),
	text varchar(100),
	email varchar(50),
	Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade,
	Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade
)engine=innodb;

delimiter $$
create trigger member_comment_before_ins_trig before insert on member_comment
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id2 + 1 into v_id from place where pid = new.pid;
  set new.comment_number = v_id;
  update place set next_table_id2 = v_id where pid = new.pid;
end $$
delimiter ;

Create Table question (
	pid int,
    next_table_id int unsigned not null default 0,
	question_number int,
	text varchar(1000),
	email varchar(50),
	Primary Key (pid, question_number),
	Foreign Key (pid) References place(pid) on Delete Cascade
											on Update Cascade,
	Foreign Key (email) References member(email) on Delete Cascade
												 on Update Cascade																			
)engine=innodb;

delimiter $$
create trigger question_before_ins_trig before insert on question
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from place where pid = new.pid;
  set new.question_number = v_id;
  update place set next_table_id = v_id where pid = new.pid;
end $$
delimiter ;

Create Table answer (
	pid int,
	question_number int,
	answer_number int,
	text varchar(1000),
	email varchar(50),
	Primary Key(pid, question_number, answer_number),
	Foreign Key (pid, question_number) References question (pid, question_number) on Delete Cascade
																				  on Update Cascade,
	Foreign Key (email) references member (email) on Delete Cascade
												  on Update Cascade
)engine=innodb;

delimiter $$
create trigger answer_before_ins_trig before insert on answer
for each row
begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from question where pid = new.pid and question_number = new.question_number;
  set new.answer_number = v_id;
  update question set next_table_id = v_id where pid = new.pid and question_number = new.question_number;
end $$
delimiter ;

Create Table contact_to_add_place (
	email1 varchar(50),
	pid int,
	email2 varchar(50),
	message varchar(1000),
	Primary Key (email1, pid),
	Foreign Key (email1) References administrator (email) on Delete Cascade
														  on Update Cascade,
	Foreign Key (pid) References place (pid) on Delete Cascade
											 on Update Cascade,
	Foreign Key (email2) References sys_admin (email) on Delete Cascade
													   on Update Cascade
);

Create Table invite (
	admin1 varchar (50),
	admin2 varchar (50),
	pid int,
	Primary Key (admin1, admin2, pid),
	Foreign Key (admin1) References administrator (email) on Delete Cascade
														  on Update Cascade,
	Foreign Key (admin2) References member (email) on Delete Cascade
														  on Update Cascade,																	 
	Foreign Key (pid) References place (pid) on Delete Cascade
											 on Update Cascade
);

Create Table manage_place (
	pid int,
	email varchar (50),
	Primary Key (pid, email),
	Foreign Key (pid) References place (pid) on Delete Cascade
											 on Update Cascade,
	Foreign Key (email) References administrator (email) on Delete Cascade
														 on Update Cascade
);

Create Table add_friend (
	sender_email varchar (50),
	reciever_email varchar (50),
	accept bit default 0,
	Primary Key (reciever_email, sender_email),
	Foreign Key (reciever_email) References member (email) on Delete Cascade
														   on Update Cascade,
	Foreign Key (sender_email) References member (email) on Delete Cascade
														 on Update Cascade
);

 Create Table message (
 	sender_email varchar (50),
	reciever_email varchar (50),
	message_number int,
	message varchar(1000),
	Primary Key (reciever_email, sender_email, message_number),
	Foreign Key (reciever_email) References member (email) on Delete Cascade
														   on Update Cascade,
	Foreign Key (sender_email) References member (email) on Delete Cascade
														 on Update Cascade
);

Create Table visited (
	member_email varchar (50),
	pid int,
	Primary Key (member_email, pid),
	Foreign Key (member_email) References member (email) on Delete Cascade
														 on Update Cascade,
	Foreign Key (pid) References place (pid) on Delete Cascade
											 on Update Cascade
);

Create Table member_liked (
	member_email varchar (50),
	pid int,
	Primary Key (member_email, pid),
	Foreign Key (member_email) References member (email) on Delete Cascade
														 on Update Cascade,
	Foreign Key (pid) References place (pid) on Delete Cascade
											 on Update Cascade
);