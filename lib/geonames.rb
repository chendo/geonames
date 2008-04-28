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
        # [0] iso alpha2    
        # [1] iso alpha3  
        # [2] iso numeric 
        # [3] fips code   
        # [4] name    
        # [5] capital 
        # [6] areaInSqKm  
        # [7] population 
        # [8] continent   
        # [9] languages   
        # [10] currency    
        # [11] geonameId
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
                @@countries[row[0]] = row   # <-- hash of countries on iso code, eg: canada = @@countries["CA"]
            end
        end
        
        ##
        # import_regions                        
        # [0] AD.00     <-- info = row[0].split('.') 
        # [1] name
        #
        def self.import_regions
            f = File.open(REGIONS)
            while (row = f.gets)
                row = row.split(/\t/)                
                (country, region_index) = row[0].split('.')
                
                if (!@@countries[country].nil?)
                    puts "Country: #{@@countries[country][4]}, region_index: #{region_index}, city #{row[1]}"
                end
            end
            
        end
                
        ##
        # import_cities1000
        # ---------------------------------------------------------------------------------------
        # [0] geonameid         : integer id of record in geonames database
        # [1] name              : name of geographical point (utf8) varchar(200)
        # [2] asciiname         : name of geographical point in plain ascii characters, varchar(200)
        # [3] alternatenames    : alternatenames, comma separated varchar(4000)
        # [4] latitude          : latitude in decimal degrees (wgs84)
        # [5] longitude         : longitude in decimal degrees (wgs84)
        # [6] feature class     : see http://www.geonames.org/export/codes.html, char(1)
        # [7] feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
        # [8] country code      : ISO-3166 2-letter country code, 2 characters
        # [9] cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
        # [10] admin1 code       : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
        # [11] admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) 
        # [12] admin3 code       : code for third level administrative division, varchar(20)
        # [13] admin4 code       : code for fourth level administrative division, varchar(20)
        # [14] population        : integer 
        # [15] elevation         : in meters, integer
        # [16] gtopo30           : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
        # [17] timezone          : the timezone id (see file timeZone.txt)
        # [18] modification date : date of last modification in yyyy-MM-dd format
        #
        def self.import_cities1000
            
        end
        
        ##
        # import_cities5000
        # ---------------------------------------------------------------------------------------
        # [0] geonameid         : integer id of record in geonames database
        # [1] name              : name of geographical point (utf8) varchar(200)
        # [2] asciiname         : name of geographical point in plain ascii characters, varchar(200)
        # [3] alternatenames    : alternatenames, comma separated varchar(4000)
        # [4] latitude          : latitude in decimal degrees (wgs84)
        # [5] longitude         : longitude in decimal degrees (wgs84)
        # [6] feature class     : see http://www.geonames.org/export/codes.html, char(1)
        # [7] feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
        # [8] country code      : ISO-3166 2-letter country code, 2 characters
        # [9] cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
        # [10] admin1 code       : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
        # [11] admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) 
        # [12] admin3 code       : code for third level administrative division, varchar(20)
        # [13] admin4 code       : code for fourth level administrative division, varchar(20)
        # [14] population        : integer 
        # [15] elevation         : in meters, integer
        # [16] gtopo30           : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
        # [17] timezone          : the timezone id (see file timeZone.txt)
        # [18] modification date : date of last modification in yyyy-MM-dd format
        #
        def self.import_cities5000
            
        end
        
        ##
        # import_cities15000        
        # ---------------------------------------------------------------------------------------
        # [0] geonameid         : integer id of record in geonames database
        # [1] name              : name of geographical point (utf8) varchar(200)
        # [2] asciiname         : name of geographical point in plain ascii characters, varchar(200)
        # [3] alternatenames    : alternatenames, comma separated varchar(4000)
        # [4] latitude          : latitude in decimal degrees (wgs84)
        # [5] longitude         : longitude in decimal degrees (wgs84)
        # [6] feature class     : see http://www.geonames.org/export/codes.html, char(1)
        # [7] feature code      : see http://www.geonames.org/export/codes.html, varchar(10)
        # [8] country code      : ISO-3166 2-letter country code, 2 characters
        # [9] cc2               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
        # [10] admin1 code       : fipscode (subject to change to iso code), isocode for the us and ch, see file admin1Codes.txt for display names of this code; varchar(20)
        # [11] admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) 
        # [12] admin3 code       : code for third level administrative division, varchar(20)
        # [13] admin4 code       : code for fourth level administrative division, varchar(20)
        # [14] population        : integer 
        # [15] elevation         : in meters, integer
        # [16] gtopo30           : average elevation of 30'x30' (ca 900mx900m) area in meters, integer
        # [17] timezone          : the timezone id (see file timeZone.txt)
        # [18] modification date : date of last modification in yyyy-MM-dd format
        #
        def self.import_cities15000
            
        end
    end
end
