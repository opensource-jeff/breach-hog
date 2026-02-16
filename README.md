# breach-hog


A self-hosted data breach search tool powered by DuckDB.


breach-hog is designed for security researchers, OSINT analysts, and incident responders who need fast, local, column-based search capabilities across large breach datasets.
> breach-hog does **not** provide breach data. Users must supply and manage their own datasets.

To get the most out of the tool especially for ingesting data and maintaining indexes you do not need to be a database expert however it is helpful to have some high level knowledge of SQL.

![Python](https://img.shields.io/badge/python-3.11+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

<img width="1854" height="872" alt="image" src="https://github.com/user-attachments/assets/80fec0ee-7737-4c74-8247-2cd299544761" /> <img width="1849" height="873" alt="image" src="https://github.com/user-attachments/assets/6a73b2f6-bb1d-479d-bfd3-37c893bf0529" />



---


## 🚧 Project Status


breach-hog is currently an MVP.


Core functionality is stable:

- Multi-database search

- Column-based querying

- Basic indexing support

- Simple ingestion scripts


Data ingestion and schema normalization are currently manual processes. Automation and normalization tooling are planned in future releases as well as a REST API for integration into other tooling.


---


##  Features


-  Simple `key:value` search syntax

-  Multi-database support

-  DuckDB-powered performance

-  CSV and JSON ingestion scripts

- Column-based indexing support

- Lightweight FastAPI and HTMX web interface

-  Fully self-hosted


---


##  How Searching Works


Search queries use a simple key-value format for example:

```

email:user@example.com

```



When executed, breach-hog:


1. Searches all configured DuckDB databases

2. Identifies tables containing a column named `email` or whichever key is specified

3. Returns matching rows (limited to 100 per table this is adjustable in the settings.py file)


Search is entirely column-name driven.


This makes schema normalization critical.


---


## ⚠️ Important: Schema Normalization


Your datasets must use consistent column names.


For example, use:


- email

- username

- phone



Avoid inconsistent naming such as:


- Email

- e_mail

- email_address

- userEmail



breach-hog only searches columns that exactly match allowed search terms defined in `settings.py`.


After normalizing your datasets:


- Update `settings.py`

- Configure:

  - `DUCKDB_FILES`

  - `ALLOWED_SEARCH_TERMS`


---


##  Installation


### 1. Clone the repository


```bash

git clone https://github.com/yourusername/breach-hog.git

cd breach-hog

```


### 2. Create a virtual environment


```bash

python3 -m venv .venv

```

### 3. Activate the virtual environment


#### Linux/macOS


```bash

source .venv/bin/activate

```


#### Windows

```

.venv\Scripts\activate

```


### 4. Install the python dependencies 


```bash

pip install -r requirements.txt

```


### 5. Install DuckDB


DuckDB must be installed separately for ingestion and indexing scripts.


Visit:


https://duckdb.org/


Follow the installation instructions for your operating system.



## Creating a new Database


To create a blank DuckDB database run:

```bash

duckdb /path/to/database.duckdb

```

You can also create multiple databases (for example per-year breach archives) and configure them all in settings.py.



## Data Ingestion


The scripts/ directory includes ingestion helpers for:


CSV datasets


JSON datasets


Example usage (purely conceptual):


./scripts/email_index.sh /path/to/database.duckdb email


You may ingest multiple datasets into a single database or maintain separate databases (depending on your preference).



## Indexing


An indexing script is provided in the scripts/ directory.


It allows you to:


- Specify a column name


- Automatically create indexes on all tables containing that column


- Index naming convention:

```

idx_{table_name}_{column_name}

```

Indexing significantly improves search performance on large datasets allowing for results to be returned quicker


## Running the Application


Start the FastAPI server with:


```bash
uvicorn app:app --reload

```


Then open your browser:


http://127.0.0.1:8000


## Configuration


All configuration is handled in settings.py.


Example structure:

```

DUCKDB_FILES = [

    "/path/to/breaches_2020.duckdb",

    "/path/to/breaches_2021.duckdb"

]


RESULTS_LIMIT = 100


VALID_SEARCH_TERMS = {

    "email",

    "username",

    "phone"

}

```

You can configure multiple database files for scalable searching and ingestion Please note: You cannot search through a database while an ingestion script is running this is by design and prevents inconsistent database states.


## Architecture Overview


FastAPI and HTMX handles the web interface and API layer


DuckDB performs search queries


Search iterates across configured databases


Results are normalized into dictionaries before rendering


The system is designed to remain lightweight and portable.


## Performance Notes


Indexing is strongly recommended for large datasets


Large ingestion operations may temporarily lock a database file


Using multiple immutable databases improves concurrency and scalability


Query results are limited to 100 rows per table by default to prevent runaway responses


## Project Roadmap


Planned improvements include:


 - Automated ingestion pipelines


- Schema normalization tooling


- D3-based graph visualization of relationships

- REST API for easy integration into other tooling


## 🔐 Security & Legal Notice


breach-hog is intended for:


- Security research


- OSINT investigations


- Defensive security operations


Users are responsible for ensuring compliance with all applicable laws and regulations.

### Please note:
If you intend to run breach-hog on a dedicated server or VPS that is exposed directly to the internet please use a reverse proxy with an IDP such as authelia or Authentik you can also lock it down using simple auth on nginx-proxy manager as well. Initially I designed this tool to be portable so it can be run on a laptop with an external HDD or SSD attached.


## Contributing


Contributions are welcome.


Particularly appreciated areas include:


Performance testing feedback


Schema normalization strategies


Index optimization suggestions
