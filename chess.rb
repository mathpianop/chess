
#Include castling! En Passant???
POS_CONVERSION = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, 
                "e" => 4, "f" => 5, "g" => 6, "h" => 7}
i = 0
while i < 8 do
POS_CONVERSION["#{i+1}"] = 0
i += 1
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

        @white_pieces = [Pawn.new([0,1], "white"), Pawn.new([1,1], "white",
                        #ETC
                            ]
        
        @red_pieces = [Pawn.new([0,6], "red"), Pawn.new([1,6], "red",
                    #ETC
                         ]

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
    #Fill this, I assume
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
        #These next three are unneccesary?
        @start_pos = piece.position
        @rank = piece.rank
        @color = piece.COLOR
    end

    def allowed_for_piece?
        if @rank == "pawn"
            move_allowed_for_pawn?(@start_pos, @end_pos, @color)
        elsif @rank == "rook"
            move_allowed_for_rook?(@start_pos, @end_pos)
        elsif @rank == "knight"
            move_allowed_for_knight?(@start_pos, @end_pos)
        elsif @rank == "bishop"
            move_allowed_for_bishop?(@start_pos, @end_pos)
        elsif @rank == "queen"
            move_allowed_for_queen?(@start_pos, @end_pos)
        elsif @rank == "king"
            move_allowed_for_king?(@start_pos, @end_pos)
        end
    end

    def promotion?
        #Fill this
    end

    def path_clear?
        #Fill this. Include occupied with friend option here
    end

    def change_position
        #Fill this
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
    def initialize(initial_position, color, rank)
        @position = initial_position
        @rank = rank
        @COLOR = color
        @symbol = color[1] + rank[1].upcase
        @first_move = true

        @@pieces.push(self)
    end
end


class King < Piece
   
end

class Game
    attr_reader :variable

    def initialize
        @variable = "snoot"
    end

    def play
        move = Move.new
        move.make_move
    end
end

class Move
    def initialize
    end

    def make_move
        puts Game.variable
    end
end

game = Game.new
game.play


