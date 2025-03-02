extends Node
class_name DialogLineProvider

# to be fully loaded, a scenario translation file needs to be added in Project-> Localization
# files 
static func GetDialogs(filePath : String, dialogGroups : Array[String]) -> Dictionary:
	var dico : Dictionary
	for group in dialogGroups:
		dico[group] = []
	
	var file = FileAccess.open(filePath, FileAccess.READ);

	# Ignore first line which has keys and language
	var line = file.get_csv_line(";")
	while (line.size() > 1):
		line = file.get_csv_line(";")
		for group in dialogGroups:
			if line[0].find(group) >= 0:
				dico[group].append(line[0])
				break
	
	file.close()
	return dico
