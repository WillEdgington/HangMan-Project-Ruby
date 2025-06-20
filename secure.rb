# this file is for encypting and decrypting word array
module Secure
  MASK=[20,6,20,25,17,36,1,12,29,3,38,101]

  def self.func1(a,b)
    ((((a ^ b + 3)**a) >> 1) + 1) % 204
  end
  
  def self.func2(a,b)
    ((Math.sqrt(2.71828**(a+1)).to_i | b) + 23)**(a | b) % 306
  end

  def self.getArr(num)
    arr=[]
    (1..12).each do |x|
      arr.append([func1(x,num),func2(x,num)])
    end
    arr.sort!
    arr.map! { |a| a[1] }
    arr.each_with_index.map { |val, i| (val + MASK[i]) % 26 }
  end
  def self.encrypt(word,num)
    arr = self.getArr(num)
    word.each_with_index.map { |l, i| ((((l.ord - "a".ord) + arr[i]) % 26) + "a".ord).chr }
  end


  def self.decrypt(word,num)
    arr = self.getArr(num)
    word.each_with_index.map { |l, i| ((((l.ord - "a".ord) + 26 - arr[i]) % 26) + "a".ord).chr }
  end
end

# puts Secure.encrypt(["g","r","o","w","s"],2)
# puts Secure.decrypt(Secure.encrypt(["g","r","o","w","s"],2),2)