###
# @module Resistor::Geonames
module Resistor
    module Geonames
        
        COUNTRIES = "#{File.dirname(__FILE__)}/../db/countryInfo.txt"
        REGIONS = "#{File.dirname(__FILE__)}/../db/admin1Codes.txt"
        CITIES_1000 = "#{File.dirname(__FILE__)}/../db/cities1000.txt"
        CITIES_5000 = "#{File.dirname(__FILE__)}/../db/cities5000.txt"
        CITIES_15000 = "#{File.dirname(__FILE__)}/../db/cities15000.txt"
        
        @@countries = {}
        @@regions = {}
        
        ##
        # import
        #
        def self.import
            puts "Resistor::Geonames.import"                        
            if (FileTest.exist?(COUNTRIES))        
                self.import_countries
            end  
            
            if (FileTest.exist?(REGIONS))        
                self.import_regions
            end 
            
            if (FileTest.exist?(CITIES_1000))        
                self.import_cities1000
            end  
            
            if (FileTest.exist?(CITIES_5000))        
                self.import_cities5000
            end 
            
            if (FileTest.exist?(CITIES_15000))        
                self.import_cities15000
            end 
            
            
        end        
        
        ##
        # import_countries
        #
        def self.import_countries
            
            f = File.open(COUNTRIES)
            
            # first get rid of comments and headers
            line = f.gets
            while (line.match(/^#/) or line.match(/^iso/))
                line = f.gets                
            end
            
            # the rest is data
            while (row = f.gets)
                row = row.split(/\t/)
                puts row[0]
                @@countries[row[0]] = row
            end
        end
        
        ##
        # import_regions
        #
        def self.import_regions
            f = File.open(REGIONS)
            while (row = f.gets)
                row = row.split(/\t/)
                
                puts row.to_s
            end
            
        end
        
        ##
        # import_cities1000
        #
        def self.import_cities1000
            
        end
        
        ##
        # import_cities5000
        #
        def self.import_cities5000
            
        end
        
        ##
        # import_cities15000
        #
        def self.import_cities15000
            
        end
    end
end
