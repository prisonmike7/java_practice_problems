require_relative "./scraper"
require_relative "./practice_problem"
require_relative "./catagory"
require "colorize"

class JavaPracticeProblems::CLI
    
    attr_accessor :main_url, :user_input, :cli_state, :cli_catagories, :cli_problems, :temp_input, :cli_catagory_temp

    MAIN_URL = 'https://codingbat.com/java'

    @@muted="\e[1;31m"
    @@grn="\e[1;32m"
    @@blu="\e[1;34m"
    @@mag="\e[1;35m"
    @@cyn="\e[1;36m"
    @@white="\e[0m"

    def initialize
        @main_url = MAIN_URL
        @user_input = ""
        @cli_state = "start_menu"
        @cli_catagories = []
        @cli_problems = []
    end

    # The master executable function for the application
    def main
        welcome_message
        create_all_objects
        until @user_input == "quit"
            case @cli_state
            when "start_menu"
                @cli_state = "catagory_menu"
            when "catagory_menu"
                display_catagories
                puts "\n#{@@mag}>>> Enter the number of the catagory you wish to choose."
                puts ">>> Enter 'quit' to leave the program.#{@@white}\n"
                @cli_catagory_temp = get_user_input
                if valid_input(@cli_catagory_temp, @cli_catagories)
                    @user_input = @cli_catagory_temp
                    if @user_input == "quit"
                        @cli_state = "goodbye_menu"
                    else
                        @cli_state = "problem_menu"
                    end
                else
                    puts "\n#{@@white}.......... Invalid Command :( ..........\n"
                    next
                end
            when "problem_menu"
                display_catagory_problems
                puts "\n#{@@mag}>>> Enter the number of the practice problem you wish to choose."
                puts ">>> Enter 'main' to return to the main catagory menu."
                puts ">>> Enter 'quit' to leave the program.#{@@white}\n"
                new_input = get_user_input
                if valid_input(new_input, @cli_problems)
                    @user_input = new_input
                    if @user_input == "quit"
                        @cli_state = "goodbye_menu"
                    elsif @user_input == "main"
                        @cli_state = "catagory_menu"
                    else
                        @cli_state = "problem_info"
                    end
                else 
                    next
                end
            when "problem_info"
                display_practice_problem_info
                puts "\n#{@@mag}>>> Enter 'back' to return to the selected catagory list"
                puts ">>> Enter 'main' to return to the main catagory menu"
                puts ">>> Enter 'quit' to leave the program#{@@white}"
                new_temp = get_user_input
                if valid_input(new_temp, @cli_problems)
                    @user_input = new_temp
                    if @user_input == "quit"
                        @cli_state = "goodbye_menu"
                    elsif @user_input == "main"
                        @cli_state = "start_menu"
                    elsif @user_input == "back"
                        @user_input = @cli_catagory_temp
                        @cli_state = "problem_menu"
                    # else
                    #     @cli_state = "goodbye_menu"
                    end
                else 
                    next
                end
            when "goodbye_menu"
                goodbye_message
                break
            end
        end
    end
    
    # Prints out all the Catagories
    def display_catagories
        # c_array = @all_catagories.each {|catagory| catagory["name"]}
        puts "\n#{@@cyn}Java Catagories:#{@@grn}"
        @cli_catagories = Catagory.all
        @cli_catagories.each_with_index do |catagory, index|
            puts "#{index + 1}. #{catagory.name}"
        end
    end
    
    # Prints out all practice problems in the selected catagory
    def display_catagory_problems
        current_catagory = Catagory.find_catagory_by_index(@user_input)
        @cli_problems = []
        puts "\n#{@@cyn}Java #{current_catagory.name} Practice Problems:#{@@grn}"
        PracticeProblem.all.each do |problem|
            if problem.catagory == current_catagory.name
                @cli_problems << problem
            end
        end
        @cli_problems.each do |problem|
            puts "#{problem.index}. #{problem.problem_name}"
        end
    end
    
    # Prints out information on the selected practice problem
    def display_practice_problem_info
        @cli_practice_problem = @cli_problems[@user_input.to_i - 1]
        puts "\n#{@@cyn}Coding Challenge: #{@@grn}#{@cli_practice_problem.problem_name} (#{@cli_practice_problem.catagory})#{@@cyn}"
        puts "\n#{@@cyn}Description:#{@@grn}\n#{@cli_practice_problem.description}"         
        puts "\n#{@@cyn}Example Case:#{@@grn}#{@cli_practice_problem.example_case}"  
    end
    
    # Creates ALL Application Objects
    def create_all_objects
        create_catagory_objects(@main_url)
        create_practice_problems_objects(Catagory.all)
        puts "#{@@blu}......... Catagories = #{Catagory.all.count} / Problems = #{PracticeProblem.all.count} ...........#{@@grn}"
    end
    
    # Creates ALL Catgory Objects
    def create_catagory_objects(index_url)
        catagory_url_array = Scraper.scrape_catagory_names_and_urls(index_url)
        catagory_url_array.each_with_index do |catagory, index|
            catagory_string = catagory.keys.join
            catagory_value = catagory.values.join
            catagory_index = index + 1
            Catagory.new(catagory_string, catagory_value, catagory_index)
        end
    end
    
    # Creates ALL Practice Problem Objects 
    def create_practice_problems_objects(catagory_objs)
        catagory_objs.each do |catagory|
            prob_name_and_url = Scraper.scrape_problem_names_and_urls(catagory.url)
            prob_name_and_url.each_with_index do |prob, index|
                problem_name = prob.keys.join
                problem_url = prob.values.join
                problem_hash = Scraper.scrape_problem_page(problem_name, problem_url)
                # puts problem_hash
                p_name = problem_hash["problem_name"]
                p_catagory = problem_hash["catagory"]
                p_url = problem_hash["url"]
                p_description = problem_hash["description"]
                p_example_case = problem_hash["example_case"]
                p_index = (index + 1)
                
                p_test = PracticeProblem.new(p_name, p_catagory, p_url, p_description, p_example_case, p_index)
                
            end
        end
    end

    # Asks for user to enter a command and returns the user input
    def get_user_input
        print "\n#{@@white}Enter Command Here >>> "
        gets.chomp.downcase
    end
    
    # Validates user input
    def valid_input(input, data)
        input.to_i <= data.length && input.to_i > 0 || input == "quit" || input == "main" || input == "back"
    end
    
    # Prints a welcome message to the terminal
    def welcome_message
        puts "\n#{@@cyn}>>>> Welcome to a Java Practice Problem Reference <<<<\n"
        puts "\n#{@@blu}................ Loading Catagories .................."
    end
    
    # Prints a goodbye message to the terminal
    def goodbye_message
        puts "#{@@cyn}>>>>>>>>>>>>>> Thanks for stoping by :) <<<<<<<<<<<<<<" # #{@@white}
        puts ">>>>>>>>>>>>>> Application SUCCESS!!!!! <<<<<<<<<<<<<<\n\n"
    end
    
end
