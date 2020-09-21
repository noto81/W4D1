require_relative 'tic_tac_toe'
require "byebug"

    #current game state(node)
    #next_mover_mark = :X
    #prev_move_pos = array with two indicies x and y

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos 
  end

    
  def losing_node?(evaluator)
    return false if self.board.over? && (self.board.winner == evaluator || self.board.tied?)
    return true if self.board.over? && self.board.winner != evaluator # ?
    # return false if self.board.over? && (self.board.winner == evaluator || self.board.tied?)
     
      #player's turn
    if self.next_mover_mark == evaluator
      self.children.all? do |child| 
        return child.losing_node?(evaluator) 
      end
    else #opponent's turn
        self.children.any? do |child|
          return child.losing_node?(evaluator) 
        end
    end
    
  end

  #logic that asks if evaluator is the current turn 
  def winning_node?(evaluator)
    return true if self.board.over? && self.board.winner == evaluator  
    return false if self.board.over? && self.board.winner != evaluator 
   
    if self.next_mover_mark == evaluator
      return self.children.any? { |child| child.winning_node?(evaluator) }
    else #opponent's turn
       return self.children.all? { |child| child.winning_node?(evaluator) }
    end
    
  end

  # This method generates an array of all moves that can be made after
  # the current move.


  def children
    children = []

    (0..2).each do |x|
      (0..2).each do |y|
        if @board.empty?([x, y])
          new_board = @board.dup
          new_board[[x, y]] = @next_mover_mark
          child_mark = @next_move_marker
          if @next_move_marker == :o
            child_mark = :x
          else
            child_mark = :o
          end
          child_node = TicTacToeNode.new(new_board, child_mark, [x, y])
          children << child_node
        end
      end
    end

    return children
  end
end
