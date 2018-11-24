class Array
  
  def uniq?(*args, &block)
    length == uniq(*args, &block).length
  end

end