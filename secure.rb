# this file is for encypting and decrypting word array
module Secure
  MASK=[20,6,20,25,17,36,1,12,29,3,38,101] # mask of random but fixed values

  # This function is used to get relative ordering number (just a random function involving a and b)
  def self.func1(a,b)
    ((((a ^ b + 3)**a) >> 1) + 1) % 204 # (% int helps get rid of strictly positive gradient so x->X does not imply f(x)->f(X))
  end
  
  # This function gives us our shifting values (before mask) (another random function involving a and b)
  def self.func2(a,b)
    ((Math.sqrt(2.71828**(a+1)).to_i | b) + 23)**(a | b) % 306
  end

  # Method for getting shift array with respect to num
  def self.getArr(num)
    arr=[]
    (1..12).each do |x|
      arr.append([func1(x,num),func2(x,num)]) # [relative ordering index, shift values (before masking)]
    end
    arr.sort! # sort with respect to relative ordering index (arr[i][0])
    arr.map! { |a| a[1] } # get rid of relative ordering index
    arr.each_with_index.map { |val, i| (val + MASK[i]) % 26 } # add mask and the mod 26 (shift of 26 is complete cycle of alphabet)
  end

  def self.encrypt(word,num)
    arr = self.getArr(num) # get shift arr with respect to num (in our case num=@guessesLeft from Game.rb)
    word.each_with_index.map { |l, i| ((((l.ord - "a".ord) + arr[i]) % 26) + "a".ord).chr } # shift characters in word to RIGHT of alphabet given arr[i]
  end

  def self.decrypt(word,num)
    arr = self.getArr(num) # get shift arr with respect to num
    word.each_with_index.map { |l, i| ((((l.ord - "a".ord) + 26 - arr[i]) % 26) + "a".ord).chr } # shift characters in word to LEFT of alphabet given arr[i]
  end
end

# puts Secure.encrypt(["g","r","o","w","s"],2)
# puts Secure.decrypt(Secure.encrypt(["g","r","o","w","s"],2),2)