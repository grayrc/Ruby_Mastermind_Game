=begin

Mastermind word game

Author: Richard Gray
Date: 9/11/2017 
=end

=begin
constants for number of guesses the player will have, and time
of pause between showing each letters result for dramatic effect,
written in the correct format for ruby
=end
GUESSES_CONST = 5
PAUSE_TIME_CONST = 0.25

=begin
	The game class contains the code for one round of the game.
=end
class Game
=begin
	attr_accessor sets up the atribute reader and writer for 'word' this acts as get and set methods
	allowing the variable to be accessed outside of the class.
	N.B. the variable is never read, so just attr_writer could have been used here
=end  
  attr_accessor :word

=begin
	compare_words takes a variable; guess, and compares it with the class variable, 'word'.
	it iterates through an array containing each letter in 'word' and compares it to the
	corresponding letter in an array of the letters in 'guess'
	if they are equal, a variable, 'result', is set to one string. If the character in 'guess' is
	in the string 'word' - accertained with the .include string method - 'result' is set to another
	string, otherwise 'result' is set to another string.
	result is then inserted into a string using string interpolation and written to the console 
	after a short pause. This tells the player which of their guesses letters are in the word, and if
	they are in the right place
=end  
  def compare_words guess
=begin
	First 'word' has any new line characters removed with .chomp. it is then separated into an
	array of characters with .chars. the .each_with_index method then takes each member of that
	array along with with it's index and passes it to a block - the code within the braces.
	the letters within the pipes are the variables passed in by .each_with_index. c is the character
	from the array and i is the index.
=end
    word.chomp.chars.each_with_index { |c, i|
=begin		
	the letter 'c' from the word array is compared directly with the letter with the same index from
	an array made from the letters of the string guess using .chars.
	if they are equivalent, the guess has a the same word in the same place as the word, and a string
	stating this is set to a variable, result.
=end		
      if c == guess.chomp.chars[i]
        result = "in the word in the same place"
=begin
	if the character at the same index of 'guess' (as a char array) as the current letter of the word array
	from .each_with_index, is not the same as that character (as it has passed through the previous if), but
	the .include? method, called on word, (with any extra characters removed with .chomp) accertains that 
	that guess character is in 'word', then a string stating as much is set to a variable, result.
=end
      elsif word.chomp.include?(guess.chars[i])
        result = "in the word in a different place"
=begin
	if neither of the previous statements are true, the character is not in the word and a string stating
	so is set to a variable, result.
=end
      else
        result = "not in the word"
      end
=begin
	the game is paused for a short time with the sleep method between each letter being displayed
	N.B. This is the reason compare_words prints the strings directly instead of returning them, which
	would be better in terms of modularity, but would not have the same dramatic effect
=end
      sleep(PAUSE_TIME_CONST)
=begin
	a string is written to the console using puts with the current character from .each_with_index, and
	the string 'result' from the previous if/else statements interpolated into it.
	string interpolation allows one to insert code directly into a string and is what is inside the #{}.
=end
      puts "Letter: #{guess.chars[i]} : #{result}"
      }
  end

=begin
	the play game method contains the code for one game of mastermind. It has no inputs or returns.
	It keeps track of how many guesses the player has had with num_guesses, and whether the word has
	been guessed with guessed_it. 
	It contains a loop which lets the player guess until they have used all their guesses or guessed
	correctly.
	Inside the loop, instructions to enter a word are written to the console and the text entered is stored
	as a variable and passed into compare_words.
	compare_words provides user feedback. If the guess is equal to the word, feedback is given and the
	guessed_it variable is set to true. If this happens, or the number max number
	of guesses is reached, the loop ends and if the player has not guessed the word, a message and the
	word are displayed.
=end
  def play_game

	#number of guesses the player has had
    num_guesses = 0
	#whether the player has guessed the word
    guessed_it = false
	
=begin
	The until loop is the same as 'while not' - so while it is not the case that the variable num_guesses 
	(which is incremented in each loop iteration) is equal to the GUESSES_CONST constant or the guessed_it
	variable is true, the loop will continue.
=end
    until num_guesses == GUESSES_CONST || guessed_it
=begin
	the number of guesses left is calculated by subtracting num_guesses (the number of guesses left) from
	GUESSES_CONST (the maximum number of guesses) inside a string using sting interpolation and written to
	the console using puts, which ends in a new line. The user is then prompted to enter a guess with print
	which does not end in a new line.
=end
      puts "\nYou have #{GUESSES_CONST - num_guesses} guesses left."
      print "\nEnter your guess: "
=begin
	the user input is read using the gets method, any new line characters are removed with .chomp and is set
	to lower case with the string method, .downcase.
	N.B I don't believe any more input checking is necessary here, as it doesn't matter if to few letters are
	entered, and if more are entered, just the first 5 will be read.
=end
      guess = gets.chomp.downcase

	  #number of guesses variable is incremented
      num_guesses += 1
=begin
	the compare_words method is called with the newly inputed 'guess' variable as an argument.
=end
      compare_words guess
=begin
	if the word that has been set as a class variable is equivalent to the players guess, a message is printed
	to the console with how many guesses it took (num_guesses) interpolated in, and the guessed_it variable
	is set to true
=end
      if word.chomp == guess.chomp
        puts "\nCongratulations, you guessed the word in #{num_guesses} guesses!"
        guessed_it = true
      end
	  
    end #end of until loop
=begin
	If the until loop has ended and guessed_it is false, then the player must have used all their guesses
	and a losing message is printed to the console with the correct word interpolated in.
=end
    if !guessed_it
      puts "\nYou did not guess the word in time :-("
      puts "\nthe word was #{word.chomp}."
    end #end of if
  end #end of play_game method
end #end of Game class.

#welcome message and instructions
puts "Welcome to the MasterMind word game"
puts "\nTry and guess the 5 letter word I am thinking of."
puts "\nEnter a five letter word and you will be told:\n\t*How many of it's letters are in the word and in the same place\n\t*How many letters are in the word, but in the wrong place\n\t*How many letters are not in the word."
puts "\nGood luck!"

#create empty array
all_words = Array.new

=begin
	.open is a method of the File class which opens a file(!) and returns
	a file object.
	the code in braces is a block. This is a piece of code which
	is passed to a method, in this case, the .each method, which yields
	each line of the File object.
	|line| is a parameter passed to the block, in this case, each
	line of the text file.
	all_words << (line) appends the parameter 'line' to the array 'words'
=end
File.open("mastermindWordList.txt").each {|line| all_words << (line)}

=begin
	the .reject method from the Array class returns an array the same as
	it's input, but without the items defined by its input block.
	In this case, if the length of the array (.count) of characters in
	the word (.char) with any repeating characters removed (.uniq) is
	not the same as the length of the word, (.length), the word has duplicate
	entries and is not added to the new array
=end
words = all_words.reject { |line| line.chars.uniq.count != line.length}

#create new instance of Game class
game = Game.new

=begin
	begin starts a while loop with it's condition at the end - the same as a do while loop in otherwise
	languages. In this case, the user is asked if they want to play again and the loop continues until
	they say no.
=end
begin
=begin
	A single word is selected randomly from the words array. A random number is selected between 0 and the 
	number of items in the words aray, as determined by .count. The word in the array with that	index is
	set to the variable 'word'.
=end
	word = words[rand(words.count - 1)]

	#instructions printed to console
	puts "\n\nI'm thinking of a 5 letter word.\nCan you guess it?"

=begin
	the variable 'word' is given to the game object of the Game class. it is able to do this because of the
	attr_accessor method in Game class.
=end
	game.word = word

=begin
	the play_game method is called on game, and one round of the game is played.
=end
    game.play_game

	#after each round of the game the player is asked if they would like to play again.
	print "\nWould you like to play again? "
	
=begin
	begin also starts a loop with it's condition at the end, this time an until statement. the player is
	asked to enter either a y to continue, or a n to quit, and until they do either, the loop continues
=end	
	begin
		#player prompted to enter y or n
		print "enter 'y' or 'n': "
=begin
	the variable 'c' is set to the user input with gets with tags removed with .chomps, and set to lower
	case with .downcase.
=end
		c = gets.chomp.downcase
=begin
	If the user input is Y or y, the player wants continue, and a variable 'continue' is created with
	the boolean value, true.
=end
		if c == 'y'
			continue = true
		end
=begin
	If the user input is N or n, the player does not want to continue, and a variable 'continue' is created
	with the boolean value, false.
=end
		if c == 'n'
			continue = false
			#if player chooses to end, a goodbye message is displayed
			puts "\nThankyou for playing\nGoodBye!\n"
		end
=begin
	if the player enters anything other than 'Y', 'y', 'N', or 'n', the loop continues and the player is
	prompted to enter y or n again.
=end
	end until c == 'n' || c == 'y'
=begin
	depending on the user input continue will be either true or false and the loop will either start again,
	playing the game with a new word, or the game will end.
=end
end while continue
