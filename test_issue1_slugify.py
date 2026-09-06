import unittest
from issue1_slugify import slugify

class Test(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(slugify("Hello World"), "hello-world")
    def test_multiple_spaces(self):
        self.assertEqual(slugify("Hello    World"), "hello-world")
    def test_special_chars(self):
        self.assertEqual(slugify("Hello, World!"), "hello-world")

if __name__ == "__main__":
    unittest.main()
