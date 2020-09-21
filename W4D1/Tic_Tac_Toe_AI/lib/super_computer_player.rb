require_relative 'tic_tac_toe_node'
require "byebug"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    @board = game.board
    node = TicTacToeNode.new(@board, mark)
    #check if children are winning nodes
    
    node.children.each do |child|
      # s
      if child.winning_node?(mark) 
        return child.prev_move_pos
      end
    end

  # else pick node that isnt a loser
    node.children.each do |child|
      if !child.losing_node?(mark)
        return child.prev_move_pos
      end
    end
     raise "invalid game" if node.children.all? { |child| child.losing_node?(mark) == true}
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
