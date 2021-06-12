#################################################################
class Code
  attr_reader :color, :code

  include Prints

  def initialize
    @colorname = { 'red' => '0', 'blue' => '1', 'green' => '2', 'orange' => '3', 'violet' => '4', 'brown' => '5',
                   'white' => '6', 'black' => '7' }
    @colornumber = @colorname.invert
    @color = @colorname.merge(@colornumber)
  end

  def code_player(guessing = false)
    puts "Choose 4 colors for your #{guessing == false ? 'code:' : 'guess:'}"
    puts '───────────────────────────────'
    puts 'You can only input a 4 digit number from 0-7 (0000 - 7777)'
    input = getter(input)

    if guessing == false
      @code = input.map do |i|
        if @colorname.any? { |k, _v| k == i }
          @colorname[i].to_i
        else
          i.to_i
        end
      end
      print_code('Your')
    else
      guess = input.map do |i|
        if @colorname.any? { |k, _v| k == i }
          @colorname[i].to_i
        else
          i.to_i
        end
      end

      print_guess('Your', guess)
      puts "Do you want to continue with this guess? (press 'n' for retry)"
      input = gets.chomp

      cls
      if input.downcase == 'n'
        code_player(true)
      else
        guess
      end
    end
  end

  def code_computer
    @code = [(rand * 7).round, (rand * 7).round, (rand * 7).round, (rand * 7).round]
    # print_code("Computer's")
  end

  def getter(i)
    color_map
    i = gets.chomp.gsub(' ', '').split('')

    until i.all? { |o| @color.values.include?(o) } && i.length == 4
      puts 'Try again:'
      color_map
      i = gets.chomp.gsub(' ', '').split('')
    end
    i
  end
end

#################################################################
class Game
  attr_reader :match, :turn, :lastGuess

  include Silent
  include Prints
  def initialize(role)
    @code = Code.new
    @turn = 1
    @win = false
    @lastGuess = []
    @role = role
  end

  def start
    if @role == 1
      start_game_breaker
    else
      @computer = Computer.new
      start_game_maker
    end
  end

  # player turns
  def start_game_breaker
    @code.code_computer
    while @turn <= 12 && @win == false
      puts "»Turn #{@turn}"
      puts "»Last guess: #{@lastGuess}" unless @lastGuess.empty?
      puts ""
      guess = @code.code_player(true)
      check(guess)
      @turn += 1
    end
    game_lose('You') if @win == false
    game_win('You') if @win == true
  end

  # computer turns
  def start_game_maker
    @code.code_player
    while @turn <= 12 && @win == false
      puts "»Turn #{@turn}"
      puts "»Last guess: #{@lastGuess}" unless @lastGuess.empty?
      guess = @computer.output
      puts "»Computer guessed: #{guess} this turn"
      check(guess)
      @turn += 1
    end
    game_lose('Computer') if @win == false
    game_win('Computer') if @win == true
  end

  def check(guess)
    @lastGuess = guess.dup # .map {|i| i = @code.color[i.to_s].capitalize}
    code = @code.code.dup
    @match = []

    return @win = true if code == guess

    guess.each.with_index do |v, i|
      if code[i] == v
        @match.push(2)
        guess[i] = nil
        code[i] = nil
      end
    end

    guess.compact!
    code.compact!

    code.map! do |o|
      if guess.include?(o)
        @match.push(1)
        guess[guess.find_index(o)] = nil
        o = nil
      end
      o
    end

    @match.push(0) while @match.length < 4
    show_match
  end

  def show_match
    match = @match.dup.map! do |i|
      i = if i == 0
            '─ NoMatch ─'
          elsif i == 1
            'Color Match'
          else
            '── Match ──'
          end
    end
    puts '  ┌───────────┬───────────┐'
    puts "  ├#{match[0]}┼#{match[1]}┤"
    puts '  ├───────────┼───────────┤'
    puts "  ├#{match[2]}┼#{match[3]}┤"
    puts '  └───────────┴───────────┘'
  end

  def game_win(player)
    puts ""
    puts "»#{player} won!"
    @code.print_code(player == 'You' ? "Computer's" : 'Your')
    puts ''
    puts 'Press any key to continue'
    gets
    new_game
  end

  def game_lose(player)
    puts ""
    puts "»#{player} ran out of turns!"
    @code.print_code(player == 'You' ? "Computer's" : 'Your')
    puts ''
    puts 'Press any key to continue'
    gets
    new_game
  end
end

#################################################################
class Computer
  def initialize
    @guess = [1, 1, 2, 2]
    @possibleCodesAll = []
    @possibleCodes = []

    ('0000'..'7777').each do |i|
      @possibleCodesAll.push(i) if i.match?(/[0-7][0-7][0-7][0-7]/)
    end
  end

  def output
    sleep(1)
    return @guess if $game.turn == 1

    @guess = new_guess
  end

  # Couldn't be bothered to minmax the samples, just random picking is accurate good enough
  def new_guess
    @possibleCodes = if @possibleCodes.empty?
                       @possibleCodesAll.map do |i|
                         if $game.check_silent(i, $game.lastGuess) == $game.match
                           i
                         else
                           i = nil
                         end
                       end.compact!

                     else
                       @possibleCodes.map do |i|
                         if $game.check_silent(i, $game.lastGuess) == $game.match
                           i
                         else
                           i = nil
                         end
                       end.compact!

                     end
    @possibleCodes.sample.split('').map!(&:to_i)
  end
end
#################################################################
