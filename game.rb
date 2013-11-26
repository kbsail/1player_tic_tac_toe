require_relative('game_controller')
require_relative('player')
require_relative('view')
require_relative('game_ai')

class Game

  attr_accessor :board, :winner
  attr_reader :players, :turns

  def initialize(player1, player2)
    self.board = Array.new(9) { 0 }
    @players = [Player.new(player1, 1), Player.new(player2, 2)]
    @turns = 0
    @winner = nil
  end

  # a list of all the possible winning combos (by board index)
  def winning_combos
    [[0, 1, 2], [3, 4, 5], [6, 7, 8],
     [0, 3, 6], [1, 4, 7], [2, 5, 8],
     [0, 4, 8], [2, 4, 6]]
  end  

  # sets the player on the board with the input
  def set_player(input, player_num)
    board[input.to_i] = player_num
  end

  # checks for a draw
  def draw?
    !board.include?(0) && winner.nil?
  end

  # checks if the game is finished
  def finished?
    draw? || !winner.nil?
  end

  # checks for a winner
  def check_win(player)
    winning_combos.each do |winning_combo|
      if three_in_a_row(winning_combo, player)
        @winner = player
        return true
      end
    end
    
    false
  
  end

  # checks if a space is empty
  def space_open?(input)
    board[input] == 0
  end

  # returns all open spaces on the board
  def open_spaces
    board.map.with_index { |space, index| index if space_open?(index) }.compact
  end

  # returns the current players turn (1 for human, 2 for computer)
  def current_player_turn
    turns % 2 == 0 ? 1 : 2
  end

  # changes the turn to the next player
  def next_turn
    @turns += 1
  end
  
  ##############################

  # checks if a player has three in a row
  def three_in_a_row(winning_combo, player)
    board_spaces(winning_combo).count(player) == 3
  end

  # returns the board state (if the space has player1, the computer or is empty) in each winning combo space
  def board_spaces(winning_combo)
    winning_combo.map {|space| board[space] } 
  end

  # returns the empty space if a player has two spaces in a row followed by an empty space
  def two_inline(winning_combo, two_count, one_count)
    if board_spaces(winning_combo).count(two_count) == 2 && board_spaces(winning_combo).include?(one_count)
      winning_combo.each {|space| return space if board[space] == 0 }
    end
  end

  # checks if a player has two in a row followed by an empty space
  def check_two(two_count, one_count)
    winning_combos.each do |winning_combo|
      open_space = two_inline(winning_combo, two_count, one_count)
      return open_space if !open_space.nil?
    end
    
    nil
  
  end

  # checks if a player has two middle spaces taken
  def two_middle(player)
    board.each_with_index.map {|space, index| index % 2 if space == player  }.count(1) == 2
  end

end
