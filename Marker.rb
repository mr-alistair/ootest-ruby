class Marker
   
  @m_location = 0
   
  def initialize(x_id)
     @m_location = 1
  end

  def m_calclocation(x_dieroll)
     @x_calcvalue = (@m_location * x_dieroll)
     return @x_calcvalue
  end

  def m_setlocation (x_newlocation)
      @m_location = x_newlocation
  end

  def m_get_location()
      return @m_location
  end

  def m_get_status()
      if @m_location == 120 
          return false
      else
          return true
      end
   end

end