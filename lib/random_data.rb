module RandomData
    def self.random_paragraph
        sentences = []
        rand(4..6).times do # a random number of times do
            sentences << random_sentence #some paragraphs have 4 random sentences, others 5/6
        end
        sentences.join(" ") #each sentence is a cell in array, create string
    end

    def self.random_sentence
        strings = []
        rand(3..8).times do
            strings << random_word #creates an array with between 3-8 cells of random words
        end
        sentence = strings.join("") #take each word from each cell and join into a string to make a sentence
        sentence.capitalize << "." #capitalize first letter of sentence and add a . at the end
    end

    def self.random_word
        letters = ("a".."z").to_a #[a,b,c,d,e...]
        letters.shuffle!      #[g,e,h,a,f,...]
        letters[0,rand(3..8)].join #give me letters between 0 and 3-8 and make a string from them
    end

    def self.random_name
        first_name = random_word.capitalize
        last_name = random_word.capitalize
        "#{first_name} #{last_name}" 
    end
    
    def self.random_email
        "#{random_word}@#{random_word}.#{random_word}"
    end
end