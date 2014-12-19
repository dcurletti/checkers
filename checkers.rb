require 'colorize'
require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'player.rb'
require 'JSON'

class Game

	attr_accessor :board, :players
	
	def initialize()
		@board = Board.new
		@players = []
	end

	def play
		loop do 
			print board.render
			all_moves = []

			puts "From where?"

			from = gets.chomp.scan(/[0-7]/).map(&:to_i)

			puts "To what positions? (List all)"

			to = gets.chomp

			to = JSON.parse(to)

			begin 
				board[*from].perform_moves(to)
			rescue InvalidMoveError => e
				puts e.message
				next
			end

			# if board[*from].perform_slide([*to]) 
			# 	next
			# else
			# 	board[*from].perform_jump([*to])
			# end


		end
	end


end

# board = Board.new
game = Game.new
game.play
# game.board[3,0] = game.board[2,1]
# game.board[2,1] = nil


# print game.board.render
# dup_board = game.board.dup.perform_moves!()


# print board.render
# piece3.perform_slide([1, 2], [0, 1])
# print board.render
# # # p piece.move_diffs
# # # p piece.perform_jump([6,1], [4,3])
# # # print board.render
# # # board[5,0].perform_slide([5,0], [4,1])
# # p board[2,1].move_diffs
# p board[2,1].perform_slide([3,0])
# # # board[2,1].perform_slide([3,2])
# # # board[5,4].perform_slide([4,3])
# # # p "Possible moves: #{board[4,3].move_diffs}"
# # # board[4,3].perform_jump([4,3], [2,1])
# print board.render
# p board[3,0]
# p board[2,1]
# game = Game.new

# game.play

# print board.dup.render

# p piece.perform_jump([6,1], [5,2])

