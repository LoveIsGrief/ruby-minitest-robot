require "robot"

describe Robot do

	before do
		@robot = Robot.new
	end

	describe "initial state" do

		it "should only allow a valid PLACE" do
			@robot.report.should eq "-1,-1,NORTH"

			@robot.move
			@robot.report.should eq "-1,-1,NORTH"

			@robot.place(0,1, "NORTH").should be_true
			@robot.report.should eq "0,1,NORTH"
		end

		it "should have a 5x5 board" do
			expect(@robot.board.height).to eq 5
			expect(@robot.board.width).to eq 5
		end

	end

	describe "placement" do

		it "should ignore offboard placements" do
			direction = "WEST"

			# Off the west end
			@robot.place(-1, 0, direction).should be_false

			# Off the east end
			@robot.place(5, 0, direction).should be_false

			# Off the north end
			@robot.place(0, 5, direction).should be_false

			# Off the south end
			@robot.place(0,  -1, direction).should be_false

			@robot.report.should eq "-1,-1,NORTH"
		end

		it "should ignore invalid directions" do

			@robot.place(0,0, "HERP").should be_false

			@robot.report.should eq "-1,-1,NORTH"
		end
	end

	describe "movement" do

		describe "(ignored invalid)" do

			it "should not move off the west border" do
				@robot.place 0,0, "WEST"
				@robot.move
				@robot.report.should eq "0,0,WEST"
			end

			it "should not move off the east border" do
				@robot.place 4,0, "EAST"
				@robot.move
				@robot.report.should eq "4,0,EAST"
			end

			it "should not move off the north border" do
				@robot.place 0,4, "NORTH"
				@robot.move
				@robot.report.should eq "0,4,NORTH"
			end

			it "should not move off the south border" do
				@robot.place 0,0, "SOUTH"
				@robot.move
				@robot.report.should eq "0,0,SOUTH"
			end
		end

		describe "(valid)" do

			before do
				@robot.place 1,1,"NORTH"
			end

			it "should move WEST" do
				@robot.left
				@robot.move
				@robot.report.should eq "0,1,WEST"
			end

			it "should move EAST" do
				@robot.right
				@robot.move
				@robot.report.should eq "2,1,EAST"
			end

			it "should move NORTH" do
				@robot.move
				@robot.report.should eq "1,2,NORTH"
			end

			it "should move SOUTH" do
				@robot.left.left
				@robot.move
				@robot.report.should eq "1,0,SOUTH"
			end
		end

	end

	describe "rotation" do

		before do
			@robot.place 0,0, "NORTH"
		end

		it "should rotate clockwise" do
			@robot.direction.name.should eq "NORTH"

			@robot.right
			@robot.direction.name.should eq "EAST"

			@robot.right
			@robot.direction.name.should eq "SOUTH"

			@robot.right
			@robot.direction.name.should eq "WEST"

			@robot.right
			@robot.direction.name.should eq "NORTH"
		end

		it "should rotate anti-clockwise" do
			@robot.direction.name.should eq "NORTH"

			@robot.left
			@robot.direction.name.should eq "WEST"

			@robot.left
			@robot.direction.name.should eq "SOUTH"

			@robot.left
			@robot.direction.name.should eq "EAST"

			@robot.left
			@robot.direction.name.should eq "NORTH"
		end
	end

	describe "input" do

		it "should move north" do
			@robot.handle_input "PLACE 0,0,NORTH"
			@robot.handle_input "MOVE"
			@robot.handle_input("REPORT").should eq "0,1,NORTH"
		end

		it "should rotate and face WEST" do
			@robot.handle_input "PLACE 0,0,NORTH"
			@robot.handle_input "LEFT"
			@robot.handle_input("REPORT").should eq "0,0,WEST"
		end

		it "should move and rotate multiple times" do
			@robot.handle_input "PLACE 1,2,EAST"
			@robot.handle_input "MOVE"
			@robot.handle_input "MOVE"
			@robot.handle_input "LEFT"
			@robot.handle_input "MOVE"
			@robot.handle_input("REPORT").should eq "3,3,NORTH"
		end

		it "should discard invalid input" do
			originalReport = "-1,-1,NORTH"

			@robot.handle_input "NON-VALID COMMAND"
			@robot.handle_input("REPORT").should eq originalReport

			@robot.handle_input "MOVE"
			@robot.handle_input("REPORT").should eq originalReport

			@robot.handle_input "PLACE"
			@robot.handle_input("REPORT").should eq originalReport

			@robot.handle_input "PLACE l,1,NORTH"
			@robot.handle_input("REPORT").should eq originalReport

			@robot.handle_input "PLACE 1,l,NORTH"
			@robot.handle_input("REPORT").should eq originalReport

			@robot.handle_input "PLACE 1,1,HERP"
			@robot.handle_input("REPORT").should eq originalReport

		end

	end
end