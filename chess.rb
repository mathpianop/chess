
#Include castling! En Passant???
POS_CONVERSION = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, 
                "e" => 4, "f" => 5, "g" => 6, "h" => 7}
i = 0
while i < 8 do
POS_CONVERSION["#{i+1}"] = 0
i += 1
end

module Game_play
    #Fill This
end

class Game
    attr_accessor :board
    attr_reader :white_pieces, :red_pieces, :pieces

    def initialize
        @board = [%w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -),
                  %w(- - - - - - - -)]

        @white_pieces = [Piece.new([0,0], "white", "rook"), 
                        Piece.new([7,0], "white", "rook"),
                        Piece.new([1,0], "white", "knight"), 
                        Piece.new([6,0], "white", "knight"),
                        Piece.new([2,0], "white", "bishop"), 
                        Piece.new([5,0], "white", "bishop"),
                        Piece.new([3,0], "white", "queen"), 
                        King.new("white")]
    
        @red_pieces = [Piece.new([0,7], "red", "rook"), 
                        Piece.new([7,7], "red", "rook"),
                        Piece.new([1,7], "red", "knight"), 
                        Piece.new([6,7], "red", "knight"),
                        Piece.new([2,7], "red", "bishop"), 
                        Piece.new([5,7], "red", "bishop"),
                        Piece.new([3,7], "red", "queen"), 
                        King.new("red")]

        i = 0
        while i < 8 do
        @white_pieces.push(Pawn.new([i,1], "white"))
        @red_pieces.push(Pawn.new([i,6], "red"))
        i += 1
        end

        @pieces = @white_pieces + @red_pieces

    
        
        #Fill in the rest of the pieces once 
        #sure of how we're setting this up

    end

    def update_board
        Piece.pieces.each do |piece|
            i = 7 - piece.position[0]
            j = piece.position[1]
            @board[i][j] = piece.symbol
        end
        return @board
    end

    def play_game
        #Fill this
    end
end


module Rank_movements_allowed
    def move_allowed_for_pawn?(start_pos, end_pos, color)
        if color == "white"
            if self.capture?
                end_pos[1] - start_pos[1] == 1 &&
                abs(end_pos[0] - start_pos[0]) == 1
            elsif piece.first_move == true
                end_pos[1] - start_pos[1] == 2 ||
                end_pos[1] - start_pos[1] == 1
            else
                end_pos[1] - start_pos[1] == 1
            end
        if color == "red"
            if self.capture?
                end_pos[1] - start_pos[1] == -1 &&
                abs(end_pos[0] - start_pos[0]) == 1
            elsif piece.first_move == true
                end_pos[1] - start_pos[1] == -2 ||
                end_pos[1] - start_pos[1] == -1
            else
                end_pos[1] - start_pos[1] == 1
            end
        end
    end

    def move_allowed_for_rook?(start_pos, end_pos)
        start_pos[0] == end_pos[0] ||
        start_pos[1] == end_pos[1]
    end

    def move_allowed_for_knight?(start_pos, end_pos)
        abs(start_pos[0] - end_pos[0]) == 2 &&
        abs(start_pos[1] - end_pos[1]) == 1 ||
        abs(start_pos[0] - end_pos[0]) == 1 &&
        abs(start_pos[1] - end_pos[1]) == 2
    end

    def move_allowed_for_bishop?(start_pos, end_pos)
        abs(start_pos[0] - end_pos[0]) == abs(start_pos[1] - end_pos[1])
    end

    def move_allowed_for_queen?(start_pos, end_pos)
        start_pos[0] == end_pos[0] ||
        start_pos[1] == end_pos[1] ||
        abs(start_pos[0] - end_pos[0]) == abs(start_pos[1] - end_pos[1])
    end

    def move_allowed_for_king?(start_pos, end_pos)
        start_pos[0] == end_pos[0] &&
        abs(start_pos[0] - end_pos[0]) == 1 ||
        start_pos[1] == end_pos[1] &&
        abs(start_pos[1] - end_pos[1]) == 1 ||
        abs(start_pos[0] - end_pos[0]) == abs(start_pos[1] - end_pos[1]) &&
        abs(start_pos[0] - end_pos[0]) == 1
    end

end

module Path_clear
    def path_clear_for_pawn?(start_pos, end_pos)
        if abs(start_pos[1] - end_pos[1] == 1)
            return true
        elsif start_pos[1] > end_pos[1]
            Piece.pieces.any? do |piece| 
                piece.position[1] == start_pos[1] &&
                (piece.position[0] == start_pos[0] - 1)
            end
        elsif end_pos[1] > start_pos[1]
            Piece.pieces.any? do |piece| 
                piece.position[1] == start_pos[1] &&
                (piece.position[0] == start_pos[0] + 1)
            end
        end
    end

    def path_clear_for_rook?(start_pos, end_pos)
        if start_pos[0] == end_pos[0]
            if start_pos[1] > end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[0] == start_pos &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] - 1)
                end
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[0] == start_pos &&
                    piece.position[1].between?(start_pos[1] + 1, end_pos[1] - 1)
                end
            end
        elsif start_pos[1] == end_pos[1]
            if start_pos[0] > end_pos[0]
                Piece.pieces.any? do |piece| 
                    piece.position[1] == start_pos &&
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] - 1)
                end
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[1] == start_pos &&
                    piece.position[0].between?(start_pos[0] + 1, end_pos[0] - 1)
                end
            end
        end
    end

    def path_clear_for_bishop?(start_pos, end_pos)
        if start_pos[0] > end_pos[0] && start_pos[1] > end_pos[1]
                Piece.pieces.any? do |piece|
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
                end
        elsif start_pos[0] < end_pos[0] && start_pos[1] > end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
            end
        elsif start_pos[0] > end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        elsif start_pos[0] < end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        end      
    end

    def path_clear_for_queen?(start_pos, end_pos)
        if start_pos[0] == end_pos[0]
            if start_pos[1] > end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[0] == start_pos &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] - 1)
                end
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[0] == start_pos &&
                    piece.position[1].between?(start_pos[1] + 1, end_pos[1] - 1)
                end
            end
        elsif start_pos[1] == end_pos[1]
            if start_pos[0] > end_pos[0]
                Piece.pieces.any? do |piece| 
                    piece.position[1] == start_pos &&
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1)
                end
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.any? do |piece| 
                    piece.position[1] == start_pos &&
                    piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1)
                end
            end
        elsif start_pos[0] > end_pos[0] && start_pos[1] > end_pos[1]
                Piece.pieces.any? do |piece|
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
                end
        elsif start_pos[0] < end_pos[0] && start_pos[1] > end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
            end
        elsif start_pos[0] > end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        elsif start_pos[0] < end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.any? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        end  
    end
end

module Attack

    def check?
        #Fill this
    end 

    def checkmate?
        #Fill this
    end

    def trying_to_capture_king?
        if color = "white"
            Piece.red_pieces.each do |piece|
                if piece.position == end_pos && piece.rank == "king"
                    puts "You cannot capture a king!"
                    return true
                end
            end
        end

        if color = "red"
            Piece.white_pieces.each do |piece|
                if piece.position == end_pos && piece.rank == "king"
                    puts "You cannot capture a king!"
                    return true
                end
            end
        end
    end

    def capture?(end_pos, color)
        capture = false
        if color = "white"
            Piece.red_pieces.each do |piece|
                if piece.position == end_pos
                    capture = true
                end
            end
        end

        if color = "red"
            Piece.white_pieces.each do |piece|
                if piece.position == end_pos
                    capture = true
                end
            end
        end
        return capture
    end

    def capture(piece, end_pos)
        captured_piece = Piece.pieces.select {|piece| piece.position == end_pos}
        puts "Captures #{captured_piece.COLOR} #{captured_piece.rank}."
        captured_piece.surrender
    end
end

class Move
    include Attack
    include Rank_movements_allowed

    def initialize(piece, end_pos)
        @piece = piece
        @end_pos = end_pos
        @start_pos = piece.position
    end

    def allowed_for_piece?
        if piece.rank == "pawn"
            move_allowed_for_pawn?(@start_pos, @end_pos, @color)
        elsif piece.rank == "rook"
            move_allowed_for_rook?(@start_pos, @end_pos)
        elsif piece.rank == "knight"
            move_allowed_for_knight?(@start_pos, @end_pos)
        elsif piece.rank == "bishop"
            move_allowed_for_bishop?(@start_pos, @end_pos)
        elsif piece.rank == "queen"
            move_allowed_for_queen?(@start_pos, @end_pos)
        elsif piece.rank == "king"
            move_allowed_for_king?(@start_pos, @end_pos)
        end
    end

    def pawn_promotion
        if piece.rank == "pawn" || piece.COLOR = "white"
            if end_pos[1] == 8
                piece.promote_pawn
        elsif piece.rank == "pawn" || piece.COLOR = "red"
            if end_pos[1] == 0
                piece.promote_pawn
            end
        end
    end


    def path_clear?
        if piece.rank == "pawn"
            path_clear_for_pawn?(start_pos, end_pos)
        elsif piece.rank == "rook"
            path_clear_for_rook?(start_pos, end_pos)
        elsif piece.rank == "bishop"
            path_clear_for_bishop?(start_pos, end_pos)
        elsif piece.rank == "queen" 
            path_clear_for_queen?(start_pos, end_pos)
        end 
    end

    def occupied_by_friend?
        if piece.COLOR == "white"
            Piece.white_pieces.any? { |piece| piece.position == end_pos}
        elsif piece.COLOR == "red"
            Piece.red_pieces.any? { |piece| piece.position == end_pos}
        end
    end

    def change_position
        piece.change_position(end_pos)
    end

    
end


class Piece
    attr_reader :position, :rank, :COLOR, :pieces, :white_pieces, :red_pieces

    @@pieces = []
    @@white_pieces = []
    @@red_pieces = []
    @@white_pieces_captured = []
    @@red_pieces_captured = []

    def initialize(initial_position, color, rank)
        @position = initial_position
        @rank = rank
        @COLOR = color
        @symbol = color[1] + rank[1].upcase

        @@pieces.push(self)
        if @COLOR == "white"
            @@white_pieces.push(self)
        elsif
            @COLOR == "red"
            @@red_pieces.push(self)
        end
    end

    def self.pieces
        @@pieces
    end

    def self.white_pieces
        @@white_pieces
    end

    def self.red_pieces
        @@red_pieces
    end

    def change_position(end_pos)
        @position = end_pos
    end

    def surrender
        @position = nil
        if @COLOR == "white"
            white_pieces_captured.push(self)
        elsif @COLOR == "red"
            red_pieces_captured.push(self)
        end
    end
end

class Pawn < Piece
    def initialize(initial_position, color)
        @position = initial_position
        @rank = "pawn"
        @COLOR = color
        @symbol = color[1] + "P"
        @first_move = true

        @@pieces.push(self)
    end

    def promote_pawn
        @rank = "queen"
        @symbol = color[1] + "Q"
    end

    def change_position
        super
    end

    def surrender
        super
    end
end


class King < Piece
    def initialize(color)
        if color == "white"
            @position = [4,0]
        elsif color == "red"
            @position = [4,7]
        end
        @rank = "king"
        @COLOR = color
        @symbol = color[1] + "K"
    end

    def change_position
        super
    end
end

