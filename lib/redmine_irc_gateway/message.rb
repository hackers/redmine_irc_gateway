
class Net::IRC::Message

  def modify!(*args)
    args.each_with_index { |n,i|
      self.params[i] = n
    }
  end
end

