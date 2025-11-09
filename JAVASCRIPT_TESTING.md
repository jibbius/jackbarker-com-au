# JavaScript Minification Testing

This directory contains automated tests to prevent JavaScript minification issues that can break your Jekyll site when deployed to GitHub Pages.

## The Problem

GitHub Pages minifies JavaScript by removing newlines, which can cause issues with:
- Single-line comments (`//`) that comment out the rest of the minified line
- Function definitions that aren't available when called
- Missing semicolons that cause syntax errors when minified

## The Solution

### Automated Testing

We've created comprehensive tests that check for these issues:

1. **`test_javascript_minification.py`** - Main test script
2. **`test_js.sh`** - Simple shell wrapper
3. **`.github/workflows/js-minification-tests.yml`** - GitHub Actions integration
4. **`pre-commit-hook.sh`** - Git pre-commit hook

### Running Tests

#### Local Testing

```bash
# Quick test of source files only (fastest)
./test_js.sh source

# Test including draft posts (builds site first)
./test_js.sh drafts  

# Full production test (builds with drafts + exits on errors)
./test_js.sh full

# Advanced usage
python3 test_javascript_minification.py --source-only          # Source files only
python3 test_javascript_minification.py --build-with-drafts    # Build + test with drafts
python3 test_javascript_minification.py --report detailed.md   # Generate report
python3 test_javascript_minification.py --ci                   # CI mode (exit codes)
```

#### Testing Strategy

The test system supports different scenarios:

1. **Source-only testing** (`--source-only`)
   - Fast check of `_includes`, `_layouts`, `_pages` files
   - Good for development and pre-commit hooks
   - Doesn't require Jekyll build

2. **Draft-inclusive testing** (`--build-with-drafts`)  
   - Builds site with `jekyll build -D` first
   - Tests all content including draft posts
   - Essential for comprehensive testing since GitHub Pages excludes drafts by default

3. **Production testing** (CI mode)
   - Combines draft build with strict error checking
   - Perfect for GitHub Actions and deployment gates

#### Setting Up Pre-commit Hook

```bash
# Install the pre-commit hook
cp pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Now tests run automatically before each commit
git commit -m "Your changes"  # Tests run automatically
```

#### GitHub Actions Integration

The workflow automatically runs on:
- Pushes to `gh-pages`, `main`, or `master` branches
- Pull requests to these branches
- Manual trigger from GitHub Actions tab

### What the Tests Check

1. **Single-line Comments (`//`)**
   - ❌ `// This will break minified code`
   - ✅ `/* This works when minified */`

2. **Function Definitions**
   - Ensures functions called in `onclick` handlers are defined
   - Checks for proper function declaration timing

3. **Syntax Issues**
   - Missing semicolons that could cause minification problems
   - Other common minification pitfalls

### Example Test Output

```
🔍 Scanning for JavaScript minification issues...
📁 Site root: /home/jack/jackbarker-com-au
📄 Found 15 HTML files to check
🔧 Checking _includes/portfolio-slideshow.html (1 JS blocks)

💥 CRITICAL ISSUES (2):
  ❌ CRITICAL: _includes/portfolio-slideshow.html:147 - Single-line comment found: '// Define functions immediately'
  ❌ CRITICAL: _includes/portfolio-slideshow.html:195 - Single-line comment found: '// Update progress bar'

⚠️  WARNINGS (1):
  ⚠️  WARNING: _includes/portfolio-slideshow.html:146 - Function 'changeSlide' called in onclick but not defined in this script block

📊 Scanned 3 JavaScript blocks
```

### Quick Fix Guidelines

1. **Replace single-line comments:**
   ```javascript
   // Bad - will break when minified
   function myFunction() {
       // This comment breaks minification
       return true;
   }
   
   /* Good - works when minified */
   function myFunction() {
       /* This comment works fine */
       return true;
   }
   ```

2. **Ensure function definitions come first:**
   ```javascript
   /* Bad - function called before definition */
   onclick="myFunction()"
   // ... later in script ...
   function myFunction() { }
   
   /* Good - function defined immediately */
   function myFunction() { }
   // ... can now use onclick="myFunction()" safely
   ```

3. **Add semicolons:**
   ```javascript
   // Bad - might break when minified
   var x = 5
   var y = 10
   
   // Good - explicit statement endings
   var x = 5;
   var y = 10;
   ```

### Integration with CI/CD

The tests integrate with your development workflow:

- **Local development**: Run `./test_js.sh` before committing
- **Pre-commit**: Automatically blocks commits with issues
- **GitHub Actions**: Tests run on every push/PR
- **Deployment**: Only clean code gets deployed to GitHub Pages

### Continuous Monitoring

Set up notifications to catch issues early:

1. GitHub Actions will fail if issues are found
2. Pull requests get automatic comments with test results
3. Test reports are saved as build artifacts
4. Email notifications for failed builds (configure in GitHub settings)

This comprehensive testing approach ensures your JavaScript will work correctly when GitHub Pages minifies it for production deployment.