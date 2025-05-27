from pydantic import BaseModel
from typing import List, Optional


class Exercise(BaseModel):
    exerciseId: str
    name: str
    gifUrl: str
    targetMuscles: List[str]
    bodyParts: List[str]
    equipments: List[str]
    secondaryMuscles: List[str]
    instructions: List[str]


class Muscle(BaseModel):
    name: str


class BodyPart(BaseModel):
    name: str


class Equipment(BaseModel):
    name: str


class ExerciseResponse(BaseModel):
    exercises: List[Exercise]
    total: int
    page: int
    limit: int
    total_pages: int


class ErrorResponse(BaseModel):
    error: str
    message: str
