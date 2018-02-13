require 'sinatra'
require 'sinatra/reloader'

@@secret_number = rand(101)
@@health = 5

def check_guess(guess)
  return "Way too low!" if (@@secret_number - guess) > 25
  return "Too low!" if (@@secret_number > guess)
  return "Correct!\nThe secret number is #{@@secret_number}" if @@secret_number == guess
  return "Too high!" if (guess - @@secret_number) < 25
  return "Way too high!"
end

def colouring(guess)
  return 'green' if (@@secret_number == guess)
  return 'red' if (@@secret_number - guess).abs > 25
  return 'pink' if (@@secret_number - guess).abs < 25
end

def end_game(guess)
  message = ""
  if (@@health == 1)
    message = @@secret_number == guess ? "You won!" : "You used all your guesses.\nThe secret number was #{@@secret_number}"
    @@secret_number = rand(101)
    @@health = 5
  else
    @@health -= 1
  end
  message
end

get '/' do
  guess = params["guess"].to_i
  message = check_guess(guess)
  colour = colouring(guess)
  result = end_game(guess)
  erb :index, :locals => {:message => message, :colour => colour, :result => result}
end