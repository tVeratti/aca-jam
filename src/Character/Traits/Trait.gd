extends Resource

class_name Trait

enum Targets { PITCH, MEMORIZATION, ENERGY }
enum Durations { PERMANENT, NEXT_EVENT, NEXT_SHOW }
enum Types { POSITIVE, NEGATIVE, NEUTRAL}


export(String) var id:String = ""
export(String) var title:String = ""
export(String) var description:String = ""
export(Durations) var duration:int = Durations.PERMANENT
export(Targets) var target:int = Targets.PITCH
export(float) var modifier:float = 0.0

var type:int setget , _get_type


func _get_type() -> int:
	match(target):
		Targets.PITCH: return Types.NEGATIVE
		Targets.MEMORIZATION, Targets.ENERGY:
			if modifier > 0: return Types.POSITIVE
			else: return Types.NEGATIVE
	
	return Types.NEUTRAL
		
