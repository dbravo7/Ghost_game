class Player 
    attr_reader :name

    def initialize(name, game)
        @name = name 
        game.losses(@name)
    end 

    def guess(str, player, game)
        if @name == "Arti"
            puts "Arti's turn"
            game.ai_move(str, @name) 
        end 

        puts "#{str}"
        puts "Enter a single letter #{@name}"
            input = gets.chomp.to_s
        str += input.downcase
        game.valid_play?(str, @name)
    end 
end     
