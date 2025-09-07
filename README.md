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

### Usage 

Viewing Tasks: The main screen displays all shared tasks with filtering options

Adding Tasks: Tap the + button to create a new task with title, description, assignee, and priority

Editing Tasks: Tap any task card to edit its details

Completing Tasks: Use the checkmark icon to mark tasks as complete

Deleting Tasks: Use the delete icon to remove tasks

Filtering: Use the filter chips to view Urgent, Important, or All tasks

### Task Properties 

Each task includes:

Title: Short description of the task

Description: Detailed information about the task

Assigned To: Options for "Me", "Partner", or "Both"

Priority: Levels include "Urgent", "Important", and "Normal"

Completion Status: Track whether tasks are done or pending


### Contributing 

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

## License

Distributed under the MIT License. See LICENSE for more information.

## Future Enhancements

User authentication and cloud synchronization

Due dates and reminders

Recurring tasks

Task categories and tags

Progress tracking and statistics

Dark mode support

Multi-language support

Push notifications