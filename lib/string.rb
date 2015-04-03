class String

  def green
    "\033[32m#{self}\033[0m"
  end

  def red
    "\033[31m#{self}\033[0m"
  end

  def blue
    "\033[34m#{self}\033[0m"
  end
end
