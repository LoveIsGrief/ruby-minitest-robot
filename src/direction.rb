# Basically a normal vector with a name
class Direction

	def initialize(name, x, y)
		@name = name
		@x = x
		@y = y
	end

	attr_reader :x, :y, :name

	def to_s
		@name
	end

end