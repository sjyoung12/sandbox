import sys
MIN_VALUE = 0
MAX_VALUE = 999999999999999
MAGNITUDES = {
  0: '',
  1: 'thousand',
  2: 'million',
  3: 'billion',
  4: 'trillion',
  5: 'quadrillion',
  6: 'quintillion',
}
TENS = {
  0: '',
  2: 'twenty',
  3: 'thirty',
  4: 'forty',
  5: 'fifty',
  6: 'sixty',
  7: 'seventy',
  8: 'eighty',
  9: 'ninety',
}
TEENS = {
  0: 'ten',
  1: 'eleven',
  2: 'twelve',
  3: 'thirteen',
  4: 'fourteen',
  5: 'fifteen',
  6: 'sixteen',
  7: 'seventeen',
  8: 'eighteen',
  9: 'nineteen',
}
ONES = {
  0: '',
  1: 'one',
  2: 'two',
  3: 'three',
  4: 'four',
  5: 'five',
  6: 'six',
  7: 'seven',
  8: 'eight',
  9: 'nine',
}

def translate_triplet(triplet):
  assert len(triplet) == 3
  tokens = []
  tokens.append(ONES[triplet[0]] + ' hundred' if triplet[0] > 0 else '')
  if triplet[1] == 1:
    tokens.append(TEENS[triplet[1]])
  else:
    translation = TENS[triplet[1]]
    if triplet[2]:
      translation += '-' if triplet[1] > 1 else ''
      translation += ONES[triplet[2]]
    tokens.append(translation)
  return ' '.join(tokens)

def translate_number(number):
  assert type(number) == int and number > MIN_VALUE and number < MAX_VALUE
  char_repr = char_representation(number)
  triplets = []
  num_triplets = len(char_repr) / 3
  for i in xrange(num_triplets):
    triplets.append(translate_triplet(char_repr[3 * i:3 * (i + 1)]) + ' ' + MAGNITUDES[num_triplets - i - 1])
  return ', '.join(triplets)

def char_representation(number):
  char_list = map(int, list(str(number)))
  remainder = len(char_list) % 3
  zeroes = []
  if remainder:
    zeroes = [0] * (3 - remainder)
  zeroes.extend(char_list)
  return zeroes


if __name__ == "__main__":
  assert len(sys.argv) == 2
  print translate_number(int(sys.argv[1]))
