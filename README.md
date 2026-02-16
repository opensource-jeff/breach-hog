 # breach-hog
A self hosted data breach search tool

## Project state
Right now the project is an MVP I have plans to enhance ingestion and normalization of breach data but for right now this is a manual process 

# Usage overview 

I have provided some easy to use ingestion scripts for getting your data into duckdb you can either ingest a dataset as a json file or as a csv file 

to run the main web application run 
```
fastapi app.py
```

## Important:
Please ensure that you normalize your fields across your breach datasets and update the settings.py file (specifically the duckdb path(s) if you are using external storage as well as the allowed search terms the reason for this will become clear later on in the docs)

## Installing the dependencies  
 to install the python dependencies you can follow these instructions
 1. create a virtual environment
  ```
python3 -m venv .venv

```
2. activate your venv 
3. Install the dependencies
```
pip install -r requirements.txt
```
4. for using the ingestion and indexing scripts duckdb needs to be installed you can accoumplish this my heading over to https://duckdb.org/ and following the installation instructions
5. you can create a blank database by running
```
duckdb /path/to/database.duckdb
```

## How does searching work?

The basic pricipal of how this tool searches for relevant data is you specify a key value pair for example

```
email:user@example.com
```
Credhog will then search the configured database(s) across all tables that have a column named email and will return all the relevant values in this case user@example.com

## Indexing

Right now you can find a quick and easy indexing script in the scripts folder and you can specify a coulmn name you would like to index and the script will index all coulmns in the database with the same name

