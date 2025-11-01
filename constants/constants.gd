extends Node


enum GameLength { SHORT, MEDIUM, LONG }
enum GameState { TITLE, PLAYING, SUCCESS, TIMEUP, FINISHED }
const TILT_SENSITIVITY: float =  400.0
const DEAD_ZONE: float =  1.0
const TRANSITION_DURATION_SECONDS: float = 2.0