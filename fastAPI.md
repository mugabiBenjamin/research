# FastAPI

- [Installation](#installation)
- [Path parameters](#path-parameters)
- [Query parameters](#query-parameters)
  - [One query parameter](#one-query-parameter)
  - [Two query parameters](#two-query-parameters)
- [Request body and post method](#request-body-and-post-method)
- [Put method](#put-method)
- [Delete method](#delete-method)

## Installation

```bash
python3 --version
pip --version

sudo apt update
sudo apt install python3 python3-pip -y

# cd project directory
python3 -m venv venv
source venv/bin/activate
pip3 install fastapi uvicorn

# To run
uvicorn myApi:app --reload
```

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def index():
    return {"message": "Hello, World!"}
```

```plaintext
http://127.0.0.1:8000/docs
```

## Path parameters

```python
@app.get("/student/{student_id}")
def get_student(student_id: int):
    if student_id in students:
        return students[student_id]
    else:
        return {"error": "Student not found"}, 404
```

```python
from fastapi import FastAPI, Path

app = FastAPI()

students = {
    1: {
        "name": "Mugabi Benjamin",
        "age": 20,
        "grade": "A"
    }
}

@app.get("/student/{student_id}")
def get_student(student_id: int = Path(description="The ID of the student to retrieve", gt=0, lt=3)):
    if student_id in students:
        return students[student_id]
    else:
        return {"error": "Student not found"}, 404
```

## Query parameters

### One query parameter

```python
@app.get("/get-by-name")
def get_student_by_name(name: str):
    if name is not None:
        for student in students.values():
            if student["name"] == name:
                return student
    return {"Error": "Student not found"}, 404
```

```python
from typing import Optional
from fastapi import FastAPI, Path

app = FastAPI()

students = {
    1: {
        "name": "Benjamin",
        "age": 20,
        "grade": "A"
    }
}

@app.get("/get-by-name")
def get_student_by_name(name: Optional[str] = None):    # Optional query parameter
    if name is not None:
        for student in students.values():
            if student["name"] == name:
                return student
    return {"Error": "Student not found"}, 404

# http://127.0.0.1:8000/get-by-name?name=Benjamin
```

### Two query parameters

```python
@app.get("/get-by-name-and-age")
def get_student_by_name(*, name: Optional[str] = None, age: int):
    if name is not None:
        for student in students.values():
            if student["name"] == name and student["age"] == age:
                return student
    return {"Error": "Student not found"}, 404

# http://127.0.0.1:8000/get-by-name-and-age/1?name=Benjamin&age=20
```

## Request body and post method

```python
from typing import Optional
from fastapi import FastAPI, Path
from pydantic import BaseModel

app = FastAPI()

students = {
    1: {
        "name": "Benjamin",
        "age": 20,
        "grade": "A"
    }
}

class Student(BaseModel):
    name: str
    age: int
    grade: str

@app.post("/add-student/{student_id}")
def add_student(student_id: int, student: Student):
    if student_id in students:
        return {"error": "Student ID already exists"}, 400
    students[student_id] = student.model_dump()
    return {"message": "Student added successfully", "student": students[student_id]}

# http://127.0.0.1:8000/add-student/2?name=Benjamin&age=20&grade=A
```

## Put method

```python
from typing import Optional
from fastapi import FastAPI, Path
from pydantic import BaseModel

app = FastAPI()

students = {
    1: {
        "name": "Benjamin",
        "age": 20,
        "grade": "A"
    }
}

class UpdateStudent(BaseModel):
    name: Optional[str] = None
    age: Optional[int] = None
    grade: Optional[str] = None

@app.put("/update-student/{student_id}")
def update_student(student_id: int, student: UpdateStudent):
    if student_id not in students:
        return {"error": "Student not found"}, 404
    existing_student = students[student_id]
    updated_student = existing_student.copy()
    if student.name is not None:
        updated_student["name"] = student.name
    if student.age is not None:
        updated_student["age"] = student.age
    if student.grade is not None:
        updated_student["grade"] = student.grade
    students[student_id] = updated_student
    return {"message": "Student updated successfully", "student": updated_student}
```

## Delete method

```python
@app.delete("/delete-student/{student_id}")
def delete_student(student_id: int):
    if student_id not in students:
        return {"error": "Student not found"}, 404
    del students[student_id]
    return {"message": "Student deleted successfully"}
```

[Back to Top](#fastapi)
