require 'json'
require_relative 'secure'

class Game
  def initialize(file=nil)
    @file=file
    @file.nil? ? newGame : loadGame # file=nil means start new game
  end

  def loadGame
    fileDir="saved"
    path=File.join(fileDir, "#{@file}.json") # get file path
    if File.exist?(path)
      data=JSON.parse(File.read(path)) # get data map from json file
      @guessesLeft=data["guessesLeft"]
      @word=Secure.decrypt(data["word"], @guessesLeft) # decrypt word
      @found=Set.new(data["found"])
    else
      puts "No saved game found. Starting a new game"
      newGame
    end
  end

  def saveGame
    fileDir="saved"
    Dir.mkdir(fileDir) unless Dir.exist?(fileDir) # if directory does not exist then make it
    if @file.nil?
      getFileName
    end

    data = {
      word: Secure.encrypt(@word,@guessesLeft), # encrypt word to avoid peeking into .json to see answer
      guessesLeft: @guessesLeft,
      found: @found.to_a # turn hash set to array
    }
    path=File.join(fileDir, "#{@file}.json") # get path
    File.write(path, JSON.pretty_generate(data)) # write .json to store data map
    puts "\nGame saved to #{path}"
  end

  # method prompts user for file name (for saving purposes)
  def getFileName
    puts "\nNo current file for this game."
    print "Create a file name: "
    @file=gets.chomp
  end

  # initialise a new game
  def newGame
    @guessesLeft=6
    @word = randomWord
    @found = Set.new()
  end

  # method deletes file (called once game is finished)
  def deleteGame
    fileDir = "saved"
    path = File.join(fileDir, "#{@file}.json")
    File.delete(path) if File.exist?(path)
  end

  # method gets a random word from word.txt (this is file for words between length 5-12)
  def randomWord
    # chomp: true removes \n from the end of each line
    words = File.readlines('data/word.txt', chomp: true)
    words.sample.chars # return a random word from words
  end

  # method that checks if word is found
  def wordFound
    @word.all? { |char| @found.include?(char) }
  end

  # method prompts user to guess a letter in word
  def getLetter
    char="1"
    # use regex to check if character given is in alphabet of "0" (save and quit). also check if character is already in found set
    until char.match(/[a-zA-Z0]{1}/) && !@found.include?(char)
      print "\n\nPick a letter (or input '0' to save and quit): "
      char=gets.chomp
    end
    char
  end

  # method checks if letter is in word
  def checkLetter(char)
    char.downcase!
    unless @word.include?(char)
      puts "Word doesn't contain letter: #{char}"
      @guessesLeft-=1 # wrong guess so subtract a guess
      return
    end
    puts "Well done! Word contains letter: #{char}"
    @found.add(char) # char in word so add to found set
  end

  # method for playing game
  def play
    # game ends if no guesses left or if word is found
    until @guessesLeft==0 || wordFound
      displayBoard
      char=getLetter
      if char=="0"
        saveGame # save request so save game and exit back to welcome menu (in UI.rb)
        return
      end
      checkLetter(char)
    end
    deleteGame # Game finished so delete file
    if @guessesLeft==0
      puts "\n\nYou have ran out of guesses."
    else
      puts "\n\nCongratulations! You have correctly guessed the word with #{@guessesLeft} guesses left!"
    end
    puts "\nWord: #{@word.join(" ")}" # game end so display word
  end

  # Method for displaying found letters position in word and also the guesses left
  def displayBoard
    print "\nWord:"
    @word.each do |l|
      print @found.include?(l) ? " #{l}" : " _"
    end
    puts "\nGuesses left: #{@guessesLeft}"
  end
end

# game=Game.new("Will")
# game.play
# game.displayBoard
# game.checkLetter("i")
# game.displayBoard
# game.checkLetter("a")
# game.displayBoard
# game.checkLetter("e")
# game.displayBoard
# game.checkLetter("o")
# game.displayBoard
# game.checkLetter("u")
# game.deleteGame
# game.saveGame