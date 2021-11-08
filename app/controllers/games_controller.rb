# frozen_string_literal: true

require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    # test
    @array = 10.times.map do
      [*'a'..'z'].sample
    end
  end

  def score
    # test
    @attempt = params[:word]
    check_word_exists
    word_in_grid
    if @word_exists == true && @word_in_grid == true
      @results = "#{@attempt} exists and can be built from #{params['grid']}"
    elsif @word_exists == false && @word_in_grid == true
      @results = "#{@attempt} does not exist but can be built from #{params['grid']}"
    elsif @word_exists == true && @word_in_grid == false
      @results = "#{@attempt} does exist but cannot be built from #{params['grid']}"
    else
      @results = "#{@attempt} does not exist and cannot be built from #{params['grid']}"
    end
    @results
  end

  def check_word_exists
    url_with_attempt = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    serialized_attempt = URI.open(url_with_attempt).read
    attempt_hash = JSON.parse(serialized_attempt)
    case attempt_hash['found']
    when true
      @word_exists = true
    when false
      @word_exists = false
    end
  end

  def word_in_grid
    @word_in_grid = true
    grid = params['grid'].split(' ')
    grid.each do |grid_letter|
      if @attempt.count(grid_letter.downcase) == params['grid'].count(grid_letter.downcase)
        @word_in_grid && true
      else
        @word_in_grid && false
      end
    end
    binding.pry
    @word_in_grid
  end
end
