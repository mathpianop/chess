require './chess'

game = Game.new
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


describe Path_clear do
  describe "path_clear?" do
    it "returns true for pawn-first-move if next space is open" do
      piece = Piece.pieces.select { |piece| piece.position == [7,1]}[0]
      move1 = Move.new(piece,[7,3])
      expect(move1.path_clear?).to eql(true)
    end

    it "returns false for pawn-first-move if middle space is blocked" do
      piece = Piece.pieces.select { |piece| piece.position == [5,1]}[0]
      move2 = Move.new(piece,[5,3])
      expect(move2.path_clear?).to eql(false)
    end
  end
end