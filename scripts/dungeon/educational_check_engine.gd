extends Node
## EducationalCheckEngine — Verifies player answers in battle.

class_name EducationalCheckEngine

signal answer_checked(is_correct: bool)

func check_answer(question_id: String, player_answer: String) -> bool:
    # Logic to fetch question from quest data
    # Placeholder: direct string match
    var is_correct = _verify_against_data(question_id, player_answer)
    answer_checked.emit(is_correct)
    return is_correct

func _verify_against_data(q_id: String, answer: String) -> bool:
    # Integration with QuestManager/Data would go here
    return answer == "correct_answer"
