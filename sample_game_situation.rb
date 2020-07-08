class Sample_game
  def initialize
    @game = Game.new
    @white_king = King.new("white")
    @white_king.instance_variable_set(:@position, [6,0])
          white_pieces = [Piece.new([4,6], "white", "rook"),
                            Piece.new([3,0], "white", "rook"), 
                            Piece.new([0,2], "white", "bishop"), 
                            Piece.new([3,2], "white", "bishop"),
                            Piece.new([0,3], "white", "queen"), 
                            @white_king,
                            Pawn.new([0,1], "white"),
                            Pawn.new([5,5], "white"),
                            Pawn.new([2,2], "white"),
                            Pawn.new([5,1], "white"),
                            Pawn.new([6,1], "white"),
                            Pawn.new([7,1], "white")]


            red_pieces = [Piece.new([1,7], "red", "rook"), 
                            Piece.new([6,7], "red", "rook"),
                            Piece.new([2,5], "red", "knight"), 
                            Piece.new([1,5], "red", "bishop"), 
                            Piece.new([1,6], "red", "bishop"),
                            Piece.new([5,2], "red", "queen"), 
                            @red_king = King.new("red"),
                            Pawn.new([0,6], "red"),
                            Pawn.new([2,6], "red"),
                            Pawn.new([3,6], "red"),
                            Pawn.new([5,6], "red"),
                            Pawn.new([7,6], "red")]


    Piece.class_variable_set(:@@white_pieces, white_pieces)
    Piece.class_variable_set(:@@red_pieces, red_pieces)
    Piece.class_variable_set(:@@pieces, red_pieces + white_pieces)
  end
end