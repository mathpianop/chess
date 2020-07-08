
#Include castling! En Passant???
#Fill in game_play. 
#Do checkmate/stalemate
#Update pawn allowed move to PREVENT direct attack
# Reconfigure Path clear module to create path arrays for a given move. Then it 
#can be used in the checkmate method
#Comment!!
POS_CONVERSION = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, 
                "e" => 4, "f" => 5, "g" => 6, "h" => 7}
i = 0
while i < 8
POS_CONVERSION["#{i+1}"] = 0
i += 1
end

module Game_play
    def make_a_move(piece, end_pos)
        move = Move.new(piece, end_pos)
        if !move.allowed_for_piece?
            puts "That's not a legal move for a #{piece.rank}. "\
                "Please try again!"
            return "illegal"
        elsif !move.path_clear?
            puts "There are pieces in the way of that move. Please try again!"
            return "illegal"
        elsif move.occupied_by_friend?
            puts "You've already got one of your own pieces there. Please try again!"
            return "illegal"
        elsif move.capture?
            if move.trying_to_capture_king? 
                return "illegal"
            else
                move.capture
            end
        
            move.change_position
            move.pawn_promotion
            update_board()
        end

        if @red_king.check?
            puts "Red King is in check"
        elsif @white_king.check?
            puts "White King is in check"
        end
    end
# Fill this with turn stuff. Include checkmate test here?
end

class Game
    attr_accessor :board
    attr_reader :white_pieces, :red_pieces, :pieces

    def initialize
        @white_pieces = [Piece.new([0,0], "white", "rook"), 
                        Piece.new([7,0], "white", "rook"),
                        Piece.new([1,0], "white", "knight"), 
                        Piece.new([6,0], "white", "knight"),
                        Piece.new([2,0], "white", "bishop"), 
                        Piece.new([5,0], "white", "bishop"),
                        Piece.new([3,0], "white", "queen"), 
                        @white_king = King.new("white")]
    
        @red_pieces = [Piece.new([0,7], "red", "rook"), 
                        Piece.new([7,7], "red", "rook"),
                        Piece.new([1,7], "red", "knight"), 
                        Piece.new([6,7], "red", "knight"),
                        Piece.new([2,7], "red", "bishop"), 
                        Piece.new([5,7], "red", "bishop"),
                        Piece.new([3,7], "red", "queen"), 
                        @red_king = King.new("red")]

        i = 0
        while i < 8 
        @white_pieces.push(Pawn.new([i,1], "white"))
        @red_pieces.push(Pawn.new([i,6], "red"))
        i += 1
        end

    end

    def get_board
        @board = [%w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -),
                %w(- - - - - - - -)]

        Piece.pieces.each do |piece|
            i = 7 - piece.position[1]
            j = piece.position[0]
            @board[i][j] = piece.symbol
        end
    end

    def display_board
        @board.each { |x| puts x.join(" ")}
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
        elsif color == "red"
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
        (start_pos[0] - end_pos[0]).abs == 2 &&
        (start_pos[1] - end_pos[1]).abs == 1 ||
        (start_pos[0] - end_pos[0]).abs == 1 &&
        (start_pos[1] - end_pos[1]).abs == 2
    end

    def move_allowed_for_bishop?(start_pos, end_pos)
        (start_pos[0] - end_pos[0]).abs == (start_pos[1] - end_pos[1]).abs
    end

    def move_allowed_for_queen?(start_pos, end_pos)
        start_pos[0] == end_pos[0] ||
        start_pos[1] == end_pos[1] ||
        (start_pos[0] - end_pos[0]).abs == (start_pos[1] - end_pos[1]).abs
    end

    def move_allowed_for_king?(start_pos, end_pos)
        start_pos[0] == end_pos[0] &&
        (start_pos[1] - end_pos[1]).abs == 1 ||
        start_pos[1] == end_pos[1] &&
        (start_pos[0] - end_pos[0]).abs == 1 ||
        (start_pos[0] - end_pos[0]).abs == (start_pos[1] - end_pos[1]).abs &&
        (start_pos[0] - end_pos[0]).abs == 1
    end
end

module Path_clear
    def path_clear_for_pawn?(start_pos, end_pos)
        # Case 1: not-first-move
        if (start_pos[1] - end_pos[1]).abs == 1
            return true
        # Case 2: first-move-red
        elsif start_pos[1] > end_pos[1]
            Piece.pieces.none? do |piece| 
                piece.position[0] == start_pos[0] &&
                (piece.position[1] == (start_pos[1] - 1))
            end
        # Case 3: first-move-white
        elsif end_pos[1] > start_pos[1]
            Piece.pieces.none? do |piece| 
                piece.position[0] == start_pos[0] &&
                (piece.position[1] == (start_pos[1] + 1))
            end
        end
    end

    def path_clear_for_rook?(start_pos, end_pos)
        if start_pos[0] == end_pos[0]
            # Case 1: vertical move down
            if start_pos[1] > end_pos[1]
                Piece.pieces.none? do |piece| 
                    piece.position[0] == start_pos[0] &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] - 1)
                end
            # Case 2: vertical move up
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.none? do |piece| 
                    piece.position[0] == start_pos[0] &&
                    piece.position[1].between?(start_pos[1] + 1, end_pos[1] - 1)
                end
            end
        elsif start_pos[1] == end_pos[1]
            # Case 3: horizontal move left
            if start_pos[0] > end_pos[0]
                Piece.pieces.none? do |piece| 
                    piece.position[1] == start_pos[1] &&
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] - 1)
                end
            # Case 4: horizontal move right
            elsif start_pos[0] < end_pos[0]
                Piece.pieces.none? do |piece| 
                    piece.position[1] == start_pos[1] &&
                    piece.position[0].between?(start_pos[0] + 1, end_pos[0] - 1)
                end
            end
        end
    end

    def path_clear_for_bishop?(start_pos, end_pos)
        # Case 1: Left-Down
        if start_pos[0] > end_pos[0] && start_pos[1] > end_pos[1]
                Piece.pieces.none? do |piece|
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
                end
        # Case 2: Right-Down
        elsif start_pos[0] < end_pos[0] && start_pos[1] > end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
            end
        # Case 3: Left-Up
        elsif start_pos[0] > end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        # Case 4: Right-Up
        elsif start_pos[0] < end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        end      
    end

    def path_clear_for_queen?(start_pos, end_pos)
        if start_pos[0] == end_pos[0]
            # Case 1: vertical move down
            if start_pos[1] > end_pos[1]
                Piece.pieces.none? do |piece| 
                    piece.position[0] == start_pos[0] &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] - 1)
                end
            # Case 2: vertical move up
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.none? do |piece| 
                    piece.position[0] == start_pos[0] &&
                    piece.position[1].between?(start_pos[1] + 1, end_pos[1] - 1)
                end
            end
        elsif start_pos[1] == end_pos[1]
            # Case 3: horizontal move left
            if start_pos[0] > end_pos[0]
                Piece.pieces.none? do |piece| 
                    piece.position[1] == start_pos[0] &&
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1)
                end
            # Case 4: horizontal move right
            elsif start_pos[1] < end_pos[1]
                Piece.pieces.none? do |piece| 
                    piece.position[1] == start_pos[0] &&
                    piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1)
                end
            end
            # Case 5: Left-Down
        elsif start_pos[0] > end_pos[0] && start_pos[1] > end_pos[1]
                Piece.pieces.none? do |piece|
                    piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                    piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
                end
            # Case 6: Right-Down
        elsif start_pos[0] < end_pos[0] && start_pos[1] > end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(end_pos[1] + 1, start_pos[1] -1)
            end
            # Case 7: Left-Up
        elsif start_pos[0] > end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(end_pos[0] + 1, start_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
            # Case 8: Right-Up
        elsif start_pos[0] < end_pos[0] && start_pos[1] < end_pos[1]
            Piece.pieces.none? do |piece|
                piece.position[0].between?(start_pos[0] + 1, end_pos[0] -1) &&
                piece.position[1].between?(start_pos[1] + 1, end_pos[1] -1)
            end
        end  
    end
end

module Attack

    def checkmate?
        #Fill this. We assume that there is already check.
    end

    def stalemate?
        #Fill This
    end


    def trying_to_capture_king?
        if @piece.color = "white"
            Piece.red_pieces.each do |piece|
                if piece.position == @end_pos && piece.rank == "king"
                    puts "You cannot capture a king!"
                    return true
                end
            end
        end

        if @piece.color = "red"
            Piece.white_pieces.each do |piece|
                if piece.position == @end_pos && piece.rank == "king"
                    puts "You cannot capture a king!"
                    return true
                end
            end
        end
    end

    def capture?
        capture = false
        if @piece.color = "white"
            Piece.red_pieces.each do |piece|
                if @piece.position == @end_pos
                    capture = true
                end
            end
        end

        if @piece.color = "red"
            Piece.white_pieces.each do |piece|
                if piece.position == @end_pos
                    capture = true
                end
            end
        end
        return capture
    end

    def capture
        captured_piece = Piece.pieces.select {|piece| piece.position == @end_pos}
        puts "Captures #{captured_piece.COLOR} #{captured_piece.rank}."
        captured_piece.surrender
    end
end

class Move
    include Attack
    include Rank_movements_allowed
    include Path_clear

    def initialize(piece, end_pos)
        @piece = piece
        @end_pos = end_pos
        @start_pos = piece.position
    end

    def allowed_for_piece?
        if @piece.rank == "pawn"
            move_allowed_for_pawn?(@start_pos, @end_pos, @color)
        elsif @piece.rank == "rook"
            move_allowed_for_rook?(@start_pos, @end_pos)
        elsif @piece.rank == "knight"
            move_allowed_for_knight?(@start_pos, @end_pos)
        elsif @piece.rank == "bishop"
            move_allowed_for_bishop?(@start_pos, @end_pos)
        elsif @piece.rank == "queen"
            move_allowed_for_queen?(@start_pos, @end_pos)
        elsif @piece.rank == "king"
            move_allowed_for_king?(@start_pos, @end_pos)
        end
    end

    def pawn_promotion
        if @piece.rank == "pawn" || @piece.COLOR = "white"
            if @end_pos[1] == 8
                @piece.promote_pawn
            end
        elsif @piece.rank == "pawn" || @piece.COLOR = "red"
            if @end_pos[1] == 0
                @piece.promote_pawn
            end
        end
    end


    def path_clear?
        if @piece.rank == "pawn"
            path_clear_for_pawn?(@start_pos, @end_pos)
        elsif @piece.rank == "rook"
            path_clear_for_rook?(@start_pos, @end_pos)
        elsif @piece.rank == "bishop"
            path_clear_for_bishop?(@start_pos, @end_pos)
        elsif @piece.rank == "queen" 
            path_clear_for_queen?(@start_pos, @end_pos)
        end 
    end

    def occupied_by_friend?
        if @piece.COLOR == "white"
            Piece.white_pieces.any? { |piece| piece.position == @end_pos}
        elsif piece.COLOR == "red"
            Piece.red_pieces.any? { |piece| piece.position == @end_pos}
        end
    end

    def change_position
       @piece.change_position(@end_pos)
    end    
end


class Piece
    attr_reader :position, :rank, :COLOR, :pieces, :white_pieces, :red_pieces, :symbol

    @@pieces = []
    @@white_pieces = []
    @@red_pieces = []
    @@white_pieces_captured = []
    @@red_pieces_captured = []

    def initialize(initial_position, color, rank)
        @position = initial_position
        @rank = rank
        @COLOR = color
        @symbol = assign_symbol(color, rank)

        @@pieces.push(self)
        if @COLOR == "white"
            @@white_pieces.push(self)
        elsif
            @COLOR == "red"
            @@red_pieces.push(self)
        end
    end

    def assign_symbol(color, rank)
        if rank == "rook"
            color == "white" ? "♖" : "♜"
        elsif rank == "knight"
            color == "white" ? "♘" : "♞"
        elsif rank == "bishop"
            color == "white" ? "♗" : "♝"
        elsif rank == "queen"
            color == "white" ? "♕" : "♛"
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
            @@white_pieces_captured.push(self)
            @@white_pieces.delete(self)
        elsif @COLOR == "red"
            @@red_pieces_captured.push(self)
        end
        @@pieces.delete(self)
    end
end

class Pawn < Piece
    def initialize(initial_position, color)
        @position = initial_position
        @rank = "pawn"
        @COLOR = color
        color == "white" ? @symbol = "♙" : @symbol = "♟"
        @first_move = true
        @@pieces.push(self)
    end

    def promote_pawn
        @rank = "queen"
        color == "white" ? @symbol = "♕" : @symbol = "♛"
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
        color == "white" ? @position = [4,0] : @position = [4,7]
        @rank = "king"
        @COLOR = color
        color == "white" ? @symbol = "♔" : @symbol = "♚"
        @checking_pieces = []
        @checking_moves = []
        @@pieces.push(self)
    end

    def change_position
        super
    end

    def check?
        if @COLOR == "white"
            Pieces.red_pieces.each do |piece|
                move = Move.new(piece, @position)
                if move.allowed_for_piece? && move.path_clear? && move.capture?
                    self.checking_pieces.push(move)
                    self.checking_moves.push(move)
                    return true
                end
            end
        elsif @COLOR == "red"
            Pieces.white_pieces.each do |piece|
                move = Move.new(piece, @position)
                if move.allowed_for_piece? && move.path_clear? && move.capture?
                    self.checking_pieces.push(piece)
                    self.checking_moves.push(move)
                    return true
                end
            end
        else 
            return false
        end
    end

    #We assume that piece is in check
    def checkmate?
        if @COLOR == "white"
            if @checking_piece.length == 1
                #Here we check IF it's possible to capture the checking piece
                Pieces.white_pieces.each do |piece|
                    move = Move.new(piece, @checking_piece[0].position)
                    if move.allowed_for_piece? && move.path_clear?
                        # Finish this. Figure out reverse move thingy
                    end
                end
                #Here we check IF it's possible to block the checking pieces
                Pieces.white_pieces.each do |piece|
                    @checking_moves[0].path.each do |position_along_path|
                        blocking_move = Move.new(piece, position_along_path)
                        if blocking_move.allowed_for_piece? &&
                            blocking_move.path_clear?
                            # Finish this. Figure out reverse move thingy
                        end
                    end
                end
            else
                #Here we check IF King can move out of danger.
                

            end          
        elsif @COLOR == "red"
            #copy stuff from above

        end
        return true
    end
end







