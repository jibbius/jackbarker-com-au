#!/bin/bash

# JavaScript Minification Test Script for Jekyll Sites
# This script tests for JavaScript issues that could break when minified by GitHub Pages

echo "🚀 JavaScript Minification Test Suite"
echo "=================================="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

# Parse arguments for common usage patterns
case "$1" in
    "source")
        echo "📋 Testing source files only..."
        python3 test_javascript_minification.py --source-only "${@:2}"
        ;;
    "drafts")
        echo "📝 Testing with drafts included..."
        python3 test_javascript_minification.py --build-with-drafts "${@:2}"
        ;;
    "full")
        echo "🔍 Full test: building with drafts then testing..."
        python3 test_javascript_minification.py --build-with-drafts --ci "${@:2}"
        ;;
    "--help"|"-h")
        echo ""
        echo "Usage:"
        echo "  ./test_js.sh source    - Test only source files (_includes, _layouts, _pages)"
        echo "  ./test_js.sh drafts    - Build site with drafts and test everything"  
        echo "  ./test_js.sh full      - Full CI test (build with drafts + exit on errors)"
        echo "  ./test_js.sh [args]    - Pass arguments directly to test script"
        echo ""
        echo "Examples:"
        echo "  ./test_js.sh source           # Quick source-only check"
        echo "  ./test_js.sh drafts           # Include draft posts"
        echo "  ./test_js.sh full             # Production-ready test"
        echo "  ./test_js.sh --report out.md  # Generate detailed report"
        echo ""
        python3 test_javascript_minification.py --help
        exit 0
        ;;
    *)
        # Default: pass all arguments to the Python script
        python3 test_javascript_minification.py "$@"
        ;;
esac

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Tests completed successfully"
else
    echo ""
    echo "❌ Tests failed - please fix the issues above"
    exit 1
fi