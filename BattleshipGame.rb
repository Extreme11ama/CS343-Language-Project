class Battlefield
    attr_accessor :grid, :player1_ships, :player2_ships
  
    SHIP_SYMBOL = 'S'
    HIT_SYMBOL = 'X'
    EMPTY_SYMBOL = '-'

    def initialize
        @grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        @player1_ships = [[1,1], [2,3], [5,6]]
        @player2_ships = [[3,4], [6,5], [7,7]]
    end

    def display_grid
        @grid.each { |row| puts row.join(' ') }
    end



end 


class Game
    
    def initialize
      @battlefield = Battlefield.new
      play
    end

    def play
        @battlefield.display_grid
    end
    

end 

Game.new


