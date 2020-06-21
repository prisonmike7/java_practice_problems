require_relative "./practice_problem"

class Catagory

    attr_accessor :name, :url, :practice_problems, :index

    @@all = []

    def initialize(name, url, index)
        @name = name
        @url = url
        @index = index.to_s
        @practice_problems = []
        @@all << self
    end

    # Returns ALL Catagory Objects
    def self.all
        @@all
    end

    # Returns a catagory object given an index specified by the user
    def self.find_catagory_by_index(index)
        result = nil
        @@all.each do |catagory|
            if catagory.index == index
                result = catagory
                break
            end
        end
        return result
    end
    
    # Returns an array of all the problems in a catagory given an index
    def self.find_catagory_problems_by_index(index)
        result = []
        c_name = self.find_catagory_by_index(index)
        PracticeProblem.all.each do |problem|
            if problem.catagory == c_name
                result << problem
            end
        end
        return result
    end

end