# Philadelphia Eagles App

## Overview

This python application connects to a MySQL database for the 2024-2025
    Philadelphia Eagles (SUPERBOWL CHAMPS GO BIRDS). It demonstrates querying data,
    adding players, deleting players, changing active status, exporting views to CSV, and displaying information
    in a user-friendly format.

## Files

- `CorethFinalSQL.sql` - SQL script containing eagles_db. 
- `CorethDAL.py` - Data Access Layer; runs SQL and stored procedures.
- `CorethBLL.py` - Business Logic Layer; calls the DAL and formats results for the GUI.
- `CorethGUI.py` - PySimpleGUI front end (the main file being run).

## Prerequisites

- Python 3.x installed
- MySQL Server running with the `eagles_db` set up as per provided SQL script
- Required Python packages(e.g., `mysql-connector-python` and `PySimpleGUI`).

## How to Run

1. Ensure CorethDAL.py, CorethBLL.py, and CorethGUI.py are in the same directory.
2. Install dependencies once:
```bash
pip install PySimpleGUI mysql-connector-python
```
3. Run the GUI:
```bash
python CorethGUI.py
```
4. In the app's top row, enter the MySQL required credentials and click Login.
   - example defaults shown in the GUI:
     - User: root
     - Database: eagles_db

## The program will

- Load tables on button click:
  - All Players / Salary by Position / Colleges / Players(List) / Games / Appearances / Contracts
  - Results are shown in fixed tables inside a scrollable column.
- Add Player
  - Opens a popup to enter first name, last name, and position; inserts via the BLL/DAL.
- Delete Player
  - Opens a popup to delete by first/last name.
- Update Status
  - Opens a popup to update a player's active status to inactive (meaning a player is injured).
- Export CSV
  - Opens a small dialog to choose All Players or Salary by Position.
  - Prompts for a save location and writes a .csv with headers coming directly from SQL aliases.

Tip: The status bar at the bottom shows quick feedback such as connection confirmation and row counts.
- e.g., "Loaded 42 players"





