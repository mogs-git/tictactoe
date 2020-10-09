module Message
	def welcome_message
		"Welcome to the game!"
	end
	def pick_symbol_message (name, symbols)
		"#{name}, please pick a symbol from these symbols: #{symbols}"
	end
	def play_piece_message (positions)
		"Please choose a position to place your piece: #{positions}"
	end
	def game_winner_message(player)
		"Well done #{player}, you have won!"
	end
end