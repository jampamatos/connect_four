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

## Usage Instructions

To play the game, follow these steps:

1. Clone the repository or download the files.
2. In a terminal, navigate to the directory where you saved the files.
3. Run the command ruby play.rb.
4. Follow the prompts to play the game.

Alternatively, you can play the game online with a live preview on [Replit](https://replit.com/@jampamatps/Connect-Four?v=1).

Enjoy the game!

## Test Instructions

This project includes automated tests to verify correct behavior of the code. The tests use the RSpec testing framework.

To run the tests, ensure that you have RSpec installed:

```bash
$ gem install rspec
```

Then, navigate to the project root directory and run:

```bash
$ rspec
```

This will run all the tests in the `spec/` directory and output the results to the console. All tests should pass without error. If any tests fail, review the error message to determine the cause of the failure.

Note that the tests depend on the behavior of the code as it exists at the time the tests were written. If changes are made to the code, it is important to verify that the tests still pass to ensure that the changes did not introduce any regressions.

## Project Status

The basic functionality for this Connect Four game has been implemented, and all the acceptance tests pass. However, there is still room for improvement and additional features that can be added. For instance, the following could be considered for future development:

* Implementing an AI player so that the game can be played solo.
* Adding a game lobby, where players can join or create games and play with other players online.
* Implementing a feature to allow users to customize the board size.
* Implementing a feature to allow users to undo their last move.

If you encounter any issues or have suggestions for improvement, please open an issue on this repository.

## Future Improvements

Here are some potential future improvements that could be made to the project:

* **Implement an AI opponent:** Currently, the game only supports two human players. Adding an AI opponent would allow for single player games and could be a fun challenge to implement.
* **Add support for different board sizes:** While the classic Connect Four game is played on a 6x7 board, it would be interesting to add support for custom board sizes. This could allow for more varied gameplay and could be a good challenge to implement.
* **Improve the user interface:** While the game is functional, the user interface could be improved to make the game more visually appealing and easier to use. For example, a more polished UI could include better graphics, more intuitive controls, and support for different screen sizes.
* **Add chip falling animation:** Animating the chips falling into the board would add a nice touch of interactivity and make the game more engaging for the players.
* **Add a Reset function:** Adding a reset function would allow players to start a new game without having to close and reopen the program, improving the user experience.

These are just a few ideas for future improvements, and there are many other features that could be added to the game.

## Acknowledgments

I would like to thank The Odin Project for providing the project requirements and inspiration for this game. We would also like to thank the following resources for their help in creating this project:

* The Ruby Programming Language book by Yukihiro Matsumoto
* The Ruby Style Guide by Bozhidar Batsov
* Ruby-Doc.org for the Ruby documentation
* Stack Overflow and OpenAI for providing helpful answers to our coding questions
* GitHub for providing a platform to host our code and collaborate with others

We are grateful to have had access to these resources throughout the development process, and we hope that this game and its accompanying documentation can serve as a helpful resource for other beginner developers.

## Author

This project was developed by [Jampa Matos](mailto:jp.coutm@gmail.com) as part of the curriculum for The Odin Project's Ruby Programming course.

* GitHub: [jampamatos](https://github.com/jampamatos)
* Twitter: [@jumpamatos](https://twitter.com/jumpamatos)
* Linkedin: [@jampamatos](https://www.linkedin.com/in/jampamatos/)