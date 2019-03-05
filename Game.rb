require "byebug"
require_relative "./player.rb"

class Game

    attr_reader :dictionary, :fragment
    attr_accessor :current_player_indice, :players, :losses 

    def initialize(n) 
         
        @game_instance = self
        @losses = Hash.new(0)
        @players =[]
        n.times {@players << Player.new(gets.chomp, @game_instance)}
         @players += [Player.new("Arti", @game_instance)]
        @fragment = ""
        @current_player_indice = 0
        @ticker = 0 
        dictionary             
        play_round
    end

    def losses(name)
        @losses[name] = 0
        @losses 
    end 

    def dictionary
        @dictionary =  Hash.new
        IO.readlines("./dictionary.txt").each {|line| @dictionary[line.chomp("\n")] = nil}
        @dictionary
    end

    def play_round
        take_turn(@players[@current_player_indice])
    end

    def current_player
        @players[@current_player_indice]
    end

    def previous_player
        @players[@current_player_indice - 1]
    end

    def next_player!
        @current_player_indice = (@current_player_indice + 1) % @players.length
        take_turn(@players[@current_player_indice])
    end

    def take_turn(player) 
         
        player.guess(@fragment, player, @game_instance)
    end

    def valid_play?(string, name)
    
        if (string.length > @fragment.length + 1 || string.length == @fragment.length) && name != "Arti"
            puts "Please input one letter on your turn with no spaces"
            take_turn(current_player)
        end 

        if @dictionary.has_key?(string)
            puts "#{string.capitalize} is a word. You lose #{name}!"
            you_lose(name)
        end 

        @dictionary.any? do |word, v| 
            if word.start_with?(string) 
                @fragment = string 
                puts "Word string - (#{string})"
                next_player!
            end  
        end 
        puts "Please either choose a letter a through z or one that can potentially form a word"
        take_turn(current_player)
    end 

    def you_lose(name)
        @losses[name] += 1

        @losses.each do |k, v|
            if @losses[k] == 5
                puts "#{name} you are a Ghost"
                @losses.delete(k)
                @players.delete_at(current_player_indice)
            end
        end
        record(@losses)
        game_run
    end

    def record(player_hash)
        ghost = {1=>"G", 2=>"Gh", 3=>"Gho", 4=>"Ghos"}

        player_hash.each do |name, num|
            if num > 0
                puts "#{name} has #{ghost[num]}"
            else 
                puts "#{name} has no letters"
            end 
        end
    end

    def game_run
        @ticker += 1
        if @ticker > 1 && @losses.length == 1
            puts "#{@losses.keys} you win!!"
        else
            @fragment = ""
            next_player!
        end
    end

    def ai_move(string, name)
        moves = @players.length
        alpha = "abcdefghijklmnopqrstuvwxyz"
       
        string_modified = false
        
        @dictionary.any? do |w, v|
            if w.start_with?(string) && (w.length - string.length) == moves
                string += w[string.length]
                string_modified = true 
            elsif w.start_with?(string) && (w.length - string.length) == moves + 2
                string += w[string.length]
                string_modified = true 
            end 
        end 

            if string_modified == false 
                string += alpha[rand(0..25)]
            end
        valid_play?(string, name)
    end
end 


if $PROGRAM_NAME == __FILE__
		Game.new
	end
