import json
from typing import List, Dict, Any
from models import Exercise, Muscle, BodyPart, Equipment


class DataLoader:
    def __init__(self):
        self.exercises: List[Exercise] = []
        self.muscles: List[Muscle] = []
        self.body_parts: List[BodyPart] = []
        self.equipments: List[Equipment] = []
        self._load_data()
    
    def _load_data(self):
        """Load all data from JSON files"""
        try:
            # Load exercises
            with open('exercises.json', 'r') as f:
                exercises_data = json.load(f)
                self.exercises = [Exercise(**exercise) for exercise in exercises_data]
            
            # Load muscles
            with open('muscles.json', 'r') as f:
                muscles_data = json.load(f)
                self.muscles = [Muscle(**muscle) for muscle in muscles_data]
            
            # Load body parts
            with open('bodyParts.json', 'r') as f:
                body_parts_data = json.load(f)
                self.body_parts = [BodyPart(**body_part) for body_part in body_parts_data]
            
            # Load equipments
            with open('equipments.json', 'r') as f:
                equipments_data = json.load(f)
                self.equipments = [Equipment(**equipment) for equipment in equipments_data]
                
        except FileNotFoundError as e:
            print(f"Error loading data file: {e}")
            raise
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
            raise
    
    def get_all_exercises(self) -> List[Exercise]:
        """Get all exercises"""
        return self.exercises
    
    def get_exercise_by_id(self, exercise_id: str) -> Exercise:
        """Get exercise by ID"""
        for exercise in self.exercises:
            if exercise.exerciseId == exercise_id:
                return exercise
        return None
    
    def search_exercises_by_name(self, query: str) -> List[Exercise]:
        """Search exercises by name (case-insensitive)"""
        query_lower = query.lower()
        return [
            exercise for exercise in self.exercises
            if query_lower in exercise.name.lower()
        ]
    
    def get_exercises_by_muscle(self, muscle: str) -> List[Exercise]:
        """Get exercises targeting specific muscle"""
        muscle_lower = muscle.lower()
        return [
            exercise for exercise in self.exercises
            if any(muscle_lower in target_muscle.lower() for target_muscle in exercise.targetMuscles) or
               any(muscle_lower in secondary_muscle.lower() for secondary_muscle in exercise.secondaryMuscles)
        ]
    
    def get_exercises_by_body_part(self, body_part: str) -> List[Exercise]:
        """Get exercises for specific body part"""
        body_part_lower = body_part.lower()
        return [
            exercise for exercise in self.exercises
            if any(body_part_lower in bp.lower() for bp in exercise.bodyParts)
        ]
    
    def get_exercises_by_equipment(self, equipment: str) -> List[Exercise]:
        """Get exercises using specific equipment"""
        equipment_lower = equipment.lower()
        return [
            exercise for exercise in self.exercises
            if any(equipment_lower in eq.lower() for eq in exercise.equipments)
        ]
    
    def get_all_muscles(self) -> List[Muscle]:
        """Get all muscles"""
        return self.muscles
    
    def get_all_body_parts(self) -> List[BodyPart]:
        """Get all body parts"""
        return self.body_parts
    
    def get_all_equipments(self) -> List[Equipment]:
        """Get all equipments"""
        return self.equipments
    
    def get_random_exercises(self, count: int = 1) -> List[Exercise]:
        """Get random exercises"""
        import random
        if count >= len(self.exercises):
            return self.exercises
        return random.sample(self.exercises, count)


# Global data loader instance
data_loader = DataLoader()
