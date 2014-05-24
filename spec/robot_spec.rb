require "robot"

describe Robot do

	before do
		@robot = Robot.new
	end

	describe "initial state" do


		it "should only allow a valid PLACE" do
			expect { @robot.move }.to be_false
			expect { @robot.left }.to be_false
			expect { @robot.right }.to be_false

			@robot.report.to eq "-1,-1,NORTH"

			@robot.place 0,1, "NORTH"
			@robot.report.to eq "0,1,NORTH"
		end

		it "should have a 5x5 board" do
			@robot.board.height.eq 5
			@robot.board.width.eq 5
		end

	end

	describe "placement" do

		it "should ignore offboard placements" do
			direction = "WEST"

			# Off the west end
			expect { @robot.place(-1, 0, direction) }.to be_false

			# Off the east end
			expect { @robot.place(5, 0, direction) }.to be_false

			# Off the north end
			expect { @robot.place(0, 5, direction) }.to be_false

			# Off the south end
			expect { @robot.place(0,  -1, direction) }.to be_false

			@robot.report.to eq "-1,-1,NORTH"
		end

		it "should ignore invalid directions" do

			expect { @robot.place 0,0, "HERP" }.to be_false

			@robot.report.to eq "-1,-1,NORTH"
		end
	end

	describe "movement" do

		describe "(ignored invalid)" do

			it "should not move off the west border" do
				@robot.place 0,0, "WEST"
				@robot.move
				@report.report.eq "0,0,WEST"
			end

			it "should not move off the east border" do
				@robot.place 4,0, "EAST"
				@robot.move
				@report.report.eq "0,0,EAST"
			end

			it "should not move off the north border" do
				@robot.place 0,4, "NORTH"
				@robot.move
				@report.report.eq "0,0,NORTH"
			end

			it "should not move off the south border" do
				@robot.place 0,0, "SOUTH"
				@robot.move
				@report.report.eq "0,0,SOUTH"
			end
		end

		describe "(valid)" do

			before do
				@robot.place 1,1,"NORTH"
			end

			it "should move WEST" do
				@robot.left
				@robot.move
				@report.report.eq "0,1,WEST"
			end

			it "should move EAST" do
				@robot.right
				@robot.move
				@report.report.eq "2,1,EAST"
			end

			it "should move NORTH" do
				@robot.move
				@report.report.eq "1,2,NORTH"
			end

			it "should not move off the south border" do
				@robot.left.left
				@robot.move
				@report.report.eq "1,0,SOUTH"
			end
		end

	end

	describe "rotation" do

		before do
			@robot.place 0,0, "NORTH"
		end

		it "should rotate clockwise" do
			@robot.direction.current.should eq "NORTH"

			@robot.right
			@robot.direction.current.should eq "EAST"

			@robot.right
			@robot.direction.current.should eq "SOUTH"

			@robot.right
			@robot.direction.current.should eq "WEST"

			@robot.right
			@robot.direction.current.should eq "NORTH"
		end

		it "should rotate anti-clockwise" do
			@robot.direction.current.should eq "NORTH"

			@robot.left
			@robot.direction.current.should eq "WEST"

			@robot.left
			@robot.direction.current.should eq "SOUTH"

			@robot.left
			@robot.direction.current.should eq "EAST"

			@robot.left
			@robot.direction.current.should eq "NORTH"
		end
	end
end