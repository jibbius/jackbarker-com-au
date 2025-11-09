#!/usr/bin/env python3
"""
Automated test suite to catch JavaScript minification issues in Jekyll sites.

This script tests for:
1. Single-line comments (//) in JavaScript that could break when minified
2. JavaScript syntax errors
3. Function definition issues
4. HTML/JavaScript integration problems

Run with: python test_javascript_minification.py
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Dict
import argparse


class JavaScriptMinificationTester:
    def __init__(self, site_root: str = "."):
        self.site_root = Path(site_root)
        self.errors = []
        self.warnings = []
        
    def find_html_files(self) -> List[Path]:
        """Find all HTML files in the Jekyll site."""
        html_files = []
        
        # Common Jekyll directories to search
        search_dirs = [
            "_includes",
            "_layouts", 
            "_pages",
            ".", # root level
        ]
        
        # Directories to exclude from scanning (vendor dependencies, build artifacts, etc.)
        exclude_dirs = {"vendor", "_site", "node_modules", ".git", ".bundle"}
        
        for dir_name in search_dirs:
            dir_path = self.site_root / dir_name
            if dir_path.exists():
                if dir_name == ".":
                    # For root directory, scan files but exclude problematic subdirectories
                    for html_file in dir_path.glob("*.html"):
                        html_files.append(html_file)
                else:
                    # For other directories, scan recursively but check for excluded paths
                    for html_file in dir_path.glob("**/*.html"):
                        # Check if any part of the path contains excluded directories
                        if not any(excluded in str(html_file) for excluded in exclude_dirs):
                            html_files.append(html_file)
                
        return html_files
    
    def extract_javascript_blocks(self, file_path: Path) -> List[Tuple[str, int, int]]:
        """Extract JavaScript code blocks from HTML files."""
        js_blocks = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Find all <script> blocks with JavaScript content
            script_pattern = r'<script[^>]*>(.*?)</script>'
            matches = re.finditer(script_pattern, content, re.DOTALL | re.IGNORECASE)
            
            for match in matches:
                js_content = match.group(1).strip()
                
                # Skip empty scripts or external scripts
                if not js_content or js_content.startswith('http'):
                    continue
                    
                # Calculate line numbers
                start_pos = match.start(1)
                lines_before = content[:start_pos].count('\n')
                lines_in_js = js_content.count('\n')
                
                js_blocks.append((js_content, lines_before + 1, lines_before + lines_in_js + 1))
                
        except Exception as e:
            self.errors.append(f"Error reading {file_path}: {e}")
            
        return js_blocks
    
    def check_single_line_comments(self, file_path: Path, js_content: str, start_line: int) -> List[str]:
        """Check for problematic single-line comments."""
        issues = []
        lines = js_content.split('\n')
        
        for i, line in enumerate(lines):
            line_stripped = line.strip()
            
            # Check for single-line comments
            if '//' in line:
                # Allow URLs (http:// https://)
                if re.search(r'https?://', line):
                    continue
                    
                # Check for actual JavaScript comments
                comment_match = re.search(r'(?:^|\s)//(.*)$', line)
                if comment_match:
                    actual_line = start_line + i
                    issues.append(
                        f"{file_path}:{actual_line} - Single-line comment found: '//{comment_match.group(1).strip()}'"
                    )
                    
        return issues
    
    def check_function_definitions(self, file_path: Path, js_content: str, start_line: int) -> List[str]:
        """Check for potential function definition timing issues."""
        issues = []
        
        # Look for function calls in onclick handlers that might be undefined
        onclick_pattern = r'onclick\s*=\s*["\']([^"\']*)["\']'
        function_calls = re.findall(onclick_pattern, js_content)
        
        # Extract function names from calls
        called_functions = set()
        for call in function_calls:
            # Extract function name (e.g., "changeSlide(1)" -> "changeSlide")
            func_match = re.search(r'(\w+)\s*\(', call)
            if func_match:
                called_functions.add(func_match.group(1))
        
        # Check if functions are defined
        for func_name in called_functions:
            # Look for function definitions
            patterns = [
                rf'function\s+{func_name}\s*\(',  # function declaration
                rf'{func_name}\s*=\s*function',   # function expression
                rf'window\.{func_name}\s*=',      # window property
                rf'var\s+{func_name}\s*=.*function', # var with function
            ]
            
            found = False
            for pattern in patterns:
                if re.search(pattern, js_content, re.IGNORECASE):
                    found = True
                    break
                    
            if not found:
                issues.append(
                    f"{file_path}:{start_line} - Function '{func_name}' called in onclick but not defined in this script block"
                )
                
        return issues
    
    def simulate_minification(self, js_content: str) -> str:
        """Simulate basic minification by removing newlines."""
        # This is a simplified simulation of what GitHub Pages might do
        minified = re.sub(r'\n\s*', ' ', js_content)
        return minified
    
    def check_minified_syntax(self, file_path: Path, js_content: str, start_line: int) -> List[str]:
        """Check if JavaScript would still be valid when minified."""
        issues = []
        
        try:
            minified = self.simulate_minification(js_content)
            
            # Check for common minification problems
            
            # 1. Single-line comments that would break minified code
            if '//' in minified and not re.search(r'https?://', minified):
                # Check if there's code after the comment on the same logical line
                comment_pos = minified.find('//')
                after_comment = minified[comment_pos + 2:].strip()
                if after_comment and not after_comment.startswith('*/'):
                    issues.append(
                        f"{file_path}:{start_line} - Single-line comment would break minified code"
                    )
            
            # 2. Missing semicolons that could cause issues when minified
            lines = js_content.split('\n')
            for i, line in enumerate(lines):
                line_stripped = line.strip()
                
                # Skip empty lines, control structures, and comments
                if (not line_stripped or 
                    line_stripped.startswith(('if', 'for', 'while', 'function', 'var', 'let', 'const')) or
                    line_stripped.startswith(('//', '/*', '*', '}', '{'))):
                    continue
                
                # Remove inline comments to check the actual code
                code_part = line_stripped
                # Remove block comments /* ... */
                code_part = re.sub(r'/\*.*?\*/', '', code_part).strip()
                # Remove single-line comments (shouldn't exist now, but just in case)
                code_part = re.sub(r'//.*$', '', code_part).strip()
                
                # Check if this looks like a statement that should end with semicolon
                if (code_part and 
                    not code_part.endswith((';', '{', '}', ')', ',', ':')) and
                    re.search(r'\w+\s*=|\w+\(|\w+\+\+|\w+--|return\s+\w+', code_part)):
                    
                    # This might be a statement that needs a semicolon
                    actual_line = start_line + i
                    issues.append(
                        f"{file_path}:{actual_line} - Potentially missing semicolon: '{code_part}' (original: '{line_stripped}')"
                    )
                        
        except Exception as e:
            issues.append(f"{file_path}:{start_line} - Error simulating minification: {e}")
            
        return issues
    
    def run_tests(self) -> bool:
        """Run all tests and return True if no critical issues found."""
        print("🔍 Scanning for JavaScript minification issues...")
        print(f"📁 Site root: {self.site_root.absolute()}")
        
        html_files = self.find_html_files()
        print(f"📄 Found {len(html_files)} HTML files to check")
        
        total_js_blocks = 0
        
        for file_path in html_files:
            relative_path = file_path.relative_to(self.site_root)
            js_blocks = self.extract_javascript_blocks(file_path)
            
            if js_blocks:
                print(f"🔧 Checking {relative_path} ({len(js_blocks)} JS blocks)")
                total_js_blocks += len(js_blocks)
                
                for js_content, start_line, end_line in js_blocks:
                    # Run all checks
                    issues = []
                    issues.extend(self.check_single_line_comments(relative_path, js_content, start_line))
                    issues.extend(self.check_function_definitions(relative_path, js_content, start_line))
                    issues.extend(self.check_minified_syntax(relative_path, js_content, start_line))
                    
                    # Categorize issues
                    for issue in issues:
                        if "Single-line comment" in issue:
                            self.errors.append(f"❌ CRITICAL: {issue}")
                        elif "not defined" in issue:
                            self.warnings.append(f"⚠️  WARNING: {issue}")
                        else:
                            self.warnings.append(f"ℹ️  INFO: {issue}")
        
        print(f"\n📊 Scanned {total_js_blocks} JavaScript blocks")
        
        # Report results
        if self.errors:
            print(f"\n💥 CRITICAL ISSUES ({len(self.errors)}):")
            for error in self.errors:
                print(f"  {error}")
        
        if self.warnings:
            print(f"\n⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"  {warning}")
        
        if not self.errors and not self.warnings:
            print("\n✅ No JavaScript minification issues found!")
        elif not self.errors:
            print(f"\n✅ No critical issues found (but {len(self.warnings)} warnings)")
        
        return len(self.errors) == 0
    
    def generate_report(self, output_file: str = "js_minification_report.md"):
        """Generate a detailed markdown report."""
        with open(output_file, 'w') as f:
            f.write("# JavaScript Minification Test Report\n\n")
            f.write(f"Generated: {Path.cwd()}\n")
            f.write(f"Total errors: {len(self.errors)}\n")
            f.write(f"Total warnings: {len(self.warnings)}\n\n")
            
            if self.errors:
                f.write("## Critical Issues\n\n")
                for error in self.errors:
                    f.write(f"- {error}\n")
                f.write("\n")
            
            if self.warnings:
                f.write("## Warnings\n\n")
                for warning in self.warnings:
                    f.write(f"- {warning}\n")
                f.write("\n")
            
            f.write("## Recommendations\n\n")
            f.write("1. Replace all `//` single-line comments with `/* */` block comments\n")
            f.write("2. Ensure all functions are defined before they are called\n")
            f.write("3. Add proper semicolons to statement endings\n")
            f.write("4. Test minified JavaScript in browser console\n")


def main():
    parser = argparse.ArgumentParser(description='Test Jekyll site for JavaScript minification issues')
    parser.add_argument('--site-root', default='.', help='Root directory of Jekyll site')
    parser.add_argument('--report', help='Generate detailed report to file')
    parser.add_argument('--ci', action='store_true', help='Exit with non-zero code if issues found (for CI)')
    parser.add_argument('--build-with-drafts', action='store_true', help='Rebuild site with drafts before testing')
    parser.add_argument('--source-only', action='store_true', help='Test only source files (excludes _site directory)')
    
    args = parser.parse_args()
    
    # Build site if requested
    if args.build_with_drafts:
        print("🔨 Building Jekyll site with drafts...")
        import subprocess
        try:
            result = subprocess.run(['bundle', 'exec', 'jekyll', 'build', '-D'], 
                                  cwd=args.site_root, capture_output=True, text=True)
            if result.returncode != 0:
                print(f"❌ Jekyll build failed: {result.stderr}")
                sys.exit(1)
            print("✅ Jekyll build completed")
        except FileNotFoundError:
            print("❌ Jekyll not found. Please ensure Jekyll is installed.")
            sys.exit(1)
    
    tester = JavaScriptMinificationTester(args.site_root)
    
    # Override file finder if source-only
    if args.source_only:
        def find_source_files():
            html_files = []
            search_dirs = ["_includes", "_layouts", "_pages"]
            exclude_dirs = {"vendor", "_site", "node_modules", ".git", ".bundle"}
            
            for dir_name in search_dirs:
                dir_path = tester.site_root / dir_name
                if dir_path.exists():
                    for html_file in dir_path.glob("**/*.html"):
                        if not any(excluded in str(html_file) for excluded in exclude_dirs):
                            html_files.append(html_file)
                    for md_file in dir_path.glob("**/*.md"):
                        if not any(excluded in str(md_file) for excluded in exclude_dirs):
                            html_files.append(md_file)
            return html_files
        
        tester.find_html_files = find_source_files
        print("📋 Testing source files only (excluding _site directory)")
    
    success = tester.run_tests()
    
    if args.report:
        tester.generate_report(args.report)
        print(f"\n📝 Detailed report saved to: {args.report}")
    
    if args.ci and not success:
        sys.exit(1)
    elif args.ci:
        print("\n🎉 All tests passed - safe for deployment!")
    
    return success


if __name__ == "__main__":
    main()