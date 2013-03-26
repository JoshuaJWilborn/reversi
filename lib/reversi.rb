#!/bin/env ruby
# encoding: utf-8
require 'colorize'
require 'debugger'

class Board
  VECTORS = [
    [-1, 1],   [0, 1], [1, 1],
    [-1, 0],           [1, 0],
    [-1, -1], [0, -1], [1, -1]
  ]
  attr_reader :rows
  def initialize
    set_up_board
    set_up_pieces
  end

  def set_up_board
    @rows = Array.new(8) { Array.new(8, nil) }
  end

  def set_up_pieces
    self[3, 3], self[4, 4]  = Piece.new(:blue), Piece.new(:blue)
    self[3, 4], self[4, 3] = Piece.new(:red), Piece.new(:red)
  end

  def display(color=nil)
    puts "  0 1 2 3 4 5 6 7   ".colorize(:color => :black, :background => :white)
    8.times do |y|
      row_print = " #{7-y}".colorize(:color => :black, :background => :white)
      8.times do |x|
        if self[x, 7-y].nil?
          if valid_move?(color, [x, 7-y])
            row_print << '  '.colorize(:background => color)
          else
            row_print << '  '.colorize(:background => :black)
          end
        end
        row_print << self[x, 7-y].to_s
      end
      row_print << "#{7-y} ".colorize(:color => :black, :background => :white)
      puts row_print + "\n"
    end
    puts "  0 1 2 3 4 5 6 7   ".colorize(:color => :black, :background => :white)
  end


  def [](x, y)
    @rows[@rows[1].length-y-1][x]
  end

  def []=(x, y, value)
    @rows[@rows[1].length-y-1][x] = value
  end

  def place(color, coords)
    if valid_move?(color, coords)
      self[*coords] = Piece.new(color)
      swap_colors(color, coords)
    end
  end

  def swap_colors(color, coords)

    return false if surrounded_by_nil?(coords)
    VECTORS.each do |vector|
      opp_color_encountered = false
      #check each consecutive space
      move_array = []
      (1..7).each do |magnitude|
        x, y = coords
        x += vector[0] * magnitude
        y += vector[1] * magnitude
        move_array << [x, y]
        break if self[x, y].nil?
        break if off_board?([x, y])
        break if self[x, y] && self[x, y].color == color && magnitude == 1
        if self[x, y] && self[x, y].color == color && magnitude > 1
          move_array.each do |coords|
            self[*coords].color = color == :blue ? :blue : :red
          end
        end
      end
    end
  end

  def valid_move?(color, coords)
    ( off_board?(coords) || occupied?(coords) || !any_valid_direction?(color, coords) ) ? false : true
  end

  def occupied?(coords)
    self[*coords]
  end

  def off_board?(coords)
    coords.any? {|coord| coord > 7 || coord < 0 }
  end

  def surrounded_by_nil?(coords)
    VECTORS.each do |vector|
      x, y = coords
      x += vector[0]
      y += vector[1]
      next if off_board?([x, y])
      return false if self[x, y]
    end
    true
  end

  def any_valid_direction?(color, coords)
    return false if surrounded_by_nil?(coords)
    VECTORS.each do |vector|
      opp_color_encountered = false
      #check each consecutive space
      (1..7).each do |magnitude|
        x, y = coords
        x += vector[0] * magnitude
        y += vector[1] * magnitude
        break if self[x, y].nil?
        break if off_board?([x, y])
        break if self[x, y] && self[x, y].color == color && magnitude == 1
        return true if self[x, y] && self[x, y].color == color && magnitude > 1
      end
    end

    false
  end
end

class Piece
  attr_accessor :color
  def initialize(color)
    @color = color
  end

  def to_s
     color == :red ? "◉ ".colorize( :color => :red ) : "◉ ".colorize( :color => :blue )
  end
end
