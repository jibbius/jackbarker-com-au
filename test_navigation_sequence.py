#!/usr/bin/env python3
"""
Test navigation sequence specifically
"""

import requests
from bs4 import BeautifulSoup

def test_navigation_sequence():
    """Test that navigation follows the correct sequence"""
    base_url = "http://localhost:4000"
    
    print("🔄 Testing Portfolio Navigation Sequence")
    print("=" * 50)
    
    # Expected sequence (non-drafts only): Python Tic-Tac-Toe → Raspberry Pi Photo Booth → WhereTheTruck.At
    
    print("\n📍 Testing Raspberry Pi Photo Booth (middle item)...")
    response = requests.get(f"{base_url}/portfolio/RaspberryPi-PhotoBooth", timeout=10)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    nav_prev = soup.find('a', class_='nav-prev')
    nav_next = soup.find('a', class_='nav-next')
    
    print(f"   Previous link: {nav_prev.get('href') if nav_prev else 'None'}")
    print(f"   Previous text: {nav_prev.get_text().strip() if nav_prev else 'None'}")
    print(f"   Next link: {nav_next.get('href') if nav_next else 'None'}")
    print(f"   Next text: {nav_next.get_text().strip() if nav_next else 'None'}")
    
    # Verify expected sequence
    expected_prev = "/portfolio/Python-TicTacToe"
    expected_next = "/portfolio/WhereTheTruckAt"
    
    success = True
    
    if nav_prev and expected_prev in nav_prev.get('href', ''):
        print("   ✅ Previous link correct: Python Tic-Tac-Toe")
    else:
        print(f"   ❌ Previous link incorrect. Expected: {expected_prev}")
        success = False
        
    if nav_next and expected_next in nav_next.get('href', ''):
        print("   ✅ Next link correct: WhereTheTruck.At")
    else:
        print(f"   ❌ Next link incorrect. Expected: {expected_next}")
        success = False
    
    if nav_prev and nav_next and nav_prev.get('href') == nav_next.get('href'):
        print("   ❌ CRITICAL: Both links point to the same place!")
        success = False
    
    return success

if __name__ == "__main__":
    print("Portfolio Navigation Sequence Test")
    print("Make sure Jekyll is running on localhost:4000")
    print()
    
    success = test_navigation_sequence()
    
    if success:
        print("\n🎉 Navigation sequence is working correctly!")
    else:
        print("\n⚠️ Navigation sequence has issues.")
    
    exit(0 if success else 1)