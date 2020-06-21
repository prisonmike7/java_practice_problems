class PracticeProblem

    attr_accessor :problem_name, :catagory, :url, :description, :example_case, :index

    @@all = []

    def initialize(problem_name, catagory, url, description, example_case = "", index = nil)
        @problem_name = problem_name[0]
        @catagory = catagory
        @url = url
        @description = description
        @example_case = example_case
        @index = index.to_s
        @@all << self
    end

    # Returns ALL Practice Problem Objects
    def self.all
        @@all
    end
    
    # Returns a practice problem object given the catagory and selected user index
    def self.find_problem_by_catagory_and_index(catagory, index)
        p_result = nil
        @@all.each do |problem| 
            p_cat = problem.catagory
            p_ind = problem.index
            if problem.catagory == catagory && problem.index == index
                p_result = problem
                break
            end
        end
        return p_result
    end

end