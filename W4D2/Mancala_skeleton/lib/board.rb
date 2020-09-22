class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) { Array.new }
    place_stones 
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, idx|
      if !(idx == 6 || idx == 13)
        4.times do
          cup << :stone
        end
      end
    end
 end

  def valid_move?(start_pos)
    raise 'Invalid starting cup' if start_pos < 0 || start_pos > 12
    raise 'Starting cup is empty' if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos] 
    @cups[start_pos] = []  # empty the cup taking all stones 

    cup_pos = start_pos
    until stones.empty?
      cup_pos += 1 # move to the next cup
      cup_pos = 0 if cup_pos > 13 # when cup is greater then 12 it means we have to start from 0 position
      if cup_pos == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif cup_pos == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[cup_pos] << stones.pop
      end
    end
    render
    next_turn(cup_pos)
  end
  # player 2:                12  11  10  9  8  7
  #            [store2]  [13]                   [6] [store1]
  # player 1:                 0   1   2  3  4  5  

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
      
      if ending_cup_idx == 6 || ending_cup_idx == 13
         # when the turn ended on the current player's points cup
        :prompt
      elsif @cups[ending_cup_idx].count == 1
        # when the turn ended on an empty cup --> switches players' turns
        :switch
      else
        # when the turn ended on a cup with stones already in it --> returns the cup's array index and start here
        ending_cup_idx
      end
    end


  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? { |cup| cup.empty? } ||
    @cups[7..12].all? { |cup| cup.empty? }
  end

  def winner
    return :draw if cups[6].count == cups[13].count
    
    if cups[6].count > cups[13].count
      return @name1
    else
      return @name2
    end
  end

end
