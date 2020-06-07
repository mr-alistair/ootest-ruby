#require_relative 'Marker.rb'
#require_relative 'Player.rb'
require_relative 'Game.rb'


x_gameover = false
x_counter = 1
x_logstring = ""

@thisGame = Game.new()

while !x_gameover

	x_logstring = "------------------------------------------------------------ #{x_counter}"
	@thisGame.g_logmove(x_logstring)

    x_logstring = "Game Move: #{x_counter}"
    
	@thisGame.g_logmove(x_logstring)
	
	x_playerid = @thisGame.g_get_playerturn()
		  
	x_gameover = @thisGame.g_player_action(x_playerid)

	for a_counter in 1..2
			for b_counter in 1..4
				x_outstring = "Player #{a_counter} Marker #{b_counter} Location: #{@thisGame.g_players[a_counter].p_pieces[b_counter].m_get_location()}"
				#print (x_outstring)
                @thisGame.g_logmove(x_outstring)
            end
    end
	
	if x_gameover
		x_clockstop = x_counter
	
	else
		#nothing

    end

	x_counter+=1
	
    @thisGame.g_flip_player()

end #while loop

@thisGame.g_dump_move_log()

print "\nFINAL MOVE: #{x_clockstop}\n"

