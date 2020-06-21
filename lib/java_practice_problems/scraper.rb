require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

    MAIN_URL = 'https://codingbat.com'

    # returns an array of hashes with {catagory names => catagory urls}
    def self.scrape_catagory_names_and_urls(index_url)
        catagory_name_array = []
        main_page = Nokogiri::HTML(open(index_url))

        titles = main_page.css('div.floatleft tr div.summ')
        titles.each do |topic|
            topic_name = topic.css('span.h2').text
            catagory_name_array << {topic_name => "#{index_url}/#{topic_name}"}
        end

        catagory_name_array
    end
    
    # returns an array of hashes with {problem names => problem urls}
    def self.scrape_problem_names_and_urls(catagory_url)
        problem_name_array = []
        main_page = Nokogiri::HTML(open(catagory_url))
        problems_page = main_page.css('div.indent table td a')

        problems_page.each do |problem|
            p_url = "#{MAIN_URL}#{problem.attribute('href').value}"
            problem_name_array << {problem.text => p_url}
        end

        problem_name_array
    end

    # returns an hash with the given problem name, catagory, url, description, and example code
    def self.scrape_problem_page(name, problem_url)
        problem_info_hash = {}
        page = Nokogiri::HTML(open(problem_url))
        problems_page = page.css('div.indent')
        problem_start_index = problems_page.css('td').text.index(name)
        problem_end_index = problems_page.css('td').text.index("Go...Save") - 1

        problem_info_hash["problem_name"] = name,
        problem_info_hash["catagory"] = problems_page.css('a span.h2').text,
        problem_info_hash["url"] = problem_url,
        problem_info_hash["description"] = self.format_description(problems_page.css('p.max2').text),
        problem_info_hash["example_case"] = problems_page.css('td').text[problem_start_index..problem_end_index].gsub(name, "\n#{name}")
        problem_info_hash["index"] = "0"
    
        return problem_info_hash
    end

    def self.format_description(description)
        str_length = description.length
        str_div = str_length / 70
        result = description
        str_div.times do|i|
          result.insert(((i + 1) * 70), "\n")
        end
        return result
    end
    
end