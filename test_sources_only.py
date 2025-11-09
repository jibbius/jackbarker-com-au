#!/usr/bin/env python3
"""Test only source files (not generated _site directory)"""

import sys
sys.path.append('.')
from test_javascript_minification import JavaScriptMinificationTester

# Test only source files
tester = JavaScriptMinificationTester(".")
tester.site_root = tester.site_root

# Override find_html_files to exclude _site directory
def find_source_html_files():
    html_files = []
    search_dirs = ["_includes", "_layouts", "_pages"]
    
    for dir_name in search_dirs:
        dir_path = tester.site_root / dir_name
        if dir_path.exists():
            html_files.extend(dir_path.glob("**/*.html"))
            html_files.extend(dir_path.glob("**/*.md"))  # Include markdown files too
    
    return html_files

# Monkey patch the method
tester.find_html_files = find_source_html_files

success = tester.run_tests()
sys.exit(0 if success else 1)