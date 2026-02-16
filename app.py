from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
import search_functions
import settings
app = FastAPI()
templates = Jinja2Templates("templates")


        

# global search wrapper that is responsible for determining which sub function to call i.e. 
# User searches for email:mail@example.com the wrapper routes the query to the search_by_email function
ALLOWED_SEARCH_FIELDS = settings.VALID_SEARCH_TERMS

async def search_wrapper(query):
    parts = query.split()
    if not parts:
        return {"results": [], "error": None}

    for part in parts:
        if ":" not in part:
            return {"results": [], "error": "Invalid query format. Use field:value"}

        field, value = part.split(":", 1)

        if field not in ALLOWED_SEARCH_FIELDS:
            return {"results": [], "error": f"Invalid search field: {field}"}

        try:
            results = await search_functions.search_by_term(field, value)
        except Exception as e:
            return {"results": [], "error": f"Search failed: {e}"}

        
        if results is None:
            results = []

        return {"results": results, "error": None}





@app.get("/", response_class=HTMLResponse)
async def get_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request })



@app.post("/content/search/", response_class=HTMLResponse)
async def search_content(request: Request):

    form = await request.form()
    query = form.get("query", "").strip()

    search_data = await search_wrapper(query)

    return templates.TemplateResponse(
        "partials/results.html",
        {
            "request": request,
            "results": search_data["results"],
            "error": search_data["error"]
        }
        )
