class Game
  def initialize(file)
    @file=file
    loadGame
  end

  def initialize()
    @file=nil
    newGame
  end

  def loadGame
  end

  def saveGame
  end

  def newGame
    @guessesLeft=6
    @word = randomWord
    @found = Set.new()
  end

  def randomWord
    # chomp: true removes \n from the end of each line
    words = File.readlines('data/word.txt', chomp: true)
    words.sample.chars # return a random word from words
  end

  def wordFound
    @word.all? { |char| @found.include?(char) }
  end

  def getLetter
    char="1"
    until char.match(/[a-zA-Z0]{1}/) && !@found.include?(char)
      print "\n\nPick a letter (or input '0' to save and quit): "
      char=gets.chomp
    end
    char
  end

  def checkLetter(char)
    char.downcase!
    unless @word.include?(char)
      puts "Word doesn't contain letter: #{char}"
      @guessesLeft-=1
      return
    end
    puts "Well done! Word contains letter: #{char}"
    @found.add(char)
  end

  def play
    until @guessesLeft==0 || wordFound
      displayBoard
      char=getLetter
      if char=="0"
        saveGame
        return
      end
      checkLetter(char)
    end
    if @guessesLeft==0
      puts "\n\nYou have ran out of guesses."
    else
      puts "\n\nCongratulations! You have correctly guessed the word with #{guessesLeft} guesses left!"
    end
    puts "\nWord: #{@word.join(" ")}"
    gets.chomp
  end

  def displayBoard
    print "\nWord:"
    @word.each do |l|
      print @found.include?(l) ? " #{l}" : " _"
    end
    puts "\nGuesses left: #{@guessesLeft}"
  end
end

game=Game.new()
game.play
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
