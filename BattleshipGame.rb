# Name: Wasif Ramzan, Lennon Green, Vincent Sisu
# Course/Semester: CS343, Spring


#Module to help with ship randomization 
module ShipRandomizer
    def randomize_ship(length)
        ship = []
        horizontal = rand(2) == 0
        if horizontal
            start_x = rand(10 - length)
            start_y = rand(10)
            length.times { |i| ship << [start_x + i, start_y] }
        else
            start_x = rand(10)
            start_y = rand(10 - length)
            length.times { |i| ship << [start_x, start_y + i] }
        end
        ship
    end
end

#The inner workings of the game
class Battlefield
    #Attribute accessors 
    attr_accessor :player_grid, :player_attack_grid, :computer_grid, :player_ships, :computer_ships
  
    #Constants
    SHIP_SYMBOL = 'S'
    HIT_SYMBOL = '*'
    MISS_SYMBOL = 'o'
    EMPTY_SYMBOL = '-'

    #Inclusion of Module
    include ShipRandomizer
  
    #Method that is automatically called when a battlefield object is created. 
    def initialize
        #Player's top board
        @player_attack_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Players bottom board
        @player_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Enemy board
        @computer_grid = Array.new(10) { Array.new(10, EMPTY_SYMBOL) }
        #Ships
        @player_ships = getNumShip(1,5, true)
        @computer_ships = getNumShip(1,5, false)
    end
  
    #Method to generate random ships.
    def getNumShip(min,max, playerInput)
        ships = []
        if playerInput
            puts "How many ships do you want?"
            num = gets.chomp.to_i
            until num.between?(min, max)
                puts "Invalid input! Please enter a number between #{min} and #{max}:"
                num = gets.chomp.to_i
                num.to_i
            end
        else 
            num = @player_ships.length
        end
        num.times do
            ship_length = rand(3..5)
            ships << randomize_ship(ship_length)
        end 
        ships  
    end
     
    #Chooses which boards to display.
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

    #Method to display player's ships on board.
    def displayShips(grid, ship)
        grid.each_with_index do |row, i|
            row.each_with_index do |cell, j|
                if ship.any? { |shipper| shipper.include?([i, j]) }
                    print "#{SHIP_SYMBOL} "
                else
                    print "#{cell} "
                end
            end
        puts # newline
        end
    end
  
    #Method to display board
    def display_grid(grid)
        grid.each { |row| puts row.join(' ') }
    end
  
    #Player attack method. 
    def attack(x, y)
        hit = false
        @computer_ships.each do |ship|
            if ship.include?([x, y])
                @computer_grid[x][y] = HIT_SYMBOL
                @player_attack_grid[x][y] = HIT_SYMBOL
                puts "HIT"
                ship.delete([x, y])
                hit = true
                break 
            end
        end
        unless hit
            @computer_grid[x][y] = MISS_SYMBOL
            @player_attack_grid[x][y] = MISS_SYMBOL
            puts "MISS"
        end
        sleep(1)
    end
  
    #Computer Attack Method
    def computer_attack
        x = rand(10)
        y = rand(10)
        hit = false
        @player_ships.each do |ship|
            if ship.include?([x, y])
                @player_grid[x][y] = HIT_SYMBOL
                puts "Computer HIT at #{y + 1},#{x + 1}!"
                ship.delete([x, y]) 
                hit = true
                break 
            end
        end
        unless hit
            @player_grid[x][y] = MISS_SYMBOL
            puts "Computer MISSED at #{y + 1},#{x + 1}!"
        end
        sleep(1)
    end

    #Method that displays introductory text to the game. 
    def getHelp 
        puts "Would you like an intro to battleship?"
        choice = gets.chomp.downcase
        until ["yes", "no"].include?(choice)
            puts "Please enter 'yes' or 'no'."
            choice = gets.chomp.downcase
        end
        if choice == "no"
            return
        else 
            puts
            display_grid(@player_attack_grid)
            puts "You put in coordinates to shoot at a position. Shoot until all the ships are gone."
            puts "The top grid is your attack grid, showing all your shots, while the bottom grid displays " + 
            "your ships' positions and your enemy's shots."
            puts "The grids range from 1 to 10 across and down."
            puts "For example, the top left position is '1, 1'."
            puts "Good luck."
        end
    end
  
    #Game over method
    def game_over?
        @player_ships.flatten.empty? || @computer_ships.flatten.empty?
    end
end
  


  #The gameplay class
class Game
    #Initializes the game
    def initialize
        @battlefield = Battlefield.new
        @battlefield.getHelp
        @show_computer = choose_display
        playGame
    end

    #Choose whether to see computer's board.
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

            @battlefield.attack(y, x)
            break if @battlefield.game_over?
            @battlefield.computer_attack
        end
        puts "Game Over! You #{player_with_remaining_ships? ? 'win' : 'lose'}!"
    end
  
    #Method to see if player has won.
    def player_with_remaining_ships?
        !@battlefield.player_ships.empty?
    end
end

#Game instance
Game.new