# 🧪 PeriodicBash (PostgreSQL + Bash CLI + Normalization)
*🇪🇸 [Leer en español](README.es.md)*

A Bash application to search for elements of the periodic table. The main objective was to normalize and correct errors in an already existing database `periodic_table_old.sql` to transform it into `periodic_table.sql`.
Avoiding data redundancy (duplication), guaranteeing data atomicity (one field, one data point), and data integrity.

## 🚀 Key Features
  - **Dump of the original database (`periodic_table_old`):** The database contains inconsistent data
    - **Lowercase symbols:** Like `he` and `li`, and the fictional element `moTanium`.
    - **Lack of referential integrity:** There is no `FOREIGN KEY` between `properties` and `elements`, allowing orphaned records.
    - **Redundant constraints:** Redundant `UNIQUE` constraints on primary keys.
    - **Risk of incomplete data and inconsistent JOINs:** `melting_point` and `boiling_point` in `properties` allow nulls, which can cause information loss or unexpected behavior when operating or filtering such data without a value.
    - **Mandatory fields exposed in elements:** `symbol` and `name` allow NULL, which would make it possible to register anonymous elements or elements without a symbol in the main catalog.
    - **Repeated attributes and over-fragmentation:** `type` should be an independent table (3NF) and the 1-to-1 division between `elements` and `properties` requires making unnecessary `JOINs`.
  - **Dump of the normalized database (`periodic_table.sql`):** The new database corrects the errors of its predecessor `periodic_table_old`
    - **Uppercase symbols:** All chemical symbols have their first or only letter capitalized (e.g., `He`, `Li`).
    - **Referential integrity:** A `FOREIGN KEY` was added between `properties` and `elements` guaranteeing referential integrity, connecting tables and avoiding erroneous data.
    - **No redundant constraints:** If a constraint is not needed, it is not implemented, benefiting the maintenance of the database.
    - **Impossibility of empty data:** By design, empty data is no longer accepted in any field.
    - **Normalization:** The `type` field is separated from properties and replaced by a Foreign Key called `type_id`, which is related to `type_id` of the `type` table, complying with the Third Normal Form (3NF).
  - **`element.sh` script:** A Bash Script that allows querying the information of a periodic table element registered in the database (`periodic_table.sql`).

## 📂 Project Structure
```text
.
├── element.sh             # Main CLI executable script
├── periodic_table.sql     # Dump of the normalized database
├── periodic_table_old.sql # Dump of the original unnormalized database
└── README.md              # Project documentation
```

## 🛠️ Technologies Used
  - **Database:** PostgreSQL
  - **Language:** Bash / Shell Scripting (psql CLI)

## 💻 Installation and Execution
### Prerequisites
Have PostgreSQL installed and configured in your local environment.  
### Steps
1. **Clone the repository:**
```bash
  git clone https://github.com/Aki-new/PeriodicBash.git
  cd PeriodicBash
```
2. **Create and import the database schema:**
```bash
  psql -U postgres < periodic_table.sql
```
> [!WARNING]  
> **Careful:**  
> Make sure to execute `psql -U postgres < periodic_table.sql` and not `psql -U postgres < periodic_table_old.sql`,
> otherwise you will import the database without the fixes and normalizations I performed.

3. **Give permissions to the application:**
```bash
  chmod +x element.sh
```

## 👨‍💻 Usage Guide 
- If you execute directly `./element.sh` you will get a message saying `Please provide an element as an argument.`
- For it to run you must give it a parameter, it can be the atomic number, a chemical symbol or directly the name
  ```bash
    # Examples
    ./element.sh 1
    ./element.sh H
    ./element.sh Hydrogen
  ```
- Any sample input will generate the same output
  ```plaintext
    The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
  ```

## 📜 Credits and Acknowledgments

* **Origin of the prompt / dataset:** This project is one of the challenges required to obtain the **Relational Database Certification** from [freeCodeCamp](https://www.freecodecamp.org/).
* **Implementation:** The bash script logic (`element.sh`) and the structuring of the PostgreSQL schema (`periodic_table.sql`) were completely developed as an individual solution to the proposed problem.
