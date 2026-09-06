import unittest
from issue2_dedupe import dedupe_preserve_order

class Test(unittest.TestCase):
    def test_order_preserved(self):
        self.assertEqual(dedupe_preserve_order([3, 1, 2, 1, 3]), [3, 1, 2])
    def test_strings(self):
        self.assertEqual(dedupe_preserve_order(["b", "a", "b", "c"]), ["b", "a", "c"])

if __name__ == "__main__":
    unittest.main()
