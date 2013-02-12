#!/usr/bin/env ruby

class Board
  attr_reader :board
  def initialize
    @board = [0] * 9
    @winner = nil
    @human_turn = true
  end

  def play
    while unfinished? do
      if @human_turn
        draw
        human_turn
      else
        computer_turn
      end

      @human_turn = !@human_turn
    end
    draw
    announce!
  end

  private
  def unfinished?
    @winner = check_for_winner

    @winner.nil?
  end

  def display_val(i)
    case board[i]
    when 0
      i
    when 1
      'X'
    when -1
      'O'
    end
  end

  def draw
    puts "   |   |   "
    puts " " + (0..2).map {|i| display_val(i) || i}.join(" | ")
    puts "---|---|---"
    puts " " + (3..5).map {|i| display_val(i) || i}.join(" | ")
    puts "---|---|---"
    puts " " + (6..8).map {|i| display_val(i) || i}.join(" | ")
    puts "   |   |   "
  end

  WIN_STATES = [[0, 1, 2],
                [3, 4, 5],
                [6, 7, 8],
                [0, 3, 6],
                [1, 4, 7],
                [2, 5, 8],
                [0, 4, 8],
                [2, 4, 6]]

  # nil => unfished | 1 => X wins | -1 => O wins | 0 => tie
  def check_for_winner
    winner = nil

    WIN_STATES.each do |state|
      sum = state.map { |pos| board[pos] }.reduce(:+)

      if sum.abs == 3
        winner = sum / 3
        break
      end
    end

    unless board.include?(0)
      winner = 0
    end

    winner
  end

  def human_turn
      puts "Select your position: "
      position = gets.chomp.to_i
      until board[position].zero? do
        puts "Nope. Try again: "
        position = gets.chomp.to_i
      end
      board[position] = 1
  end

  def computer_turn
    computer_move = rand(9)
    until board[computer_move].zero? do
      computer_move = rand(9)
    end
    board[computer_move] = -1
  end

  def announce!
    case @winner
    when 0
      puts "You tied!"
    when 1
      puts "X won!"
    when -1
      puts "O won!"
    end
  end
end

Board.new.play
