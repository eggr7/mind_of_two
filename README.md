# Mind of Two - Shared Task Manager

Mind of Two is a Flutter-based mobile application designed to help couples or partners manage shared tasks and responsibilities. It provides a simple and intuitive interface for creating, tracking, and organizing tasks to improve collaboration and productivity.

## Features

- **View Shared Tasks**: See a list of all tasks with their current status.
- **Add Tasks**: Quickly add new tasks to the shared list.
- **Edit Tasks**: Tap on a task to modify its details, such as title, description, assignee, and priority.
- **Mark as Complete**: Toggle the completion status of tasks with a single tap.
- **Delete Tasks**: Remove tasks that are no longer needed.
- **State Management**: Utilizes the `provider` package for efficient and centralized state management.

## Project Structure

The project is organized into the following directories under `lib/`:

-   `models/`: Contains the data models for the application, such as the `Task` model.
-   `providers/`: Holds the state management logic. The `TaskProvider` manages the state of the tasks.
-   `screens/`: Includes the different screens or pages of the application, like the main task list and the edit task screen.
-   `widgets/`: Contains reusable UI components used across different screens.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
-   A code editor like VS Code or Android Studio.

### Installation

1.  Clone the repo:
    ```sh
    git clone https://github.com/eggr7/mind_of_two.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd mind_of_two
    ```
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
