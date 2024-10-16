extends Node3D

@export var cell_size: int = 1  # Taille d'une cellule de la grille
@export var grid_width: int = 10  # Nombre de cellules en largeur
@export var grid_height: int = 10  # Nombre de cellules en hauteur

var grid: Array = []  # Tableau pour stocker les positions de la grille

# Appelée lorsque le noeud entre dans l'arbre de la scène pour la première fois
func _ready():
	if Engine.is_editor_hint():
		generate_grid()

# Générer la grille de coordonnées
func generate_grid():
	if Engine.is_editor_hint():
		grid.clear()  # Vider la grille si elle existe déjà

		for x in range(-grid_width/2, grid_width/2):
			for z in range(-grid_height/2, grid_height/2):
				# Calculer la position de chaque cellule
				var grid_position = Vector3(x * cell_size, 0, z * cell_size)
				grid.append(grid_position)
				print("Coordonnée de la grille : ", grid_position)
			
			

# Appelée chaque frame
func _process(delta):
	pass
