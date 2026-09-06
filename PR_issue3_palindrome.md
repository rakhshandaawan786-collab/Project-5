# PR: issue3_palindrome
**Branch:** fix/issue3_palindrome
**Verdict:** PASS

```diff
diff --git a/issue3_palindrome.py b/issue3_palindrome.py
index 92892de..e66b262 100644
--- a/issue3_palindrome.py
+++ b/issue3_palindrome.py
@@ -1,2 +1,3 @@
 def is_palindrome(s):
-    return s == s[::-1]
+    cleaned = "".join(ch.lower() for ch in s if ch.isalnum())
+    return cleaned == cleaned[::-1]
```
