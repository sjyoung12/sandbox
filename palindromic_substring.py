import sys

class Solution(object):
    def isPalindromicSubstring(self, fullString, left, right):
        leftIndex = left
        rightIndex = right
        while leftIndex < rightIndex:
            if fullString[leftIndex] != fullString[rightIndex]:
                return False
            leftIndex += 1
            rightIndex -= 1
        return True
    
    def longestPalindrome(self, s):
        """
        :type s: str
        :rtype: str
        """
        candidates = set()
        for i in xrange(len(s)):
            for j in xrange(len(s) - i):
                if self.isPalindromicSubstring(s, i, len(s) - j - 1):
                    candidates.add(s[i:len(s) - j])
                    break
        return max(candidates, key=lambda c: len(c))

if __name__ == "__main__":
    assert len(sys.argv) == 2
    print Solution().longestPalindrome(sys.argv[1])