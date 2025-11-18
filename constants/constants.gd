extends Node


enum GameState {
  TITLE, # Only when the title screen is being shown.
  COUNTING, # During the countdown before play begins.
  PLAYING, # During normal game play.
  SUCCESS, # When getting a ball onto a valid target.
  TIMEUP, # When time runs out and game play must stop.
  PERFECT, # When all levels are complete and game play must stop.
  FINISHED, # When showing the score after finishing the game.
}