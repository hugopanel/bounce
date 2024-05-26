extends Node3D

signal PA_scored
signal PB_scored

var zoneA_team = -1
var zoneB_team = -1

func _ready():
    # define zones' teams
    if (randi() % 2) == 0:
        zoneA_team = 0
        zoneB_team = 1
    else:
        zoneA_team = 1
        zoneB_team = 0

    # set zones' colors
    if (zoneA_team == 1):
        $ZoneA.get_node("Light").light_color = Color(1, 0, 0, 1)
        $ZoneB.get_node("Light").light_color = Color(0, 1, 0, 1)
    else:
        $ZoneA.get_node("Light").light_color = Color(0, 1, 0, 1)
        $ZoneB.get_node("Light").light_color = Color(1, 0, 0, 1)

    $ZoneA.body_entered.connect(_on_body_entered_A)
    $ZoneB.body_entered.connect(_on_body_entered_B)

func _on_body_entered_A(body: RigidBody3D):
    if (body.name == "Puck"):
        if (zoneA_team == 1):
            # print("Player A scored!")
            emit_signal("PA_scored")
        else:
            # print("Player B scored!")
            emit_signal("PB_scored")

func _on_body_entered_B(body: RigidBody3D):
    if (body.name == "Puck"):
        if (zoneB_team == 1):
            # print("Player A scored!")
            emit_signal("PA_scored")
        else:
            # print("Player B scored!")
            emit_signal("PB_scored")
