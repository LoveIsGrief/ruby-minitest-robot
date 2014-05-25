require "direction"
require "board"

class Robot

	def initialize
		@directions = [
			Direction.new("NORTH", 0, 1),
			Direction.new("EAST", 1, 0),
			Direction.new("SOUTH", 0, -1),
			Direction.new("WEST", -1, 0)
		]
		@x = -1
		@y = -1
		@board = Board.new 5,5
	end

	##############################
	# Attributes

	attr_reader :x, :y, :board

	def direction
		@directions.first
	end

	def placed?
		@x != -1 and @y != -1
	end


	##############################
	# Methods


	def place(x,y,direction)
		return false if not @board.on?(x,y) or not self.rotate_to(direction.upcase)
		@x = x
		@y = y

		return true
	end

	def report
		theReport = "#{@x},#{@y},#{self.direction}"
	end

	def move
		newX = self.direction.x + @x
		newY = self.direction.y + @y
		if self.placed? and  @board.on?(newX, newY)
			@x = newX
			@y = newY
		end
		self
	end

	# Attempts to rotate to a given direction
	# Returns: boolean
	def rotate_to(direction)
		i = @directions.find_index { |aDirection|
			aDirection.name == direction
		}
		if not i
			return false
		else
			@directions.rotate!(i)
			return true
		end
	end

	# Rotates the robot 90° to the right
	# Ignored if robot is not on the board
	def right
		@directions.rotate! if self.placed?
		self
	end

	# Rotates the robot 90° to the left
	# Ignored if robot is not on the board
	def left
		@directions.rotate! -1 if self.placed?
		self
	end

	###################################
	# Input handling

	# Returns the output of the given command
	def handle_input(commandAndArgs)
		command, args = commandAndArgs.split " "

		case command
		when "PLACE"
			# Validations
			return if not args

			x,y,direction = args.split(",").each { |e| e.strip! }

			begin
				x = Integer(x)
				y = Integer(y)
				self.place x,y,direction
			rescue ArgumentError => e

			end
		when "MOVE"
			self.move
		when "LEFT"
			self.left
		when "RIGHT"
			self.right
		when "REPORT"
			self.report

		end

	end

end