# PR: issue2_dedupe
**Branch:** fix/issue2_dedupe
**Verdict:** PASS

```diff
diff --git a/issue2_dedupe.py b/issue2_dedupe.py
index 770740f..eea094e 100644
--- a/issue2_dedupe.py
+++ b/issue2_dedupe.py
@@ -1,2 +1,8 @@
 def dedupe_preserve_order(items):
-    return list(set(items))
+    seen = set()
+    result = []
+    for item in items:
+        if item not in seen:
+            seen.add(item)
+            result.append(item)
+    return result
```
