# Pollhub

**Pollhub** is a simple application for creating, managing, and participating in polls. Built with **Elixir** and **Phoenix LiveView**.

---

## **Features**
- **User Authentication**: Secure user registration and login using email and password, implemented via Phoenix's built-in auth generator.
- **Poll Management**: Create, edit, and delete polls through an interface.
- **Participation**: Users can view poll entries and cast votes.

---

## **Project Structure**

### **Live Views**
- `index.ex`
    - Displays all existing polls with options to create, edit, or delete a poll.

- `show.ex`
    - Displays a specific poll's details. Allows users to view entries, participate in voting, and edit polls if needed.

### **Live Component**
- `form_component.ex`
    - A shared component used for creating or editing polls. It provides reusable form logic and rendering, shared between the `index.ex` and `show.ex` live views.

### **Rendering**
Each LiveView and component has its own `.heex` file responsible for rendering its HTML structure.

---

## **Database Schemas**

### **Schema Overview**
The project contains three custom schemas (excluding the generated user schema):

1. **Poll** (`poll.ex`)
    - Fields:
        - `name` (string): The poll's title.
        - `entries` (array): Associated entries for the poll.

2. **Entry** (`entry.ex`)
    - Fields:
        - `title` (string): Entry title.
        - `votes` (integer): Number of votes received.
        - `poll_id` (foreign key): Links to the associated poll.

3. **Participation** (`participation.ex`)
    - Fields:
        - `poll_id` (foreign key): ID of the poll.
        - `user_id` (foreign key): ID of the user who has participated.

### **Schema Diagram**

```plaintext
+------------------+        +----------------+        +----------------------+
|      Poll        |        |     Entry      |        |    Participation     |
+------------------+        +----------------+        +----------------------+
| id (PK)          |        | id (PK)        |        | id (PK)              |
| name             |        | title          |        | poll_id (FK)         |
| entries          |        | votes          |        | user_id (FK)         |
|                  |        | poll_id (FK)   |        |                      |
+------------------+        +----------------+        +----------------------+
```

## **Running the Application Locally**

Follow these steps to run Pollhub on your local machine:

1. **Ensure Docker is Running**
    - Install Docker if it’s not already installed on your system.
    - Start the Docker service.

2. **Clone and Navigate to the Project**
    - Clone the repository:
      ```bash
      git clone <repository-url>
      ```  
    - Navigate to the project directory:
      ```bash
      cd pollhub
      ```

3. **Start the Application**
    - Use Docker Compose to set up the environment:
      ```bash
      docker-compose up
      ```  

4. **Access the Application**
    - Open your browser and go to [http://localhost:4000/polls](http://localhost:4000/polls).

---

## **Status of Implementation**

### **Completed**
- User registration and login functionality.
- Basic poll creation.

### **In Progress**
- **Poll Entry Management**:
    - Poll entries can be added, but they are not properly saved to the database.

- **Voting Logic**:
    - Users cannot vote on polls yet. This functionality is currently under development.