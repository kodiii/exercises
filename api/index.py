from fastapi import FastAPI, HTTPException, Query, Path
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, RedirectResponse
from typing import List, Optional
import math
import os
import sys

# Add the parent directory to the path so we can import our modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models import Exercise, Muscle, BodyPart, Equipment, ExerciseResponse, ErrorResponse
from data_loader import data_loader

# Create FastAPI app
app = FastAPI(
    title="Muscle Exercises API",
    description="A comprehensive API for muscle exercises with detailed information about workouts, target muscles, equipment, and instructions.",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Note: Static file serving is handled differently in Vercel
# We'll serve the website files through a separate route

@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={"error": "Internal Server Error", "message": str(exc)}
    )


@app.get("/", tags=["Root"])
async def root():
    """API information endpoint"""
    return {
        "message": "Welcome to the Muscle Exercises API",
        "version": "1.0.0",
        "total_exercises": len(data_loader.get_all_exercises()),
        "total_muscles": len(data_loader.get_all_muscles()),
        "total_body_parts": len(data_loader.get_all_body_parts()),
        "total_equipments": len(data_loader.get_all_equipments()),
        "documentation": "/docs",
        "website": "https://kodiii.github.io/exercises/website/",
        "endpoints": {
            "exercises": "/exercises",
            "muscles": "/muscles",
            "body_parts": "/bodyparts",
            "equipments": "/equipments"
        }
    }


@app.get("/api", tags=["Root"])
async def api_info():
    """API information endpoint"""
    return {
        "message": "Welcome to the Muscle Exercises API",
        "version": "1.0.0",
        "total_exercises": len(data_loader.get_all_exercises()),
        "total_muscles": len(data_loader.get_all_muscles()),
        "total_body_parts": len(data_loader.get_all_body_parts()),
        "total_equipments": len(data_loader.get_all_equipments()),
        "documentation": "/docs",
        "website": "https://kodiii.github.io/exercises/website/",
        "endpoints": {
            "exercises": "/exercises",
            "muscles": "/muscles",
            "body_parts": "/bodyparts",
            "equipments": "/equipments"
        }
    }


@app.get("/exercises", response_model=ExerciseResponse, tags=["Exercises"])
async def get_exercises(
    page: int = Query(1, ge=1, description="Page number"),
    limit: int = Query(20, ge=1, le=100, description="Number of exercises per page"),
    muscle: Optional[str] = Query(None, description="Filter by target muscle"),
    bodypart: Optional[str] = Query(None, description="Filter by body part"),
    equipment: Optional[str] = Query(None, description="Filter by equipment"),
    search: Optional[str] = Query(None, description="Search by exercise name")
):
    """
    Get all exercises with optional filtering and pagination.
    
    - **page**: Page number (default: 1)
    - **limit**: Number of exercises per page (default: 20, max: 100)
    - **muscle**: Filter by target muscle (case-insensitive)
    - **bodypart**: Filter by body part (case-insensitive)
    - **equipment**: Filter by equipment (case-insensitive)
    - **search**: Search by exercise name (case-insensitive)
    """
    exercises = data_loader.get_all_exercises()
    
    # Apply filters
    if search:
        exercises = data_loader.search_exercises_by_name(search)
    elif muscle:
        exercises = data_loader.get_exercises_by_muscle(muscle)
    elif bodypart:
        exercises = data_loader.get_exercises_by_body_part(bodypart)
    elif equipment:
        exercises = data_loader.get_exercises_by_equipment(equipment)
    
    # Calculate pagination
    total = len(exercises)
    total_pages = math.ceil(total / limit)
    start_idx = (page - 1) * limit
    end_idx = start_idx + limit
    paginated_exercises = exercises[start_idx:end_idx]
    
    return ExerciseResponse(
        exercises=paginated_exercises,
        total=total,
        page=page,
        limit=limit,
        total_pages=total_pages
    )


@app.get("/exercises/{exercise_id}", response_model=Exercise, tags=["Exercises"])
async def get_exercise_by_id(
    exercise_id: str = Path(..., description="The ID of the exercise")
):
    """
    Get a specific exercise by its ID.
    
    - **exercise_id**: The unique identifier of the exercise
    """
    exercise = data_loader.get_exercise_by_id(exercise_id)
    if not exercise:
        raise HTTPException(status_code=404, detail=f"Exercise with ID '{exercise_id}' not found")
    return exercise


@app.get("/exercises/search/{query}", response_model=List[Exercise], tags=["Exercises"])
async def search_exercises(
    query: str = Path(..., description="Search query for exercise names"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of results")
):
    """
    Search exercises by name.
    
    - **query**: Search term to match against exercise names
    - **limit**: Maximum number of results to return (default: 50, max: 100)
    """
    exercises = data_loader.search_exercises_by_name(query)
    return exercises[:limit]


@app.get("/exercises/by-muscle/{muscle}", response_model=List[Exercise], tags=["Exercises"])
async def get_exercises_by_muscle(
    muscle: str = Path(..., description="Target muscle name"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of results")
):
    """
    Get exercises targeting a specific muscle.
    
    - **muscle**: Name of the target muscle (case-insensitive)
    - **limit**: Maximum number of results to return (default: 50, max: 100)
    """
    exercises = data_loader.get_exercises_by_muscle(muscle)
    if not exercises:
        raise HTTPException(status_code=404, detail=f"No exercises found for muscle '{muscle}'")
    return exercises[:limit]


@app.get("/exercises/by-bodypart/{bodypart}", response_model=List[Exercise], tags=["Exercises"])
async def get_exercises_by_bodypart(
    bodypart: str = Path(..., description="Body part name"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of results")
):
    """
    Get exercises for a specific body part.
    
    - **bodypart**: Name of the body part (case-insensitive)
    - **limit**: Maximum number of results to return (default: 50, max: 100)
    """
    exercises = data_loader.get_exercises_by_body_part(bodypart)
    if not exercises:
        raise HTTPException(status_code=404, detail=f"No exercises found for body part '{bodypart}'")
    return exercises[:limit]


@app.get("/exercises/by-equipment/{equipment}", response_model=List[Exercise], tags=["Exercises"])
async def get_exercises_by_equipment(
    equipment: str = Path(..., description="Equipment name"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of results")
):
    """
    Get exercises using specific equipment.
    
    - **equipment**: Name of the equipment (case-insensitive)
    - **limit**: Maximum number of results to return (default: 50, max: 100)
    """
    exercises = data_loader.get_exercises_by_equipment(equipment)
    if not exercises:
        raise HTTPException(status_code=404, detail=f"No exercises found for equipment '{equipment}'")
    return exercises[:limit]


@app.get("/exercises/random", response_model=List[Exercise], tags=["Exercises"])
async def get_random_exercises(
    count: int = Query(1, ge=1, le=20, description="Number of random exercises to return")
):
    """
    Get random exercises.
    
    - **count**: Number of random exercises to return (default: 1, max: 20)
    """
    return data_loader.get_random_exercises(count)


@app.get("/muscles", response_model=List[Muscle], tags=["Reference Data"])
async def get_all_muscles():
    """Get all available muscle groups."""
    return data_loader.get_all_muscles()


@app.get("/bodyparts", response_model=List[BodyPart], tags=["Reference Data"])
async def get_all_bodyparts():
    """Get all available body parts."""
    return data_loader.get_all_body_parts()


@app.get("/equipments", response_model=List[Equipment], tags=["Reference Data"])
async def get_all_equipments():
    """Get all available equipment types."""
    return data_loader.get_all_equipments()


@app.get("/stats", tags=["Statistics"])
async def get_api_stats():
    """Get API statistics and data overview."""
    exercises = data_loader.get_all_exercises()
    
    # Count exercises by body part
    bodypart_counts = {}
    for exercise in exercises:
        for bodypart in exercise.bodyParts:
            bodypart_counts[bodypart] = bodypart_counts.get(bodypart, 0) + 1
    
    # Count exercises by equipment
    equipment_counts = {}
    for exercise in exercises:
        for equipment in exercise.equipments:
            equipment_counts[equipment] = equipment_counts.get(equipment, 0) + 1
    
    # Count exercises by target muscle
    muscle_counts = {}
    for exercise in exercises:
        for muscle in exercise.targetMuscles:
            muscle_counts[muscle] = muscle_counts.get(muscle, 0) + 1
    
    return {
        "total_exercises": len(exercises),
        "total_muscles": len(data_loader.get_all_muscles()),
        "total_body_parts": len(data_loader.get_all_body_parts()),
        "total_equipments": len(data_loader.get_all_equipments()),
        "exercises_by_bodypart": dict(sorted(bodypart_counts.items(), key=lambda x: x[1], reverse=True)),
        "exercises_by_equipment": dict(sorted(equipment_counts.items(), key=lambda x: x[1], reverse=True)[:10]),  # Top 10
        "exercises_by_muscle": dict(sorted(muscle_counts.items(), key=lambda x: x[1], reverse=True)[:10])  # Top 10
    }


# Vercel handler
def handler(request):
    return app(request)

# For local development
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
