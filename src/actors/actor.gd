extends Node2D
class_name Actor

enum CellTypes {
	Ground
	Actor
	Obstacle
}
export (CellTypes) var type
