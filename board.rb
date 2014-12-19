
class Board

	attr_accessor :grid

	def initialize(options = {})
		self.grid = Array.new(8) { Array.new(8) {nil} }
		# self.grid[6, 0] = Piece.new(self, :white)
		default_opt = {empty: false}
		options = default_opt.merge(options)
		return if options[:empty]

		6.times do |i|
			i += i > 2 ? 2 : 0
			[0, 2, 4, 6].each do |j|
				j += i.odd? ? 0 : 1
				color = i < 3 ? :black : :white
				self[i, j] = Piece.new(self, color)
			end
		end
	end

	def [] (r, c)
		self.grid[r][c]
	end

	def []=(r, c, piece)
		self.grid[r][c] = piece
		piece.pos = [r ,c] if !piece.nil?
	end

	def render
		result = []
		print "\e[H\e[2J   0   1   2   3   4   5   6   7\n"
		self.grid.each_with_index do |row, r|
			print r.to_s + " "
			row.each_with_index do |piece, c|
				str = piece.nil? ? " . " : (" " + piece.to_s + " ")
				# .colorize(color: piece.color)
				print str + " "
			end

			result << "\n"
			print "\n"
			print "\n"
		end

		nil
	end

	def dup
		dup_board = Board.new(empty: true)
		self.grid.each do |row|
			row.each do |el|
				unless el.nil? 
					dup_board[*el.pos] = Piece.new(dup_board, el.color)
				end
			end
		end
		puts "THIS IS A DUP BOARD"
		dup_board
	end

end
