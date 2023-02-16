# Project: Connect Four Game in Ruby

[Connect Four](https://en.wikipedia.org/wiki/Connect_Four) is a classic two-player connection game in which players take turns dropping colored discs into a vertical grid. The first player to connect four discs of the same color vertically, horizontally, or diagonally wins the game.

This project implements the Connect Four game using Ruby programming language. It is a part of [The Odin Project's Ruby](https://www.theodinproject.com/lessons/ruby-connect-four) curriculum, which is designed to help you learn Ruby by building projects.

In this game, two players take turns dropping their colored discs into a 6x7 grid until one player connects four discs in a row or the grid is filled, resulting in a tie. The game can be played in the terminal or in a graphical interface.

In the following sections, you will find instructions on how to install and run the game, the rules of the game, and an overview of the code structure and design. Let's get started!

## Description of the project

**Connect Four** is a classic board game that has been enjoyed by players of all ages for decades. In this project, we implement the Connect Four game using Ruby. The game is played by two players, who take turns dropping colored discs into a vertical board. The objective of the game is to connect four discs of the same color vertically, horizontally, or diagonally.

The project consists of several classes that are responsible for different aspects of the game. The `Player` class represents a player, with attributes such as name, color, and number of wins. The `Board` class represents the game board, which is a grid of cells that can be empty or contain a disc of a certain color. The `GameManager` class is responsible for managing the game, including keeping track of the players, the board, the number of ties, and the current state of the game.

In addition to the core game classes, the project also includes several tests to ensure that the classes work as expected. The tests cover various scenarios and edge cases, such as checking if a player's wins are incremented correctly or if a game can be won diagonally.

Overall, this project provides an opportunity to practice object-oriented programming in Ruby, as well as to implement a classic game that many people have enjoyed over the years.

## Project Motivation and Goals

The main objective of this project is to gain experience with the following concepts in Ruby:

* Object-oriented programming
* Testing with RSpec
* Test-driven development (TDD)
* Serialization with JSON
* File I/O

Through building a Connect Four game, I was able to practice these concepts and develop our skills in Ruby. Additionally, this project allowed me to create a fun game that can played and enjoyed.

## Features

* Play a game of Connect Four in the terminal
* Play against another human player (*TO BE IMPLEMENTED*) or against a computer player
* Save and load game state to/from a file
* View the game state history
* Review game statistics, including player wins, ties, and games played

## Technologies used

This project was implemented using the following technologies:

* [Ruby](https://www.ruby-lang.org/en/) programming language
* [RSpec](https://rspec.info/) testing framework
* [JSON](https://www.json.org/json-en.html) data interchange format

The project was developed using Git for version control and hosted on GitHub.
