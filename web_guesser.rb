require 'sinatra'
require 'sinatra/reloader'

x = rand(101)
get '/' do
  "The secret number is #{x}"
end