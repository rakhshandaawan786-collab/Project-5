# PR: issue1_slugify
**Branch:** fix/issue1_slugify
**Verdict:** PASS

```diff
diff --git a/issue1_slugify.py b/issue1_slugify.py
index de51145..597ff66 100644
--- a/issue1_slugify.py
+++ b/issue1_slugify.py
@@ -1,4 +1,6 @@
+import re
+
 def slugify(text):
     text = text.lower().strip()
-    text = text.replace(" ", "-")
-    return text
+    text = re.sub(r"[^a-z0-9]+", "-", text)
+    return text.strip("-")
```
