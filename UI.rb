require_relative "Game"

class UI
  # welcome menu to choose game and create and  instance of Game class
  def welcomeMenu
    input=10
    until [1,2,3].include?(input)
      puts "\nWelcome to hangman! Choose an option:"
      puts "1. Load game"
      puts "2. New game"
      puts "3. Quit"
      print "Enter: "
      input = gets.to_i
    end

    if input==3
      return nil # quitting so return nil
    end
    # if loading game then get file name from load game menu
    game=input==2  ? Game.new() : Game.new(loadGameMenu)
  end

  # Method to display saved games and prompt user to choose one
  def loadGameMenu
    fileDir="saved"
    files = Dir.glob(File.join(fileDir, "*.json")) # get all files saved/~~~~~.json
    if files.empty?
      puts "No games in saved. Starting new game..."
      return nil
    end

    saves = files.map { |file| File.basename(file, ".json") } # get rid of .json
    input=nil
    until saves.include?(input) || input==""
      puts "Here are the saved games:"
      saves.each_with_index { |name, i| puts "#{i+1}. #{name}" } # display saved games
      print "Enter a game name (leave empty for new game): "
      input = gets.chomp
    end
    input=input=="" ? nil : input # empty string means new game
  end

  def start
    while true
      game=welcomeMenu # get instance of game
      if game==nil
        break # game is nil so quit
      end

      game.play # play game
    end
  end

end