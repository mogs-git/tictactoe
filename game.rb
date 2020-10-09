require_relative "messages.rb"

class Game
	include Message
	attr_accessor :players, :symbols, :current_player, :n_players, :board
	
	def initialize
		puts welcome_message
		@players = create_players
		@board = Board.new
		@current_player = 0
		@n_players = 2
		game_loop
	end

	def create_players
		player_1 = Player.new("Player 1")
		player_2 = Player.new("Player 2")
		[player_1, player_2]
	end

	def play_turn
		puts play_piece_message(board.free_positions)
		player = self.players[self.current_player]
		choice = gets.chomp
		while !board.free_positions.include?(choice)
			puts play_piece_message(board.free_positions)
			choice = gets.chomp
		end
		x = self.board.coordinates[choice]["x"]
		y = self.board.coordinates[choice]["y"]
		board.positions[x][y] = player.symbol
	end

	def next_turn
		self.current_player == self.n_players-1 ? self.current_player = 0 : self.current_player += 1
	end

	def game_over
		winning_combinations = [
			[1,2,3], [4,5,6], [7,8,9], # rows
			[1,4,7], [2,5,8], [3,6,9], # columns
			[1,5,9], [3,5,7] # diagonals
		]
		winning_combinations.map! { |combination| combination.map! { |value| value.to_s } }
		winning_combinations.each do |combination|
			the_three_pieces = []
			combination.each do |place|
				piece = self.board.positions[self.board.coordinates[place]["x"]][self.board.coordinates[place]["y"]]
				the_three_pieces.push(piece)
			end
			return true if the_three_pieces.uniq.length == 1 
		end
		false
	end

	def game_loop
		while !game_over
			play_turn
			self.board.draw_board
			next_turn if !game_over
		end
		p game_winner_message(players[current_player].name)
	end
end

class Player
	@@symbols = ["X", "O"]
	include Message
	attr_accessor :name, :symbol

	def initialize(name)
		@name = name
		@symbol = pick_symbol(self.name)
	end

	def self.symbols
	    @@symbols
	end

	def pick_symbol(name)
		puts pick_symbol_message(self.name, Player.symbols)
		symbol = gets.chomp
		while !Player.symbols.include? symbol
			puts pick_symbol_message(self.name, Player.symbols)
			symbol = gets.chomp
		end
		Player.symbols.delete(symbol)
		symbol
	end
end

class Board
	attr_accessor :positions, :coordinates
	SIDE_LENGTH = 3

	def initialize
		@positions = create_board
		@coordinates = map_coordinates
		draw_board
	end

	def create_board
		grid = Array.new
		SIDE_LENGTH.times do |x|
			row = Array.new
			SIDE_LENGTH.times do |y|
				position = (SIDE_LENGTH*x) + y + 1
				row.push(position.to_s)
			end
			p row
			grid.push(row)
		end
		grid
	end

	def map_coordinates
		coordinates = {}
		SIDE_LENGTH.times do |x|
			SIDE_LENGTH.times do |y|
				position = (SIDE_LENGTH*x) + y + 1
				coordinates[position.to_s] = {"x" => x, "y" => y}
			end
		end
		coordinates
	end

	def free_positions
		self.positions.flatten.reject {|val| val == "X" || val == "O"}
	end

	def draw_board
		puts
		puts "-------------"
		SIDE_LENGTH.times do |x|
			print "| "
			SIDE_LENGTH.times do |y|
				print "#{positions[x][y]} | "
			end
			puts
			puts "-------------"
		end
		puts
	end
end

Game.new
