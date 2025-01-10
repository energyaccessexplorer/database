# Energy Access Explorer Database

This repository houses the SQL (PostgreSQL) code for the Energy Access Explorer platform's database. This README guides you through setup, development, and contribution processes.

## Getting Started

### Prerequisites:

- **PostgreSQL**: Ensure PostgreSQL v15 is installed and running in your machine.
- **PostgREST**: PostgREST is required for handling authentication and permissions via JWT using [pgjwt](https://github.com/michelp/pgjwt). Check [EAE API](https://github.com/energyaccessexplorer/api) repository documentation for further information regarding PostgREST.
- **pgcrypto**: This PostgreSQL extension is used for generating UUIDs and checksums. It's typically included in standard PostgreSQL installations. If you encounter errors related to UUID generation or checksum functions, ensure [pgcrypto](https://www.postgresql.org/docs/current/pgcrypto.html) is enabled in your database. Make sure it is installed and enable by running `CREATE EXTENSION pgcrypto;` in your database. If it is already installed, you should see the message **NOTICE:  extension "pgcrypto" already exists, skipping** after running this command.
- **Make**: A make utility (like GNU Make or BSD Make) should be installed to utilize the provided Makefile for streamlining common tasks.

### Setup:

1. **Configure Makefile**: Open the Makefile and adjust the configuration variables in the first few lines to match your environment. This includes database connection details (host, username, password, database name).
2. **Database Creation and Build**: Execute the following commands in your terminal from the root of the project directory:

```
make dbcreate dbbuild
```

- `make dbcreate` creates the database.
- `make dbbuild` builds the necessary database schema and populates any required initial data.

## Development Workflow

- **Branching**: Create a new branch for your feature or bug fix. This isolates your work from the main codebase and simplifies code reviews. Use descriptive branch names (e.g., `feature/new-table`, `bugfix/data-validation`).
- **SQL Scripting**: Write clear and well-documented SQL scripts. Use comments to explain complex logic.
- **Testing**: Thoroughly test your changes locally before submitting a pull request. Verify data integrity and ensure queries perform efficiently.
- **Commits**: Commit your changes frequently with concise and informative commit messages.


## Good Development Practices

- **Code Style**: Maintain consistent code style and formatting. Use tools like `pgFormatter` to automatically format your SQL code.
- **Data Integrity**: Enforce data integrity with constraints (e.g., primary keys, foreign keys, data type validation).
- **Indexing**: Use appropriate indexes to optimize query performance.
- **Documentation**: Keep the database schema well-documented. Use comments to explain table structures, columns, and relationships.