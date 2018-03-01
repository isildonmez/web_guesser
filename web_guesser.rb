require 'sinatra'
require 'sinatra/reloader'

$secret_number ||= rand(101)
$health ||= 5

def check_guess(guess)
  return "" if guess.nil?
  guess = guess.to_i
  return "Way too low!" if ($secret_number - guess) > 25
  return "Too low!" if ($secret_number > guess)
  return "Correct!\nThe secret number is #{$secret_number}." if $secret_number == guess
  return "Too high!" if (guess - $secret_number) < 25
  return "Way too high!"
end

def colouring(guess)
  return "white" if guess.nil?
  guess = guess.to_i
  return 'green' if ($secret_number == guess)
  return 'red' if ($secret_number - guess).abs > 25
  return 'pink' if ($secret_number - guess).abs < 25
end

def end_game(guess)
  return if guess.nil?
  guess = guess.to_i
  if $secret_number == guess
    return "You won!"
  end
  $health -= 1
  message = ""
  if ($health == 0)
    message = "You used all your guesses.\nThe secret number was #{$secret_number}."
  end
end

get '/' do
  guess = params["guess"]
  feedback = check_guess(guess)
  colour = colouring(guess)
  result = end_game(guess)
  if params["cheat"] == "true"
    feedback = "The secret number is #{$secret_number}"
    colour = colouring(nil)
    result = end_game(nil)
  end
  if ($health == 0) || (result == "You won!")
    $secret_number = rand(101)
    $health = 5
  end
  erb :index, :locals => {:feedback => feedback, :colour => colour, :result => result}
end