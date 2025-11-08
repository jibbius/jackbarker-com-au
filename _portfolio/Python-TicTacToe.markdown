---
layout: portfolio-item
title: Tic-Tac-Toe with Python, Flask, & AI
desc: "Advanced Python implementation featuring Flask web interface, SQLAlchemy persistence, and AI opponents using the Strategy Pattern"
rank: 2
tags:
  - Python
  - Flask
  - SQLAlchemy
  - Strategy Pattern
  - AI
  - REST API
  - Object Oriented
img: /portfolio/python-tictactoe
img-ext: .png
---

# Tic-Tac-Toe with Python, Flask, & AI

This is an advanced Python implementation of Tic-Tac-Toe that goes far beyond the traditional console game. Built as the capstone project for General Assembly's Python Programming course, this application demonstrates sophisticated software engineering principles and modern web development practices.

{% include image-2.html
    img="/portfolio/flask-tic-tac-toe"
    alt="UI"
    caption="Modern, responsive web interface showing game board, player management, and real-time gameplay."
%}

## 🎮 **Try It Live!**

Experience the full-featured web application with AI opponents and persistent gameplay:

**[🚀 Play Tic-Tac-Toe Now →][play-now-link]{:class="play-button"}**

## 🎯 **Project Objectives**

This project was designed to showcase several key competencies:

- **Flask Web Framework**: Building a full-featured web application with routing, templates, and API endpoints
- **Data Persistence**: Implementing a robust database layer using SQLAlchemy ORM with SQLite
- **Design Patterns**: Demonstrating the Strategy Pattern through different AI opponent difficulties
- **API Development**: Creating a comprehensive REST API with JSON responses
- **Full-Stack Development**: Integrating backend logic with interactive frontend interfaces

## **Key Features**

### **Web Application**

- **Modern Web UI**: Clean, responsive interface for all game functions
- **Player Management**: Create and manage human and computer players
- **Game Creation**: Set up new games with custom player assignments
- **Real-time Gameplay**: Interactive moves for both human and AI players
- **Game State Tracking**: Visual representation of current game status and winner determination

### **AI Implementation**

- **Multiple Difficulty Levels**: Different computer opponent strategies using the Strategy Pattern
- **Intelligent Moves**: AI players make strategic decisions based on game state
- **Scalable Architecture**: Easy to add new AI strategies without modifying core game logic

### **Data Management**

- **SQLAlchemy ORM**: Robust object-relational mapping for game data
- **SQLite Database**: Persistent storage for players, games, and move history
- **CSV Import**: Ability to seed initial player database from CSV files
- **Data Integrity**: Proper relationships and constraints between game entities

### **API & Integration**

- **Complete REST API**: Full JSON API for programmatic access to all game functions
- **API Testing Interface**: HTML + JavaScript forms for testing API endpoints
- **Flexible Integration**: API designed for potential mobile app or third-party integrations

## 🏗️ **Technical Architecture**

### **Design Patterns**

The project showcases the **Strategy Pattern** implementation for AI opponents:

- **Abstract Strategy**: Base computer player interface
- **Concrete Strategies**: Different difficulty levels (Easy, Medium, Hard)
- **Context**: Game engine that uses strategies interchangeably
- **Flexibility**: New AI strategies can be added without modifying existing code

### **Technology Stack**

- **Backend**: Python with Flask web framework
- **Database**: SQLAlchemy ORM with SQLite database
- **Frontend**: HTML5, CSS3, and JavaScript
- **API**: RESTful JSON endpoints
- **Architecture**: Model-View-Controller (MVC) pattern

## 💡 **Learning Outcomes**

This project demonstrates proficiency in:

- **Object-Oriented Programming**: Abstraction, encapsulation, inheritance, and polymorphism
- **Web Development**: Flask routing, templating, and request handling
- **Database Design**: Entity relationships, ORM usage, and data persistence
- **API Development**: RESTful design principles and JSON responses
- **Software Architecture**: Design patterns and separation of concerns
- **Testing & Debugging**: API testing interfaces and error handling

## 🎮 **Game Features**

- **Player Types**: Support for both human and computer-controlled players
- **Game Management**: Create, assign players, and track multiple concurrent games
- **Move Validation**: Intelligent move validation and game state management
- **Winner Detection**: Automatic winner determination and game completion
- **Game History**: Persistent storage of all games and moves for analysis

This project represents a comprehensive exploration of Python web development, combining algorithmic thinking (AI strategies), database management, web technologies, and software design patterns into a cohesive, production-quality application.

---

## 🔗 **Project Links**

**[🎮 Play Live Demo][play-now-link]** | **[💻 View Source Code][repo-link]**

[play-now-link]: https://jibbius.pythonanywhere.com/
[repo-link]: https://github.com/Jibbius/flask-tic-tac-toe
