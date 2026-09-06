import unittest
from issue3_palindrome import is_palindrome

class Test(unittest.TestCase):
    def test_with_spaces_and_case(self):
        self.assertTrue(is_palindrome("A man a plan a canal Panama"))
    def test_another(self):
        self.assertTrue(is_palindrome("Was it a car or a cat I saw"))
    def test_not_palindrome(self):
        self.assertFalse(is_palindrome("hello"))

if __name__ == "__main__":
    unittest.main()
