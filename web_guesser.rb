require 'sinatra'
require 'sinatra/reloader'

def start
  @@secret_number = rand(101)
  @@health = 5
end

def check_guess(guess)
  return "Way too low!" if (@@secret_number - guess) > 25
  return "Too low!" if (@@secret_number > guess)
  return "Correct!\nThe secret number is #{@@secret_number}." if @@secret_number == guess
  return "Too high!" if (guess - @@secret_number) < 25
  return "Way too high!"
end

def colouring(guess)
  return 'green' if (@@secret_number == guess)
  return 'red' if (@@secret_number - guess).abs > 25
  return 'pink' if (@@secret_number - guess).abs < 25
end

def end_game(guess)
  if @@secret_number == guess
    start
    return "You won!"
  end
  message = ""
  if (@@health == 1)
    message = "You used all your guesses.\nThe secret number was #{@@secret_number}."
    start
  else
    @@health -= 1
  end
  message
end

get '/' do
  if params["cheat"] == "true"
    message = "The secret number is #{@@secret_number}"
  else
    guess = params["guess"].to_i
    message = check_guess(guess)
    colour = colouring(guess)
    result = end_game(guess)
  end
  erb :index, :locals => {:message => message, :colour => colour, :result => result}
end