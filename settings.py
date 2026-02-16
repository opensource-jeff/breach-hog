'''
This file manages the configuration settings for the credhog tool 
you can find examples on how to configure the tool below
'''

'''
The DUCKDB_FILES array is used to specify a collection of databases to search accross
The recommended approach is to group databases by year or source for example
breaches_2020.duckdb
breaches_2021.duckdb
This allows you to carry on searching while indexing or ingesting in the background on new data that is being added

Example config:
    DUCKDB_FILES = [
            r"path/to/database1.duckdb",
            r"path/to/database2.duckdb"

    ]

    
Please ensure you use both the r prefix as well as / even on windows as the application interprests the path to the databases as a raw string
'''



DUCKDB_FILES = [
        r"./breaches.duckdb"
        ]

'''
The RESULTS_LIMIT variable is used to specify a limit for the number of results that are returned for searches 
the default limit is 100

'''

RESULTS_LIMIT = 100


'''
The VALID_SEARCH_TERMS list is used for specifying what column names are searchable across the databases that are configured in DUCKDB_FILES
'''

VALID_SEARCH_TERMS = {
        "email",
        "phone",
        "username"
        }
