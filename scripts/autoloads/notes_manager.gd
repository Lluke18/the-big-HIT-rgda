extends Node

enum step{
	VENTS, #0
	STORAGE, #1
	LAXATIVES, #2
	BATHROOM, #3
	KILL_1, #4
	CAMERAS, #5
	KEYS, #6
	VAMPIRE, #7
	KILL_2, #8
	TONY, #9
	OFFICE, #10
	KILL_3, #11
	GARLIC, #12
	SANDWICH, #13
	PHONE, #14
}

signal update_page(method_index: step)
