call tourism.sign_up('ziadelwa7sh@hotmail.com', 'lafajag');

call tourism.input_personal_data('ziadelwa7sh@hotmail.com', 'Ziad', 'Hassan', 'Egyptian', 'Cairo, Hussien Kamel, 70');

call tourism.input_phone_number('ziadelwa7sh@hotmail.com', '0111855588');

call tourism.send_friendship_request('ansary510@gmail.com', 'kimobasha3000@hotmail.com');
call tourism.send_friendship_request('blueberry@yahoo.com', 'ansary510@gmail.com');

call tourism.search_members_by_name('karim');
call tourism.search_members_by_email('ansary');

call tourism.search_place_by_name('andi');

call tourism.view_information(1);
call tourism.view_rating_criterias_of_a_page(1);
call tourism.view_rate_value_of_rating_criterias(1);
call tourism.view_comments(1);
call tourism.view_hashtags(1);
call tourism.view_questions(1);
call tourism.view_answers_of_a_question(1, 1);

call tourism.view_pending_incoming_requests('kimobasha3000@hotmail.com');
call tourism.view_pending_outgoing_requests('kimobasha3000@hotmail.com');

call tourism.view_friends('kimobasha3000@hotmail.com');

call tourism.accept_friend_request('ansary510@gmail.com', 'blueberry@yahoo.com');
call tourism.reject_friend_request('kimobasha3000@hotmail.com', 'ansary510@gmail.com');

call tourism.view_invites('kimobasha3000@hotmail.com');

call tourism.accept_invitation('kimobasha3000@hotmail.com', 10);

call tourism.reject_invitation('ansary510@gmail.com', 'kimobasha3000@hotmail.com', 11);

call tourism.view_places_visited_by_friends('ansary510@gmail.com');

call tourism.send_message('Hello, how was today\'s networks quiz?', 'ansary510@gmail.com', 'blueberry@yahoo.com');
call tourism.send_message('It was awful :((, my parents are gonna spank me', 'blueberry@yahoo.com', 'ansary510@gmail.com');
call tourism.send_message('Hello, how was today\'s networks quiz?', 'ansary510@gmail.com', 'kimobasha3000@hotmail.com');
call tourism.send_message('Easy Peasy Lemon squeezy =)))', 'kimobasha3000@hotmail.com', 'ansary510@gmail.com');

call tourism.view_thread('kimobasha3000@hotmail.com', 'ansary510@gmail.com');
call tourism.view_thread('ansary510@gmail.com', 'kimobasha3000@hotmail.com');

call tourism.like_a_place('kimobasha3000@hotmail.com', 6);

call tourism.check_information_of_profile('kimobasha3000@hotmail.com');
call tourism.check_phone_numbers_of_profile('kimobasha3000@hotmail.com');
call tourism.open_images_uploaded_by('kimobasha3000@hotmail.com');

call tourism.view_visited_places('kimobasha3000@hotmail.com');

call tourism.upload_image('kimobasha3000@hotmail.com', 'Terass.jpg', 1);

call tourism.leave_question('ansary510@gmail.com', 'How much do they charge for a cinema ticket?' ,2);

call tourism.add_rating_criteria('blueberry@yahoo.com', 'Rooms ', 2);

call tourism.rate_a_criteria('blueberry@yahoo.com', 'Value', 1, 4);

call tourism.add_a_comment('blueberry@yahoo.com', 1, 'Awesome! Had the night of my life!');

call tourism.add_a_hashtag('ansary510@gmail.com', 1, '#WOW');

call tourism.get_hotel_with_most_likes();
call tourism.get_museum_with_most_likes();
call tourism.get_city_with_most_likes();
call tourism.get_monument_with_most_likes();
call tourism.get_restaurant_with_most_likes();

call tourism.get_museums_sort_by_ticket_price();
call tourism.get_hotels_sort_by_avg_room_price();

call tourism.send_email_to_be_admin_of_a_place('ansary510@gmail.com', 1, 'kimobasha3000@hotmail.com', 'I really like this place. Can I manage it?');

call tourism.Enter_info_of_place(1, 'Dandi Mall', '2000-05-14', 31, 78.24, 'A very good place to visit');
call tourism.Enter_info_of_city(10, 1, 'Egypt');
call tourism.Enter_info_of_restaurant(18, 'American', 'American');
call tourism.Enter_info_of_room(3, 'Single', 100);
call tourism.Enter_info_of_facility(3, 'Pool: Great Pool for people of all ages');
call tourism.Enter_info_of_museum(8, 'Everyday at 14:00', 'Everyday at 21:00', 9.50);
call tourism.Enter_info_of_monument(15, 'House of Horror');

call tourism.upload_professional_photo('ansary510@gmail.com', 'beach.jpg', 10);

call tourism.view_questions_in_my_places('kimobasha3000@hotmail.com');

call tourism.answer_question('kimobasha3000@hotmail.com', 1, 1, 'Kindly note, that the ticket now costs 60$');

call tourism.invite_to_manage_my_place('ansary510@gmail.com', 'marwa@hotmail.com', 10);

call tourism.view_places_managed_by_member('kimobasha3000@hotmail.com');

call tourism.remove_comment(1, 1);

call tourism.remove_rating_criteria(2, 'Rooms');

call tourism.delete_page(20);

call tourism.add_admin_of_a_place('kaltaz80@gmail.com', 'Starbucks');