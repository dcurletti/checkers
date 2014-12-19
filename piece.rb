class InvalidMoveError < ArgumentError
end


class Piece
	attr_accessor :board, :color, :pos, :king

	def initialize(board, color)
		@color = color
		@board = board
		@king = false
	end

	def to_s
		if king?
			color == :black ? "\u265A" : "\u2654"
		else
			color == :black ? "\u265F" : "\u2659"
		end
	end

	def inspect
		"(#{self.color} at #{self.pos})"
	end

	def king?
		@king
	end

	def pos_finder(arr1, arr2)
		arr1.zip(arr2).map { |pair| pair.reduce(:+) }
	end

	def find_delta(arr1, arr2)
		arr1.zip(arr2).map { |pair| pair.reduce(:-) }
	end

	DIRS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

	def move_diffs
		if self.king?
			dir = DIRS.take(4)
		elsif	self.color == :white
			dir = DIRS.take(2)
		else
			dir = DIRS.drop(2)
		end
		valid_moves = []

		dir.each do |move_dir|
			move_coor = pos_finder(self.pos, move_dir)
			space = @board[*move_coor]
			# p "These are the move_coor: #{move_coor}"
			next if move_coor.any? {|pos| !pos.between?(0,7)}
			if space.nil?
				valid_moves << move_dir 
			else
				next if space.color == self.color
				valid_moves << pos_finder(move_dir, move_dir)
			end
		end

		valid_moves
	end	

	def perform_slide(to)
		valid_slide = move_diffs.select do |move|
			move.all? { |e| e.between?(-1,1) }
		end
		puts "THIS IS MY POS: #{self.pos}"
		delta = find_delta(to, self.pos)
		if valid_slide.include?(delta)
			puts "THIS IS SELF: #{self}"
			old_pos = self.pos
			self.board[*to] = self
			self.board[*old_pos] = nil
			return true
		end

		false
		
	end

	def perform_jump(to)
		valid_slide = move_diffs.select do |move|
			move.all? { |e| e == 2 || e == -2 }
		end
		delta = find_delta(to, self.pos)
		# puts "This is the delta: #{delta}"
		if valid_slide.include?(delta)
			old_pos = self.pos
			self.board[*to] = self
			self.board[*old_pos] = nil
			ate_piece_delta = delta.map { |e| e / 2 }
			# puts "halway delta: #{ate_piece_delta}"
			# puts "halfway coord: #{pos_finder(self.pos, ate_piece_delta)}"
			self.board[*pos_finder(old_pos, ate_piece_delta)] = nil
			return true
		end

		false
	end

	def perform_moves!(move_sequence)
		if perform_slide(move_sequence.first)
			return true
		end
		move_sequence.each do |move|
			unless perform_jump(to)
				raise InvalidMoveError.new("Can't jump to that position")
			end
		end
	end

	def valid_move_seq?(move_sequence)
		begin
			dup_board = self.board.dup
			piece = dup_board[self.pos]
			piece.perform_moves!(move_sequence)
		rescue InvalidMoveError
			return false
		end

		true
	end

	def perform_moves(move_sequence)
		if valid_move_seq?(move_sequence)
			perform_moves!(move_sequence)
		else
			raise InvalidMoveError
		end
	end




	def maybe_promote
		if self.color == :white && self.pos.first == 0
			self.king = true
		elsif self.color == :black && self.pos.first == 7
			self.king = true
		end
	end

end
