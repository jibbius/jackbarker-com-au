#!/bin/bash

# Pre-commit hook to check for JavaScript minification issues
# Install this hook by copying it to .git/hooks/pre-commit and making it executable

echo "🔍 Running JavaScript minification tests..."

# Run the test
if ! python3 test_javascript_minification.py --ci; then
    echo ""
    echo "❌ Pre-commit check failed!"
    echo "Please fix the JavaScript minification issues above before committing."
    echo ""
    echo "💡 Quick fixes:"
    echo "  - Replace // comments with /* */ comments"
    echo "  - Ensure functions are defined before being called"
    echo "  - Add missing semicolons"
    echo ""
    echo "Run './test_js.sh' for detailed analysis."
    exit 1
fi

echo "✅ JavaScript minification tests passed"