# Represents the board the robot will be restricted to
class Board
	def initialize(width,height)
		@width = width
		@height = height
	end

	attr_reader :width, :height

	# Check if x and y are on the board
	def on?(x,y)
		return false if x >= @width or y >= @height or x < 0 or y < 0
		true
	end

end