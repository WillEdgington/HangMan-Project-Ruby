# Run this file to filter words in google words text file to get words between 5 and 12 characters long then save to word.txt

dirPath='data/'
inputFile = dirPath + 'google-10000-english-no-swears.txt'
outputFile = dirPath + 'word.txt'

File.open(outputFile, 'w') do |out| # write to the output file (word.txt)
  File.foreach(inputFile) do |line| # read input file (google words text file)
    word = line.strip # remove outer blank spaces
    out.puts(word) if word.length.between?(5,12) # write word to output if between length 5,12 
  end
end