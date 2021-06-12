#################################################################
module Basic
  def cls
    system('cls') || system('clear')
  end

  def instructions
    cls
    puts "Welcome to my version of mastermind!

		"
    puts 'If you choose to be the guesser you have 12 turns'
    puts 'to guess the computers code.'
    puts 'If you choose the maker you enter a code and see if'
    puts "the computer can solve it in 12 turns (He can)

		"
    puts 'Good Luck! (press any key to continue)'
    gets
  end
end

#################################################################
module Prints
  def color_map
    puts '┌─────────────────────────────────────────────┐'
    puts '│ 0 = red, 1 = blue, 2 = green, 3 = orange    │'
    puts '│ 4 = violet, 5 = brown, 6 = white, 7 = black │'
    puts '└─────────────────────────────────────────────┘'
  end

  def print_code(user)
    puts '┌─────────────────────────────────┐'
    print format('%-34.34s', "│ #{user} code is: #{@code}")
    puts '│'
    print format('%-34.34s',
                 "│ #{@color[@code[0].to_s].capitalize}, #{@color[@code[1].to_s].capitalize}, #{@color[@code[2].to_s].capitalize}, #{@color[@code[3].to_s].capitalize}")
    puts '│'
    puts '└─────────────────────────────────┘'
  end

  def print_guess(user, guess)
    # input = guess.dup.map {|i| i = @color[i.to_s].capitalize}
    puts '┌────────────────────────────────────────────────────────┐'
    print format('%-57.57s', "│ #{user} guess is: #{guess}")
    puts '│'
    puts '└────────────────────────────────────────────────────────┘'
  end
end

#################################################################
module Silent
  def check_silent(guess, lastguess)
    guess = guess.split('').map!(&:to_i)
    code = lastguess.dup
    match = []

    guess.each.with_index do |v, i|
      if code[i] == v
        match.push(2)
        guess[i] = nil
        code[i] = nil
      end
    end

    guess.compact!
    code.compact!

    code.map! do |o|
      if guess.include?(o)
        match.push(1)
        guess[guess.find_index(o)] = nil
        o = nil
      end
      o
    end

    match.push(0) while match.length < 4
    match
  end
end

#################################################################
module Scrap
  def getter(i)
    while @color.none? { |_k, v| v == i }
      color_map
      i = gets.chomp
    end
    cls
    i
  end

  def code_player_(guessing = false)
    puts "Choose 4 colors for your #{guessing == false ? 'code:' : 'guess:'}"
    puts '┌──────────┬───────────────────'
    puts '│1. Color: │'
    puts '└──────────┘'
    a = getter(a)
    puts '┌──────────┐'
    puts '│2. Color: │'
    puts '└──────────┘'
    b = getter(b)
    puts '┌──────────┐'
    puts '│3. Color: │'
    puts '└──────────┘'
    c = getter(c)
    puts '┌──────────┐'
    puts '│4. Color: │'
    puts '└──────────┘'
    d = getter(d)

    if guessing == false
      @code = [a, b, c, d].map do |i|
        if @colorname.any? { |k, _v| k == i }
          @colorname[i].to_i
        else
          i.to_i
        end
      end
      print_code('Your')
    else
      guess = [a, b, c, d].map do |i|
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
end
