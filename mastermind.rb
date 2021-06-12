require_relative 'modules'
require_relative 'classes'
include Basic

def new_game
  cls
  puts 'Start a new game? (Y/n or any other key)'
  input = gets.chomp
  if input.downcase != 'y'
    puts 'Thanks for playing!'
    sleep(1)
    cls
  else
    puts 'Choose your role (breaker = 1 or maker = 0)'
    role = gets.chomp
    until %w[1 0].include?(role)
      puts 'Try again'
      role = gets.chomp
    end
    cls
    $game = Game.new(role.to_i)
    $game.start
  end
end
#################################################################

instructions
new_game
