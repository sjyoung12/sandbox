import sys

class Fibonacci(object):
  MAX_INPUT = 50000

  def __init__(self):
    self.cache = {0:0, 1:1}

  def validate_input(self, n):
    if n > self.MAX_INPUT:
      print "Only numbers less than %d are supported" % self.MAX_INPUT
      return False
    elif n < 0:
      print "Only nonnegative numbers are supported"
      return False
    else:
      return True

  def iterative_solve(self, n):
    if not self.validate_input(n):
      return -1
    for i in range(n):
      self.solve(i)
    return self.solve(n)

  def solve(self, n):
    if not self.validate_input(n):
      return -1
    elif n not in self.cache:
      self.cache[n] = self.solve(n - 1) + self.solve(n - 2)
    return self.cache[n]

if __name__ == "__main__":
  assert len(sys.argv) == 2
  print Fibonacci().iterative_solve(int(sys.argv[1]))
