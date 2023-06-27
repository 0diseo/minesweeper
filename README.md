# API specification

## Create a new minesweeper game

Creating a new game is required to specify the columns, mines and rows, after that a new mine board is made and saved in the data base,returning the id of the board in uuid format, the id is critical to save it, becasue using it is how you are going to playu

**URL**: `/minesweeper`

**Method**: `POST`

**Body**:
```json
{
  "minesweeper": {
    "rows": 8,
    "columns": 8,
    "mines": 6
  }
}

```
**rows:** int value with minimum value of 8, is the size board rows that is going to be created

**columns:** int value with minimum value of 8, is the size board columns that is going to be created

**mines** int value, is the amount of mines in the board

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "board": [ 
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"]
  ],
  "id": "029ce810-014f-4d5e-ac9b-b006fdca8754"
}
```
**board:** the representation of the current board

**id:** is the id to access and play with the board

### Error Responses

#### Minimum rows value

**Code:** `422 Unauthorized`

**error:** `row number is minimum 8`

#### Minimum columns value

**Code:** `422 Unauthorized`

**error:** `columns number is minimum 8`

# Get a created board

get the current state of a mining board

**URL**: `/minesweeper/:id`

**id:** the id of a board

**Method**: `GET`

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "board": [ 
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"]
  ],
  "id": "029ce810-014f-4d5e-ac9b-b006fdca8754"
}
```
**board:** the representation of the current board

**id:** is the id to access and play with the board

### Error Responses

#### Invalid id

**Code:** `422 Unauthorized`

**error:** `"id board not valid"`

## Put a flag in a cell

put a flag in a cell is essential to mark possibles mines and avoid to open the cell

**URL**: `/minesweeper/{id}/flag_cell`

**Method**: `PUT`

**Body**:
```json
{
  "row": 2,
  "column":5
}
```
**row:** the number of the row to select, the first row is 0
**colum:** the number of the column to select, the first column is 0

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "board": [ 
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","flag","?","?"],
    ["?","?","?","?","?","2","?","?"],
    ["?","?","?","?","flag","?","?","?"],
    ["?","1","1","1","1","?","?","?"],
    ["?","2","0","0","1","3","?","?"],
    ["?","1","2","0","1","?","?","?"]
  ],
  "id": "029ce810-014f-4d5e-ac9b-b006fdca8754"
}
```
**board:** the representation of the current board

**id:** is the id to access and play with the board

### Error Responses

#### Invalid id

**Code:** `422 Unauthorized`

**error:** `"id board not valid"`

#### row or column impossible to use in the curren board

**Code:** `422 Unauthorized`

**error:** `"row or column is out of range"`

#### Game over or win game

is imposible to complete the action, the game was won or game over

**Code:** `200`

**error:** `the game is over`

## remove a flag in a cell

after a flag was put, it could be an error, with this action the flag can be removed

**URL**: `/minesweeper/{id}/undo_flag_cell`

**Method**: `PUT`

**Body**:
```json
{
  "row": 2,
  "column":5
}
```
**row:** the number of the row to select, the first row is 0
**colum:** the number of the column to select, the first column is 0

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "board": [ 
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","2","?","?"],
    ["?","?","?","?","flag","?","?","?"],
    ["?","1","1","1","1","?","?","?"],
    ["?","2","0","0","1","3","?","?"],
    ["?","1","2","0","1","?","?","?"]
  ],
  "id": "029ce810-014f-4d5e-ac9b-b006fdca8754"
}
```
**board:** the representation of the current board

**id:** is the id to access and play with the board

### Error Responses

#### Invalid id

**Code:** `422 Unauthorized`

**error:** `"id board not valid"`

#### row or column impossible to use in the curren board

**Code:** `422 Unauthorized`

**error:** `"row or column is out of range"`

#### Game over or win game

is imposible to complete the action, the game was won or game over

**Code:** `200`

**error:** `the game is over`

## Open a cell

the main action is to open cell, looking to open all the cell that contain number and avoiding the mines

**URL**: `/minesweeper/{id}/select_cell`

**Method**: `PUT`

**Body**:
```json
{
  "row": 2,
  "column":5
}
```
**row:** the number of the row to select, the first row is 0
**colum:** the number of the column to select, the first column is 0

### Successful Response

**Code**: `200 OK`

**Payload**:
```json
{
  "board": [ 
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","?","?","?"],
    ["?","?","?","?","?","2","?","?"],
    ["?","?","?","?","flag","?","?","?"],
    ["?","1","1","1","1","?","?","?"],
    ["?","2","0","0","1","3","?","?"],
    ["?","1","2","0","1","?","?","?"]
  ],
  "id": "029ce810-014f-4d5e-ac9b-b006fdca8754",
  "status": "active"
}
```
**board:** the representation of the current board

**id:** is the id to access and play with the board

**status:** is the actual state of the game, it could be active that is game that can be still played, or game over or win that is where the fame end

### Error Responses

#### Invalid id

**Code:** `422 Unauthorized`

**error:** `"id board not valid"`

#### row or column impossible to use in the curren board

**Code:** `422 Unauthorized`

**error:** `"row or column is out of range"`

#### Game over or win game

is imposible to complete the action, the game was won or game over

**Code:** `200`

**error:** `the game is over`



# Notes
## Test cases
the test cases where no completed, there is not test case for service and adapter layer, but there are test cases for the controller

**path:** spec/resquest

## heroku
**url:** 

## git
**url:**

## swager
ther is a half implementation of swager, is not working, is the first time I try to implemented and I failed in short time