#The inner workings of the game
class Battlefield
    attr_accessor :player_grid, :player_attack_grid, :computer_grid, :player_ships, :computer_ships
  
    SHIP_SYMBOL = 'S'
    HIT_SYMBOL = '*'
    MISS_SYMBOL = 'o'
    EMPTY_SYMBOL = '-'
  
    def initialize
        #Player's top board
        @player_attack_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Players bottom board
        @player_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Enemy board
        @computer_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Example ships
        @player_ships = [[1,1], [2,3], [5,6]]
        @computer_ships = [[3,4], [6,5], [7,7]]
    end
  
    #Chooses which boards to display
    def display_grids(show_computer)
        puts "Attack Grid: "
        display_grid(@player_attack_grid)
        puts "Player's Grid:"
        displayShips(@player_grid, @player_ships)
        if show_computer == "yes" 
            puts "\nComputer's Grid:"
            displayShips(@computer_grid, @computer_ships)
        end
    end

    #Method to display player's ships on board
    def displayShips(grid, ship)
        grid.each_with_index do |row, i|
            row.each_with_index do |cell, j|
                if ship.include?([i, j])
                    print "#{SHIP_SYMBOL} "
                else
                    print "#{cell} "
                end
            end
        puts #newline
        end
    end
  
    #Method ethod to display board
    def display_grid(grid)
        grid.each { |row| puts row.join(' ') }
    end
  
    #Player attack method. 
    def attack(x, y)
        if @computer_ships.include?([x, y])
            @computer_grid[x][y] = HIT_SYMBOL
            @player_attack_grid[x][y] = HIT_SYMBOL
            puts "HIT"
            @computer_ships.delete([x, y])
            sleep(1)
        else
            @computer_grid[x][y] = MISS_SYMBOL
            @player_attack_grid[x][y] = MISS_SYMBOL
            puts "MISS"
            sleep(1)
        end
    end
  
    #Computer Attack Method
    def computer_attack
        x = rand(10)
        y = rand(10)
        if @player_ships.include?([x, y])
            @player_grid[x][y] = HIT_SYMBOL
            puts "Computer hit at #{x},#{y}!"
            @player_ships.delete([x,y])
            sleep(1)
        else
            @player_grid[x][y] = MISS_SYMBOL
            puts "Computer missed at #{x},#{y}!"
            sleep(1)
        end
    end
  
    #Game over method
    def game_over?
        @player_ships.empty? || @computer_ships.empty?
    end
end
  


  #The gameplay class
class Game
    #Initializes the game
    def initialize
        @battlefield = Battlefield.new
        @show_computer = choose_display
        playGame
    end

    #CHoose whether to see computer's board
    def choose_display
        puts "Do you want to see the computer's grid? (yes/no)"
        choice = gets.chomp.downcase
        until ["yes", "no"].include?(choice)
            puts "Invalid choice! Please enter 'yes' or 'no'."
            choice = gets.chomp.downcase
        end
        choice
    end
  
    #Gameplay loop
    def playGame
        until @battlefield.game_over?
            @battlefield.display_grids(@show_computer)
            puts "Your turn (Enter coordinates in format 'x, y', or type 'exit' to quit the game):"

            input = gets.chomp.strip.downcase
            if input == "exit"
                puts "Thanks for playing!"
                return
            end

            x_str, y_str = input.split(",")
            x = x_str.to_i - 1 # rows are zero indexed
            y = y_str.to_i - 1

            @battlefield.attack(x, y)
  
            break if @battlefield.game_over?
  
            @battlefield.computer_attack
        end
  
        puts "Game Over! You #{player_with_remaining_ships? ? 'win' : 'lose'}!"
    end
  
    #Method to see if player has won
    def player_with_remaining_ships?
        !@battlefield.player_ships.empty?
    end

end

#Game instance
Game.new
  