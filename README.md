# Index the Content [![CircleCI](https://circleci.com/gh/mur-wtag/indexTheContent.svg?style=svg)](https://circleci.com/gh/mur-wtag/indexTheContent)
A tiny RESTful API to index a page's content

## Setup
1. Clone the repo
2. Run in project directory
```shell
bundle install
rake db:create
rake db:schema:load
rails s
```

## Api Endpoints
1. `POST /api/web_contents/crawls`:
    
    ```
    Content-type: application/json
    Accept-Version: v1
    Authorization: Basic dXNlcjE6cGFzc3dvcmQx (See Basic Authentication section)
    Parameters: a) crawl_url (string type), b) container_tags (array type)
    
    Response Body:
    { "id" => 1 }
    ```
    
    **Curl Example**
    ```
    curl -H "Content-Type: application/json" \
         -H "Accept-Version: v1" \
         -H "Authorization: Basic dXNlcjE6cGFzc3dvcmQx" \
         -X POST -d '{"crawl_url":"https://www.github.com","container_tags":["h1"]}' http://localhost:3000/api/web_contents/crawls
    ```
2. `GET /api/web_contents/crawls/<query_id>/results`:
    ```
    Content-type: application/json
    Accept-Version: v1
    Authorization: Basic dXNlcjE6cGFzc3dvcmQx (See Basic Authentication section)
    Parameters: None
    
    Response Body:
    { "query_id": 1, "container_tag": "h1", "content": "You are Welcome" }
    ```

    **Curl Example**
    ```
    curl -H "Content-Type: application/json" \
         -H "Accept-Version: v1" \
         -H "Authorization: Basic dXNlcjE6cGFzc3dvcmQx" \
         -X GET http://localhost:3000/api/web_contents/crawls/1/results
         
    ```

## Basic Authentication
Here in this application simple Basic Authentication added.

**Authenticating Credential:**
```
username: 'user1'
password: 'password1'
```

Thanks!
