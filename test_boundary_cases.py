#!/usr/bin/env python3
"""
Test navigation boundary cases
"""

import requests
from bs4 import BeautifulSoup

def test_boundary_cases():
    """Test first and last items in sequence"""
    base_url = "http://localhost:4000"
    
    print("🔄 Testing Navigation Boundary Cases")
    print("=" * 50)
    
    # Test first item (should only have next)
    print("\n📍 Testing Python Tic-Tac-Toe (first item)...")
    response = requests.get(f"{base_url}/portfolio/Python-TicTacToe", timeout=10)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    nav_prev = soup.find('a', class_='nav-prev')
    nav_next = soup.find('a', class_='nav-next')
    
    print(f"   Previous link: {nav_prev.get('href') if nav_prev else 'None (Expected)'}")
    print(f"   Next link: {nav_next.get('href') if nav_next else 'None'}")
    
    if not nav_prev and nav_next and "RaspberryPi-PhotoBooth" in nav_next.get('href', ''):
        print("   ✅ First item navigation correct")
        first_ok = True
    else:
        print("   ❌ First item navigation incorrect")
        first_ok = False
    
    # Test last item (should only have previous)
    print("\n📍 Testing WhereTheTruckAt (last item)...")
    response = requests.get(f"{base_url}/portfolio/WhereTheTruckAt", timeout=10)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    nav_prev = soup.find('a', class_='nav-prev')
    nav_next = soup.find('a', class_='nav-next')
    
    print(f"   Previous link: {nav_prev.get('href') if nav_prev else 'None'}")
    print(f"   Next link: {nav_next.get('href') if nav_next else 'None (Expected)'}")
    
    if nav_prev and "RaspberryPi-PhotoBooth" in nav_prev.get('href', '') and not nav_next:
        print("   ✅ Last item navigation correct")
        last_ok = True
    else:
        print("   ❌ Last item navigation incorrect")
        last_ok = False
    
    return first_ok and last_ok

if __name__ == "__main__":
    success = test_boundary_cases()
    
    if success:
        print("\n🎉 All boundary cases working correctly!")
    else:
        print("\n⚠️ Some boundary cases have issues.")
    
    exit(0 if success else 1)