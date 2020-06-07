require_relative './Marker.rb'

class Player
   attr_accessor :p_pieces

   @p_playerid = 0
   @p_pieces = []
   
   def initialize(x_id)
        
        @p_playerid = x_id

        @p_pieces = [Marker.new(0)]
   
        for x_counter in 1..4

            @p_pieces.push(Marker.new(x_counter))

            @p_pieces[x_counter].m_setlocation(1)

        end
    end



    def p_get_playerid()
        return @p_playerid
    end
 
    def p_check_game_status()

        x_game_over = true

        for x_counter in 1..4

            if @p_pieces[x_counter].m_get_location() != 120

                x_game_over = false

            else
                #Do nothing
            end

        end

        return x_game_over
    end

end