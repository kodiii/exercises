# Muscle Exercises API

A comprehensive REST API for muscle exercises with detailed information about workouts, target muscles, equipment, and step-by-step instructions.

## Features

- **500+ Exercises** with detailed information
- **151 Muscle groups** categorized
- **10 Body parts** (neck, arms, shoulders, chest, back, legs, waist, cardio)
- **83 Equipment types** supported
- **Exercise GIFs** for visual demonstrations
- **Search and filtering** capabilities
- **Pagination** support
- **Automatic API documentation** with Swagger/OpenAPI

## Quick Start

### Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the API:
```bash
python main.py
```

Or using uvicorn directly:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

3. Access the API:
- **API Base URL**: http://localhost:8000
- **Interactive Documentation**: http://localhost:8000/docs
- **Alternative Documentation**: http://localhost:8000/redoc

## API Endpoints

### Exercises

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/exercises` | Get all exercises with filtering and pagination |
| GET | `/exercises/{exercise_id}` | Get specific exercise by ID |
| GET | `/exercises/search/{query}` | Search exercises by name |
| GET | `/exercises/by-muscle/{muscle}` | Get exercises targeting specific muscle |
| GET | `/exercises/by-bodypart/{bodypart}` | Get exercises for specific body part |
| GET | `/exercises/by-equipment/{equipment}` | Get exercises using specific equipment |
| GET | `/exercises/random` | Get random exercise(s) |

### Reference Data

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/muscles` | Get all available muscles |
| GET | `/bodyparts` | Get all body parts |
| GET | `/equipments` | Get all equipment types |

### Utilities

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information and overview |
| GET | `/stats` | API statistics and data overview |
| GET | `/gifs/{gif_name}` | Serve exercise GIF files |

## Usage Examples

### Get All Exercises (with pagination)
```bash
curl "http://localhost:8000/exercises?page=1&limit=10"
```

### Search Exercises
```bash
curl "http://localhost:8000/exercises/search/push%20up"
```

### Get Exercises by Muscle
```bash
curl "http://localhost:8000/exercises/by-muscle/biceps"
```

### Get Exercises by Body Part
```bash
curl "http://localhost:8000/exercises/by-bodypart/chest"
```

### Get Exercises by Equipment
```bash
curl "http://localhost:8000/exercises/by-equipment/dumbbell"
```

### Get Random Exercise
```bash
curl "http://localhost:8000/exercises/random?count=3"
```

### Get Specific Exercise
```bash
curl "http://localhost:8000/exercises/2ORFMoR"
```

### Filtering with Query Parameters
```bash
# Filter exercises with pagination
curl "http://localhost:8000/exercises?muscle=biceps&page=1&limit=5"

# Search with limit
curl "http://localhost:8000/exercises?search=squat&limit=10"
```

## Response Format

### Exercise Object
```json
{
  "exerciseId": "2ORFMoR",
  "name": "hack calf raise",
  "gifUrl": "2ORFMoR.gif",
  "targetMuscles": ["calves"],
  "bodyParts": ["lower legs"],
  "equipments": ["sled machine"],
  "secondaryMuscles": ["hamstrings", "glutes"],
  "instructions": [
    "Step:1 Adjust the sled machine to a comfortable weight.",
    "Step:2 Stand on the sled machine with your toes on the platform...",
    "..."
  ]
}
```

### Paginated Response
```json
{
  "exercises": [...],
  "total": 500,
  "page": 1,
  "limit": 20,
  "total_pages": 25
}
```

## Query Parameters

### `/exercises` endpoint supports:
- `page` (int): Page number (default: 1)
- `limit` (int): Items per page (default: 20, max: 100)
- `muscle` (string): Filter by target muscle
- `bodypart` (string): Filter by body part
- `equipment` (string): Filter by equipment
- `search` (string): Search by exercise name

## Error Handling

The API returns appropriate HTTP status codes:
- `200`: Success
- `404`: Resource not found
- `422`: Validation error
- `500`: Internal server error

Error responses include details:
```json
{
  "error": "Not Found",
  "message": "Exercise with ID 'invalid_id' not found"
}
```

## CORS Support

The API includes CORS middleware to allow cross-origin requests from web applications.

## Data Sources

The API serves data from JSON files:
- `exercises.json`: Exercise database
- `muscles.json`: Muscle groups
- `bodyParts.json`: Body part categories
- `equipments.json`: Equipment types
- `gifs/`: Exercise demonstration GIFs

## Development

### Project Structure
```
muscle_exercises_api/
├── main.py              # FastAPI application
├── models.py            # Pydantic data models
├── data_loader.py       # Data loading utilities
├── requirements.txt     # Python dependencies
├── README.md           # This file
├── exercises.json      # Exercise database
├── muscles.json        # Muscle groups
├── bodyParts.json      # Body parts
├── equipments.json     # Equipment types
└── gifs/              # Exercise GIF files
```

### Adding New Features

1. **New Endpoints**: Add to `main.py`
2. **Data Models**: Update `models.py`
3. **Data Processing**: Modify `data_loader.py`

### Running in Production

For production deployment, consider:
- Using a production ASGI server like Gunicorn with Uvicorn workers
- Setting up proper CORS origins
- Adding authentication if needed
- Implementing rate limiting
- Adding logging and monitoring

Example production command:
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

## License

This API is built for educational and fitness purposes. Please ensure you have proper rights to use the exercise data and GIF files in your specific use case.
