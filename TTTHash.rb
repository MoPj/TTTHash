class TTTGame
# Tic Tac Toe Game by Maureen Johnston
# The Tic Tac Toe board is a Hash and the comination of possible wins is an array of board has keys
	attr_accessor :gameEnded
	attr_accessor :turn
	def initialize()
		@board = {"1"=>"1", "4"=>"4", "7"=>"7", 
				  "2"=>"2", "5"=>"5", "8"=>"8",
				  "3"=>"3", "6"=>"6", "9"=>"9"}
		@gameEnded = false
		@turn = 1
		@possibleWins = [
		['1','4','7'],
		['2','5','8'],
		['3','6','9'],

		['1','2','3'],
		['4','5','6'],
		['7','8','9'],

		['1','5','9'],
		['3','5','7']]		
	end

	
 
	def putsSeparator
		puts "*******************************************************"
	end
	def putsTurnSeparator
		puts "________________________________________________________"
	end
	def drawBoard(playername, token)
		puts ""
		puts "#{@board["1"]}|#{@board["2"]}|#{@board["3"]}"
		puts "-----"
		puts "#{@board["4"]}|#{@board["5"]}|#{@board["6"]}"
		puts "-----"
		puts "#{@board["7"]}|#{@board["8"]}|#{@board["9"]}"
		puts ""	
	end
  # check to see if position is a valid entry from user.  It must be an integer value,
  # between 1-9 inclusive, and it must be an open position that has not yet been filled
	def validatePos(token)
	pos = 0
		until pos != 0
			begin 
			puts ("Enter board position")
				pos = Integer(gets.chomp)
			rescue 
				pos = 0
				puts "Please try again."
			else
				if !(pos.between?(1, 9))
					pos = 0
					puts("board position must be between 1 and 9, inclusive\nPlease try again.")	
				else 
					if @board[pos.to_s] == pos.to_s
						@board[pos.to_s] = token
					else
						pos = 0
						puts "position already filled"
					end				
				end
			end
		end
	end
# get users token position, validate it, draw the board, and check to see if the move created a win or a draw	
	def userPTurn(name, token)
		puts "Your turn. To make a move #{name}.  You are playing token: #{token}:"
		validatePos(token)
		drawBoard(name, token)
		checkWin(name, token)
		unless @gameEnded 
			checkForDrawAndCnt	
		end
	end
# find the computers next move	
	def computerP(name, token)
		puts "The Computer will now make a more.  Playing token: #{token}:"	
		# get all empty slots 		
		findEmptyPostion(name, token)
		drawBoard(name, token)
	end
# go through the board positions to check if there are any empty spots 
#   if no more slots are available it would be a draw sice there was not a win found
	def checkForDrawAndCnt
		drawCnt = 0
		saveprevkey = 0
		@board.each {|key, emptyBoardPos| drawCnt +=1 if emptyBoardPos.to_s == "X" || emptyBoardPos.to_s == "O"}
			if drawCnt == 9
				puts "This game is over due to a DRAW!"
				@gameEnded = true
			end
			if drawCnt == 8  then saveprevkey = key end	
		# this is going to be used to see if there is only one empty position left on the board
		return drawCnt, saveprevkey

	end
	
	def findEmptyPostion(name, token)
		# first check to see there is only one position left empty on the board, 
		#  (chedkForDraw will return 8 and the board key to the last empty position)
		# if this position is not a win then check to see if this empty position is a draw
		# call this method to check for one last empty slot on the board and save the key of that slot
		if @turn == 1 && @board[5] != getOpponentToken(token)
			@board[5.to_s] = token
		else
			slotAndKeyArr = checkForDrawAndCnt	
			if slotAndKeyArr[0]== 8
				@board[slotAndKeyArr[1].to_s] = token
				# check if this empty position is a win	
				checkWin(name, token)
				unless @gameEnded 
				# call this method again to see if this last empty slot created a draw if not a win
					checkForDrawAndCnt
				end
			end		
			findTwoInRowFlag = true		
			unless @gameEnded 
				# first look through the board for empty slots, store them in an array and see if it's a win for the computer
				emptyPosArray = Array.new	
				boardkey = nil 	
				@board.each {|key, emptyBoardPos| 
					unless emptyBoardPos.to_s == "X" || emptyBoardPos.to_s == "O"
						# store the new empty position in case you need to find a random empty slot
						emptyPosArray << key
						if findTwoInRowFlag != false						
							# first check if this position gives a two row combo with an empty 3rd slot					
							boardkey = findInRow(key.to_s, token)							
							if boardkey != nil 
								# move the new token piece on the board for the computer 
								findTwoInRowFlag = false
								#first check to see if a block is necessary
								# look through the board to block possible opponent wins
								boardkey = findOpponentInRow(key.to_s, token)								
								if boardkey != nil 								
									# move the new token piece on the board for the computer 
									findTwoInRowFlag = false
									#break
								end							
								#break
								end
							# look through the board to block possible opponent wins
							boardkey = findOpponentInRow(key.to_s, token)					
							if boardkey != nil
								# move the new token piece on the board for the computer 
								findTwoInRowFlag = false
							#	break
							end
						end						
					end	
				}
				# if the emptyPos Array is not empty then you found an empty slot so fill a random slot with the Computers token
				if findTwoInRowFlag == true
				# before you choose a random slot make sure it's not where you have a "row" with
				#  an opponents playing token in it
					checkRandomSlots(emptyPosArray, getOpponentToken(token))
					# fill a random slot
					@board[emptyPosArray.sample] = token
				else
					@board[boardkey.to_s] = token
				end
			end	
		end			
	end
	
	def checkRandomSlots(emptyPosArray, token)
	# for each empty position see if you can get a possible win "row" where there is just one of 
	# your player tokens in it, then se
		emptyPosArray.each do |emptyPos|
			boardkey = findOneInRow(emptyPos.to_s, getOpponentToken(token))			
			if boardkey == nil && emptyPosArray.length > 1
				emptyPosArray.delete(emptyPos)
			end
		end
		#emptyPosArray.each do |emptyPos|
		#	boardkey = findOneInRow(emptyPos.to_s, token)			
		#	if boardkey != nil
		#		@board[boardkey]
		#	end	
		#end			
		# now get a random empty position that's left in the array

		@board[emptyPosArray.sample]
	end
	# look through the multi dimentional array with possible wins
	def findOneInRow(key, token)
		boardkey = nil	
		@possibleWins.each do |possibleWin|
			boardkey = FindPossOneWinInRow(possibleWin, key, token)
				return boardkey
		end	
	end
	# look to see if the board key is in a possible win "row" that has a token match 
	def FindPossOneWinInRow (possibleWin,key, token)
		if possibleWin.include?(key)
		arr = [@board[possibleWin[0]], @board[possibleWin[1]], @board[possibleWin[2]]]
			if arr.include?(token) && arr.include?(getOpponentToken(token))
				return nil
			else
				return key
			end
		end
	end

	def getOpponentToken(token)
		return  token == "X" ? "O" : "X"
	end
	# get the opponent token to find 
	def findOpponentInRow(key, token)
		return findInRow(key, getOpponentToken(token))
	end
	# go through the possible wins array and find the empty board position with in rows and then check 
	#  if there is another matching token in the row
	def findInRow(key, token)
		@possibleWins.each do |possibleWin|
			boardkey = FindPossWinInRow(possibleWin, key, token)
				unless boardkey == nil	
					return boardkey	
				end
		end	
		return nil			
	end
	# look to see if the board key is in a possible win "row" that has a double token match 
	def FindPossWinInRow (possibleWin,key, token)
		if possibleWin.include?(key)
			arr = [@board[possibleWin[0]], @board[possibleWin[1]], @board[possibleWin[2]]]
			if (arr[0] == token && arr[1] == token) || (arr[1] == token && arr[2] == token) || (arr[0] == token && arr[2] == token)
			return key
			end
		end
		return nil
	end

	#check to see if you have a win
	def checkWin(name, token)
		# look to see if the last move was for a win
		@possibleWins.each do |possibleWin|
			if FindWin(possibleWin, token) == 3
				puts "Player #{name} playing token #{token} Wins the Game!"
				@gameEnded = true	
			end
		end
	end
	#  go through the array possibleWins, and see if any of the possible wins defined are on the board
	def FindWin (possibleWin, token)
		cnt = 0
		possibleWin.each do |x|
			if @board[x.to_s] == token
				cnt += 1
			end
		end
		return cnt
	end

end 
class Player
  attr_accessor :name, :token
  def initialize(name, token)
    @name = name
    @token = token
  end
end

puts "Welcome to TicTacToe!"

puts "What is your name?"
playername = gets.chomp
# ask the user if they choose to be X or O
puts "Hi #{playername}!"
tokenchoice = " "
while tokenchoice != "X" && tokenchoice != "O"
	puts "Please enter token X or O (X gets the first move):"
	tokenchoice = gets.chomp.capitalize
end
userP = Player.new(playername, tokenchoice)
computerP = Player.new("Computer", tokenchoice == "X" ? "O" : "X")

game = TTTGame.new
game.putsSeparator
puts "Game started."
game.drawBoard(userP.name, userP.token)
while(!game.gameEnded)
	game.userPTurn(userP.name, userP.token)
	
 #   game.checkBoard
    break if game.gameEnded	
    puts "Game is still in play"
	game.putsTurnSeparator
	game.computerP(computerP.name, computerP.token)
	game.turn += 1
end
# verify that the name is entered - to be implemented later
class NoNameError<Exception
	def to_str
		"No Name was given, Please enter your name"
	end
end