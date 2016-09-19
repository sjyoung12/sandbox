import sys

def isContiguousSum(arr, target):
  return True

if __name__ == "__main__":
  assert len(sys.argv) == 3
  arr = map(int, sys.argv[1].split(','))
  target = int(sys.argv[2])
  print isContiguousSum(arr, target)
