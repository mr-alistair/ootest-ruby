require_relative 'Marker.rb'
require_relative 'Player.rb'


class Game
    attr_accessor :g_players

    @g_movecounter = 0
	@g_movelog = []
	@g_playerturn = 0
	@g_players = []
	@g_dievalue = 0
	@g_gameover = false
   
    def initialize()
        g_newgame()
		@g_movecounter = 0
        @g_playerturn = g_get_random(2)
        @g_movelog = ["START"]
		g_logmove( "Player #{@g_playerturn} will go first." )
		@g_dievalue = 0
		@g_gameover = false
    end

    def g_get_random(x_upper)
        return rand(1..x_upper)
    end

    def g_newgame()
        @g_players = [Player.new(0), Player.new(1), Player.new(2)]
    end

    def g_logmove(x_logmove)
		@g_movecounter+=1
        g_now = Time.new
		g_now_string = g_now.strftime("%Y-%m-%d %H:%M:%S") + " - - " + x_logmove
		@g_movelog.push(g_now_string)
		#print(g_now_string)
    end

    def g_flip_player()
		if @g_playerturn == 1
			@g_playerturn = 2
		else
            @g_playerturn = 1
        end
    end

	def g_diceroll()
		@g_dievalue = g_get_random(6)
		@g_dievalue
    end

    def g_return_other_player()
        if @g_playerturn == 1
			@x_player = @g_players[2]
        else 
            @x_player = @g_players[1]
        end

        return @x_player
    end

	def g_return_player(x_playerid)
        return g_players[x_playerid]
    end

    def g_find_to_move_onto_board(x_player)
		#temp properties
		x_piece_array_pointer = [0,0,0,0,0]
		x_logstring = ""      
		x_counter_array = 0
        x_counter = 0
        x_return_value = 0

		for x_counter in 1..4
			if x_player.p_pieces[x_counter].m_get_location() == 1
			   x_counter_array+=1
			   x_piece_array_pointer[x_counter_array] = x_counter
			else
                #nothing
            end
        end

		#If there is one or more, return one at random
        if x_counter_array > 0
            x_return_value = x_piece_array_pointer[g_get_random(x_counter_array)]
		else
    		# there were no markers "off the board" ... return an empty pointer
			x_logstring = "Player #{x_player.p_get_playerid()} was in SET D but could not find markers to move onto the board..."
			g_logmove(x_logstring)
			x_return_value = 0
        end

        return x_return_value
    end

    def g_find_to_move_in_play(x_player)
	
		#temp properties
		x_piece_array_pointer = [0,0,0,0,0]
        x_piece_array_backup = [0,0,0,0,0]
        x_return_value = 99
		x_logstring = ""
		x_test_1 = false
		x_test_2 = false
		x_counter_array = 0
        x_temp_value = 0
        x_counter_a, x_counter_b, x_counter_loop_a,x_counter_loop_b,x_counter_loop_c,x_counter_loop_d = 0,0,0,0,0,0

		x_temp_magic_numbers = [20,24,30,40,60]

		#FOR1
		for x_counter_a in 1..4

       		#find a player's marker which is active
			if x_player.p_pieces[x_counter_a].m_get_status() == true
				x_counter_array+=1
				x_piece_array_pointer[x_counter_array] = x_counter_a
				x_piece_array_backup[x_counter_array] = x_counter_a
			else
				#nothing
            end		
        end

		#BIGIF1
		#If there is one or more, return one at random
		if x_counter_array > 0
			x_logstring = "Considering between #{x_counter_array} potential piece(s)."
			g_logmove(x_logstring)
			#FOR2
			for x_counter_loop_a in 1..x_counter_array

				x_test_1 = false		
				x_test_2 = false

				x_temp_value = x_piece_array_pointer[x_counter_loop_a]
		
				x_logstring = "Step #{x_counter_loop_a} of #{x_counter_array} ...Looking at piece: #{x_temp_value} at location #{x_player.p_pieces[x_temp_value].m_get_location()}"
	
				g_logmove(x_logstring)
		
                x_test_1 = x_temp_magic_numbers.include?(x_temp_value)

				if x_test_1
					x_logstring = "Considering ignoring piece #{x_temp_value} as it is on a penultimate number."
					g_logmove(x_logstring)
				else
                    #nothing
                end

				if (x_player.p_pieces[x_temp_value].m_get_location() * @g_dievalue) > 120
					x_test_2 = true
					x_logstring = "Considering ignoring piece #{x_temp_value} as it may cause a blowout."
					g_logmove(x_logstring)
				else
                    #nothing
                end

				if x_test_1 || x_test_2
					x_piece_array_backup[x_counter_loop_a] = 999
				else
                    #nothing
                end
	
            end				#ENDFOR2
			########################
			# find the number of pieces in the backup array
			#FOR3
			for x_counter_loop_b in 1..4 
				if (x_piece_array_backup[x_counter_loop_b] != 999) and (x_piece_array_backup[x_counter_loop_b] > 0)
					x_counter_b+=1
				else
                    #nothing
                end
            end
			#ENDFOR3
			##################################################	

			#pick a pointer at random from the remainder    
			#BIG IF 2
			if x_counter_b == 0
				x_temp_value = 0
				x_logstring = "Ignored too many...reverting."
				g_logmove(x_logstring)
				for x_counter_loop_c in 1..4
					if x_piece_array_pointer[x_counter_loop_c] != 999 and x_piece_array_pointer[x_counter_loop_c] > 0
						x_temp_value+=1
					else
                        #nothing
                    end
                #ENDFOR
                end

				x_logstring = "Player #{x_player.p_get_playerid()} has #{x_temp_value} possible piece(s) to move."
				g_logmove(x_logstring)
                x_test_1 = true
                
				while x_test_1
					x_counter_array = g_get_random(4)	
					if x_piece_array_pointer[x_counter_array] > 0 and x_piece_array_pointer[x_counter_array] != 999
						x_test_1 = false # FOUND ONE TO MOVE AND IT IS IN THE ARRAY_POINTER AT POSITION X_COUNTER_ARRAY
					else
                        #nothing
                    end
                end
                #END WHILE
                
			else	#BRANCH ELSE
				#pick one from the backup array to use
				x_temp_value = 0
				for x_counter_loop_d in  1..4 
					if (x_piece_array_backup[x_counter_loop_d] != 999) and (x_piece_array_backup[x_counter_loop_d] > 0)
						x_temp_value+=1
					else
                        #nothing
                    end
                end
				
				#END FOR
				
				x_logstring = "Choosing one from the remaining markers..." #must choose a random from the remaining 'good' pointers in the live array
				g_logmove(x_logstring)
				x_logstring = "Player #{x_player.p_get_playerid() } has #{x_temp_value} possible piece(s) to move which are on the board..."
				g_logmove(x_logstring)

                x_test_1 = true
                
				while x_test_1
					x_counter_array = g_get_random(4)
					if (x_piece_array_backup[x_counter_array] > 0) and (x_piece_array_backup[x_counter_array] != 999)
						x_test_1 = false  #found one to move	
					else
                        #nothing
                    end
                end
				#END WHILE
			#END BIG IF 2
            end

			x_logstring = "Player #{x_player.p_get_playerid()} has chosen to move piece #{x_piece_array_pointer[x_counter_array]}"
		
			g_logmove(x_logstring)

		else  #BIG IF 1 BRANCH 
				#there were no markers 'on the board'...return an empty pointer;
		#this is captured by the calling function and acted upon        
			x_return_value = 0
        end
        
        if x_return_value != 0
            x_return_value =  x_piece_array_pointer[x_counter_array]
        end

        return x_return_value
    
    end


    def g_move_onto_board_set_D(x_player)
        x_return_value = false
        
		x_piece_pointer = g_find_to_move_onto_board(x_player)

		if x_piece_pointer == 0
			
			#no more pieces to move on to the board
			x_logstring = "Player #{x_player.p_get_playerid()} did not have pieces to move into play."
			g_logmove(x_logstring)
			
			x_return_value = false

        else
            
			g_marker_move(x_player.p_get_playerid(), x_piece_pointer)
								
            x_return_value = true
        end

        return x_return_value
    end


	def g_marker_move(x_playerid, x_piece_pointer)

		x_logstring = ""
		x_text = ""
		x_old_position = 0
		x_new_location = 0
		x_other_player = g_return_other_player()
		x_old_position = g_players[x_playerid].p_pieces[x_piece_pointer].m_get_location()

			
		if @g_dievalue != 0
			x_pass_value = @g_dievalue
			x_new_location = @g_players[x_playerid].p_pieces[x_piece_pointer].m_calclocation(x_pass_value)
		else
			#Piece has been bumped to the start either due to clash or blow-out
			x_new_location = 1
        end

		if x_new_location > 120
	
			#blow-out!
			x_logstring = "Player #{x_playerid} busted piece #{x_piece_pointer} to a value of #{x_new_location} !"
			g_logmove(x_logstring)
			x_new_location = 1
		else
            #nothing
        end
	
	
		@g_players[x_playerid].p_pieces[x_piece_pointer].m_setlocation(x_new_location)

		x_logstring = "[[[Player #{x_playerid} moved piece #{x_piece_pointer} from position #{x_old_position} to #{@g_players[x_playerid].p_pieces[x_piece_pointer].m_get_location()} ]]]"

		g_logmove(x_logstring)



		if x_new_location == 120
			#piece has made it to the end and will be disabled

			if @g_players[x_playerid].p_pieces[x_piece_pointer].m_get_status()
				x_text = "ACTIVE"
			else
				x_text = "INACTIVE"
            end

			x_logstring = "Player #{x_playerid}'s piece #{x_piece_pointer} has reached position #{@g_players[x_playerid].p_pieces[x_piece_pointer].m_get_location()} successfully and is now #{x_text}"

			g_logmove(x_logstring)
		else
            #nothing
        end

		#call clash detect unless it has moved to 1
		if (x_new_location != 1) and (x_new_location != 120)
				g_detect_clash(@g_players[x_playerid].p_pieces[x_piece_pointer].m_get_location(), x_other_player)
		else
            #nothing
        end
	
		
        @g_gameover = @g_players[x_playerid].p_check_game_status()
        
    end 

	def g_detect_clash(x_location, x_player)
		
		#iterate through opposing players active pieces and reset them if the new move has caused a clash

		x_return_flag = false

		for x_counter in  1..4
			#find an (opposition) player's marker which is on the board but active

			if (x_player.p_pieces[x_counter].m_get_location() == x_location and x_player.p_pieces[x_counter].m_get_status())
				#bump the clash piece
				@g_dievalue = 0
				g_marker_move(x_player.p_get_playerid(), x_counter)
				x_logstring = "Player #{x_player.p_get_playerid()}'s piece #{x_counter} was bumped to the start of the board!"
				g_logmove(x_logstring)
				x_return_flag = true
			else
				#if it doesn't find a clash, do nothing
                #nothing
            end
        end

		return x_return_flag
    end


	def g_player_action(x_playerid)
		
		x_result = false
		x_test = ""
		x_temp_magic_numbers = [ 0, 20, 24, 30, 40, 60, 120 ]
		x_temp_factor_numbers = [ 0, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 25, 50 ]
		x_logstring = ""

		@g_dievalue = g_diceroll()

		x_logstring = "[[[Player #{x_playerid} rolled a #{@g_dievalue} ]]]"

		g_logmove(x_logstring)


		if @g_dievalue == 1
				x_logstring = "Player #{x_playerid} has to forfeit their move!"
				g_logmove(x_logstring)
		else
				#SET A
				x_result = g_target_magic_numbers(x_playerid, x_temp_magic_numbers, "penultimate",6)

				#SET B
				if !x_result
					x_logstring = "Player #{x_playerid} did not find any penultimate targets."
					g_logmove(x_logstring)
					x_result = g_target_magic_numbers(x_playerid, x_temp_factor_numbers, "factor", 12)
				else
                    #nothing
                end

				
				#SET C
				if !x_result
					x_logstring = "Player #{x_playerid} did not find any factor targets."
					g_logmove(x_logstring)

					x_result = g_target_potential_clashes_set_C(@g_players[x_playerid])

				else
                    #nothing
                end

				#SET D
				if !x_result
					x_result = g_move_onto_board_set_D(@g_players[x_playerid])
					g_logmove("SET D result is #{x_result}")

				else
                    #nothing
                end
        end

		if (@g_gameover)
				print("**************************************\n");
				print("***   Player #{x_playerid} HAS WON THE MATCH! ***\n");
				print("**************************************\n");

				g_logmove("************************************");
				x_logstring = "***   Player #{x_playerid} HAS WON THE MATCH! ***"
				g_logmove(x_logstring)

				self.g_logmove("************************************");

		else
            #nothing
            
        end

		return @g_gameover
    
    end

	def g_target_magic_numbers(x_playerid, x_magicnumbers, x_type, x_magic_count)
		x_forecast_dummy = [0,0,0] 
		x_forecast_pointers = [x_forecast_dummy,x_forecast_dummy,x_forecast_dummy,x_forecast_dummy,x_forecast_dummy] 
		x_found_target = false
		x_test_count_flag = false
		x_piece_pointer = 0
		x_counter = 0
		x_counter_m = 0
		x_counter_test = 0
		x_temp_forecast = 0

		#populate current players positions and status to temporary array
		for x_counter_a in 1..4
			if !@g_players[x_playerid].p_pieces[x_counter_a].m_get_status()
				#this piece is out of play - set up a dummy which will never get hit
				x_forecast_pointers[x_counter_a][0] = x_counter_a
				x_forecast_pointers[x_counter_a][1] = 999
				x_forecast_pointers[x_counter_a][2] = 0
			else
				#otherwise, put in a forecast of where it would land based on the dice roll
				x_forecast_pointers[x_counter_a][0] = x_counter_a
				x_forecast_pointers[x_counter_a][1] = @g_players[x_playerid].p_pieces[x_counter_a].m_get_location() * @g_dievalue
				x_forecast_pointers[x_counter_a][2] = 0
            end
        end
	
		#now for each potential location see if there is a match in magic numbers
		for x_counter_m in 1..4 
			x_temp_forecast = x_forecast_pointers[x_counter_m][1]

            if x_magicnumbers.include?(x_temp_forecast) 
				#found one
				x_forecast_pointers[x_counter_m][2] = 1
			else
				#nothing
            end
        end

		#clear the array of player's pieces that are not a magic target
		x_test_count_flag = false

		for x_counter_test in 1..4 
			if x_forecast_pointers[x_counter_test][2] == 1
				#found at least one
				x_test_count_flag = true
			else
				# set the rest to dummy
                x_forecast_pointers[x_counter_test][2] = 999
            end
        end

        #got at least one potential target
		if x_test_count_flag
			#now we have an array of only the possible markers to select to target
			#loop until we find one that is not 999

			while !x_found_target
				x_counter_c = g_get_random(4) 
				if x_forecast_pointers[x_counter_c][2] != 999
					#the piece we choose to move
					x_piece_pointer = x_forecast_pointers[x_counter_c][0]
					x_logstring = "Player #{x_playerid} is selecting #{x_type} target at location #{x_forecast_pointers[x_counter_c][1]} with piece #{x_piece_pointer}              ***"
					g_logmove(x_logstring)
					g_marker_move(x_playerid,  x_piece_pointer)
					x_found_target = true
				else
                    #nothing
                end
            end

		else
			x_found_target = false

        end

		return x_found_target
	
    end



    def g_target_potential_clashes_set_C(x_player)

		#properties
		x_temp_pointer_list = [0,0,0,0,0]
		x_forecast_pointers = [x_temp_pointer_list,x_temp_pointer_list,x_temp_pointer_list,x_temp_pointer_list,x_temp_pointer_list]
		x_found_target = false
		x_test_count_flag = false
		x_piece_pointer = 0
		x_temp_branch = 2
		x_counter = 0
		x_counter_o = 0
		x_counter_p = 0
		x_counter_test = 0
		x_temp_opp_location = 0
		x_temp_opp = g_return_other_player()
		x_offboard_flag = false
		x_onboard_flag = false

		#populate current players positions and status to temporary array
		for x_counter in 1..4
			if !x_player.p_pieces[x_counter].m_get_status()
				#this piece is out of play - set up a dummy which will never get hit
				x_forecast_pointers[x_counter][0] = x_counter
				x_forecast_pointers[x_counter][1] = 999
				x_forecast_pointers[x_counter][2] = 0
			else
				#otherwise, put in a forecast of where it would land based on the dice roll
				x_forecast_pointers[x_counter][0] = x_counter
				x_forecast_pointers[x_counter][1] = x_player.p_pieces[x_counter].m_get_location() * @g_dievalue
                x_forecast_pointers[x_counter][2] = 0
            end
        end

		#now for each potential location see if there is a match in the opponent's pieces

		for x_counter_o in  1..4
			if !x_temp_opp.p_pieces[x_counter_o].m_get_status()
				#opp position is out of play and should be ignored -  dummy value
				x_logstring = "Ignoring target piece #{x_counter_o} as it is out of play."
				g_logmove(x_logstring)
				x_temp_opp_location = 888
			else
				#hold the location of a potential target piece to hit
                x_temp_opp_location = x_temp_opp.p_pieces[x_counter_o].m_get_location()
            end

			for x_counter_p  in 1..4
				#check that the locations match and that the opponents piece  is not at the start, or inactive:
				if x_forecast_pointers[x_counter_p][1] == x_temp_opp_location and x_temp_opp_location != 1 and x_temp_opp_location != 888
					#we have a potential target
					x_forecast_pointers[x_counter_p][2] = 1
					x_logstring = "Player #{x_temp_opp.p_get_playerid()}'s marker #{x_counter_o} at location #{x_temp_opp.p_pieces[x_counter_o].m_get_location()} is a target of piece #{x_counter_p}"
					g_logmove(x_logstring)
					break
				else
                    #nothing
                end
            end
			#move on to next player piece
        end
		 #move on to next opponent piece


		#clear the array of player's pieces that are not a likely hit
		x_test_count_flag = false

		for x_counter_test in 1..4
			if x_forecast_pointers[x_counter_test][2] == 1
				#found at least one
				x_test_count_flag = true
			else
				x_forecast_pointers[x_counter_test][0] = 999
            end
        end

		#got at least one potential target
		if x_test_count_flag
			x_counter = 0
			while not x_found_target
				x_counter =  g_get_random(4) 
				if x_forecast_pointers[x_counter][0] != 999
					x_piece_pointer = x_forecast_pointers[x_counter][0]
					x_logstring = "Player #{x_player.p_get_playerid()} has targets to consider and chose to move piece #{x_piece_pointer}"
					g_logmove(x_logstring)
					g_marker_move(x_player.p_get_playerid(), x_piece_pointer)
					x_found_target = true
                    #return x_found_target
                end
            end
		else
			x_logstring = "Player #{x_player.p_get_playerid()} could not find a clash target so is going to find a pointer at random to move."
			g_logmove(x_logstring)

			#toss up between on or off board
			x_offboard_flag = false

			x_onboard_flag = false
			for x_counter in  1..4
				#loop and see if there is a mix of on-board or off-board marker; do a coin toss if there is
				if x_player.p_pieces[x_counter].m_get_location() == 1 and x_player.p_pieces[x_counter].m_get_status()
					x_offboard_flag = true  #we could get a piece off the board
				else
                    #nothing
                end

				if x_player.p_pieces[x_counter].m_get_location() > 1 and x_player.p_pieces[x_counter].m_get_status()
					x_onboard_flag = true  # we could get a piece on the board
				else
                    #nothing
                end
            end
			
			if x_onboard_flag
				if x_offboard_flag
					#choice is a wonderful thing - 1 is on-board, 2 is off-board
					x_temp_branch = g_get_random(2)  
				else
					x_temp_branch = 1
                end
            end

			if x_temp_branch == 1
				x_piece_pointer = 0
				g_logmove("Finding a piece on the board.")
				x_piece_pointer = g_find_to_move_in_play(x_player)


				if x_piece_pointer != 0
					#found one... move it        
					g_marker_move(x_player.p_get_playerid(), x_piece_pointer)
					x_found_target = true
				else
					#didn't find one, have to force to go down the SET D path.
					x_temp_branch = 0
                    x_found_target = false
                end
            end

			if x_temp_branch == 0
				x_found_target = false
				g_logmove("Finding a piece OFF the board using SET D.")
			else
				#nothing
            end
        
        end

        return x_found_target

    end #end of function

    def g_get_playerturn()
		#this is a test
            return @g_playerturn
    end

    def g_dump_move_log()
        x_counter = 0
        for x_counter in 1..@g_movelog.length()
            print @g_movelog[x_counter]
            print "\n"
        end
    end
end