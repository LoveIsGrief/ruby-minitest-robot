# Represents the board the robot will be restricted to
class Board
	def initialize(width,height)
		@width = width
		@height = height
	end

	attr_reader :width, :height

end