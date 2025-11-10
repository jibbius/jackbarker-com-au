#!/usr/bin/env python3
"""
Test script to validate draft behavior on Jekyll site
"""

import requests
from bs4 import BeautifulSoup
import sys
import re

def test_draft_protection():
    """Test that draft pages are properly protected"""
    base_url = "http://localhost:4000"
    
    print("🧪 Testing Draft Protection Behaviors")
    print("=" * 50)
    
    results = []
    
    # Test 1: Direct access to draft page should redirect or show 404
    print("\n1️⃣ Testing direct access to draft page...")
    try:
        response = requests.get(f"{base_url}/portfolio/RoyalMelbournePhilharmonic", 
                              allow_redirects=False, timeout=10)
        
        if response.status_code == 302 or response.status_code == 301:
            print("   ✅ PASS: Draft page redirects (status: {})".format(response.status_code))
            results.append("PASS")
        elif response.status_code == 404:
            print("   ✅ PASS: Draft page returns 404")
            results.append("PASS")
        else:
            # Check if page contains redirect script or meta refresh
            soup = BeautifulSoup(response.text, 'html.parser')
            has_redirect_script = soup.find('script', string=re.compile(r'window\.location\.replace'))
            has_meta_refresh = soup.find('meta', {'http-equiv': 'refresh'})
            
            if has_redirect_script or has_meta_refresh:
                print("   ✅ PASS: Draft page has client-side redirect protection")
                results.append("PASS")
            else:
                print("   ❌ FAIL: Draft page is accessible (status: {})".format(response.status_code))
                results.append("FAIL")
                
    except requests.RequestException as e:
        print(f"   ❌ ERROR: Could not test draft page - {e}")
        results.append("ERROR")
    
    # Test 2: Check that draft pages have proper SEO meta tags
    print("\n2️⃣ Testing SEO protection for draft pages...")
    try:
        response = requests.get(f"{base_url}/portfolio/RoyalMelbournePhilharmonic", timeout=10)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Look for noindex meta tags
        noindex_meta = soup.find('meta', {'name': 'robots', 'content': re.compile(r'noindex')})
        googlebot_meta = soup.find('meta', {'name': 'googlebot', 'content': re.compile(r'noindex')})
        
        if noindex_meta and googlebot_meta:
            print("   ✅ PASS: Draft page has proper SEO protection meta tags")
            results.append("PASS")
        else:
            print("   ❌ FAIL: Draft page missing SEO protection meta tags")
            results.append("FAIL")
            
    except requests.RequestException as e:
        print(f"   ❌ ERROR: Could not test SEO protection - {e}")
        results.append("ERROR")
    
    # Test 3: Check that drafts don't appear in project listings
    print("\n3️⃣ Testing draft exclusion from project listings...")
    try:
        # Test homepage
        response = requests.get(f"{base_url}/", timeout=10)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Look for links to RoyalMelbournePhilharmonic
        draft_links = soup.find_all('a', href=re.compile(r'/portfolio/RoyalMelbournePhilharmonic'))
        
        if len(draft_links) == 0:
            print("   ✅ PASS: Homepage doesn't link to draft projects")
            homepage_pass = True
        else:
            print(f"   ❌ FAIL: Homepage contains {len(draft_links)} links to draft project")
            homepage_pass = False
        
        # Test portfolio page
        response = requests.get(f"{base_url}/portfolio/", timeout=10)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        draft_links = soup.find_all('a', href=re.compile(r'/portfolio/RoyalMelbournePhilharmonic'))
        
        if len(draft_links) == 0:
            print("   ✅ PASS: Portfolio page doesn't link to draft projects")
            portfolio_pass = True
        else:
            print(f"   ❌ FAIL: Portfolio page contains {len(draft_links)} links to draft project")
            portfolio_pass = False
        
        if homepage_pass and portfolio_pass:
            results.append("PASS")
        else:
            results.append("FAIL")
            
    except requests.RequestException as e:
        print(f"   ❌ ERROR: Could not test project listings - {e}")
        results.append("ERROR")
    
    # Test 4: Check navigation links don't point to drafts and are properly sequential
    print("\n4️⃣ Testing portfolio navigation excludes drafts and sequences correctly...")
    try:
        # Test a known non-draft page to see if its navigation links to drafts
        response = requests.get(f"{base_url}/portfolio/RaspberryPi-PhotoBooth", timeout=10)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find navigation links
        nav_prev = soup.find('a', class_='nav-prev')
        nav_next = soup.find('a', class_='nav-next')
        
        # Check for draft links
        draft_nav_links = []
        if nav_prev and nav_prev.get('href') and 'RoyalMelbournePhilharmonic' in nav_prev.get('href'):
            draft_nav_links.append(nav_prev)
        if nav_next and nav_next.get('href') and 'RoyalMelbournePhilharmonic' in nav_next.get('href'):
            draft_nav_links.append(nav_next)
        
        if len(draft_nav_links) == 0:
            print("   ✅ PASS: Portfolio navigation doesn't link to draft projects")
            
            # Additional check: ensure prev and next are different (if both exist)
            if nav_prev and nav_next:
                prev_href = nav_prev.get('href', '')
                next_href = nav_next.get('href', '')
                
                if prev_href != next_href:
                    print("   ✅ PASS: Navigation links point to different projects")
                    results.append("PASS")
                else:
                    print(f"   ❌ FAIL: Both navigation links point to same project:")
                    print(f"      Previous: {prev_href}")
                    print(f"      Next: {next_href}")
                    results.append("FAIL")
            else:
                print("   ✅ PASS: Navigation has only one direction (expected for first/last item)")
                results.append("PASS")
        else:
            print(f"   ❌ FAIL: Portfolio navigation contains {len(draft_nav_links)} links to draft project")
            results.append("FAIL")
            
    except requests.RequestException as e:
        print(f"   ❌ ERROR: Could not test navigation links - {e}")
        results.append("ERROR")
    
    # Summary
    print("\n📊 Test Summary")
    print("=" * 30)
    
    pass_count = results.count("PASS")
    fail_count = results.count("FAIL")
    error_count = results.count("ERROR")
    total_tests = len(results)
    
    print(f"✅ Passed: {pass_count}/{total_tests}")
    print(f"❌ Failed: {fail_count}/{total_tests}")
    print(f"⚠️  Errors: {error_count}/{total_tests}")
    
    if fail_count == 0 and error_count == 0:
        print("\n🎉 All tests passed! Draft protection is working correctly.")
        return True
    else:
        print("\n⚠️  Some tests failed. Please review the implementation.")
        return False

if __name__ == "__main__":
    print("Draft Behavior Test Suite")
    print("Make sure Jekyll is running on localhost:4000")
    print()
    
    success = test_draft_protection()
    sys.exit(0 if success else 1)