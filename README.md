# 👾 Monster Battle API ⚔️

Welcome to the **Monster Battle API**! This is a personal passion project aimed at creating a robust and well-structured backend system for simulating battles between monsters. 🐲🔥💧

## 🎯 About The Project

The `Monster Battle API` is a backend application built with **Ruby** 💎, designed to manage the logic and rules for confrontations between monsters. The core idea is to provide a solid foundation that can be expanded for various types of games or applications requiring a combat system.

This project is not just about creating monsters and making them fight; it's also an exercise in applying and practicing key software development concepts.

## ✨ Core Principles & Architecture

During the development of this API, a strong emphasis was placed on code quality and maintainability. To achieve this, the following principles and practices were adopted:

* **SOLID**: The five principles of object-oriented design served as a compass for structuring classes and modules, aiming to create code that is:
    * **S**ingle Responsibility Principle
    * **O**pen/Closed Principle
    * **L**iskov Substitution Principle
    * **I**nterface Segregation Principle
    * **D**ependency Inversion Principle
* **Clean Code**: Continuous efforts were made to write code that is clean, readable, and understandable. This includes meaningful names for variables and methods, small and focused functions, and a logical organization of the codebase.
* **Organization**: The project structure aims for a clear separation of concerns, making it easier to navigate and evolve the system.

## 🛠️ Tech Stack

* **Main Language**: Ruby 💎

## 🚀 Features

* Creation and management of monsters with customizable attributes (health, attack, defense, etc.).
* Turn-based battle system.
* Damage calculation based on attributes and combat mechanics.

## ⚙️ Getting Started

To get a local copy up and running, follow these simple example steps.

### Prerequisites

* Ruby (version 3.3.0)
* Rails (version 7.1.5)

### Installation

1.  **Clone the repo**:
    ```bash
    git clone [https://github.com/your-username/monster_battle_api.git](https://github.com/your-username/monster_battle_api.git)
    cd monster_battle_api
    ```
2.  **Install dependencies**:
    ```bash
    bundle install
    ```
3.  **Database Setup**:
    ```bash
    rails db:create db:migrate db:seed
    ```
4.  **Running the Application**:
    ```bash
    rails server
    ```

## 🧪 Running Tests (Example Structure)
```bash
bundle exec rspec
